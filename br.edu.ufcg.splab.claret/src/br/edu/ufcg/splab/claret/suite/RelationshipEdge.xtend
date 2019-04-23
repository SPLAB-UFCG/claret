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

import org.jgrapht.graph.DefaultEdge
import java.util.Map
import org.jgrapht.io.Attribute
import org.jgrapht.io.DefaultAttribute
import java.util.HashMap
import org.jgrapht.io.AttributeType

class RelationshipEdge extends DefaultEdge {
    static final long serialVersionUID = 8238755873387699328L;
	Object v1;
	Object v2;
	Map<String, Attribute> att;

	// Construtores
	new(Object v1, Object v2, Map<String, Attribute> att) {
		this.v1 = v1;
		this.v2 = v2;
		this.att = att;
	}
	
	new(Object v1, Object v2, String label) {
		this.v1 = v1;
		this.v2 = v2;
		att = new HashMap <String,Attribute> ();
		att.put("label",new DefaultAttribute<String>(label,AttributeType.STRING));		
	}

    // Métodos de Acesso	
	def String getLabel() {
		val Object o = att.get("label"); 
		return if (o === null) ("{" + v1 + "," + v2 + "}") else o.toString(); 
	}
	
	def Object getNeighbor(Object v) {
		return if (v.equals(v1)) v2 else v1; 
	}
	
	def Object getV1() {
		return v1;
	}
	
	def Object getV2() {
		return v2;
	}

	override int hashCode() {
		val int prime = 31;
		var int result = 1;
		result = prime * result + (if (v1 === null) 0 else v1.hashCode());
		result = prime * result + (if (v2 === null) 0 else v2.hashCode());
		return result;
	}

	def boolean equals(RelationshipEdge e) {
		return (this.getLabel()).equals(e.getLabel());
	}

	override String toString() {
		val Object o = att.get("label"); // captura o lable da aresta
		return '''«if (o !== null) (att.get("label")).toString() + "->"»{«v1»,«v2»}''';
	}
}
