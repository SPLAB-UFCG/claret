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
 * @author Dalton Nicodemos Jorge <daltonjorge@copi.ufcg.edu.br>
 */
 
package br.edu.ufcg.splab.claret.generator

import br.edu.ufcg.splab.claret.claret.Usecase

class GmlGenerator {
	def static toText(Usecase usecase) {
        val g = new TgfBuilder().parser(usecase)

        // Print vertices and edges
        return '''
graph
[
    «FOR v : g.vertices »
    node
    [
        id «v»
        label "«v»"
    ]«"\n"»
«ENDFOR»
    «FOR e : g.getEdgesList »
    edge
    [
        source «e.one»
        target «e.two»
        label «e.annotation» "«e.description.replaceAll("\\r\\n\\s\\t*|\\r\\s\\t*|\\n\\s\\t*", " ")»"
    ]«"\n"»
«ENDFOR»
]
'''
    }
}
