<%@ page import="nl.nn.testtool.TestTool"%>
<%@ page import="nl.nn.testtool.MessageEncoderImpl"%>
<%@ page import="org.springframework.web.context.WebApplicationContext"%>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@ page import="java.util.UUID"%>
<%@ page import="java.io.ByteArrayInputStream"%>
<%
ServletContext servletContext = request.getSession().getServletContext();
WebApplicationContext webApplicationContext = WebApplicationContextUtils.getWebApplicationContext(servletContext);
TestTool testTool = (TestTool)webApplicationContext.getBean("testTool");
String correlationId = UUID.randomUUID().toString();
if ("waitingForThread".equals(request.getParameter("createReportInProgress"))) {
	testTool.startpoint(correlationId, "sourceClassName", "name", "message");
	testTool.threadCreatepoint(correlationId, "123");
}
if ("waitingForStream".equals(request.getParameter("createReportInProgress"))) {
	testTool.startpoint(correlationId, "sourceClassName", "name", new ByteArrayInputStream(new byte[0]));
}
%>
<html>
  <a href="testtool">Old Echo2 GUI</a>

  <br/>
  <br/>
  <a href="ladybug">New Angular GUI</a>
  <br/>
  <a href="http://localhost:4200">New Angular GUI using Node.js</a>

  <br/>
  <br/>
  <a href="ladybug/api/testtool">TestTool API</a>
  <br/>
  <a href="http://localhost:4200/api/testtool">TestTool API proxied by Node.js</a>

  <br/>
  <br/>
  <a href="ladybug/api/metadata">Metadata API</a>
  <br/>
  <a href="http://localhost:4200/api/metadata">Metadata API proxied by Node.js</a>

  <br/>
  <br/>
  <a href="https://github.com/ibissource/ibis-ladybug/tree/master/src/main/java/nl/nn/testtool/web/api">More API info</a>

  <br/>
  <br/>
  <a href="index.jsp?createReportInProgress=waitingForThread">Create report in progress with Waiting for thread '123' to start...</a>
  <br/>
  <a href="index.jsp?createReportInProgress=waitingForStream">Create report in progress with <%=MessageEncoderImpl.WAITING_FOR_STREAM_MESSAGE%></a>
</html>
