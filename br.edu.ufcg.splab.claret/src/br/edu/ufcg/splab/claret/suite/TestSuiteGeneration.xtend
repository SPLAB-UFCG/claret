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

import java.util.HashSet
import java.util.Iterator
import java.util.List
import java.util.Set
import org.jgrapht.GraphPath
import org.jgrapht.alg.shortestpath.AllDirectedPaths
import org.jgrapht.alg.util.Pair
import org.jgrapht.graph.DirectedMultigraph

class TestSuiteGeneration {
	var graphgml = new DirectedMultigraph<DefaultVertex, RelationshipDirectedEdge>(RelationshipDirectedEdge);
	DefaultVertex source;
	DefaultVertex target;
	
	new(String gml, String initialNode, String finalNode) {
		// Import Graph and Get access to source and target vertices
		MyJGraphTUtil.importDirectedGraphGML(this.graphgml, gml);    		
		val Set <DefaultVertex> V = new HashSet <DefaultVertex>(this.graphgml.vertexSet());
		this.source = MyJGraphTUtil.getVertexfromLabel(V,initialNode);
		this.target = MyJGraphTUtil.getVertexfromLabel(V,finalNode);
	}
	
	def List<GraphPath<DefaultVertex,RelationshipDirectedEdge>> generate (int maxTCSize) {
	    // Generate and print the test suite
	    val AllDirectedPaths <DefaultVertex, RelationshipDirectedEdge> adp = new AllDirectedPaths (this.graphgml);
	    return adp.getAllPaths(this.source, this.target, false, maxTCSize*2+2);
	}
	
	def HashSet <RelationshipDirectedEdge> getTransitionReqs () {
		return new HashSet <RelationshipDirectedEdge>(this.graphgml.edgeSet());
	}
	
	def HashSet <Pair<RelationshipDirectedEdge,RelationshipDirectedEdge>> getTransitionPairReqs () {
		val Set <RelationshipDirectedEdge> E = new HashSet <RelationshipDirectedEdge>(this.graphgml.edgeSet());
		val HashSet <Pair<RelationshipDirectedEdge,RelationshipDirectedEdge>> tps = new HashSet();
		val Iterator <RelationshipDirectedEdge> it1 = E.iterator();
		while (it1.hasNext()) {
			val RelationshipDirectedEdge e1 = it1.next();
			val Set <RelationshipDirectedEdge> N = this.graphgml.outgoingEdgesOf(e1.getTarget() as DefaultVertex);
			val Iterator <RelationshipDirectedEdge> it2 = N.iterator();
			while (it2.hasNext()) {
				tps.add(new Pair(e1,it2.next()));
			}
		}		
		return tps;
	}
}
