package nl.nn.testtool.test.webapp;

import lombok.Setter;
import nl.nn.testtool.Report;
import nl.nn.testtool.Rerunner;
import nl.nn.testtool.SecurityContext;
import nl.nn.testtool.TestTool;
import nl.nn.testtool.run.ReportRunner;

public class SimpleRerunner implements Rerunner {
	@Setter TestTool testTool;

	@Override
	public String rerun(String correlationId, Report originalReport,
			SecurityContext securityContext, ReportRunner reportRunner) {
		testTool.startpoint(correlationId, this.getClass().getName(), "test", "Hello World!");
		testTool.endpoint(correlationId, this.getClass().getName(), "test", "Goodbye World!");
		return null;
	}

}
