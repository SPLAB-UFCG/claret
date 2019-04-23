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
import br.edu.ufcg.splab.claret.suite.GreedyReduction
import br.edu.ufcg.splab.claret.suite.PrintTestSuite
import br.edu.ufcg.splab.claret.suite.SimReduction
import br.edu.ufcg.splab.claret.suite.TestSuiteGeneration

class TestSuiteGenerator {
	def static toText(Usecase usecase, GMLStruct gml) {
		val int maxTCSize = 3;  // max number of steps for test cases

		// Test Suite Generation
		val g = new TestSuiteGeneration(gml.content, gml.initialNode, gml.finalNode);
	    val testsuite = g.generate(maxTCSize);
	    
        // Print vertices and edges
        return #{
        	'complete_test_suite' -> '***Complete Test SUITE - size = ' + testsuite.size() + '\n' + PrintTestSuite.print(testsuite),
        	'reduced_test_suite_1' -> '***Reduced Test SUITE (Greedy Heuristic - Transition Coverage)\n' + PrintTestSuite.print(GreedyReduction.reduce(testsuite,g.getTransitionReqs(),0)),
        	'reduced_test_suite_2' -> '***Reduced Test SUITE (Greedy Heuristic - Transition Pair Coverage)\n' + PrintTestSuite.print(GreedyReduction.reduce(testsuite,g.getTransitionPairReqs(),1)),
        	'reduced_test_suite_3' -> '***Reduced Test SUITE (Sim with Jaccard Index - Transition Coverage)\n' + PrintTestSuite.print(SimReduction.reduce(testsuite,g.getTransitionReqs(),0)),
        	'reduced_test_suite_4' -> '***Reduced Test SUITE (Sim with Jaccard Index - Transition Pair Coverage)\n' + PrintTestSuite.print(SimReduction.reduce(testsuite,g.getTransitionPairReqs(),1))
   		}
    }
}