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

package br.edu.ufcg.splab.claret.validation

import br.edu.ufcg.splab.claret.claret.Afs
import br.edu.ufcg.splab.claret.claret.Alternative
import br.edu.ufcg.splab.claret.claret.AlternativeAction
import br.edu.ufcg.splab.claret.claret.AlternativeResponse
import br.edu.ufcg.splab.claret.claret.Basic
import br.edu.ufcg.splab.claret.claret.BasicAction
import br.edu.ufcg.splab.claret.claret.BasicResponse
import br.edu.ufcg.splab.claret.claret.Bs
import br.edu.ufcg.splab.claret.claret.ClaretPackage
import br.edu.ufcg.splab.claret.claret.Exception
import br.edu.ufcg.splab.claret.claret.ExceptionAction
import br.edu.ufcg.splab.claret.claret.ExceptionResponse
import br.edu.ufcg.splab.claret.claret.Usecase
import java.util.HashSet
import java.util.List
import java.util.Set
import org.eclipse.xtext.validation.Check

/**
 * This class contains custom validation rules.
 *
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
class ClaretValidator extends AbstractClaretValidator {

  public static val DUPLICATED_STEPS = 'Basic steps shouldn\'t have duplicated step id'
  public static val DUPLICATED_ALTERNATIVE_STEPS = 'Alternative steps shouldn\'t have duplicated step id'
  public static val DUPLICATED_EXCEPTION_STEPS = 'Exception steps shouldn\'t have duplicated step id'
  public static val DUPLICATED_ALTERNATIVES = 'Shouldn\'t have duplicated alternative ids'
  public static val DUPLICATED_EXCEPTIONS = 'Shouldn\'t have duplicated exception ids'
  public static val NON_ALTERNATED_STEPS = 'Steps should be alternated between action from actor and response from system'
  public static val FIRST_STEP_IS_RESPONSE = 'First step shouldn\'t be an response from system'
  public static val FIRST_STEP_IS_ACTION = 'First step shouldn\'t be an action from actor'
  public static val LAST_STEP_IS_ACTION_WITHOUT_SKIP = 'Last action step should have an "bs" return'
  public static val SKIP_BEFORE_LAST_STEP = 'Skip not allowed here'
  public static val LAST_STEP_IS_ACTION = 'Last step shouldn\'t be an action from actor'
  public static val ALTERNATIVE_FLOW_UNKNOWN = 'Reference for alternative flow doesn\'t exists'

    @Check
    def checkBasicStepIdsAreUnique(Basic basic) {
        val Set<Integer> uniqueSteps = new HashSet<Integer>();

        for (step : basic.steps) {
            if (step instanceof BasicAction) {
                if (!uniqueSteps.add((step as BasicAction).id)) {
                    error(DUPLICATED_STEPS, step, ClaretPackage.eINSTANCE.basicAction_Id)
                }
            } else if (step instanceof BasicResponse) {
                if (!uniqueSteps.add((step as BasicResponse).id)) {
                    error(DUPLICATED_STEPS, step, ClaretPackage.eINSTANCE.basicResponse_Id)
                }
            }
        }
    }

	@Check
    def checkAlternativeStepIdsAreUnique(Alternative alternative) {
        val Set<Integer> uniqueSteps = new HashSet<Integer>();

        for (step : alternative.steps) {
            if (step instanceof AlternativeAction) {
                if (!uniqueSteps.add((step as AlternativeAction).id)) {
                    error(DUPLICATED_ALTERNATIVE_STEPS, step, ClaretPackage.eINSTANCE.alternativeAction_Id)
                }
            } else if (step instanceof AlternativeResponse) {
                if (!uniqueSteps.add((step as AlternativeResponse).id)) {
                    error(DUPLICATED_ALTERNATIVE_STEPS, step, ClaretPackage.eINSTANCE.alternativeResponse_Id)
                }
            }
        }
    }

    @Check
    def checkExceptionStepIdAreUnique(Exception exception) {
        val Set<Integer> uniqueSteps = new HashSet<Integer>();

        for (step : exception.steps) {
            if (step instanceof ExceptionAction) {
                if (!uniqueSteps.add((step as ExceptionAction).id)) {
                    error(DUPLICATED_EXCEPTION_STEPS, step, ClaretPackage.eINSTANCE.exceptionAction_Id)
                }
            } else if (step instanceof ExceptionResponse) {
                if (!uniqueSteps.add((step as ExceptionResponse).id)) {
                    error(DUPLICATED_EXCEPTION_STEPS, step, ClaretPackage.eINSTANCE.exceptionResponse_Id)
                }
            }
        }
    }

    @Check
    def checkAlternativeIdsAreUnique(Usecase usecase) {
        val Set<Integer> uniqueAlternatives = new HashSet<Integer>();
        val Set<Integer> uniqueExceptions = new HashSet<Integer>();

        for (flow : usecase.flows) {
            if (flow instanceof Alternative) {
                if (!uniqueAlternatives.add((flow as Alternative).id)) {
                    error(DUPLICATED_ALTERNATIVES, flow, ClaretPackage.eINSTANCE.alternative_Id)
                }
            } else if (flow instanceof Exception) {
                if (!uniqueExceptions.add((flow as Exception).id)) {
                    error(DUPLICATED_EXCEPTIONS, flow, ClaretPackage.eINSTANCE.exception_Id)
                }
            }
        }
    }

    @Check
    def checkAlternatedSequenceStepsInBasic(Basic basic) {
        var current = basic.steps?.get(0)
        for (var i = 1; i < basic.steps.size; i++) {
            val next = basic.steps.get(i)
            if (current instanceof BasicAction && next instanceof BasicAction) {
                error(NON_ALTERNATED_STEPS, next, ClaretPackage.eINSTANCE.basicAction_Id)
            } else if (current instanceof BasicResponse && next instanceof BasicResponse) {
                error(NON_ALTERNATED_STEPS, next, ClaretPackage.eINSTANCE.basicResponse_Id)
            }
            current = next
        }
    }

    @Check
    def checkAlternatedSequenceStepsInAlternative(Alternative alternative) {
        var current = alternative.steps?.get(0)
        for (var i = 1; i < alternative.steps.size; i++) {
            val next = alternative.steps.get(i)
            if (current instanceof AlternativeAction && next instanceof AlternativeAction) {
                error(NON_ALTERNATED_STEPS, next, ClaretPackage.eINSTANCE.alternativeAction_Id)
            } else if (current instanceof AlternativeResponse && next instanceof AlternativeResponse) {
                error(NON_ALTERNATED_STEPS, next, ClaretPackage.eINSTANCE.alternativeResponse_Id)
            }
            current = next
        }
    }

    @Check
    def checkAlternatedSequenceStepsInException(Exception exception) {
        var current = exception.steps?.get(0)
        for (var i = 1; i < exception.steps.size; i++) {
            val next = exception.steps.get(i)
            if (current instanceof ExceptionAction && next instanceof ExceptionAction) {
                error(NON_ALTERNATED_STEPS, next, ClaretPackage.eINSTANCE.exceptionAction_Id)
            } else if (current instanceof ExceptionResponse && next instanceof ExceptionResponse) {
                error(NON_ALTERNATED_STEPS, next, ClaretPackage.eINSTANCE.exceptionResponse_Id)
            }
            current = next
        }
    }

    @Check
    def checkFirstStepIsResponse(Basic basic) {
        if (!basic.steps.isEmpty) {
            var current = basic.steps.get(0)
            if (current instanceof BasicResponse) {
                error(FIRST_STEP_IS_RESPONSE, current, ClaretPackage.eINSTANCE.basicResponse_Id)
            }
        }
    }

    @Check
    def checkFirstStepIsResponse(Alternative alternative) {
        if (!alternative.steps.isEmpty) {
            var current = alternative.steps.get(0)
            if (current instanceof AlternativeResponse) {
                error(FIRST_STEP_IS_RESPONSE, current, ClaretPackage.eINSTANCE.alternativeResponse_Id)
            }
        }
    }

    @Check
    def checkFirstStepIsResponse(Exception exception) {
        if (!exception.steps.isEmpty) {
            var current = exception.steps.get(0)
            if (current instanceof ExceptionAction) {
                error(FIRST_STEP_IS_ACTION, current, ClaretPackage.eINSTANCE.exceptionAction_Id)
            }
        }
    }

    @Check
    def checkLastStepIsResponse(Basic basic) {
        if (!basic.steps.isEmpty) {
            var last = basic.steps.get(basic.steps.size - 1)
            if (last instanceof BasicAction) {
                error(LAST_STEP_IS_ACTION, last, ClaretPackage.eINSTANCE.basicAction_Id)
            }
        }
    }

    @Check
    def checkLastStepIsActionWithoutBs(Alternative alternative) {
        val head = alternative.steps.reverseView.head
        if (head instanceof AlternativeAction && (head as AlternativeAction).skip === null) {
            error(LAST_STEP_IS_ACTION_WITHOUT_SKIP, head, ClaretPackage.eINSTANCE.alternativeAction_Skip)
        }
    }

    @Check
    def checkExistsBsBeforeLastAlternativeStep(Alternative alternative) {
        val actionSteps = alternative.steps.reverseView.tail.filter(typeof(AlternativeAction))
        actionSteps.forEach[
            if (it.skip !== null) {
                error(SKIP_BEFORE_LAST_STEP, it, ClaretPackage.eINSTANCE.alternativeAction_Skip)
            }
        ]

    }

    @Check
    def checkExistsBsBeforeLastExceptionStep(Exception exception) {
        val responseSteps = exception.steps.reverseView.tail.filter(typeof(ExceptionResponse))
        responseSteps.forEach[
            if (it.skip !== null) {
                error(SKIP_BEFORE_LAST_STEP, it, ClaretPackage.eINSTANCE.exceptionResponse_Skip)
            }
        ]

    }

    @Check
    def checkLastStepIsResponse(Exception exception) {
        if (!exception.steps.isEmpty) {
            var last = exception.steps.get(exception.steps.size - 1)
            if (last instanceof ExceptionAction) {
                error(LAST_STEP_IS_ACTION, last, ClaretPackage.eINSTANCE.exceptionAction_Id)
            }
        }
    }

    @Check
    def checkReferenceToAf(Usecase usecase) {
        val afList = usecase.flows.filter[it instanceof Alternative].map[it as Alternative]
        val afSkipList = usecase.basic.steps.filter[it instanceof BasicAction && (it as BasicAction).skip !== null].map[(it as BasicAction).skip.afList].flatten.toList
        afList.forEach[af |
          if(!afSkipList.contains(af.id)) {
            warning('''Alternative «af.id» declared but never referenced''', af, ClaretPackage.eINSTANCE.alternative_Id)
          }
        ]
    }

    @Check
    def checkExistsReferenceToEf(Usecase usecase) {
        val afList = usecase.flows.filter[it instanceof Alternative].map[it as Alternative]
        val efList = usecase.flows.filter[it instanceof Exception].map[it as Exception]
        val efSkipListFromBasic = usecase.basic.steps.
          filter[it instanceof BasicResponse].map[it as BasicResponse].
          filter[skip !== null].map[skip.efList].flatten.toList
        val efSkipListFromAlternative = afList.map[steps].flatten.
          filter[it instanceof AlternativeResponse].map[it as AlternativeResponse].
          filter[skip !== null].map[skip.efList].flatten.toList
        efList.forEach[ef |
          if(!(efSkipListFromBasic.contains(ef.id) || efSkipListFromAlternative.contains(ef.id))) {
            warning('''Exception «ef.id» declared but never referenced''', ef, ClaretPackage.eINSTANCE.exception_Id)
          }
        ]
    }

    @Check
    def checkExistsAf(Usecase usecase) {
        val List<Integer> afList = usecase.flows.filter[it instanceof Alternative].map[s | (s as Alternative).id].toList
        usecase.basic.steps.filter[it instanceof BasicAction].map[it as BasicAction].forEach[ba |
          ba.skip.afList.forEach[af |
            if (!afList.contains(af)) {
                error('''Alternative «af» does not exist''', ba, ClaretPackage.eINSTANCE.basicAction_Skip)
            }
          ]
        ]
    }

    @Check
    def checkExistsEf(Usecase usecase) {
      val List<Integer> efList = usecase.flows.filter[it instanceof Exception].map[s | (s as Exception).id].toList
      usecase.basic.steps.filter[it instanceof BasicResponse].map[it as BasicResponse].forEach[br |
        br.skip.efList.forEach[ef |
          if (!efList.contains(ef)) {
            error('''Exception «ef» does not exist''', br, ClaretPackage.eINSTANCE.basicResponse_Skip)
          }
        ]
      ]
    }

    @Check
    def checkExistsEfFromAf(Usecase usecase) {
      val efList = usecase.flows.filter[it instanceof Exception].map[(it as Exception).id].toList
      val afList = usecase.flows.filter[it instanceof Alternative].map[it as Alternative]
      afList.map[steps].flatten.filter[it instanceof AlternativeResponse].map[it as AlternativeResponse].forEach[ar |
        ar.skip?.efList.forEach[ef |
          if (!efList.contains(ef)) {
            error('''Exception «ef» does not exist''', ar, ClaretPackage.eINSTANCE.alternativeResponse_Skip)
          }
        ]
      ]
    }

    @Check
    def checkReturnAfs(Usecase usecase) {
      val afList = usecase.flows.filter[it instanceof Alternative].map[it as Alternative].toList
      val afIdList = afList.map[id].toList
      val efList = usecase.flows.filter[it instanceof Exception].map[it as Exception]
      val afsList = efList.map[steps].flatten.filter[it instanceof ExceptionResponse].map[it as ExceptionResponse].filter[skip instanceof Afs].map[skip as Afs]
      afsList.forEach[afs |
        val eid = ((afs.eContainer as ExceptionResponse).eContainer as Exception).id
        if(afIdList.contains(afs.af)) {
          val alternativeSkips = afList.filter[it.id == afs.af].head.steps.filter[it instanceof AlternativeResponse].map[it as AlternativeResponse]
          if(!alternativeSkips.filter[skip !== null].map[it.skip.efList].flatten.toList.contains(eid))
            error('''This exception is not called from alternative «afs.af»''', afs, ClaretPackage.eINSTANCE.afs_Af)
        } else {
           error('''This exception is not called from alternative «afs.af»''', afs, ClaretPackage.eINSTANCE.afs_Af)
        }
      ]
    }

    @Check
    def checkReturnFromExceptionAlternative(Usecase usecase) {
      val efList = usecase.flows.filter[it instanceof Exception].map[it as Exception]
      val afList = usecase.flows.filter[it instanceof Alternative].map[it as Alternative].toList
      afList.map[steps].flatten.filter[it instanceof AlternativeResponse].map[it as AlternativeResponse].forEach[ar |
        ar.skip?.efList.forEach[ef |
          if (efList.exists[id == ef]) {

            val exception = efList.findFirst[id == ef]
            val er = exception.steps.filter[it instanceof ExceptionResponse].map[it as ExceptionResponse].findFirst[skip instanceof Bs]
            if(er !== null) {
              val alternativeId = (ar.eContainer as Alternative).id
              error('''BS Skip not permitted, only afs skip or none. Alternative «alternativeId» references this Exception.''', er, ClaretPackage.eINSTANCE.exceptionResponse_Skip)
            }
          }
        ]
      ]
    }
}
