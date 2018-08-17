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

import br.edu.ufcg.splab.claret.claret.Af
import br.edu.ufcg.splab.claret.claret.BasicAction
import br.edu.ufcg.splab.claret.claret.BasicResponse
import br.edu.ufcg.splab.claret.claret.Ef
import br.edu.ufcg.splab.claret.claret.Usecase
import fr.opensagres.xdocreport.core.XDocReportException
import fr.opensagres.xdocreport.document.IXDocReport
import fr.opensagres.xdocreport.document.registry.XDocReportRegistry
import fr.opensagres.xdocreport.template.IContext
import fr.opensagres.xdocreport.template.TemplateEngineKind
import fr.opensagres.xdocreport.template.formatter.FieldsMetadata
import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream
import java.io.IOException
import java.util.List
import org.eclipse.xtext.generator.IFileSystemAccess2
import br.edu.ufcg.splab.claret.claret.Alternative
import br.edu.ufcg.splab.claret.claret.Exception
import br.edu.ufcg.splab.claret.claret.Bs
import org.eclipse.emf.common.util.EList
import org.eclipse.emf.ecore.EObject
import br.edu.ufcg.splab.claret.claret.AlternativeAction
import br.edu.ufcg.splab.claret.claret.AlternativeResponse
import java.util.Map
import br.edu.ufcg.splab.claret.claret.Afs
import br.edu.ufcg.splab.claret.claret.ExceptionResponse
import br.edu.ufcg.splab.claret.claret.ExceptionAction
import org.eclipse.xtend.lib.annotations.Data

class TextGenerator {
  def static toOdt(String systemName, Usecase usecase, IFileSystemAccess2 fsa) {
    try {
      var template = fsa.readBinaryFile('template.odt', TemplateOutputConfigurationProvider::GEN_ONCE_OUTPUT)
      var IXDocReport report = XDocReportRegistry.getRegistry().loadReport(template, TemplateEngineKind.Velocity)
      var IContext context = report.createContext()

      var FieldsMetadata metadata = new FieldsMetadata();
      metadata.addFieldAsList("versions.version");
      metadata.addFieldAsList("versions.type");
      metadata.addFieldAsList("versions.user");
      metadata.addFieldAsList("versions.date");
      metadata.addFieldAsList("actors.name");
      metadata.addFieldAsList("actors.description");
      metadata.addFieldAsList("preconditions.id");
      metadata.addFieldAsList("preconditions.precondition");
      metadata.addFieldAsList("postconditions.id");
      metadata.addFieldAsList("postconditions.postcondition");
      report.setFieldsMetadata(metadata);

      context.put("system", systemName)
      context.put("usecase", usecase.name)

      val preconditions = usecase.preCondition.preConditionList.indexed.map[new Precondition(it.key + 1, it.value)].toList
      context.put("preconditions", preconditions)

      var versions = usecase.versions.toList
      context.put("versions", versions)

      val actors = usecase.actors.toList
      context.put("actors", actors)

      val steps = usecase.basic.steps.map[getStep(it)]
      context.put("basicsteps", steps)

      val alternatives = usecase.flows.filter[it instanceof Alternative].map[it as Alternative].map[new MyAlternative(it.id, it.description, it.steps)].toList
      context.put("alternatives", alternatives)

      val exceptions = usecase.flows.filter[it instanceof Exception].map[it as Exception].map[new MyException(it.id, it.description, it.steps)].toList
      context.put("exceptions", exceptions)

      val postconditions = usecase.postCondition.postConditionList.indexed.map[new Postcondition(it.key + 1, it.value)].toList
      context.put("postconditions", postconditions)

      var freport = new File("usecase_report.odt")
      var FileOutputStream out = new FileOutputStream(freport);
      report.process(context, out);
      return new FileInputStream(freport)
    } catch (IOException e) {
    	e.printStackTrace();
    } catch (XDocReportException e) {
    	e.printStackTrace();
    } catch (java.lang.Exception e) {
      e.printStackTrace();
    }
  }

  def static dispatch getStep(BasicAction a) {
    #{"id" -> a.id.toString(), "subject" -> a.actor.description, "action" -> a.action, "skips" -> if(a.skip !== null) a.skip?.getSkip else ''}
  }

  def static dispatch getStep(BasicResponse r) {
    #{"id" -> r.id.toString(), "subject" -> "System", "action" -> r.action, "skips" -> if(r.skip !== null) r.skip?.getSkip else ''}
  }

  def static dispatch getSkip(Af af) { "af[" + af.afList.map[s | s.toString].join(',') + ']' }
  def static dispatch getSkip(Ef ef) { "ef[" + ef.efList.map[s | s.toString].join(',') + ']' }
  def static dispatch getSkip(Bs bs) { "bs " + bs.id + ']' }
}

@Data class Precondition {
  Integer id
  String precondition
}

@Data class Postcondition {
  Integer id
  String postcondition
}

@Data class MyAlternative {
  Integer id
  String description
  List<Map<String, String>> steps

  new(Integer id, String description, EList<EObject> steps) {
    this.id = id
    this.description = description
    this.steps = steps.map[getStep(it)]
  }

  def static dispatch getStep(AlternativeAction a) {
    #{"id" -> a.id.toString(), "subject" -> a.actor.description, "action" -> a.action, "skips" -> if(a.skip !== null) a.skip?.getSkip else ''}
  }

  def static dispatch getStep(AlternativeResponse r) {
    #{"id" -> r.id.toString(), "subject" -> "System", "action" -> r.action, "skips" -> if(r.skip !== null) r.skip.getSkip else ''}
  }

  def static dispatch getSkip(Ef ef) { "ef[" + ef.efList.map[s | s.toString].join(',') + ']' }
  def static dispatch getSkip(Bs bs) { "bs " + bs.id }
}

@Data class MyException {
  Integer id
  String description
  List<Map<String, String>> steps

  new(Integer id, String description, EList<EObject> steps) {
    this.id = id
    this.description = description
    this.steps = steps.map[getStep(it)]
  }

  def static dispatch getStep(ExceptionAction a) {
    #{"id" -> a.id.toString(), "subject" -> a.actor.description, "action" -> a.action, "skips" -> '' }
  }

  def static dispatch getStep(ExceptionResponse r) {
    #{"id" -> r.id.toString(), "subject" -> "System", "action" -> r.action, "skips" -> if(r.skip !== null) r.skip.getSkip else '' }
  }

  def static dispatch getSkip(Afs afs) { "afs " + afs.af + ':' + afs.step }
  def static dispatch getSkip(Bs bs) { "bs " + bs.id }
}