package nl.nn.testtool.test.webapp;

import nl.nn.testtool.TestTool;

public class ComplexReports {
	private ComplexReports() {
	}

	public static void fillComplexSuccessReport(String correlationId, String reportName, TestTool testTool) {
		testTool.startpoint(correlationId, null, reportName, "Input message of parent");
		testTool.infopoint(correlationId, null, reportName, "Information about the parent");
		testTool.inputpoint(correlationId, null, "Name of first input of parent", "Value of first input of parent");
		testTool.inputpoint(correlationId, null, "Name of second input of parent", "Value of second input of parent");
		testTool.startpoint(correlationId, null, "First child", "Value of first child");
		testTool.infopoint(correlationId, null, "First child", "Info about first child");
		testTool.inputpoint(correlationId, null, "First input of first child", "Value of first input of first child");
		testTool.outputpoint(correlationId, null, "First output of first child", "Value of first output of first child");
		testTool.endpoint(correlationId, null, "First child", "Output value of first child");
		testTool.outputpoint(correlationId, null, "First output of first child", "Value of first output of first child");
		testTool.endpoint(correlationId, null, reportName, "Output message of parent");
	}

	public static void fillComplexErrorReport(String correlationId, String reportName, TestTool testTool) {
		testTool.startpoint(correlationId, null, reportName, "Parent");
		testTool.infopoint(correlationId, null, reportName, "Information about the parent");
		testTool.inputpoint(correlationId, null, reportName, "First input of parent");
		testTool.inputpoint(correlationId, null, reportName, "Second input of parent");
		testTool.startpoint(correlationId, null, reportName, "First child");
		testTool.infopoint(correlationId, null, reportName, "Info about first child");
		testTool.inputpoint(correlationId, null, reportName, "First input of first child");
		testTool.outputpoint(correlationId, null, reportName, "First output of first child");
		testTool.abortpoint(correlationId, null, reportName, "First child");
		testTool.abortpoint(correlationId, null, reportName, "Parent");
	}
}
