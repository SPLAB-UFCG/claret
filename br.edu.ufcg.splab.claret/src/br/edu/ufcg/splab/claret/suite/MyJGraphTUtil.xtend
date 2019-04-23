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

import java.io.BufferedReader
import java.io.FileReader
import java.io.IOException
import java.io.StringReader
import java.util.Set
import org.jgrapht.Graph
import org.jgrapht.graph.DefaultEdge
import org.jgrapht.graph.DefaultWeightedEdge
import org.jgrapht.io.CSVFormat
import org.jgrapht.io.CSVImporter
import org.jgrapht.io.EdgeProvider
import org.jgrapht.io.GmlImporter
import org.jgrapht.io.ImportException
import org.jgrapht.io.VertexProvider

//import java.io.Reader

class MyJGraphTUtil {
	def static <V,E> void printGraph (Graph<V,E> g ) {
        println(g.vertexSet());
		println(g.edgeSet()+"\n");
	}

	/**
	 * Os métodos a seguir retornam um vértice ou aresta cujo label eh igual ao passado como parametro.
	 * 
	 */
	def static DefaultVertex getVertexfromLabel(Set<DefaultVertex> V, String label) {	
		return V.stream().filter[v | v.getLabel().equals(label)].findAny().get();
	}

	def static RelationshipEdge getEdgefromLabel(Set<RelationshipEdge> V, String label) {	
		return V.stream().filter[v | v.getLabel().equals(label)].findAny().get();
	}
	
	/**
	 * Os métodos a seguir realizam a importação de grafos no formato CSV e GML.
	 * 
	 */	
	
	def static Graph<String,DefaultEdge> importGraphCSV (Graph<String,DefaultEdge> graph, String filename, CSVFormat f) {
		val VertexProvider<String> vp = [label, attributes| label];
		val EdgeProvider<String, DefaultEdge> ep = [from, to, label, attributes| new DefaultEdge()];

		val CSVImporter<String, DefaultEdge> csvImporter = new CSVImporter(vp, ep);
		csvImporter.setFormat(f); 
		
		try {
			csvImporter.importGraph(graph, readFile(filename)); 
		} catch (ImportException e) { 
			throw new RuntimeException(e); 
		}
		return graph;
	}
	
    def static readFile(String filename) {
		val contentBuilder = new StringBuilder();
		val br = new BufferedReader(new FileReader(filename))
		try {
			var String sCurrentLine;
			while ((sCurrentLine = br.readLine()) !== null) {
				contentBuilder.append(sCurrentLine).append("\n");
			}
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (br !== null) br.close();
		}
		val readergml = new StringReader(contentBuilder.toString());
		return readergml;
	}

	def static Graph<String,DefaultEdge> importGraphCSV (
			Graph<String,DefaultEdge> graph, 
			String filename, 
			CSVFormat f,
			boolean pMATRIX_FORMAT_ZERO_WHEN_NO_EDGE,
			boolean pEDGE_WEIGHT,
			boolean pMATRIX_FORMAT_NODEID) {
		val VertexProvider<String> vp = [label, attributes| label];
		val EdgeProvider<String, DefaultEdge> ep = [from, to, label, attributes| new DefaultEdge()];

		val CSVImporter<String, DefaultEdge> csvImporter = new CSVImporter(vp, ep);
		csvImporter.setFormat(f);
	    csvImporter.setParameter(CSVFormat.Parameter.MATRIX_FORMAT_ZERO_WHEN_NO_EDGE,pMATRIX_FORMAT_ZERO_WHEN_NO_EDGE);
	    csvImporter.setParameter(CSVFormat.Parameter.EDGE_WEIGHTS, pEDGE_WEIGHT);
	    csvImporter.setParameter(CSVFormat.Parameter.MATRIX_FORMAT_NODEID, pMATRIX_FORMAT_NODEID);
		
		try {
			csvImporter.importGraph(graph, readFile(filename)); 
		} catch (ImportException e) { 
			throw new RuntimeException(e); 
		}
		return graph;
	}
	
	def static Graph<String,DefaultWeightedEdge> importWeightedGraphCSV (
			Graph<String,DefaultWeightedEdge> graph, 
			String filename, 
			CSVFormat f,
			boolean pMATRIX_FORMAT_ZERO_WHEN_NO_EDGE,
			boolean pEDGE_WEIGHT,
			boolean pMATRIX_FORMAT_NODEID) {
		val VertexProvider<String> vp = [label, attributes| label];
		val EdgeProvider<String, DefaultWeightedEdge> ep = [from, to, label, attributes| new DefaultWeightedEdge()];

		val CSVImporter<String, DefaultWeightedEdge> csvImporter = new CSVImporter(vp, ep);
		csvImporter.setFormat(f);
	    csvImporter.setParameter(CSVFormat.Parameter.MATRIX_FORMAT_ZERO_WHEN_NO_EDGE,pMATRIX_FORMAT_ZERO_WHEN_NO_EDGE);
	    csvImporter.setParameter(CSVFormat.Parameter.EDGE_WEIGHTS, pEDGE_WEIGHT);
	    csvImporter.setParameter(CSVFormat.Parameter.MATRIX_FORMAT_NODEID, pMATRIX_FORMAT_NODEID);
		
		try {
			csvImporter.importGraph(graph, readFile(filename)); 
		} catch (ImportException e) { 
			throw new RuntimeException(e); 
		}
		return graph;
	}
	
	def static Graph<String,DefaultEdge> importDefaultGraphGML (Graph<String,DefaultEdge> graph, String filename) {
		val VertexProvider<String> vp1 = [label, attributes| label];
		val EdgeProvider<String, DefaultEdge> ep1 = [from, to, label, attributes| new DefaultEdge()];
		val GmlImporter<String, DefaultEdge> gmlImporter = new GmlImporter(vp1, ep1);
		try {
			gmlImporter.importGraph(graph, readFile(filename));
		} catch (ImportException e) {
			throw new RuntimeException(e);
		}
		return graph;
	}

	def static Graph<DefaultVertex,RelationshipEdge> importGraphGML (Graph<DefaultVertex,RelationshipEdge> graph, String filename) {
		val VertexProvider<DefaultVertex> vp1 = [label, attributes| new DefaultVertex(label, attributes)];
		val EdgeProvider<DefaultVertex, RelationshipEdge> ep1 = [from, to, label, attributes| new RelationshipEdge(from,
				to, attributes)];
		val GmlImporter<DefaultVertex, RelationshipEdge> gmlImporter = new GmlImporter(vp1, ep1);
		try {
			gmlImporter.importGraph(graph, readFile(filename));
		} catch (ImportException e) {
			throw new RuntimeException(e);
		}
		return graph;
	}

	def static Graph<DefaultVertex,RelationshipDirectedEdge> importDirectedGraphGML (Graph<DefaultVertex,RelationshipDirectedEdge> graph, String gmlContent) {
		val VertexProvider<DefaultVertex> vp1 = [label, attributes| new DefaultVertex(label, attributes)];
		val EdgeProvider<DefaultVertex, RelationshipDirectedEdge> ep1 = [from, to, label, attributes| new RelationshipDirectedEdge(from,
				to, attributes)];
		val gmlImporter = new GmlImporter<DefaultVertex, RelationshipDirectedEdge>(vp1, ep1);
		try {
			gmlImporter.importGraph(graph, new StringReader(gmlContent));
		} catch (ImportException e) {
			throw new RuntimeException(e);
		}
		return graph;
	}
		
}
