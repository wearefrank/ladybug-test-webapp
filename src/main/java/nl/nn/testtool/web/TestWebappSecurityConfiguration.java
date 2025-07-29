package nl.nn.testtool.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.security.web.SecurityFilterChain;

import nl.nn.testtool.web.api.SomeBean;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import org.springframework.security.web.util.matcher.RequestMatcher;

import java.io.IOException;

@Configuration
@EnableWebSecurity
public class TestWebappSecurityConfiguration {
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        System.out.println("Method TestWebappSecurityConfiguration#securityFilterChain() called");

        RequestMatcher securityRequestMatcher = new AntPathRequestMatcher("/**");

        // Endpoints on which the SecurityFilterChain (filter) will match, also for OPTIONS requests!
        // This does not authenticate the user, but only means the filter will be triggered.
        http.securityMatcher(securityRequestMatcher);

        // Enables security for all servlet endpoints
        http.authorizeHttpRequests(requests -> requests.requestMatchers(securityRequestMatcher).authenticated());

        // Uses a BasicAuthenticationEntryPoint to force users to log in
        http.httpBasic(basic -> basic.realmName("Frank"));

        UserDetails observerUser = User.builder()
                .username("observer")
                .password("{noop}observer")
                .roles("IbisObserver")
                .build();
        UserDetails dataAdminUser = User.builder()
                .username("dataAdmin")
                .password("{noop}dataAdmin")
                .roles("IbisDataAdmin")
                .build();
        UserDetails adminUser = User.builder()
                .username("admin")
                .password("{noop}admin")
                .roles("IbisAdmin")
                .build();
        UserDetails testerUser = User.builder()
                .username("tester")
                .password("{noop}tester")
                .roles("IbisTester")
                .build();
        // Create an UserDetailsManager without any users.
        InMemoryUserDetailsManager udm = new InMemoryUserDetailsManager(observerUser, dataAdminUser, adminUser, testerUser);
        http.userDetailsService(udm);

        return http.build();
    }

    private static class Http401EntryPoint implements AuthenticationEntryPoint {

        @Override
        public void commence(HttpServletRequest request, HttpServletResponse response, AuthenticationException authException) throws IOException, ServletException {
            // Block all requests
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Access Denied, configure an authenticator to enable web access.");
        }
    }

    @Bean
    SomeBean hello() {
        return new SomeBean();
    }
}
