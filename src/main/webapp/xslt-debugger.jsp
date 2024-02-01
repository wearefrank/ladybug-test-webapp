<%@ page import="java.io.*,java.util.*" %>
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

    String xmlInput = request.getParameter("xmlInput");
    String xslInput = request.getParameter("xslInput");
    String version = request.getParameter("xsltVersion");

    XSLTReporterSetup setup = new XSLTReporterSetup(xmlInput, xslInput, Integer.parseInt(version));
    try {
        setup.transform();
    }catch (Exception e){
        response.sendRedirect("error-page.jsp");
    }

    String reportName;
    if(Integer.parseInt(version) == 1){
        reportName = "Xalan";
    }else{
        reportName = "Saxon";
    }

    XSLTTraceReporter.initiate(testTool, setup, correlationId, reportName);
//    response.sendRedirect("/testtool");
%>

<html>
<head>
    <link rel="stylesheet" type="text/css" href="css/styles.css">
    <title>Processing Input</title>
</head>
<body>
<h1>This is a heading</h1>
<p class="paragraph">This is a paragraph with a specific class.</p>
</body>
</html>
