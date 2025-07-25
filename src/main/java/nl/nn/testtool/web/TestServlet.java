package nl.nn.testtool.web;

import java.io.IOException;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.WebApplicationContext;

import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.mvc.method.RequestMappingInfo;
import org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerMapping;

public class TestServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private WebApplicationContext applicationContext;

    @Override
    public void init() throws ServletException {
        super.init();
        ApplicationContext ctx = (ApplicationContext) getServletContext().getAttribute(
                WebApplicationContext.ROOT_WEB_APPLICATION_CONTEXT_ATTRIBUTE);
        this.applicationContext = (WebApplicationContext) ctx;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Log a message to the console
        System.out.println("TestServlet: Received a GET request.");

        RequestMappingHandlerMapping requestMappings = applicationContext.getBean(RequestMappingHandlerMapping.class);
        Map<RequestMappingInfo, HandlerMethod> handlers = requestMappings.getHandlerMethods();
        handlers.forEach((mappingInfo, handler) -> {
            System.out.println(String.format("  %s: %s", mappingInfo.toString(), handler.toString()));
        });

        // Set response content type
        response.setContentType("text/html");
        response.getWriter().println("<h1>LogServlet</h1><p>Check the console for log messages.</p>");
    }
}