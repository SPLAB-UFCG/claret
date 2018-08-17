/**
 * Copyright 2018 Dalton N. Jorge
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
 * @author Dalton N. Jorge <daltonjorge@copi.ufcg.edu.br>
 */

package br.edu.ufcg.splab.claret.generator

import org.eclipse.emf.ecore.EObject
import org.eclipse.xtend.lib.annotations.Data 

@Data
class Vertex {

    int id
    String label
    EObject node
    String description

    new(int id, String label, EObject node, String description) {
        this.id = id
        this.label = label
        this.node = node
        this.description = description
    }

    override String toString() {
        "Vertex " + this.id
    }
}
