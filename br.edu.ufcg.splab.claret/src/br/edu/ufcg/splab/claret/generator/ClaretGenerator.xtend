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

import br.edu.ufcg.splab.claret.claret.Sud
import br.edu.ufcg.splab.claret.claret.Usecase
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IFileSystemAccessExtension3
import org.eclipse.xtext.generator.IGeneratorContext
import java.io.IOException

/**
 * Generates code from your model files on save.
 *
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class ClaretGenerator extends AbstractGenerator {
  override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
	val files = #['template.odt', 'template.docx']
    files.forEach[
      try {
      	if(!fsa.isFile(it, TemplateOutputConfigurationProvider::GEN_ONCE_OUTPUT)) {
          val in = this.class.getResourceAsStream("/resources/" + it)
          (fsa as IFileSystemAccessExtension3).generateFile(it, TemplateOutputConfigurationProvider::GEN_ONCE_OUTPUT, in)
        }
      } catch (IOException e) {
        throw new RuntimeException(it + " cannot be loaded.", e);
      }
    ]

    for (u : resource.allContents.toIterable.filter(Usecase)){
      val gml = GmlGenerator.getGMLStruct(u)
      fsa.generateFile("gml/"+ u.name + ".gml", gml.content)
      fsa.generateFile("tgf/"+ u.name + ".tgf", TgfGenerator.toText(u))
      fsa.generateFile("tgf/"+ u.name + "-annotated.tgf", AnnotatedTgfGenerator.toText(u))
      TestSuiteGenerator.toText(u, gml).forEach[k,v|
      	fsa.generateFile("test-suite/"+ u.name + "-"+k.toString+".txt", v.toString)
      ]
      
      val root = resource.allContents.head as Sud
      if (root !== null) {
        (fsa as IFileSystemAccessExtension3).generateFile("odt/" + u.name + ".odt", OdtGenerator.generate(root.name, u, fsa))
        (fsa as IFileSystemAccessExtension3).generateFile("docx/" + u.name + ".docx", DocxGenerator.generate(root.name, u, fsa))
      }
    }
  }
}

