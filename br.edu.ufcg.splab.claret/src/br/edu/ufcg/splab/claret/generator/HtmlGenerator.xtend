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
import com.github.mustachejava.MustacheFactory
import com.github.mustachejava.DefaultMustacheFactory
import com.github.mustachejava.Mustache

class HtmlGenerator {
	def static getGMLStruct(Usecase usecase) {
		
		val MustacheFactory mf = new DefaultMustacheFactory();
		val Mustache m = mf.compile("todo.mustache");
		
//		Todo todo = new Todo("Todo 1", "Description");
//		StringWriter writer = new StringWriter();
//		m.execute(writer, todo).flush();
//		String html = writer.toString();
	}
}