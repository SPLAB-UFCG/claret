= Especificação de Casos de Uso do Sistema ${name}
SPLab/Ingenico
:revnumber: v${uc.versions.last.num}
:revdate: {docdatetime}
:pagenums:
:toc:
:imagesdir: assets/images
:homepage: http://asciidoctor.org
:numbered:
:toc-title: SUMÁRIO
:toclevels: 3
:imagesdir: ./myimages

== Informações sobre o Documento
\'\'\'
=== Histórico
[cols=\"<10,<40,^25,^14\"]
|==="
|Versão |Tipo de Modificação |Autor | Data

          walkAsciidoc(uc.versions)
|==="
=== Objetivo"
Este documento descreve o caso de uso '${uc.name}', pertencente ao sistema '${name}'.

<<<
== Caso de Uso: ${uc.name}
\'\'\'
=== Finalidade
=== Usuário/Ator
[cols=\"^29,60\"]
|===
|Usuário/Ator |Descrição

          walkAsciidoc(uc.actors)
|===
          walkAsciidoc(uc.pre)
=== Fluxos
          walkAsciidoc(uc.basic)
          walkAsciidoc(uc.flows)
          walkAsciidoc(uc.post)
          writer.write(lines.mkString("\n"))
          writer.close()