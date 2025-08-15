package nl.nn.testtool.web;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.multipart.MultipartResolver;
import org.springframework.web.multipart.support.StandardServletMultipartResolver;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;

@Configuration
@EnableWebMvc
public class TestWebappConfiguration {
    @Bean
    MultipartResolver multipartResolver() {
        return new StandardServletMultipartResolver();
    }
}
