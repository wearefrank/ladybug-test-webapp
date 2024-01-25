<%@ page import="java.io.*,java.util.*" %>
<%@ page import="javax.xml.transform.Result" %>
<%@ page import="javax.xml.transform.stream.StreamResult" %>
<%@ page import="javax.xml.transform.stream.StreamSource" %>
<%@ page import="org.wearefrank.xsltdebugger.trace.XalanTraceListener" %>
<%@ page import="org.springframework.web.context.WebApplicationContext" %>
<%@ page import="nl.nn.testtool.TestTool" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="org.wearefrank.xsltdebugger.XSLTTraceReporter" %>
<%@ page import="org.wearefrank.xsltdebugger.XSLTReporterSetup" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>

<%
    ServletContext servletContext = request.getSession().getServletContext();
    WebApplicationContext webApplicationContext = WebApplicationContextUtils.getWebApplicationContext(servletContext);
    TestTool testTool = (TestTool)webApplicationContext.getBean("testTool");
    String correlationId = UUID.randomUUID().toString();
    String otherCorrelationId = UUID.randomUUID().toString();

    String xmlInput = request.getParameter("xmlInput");
    String xslInput = request.getParameter("xslInput");
    String version = request.getParameter("xsltVersion");

    XSLTReporterSetup setup = new XSLTReporterSetup(xmlInput, xslInput, Integer.parseInt(version));
    setup.transform();

    String reportName;
    if(Integer.parseInt(version) == 1){
        reportName = "Xalan";
    }else{
        reportName = "Saxon";
    }

    XSLTTraceReporter.initiate(testTool, setup, correlationId, reportName);
%>

<html>
<head>
    <title>Processing Input</title>
</head>
<body>
<h2>Inputs Processed</h2>
<p>Check the console for the input values.</p>
</body>
</html>
