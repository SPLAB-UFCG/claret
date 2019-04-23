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
import java.util.HashMap
import org.jgrapht.io.DefaultAttribute
import org.jgrapht.io.AttributeType

class RelationshipDirectedEdge extends DefaultEdge {
	static val long serialVersionUID = -7887238603558924507L;

	// Atributos da classe RelationshipDirectedEdge
	Object source;
	Object target;
	Map<String, Attribute> att;

	new(Object s, Object t, Map<String, Attribute> att) {
		this.source = s;
		this.target = t;
		this.att = att;
	}
	
	new(Object s, Object t, String label) {
		this.source = s;
		this.target = t;
		att = new HashMap <String,Attribute> ();
		att.put("label",new DefaultAttribute<String>(label,AttributeType.STRING));		
	}

	def String getLabel() {
		val Object o = att.get("label"); // captura o label da aresta
		return 
		  if (o === null) // analisa se este eh nulo. se for...
			("(" + source + ":" + target + ")") // retorna um label na forma "(cauda:cabeca)"
		  else o.toString(); // caso contrario retorna o proprio label capturado.
	}

	override Object getSource() {
		return source;
	}

	override Object getTarget() {
		return target;
	}


	def Object getNeighbour(Object v) {
		return if (v.equals(source)) target else source;
	}

	override int hashCode() {
		val int prime = 31;
		var int result = 1;
		result = prime * result + (if (source === null) 0 else source.hashCode());
		result = prime * result + (if(target === null) 0 else target.hashCode());
		return result;
	}

	def boolean equals(RelationshipDirectedEdge e) {
		return (this.getLabel()).equals(e.getLabel());
	}

    override String toString() {
		val Object o = att.get("label"); // captura o label da aresta
//		return if (o === null) // analisa se este eh nulo. se for...
//			 ("(" + source + ":" + target + ")") // retorna uma descricao no formato "(cauda:cabeca)"
//		  else // caso contrario...
//			o.toString() + "->(" + source + ":" + target + ")"; // retorna uma descricao no formato
//																// "label->(cauda:cabeca)"
	    return '''«if (o !== null) o.toString() + "->"»(«source»:«target»)'''
	}
}
