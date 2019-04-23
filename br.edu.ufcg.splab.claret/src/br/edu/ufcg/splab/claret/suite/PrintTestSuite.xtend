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

package br.edu.ufcg.splab.claret.suite

import java.util.Iterator
import java.util.List
import org.jgrapht.GraphPath

class PrintTestSuite {
	
	// Print a Test Suite
	def static String print (List<GraphPath<DefaultVertex,RelationshipDirectedEdge>> testsuite) {
	    val Iterator <GraphPath<DefaultVertex,RelationshipDirectedEdge>> it1 = testsuite.iterator();
	    var int countTC = 1;
	    val strBuilder = new StringBuilder();
	    while (it1.hasNext()) {
	    	strBuilder.append(printTC(it1.next(),countTC++));
	    }
	    return strBuilder.toString
	}
	
	// Print a Test Case
	def static String printTC (GraphPath<DefaultVertex,RelationshipDirectedEdge> p, int count) {
	    val Iterator <RelationshipDirectedEdge> it = p.getEdgeList().iterator();
		var boolean flag = true;
		val strBuilder = new StringBuilder();
		strBuilder.append("Test Case: " + count + "\n");
		while (it.hasNext()) { 
			val RelationshipDirectedEdge e = it.next();
			//System.out.println(e);
			val String kindS = e.getLabel().substring(1,2);
			val String labelS = e.getLabel().substring(4);
			if(kindS.contentEquals("c")) {
				if (flag) { 
					strBuilder.append("Precondition: " + labelS + "\n");
					flag = false;
				} else {
					strBuilder.append("Postcondition: " + labelS + "\n");
				}

			} else {
				if (kindS.contentEquals("s")) {
					strBuilder.append(labelS + " -> ");
					if (it.hasNext()) {
						val RelationshipDirectedEdge e2 = it.next();
						val String kindER = e2.getLabel().substring(1,2);
						val String labelER = e2.getLabel().substring(4);
						if (kindER.equals("e")) {
							strBuilder.append(labelER.replaceAll("system", "SYSTEM")+"\n");
						}
					}
				}
			}
		}
		strBuilder.append("\n");
		return strBuilder.toString
	}
}
