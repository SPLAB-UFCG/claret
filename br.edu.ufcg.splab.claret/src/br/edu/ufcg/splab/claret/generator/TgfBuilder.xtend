/**
 * Copyright 2018 Dalton Nicodemos Jorge
 * 
 * Licensed under the Apache License, Version 2.0 (the "License"); 
 * you may not use this file except in compliance with the License. 
 * You may obtain a copy of the License at 
 * 
 * http://www.apache.org/licenses/LICENSE-2.0 
 * 
 * Unless required by applicable law or agreed to in writing, software 
 * distributed under the License is distributed on an "AS IS" BASIS, 
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
 * See the License for the specific language governing permissions and 
 * limitations under the License. 
 * 
 * @author Dalton Nicodemos Jorge <daltonjorge@copi.ufcg.edu.br>
 */

package br.edu.ufcg.splab.claret.generator

import br.edu.ufcg.splab.claret.claret.Af
import br.edu.ufcg.splab.claret.claret.Alternative
import br.edu.ufcg.splab.claret.claret.AlternativeAction
import br.edu.ufcg.splab.claret.claret.AlternativeResponse
import br.edu.ufcg.splab.claret.claret.BasicAction
import br.edu.ufcg.splab.claret.claret.BasicResponse
import br.edu.ufcg.splab.claret.claret.Bs
import br.edu.ufcg.splab.claret.claret.Ef
import br.edu.ufcg.splab.claret.claret.Exception
import br.edu.ufcg.splab.claret.claret.ExceptionAction
import br.edu.ufcg.splab.claret.claret.ExceptionResponse
import br.edu.ufcg.splab.claret.claret.PostCondition
import br.edu.ufcg.splab.claret.claret.Precondition
import br.edu.ufcg.splab.claret.claret.Usecase
import br.edu.ufcg.splab.claret.claret.Afs

class TgfBuilder {
    MyGraph g = new MyGraph()

    def MyGraph parser(Usecase usecase) {
        // Pre-condition Rule
    	g.initialNode = g.newVertex
        var next = g.addEdge(g.initialNode, g.newVertex, 'PC', getDescription(usecase.preCondition), getAnnotationType(usecase.preCondition))

        // Chainning sequential basic steps...
        next = usecase.basic.steps.fold(next)[ n, s | g.addEdge(n, g.newVertex, 'BS' + getStepId(s), getDescription(s), getAnnotationType(s)) ]

        // Post-condition Rule
        g.finalNode = g.newVertex
        val fim_po = g.addEdge( next, g.finalNode, 'PO', getDescription(usecase.postCondition), getAnnotationType(usecase.postCondition))

        // Alternative and Exception Rules
        usecase.basic.steps.forEach[ step | if (getSkip(step) !== null) applyRules('BS', step.stepId, getSkip(step), usecase, fim_po) ]

        usecase.basic.steps.filter[it instanceof BasicAction].forEach[ step |
          (step as BasicAction).skip?.afList?.forEach[ afId |
            val af = usecase.flows.filter[it instanceof Alternative].findFirst[(it as Alternative).id == afId] as Alternative
            if(af.steps.length > 1) {
              af.steps.filter[it instanceof AlternativeResponse && (it as AlternativeResponse).skip instanceof Ef].forEach [ ar|
                val stepWithSkip = 'BS' + (step as BasicAction).id + '_AF'+af.id
                val from = g.from(stepWithSkip+'_'+(ar as AlternativeResponse).id)
                (ar as AlternativeResponse).skip?.efList?.forEach[ efId |
                  val ef = usecase.flows.filter[it instanceof Exception].findFirst[(it as Exception).id == efId] as Exception
                  if(ef !== null && ef.steps.length == 1) {
                    val first = ef.steps.head as ExceptionResponse
                    val toVertex = if(first.skip !== null && first.skip instanceof Afs) g.from(stepWithSkip + '_' + (first.skip as Afs).step) else fim_po
                    g.addEdge(from, toVertex, stepWithSkip+'_'+(ar as AlternativeResponse).id + '_EF' + efId +'_1', getDescription(first), getAnnotationType(first))
                  } else if(ef !== null && ef.steps.length > 1){
                    var altNext = g.addEdge(from, g.newVertex, stepWithSkip+'_'+(ar as AlternativeResponse).id + '_EF' + efId +'_1', (ef.steps.head as ExceptionResponse).action,'[e]')
                    val middle = ef.steps.tail.toList
                    middle.remove(ef.steps.tail.last)
                    // Chainning sequential steps...
                    altNext = middle.fold(altNext)[ n, s | g.addEdge(n, g.newVertex, stepWithSkip+'_'+(ar as AlternativeResponse).id + '_EF' + efId + '_' + getStepId(s), getDescription(s), getAnnotationType(s)) ]
                    val lastStep = ef.steps.tail.last
                    val toVertex = if(lastStep instanceof ExceptionResponse && (lastStep as ExceptionResponse).skip !== null) {
                      val label = stepWithSkip + '_' + ((lastStep as ExceptionResponse).skip as Afs).step
                      g.from(label)
                    } else fim_po
                    g.addEdge(altNext, toVertex, stepWithSkip+'_'+(ar as AlternativeResponse).id + '_EF' + efId + '_' + getStepId(lastStep), getDescription(lastStep), getAnnotationType(lastStep))
                  }
                ]

              ]
            }
          ]
        ]
        return g
    }

    def dispatch applyRules(String parentFlow, String parentStepId, Af afSkip, Usecase usecase, Integer fim_po) {
      afSkip?.afList?.forEach[ afId |
        val flow = usecase.flows.filter[it instanceof Alternative].findFirst[(it as Alternative).id == afId] as Alternative
        if(flow !== null) {
          val flowLabel = parentFlow + parentStepId + '_AF' + flow.id
          val first = flow.steps.head as AlternativeAction
          if(flow.steps.length == 1) {
            val toVertex = if(first.skip !== null && first.skip instanceof Bs) g.from('BS' + (first.skip as Bs).id) else fim_po
            g.addEdge(g.from(parentFlow + parentStepId), toVertex, flowLabel + '_' + first.id, getDescription(first), getAnnotationType(first))
          } else {
            var altNext = g.addEdge(g.from(parentFlow + parentStepId), g.newVertex, flowLabel + '_' + first.id, getDescription(first), getAnnotationType(first))
            val middle = flow.steps.tail.toList
            middle.remove(flow.steps.tail.last)
            // Chainning sequential steps...
            altNext = middle.fold(altNext)[ n, s | g.addEdge(n, g.newVertex, flowLabel + '_' + getStepId(s), getDescription(s), getAnnotationType(s)) ]
            val lastStep = flow.steps.tail.last
            val toVertex = if(lastStep instanceof AlternativeAction) g.from('BS' + lastStep.skip.id) else fim_po
            g.addEdge(altNext, toVertex, flowLabel + '_' + getStepId(lastStep), getDescription(lastStep), getAnnotationType(lastStep))
          }
        }
      ]
    }

    def dispatch applyRules(String parentFlow, String parentStepId, Ef efSkip, Usecase usecase, Integer fim_po) {
      efSkip?.efList?.forEach[ efId |
        val flow = usecase.flows.filter[it instanceof Exception].findFirst[(it as Exception).id == efId] as Exception
        if(flow !== null) {
          val flowLabel = parentFlow + parentStepId + '_EF' + flow.id
          val first = flow.steps.head as ExceptionResponse
          if(flow.steps.length == 1) {
            val toVertex = if(first.skip !== null && first.skip instanceof Bs) g.from('BS' + (first.skip as Bs).id) else fim_po
            g.addEdge(g.from(parentFlow + parentStepId), toVertex, flowLabel + '_' + first.id, getDescription(first), getAnnotationType(first))
          } else {
            var altNext = g.addEdge(g.from(parentFlow + parentStepId), g.newVertex, flowLabel + '_' + first.id, getDescription(first), getAnnotationType(first))
            val middle = flow.steps.tail.toList
            middle.remove(flow.steps.tail.last)
            // Chainning sequential steps...
            altNext = middle.fold(altNext)[ n, s | g.addEdge(n, g.newVertex, flowLabel + '_' + getStepId(s), getDescription(s), getAnnotationType(s)) ]
            val lastStep = flow.steps.tail.last
            val toVertex = if(lastStep instanceof ExceptionResponse && (lastStep as ExceptionResponse).skip instanceof Bs) g.from('BS' + ((lastStep as ExceptionResponse).skip as Bs).id) else fim_po
            g.addEdge(altNext, toVertex, flowLabel + '_' + getStepId(lastStep), getDescription(lastStep), getAnnotationType(lastStep))
          }
        }
      ]
    }

    def dispatch getDescription(BasicAction type) { type.actor.description + ' ' + type.action }
    def dispatch getDescription(BasicResponse type) { 'system ' + type.action }
    def dispatch getDescription(AlternativeAction type) { type.actor.description + ' ' + type.action }
    def dispatch getDescription(AlternativeResponse type) { 'system ' + type.action }
    def dispatch getDescription(ExceptionAction type) { type.actor.description + ' ' + type.action }
    def dispatch getDescription(ExceptionResponse type) { 'system ' + type.action }
    def dispatch getDescription(Precondition type) { type.preConditionList.join('. ') }
    def dispatch getDescription(PostCondition type) { type.postConditionList.join('. ') }

    def dispatch getStepId(BasicAction type) { type.id.toString() }
    def dispatch getStepId(BasicResponse type) { type.id.toString() }
    def dispatch getStepId(AlternativeAction type) { type.id.toString() }
    def dispatch getStepId(AlternativeResponse type) { type.id.toString() }
    def dispatch getStepId(ExceptionAction type) { type.id.toString() }
    def dispatch getStepId(ExceptionResponse type) { type.id.toString() }

    def dispatch getAnnotationType(BasicAction type) { '[s]' }
    def dispatch getAnnotationType(BasicResponse type) { '[e]' }
    def dispatch getAnnotationType(AlternativeAction type) { '[s]' }
    def dispatch getAnnotationType(AlternativeResponse type) { '[e]' }
    def dispatch getAnnotationType(ExceptionAction type) { '[s]' }
    def dispatch getAnnotationType(ExceptionResponse type) { '[e]' }
    def dispatch getAnnotationType(Precondition type) { '[c]' }
    def dispatch getAnnotationType(PostCondition type) { '[c]' }

    def dispatch getSkip(BasicAction type) { type?.skip }
    def dispatch getSkip(BasicResponse type) { type?.skip }
}