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

import org.eclipse.xtext.generator.IOutputConfigurationProvider
import org.eclipse.xtext.generator.OutputConfiguration
import org.eclipse.xtext.generator.IFileSystemAccess

class TemplateOutputConfigurationProvider implements IOutputConfigurationProvider {
  
  public static final String GEN_ONCE_OUTPUT = "GEN_ONCE_OUTPUT"
  
  override getOutputConfigurations() {
    var defaultOutput = new OutputConfiguration(IFileSystemAccess.DEFAULT_OUTPUT)
    defaultOutput.setDescription("Output Folder")
    defaultOutput.setOutputDirectory("./output")
    defaultOutput.setOverrideExistingResources(true)
    defaultOutput.setCreateOutputDirectory(true)
    defaultOutput.setCleanUpDerivedResources(true)
    defaultOutput.setSetDerivedProperty(true)

    var readonlyOutput = new OutputConfiguration(GEN_ONCE_OUTPUT)
    readonlyOutput.setDescription("Template Folder")
    readonlyOutput.setOutputDirectory("./template")
    readonlyOutput.setOverrideExistingResources(false)
    readonlyOutput.setCreateOutputDirectory(true)
    readonlyOutput.setCleanUpDerivedResources(false)
    readonlyOutput.setSetDerivedProperty(false)

    return newHashSet(defaultOutput, readonlyOutput)
  }
}