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

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map
import org.jgrapht.io.Attribute

class DefaultVertex {
	static val serialVersionUID = -4861285584479124799L;
	String id;
	Map<String, Attribute> att;

    // Construtores
	new(String id, Map<String, Attribute> att) {
		this.id = id;
		this.att = att;
	}
	new(String id) {
		this.id = id;
		this.att = new HashMap <String,Attribute> ();
	}

	// Métodos de Acesso
	def String getId() {
		return id;
	}

	def String getLabel() {
		var String label;
		try {
		   label = (att.get("label")).toString(); 
	    } catch (Exception e) {
		   label = id;
	    }
		return label;
	}

	override int hashCode() {
		val int prime = 31;
		var int result = 1;
		result = prime * result + (if (id === null) 0 else id.hashCode());
		return result;
	}

	def boolean equals(DefaultVertex v) {
		val String s1 = this.getId();
		val String s2 = v.getId();
		return if (s2 instanceof String) s1.equals(s2) else false;
	}

	override String toString() {
		return this.getLabel();
	}
}
