<%@ page import="java.io.*,java.util.*" %>
<%@ page import="javax.xml.transform.Result" %>
<%@ page import="javax.xml.transform.stream.StreamResult" %>
<%@ page import="javax.xml.transform.stream.StreamSource" %>
<%@ page import="org.wearefrank.xsltdebugger.trace.XalanTraceListener" %>
<%@ page import="org.springframework.web.context.WebApplicationContext" %>
<%@ page import="nl.nn.testtool.TestTool" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="org.wearefrank.xsltdebugger.XSLTTraceReporter" %>
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

    XalanTraceListener traceListener = new XalanTraceListener();

    traceListener.m_traceElements = true;
    traceListener.m_traceTemplates = true;
    traceListener.m_traceGeneration = true;
    traceListener.m_traceSelection = true;

    StringWriter writer = new StringWriter();
    Result result = new StreamResult(writer);

    StreamSource xmlSource = new StreamSource(new StringReader(xmlInput));
    StreamSource xslSource = new StreamSource(new StringReader(xslInput));

    try {
        org.apache.xalan.processor.TransformerFactoryImpl transformerFactory = new org.apache.xalan.processor.TransformerFactoryImpl();
        org.apache.xalan.transformer.TransformerImpl transformer = (org.apache.xalan.transformer.TransformerImpl) transformerFactory.newTransformer(xslSource);
        transformer.getTraceManager().addTraceListener(traceListener);
        transformer.transform(xmlSource, result);

        writer.close();
    } catch (Exception e) {
        throw new RuntimeException(e);
    }
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
