package app;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;
import springfox.documentation.swagger2.annotations.EnableSwagger2;

@SpringBootApplication
@EnableSwagger2
@ComponentScan
public class Application {

	static Logger log = LogManager.getLogger(Application.class);
	public static void main(String[] args) {
		log.info("Welcome In CAFU Functional Automation Service info");
		log.trace("Welcome In CAFU Functional Automation Service trace");
		log.debug("Welcome In CAFU Functional Automation Service debug");
		SpringApplication.run(Application.class, args);
	}
}
