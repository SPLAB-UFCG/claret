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

package br.edu.ufcg.splab.claret.ui.labeling

import br.edu.ufcg.splab.claret.claret.Actor
import br.edu.ufcg.splab.claret.claret.Af
import br.edu.ufcg.splab.claret.claret.Afs
import br.edu.ufcg.splab.claret.claret.Alternative
import br.edu.ufcg.splab.claret.claret.AlternativeAction
import br.edu.ufcg.splab.claret.claret.AlternativeResponse
import br.edu.ufcg.splab.claret.claret.Basic
import br.edu.ufcg.splab.claret.claret.BasicAction
import br.edu.ufcg.splab.claret.claret.BasicResponse
import br.edu.ufcg.splab.claret.claret.Bs
import br.edu.ufcg.splab.claret.claret.Ef
import br.edu.ufcg.splab.claret.claret.Exception
import br.edu.ufcg.splab.claret.claret.ExceptionAction
import br.edu.ufcg.splab.claret.claret.ExceptionResponse
import br.edu.ufcg.splab.claret.claret.PostCondition
import br.edu.ufcg.splab.claret.claret.Precondition
import br.edu.ufcg.splab.claret.claret.Sud
import br.edu.ufcg.splab.claret.claret.Usecase
import br.edu.ufcg.splab.claret.claret.Version
import com.google.inject.Inject
import org.eclipse.emf.edit.ui.provider.AdapterFactoryLabelProvider
import org.eclipse.xtext.ui.label.DefaultEObjectLabelProvider

/**
 * Provides labels for EObjects.
 * 
 * See https://www.eclipse.org/Xtext/documentation/304_ide_concepts.html#label-provider
 */
class ClaretLabelProvider extends DefaultEObjectLabelProvider {

	@Inject
	new(AdapterFactoryLabelProvider delegate) {
		super(delegate);
	}

	// Labels and icons can be computed like this:
	
	def text(Sud sud) {
		'System : ' + sud.name
	}

	def text(Usecase usecase) {
		'Usecase : ' + usecase.name
	}

	def text(Version version) {
		'Version : ' + version.version + ' - ' + version.type + ' by ' + version.user + ' on ' + version.date
	}

	def text(Actor actor) {
		'Actor : ' + actor.name
	}

	def text(Precondition precondition) {
		'Precondition : ' + precondition.preConditionList.toString()
	}

	def text(PostCondition postcondition) {
		'Precondition : ' + postcondition.postConditionList.toString()
	}

	def text(Basic basic) {
		'Basic'
	}

    def text(BasicAction action) {
        'Step ' + action.id + ' : ' + action.actor.name + ' ' + 
            action.action.replaceAll("[\n\r]", "") +
            if(action.skip !== null) { 
                ' af ' + action.skip.afList.toString()
            } else ''
    }

    def text(BasicResponse response) {
        'Step ' + response.id + ' : system ' + 
            response.action.replaceAll("[\n\r]", "") + 
            if(response.skip !== null) { 
                ' ef ' + response.skip.efList.toString()
            } else ''
    }

    def text(AlternativeAction action) {
        'Step ' + action.id + ' : ' + action.actor.name + ' ' + 
            action.action.replaceAll("[\n\r]", "") +
            if((action.skip !== null) && action.skip instanceof Bs) { 
                ' bs ' + (action.skip as Bs).id
            } else ''
        
    }

    def text(AlternativeResponse response) {
        'Step ' + response.id + ' : system ' + 
            response.action.replaceAll("[\n\r]", "") +
            if((response.skip !== null) && response.skip instanceof Ef) { 
                ' ef ' + (response.skip as Ef).efList.toString()
            }
            else ''
    }

    def text(ExceptionAction action) {
        'Step ' + action.id + ' : ' + action.actor.name + ' ' + 
            action.action.replaceAll("[\n\r]", "")
    }

    def text(ExceptionResponse response) {
        'Step ' + response.id + ' : system ' + 
            response.action.replaceAll("[\n\r]", "") +
            if((response.skip !== null) && response.skip instanceof Bs) { 
                ' bs ' + (response.skip as Bs).id
            } else if((response.skip !== null) && response.skip instanceof Afs) { 
                ' afs ' + (response.skip as Afs).af + ':'+(response.skip as Afs).step
            } else ''
    }

	def text(Alternative alternative) {
		'Alternative ' + alternative.id + ' : ' + alternative.description
	}

	def text(Exception exception) {
		'Exception ' + exception.id + ' : ' + exception.description
	}

  def text(Af af) {
    if (af !== null) af.toString else ''
  }

//	def image(Greeting ele) {
//		'Greeting.gif'
//	}
}
