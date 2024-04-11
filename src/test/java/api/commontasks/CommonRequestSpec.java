package api.commontasks;

import io.restassured.builder.RequestSpecBuilder;
import io.restassured.specification.RequestSpecification;
import net.serenitybdd.core.environment.EnvironmentSpecificConfiguration;
import net.thucydides.core.guice.Injectors;
import net.thucydides.core.util.EnvironmentVariables;

public class CommonRequestSpec {
  /**
   * Get Request Specification for Message endpoint
   *
   * @return RequestSpecification
   */
  public static RequestSpecification sendRequest(String ServiceName) {
    EnvironmentVariables environmentVariables = Injectors.getInjector()
        .getInstance(EnvironmentVariables.class);

    String baseUrl = EnvironmentSpecificConfiguration.from(environmentVariables)
        .getProperty("BASEURL_"+ServiceName);

    return new RequestSpecBuilder().setBaseUri(baseUrl)
        .setContentType("application/json")
        .build();
  }
}
