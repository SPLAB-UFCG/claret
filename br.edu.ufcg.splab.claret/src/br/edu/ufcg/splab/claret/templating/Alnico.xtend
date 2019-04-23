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

import com.github.mustachejava.DefaultMustacheFactory
import com.github.mustachejava.Mustache
import com.github.mustachejava.MustacheException
import com.github.mustachejava.MustacheFactory
import java.io.BufferedReader
import java.io.BufferedWriter
import java.io.InputStream
import java.io.InputStreamReader
import java.io.OutputStream
import java.io.OutputStreamWriter
import java.util.zip.ZipEntry
import java.util.zip.ZipInputStream
import java.util.zip.ZipOutputStream
import java.io.FileInputStream
import java.io.File
import java.io.FileOutputStream

class Alnico {
	def static FileInputStream docxTransform(InputStream source, Context context) {
		val String out = "out.docx";
		return transform(source, new FileOutputStream(out), context, "word/document.xml", out)
	}
	
	def static FileInputStream odtTransform(InputStream source, Context context) {
		val String out = "out.odt";
		return transform(source, new FileOutputStream(out), context, "content.xml", out)		
	}
	
  	def private static FileInputStream transform(InputStream source, OutputStream target, Context context, String filename, String out) {
		val MustacheFactory mf = new DefaultMustacheFactory
		val zis = new ZipInputStream(source)
		val zos = new ZipOutputStream(target);
        val reader = new BufferedReader(new InputStreamReader(zis, "UTF-8")) {override close() {}}
		var ZipEntry ze
        while ((ze = zis.nextEntry) !== null) {
    		zos.putNextEntry(ze);
        	if(ze.name.equalsIgnoreCase(filename)){
    			try {
					val Mustache mustache = mf.compile(reader, 'main')
					val writer = new BufferedWriter(new OutputStreamWriter(zos))
					mustache.execute(writer, context).flush
    			} catch (MustacheException me) {
    				throw new IllegalArgumentException(me.message, me)
    			}
        	}
    		copy(zis, zos)
			zos.closeEntry
    	}
    	zos.close
    	var freport = new File(out)
      	return new FileInputStream(freport)
  	}

    def private static copy(InputStream input, OutputStream output) {
    	val bufferSize = 8192
    	val buffer = newByteArrayOfSize(bufferSize)
    	var long count = 0
    	var n = 0
    	val EOF = -1
    	while (EOF != ({ n = input.read(buffer); n})) {
      		output.write(buffer, 0, n)
      		count += n
    	}
    	return count
  	}	

}