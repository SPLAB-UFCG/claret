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

//import org.eclipse.core.runtime.Status
import org.eclipse.xtext.ui.XtextProjectHelper
import org.eclipse.xtext.ui.util.PluginProjectFactory
import org.eclipse.xtext.ui.wizard.template.IProjectGenerator
import org.eclipse.xtext.ui.wizard.template.IProjectTemplateProvider
import org.eclipse.xtext.ui.wizard.template.ProjectTemplate

//import static org.eclipse.core.runtime.IStatus.*

/**
 * Create a list with all project templates to be shown in the template new project wizard.
 * 
 * Each template is able to generate one or more projects. Each project can be configured such that any number of files are included.
 */
class ClaretProjectTemplateProvider implements IProjectTemplateProvider {
	override getProjectTemplates() {
		#[new ClaretProject]
	}
}

@ProjectTemplate(label="Template Project", icon="project_template.png", description="<p><b>Claret Template Project</b></p>
<p>This is a template project for Claret.</p>")
final class ClaretProject {
	override generateProjects(IProjectGenerator generator) {
		generator.generate(new PluginProjectFactory => [
			projectName = projectInfo.projectName
			location = projectInfo.locationPath
			projectNatures += #[XtextProjectHelper.NATURE_ID]
			builderIds += XtextProjectHelper.BUILDER_ID
			folders += "src"
//			addFile('''src/«path»/Model.claret''', '''
			addFile('''src/MySpec.claret''', '''
				/*
				 * This is an example claret specification
				 */
				systemName "SYSTEM_NAME"
				
				usecase "Your First Use Case" {
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
		])
	}
}
