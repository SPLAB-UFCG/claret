package br.edu.ufcg.splab.claret.suite

import java.util.List
import org.jgrapht.GraphPath
import java.util.Set
import java.util.ArrayList
import java.util.HashSet
import java.util.stream.Collectors
import java.util.Random

class GreedyReduction <R> {
	def static <R> List<GraphPath<DefaultVertex,RelationshipDirectedEdge>> reduce (
			List<GraphPath<DefaultVertex,RelationshipDirectedEdge>> ts, 
			Set <R> reqs,
			int coverageType) {
		val Set <R> testreqs = new HashSet <R>(reqs);
	    val List<GraphPath<DefaultVertex,RelationshipDirectedEdge>> temptestsuite = new ArrayList(ts);
	    val List<GraphPath<DefaultVertex,RelationshipDirectedEdge>> redtestsuite = new ArrayList();	    
	    while (testreqs.isEmpty()==false && temptestsuite.isEmpty()==false) {
	    	var GraphPath<DefaultVertex,RelationshipDirectedEdge> nexttc;
	    	if (coverageType == 0) { // Transition
	    		nexttc = getBiggerTransitionCoverage(temptestsuite,testreqs);
	    		cleanTransitionReqs(nexttc,testreqs);
	    	} else {
	    		nexttc = getBiggerTransitionPairCoverage(temptestsuite,testreqs); // TransitionPair
	    		cleanTransitionPairReqs(nexttc,testreqs);
	    	}
	    	temptestsuite.remove(nexttc);
	    	redtestsuite.add(nexttc);
	    }
	    return redtestsuite;
	}
	
		// Return the coverage of a set of requirements by a test suite
	def static <R> Integer getTransitionCoverage (GraphPath<DefaultVertex,RelationshipDirectedEdge> tc, Set <R> reqs  ) {
		val List <RelationshipDirectedEdge> l = tc.getEdgeList();
		val List<R> coveredReqs = reqs.stream().filter[t| l.contains(t)].collect(Collectors.toList());
		val Integer count = new Integer(coveredReqs.size()); 
		return count;
	}

	// Return the TC that covers more requirements than the others. In case of tie, a random choice is applied.
	def static <R> GraphPath<DefaultVertex,RelationshipDirectedEdge> getBiggerTransitionCoverage (
			List<GraphPath<DefaultVertex,RelationshipDirectedEdge>> testsuite,
			Set <R> reqs) {
        // Order by coverage of reqs
		val List< GraphPath<DefaultVertex,RelationshipDirectedEdge> > otcs = 
				testsuite.stream().sorted[e1,e2| getTransitionCoverage(e1,reqs).compareTo(getTransitionCoverage(e2,reqs))]
				.collect(Collectors.toList());	
		// Compute biggest coverage value
		val GraphPath<DefaultVertex,RelationshipDirectedEdge> e = otcs.get(otcs.size()-1);
		val int biggestCoverage = getTransitionCoverage(e,reqs);
		// Filter test cases with biggest coverage
		val List< GraphPath<DefaultVertex,RelationshipDirectedEdge> > otcs2 = 
				otcs.stream().filter[tc| getTransitionCoverage(tc,reqs) == biggestCoverage].collect(Collectors.toList());
		// If there is more than one TC, a random index is selected
		val Random random = new Random();
		val int index = if (otcs2.size() > 1) random.nextInt(otcs2.size()-1) else 0;
		return otcs2.get(index);
	}

	def static <R> void cleanTransitionReqs (GraphPath<DefaultVertex,RelationshipDirectedEdge> tc, Set <R> reqs  ) {
		val List <RelationshipDirectedEdge> l = tc.getEdgeList();
		val List<R> coveredReqs = reqs.stream().filter[t| l.contains(t)].collect(Collectors.toList());
		reqs.removeAll(coveredReqs);
	}
	
	def static <R> Integer getTransitionPairCoverage (GraphPath<DefaultVertex,RelationshipDirectedEdge> tc, Set <R> reqs  ) {
		val List <RelationshipDirectedEdge> l = tc.getEdgeList();
		val List <Pair<RelationshipDirectedEdge,RelationshipDirectedEdge>> lp = new ArrayList();
		for (var int i=0;i < l.size()-1; i++) {
			lp.add(new Pair(l.get(i),l.get(i+1)));
		}
		val List<R> coveredReqs = reqs.stream().filter[t| lp.contains(t)].collect(Collectors.toList());
		return new Integer (coveredReqs.size());
	}
	
	// Return the TC that covers more requirements than the others. In case of tie, a random choice is applied.
	def static <R> GraphPath<DefaultVertex,RelationshipDirectedEdge> getBiggerTransitionPairCoverage (
			List<GraphPath<DefaultVertex,RelationshipDirectedEdge>> testsuite,
			Set <R> reqs) {
        // Order by coverage of reqs
		val List< GraphPath<DefaultVertex,RelationshipDirectedEdge> > otcs = 
				testsuite.stream().sorted[e1,e2| 
				getTransitionPairCoverage(e1,reqs).compareTo(getTransitionPairCoverage(e2,reqs))].collect(Collectors.toList());	
		// Compute biggest coverage value
		val GraphPath<DefaultVertex,RelationshipDirectedEdge> e = otcs.get(otcs.size()-1);
		val int biggestCoverage = getTransitionPairCoverage(e,reqs);
		// Filter test cases with biggest coverage
		val List< GraphPath<DefaultVertex,RelationshipDirectedEdge> > otcs2 = 
				otcs.stream().filter[tc| getTransitionPairCoverage(tc,reqs) == biggestCoverage].collect(Collectors.toList());
		// If there is more than one TC, a random index is selected
		val Random random = new Random();
		val int index = if (otcs2.size() > 1) random.nextInt(otcs2.size()-1)  else 0;
		return otcs2.get(index);
	}
		
	def static <R> void cleanTransitionPairReqs (GraphPath<DefaultVertex,RelationshipDirectedEdge> tc, Set <R> reqs  ) {
		val List <RelationshipDirectedEdge> l = tc.getEdgeList();
	    val List <Pair<RelationshipDirectedEdge,RelationshipDirectedEdge>> lp = new ArrayList();
	    for (var int i=0;i < l.size()-1; i++) {
	    	lp.add(new Pair(l.get(i),l.get(i+1)));
	    }
		val List<R> coveredReqs = reqs.stream().filter[t| lp.contains(t)].collect(Collectors.toList());
		reqs.removeAll(coveredReqs);
	}
	
		// Return the biggest TC from a test suite
	def static GraphPath<DefaultVertex,RelationshipDirectedEdge> getBiggerSize 
	           (List<GraphPath<DefaultVertex,RelationshipDirectedEdge>> testsuite) {
		val List< GraphPath<DefaultVertex,RelationshipDirectedEdge> > otcs = 
				testsuite.stream().sorted[e1,e2| (new Integer (e1.getLength())).compareTo(new Integer (e2.getLength()))].collect(Collectors.toList());
		return otcs.get(otcs.size()-1);
	}
}
