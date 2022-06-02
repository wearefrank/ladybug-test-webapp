<%@ page import="nl.nn.testtool.TestTool"%>
<%@ page import="nl.nn.testtool.MessageEncoderImpl"%>
<%@ page import="nl.nn.testtool.storage.LogStorage"%>
<%@ page import="org.springframework.web.context.WebApplicationContext"%>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Arrays"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.UUID"%>
<%@ page import="java.io.ByteArrayInputStream"%>
<%@ page import="java.io.Writer" %>
<%@ page import="java.io.StringWriter" %>
<%
	ServletContext servletContext = request.getSession().getServletContext();
	WebApplicationContext webApplicationContext = WebApplicationContextUtils.getWebApplicationContext(servletContext);
	TestTool testTool = (TestTool)webApplicationContext.getBean("testTool");
	String correlationId = UUID.randomUUID().toString();
	String otherCorrelationId = UUID.randomUUID().toString();
	String reportName;
	List<String> reportNames = new ArrayList<String>();

	// Create report links
	String createReportAction = request.getParameter("createReport");
	reportNames.add(reportName = "Simple report");
	if (reportName.equals(createReportAction)) {
		testTool.startpoint(correlationId, null, reportName, "Hello World!");
		testTool.endpoint(correlationId, null, reportName, "Goodbye World!");
	}
	reportNames.add(reportName = "Another simple report");
	if (reportName.equals(createReportAction)) {
		testTool.startpoint(otherCorrelationId, null, reportName, "Hello World!");
		testTool.endpoint(otherCorrelationId, null, reportName, "Goodbye World!");
	}
	reportNames.add(reportName = "Message is captured asynchronously from a character stream");
	if (reportName.equals(createReportAction)) {
		testTool.setCloseMessageCapturers(true);
		testTool.setCloseThreads(true);
		testTool.startpoint(correlationId, null, reportName, "Hello World!");
		Writer writerMessage = testTool.inputpoint(correlationId, null, "writer", new StringWriter());
		writerMessage.write("Passing by the world!");
		testTool.endpoint(correlationId, null, reportName, "Goodbye World!");
		testTool.close(correlationId);
		writerMessage.close();
	}
	reportNames.add(reportName = "Message is null");
	if (reportName.equals(createReportAction)) {
		testTool.startpoint(correlationId, null, reportName, "Hello World!");
		testTool.infopoint(correlationId, null, "Null String", null);
		testTool.setMessageEncoder(testTool.getMessageEncoder());
		testTool.endpoint(correlationId, null, reportName, "Goodbye World!");
	}
	reportNames.add(reportName = "Message is an empty string");
	if (reportName.equals(createReportAction)) {
		testTool.startpoint(correlationId, null, reportName, "Hello World!");
		testTool.infopoint(correlationId, null, "Empty String", "");
		testTool.setMessageEncoder(testTool.getMessageEncoder());
		testTool.endpoint(correlationId, null, reportName, "Goodbye World!");
	}
	reportNames.add(reportName = "Message encoded using Base64");
	if (reportName.equals(createReportAction)) {
		byte[] message = new byte[6];
		// Two bytes for ë in UTF-8
		message[0] = (byte)195;
		message[1] = (byte)171;
		// Two bytes for © in UTF-8
		message[2] = (byte)194;
		message[3] = (byte)169;
		// One byte for ë in ISO-8859-1
		message[4] = (byte)235;
		// One byte for © in ISO-8859-1
		message[5] = (byte)169;
		// The last two bytes cannot be encoded in UTF-8 so Ladybug will use Base64 instead
		testTool.startpoint(correlationId, null, reportName, message);
		// Remove last two bytes so message can be encoded using UTF-8 by Ladybug
		message = Arrays.copyOf(message, 4);
		testTool.infopoint(correlationId, null, reportName, message);
		// Test Unicode supplementary characters with a smiley :)
		message[0] = (byte)240;
		message[1] = (byte)159;
		message[2] = (byte)152;
		message[3] = (byte)138;
		testTool.endpoint(correlationId, null, reportName, message);
	}
	reportNames.add(reportName = "Waiting for thread to start");
	if (reportName.equals(createReportAction)) {
		testTool.startpoint(correlationId, null, reportName, "message");
		testTool.threadCreatepoint(correlationId, "123");
	}
	reportNames.add(reportName = "Waiting for message to be captured");
	if (reportName.equals(createReportAction)) {
		testTool.startpoint(correlationId, null, reportName, new ByteArrayInputStream(new byte[0]));
	}

	// Other actions
	if ("true".equals(request.getParameter("clearDebugStorage"))) {
		LogStorage debugStorage = (LogStorage)webApplicationContext.getBean("debugStorage");
		debugStorage.clear();
	}
	if (request.getParameter("removeReportInProgress") != null) {
		int nr = Integer.valueOf(request.getParameter("removeReportInProgress"));
		testTool.removeReportInProgress(nr -1);
	}
%>
<html>

  <h1>Browse</h1>

  <a href="testtool">Old Echo2 GUI</a><br/>

  <br/>

  <a href="ladybug">New Angular GUI</a><br/>
  <a href="http://localhost:4200">New Angular GUI using Node.js</a><br/>

  <br/>

  <a href="ladybug/api/testtool">TestTool API</a><br/>
  <a href="http://localhost:4200/api/testtool">TestTool API proxied by Node.js</a><br/>

  <br/>

  <a href="ladybug/api/metadata">Metadata API</a><br/>
  <a href="http://localhost:4200/api/metadata">Metadata API proxied by Node.js</a><br/>

  <br/>

  <a href="https://github.com/ibissource/ibis-ladybug/tree/master/src/main/java/nl/nn/testtool/web/api">More API info</a><br/>


  <h1>Create report</h1>

  <% for (String name : reportNames) { %>
  <a href="index.jsp?createReport=<%=name%>"><%=name%></a><br/>
  <% } %>


  <h1>Other actions</h1>

  <a href="index.jsp?clearDebugStorage=true">Clear debug storage</a><br/>
  <a href="index.jsp?removeReportInProgress=1">Remove report in progress number 1</a><br/>


  <h1>Debug info</h1>

  Name: <%= testTool.getName() %><br/>
  Version: <%= testTool.getVersion() %><br/>
  SpecificationVersion: <%= testTool.getSpecificationVersion() %><br/>
  ImplementationVersion: <%= testTool.getImplementationVersion() %><br/>
  ConfigName: <%= testTool.getConfigName() %><br/>
  ConfigVersion: <%= testTool.getConfigVersion() %><br/>

  <br/>

  ReportGeneratorEnabled: <%= testTool.isReportGeneratorEnabled() %><br/>
  RegexFilter: <%= testTool.getRegexFilter() %><br/>

  <br/>

  NumberOfReportsInProgress: <%= testTool.getNumberOfReportsInProgress() %><br/>
  ReportsInProgressEstimatedMemoryUsage: <%= testTool.getReportsInProgressEstimatedMemoryUsage() %><br/>

  <br/>

  DebugStorage: <%= testTool.getDebugStorage() %><br/>
  DebugStorage size: <%= testTool.getDebugStorage().getSize() %><br/>
  TestStorage: <%= testTool.getTestStorage() %><br/>
  TestStorage size: <%= testTool.getTestStorage().getSize() %><br/>

  <br/>

  Debugger: <%= testTool.getDebugger() %><br/>
  Rerunner: <%= testTool.getRerunner() %><br/>

  <br/>

  Views: <%= testTool.getViews() %><br/>
  StubStrategies: <%= testTool.getStubStrategies() %><br/>
  DefaultStubStrategy: <%= testTool.getDefaultStubStrategy() %><br/>
  MatchingStubStrategiesForExternalConnectionCode: <%= testTool.getMatchingStubStrategiesForExternalConnectionCode() %><br/>

  <br/>

  MaxCheckpoints: <%= testTool.getMaxCheckpoints() %><br/>
  MaxMemoryUsage: <%= testTool.getMaxMemoryUsage() %><br/>
  MaxMessageLength: <%= testTool.getMaxMessageLength() %><br/>

  <br/>

  MessageTransformer: <%= testTool.getMessageTransformer() %><br/>
  MessageEncoder: <%= testTool.getMessageEncoder() %><br/>
  MessageCapturer: <%= testTool.getMessageCapturer() %><br/>
  CloseMessageCapturers: <%= testTool.isCloseMessageCapturers() %><br/>
  CloseThreads: <%= testTool.isCloseThreads() %><br/>

  <br/>

  SecurityLog: <%= testTool.getSecurityLog() %><br/>

  <br/>

  Default charset: <%= java.nio.charset.Charset.defaultCharset() %><br/>
  File encoding: <%= System.getProperty("file.encoding") %><br/>

</html>
