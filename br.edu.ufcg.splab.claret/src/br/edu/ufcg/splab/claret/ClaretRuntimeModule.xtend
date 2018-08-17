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

package br.edu.ufcg.splab.claret

import com.google.inject.Binder
import org.eclipse.xtext.generator.IOutputConfigurationProvider
import br.edu.ufcg.splab.claret.generator.TemplateOutputConfigurationProvider
import com.google.inject.Singleton

/**
 * Use this class to register components to be used at runtime / without the Equinox extension registry.
 */
class ClaretRuntimeModule extends AbstractClaretRuntimeModule {

  override configure(Binder binder) {
    super.configure(binder);
    binder.bind(IOutputConfigurationProvider)
        .to(TemplateOutputConfigurationProvider)
        .in(Singleton);
  }
}
