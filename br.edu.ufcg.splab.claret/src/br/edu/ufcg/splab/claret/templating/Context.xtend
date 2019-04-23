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

package br.edu.ufcg.splab.claret.templating

import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.Data
import java.util.List
import br.edu.ufcg.splab.claret.claret.Version
import br.edu.ufcg.splab.claret.claret.Actor
import br.edu.ufcg.splab.claret.claret.Usecase
import br.edu.ufcg.splab.claret.claret.BasicAction
import br.edu.ufcg.splab.claret.claret.BasicResponse
import br.edu.ufcg.splab.claret.claret.Af
import br.edu.ufcg.splab.claret.claret.Ef
import br.edu.ufcg.splab.claret.claret.Bs
import br.edu.ufcg.splab.claret.claret.Alternative
import br.edu.ufcg.splab.claret.claret.Exception
import java.util.Map
import org.eclipse.emf.common.util.EList
import org.eclipse.emf.ecore.EObject
import br.edu.ufcg.splab.claret.claret.AlternativeAction
import br.edu.ufcg.splab.claret.claret.AlternativeResponse
import br.edu.ufcg.splab.claret.claret.ExceptionAction
import br.edu.ufcg.splab.claret.claret.ExceptionResponse
import br.edu.ufcg.splab.claret.claret.Afs

class Context {
	@Data static class Precondition {
  		Integer id
  		String precondition
	}
	
	@Data static class Postcondition {
		Integer id
		String postcondition
	}

	@Data static class Basicstep {
		String id
		String subject
		String action
		String skips
	}
	
	@Data static class MyAlternative {
		Integer id
		String description
		List<Map<String, String>> steps
	
		new(Integer id, String description, EList<EObject> steps) {
	    	this.id = id
	    	this.description = description
	    	this.steps = steps.map[getStep(it)]
	  	}
	
	  	def static dispatch getStep(AlternativeAction a) {
	    	#{
	    		"id" -> a.id.toString(), 
	    		"subject" -> a.actor.description, 
	    		"action" -> a.action, 
	    		"skips" -> if(a.skip !== null) a.skip?.getSkip else ''
	    	}
	  	}
	
	  	def static dispatch getStep(AlternativeResponse r) {
	    	#{
	    		"id" -> r.id.toString(), 
	    		"subject" -> "System", 
	    		"action" -> r.action, 
	    		"skips" -> if(r.skip !== null) r.skip.getSkip else ''
	    	}
	  	}
	
	  	def static dispatch getSkip(Ef ef) { "ef[" + ef.efList.map[s | s.toString].join(',') + ']' }
	  	def static dispatch getSkip(Bs bs) { "bs " + bs.id }
	}
	
	@Data static class MyException {
		Integer id
		String description
		List<Map<String, String>> steps
	
		new(Integer id, String description, EList<EObject> steps) {
	    	this.id = id
	  		this.description = description
	  		this.steps = steps.map[getStep(it)]
	  	}
	
	  	def static dispatch getStep(ExceptionAction a) {
	    	#{
	    		"id"	  -> a.id.toString(), 
	    		"subject" -> a.actor.description, 
	    		"action"  -> a.action, 
	    		"skips"   -> '' 
	    	}
	  	}
	
	  	def static dispatch getStep(ExceptionResponse r) {
	    	#{
	    		"id"      -> r.id.toString(), 
	    		"subject" -> "System", 
	    		"action"  -> r.action, 
	    		"skips"   -> if(r.skip !== null) r.skip.getSkip else '' 
	    	}
		}
	
		def static dispatch getSkip(Afs afs) { "afs " + afs.af + ':' + afs.step }
		def static dispatch getSkip(Bs bs) { "bs " + bs.id }
	}
	
	@Accessors String system
	@Accessors String usecase
	@Accessors List<Precondition> preconditions
	@Accessors List<Version> versions
	@Accessors List<Actor> actors
	@Accessors List<Basicstep> basicsteps
	@Accessors List<MyAlternative> alternatives
	@Accessors List<MyException> exceptions
	@Accessors List<Postcondition> postconditions

	new(String systemName, Usecase usecase) {
		this.system = systemName
		this.usecase = usecase.name
		this.preconditions = usecase.preCondition.preConditionList.indexed.map[new Precondition(it.key + 1, it.value)].toList
		this.versions = usecase.versions.toList
		this.actors = usecase.actors.toList
		this.basicsteps = usecase.basic.steps.map[getStep(it)]
		this.alternatives = usecase.flows.filter[it instanceof Alternative].map[it as Alternative].map[new MyAlternative(it.id, it.description, it.steps)].toList
      	this.exceptions = usecase.flows.filter[it instanceof Exception].map[it as Exception].map[new MyException(it. id, it.description, it.steps)].toList
		this.postconditions = usecase.postCondition.postConditionList.indexed.map[new Postcondition(it.key + 1, it.value)].toList
	}
	
  	def static dispatch getStep(BasicAction a) {
  		new Basicstep(a.id.toString(), a.actor.description, a.action, if(a.skip !== null) a.skip?.getSkip else '')
  	}

  	def static dispatch getStep(BasicResponse r) {
  		new Basicstep(r.id.toString(), "System", r.action, if(r.skip !== null) r.skip?.getSkip else '')
  	}

  	def static dispatch getSkip(Af af) { "af[" + af.afList.map[s | s.toString].join(',') + ']' }
  	def static dispatch getSkip(Ef ef) { "ef[" + ef.efList.map[s | s.toString].join(',') + ']' }
  	def static dispatch getSkip(Bs bs) { "bs " + bs.id + ']' }
}