package api.commontasks;

import io.restassured.path.json.JsonPath;
import io.restassured.response.Response;
import net.serenitybdd.core.Serenity;
import net.thucydides.core.annotations.Step;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.junit.Assert;
import static io.restassured.module.jsv.JsonSchemaValidator.matchesJsonSchemaInClasspath;
import static org.assertj.core.api.AssertionsForClassTypes.assertThat;


public class CommonQuestions {

    static Logger log = LogManager.getLogger(CommonQuestions.class.getName());

    @Step("Verify that API response is {0}")
    public void responseCodeIs(int responseCode, Response lastResponse) {
        assertThat(lastResponse.statusCode()).isEqualTo(responseCode);
    }

    @Step("Verify that API response is {0}")
    public void responseCodeIs(int responseCode, int alterResponseCode, Response lastResponse) {
        boolean condition = lastResponse.statusCode() == responseCode || lastResponse.statusCode() == alterResponseCode;
        assertThat(condition).isEqualTo(true);
    }

    @Step("Verify that response is empty list")
    public void responseShouldBeEmptyList(Response lastResponse) {
        assertThat(lastResponse.getBody().jsonPath().getList("").size()).isEqualTo(0);
    }

    @Step("Verify that responseBody Should not empty")
    public void responseShouldNotBeEmpty(Response lastResponse) {
        assertThat(lastResponse.getBody().asString().length()).isNotEqualTo(0);
    }

    @Step("Verify that responseBody Should Contains")
    public void responseShouldContains(Response lastResponse, String expectedValue) {
        if (!lastResponse.getBody().asString().contains(expectedValue)) {
            Assert.fail("FAIL! Expected Value <" + expectedValue + "> Not Found in Response Body!");
        }
    }

    @Step("Verify that responseBody Should be empty")
    public void responseShouldBeEmpty(Response lastResponse) {
        assertThat(lastResponse.getBody().asString().length()).isEqualTo(0);
    }

    @Step("Verify Response Message")
    public void verifyResponseMessage(Response lastResponse, String expectedResponseMessage) {
        String response = lastResponse.getBody().asString();
        assertThat(response).contains(expectedResponseMessage);
    }

    @Step("Verify response schema with {1}")
    public void verifyResponseSchema(Response lastResponse, String schemaFilPath) {
        lastResponse.then().body(matchesJsonSchemaInClasspath(
                schemaFilPath));
    }

    @Step("Get Response Body Values with Json Expression")
    public String getResponseBodyValue(Response lastResponse, String value) {
        String getActualValue;
        try {
            getActualValue = lastResponse.getBody().jsonPath().getString(value).trim();
            log.debug("Get [ActualValue] From Response Body : \n " + getActualValue);
        } catch (Exception e) {
            try {
                JsonPath jsonPath = new JsonPath(Serenity.getCurrentSession().get("ResponseBody").toString());
                getActualValue = jsonPath.getString(value);
            } catch (Exception ex) {
                log.error("ERROR! ActualValue From Response Body is null!");
                getActualValue = null;
            }
            log.debug("Get [ActualValue] From Response Body" + getActualValue);
        }
        return getActualValue;
    }

    @Step("Verify Contains Values from Response Body")
    public void checkContains(String value, String expectedValue, String message) {
        if (!value.trim().contains(expectedValue.trim())) {
            Assert.fail("FAIL:" + message + "With the expectedValue value " + expectedValue.trim() + " doesn't contains Actual " + value.trim());
        }
    }

    @Step("Verify that responseBody Should not empty with Expression")
    public void responseShouldNotBeEmptyWithExpression(String expectedValue) {
        assertThat(expectedValue.length()).isNotEqualTo(0);
    }

    @Step("Verify that responseBody Should be empty with Expression")
    public void responseShouldBeEmptyWithExpression(String expectedValue) {
        assertThat(expectedValue.length()).isEqualTo(0);
    }

    @Step("Verify Exact Matched Values from Response Body")
    public void checkExactMatch(String value, String expectedValue, String message) {
        if (!value.trim().equals(expectedValue.trim())) {
            Assert.fail("FAIL:" + message + "With the value <" + value + "> doesn't Exact Matched " + expectedValue);
        }
    }

    @Step("Verify not Exact Matched Values from Response Body")
    public void checkNotExactMatch(String value, String expectedValue, String message) {
        if (value.trim().equals(expectedValue.trim())) {
            Assert.fail("FAIL:" + message + "With the value <" + value + "> does Exact Matched " + expectedValue);
        }
    }

    @Step("Get Response header value as a String")
    public String getResponseHeaderValue(Response lastResponse, String headerName) {
        String responseHeaderValue;
        responseHeaderValue = lastResponse.getHeader(headerName);
        if (responseHeaderValue != null)
            log.debug(String.format("Response Header %s  = %s ", headerName, responseHeaderValue));
        else
            log.debug(String.format("Response Header %s is not available in Response !", headerName));
        return responseHeaderValue;
    }
}