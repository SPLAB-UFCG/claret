/*
/**
 * Copyright 2018 Synaptik Solutions
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

package br.edu.ufcg.splab.claret.tests

import com.google.inject.Inject
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.testing.util.ParseHelper
import org.junit.Assert
import org.junit.Test
import org.junit.runner.RunWith
import br.edu.ufcg.splab.claret.claret.Sud

@RunWith(XtextRunner)
@InjectWith(ClaretInjectorProvider)
class ClaretParsingTest {
	@Inject
	ParseHelper<Sud> parseHelper
	
	@Test
	def void loadModel() {
		val result = parseHelper.parse('''
systemName "TCoMApp"

usecase "Login do usuário" {
    //levou 20min
    version "1.0" type "Criação" user "Rayssa" date "26/09/2017"
    actor usuario "Usuário do sistema TCoMApp"

    preCondition "Usuário ter cadastro no sistema"

    basic {
        step 1 usuario "preenche o formulário com os campos Username e Password; e seleciona a ação para acesso do sistema"
        step 2 system "direciona o usuário para a página de ordem de serviço" ef[1,2,3,4]
        step 2 usuario "preenche o formulário com os campos Username e Password; e seleciona a ação para acesso do sistema"
        step 4 system "direciona o usuário para a página de ordem de serviço" ef[1,2,3,4]
    }

    exception 1 "Usuário digitou um username inválido (vazio, espaços em branco)" {
    		
        step 1 system "informa que o nome do usuário é necessário para realizar o login"
        
    }

    exception 2 "Usuário digitou password inválida (vazio, espaços em branco)" {
        step 1 system "informa que a senha é necessária para realizar o login"
    }

    exception 3 "Usuário digitou username ou password incompatíveis" {
        step 1 system "informa que o username ou password são incompatíveis"
    }

    exception 4 "Sistema sem conexão com o servidor" {
        step 1 system "informa que foi impossível se conectar com o servidor"
    }

    postCondition "O usuário acessa o sistema"
}		
		''')
		Assert.assertNotNull(result)
		Assert.assertTrue(result.eResource.errors.isEmpty)
	}
}
