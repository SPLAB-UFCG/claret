/**
 * Copyright 2019 Dalton Nicodemos Jorge
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
 * @author Dalton Nicodemos Jorge <daltonjorge@copin.ufcg.edu.br>
 */

package br.edu.ufcg.splab.claret.generator

import br.edu.ufcg.splab.claret.claret.Usecase
import br.edu.ufcg.splab.claret.claret.MaximumTestCaseSize
//import lib.TestSuiteGeneration
//import lib.PrintTestSuite
//import lib.GreedyReduction
//import lib.SimReduction
import br.edu.ufcg.splab.claret.claret.Alternative
import br.edu.ufcg.splab.claret.claret.Exception

class TestSuiteGenerator {

  def static toText(Usecase usecase, GMLStruct gml, MaximumTestCaseSize maximumTestCaseSize) {
//    var maxTCSize = 0
//    val testGenerationDetails = if (maximumTestCaseSize?.size == 0) {
//      val basicStepsSize = usecase.basic.steps.size;
//      val alternativeFlows = usecase.flows?.filter[it instanceof Alternative];
//      val exceptionFlows = usecase.flows?.filter[it instanceof Exception];
//      val alternativeStepsSize = if(alternativeFlows.isEmpty) 0 else alternativeFlows.map [
//        (it as Alternative).steps.size
//      ].max;
//      val exceptionStepsSize = if(exceptionFlows.isEmpty) 0 else exceptionFlows.map[(it as Exception).steps.size].max;
//      maxTCSize = (basicStepsSize + #[alternativeStepsSize.intValue, exceptionStepsSize.intValue].max) / 2;
//      ''' * - Calculated Maximum Test Case Size: «maxTCSize»
// *
// * - Equation:
// *
// *     maxTestCaseSize = (b + max(a, e))/2
// * 
// *     where:
// *       b (Total of Basic Flow Steps): «basicStepsSize»
// *       a (Total of Steps from Greater Alternative Flow): «alternativeStepsSize»
// *       e (Total of Steps from Greater Exception Flow): «exceptionStepsSize»
// *
// * - Total of Generated Test Cases: '''
//    } else {
//        maxTCSize = maximumTestCaseSize.size;
//        ''' * - Informed Maximum Test Case Size: «maxTCSize»
// *
// * - Total of Generated Test Cases: '''
//    }
//    // Test Suite Generation
//    val g = new TestSuiteGeneration(gml.content, gml.initialNode, gml.finalNode);
//    val testsuite = g.generate(maxTCSize);
//    val reducedTestSuitGreedyTransitionCoverage = GreedyReduction.reduce(testsuite, g.getTransitionReqs(), 0);
//    val reducedTestSuitGreedyTransitionPairCoverage = GreedyReduction.reduce(testsuite, g.getTransitionReqs(), 1);
//    val reducedTestSuitJaccardIndexTransitionCoverage = SimReduction.reduce(testsuite, g.getTransitionReqs(), 0);
//    val reducedTestSuitJaccardIndexTransitionPairCoverage = SimReduction.reduce(testsuite, g.getTransitionReqs(), 1);
//
//    // Print vertices and edges
//    return #{
//      'complete_test_suite' ->
//        '/**\n *	 >>> COMPLETE TEST SUITE <<<\n *\n' + testGenerationDetails + testsuite.size() + '\n */\n\n' +
//          PrintTestSuite.print(testsuite),
//      'reduced_test_suite_1' ->
//        '/**\n *	 >>> REDUCED TEST SUITE (Greedy Heuristic - Transition Coverage) <<<\n *\n' + testGenerationDetails +
//          reducedTestSuitGreedyTransitionCoverage.size() + '\n */\n\n' +
//          PrintTestSuite.print(reducedTestSuitGreedyTransitionCoverage),
//      'reduced_test_suite_2' ->
//        '/**\n *	 >>> REDUCED TEST SUITE (Greedy Heuristic - Transition Pair Coverage) <<<\n *\n' +
//          testGenerationDetails + reducedTestSuitGreedyTransitionPairCoverage.size() + '\n */\n\n' +
//          PrintTestSuite.print(reducedTestSuitGreedyTransitionPairCoverage),
//      'reduced_test_suite_3' ->
//        '/**\n *	 >>> REDUCED TEST SUITE (Sim with Jaccard Index - Transition Coverage) <<<\n *\n' +
//          testGenerationDetails + reducedTestSuitJaccardIndexTransitionCoverage.size() + '\n */\n\n' +
//          PrintTestSuite.print(reducedTestSuitJaccardIndexTransitionCoverage),
//      'reduced_test_suite_4' ->
//        '/**\n *	 >>> REDUCED TEST SUITE (Sim with Jaccard Index - Transition Pair Coverage) <<<\n *\n' +
//          testGenerationDetails + reducedTestSuitJaccardIndexTransitionPairCoverage.size() + '\n */\n\n' +
//          PrintTestSuite.print(reducedTestSuitJaccardIndexTransitionPairCoverage)
//    }
  }
}
