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

import br.edu.ufcg.splab.claret.claret.Usecase

class AnnotatedTgfGenerator {
    def static toText(Usecase usecase) {
        val g = new TgfBuilder().parser(usecase)
        val ag = new MyGraph()

        g.vertices.forEach[ag.newVertex()]

        g.edgesList.forEach[e |
          val nextVertice = ag.newVertexId()
          ag.addVertex(nextVertice)
          val annotatedDescription = switch (e.annotation) {
            case '[e]': 'expected_results'
            case '[s]': 'steps'
            case '[c]': 'conditions'
            default: ''
          }
          ag.addEdge(e.one, nextVertice, nextVertice.toString, annotatedDescription, '')
          ag.addEdge(nextVertice, e.two, e.id, e.description, '')
        ]

        return '''
            «FOR v : ag.vertices »«v» «v»«"\n"»«ENDFOR»
            #
            «FOR e : ag.getEdgesList »«e.one» «e.two» «e.description.replaceAll("\\r\\n\\s\\t*|\\r\\s\\t*|\\n\\s\\t*", " ")»«"\n"»«ENDFOR»
        '''
    }

}