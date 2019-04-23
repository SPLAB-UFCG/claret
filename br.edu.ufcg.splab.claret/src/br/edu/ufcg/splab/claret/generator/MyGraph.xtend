/**
 * Copyright 2018 Dalton Nicodemos Jorge
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

import java.util.ArrayList
import java.util.LinkedHashMap
import org.eclipse.xtend.lib.annotations.Accessors

class MyGraph {
	@Accessors int initialNode
	@Accessors int finalNode
    @Accessors(PUBLIC_GETTER) val vertices = new ArrayList<Integer>()
    @Accessors(PUBLIC_GETTER) val edges = new LinkedHashMap<String, MyEdge>()

    def Integer addEdge(Integer one, Integer two, String id , String description, String annotation){
        val e = new MyEdge(one, two, id, description, annotation)
        edges.put(id, e)
        return e.two
    }

    def Integer newVertex(){
        val vertex = this.newVertexId
        vertices.add(vertex)
        return vertex
    }

    def boolean addVertex(Integer vertex){
        vertices.add(vertex)
        return true
    }

    def Integer from(String id) {
        return this.edges.get(id).one
    }

    def Integer to(String id) {
        return this.edges.get(id).two
    }

    def boolean containsEdge(MyEdge e){
        if(e.one === null || e.two === null){
            return false
        }
        return this.edges.containsKey(e.hashCode())
    }

    def ArrayList<MyEdge> getEdgesList() {
        return new ArrayList<MyEdge>(this.edges.values())
    }

    def Integer newVertexId() {
        return this.vertices.size + 1
    }
}