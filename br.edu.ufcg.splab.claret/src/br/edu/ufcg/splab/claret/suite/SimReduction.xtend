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

import java.util.List
import java.util.HashSet
import java.util.Set
import java.util.HashMap
import org.jgrapht.GraphPath
import java.util.Iterator
import java.util.ArrayList
import java.util.Random
import org.jgrapht.alg.util.Pair;
import java.util.Map

class SimReduction <R> {
	// Implements Jaccard distance between two test cases
	// https://en.wikipedia.org/wiki/Jaccard_index
	def static Double getJaccardDistance (GraphPath<DefaultVertex,RelationshipDirectedEdge> tc1, GraphPath<DefaultVertex,RelationshipDirectedEdge> tc2) {
		val Set <RelationshipDirectedEdge> es1 = new HashSet<RelationshipDirectedEdge> (tc1.getEdgeList());
		val Set <RelationshipDirectedEdge> es2 = new HashSet<RelationshipDirectedEdge> (tc2.getEdgeList());
		val Set <RelationshipDirectedEdge> union = new HashSet<RelationshipDirectedEdge>(es1);
		union.addAll(es2);
		val Set <RelationshipDirectedEdge> intersection = new HashSet<RelationshipDirectedEdge>(es1);
		intersection.retainAll(es2);
		return new Double(intersection.size() as double /union.size() as double);
	}

	def static  
		HashMap<Pair<GraphPath<DefaultVertex, RelationshipDirectedEdge>, GraphPath<DefaultVertex, RelationshipDirectedEdge>>, Pair<Boolean, Double>> computeSimilarityMapping (List<GraphPath<DefaultVertex,RelationshipDirectedEdge>> testsuite) {
		val HashMap <Pair<GraphPath<DefaultVertex,RelationshipDirectedEdge>,GraphPath<DefaultVertex,RelationshipDirectedEdge>>,Pair<Boolean,Double>> dict = 
				new HashMap();
		val Iterator <GraphPath<DefaultVertex,RelationshipDirectedEdge>> it1 = testsuite.iterator();
		while (it1.hasNext()) {
			val GraphPath<DefaultVertex,RelationshipDirectedEdge> tc1 = it1.next();
			val Iterator <GraphPath<DefaultVertex,RelationshipDirectedEdge>> it2 = testsuite.iterator();
			while (it2.hasNext()) {
				val GraphPath<DefaultVertex,RelationshipDirectedEdge> tc2 = it2.next();
				if (tc1!=tc2) {
					val Pair<GraphPath<DefaultVertex,RelationshipDirectedEdge>,GraphPath<DefaultVertex,RelationshipDirectedEdge>> key = new Pair(tc1,tc2);
					val Pair<Boolean,Double> value = new Pair(new Boolean(false),getJaccardDistance(tc1,tc2));
					dict.put(key,value);
				}	
			}	
		}
		return dict;
	 }

	def static Pair<GraphPath<DefaultVertex,RelationshipDirectedEdge>,GraphPath<DefaultVertex,RelationshipDirectedEdge>> randomOrderPair (
			Pair<GraphPath<DefaultVertex,RelationshipDirectedEdge>,GraphPath<DefaultVertex,RelationshipDirectedEdge>> tcpair) {	
		val Random r = new Random();
		val int index = r.nextInt(19);
		return if (index < 10) tcpair else new Pair(tcpair.getSecond(),tcpair.getFirst());
	}
	
	def static boolean hasFalse (HashMap <Pair<GraphPath<DefaultVertex,RelationshipDirectedEdge>,GraphPath<DefaultVertex,RelationshipDirectedEdge>>,Pair<Boolean,Double>> dict) {
        for (Map.Entry<Pair<GraphPath<DefaultVertex, RelationshipDirectedEdge>, GraphPath<DefaultVertex, RelationshipDirectedEdge>>, Pair<Boolean, Double>> entry : dict.entrySet()) {
        	if (entry.getValue().getFirst()==false) {
        		return true;
        	}
        }
        return false;
	}

	def static Pair<GraphPath<DefaultVertex,RelationshipDirectedEdge>,GraphPath<DefaultVertex,RelationshipDirectedEdge>> getMostSimilar (
			List<GraphPath<DefaultVertex,RelationshipDirectedEdge>> ts,
			HashMap<Pair<GraphPath<DefaultVertex, RelationshipDirectedEdge>, GraphPath<DefaultVertex, RelationshipDirectedEdge>>, Pair<Boolean, Double>> sim) {
        val List <Pair<GraphPath<DefaultVertex,RelationshipDirectedEdge>,GraphPath<DefaultVertex,RelationshipDirectedEdge>>> mostSimilar = 
        		new ArrayList<Pair<GraphPath<DefaultVertex, RelationshipDirectedEdge>, GraphPath<DefaultVertex, RelationshipDirectedEdge>>> ();
        var double larger = 0.0;
        for (Map.Entry<Pair<GraphPath<DefaultVertex, RelationshipDirectedEdge>, GraphPath<DefaultVertex, RelationshipDirectedEdge>>, Pair<Boolean, Double>> entry : sim.entrySet()) {
        	if (entry.getValue().getSecond().doubleValue()>larger && entry.getValue().getFirst().booleanValue()==false) {
        		larger = entry.getValue().getSecond().doubleValue();
        	}
        }
        for (Map.Entry<Pair<GraphPath<DefaultVertex, RelationshipDirectedEdge>, GraphPath<DefaultVertex, RelationshipDirectedEdge>>, Pair<Boolean, Double>> entry : sim.entrySet()) {
        	if (entry.getValue().getSecond().doubleValue()==larger && entry.getValue().getFirst().booleanValue()==false) {
        		mostSimilar.add(entry.getKey());
        	}
        }
        val Random r = new Random();
        val int index = if (mostSimilar.size() > 1) r.nextInt(mostSimilar.size()-1) else 0;
		return mostSimilar.get(index);
	}

    def static <R> boolean fullCoverage (List<GraphPath<DefaultVertex,RelationshipDirectedEdge>> ts, Set <R> reqs, int coverageType) {
   		val Set <R> tempreqs = new HashSet(reqs);
    	if (coverageType == 0) {
    		val Iterator <GraphPath<DefaultVertex,RelationshipDirectedEdge>> it = ts.iterator();
    		while (tempreqs.isEmpty()==false && it.hasNext()) {
    			tempreqs.removeAll(it.next().getEdgeList());
    		}
    	} else {
    		val Iterator <GraphPath<DefaultVertex,RelationshipDirectedEdge>> it = ts.iterator();
    		while (tempreqs.isEmpty()==false && it.hasNext()) {
    			val List<RelationshipDirectedEdge> l = it.next().getEdgeList();
    			val List <Pair<RelationshipDirectedEdge,RelationshipDirectedEdge>> lp = new ArrayList();
    		    for (var int i=0; i < l.size()-1; i++) {
    		    	lp.add(new Pair(l.get(i),l.get(i+1)));
    		    }
    			tempreqs.removeAll(lp);
    		}
    	}
    	
    	if (tempreqs.isEmpty()) {
    		return true;
    	} else return false;
    }
    		
	def static <R> List<GraphPath<DefaultVertex,RelationshipDirectedEdge>> reduce (List<GraphPath<DefaultVertex,RelationshipDirectedEdge>> ts, 
			                      Set <R> reqs,
			                      int coverageType) {
		val Set <R> testreqs = new HashSet<R>(reqs);
		var HashMap <Pair<GraphPath<DefaultVertex,RelationshipDirectedEdge>,GraphPath<DefaultVertex,RelationshipDirectedEdge>>,Pair<Boolean,Double>> dict =
				computeSimilarityMapping (ts);
	    val List<GraphPath<DefaultVertex,RelationshipDirectedEdge>> temptestsuite = new ArrayList(ts);
	    while (hasFalse(dict)) {
	    	val Pair<GraphPath<DefaultVertex,RelationshipDirectedEdge>,GraphPath<DefaultVertex,RelationshipDirectedEdge>> pair = randomOrderPair(getMostSimilar(temptestsuite,dict));
	    	val GraphPath<DefaultVertex,RelationshipDirectedEdge> first = pair.getFirst();
	    	val GraphPath<DefaultVertex,RelationshipDirectedEdge> second = pair.getSecond();
	       	temptestsuite.remove(first);
	       	if (fullCoverage(temptestsuite,testreqs,coverageType)==false) {
	       		temptestsuite.add(first);
	       		temptestsuite.remove(second);
	       		if (fullCoverage(temptestsuite,testreqs,coverageType)==false) {
	       			temptestsuite.add(second);
	       			val Pair <Boolean,Double> temp = new Pair(new Boolean(true),dict.get(pair).getSecond());
	       			dict.remove(pair);
	       			dict.put(pair,temp);
	       		} else dict = removeDictEntry(dict,second);
	       	} else dict = removeDictEntry(dict,first);
	    }
	    return temptestsuite;	
	}
	
	def static HashMap <Pair<GraphPath<DefaultVertex,RelationshipDirectedEdge>,GraphPath<DefaultVertex,RelationshipDirectedEdge>>,Pair<Boolean,Double>> removeDictEntry (
			HashMap <Pair<GraphPath<DefaultVertex,RelationshipDirectedEdge>,GraphPath<DefaultVertex,RelationshipDirectedEdge>>,Pair<Boolean,Double>> dict,
			GraphPath<DefaultVertex,RelationshipDirectedEdge> tc) {
		val HashMap <Pair<GraphPath<DefaultVertex,RelationshipDirectedEdge>,GraphPath<DefaultVertex,RelationshipDirectedEdge>>,Pair<Boolean,Double>> tempdict = new HashMap(dict);
        for (Map.Entry<Pair<GraphPath<DefaultVertex, RelationshipDirectedEdge>, GraphPath<DefaultVertex, RelationshipDirectedEdge>>, Pair<Boolean, Double>> entry : dict.entrySet()) {
        	if (entry.getKey().getFirst().equals(tc)||entry.getKey().getSecond().equals(tc)) {
        		tempdict.remove(entry.getKey());
        	}
        }
		return tempdict;
	}
}
