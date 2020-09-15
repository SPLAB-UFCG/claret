package br.edu.ufcg.splab.claret.generator

import br.edu.ufcg.splab.claret.claret.MaximumTestCaseSize
import br.edu.ufcg.splab.claret.claret.Usecase
import br.edu.ufcg.splab.claret.claret.Version
import java.io.ByteArrayInputStream
import java.io.ByteArrayOutputStream
import java.io.StringReader
import lib.XLSXExporter
import org.eclipse.xtext.generator.IFileSystemAccess2
import lib.TestSuiteGeneration
import lib.GreedyReduction
import lib.ArtSimReduction
import java.util.List
import org.jgrapht.GraphPath
import util.DefaultVertex
import util.RelationshipDirectedEdge

//import org.apache.poi.ss.usermodel.Workbook;
class XlsxGenerator {
  def static generate(
    String systemName,
    Usecase usecase,
    GMLStruct gml,
    MaximumTestCaseSize maximumTestCaseSize,
    IFileSystemAccess2 fsa
  ) {
    val lastVersion = usecase.versions.last as Version
    val content = gml.content.toString
    val gmlReader = new StringReader(content)
    val gmlIni = gml.initialNode
    val gmlEnd = gml.finalNode
    val g = new TestSuiteGeneration(gmlReader, gmlIni, gmlEnd)
    val maxTCSize = if (maximumTestCaseSize === null) 1 else maximumTestCaseSize.size 
    val completetestsuite = g.generate(maxTCSize)
    val reducedsuiteGT = GreedyReduction.reduce(completetestsuite, g.getTransitionReqs(), 0)
    val reducedsuiteGTP = GreedyReduction.reduce(completetestsuite, g.getTransitionPairReqs(), 1)
    val reducedsuiteART = ArtSimReduction.reduce(completetestsuite, g.getTransitionReqs(), 0)

    val tsList = #{
      '-Complete-' -> toByteArrayInputStream(
        completetestsuite, "Complete Test Suite",
        systemName, usecase.name, lastVersion.version
      ),
      '-GT-' -> toByteArrayInputStream(
        reducedsuiteGT, "Reduced (Greedy Heuristic - Transition Coverage)",
        systemName, usecase.name, lastVersion.version
      ),
      '-GTP-' -> toByteArrayInputStream(
        reducedsuiteGTP, "Reduced (Greedy Heuristic - Transition Pair Coverage)",
        systemName, usecase.name, lastVersion.version
      ),
      '-ART-' -> toByteArrayInputStream(
        reducedsuiteART, "Reduced (Adaptive Random Testing by Jaccard Distance)",
        systemName, usecase.name, lastVersion.version
      )
    }

    return tsList
  }
  
  def private static toByteArrayInputStream (
      List<GraphPath<DefaultVertex, RelationshipDirectedEdge>> testsuite, 
      String testsuitetype,
      String systemName,
      String usecaseName,
      String version
  ) {
    val workbook = XLSXExporter.export(
      testsuite,
      testsuitetype,
      systemName,
      usecaseName,
      version
    )
    val out = new ByteArrayOutputStream()
    workbook.write(out)
    return new ByteArrayInputStream(out.toByteArray)
  }
  
}
