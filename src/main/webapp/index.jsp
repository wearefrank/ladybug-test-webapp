<%@ page import="nl.nn.testtool.TestTool"%>
<%@ page import="nl.nn.testtool.MessageEncoderImpl"%>
<%@ page import="nl.nn.testtool.storage.LogStorage"%>
<%@ page import="org.springframework.web.context.WebApplicationContext"%>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@ page import="java.util.UUID"%>
<%@ page import="java.io.ByteArrayInputStream"%>
<%
ServletContext servletContext = request.getSession().getServletContext();
WebApplicationContext webApplicationContext = WebApplicationContextUtils.getWebApplicationContext(servletContext);
TestTool testTool = (TestTool)webApplicationContext.getBean("testTool");
String correlationId = UUID.randomUUID().toString();
String otherCorrelationId = UUID.randomUUID().toString();

if ("simple".equals(request.getParameter("createReport"))) {
	testTool.startpoint(correlationId, "sourceClassName", "name", "Hello World!");
	testTool.endpoint(correlationId, "sourceClassName", "name", "Goodbye World!");
}
if ("otherSimple".equals(request.getParameter("createReport"))) {
	testTool.startpoint(otherCorrelationId, "sourceClassName", "otherName", "Hello World!");
	testTool.endpoint(otherCorrelationId, "sourceClassName", "otherName", "Goodbye World!");
}
if ("waitingForThread".equals(request.getParameter("createReportInProgress"))) {
	testTool.startpoint(correlationId, "sourceClassName", "name", "message");
	testTool.threadCreatepoint(correlationId, "123");
}
if ("waitingForStream".equals(request.getParameter("createReportInProgress"))) {
	testTool.startpoint(correlationId, "sourceClassName", "name", new ByteArrayInputStream(new byte[0]));
}
if ("true".equals(request.getParameter("clearDebugStorage"))) {
	LogStorage debugStorage = (LogStorage)webApplicationContext.getBean("debugStorage");
	debugStorage.clear();
}
%>
<html>
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

  <br/>
  <a href="index.jsp?createReport=simple">Create a simple report</a><br/>
  <a href="index.jsp?createReport=otherSimple">Create another simple report</a><br/>
  <a href="index.jsp?createReportInProgress=waitingForThread">Create report in progress with Waiting for thread '123' to start...</a><br/>
  <a href="index.jsp?createReportInProgress=waitingForStream">Create report in progress with <%=MessageEncoderImpl.WAITING_FOR_STREAM_MESSAGE%></a><br/>
  <a href="index.jsp?clearDebugStorage=true">Clear debug storage</a><br/>

  <br/>
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
</html>
