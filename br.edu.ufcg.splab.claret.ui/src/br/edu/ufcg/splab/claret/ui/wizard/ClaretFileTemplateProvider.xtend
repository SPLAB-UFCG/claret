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

package br.edu.ufcg.splab.claret.ui.wizard


import org.eclipse.xtext.ui.wizard.template.FileTemplate
import org.eclipse.xtext.ui.wizard.template.IFileGenerator
import org.eclipse.xtext.ui.wizard.template.IFileTemplateProvider

/**
 * Create a list with all file templates to be shown in the template new file wizard.
 * 
 * Each template is able to generate one or more files.
 */
class ClaretFileTemplateProvider implements IFileTemplateProvider {
	override getFileTemplates() {
		#[new HelloWorldFile]
	}
}

@FileTemplate(label="Claret File", icon="file_template.png", description="Create a usecase file for Claret.")
final class HelloWorldFile {
	override generateFiles(IFileGenerator generator) {
		generator.generate('''«folder»/«name».claret''', '''
        /*
         * This is an example claret specification
         */
        systemName "SYSTEM_NAME"
        
        usecase "Your Use Case" {
          version "0.1" type "set_type" user "set_user" date "set_date"
          actor person "system actor"
          
          preCondition "first_condition", "second_condition"
          
          basic {
            step 1 person "does something"
            step 2 system "responds to actor"
          }
          
          // Alternatives scenarios here...
          
          // Exceptions scenarios here...
          
          postCondition "final condition", "other condition"
        }

		''')
	}
}
