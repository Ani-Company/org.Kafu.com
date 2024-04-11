package api.commontasks;

import app.utilities.CommonHelpers;
import app.utilities.PropertiesManager;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.github.javafaker.Faker;
import com.jayway.jsonpath.JsonPath;
import io.cucumber.java.After;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import net.serenitybdd.core.Serenity;
import net.serenitybdd.rest.SerenityRest;
import net.thucydides.core.annotations.Steps;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.eclipse.jetty.util.log.Log;
import org.json.JSONException;
import org.json.JSONObject;
import org.junit.Assert;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.util.*;
import java.util.concurrent.TimeUnit;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Stream;

import static app.utilities.CommonHelpers.*;
import static net.serenitybdd.rest.SerenityRest.lastResponse;

public class CommonSteps {
    static Logger log = LogManager.getLogger(CommonSteps.class.getName());
    private final List<List<String>> alistOfHeaders = new ArrayList<>();
    private final List<List<String>> alistOfFormParams = new ArrayList<>();
    private final List<List<String>> alistOfMultiPartFiles = new ArrayList<>();

    public enum SpecialBody {WHITE_SPACE, RANDOM_STRING}

    @Steps
    CommonQuestions commonQuestions;
    @Steps
    CommonActions commonActions;

    @After
    private void close() {
        System.out.println("Close!");
    }

    @When("I call the POST Request service {string} endpoint {string} with Variable {string} and Parameter {string} with Body and idempotency key")
    public void iCallThePOSTRequestServiceStringEndpointStringWithVariableStringAndParameterStringWithBodyAndIdempotencyKey(String serviceName, String serviceUri,
                                                                                                                            String variable, String parameters) {
        log.debug("iCallThePOSTRequestServiceStringEndpointStringWithVariableStringAndParameterStringWithBodyAndIdempotencyKey()");
        parameters = "/" + generateUUID() + parameters;
        prepareUriForServiceRequest(serviceName, serviceUri, variable, parameters);
        alistOfHeaders.add((Arrays.asList("Idempotency-Key", generateUUID())));
        if (Serenity.getCurrentSession().get("body") != null) {
            commonActions.sendPostRequest(Serenity.getCurrentSession().get("serviceName").toString(),
                    Serenity.getCurrentSession().get("uri").toString(),
                    alistOfHeaders,
                    Serenity.getCurrentSession().get("body").toString());

        } else {
            commonActions.sendPostRequest(Serenity.getCurrentSession().get("serviceName").toString(),
                    Serenity.getCurrentSession().get("uri").toString(),
                    alistOfHeaders);
        }
        alistOfHeaders.clear();
    }

    @When("I call the POST Request service {string} endpoint {string} with Variable {string} and Parameter {string} with Body and idempotency key for transaction")
    public void iCallThePOSTRequestServiceStringEndpointStringWithVariableStringAndParameterStringWithBodyAndIdempotencyKeyForTransaction(String serviceName, String serviceUri,
                                                                                                                                          String variable, String parameters) {
        log.debug("iCallThePOSTRequestServiceStringEndpointStringWithVariableStringAndParameterStringWithBodyAndIdempotencyKey()");
        prepareUriForServiceRequest(serviceName, serviceUri, variable, parameters);
        alistOfHeaders.add((Arrays.asList("Idempotency-Key", generateUUID())));
        if (Serenity.getCurrentSession().get("body") != null) {
            commonActions.sendPostRequest(Serenity.getCurrentSession().get("serviceName").toString(),
                    Serenity.getCurrentSession().get("uri").toString(),
                    alistOfHeaders,
                    Serenity.getCurrentSession().get("body").toString());

        } else {
            commonActions.sendPostRequest(Serenity.getCurrentSession().get("serviceName").toString(),
                    Serenity.getCurrentSession().get("uri").toString(),
                    alistOfHeaders);
        }
        alistOfHeaders.clear();
    }

    @Given("I prepare the request headers with form param key {string} and value {string}")
    public void iPrepareTheRequestHeadersWithFormParamKeyAndValue(String key, String value) {
        alistOfFormParams.add((Arrays.asList(key, value)));
    }

    @Given("I prepare the request headers with form param key {string} and variable {string}")
    public void iPrepareTheRequestHeadersWithFormParamKeyAndVariable(String key, String variable) {
        log.debug("iPrepareTheRequestHeadersWithFormParamKeyAndVariable");
        alistOfFormParams.add((Arrays.asList(key, (String) Serenity.getCurrentSession().get(variable))));
    }

    @When("I call the POST Request service {string} endpoint {string} with Variable {string}, Parameter {string} and form params")
    public void iCallThePOSTRequestServiceEndpointWithVariableParameterAndFormParams(String serviceName, String serviceUri, String variable, String parameters) {
        log.debug("iCallThePOSTRequestServiceEndpointWithVariableParameterAndFormParams()");
        prepareUriForServiceRequest(serviceName, serviceUri, variable, parameters);
        commonActions.sendPostRequest(Serenity.getCurrentSession().get("serviceName").toString(),
                Serenity.getCurrentSession().get("uri").toString(),
                alistOfHeaders,
                alistOfFormParams,
                alistOfMultiPartFiles);

        alistOfHeaders.clear();
        alistOfFormParams.clear();
        alistOfMultiPartFiles.clear();
    }

    @And("Convert HTML Response to JSON")
    public void ConvertHtmlResponseToJson() {
        commonActions.convertHtmlToJson();
        log.debug("ConvertHtmlResponseToJson() " + Serenity.getCurrentSession().get("ResponseBody").toString());
    }

    @Given("I prepare the request with multipart file {string} from {string} and type {string}")
    public void iPrepareTheRequestWithMultipartFileFromAndType(String name, String location, String type) {
        location = Objects.requireNonNull(getClass().getClassLoader().getResource(location)).getPath();
        alistOfMultiPartFiles.add((Arrays.asList(name, location, type)));
    }

    @Then("Response Code should be {int}")
    public void responseCodeShouldBe(int arg0) {
        commonQuestions.responseCodeIs(arg0, lastResponse());
    }

    @Then("Alphabetical Order should be {string} and {string}")
    public void checkAlphabeticalOrder(String arg0, String arg1) {
        String value1 = Serenity.sessionVariableCalled(arg0).toString();
        String value2 = Serenity.sessionVariableCalled(arg1).toString();
        int compare = value1.toLowerCase().compareTo(value2.toLowerCase());
        String condition = "false";
        log.debug(value1);
        log.debug(value2);
        log.debug(compare);
        if (compare < 0 || compare == 0) {
            condition = "true";
        } else {
            condition = "false";
        }
        commonQuestions.checkExactMatch("true", condition, "Alphabetical Order MisMatches - " + value1 + " and " + value2 + " and its condition value - " + condition + " and its compare value - " + compare);
    }

    @Then("Response Code should be either {int} OR {int}")
    public void responseCodeShouldBe(int arg0, int arg1) {
        commonQuestions.responseCodeIs(arg0, arg1, lastResponse());
    }

    @When("I call the GET Request for service {string} endpoint {string} with Variable {string} and other parameters {string}")
    public void iCallTheServiceEndpointWithParametersWithVariables(String serviceName, String serviceUri, String variable, String parameters) {
        log.debug("iCallTheServiceEndpointWithParametersWithVariables");
        prepareUriForServiceRequest(serviceName, serviceUri, variable, parameters);
        commonActions.sendGetRequest(serviceName, Serenity.getCurrentSession().get("uri").toString(), alistOfHeaders);
        alistOfHeaders.clear();
    }

    @When("I call the GET Request for service {string} endpoint {string} with Variable {string} and other parameters {string} , query params from serenity session")
    public void iCallTheGETRequestForServiceEndpointWithVariableAndOtherParametersQueryParamsFromSerenitySession(String serviceName, String serviceUri, String variable, String parameters) {
        log.debug("iCallTheGETRequestForServiceEndpointWithVariableAndOtherParametersQueryParamsFromSerenitySession");
        prepareUriForServiceRequest(serviceName, serviceUri, variable, parameters);
        String uri = Serenity.getCurrentSession().get("uri").toString();
        String queryParamsStringFromSerenitySession = (String) Serenity.getCurrentSession().getOrDefault("queryParamsString", "");
        if (!queryParamsStringFromSerenitySession.isEmpty()) {
            if (uri.contains("?"))
                uri = uri + "&" + queryParamsStringFromSerenitySession;
            else
                uri = uri + "?" + queryParamsStringFromSerenitySession;
        }
        commonActions.sendGetRequest(serviceName, uri, alistOfHeaders);
        alistOfHeaders.clear();
    }

    @When("I call the GET Request for service {string} endpoint {string} with Variable {string} and other parameters {string} Without Lang Header")
    public void iCallTheGETRequestForServiceEndpointWithVariableAndOtherParametersQueryParamsWithOutAcceptLanguageHeaderFromSerenitySession(String serviceName, String serviceUri, String variable, String parameters) {
        log.debug("iCallTheGETRequestForServiceEndpointWithVariableAndOtherParametersQueryParamsFromSerenitySession");
        prepareUriForServiceRequest(serviceName, serviceUri, variable, parameters);
        String uri = Serenity.getCurrentSession().get("uri").toString();
        String queryParamsStringFromSerenitySession = (String) Serenity.getCurrentSession().getOrDefault("queryParamsString", "");
        if (!queryParamsStringFromSerenitySession.isEmpty()) {
            if (uri.contains("?"))
                uri = uri + "&" + queryParamsStringFromSerenitySession;
            else
                uri = uri + "?" + queryParamsStringFromSerenitySession;
        }
        commonActions.sendGetRequestWithOutAcceptLanguageHeader(serviceName, uri, alistOfHeaders);
        alistOfHeaders.clear();
    }

    public void prepareUriForServiceRequest(String serviceName, String serviceUri,
                                            String variable, String parameters) {
        if (alistOfHeaders.isEmpty()) {
            try {
                alistOfHeaders.add((Arrays.asList(Serenity.getCurrentSession().get("headersKey").toString(),
                        Serenity.getCurrentSession().get("headersValue").toString())));
            } catch (Exception e) {
                Serenity.setSessionVariable("headersKey").to("Content-Type");
                Serenity.setSessionVariable("headersValue").to("application/json");
                alistOfHeaders.add((Arrays.asList(Serenity.getCurrentSession().get("headersKey").toString(),
                        Serenity.getCurrentSession().get("headersValue").toString())));
            }
        }

        String uri = PropertiesManager.getProperty(serviceUri, PropertiesManager.prefix.ENVIRONMENT);

        if (!variable.isEmpty()) {
            variable = "/" + getVariableStringFromResponseBody(variable);
            uri = PropertiesManager.getProperty(serviceUri, PropertiesManager.prefix.ENVIRONMENT) + variable + parameters;
        } else {
            uri = uri + variable + parameters;
        }
        Serenity.setSessionVariable("serviceName").to(serviceName);
        Serenity.setSessionVariable("uri").to(uri);
    }

    @When("I call the POST Request service {string} endpoint {string} with Variable {string} and Parameter {string} with Body")
    public void iCallThePOSTRequestServiceServiceNameEndpointServiceUriWithParametersAndOtherParameters(String serviceName, String serviceUri,
                                                                                                        String variable, String parameters) {
        log.debug("iCallThePOSTRequestServiceServiceNameEndpointServiceUriWithParametersAndOtherParameters()");
        prepareUriForServiceRequest(serviceName, serviceUri, variable, parameters);
        try {
            if (Serenity.getCurrentSession().get("body") != null) {
                commonActions.sendPostRequest(Serenity.getCurrentSession().get("serviceName").toString(),
                        Serenity.getCurrentSession().get("uri").toString(),
                        alistOfHeaders,
                        Serenity.getCurrentSession().get("body").toString());

            } else {
                commonActions.sendPostRequest(Serenity.getCurrentSession().get("serviceName").toString(),
                        Serenity.getCurrentSession().get("uri").toString(),
                        alistOfHeaders);
            }
            alistOfHeaders.clear();
        } catch (Exception e) {
            log.error("ERROR In Post()" + e.getMessage());
        }
    }


    @When("I call the POST Request service {string} endpoint {string} with Variables in path {string} and Parameter {string} with Body")
    public void iCallThePOSTRequestServiceServiceNameEndpointServiceUriWithVarialbesInPathParametersAndOtherParameters(String serviceName, String serviceUri,
                                                                                                                       String pathWithVariables, String parameters) {
        log.debug("iCallThePOSTRequestServiceServiceNameEndpointServiceUriWithVariablesInPathParametersAndOtherParameters()");
        if (pathWithVariables.startsWith("/"))
            pathWithVariables = pathWithVariables.substring(1);
        StringBuilder pathParams = new StringBuilder();
        String[] tokens = pathWithVariables.split("/");
        for (String token : tokens) {
            pathParams.append("/").append(Serenity.getCurrentSession().getOrDefault(token, token));
        }
        parameters = pathParams + parameters;
        prepareUriForServiceRequest(serviceName, serviceUri, "", parameters);
        if (Serenity.getCurrentSession().get("body") != null) {
            commonActions.sendPostRequest(Serenity.getCurrentSession().get("serviceName").toString(),
                    Serenity.getCurrentSession().get("uri").toString(),
                    alistOfHeaders,
                    Serenity.getCurrentSession().get("body").toString());

        } else {
            commonActions.sendPostRequest(Serenity.getCurrentSession().get("serviceName").toString(),
                    Serenity.getCurrentSession().get("uri").toString(),
                    alistOfHeaders);
        }
        alistOfHeaders.clear();
    }

    @When("I call the DELETE Request service {string} endpoint {string} with Variables in path {string} and Parameter {string} with Body")
    public void iCallTheDELETERequestServiceServiceNameEndpointServiceUriWithVarialbesInPathParametersAndOtherParameters(String serviceName, String serviceUri,
                                                                                                                         String pathWithVariables, String parameters) {
        log.debug("iCallTheDELETERequestServiceServiceNameEndpointServiceUriWithVariablesInPathParametersAndOtherParameters()");
        if (pathWithVariables.startsWith("/"))
            pathWithVariables = pathWithVariables.substring(1);
        StringBuilder pathParams = new StringBuilder();
        String[] tokens = pathWithVariables.split("/");
        for (String token : tokens) {
            pathParams.append("/").append(Serenity.getCurrentSession().getOrDefault(token, token));
        }
        parameters = pathParams + parameters;
        prepareUriForServiceRequest(serviceName, serviceUri, "", parameters);
        if (Serenity.getCurrentSession().get("body") != null) {
            commonActions.sendDeleteRequestWithRequestBody(Serenity.getCurrentSession().get("serviceName").toString(),
                    Serenity.getCurrentSession().get("uri").toString(),
                    alistOfHeaders,
                    Serenity.getCurrentSession().get("body").toString());

        } else {
            commonActions.sendDeleteRequest(Serenity.getCurrentSession().get("serviceName").toString(),
                    Serenity.getCurrentSession().get("uri").toString(),
                    alistOfHeaders);
        }
        alistOfHeaders.clear();
    }

    @When("I call the PATCH Request service {string} endpoint {string} with Variables in path {string} and Parameter {string} with Body")
    public void iCallThePATCHRequestServiceServiceNameEndpointServiceUriWithVarialbesInPathParametersAndOtherParameters(String serviceName, String serviceUri,
                                                                                                                        String pathWithVariables, String parameters) {
        log.debug("iCallThePATCHRequestServiceServiceNameEndpointServiceUriWithVariablesInPathParametersAndOtherParameters()");
        if (pathWithVariables.startsWith("/"))
            pathWithVariables = pathWithVariables.substring(1);
        StringBuilder pathParams = new StringBuilder();
        String[] tokens = pathWithVariables.split("/");
        for (String token : tokens) {
            pathParams.append("/").append(Serenity.getCurrentSession().getOrDefault(token, token));
        }
        parameters = pathParams + parameters;
        prepareUriForServiceRequest(serviceName, serviceUri, "", parameters);
        commonActions.sendPatchRequest(Serenity.getCurrentSession().get("serviceName").toString(),
                Serenity.getCurrentSession().get("uri").toString(),
                alistOfHeaders,
                Serenity.getCurrentSession().get("body").toString());
        alistOfHeaders.clear();
    }

    @When("I call the PUT Request service {string} endpoint {string} with Variables in path {string} and Parameter {string} with Body")
    public void iCallThePUTRequestServiceServiceNameEndpointServiceUriWithVarialbesInPathParametersAndOtherParameters(String serviceName, String serviceUri,
                                                                                                                      String pathWithVariables, String parameters) {
        log.debug("iCallThePUTRequestServiceServiceNameEndpointServiceUriWithVariablesInPathParametersAndOtherParameters()");
        if (pathWithVariables.startsWith("/"))
            pathWithVariables = pathWithVariables.substring(1);
        StringBuilder pathParams = new StringBuilder();
        String[] tokens = pathWithVariables.split("/");
        for (String token : tokens) {
            pathParams.append("/").append(Serenity.getCurrentSession().getOrDefault(token, token));
        }
        parameters = pathParams + parameters;
        prepareUriForServiceRequest(serviceName, serviceUri, "", parameters);
        commonActions.sendPutRequest(Serenity.getCurrentSession().get("serviceName").toString(),
                Serenity.getCurrentSession().get("uri").toString(),
                alistOfHeaders,
                Serenity.getCurrentSession().get("body").toString());
        alistOfHeaders.clear();
    }

    @When("I call the PATCH Request service {string} endpoint {string} with Variable {string} and Parameter {string} with Body")
    public void i_call_the_patch_request_service_endpoint_with_parameter_and_with_body(String serviceName, String serviceUri,
                                                                                       String variable, String parameters) {
        log.debug("i_call_the_patch_request_service_endpoint_with_parameter_and_with_body()");
        prepareUriForServiceRequest(serviceName, serviceUri, variable, parameters);
        commonActions.sendPatchRequest(Serenity.getCurrentSession().get("serviceName").toString(),
                Serenity.getCurrentSession().get("uri").toString(),
                alistOfHeaders,
                Serenity.getCurrentSession().get("body").toString());
        alistOfHeaders.clear();
    }


    @When("I call the DELETE Request for service {string} endpoint {string} with Variable {string} and other parameters {string}")
    public void iCallTheDeleteServiceEndpointWithParameters(String serviceName, String serviceUri, String variable, String parameters) {
        log.debug("iCallTheDeleteServiceEndpointWithParameters");
        prepareUriForServiceRequest(serviceName, serviceUri, variable, parameters);
        commonActions.sendDeleteRequest(serviceName, Serenity.getCurrentSession().get("uri").toString(), alistOfHeaders);
        alistOfHeaders.clear();
    }

    @When("I call the DELETE Request for service {string} endpoint {string} with Variables in the path {string} and other parameters {string}")
    public void iCallTheDeleteServiceEndpointWithVariablesInThePathAndParameters(String serviceName, String serviceUri, String pathWithVariables, String parameters) {
        log.debug("iCallTheDeleteServiceEndpointWithVariablesInThePathAndParameters");
        if (pathWithVariables.startsWith("/"))
            pathWithVariables = pathWithVariables.substring(1);
        StringBuilder pathParams = new StringBuilder();
        String[] tokens = pathWithVariables.split("/");
        for (String token : tokens) {
            pathParams.append("/").append(Serenity.getCurrentSession().getOrDefault(token, token));
        }
        parameters = pathParams + parameters;
        prepareUriForServiceRequest(serviceName, serviceUri, "", parameters);
        commonActions.sendDeleteRequest(serviceName, Serenity.getCurrentSession().get("uri").toString(), alistOfHeaders);
        alistOfHeaders.clear();
    }

    @When("I call the DELETE Request for service {string} endpoint {string} with Variable {string} and other parameters {string} with Body")
    public void iCallTheDeleteServiceEndpointWithParametersWithBody(String serviceName, String serviceUri, String variable, String parameters) {
        log.debug("iCallTheDeleteServiceEndpointWithParametersWithBody");
        prepareUriForServiceRequest(serviceName, serviceUri, variable, parameters);
        commonActions.sendDeleteRequestWithRequestBody(serviceName, Serenity.getCurrentSession().get("uri").toString(), alistOfHeaders,
                Serenity.getCurrentSession().get("body").toString());
        alistOfHeaders.clear();
    }

    @And("Response Body Should Exact Match the Value {string} with Expression {string}")
    public void responseBodyShouldMatchedTheValueWithExpression(String expectedValue, String JsonExpression) {
        log.debug("responseBodyShouldMatchedTheValueWithExpression");
        String actualValue = commonQuestions.getResponseBodyValue(lastResponse(), JsonExpression);
        log.info("Info : Expected Value : <" + expectedValue + "> & Actual Value : <" + actualValue + ">");
        commonQuestions.checkExactMatch(actualValue, expectedValue, "Should Match");
    }

    @And("Response Body Should Exact Match the Value {string} with Expression having variables {string}")
    public void responseBodyShouldMatchedTheValueWithExpressionHavingVariables(String expectedValue, String jsonExpression) {
        log.debug("responseBodyShouldMatchedTheValueWithExpressionHavingVariables");
        jsonExpression = replaceVariablesInExpressionWithValues(jsonExpression);
        log.info("Json Expression after variables replacement - " + jsonExpression);
        responseBodyShouldMatchedTheValueWithExpression(expectedValue, jsonExpression);
    }

    @And("Response Body with Expression {string} Should Exact Match with Data type {string}")
    public void responseBodyWithExpressionShouldMatchDataType(String JsonExpression, String dataType) {
        log.debug("responseBodyShouldMatchedTheValueWithExpression");
        io.restassured.path.json.JsonPath jsonPath = lastResponse().jsonPath();
        if (dataType.equalsIgnoreCase("String")) {
            assert jsonPath.get(JsonExpression) instanceof String;
        } else if (dataType.equalsIgnoreCase("Integer")) {
            assert jsonPath.get(JsonExpression) instanceof Integer;
        }
    }

    @And("Response Body Should Contains the Value {string} with Expression {string}")
    public void responseBodyShouldContainsTheValueWithExpression(String expectedValue, String JsonExpression) {
        log.debug("responseBodyShouldContainsTheValueWithExpression");
        String actualValue = commonQuestions.getResponseBodyValue(lastResponse(), JsonExpression);
        log.info("Info : Expected Value : <" + expectedValue + "> & Actual Value : <" + actualValue + ">?");
        commonQuestions.checkContains(actualValue, expectedValue, "Should Contains");
    }

    @And("Response Body Should not blank with Expression {string}")
    public void responseBodyShouldNotBlankWithExpression(String JsonExpression) {
        log.debug("responseBodyShouldNotBlankWithExpression");
        String actualValue = commonQuestions.getResponseBodyValue(lastResponse(), JsonExpression);
        log.info("Info : Actual Value : <" + actualValue + "> Should not empty?");
        commonQuestions.responseShouldNotBeEmptyWithExpression(actualValue);
    }

    @And("Response Body Should be blank with Expression {string}")
    public void responseBodyShouldBeBlankWithExpression(String JsonExpression) {
        log.debug("responseBodyShouldBeBlankWithExpression");
        String actualValue = commonQuestions.getResponseBodyValue(lastResponse(), JsonExpression);
        if (actualValue != null) {
            Assert.fail("Info : Actual Value not empty!");
        }
    }

    @And("Response Body Should be null with Expression {string}")
    public void responseBodyShouldBeNullWithExpression(String JsonExpression) {
        log.debug("responseBodyShouldBeNullWithExpression");
        String actualValue = commonQuestions.getResponseBodyValue(lastResponse(), JsonExpression);
        Assert.assertNull("Info : Actual Value is not null with expression " + JsonExpression, actualValue);
    }

    @And("Response Body Should be null with Expression having variables {string}")
    public void responseBodyShouldBeNullWithExpressionHavingVariables(String jsonExpression) {
        log.debug("responseBodyShouldMatchedTheValueWithExpressionHavingVariables");
        jsonExpression = replaceVariablesInExpressionWithValues(jsonExpression);
        log.info("Json Expression after variables replacement - " + jsonExpression);
        String actualValue = commonQuestions.getResponseBodyValue(lastResponse(), jsonExpression);
        Assert.assertNull("Info : Actual Value is not null with expression " + jsonExpression, actualValue);
    }

    @And("Response Body Should Contains the Current Date Value {string} with Expression {string}")
    public void responseBodyShouldContainsTheCurrentDateValueWithExpression(String dateFormat, String JsonExpression) {
        log.debug("responseBodyShouldContainsTheCurrentDateValueWithExpression");
        String stringDate = getCurrentDateTime(dateFormat);
        String actualValue = commonQuestions.getResponseBodyValue(lastResponse(), JsonExpression);
        log.info("Info : Expected Value : <" + stringDate + "> & Actual Value : <" + actualValue + ">");
        commonQuestions.checkContains(actualValue, stringDate, "Should Contains");
    }

    @And("Verify that response is not empty")
    public void verifyThatResponseIsNotEmpty() {
        commonQuestions.responseShouldNotBeEmpty(lastResponse());
    }

    @And("Verify that response is empty")
    public void verifyThatResponseIsEmpty() {
        commonQuestions.responseShouldBeEmpty(lastResponse());
    }

    @And("Verify that response should contains {string}")
    public void verifyThatResponseShouldContains(String expectedValue) {
        commonQuestions.responseShouldContains(lastResponse(), expectedValue);
    }

    @And("Verify that response should contains variable {string}")
    public void verifyThatResponseShouldContainsvariable(String expectedValue) {
        log.debug("responseBodyShouldMatchedTheValueWithExpression");
        String expectedValueTitle = Serenity.sessionVariableCalled(expectedValue);
        commonQuestions.responseShouldContains(lastResponse(), expectedValueTitle);
    }

    @Given("I prepare the Body {string} Without Parameter updates in Request")
    public void iPrepareTheWithBodyFileNameWithoutParameters(String fileName) {
        log.debug("iPrepareTheWithBodyFileNameWithoutParameters");
        String body;
        try {
            body = readJsonFile(fileName);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        Serenity.setSessionVariable("body").to(body);
    }

    @Then("Set Variable {string} from Response Body with Expression {string}")
    public void setVariableFromResponseBodyWithExpression(String variableName, String jsonExpression) {
        try {
            String saveValue = lastResponse().getBody().jsonPath().getString(jsonExpression);
            log.debug("JSON Path : " + jsonExpression + " & Value : " + saveValue);
//        Serenity.initializeTestSession();
            Serenity.setSessionVariable(variableName).to(saveValue);
            log.debug("Variable Name : " + variableName + " & Value : " + Serenity.getCurrentSession().get(variableName).toString());
        } catch (Exception e) {
            io.restassured.path.json.JsonPath jsonPath = new io.restassured.path.json.JsonPath(Serenity.getCurrentSession().get("ResponseBody").toString());
            String jsonValue = jsonPath.getString(jsonExpression);
            Serenity.setSessionVariable(variableName).to(jsonValue);
        }
    }


    @Then("Set Variable {string} from Response Body with Expression having variables {string}")
    public void setVariableFromResponseBodyWithExpressionHavingVariables(String variableName, String jsonExpression) {
        log.debug("setVariableFromResponseBodyWithExpressionHavingVariables");
        jsonExpression = replaceVariablesInExpressionWithValues(jsonExpression);
        log.debug("Json Expression after variables replacement - " + jsonExpression);
        setVariableFromResponseBodyWithExpression(variableName, jsonExpression);
    }


    @Given("Get Variable {string} from Serenity Session Variables")
    public String getVariableStringFromResponseBody(String variableName) {
        String getValue = Serenity.sessionVariableCalled(variableName);
        log.debug("Value in CurrentSession: " + getValue);
        assert getValue != null;
        return getValue;
    }

    @Given("I remove the parameter from the request body Parameter is {string}")
    public void i_remove_the_parameter_from_the_request_body_parameter_is_request_params(String param) {
        JSONObject jsonObject;
        try {
            jsonObject = new JSONObject(Serenity.getCurrentSession().get("body").toString());
        } catch (JSONException e) {
            throw new RuntimeException(e);
        }
        jsonObject.remove(param);
        Serenity.setSessionVariable("body").to(jsonObject.toString());
    }

    @Given("I remove the parameters from the request body Parameters are {string}")
    public void i_remove_the_parameters_from_the_request_body_parameters_are_request_params(String commaSeparatedParamsList) {
        JSONObject jsonObject;
        try {
            jsonObject = new JSONObject(Serenity.getCurrentSession().get("body").toString());
        } catch (JSONException e) {
            throw new RuntimeException(e);
        }
        Stream.of(commaSeparatedParamsList.split(",")).map(String::trim).forEach(jsonObject::remove);
        Serenity.setSessionVariable("body").to(jsonObject.toString());
    }

    @Given("Connect with the Database {string}")
    public void connectWithTheDatabase(String databaseName) {
        commonActions.createDbConnection(databaseName);
    }

    @Given("Connect with the B2B Database {string}")
    public void connectWithTheB2BDatabase(String databaseName) {
        commonActions.createB2BDbConnection(databaseName);
    }

    @Then("Execute the SELECT query {string} where column_name {string} with Value {string}")
    public void executeTheSELECTQueryWhereColumn_nameWithValue(String arg0, String arg1, String variable) {
        String query;
        if (variable != null) {
            query = arg0 + arg1 + "\'" + getVariableStringFromResponseBody(variable) + "\'";
            log.debug("Query With Variable : " + query);
        } else {
            query = arg0 + arg1;
            log.debug("Query : " + query);
        }
        commonActions.runQuery(query);
    }

    @Then("Prepare the SELECT query {string}")
    public void prepareTheSELECTQueryWhereColumn_nameWithValueAndExtension(String query) {
        Serenity.setSessionVariable("query").to(query);
    }

    @Then("Prepare the DELETE query {string}")
    public void prepareTheDELETEQuery(String query) {
        Serenity.setSessionVariable("query").to(query);
    }

    @Then("Prepare the query {string}")
    public void prepareTheQuery(String query) {
        Serenity.setSessionVariable("query").to(query);
    }

    @And("Adding Where clause with Condition {string} with fixed Value {string}")
    public void whereClauseWithConditions(String andCondition, String conditionValue) {
        String query;
        query = Serenity.getCurrentSession().get("query").toString();
        query = query + " " + andCondition + "\'" + conditionValue + "\'";
        log.debug("Query With Static Value : " + query);
        Serenity.setSessionVariable("query").to(query);
    }

    @And("Adding Where clause with Condition {string} with dynamic Value {string}")
    public void whereClauseWithDynamicConditions(String whereClause, String variable) {
        String query;
        query = Serenity.getCurrentSession().get("query").toString();
        query = query + " " + whereClause + "\'" + getVariableStringFromResponseBody(variable) + "\'";
        log.debug("Query With Dynamic Value : " + query);
        Serenity.setSessionVariable("query").to(query);
    }

    @And("Adding Order By keyword with expression {string}")
    public void addingOrderByKeywordWithExpression(String orderByExpression) {
        String query;
        query = Serenity.getCurrentSession().get("query").toString();
        query = query + " " + orderByExpression;
        log.debug("Query With Dynamic Value : " + query);
        Serenity.setSessionVariable("query").to(query);
    }

    @Given("Adding Offset keyword with value {int}")
    public void addingOffsetKeywordWithValue(int offsetValue) {
        log.debug("addingOffsetKeywordWithValue");
        String query;
        query = Serenity.getCurrentSession().get("query").toString();
        query = query + " offset " + offsetValue;
        log.debug("Query With Dynamic Value : " + query);
        Serenity.setSessionVariable("query").to(query);
    }

    @Given("Adding Limit keyword with value {int}")
    public void addingLimitKeywordWithValue(int limitValue) {
        log.debug("addingLimitKeywordWithValue");
        String query;
        query = Serenity.getCurrentSession().get("query").toString();
        query = query + " LIMIT " + limitValue;
        log.debug("Query With Dynamic Value : " + query);
        Serenity.setSessionVariable("query").to(query);
    }

    @Then("Execute the Query")
    public void executeQuery() {
        log.debug("Final Query : " + Serenity.getCurrentSession().get("query").toString());
        commonActions.runQuery(Serenity.getCurrentSession().get("query").toString());
    }

    @Then("Execute Update Query with Status {string}")
    public void executeUpdateQuery(String status) {
        log.debug("Final Query : " + Serenity.getCurrentSession().get("query").toString());
        try {
            commonActions.runUpdateQueryForStatus(Serenity.getCurrentSession().get("query").toString(), status);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Then("Execute Update Query with ItemId {int}")
    public void executeUpdateQuery(Integer item_id) {
        log.debug("Final Query : " + Serenity.getCurrentSession().get("query").toString());
        try {
            commonActions.runUpdateQueryForID(Serenity.getCurrentSession().get("query").toString(), item_id);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Then("Execute Update Query")
    public void executeUpdateQuery() {
        log.info("Final Query : " + Serenity.getCurrentSession().get("query").toString());
        try {
            commonActions.runUpdateQuery(Serenity.getCurrentSession().get("query").toString());
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Then("Execute Delete Query")
    public void executeDeleteQuery() {
        log.debug("Final Query : " + Serenity.getCurrentSession().get("query").toString());
        try {
            commonActions.runDeleteQuery(Serenity.getCurrentSession().get("query").toString());
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Then("Verify the Values for Columns {string}")
    public void getTheValuesForColumns(String getObjects) {
        String[] strArray = getObjects.split(" ");
        Map<Object, Object> expectedColumnsValues = new HashMap<>();
        Map<Object, Object> actualColumnsValues = new HashMap<>();
        for (String data : strArray) {
            String[] keyValue = data.split("=");
            expectedColumnsValues.put(keyValue[0], keyValue[1]);
            actualColumnsValues.put(keyValue[0], keyValue[1]);
        }
        try {
            actualColumnsValues = commonActions.getValuesOfColumns(actualColumnsValues);
            if (!actualColumnsValues.toString().equals(expectedColumnsValues.toString())) {
                log.debug("expectedColumnsValues" + expectedColumnsValues + "\n");
                log.debug("actualColumnsValues" + actualColumnsValues);
                Assert.fail("FAIL: Expected Columns Values are not Matched!");
            }
            log.info("OK : DB Values are Successfully Matched!");
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }


    @Then("Verify the Values for Columns with Variables {string}")
    public void getTheValuesForColumnsWithVariables(String getObjects) {
        String[] strArray = getObjects.split(" ");
        Map<Object, Object> expectedColumnsValues = new HashMap<>();
        Map<Object, Object> actualColumnsValues = new HashMap<>();
        for (String data : strArray) {
            String[] keyValue = data.split("=");
            expectedColumnsValues.put(keyValue[0], Serenity.getCurrentSession().get(keyValue[1]));
            actualColumnsValues.put(keyValue[0], keyValue[1]);
        }
        try {
            actualColumnsValues = commonActions.getValuesOfColumns(actualColumnsValues);
            if (!actualColumnsValues.toString().equals(expectedColumnsValues.toString())) {
                log.debug("expectedColumnsValues" + expectedColumnsValues + "\n");
                log.debug("actualColumnsValues" + actualColumnsValues);
                Assert.fail("FAIL: Expected Columns Values are not Matched!");
            }
            log.info("OK : DB Values are Successfully Matched!");
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Given("I prepare the Body {string} With Parameters {string}")
    public void iPrepareTheWithBodyFileNameParameters(String fileName, String parameters) {
        log.debug("iPrepareTheWithBodyFileNameParameters");
        String body;
        try {
            body = readJsonFile(fileName);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        String[] strArray = parameters.split(" ");
        for (String data : strArray) {
            String[] keyValue = data.split("=");
            body = replaceText(body, keyValue[0], keyValue[1]);
        }
        if (body.contains(SpecialBody.WHITE_SPACE.toString())) {
            body = body.replace(SpecialBody.WHITE_SPACE.toString(), " ");
        }
        Serenity.setSessionVariable("body").to(body);
    }

    @Given("I prepare the Body With Parameters {string}")
    public void iPrepareTheBodyWithParameters(String arg0) {
        log.debug("iPrepareTheWithBodyWithParameters");
        Serenity.setSessionVariable("body").to(arg0);
    }

    @When("I call the GET Request for service {string} endpoint {string} with query parameter name {string} and value {string}")
    public void iCallTheServiceEndpointWithQueryParam(String serviceName, String serviceUri, String paramName, String paramValue) {
        log.debug("iCallTheServiceEndpointWithQueryParam");
        prepareUriForServiceRequest(serviceName, serviceUri, "", "");
        commonActions.sendGetRequestWithQueryParam(serviceName, Serenity.getCurrentSession().get("uri").toString(), paramName, paramValue, alistOfHeaders);
        alistOfHeaders.clear();
    }

    @Given("I prepare the user Body {string} with Parameter {string} and {string} and {string} and {string} and {string}")
    public void i_prepare_the_user_body_with_parameter_and_and_and_and(String fileName, String username, String given_name, String family_name, String password, String user_type) {
        String body;
        try {
            body = readJsonFile(fileName);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        body = replaceText(body, "username", username);
        body = replaceText(body, "given_name", given_name);
        body = replaceText(body, "family_name", family_name);
        body = replaceText(body, "password", password);
        body = replaceText(body, "user_type", user_type);
        Serenity.setSessionVariable("body").to(body);
    }

    @When("I call the PATCH Request service {string} endpoint {string} with id {string} and Body")
    public void iCallThePATCHRequestServiceServiceNameEndpointServiceUriWithIdIdAndBody(String serviceName, String serviceUri, String id) {
        log.debug("i_call_the_patch_request_service_endpoint_with_parameter_and_with_body()");
        alistOfHeaders.add((Arrays.asList("Content-Type", "application/json")));
        String uri;
        if (!id.isEmpty())
            uri = PropertiesManager.getProperty(serviceUri, PropertiesManager.prefix.ENVIRONMENT) + "/" + id;
        else
            uri = PropertiesManager.getProperty(serviceUri, PropertiesManager.prefix.ENVIRONMENT);

        Serenity.setSessionVariable("serviceName").to(serviceName);
        Serenity.setSessionVariable("uri").to(uri);
        commonActions.sendPatchRequest(Serenity.getCurrentSession().get("serviceName").toString(),
                Serenity.getCurrentSession().get("uri").toString(),
                alistOfHeaders,
                Serenity.getCurrentSession().get("body").toString());
        alistOfHeaders.clear();
    }

    @When("I call the PUT Request service {string} endpoint {string} with id {string} and Body")
    public void iCallThePUTRequestServiceServiceNameEndpointServiceUriWithIdIdAndBody(String serviceName, String serviceUri, String id) {
        log.debug("i_call_the_patch_request_service_endpoint_with_parameter_and_with_body()");
        alistOfHeaders.add((Arrays.asList("Content-Type", "application/json")));
        String uri = PropertiesManager.getProperty(serviceUri, PropertiesManager.prefix.ENVIRONMENT) + "/" + id;
        Serenity.setSessionVariable("serviceName").to(serviceName);
        Serenity.setSessionVariable("uri").to(uri);
        commonActions.sendPutRequest(Serenity.getCurrentSession().get("serviceName").toString(),
                Serenity.getCurrentSession().get("uri").toString(),
                alistOfHeaders,
                Serenity.getCurrentSession().get("body").toString());
        alistOfHeaders.clear();
    }

    @When("I call the POST Request service {string} endpoint {string} with Variable {string} and Parameter {string} with Body for {int} times")
    public void iCallThePOSTRequestServiceServiceNameEndpointServiceUriWithParametersAndOtherParametersWithNoOfTimes(String serviceName, String serviceUri,
                                                                                                                     String variable, String parameters, int time) {
        log.debug("iCallThePOSTRequestServiceServiceNameEndpointServiceUriWithParametersAndOtherParameters()");
        for (int i = 0; i < time; i++) {
            prepareUriForServiceRequest(serviceName, serviceUri, variable, parameters);
            if (Serenity.getCurrentSession().get("body") != null) {
                commonActions.sendPostRequest(Serenity.getCurrentSession().get("serviceName").toString(),
                        Serenity.getCurrentSession().get("uri").toString(),
                        alistOfHeaders,
                        Serenity.getCurrentSession().get("body").toString());
            } else {
                commonActions.sendPostRequest(Serenity.getCurrentSession().get("serviceName").toString(),
                        Serenity.getCurrentSession().get("uri").toString(),
                        alistOfHeaders);
            }
        }
        alistOfHeaders.clear();
    }

    @Given("I prepare the user Body {string} with Parameter {string} and {string} and {string}")
    public void i_prepare_the_user_body_with_parameter_and_and_and_and(String fileName, String username, String given_name, String family_name) {
        String body;
        try {
            body = readJsonFile(fileName);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        body = replaceText(body, "username", username);
        body = replaceText(body, "given_name", given_name);
        body = replaceText(body, "family_name", family_name);
        Serenity.setSessionVariable("body").to(body);
    }

    @Given("I prepare the Body {string} With Variables {string}")
    public void iPrepareTheWithBodyFileNameVariables(String fileName, String parameters) {
        log.debug("iPrepareTheWithBodyFileNameVariables");
        String body;
        try {
            body = readJsonFile(fileName);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        String[] strArray = parameters.split(" ");
        for (String data : strArray) {
            String[] keyValue = data.split("=");
            body = replaceText(body, keyValue[0], getVariableStringFromResponseBody(keyValue[1]));
        }
        if (body.contains(SpecialBody.WHITE_SPACE.toString())) {
            body = body.replace(SpecialBody.WHITE_SPACE.toString(), " ");
        }
        Serenity.setSessionVariable("body").to(body);
    }

    @Given("I prepare the request headers with key {string} and prefix {string} and Variable value {string}")
    public void i_prepare_the_request_headers_with_key_and_value(String headersKey, String headersPrefix, String headersValue) {
        headersValue = getVariableStringFromResponseBody(headersValue);
        if (headersPrefix.isEmpty()) {
            alistOfHeaders.add((Arrays.asList(headersKey, headersValue)));
        } else {
            headersValue = headersPrefix + " " + headersValue;
            alistOfHeaders.add((Arrays.asList(headersKey, headersValue)));
        }
        Serenity.setSessionVariable("headersKey").to(headersKey);
        Serenity.setSessionVariable("headersValue").to(headersValue);
    }

    @Given("I prepare the request headers with key {string} and prefix {string} and Static value {string}")
    public void i_prepare_the_request_headers_with_key_and_static_value(String headersKey, String headersPrefix, String headersValue) {
        if (headersPrefix.isEmpty()) {
            alistOfHeaders.add((Arrays.asList(headersKey, headersValue)));
        } else {
            headersValue = headersPrefix + " " + headersValue;
            alistOfHeaders.add((Arrays.asList(headersKey, headersValue)));
        }
        Serenity.setSessionVariable("headersKey").to(headersKey);
        Serenity.setSessionVariable("headersValue").to(headersValue);
    }

    @Then("Get the Values for Column {string} and Set into Variable {string}")
    public void getAndStoreTheValuesForColumn(String columnName, String variableName) {
        Object actualColumnsValues;
        try {
            actualColumnsValues = commonActions.getValuesOfColumn(columnName);
            log.debug("actualColumnsValues" + actualColumnsValues);
            log.info("OK : DB Values are Successfully Matched!");
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        setTheVariableValueInSerenitySession(variableName, actualColumnsValues);
    }

    @Then("Set the Value of Variable name {string} and Value {string}")
    public void setTheVariableValueInSerenitySession(String variableName, Object value) {
        try {
            Serenity.setSessionVariable(variableName).to(value.toString());
        } catch (Exception e) {
            log.error("ERROR : " + e.getMessage());
        }
        log.debug("Check Value in Session Variable : " + Serenity.sessionVariableCalled(variableName).toString());
    }

    @Then("Set Variable {string} with value having variables {string}")
    public void setVariableWithValueHavingVariablesInSerenitySession(String variableName, String stringHavingVariables) {
        log.info("setVariableWithValueHavingVariablesInSerenitySession");
        try {
            String replacedValue = replaceVariablesInExpressionWithValues(stringHavingVariables.toString());
            log.info("Value after variables replacement - " + replacedValue);
            Serenity.setSessionVariable(variableName).to(replacedValue);
        } catch (Exception e) {
            log.error("ERROR : " + e.getMessage());
        }
        log.debug("Check Value in Session Variable : " + Serenity.sessionVariableCalled(variableName).toString());
    }

    @Then("Set the Value of Variable name {string} and Value {string} From Date Function")
    public void setTheVariableValueInSerenitySessionFromDate(String variableName, Object value) {
        value = CommonHelpers.getCurrentDateTimeWithSDF(value.toString());
        try {
            Serenity.setSessionVariable(variableName).to(value.toString());
        } catch (Exception e) {
            log.error("ERROR : " + e.getMessage());
        }
        log.debug("Check Value in Session Variable : " + Serenity.sessionVariableCalled(variableName).toString());
    }

    @Given("I prepare the Body {string} With Date Functions {string}")
    public void iPrepareTheWithBodyFileNameFunctions(String fileName, String parameters) {
        log.debug("iPrepareTheWithBodyFileNameFunctions");
        String body;
        try {
            body = readJsonFile(fileName);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        String[] strArray = parameters.split(" ");
        for (String data : strArray) {
            String[] keyValue = data.split("=");
            body = replaceText(body, keyValue[0], CommonHelpers.getCurrentDateTimeWithSDF(keyValue[1]));
        }
        if (body.contains(SpecialBody.WHITE_SPACE.toString())) {
            body = body.replace(SpecialBody.WHITE_SPACE.toString(), " ");
        }
        Serenity.setSessionVariable("body").to(body);
    }

    @And("Wait for {int} seconds")
    public void waitForSeconds(int arg0) {
        try {
            TimeUnit.SECONDS.sleep(arg0);
        } catch (InterruptedException ignored) {
        }
        log.debug("waitForSeconds - " + arg0);
    }

    @When("I call the GET Request for service {string} endpoint {string} with Variable {string} and other parameters {string} with Variable {string}")
    public void iCallTheServiceEndpointWithParametersWithVariablesWithSecondaryVariable(String serviceName, String serviceUri, String variable, String parameters, String variable2) {
        log.debug("iCallTheServiceEndpointWithParametersWithVariablesWithSecondaryVariable");
        variable2 = getVariableStringFromResponseBody(variable2);
        parameters = parameters + variable2;
        prepareUriForServiceRequest(serviceName, serviceUri, variable, parameters);
        commonActions.sendGetRequest(serviceName, Serenity.getCurrentSession().get("uri").toString(), alistOfHeaders);
        alistOfHeaders.clear();
    }

    @When("I call the PATCH Request service {string} endpoint {string} with Variable {string} and Parameter {string} with Body Variable {string}")
    public void i_call_the_patch_request_service_endpoint_with_parameter_and_with_body_with_variable(String serviceName, String serviceUri,
                                                                                                     String variable, String parameters, String variable2) {
        log.debug("i_call_the_patch_request_service_endpoint_with_parameter_and_with_body_with_variable()");
        variable2 = "/" + getVariableStringFromResponseBody(variable2);
        parameters = parameters + variable2;
        prepareUriForServiceRequest(serviceName, serviceUri, variable, parameters);
        commonActions.sendPatchRequest(Serenity.getCurrentSession().get("serviceName").toString(),
                Serenity.getCurrentSession().get("uri").toString(),
                alistOfHeaders,
                Serenity.getCurrentSession().get("body").toString());
        alistOfHeaders.clear();
    }

    @When("I call the PUT Request service {string} endpoint {string} with Variable {string} and Parameter {string} with Body Variable {string}")
    public void i_call_the_put_request_service_endpoint_with_parameter_and_with_body_with_variable(String serviceName, String serviceUri,
                                                                                                   String variable, String parameters, String variable2) {
        log.debug("i_call_the_patch_request_service_endpoint_with_parameter_and_with_body_with_variable()");
        variable2 = "/" + getVariableStringFromResponseBody(variable2);
        parameters = parameters + variable2;
        prepareUriForServiceRequest(serviceName, serviceUri, variable, parameters);
        commonActions.sendPutRequest(Serenity.getCurrentSession().get("serviceName").toString(),
                Serenity.getCurrentSession().get("uri").toString(),
                alistOfHeaders,
                Serenity.getCurrentSession().get("body").toString());
        alistOfHeaders.clear();
    }

    @When("Request Variable {string} for uri {string}")
    public void formVariableForRequestParameter(String Variable, String Parameter) {
        log.debug("formVariableForRequestParameter");
        String getvariable = Serenity.sessionVariableCalled(Variable);
        if (getvariable == null) {
            getvariable = "";
        }
        String getparam = Serenity.sessionVariableCalled(Parameter);
        if (getparam == null) {
            getparam = Parameter;
        }
        getvariable = getvariable + "/" + getparam;
        Serenity.setSessionVariable(getvariable).to(Variable);
    }

    @Given("I prepare the pilot Body {string}")
    public void i_prepare_the_pilot_body_with_parameter(String fileName) {
        String body;
        try {
            body = readJsonFile(fileName);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        Faker faker = new Faker(new Locale("en-CA"));
        String phone = faker.numerify("+1#########");//("###########");

        String randomFirstName = faker.name().firstName();
        String randomLastName = faker.name().lastName();

        body = replaceText(body, "first_name", randomFirstName);
        body = replaceText(body, "last_name", randomLastName);
        body = replaceText(body, "phone_number", phone);
        body = replaceText(body, "active", "true");
        Serenity.setSessionVariable("body").to(body);
    }

    @And("the schema should match with the specification defined in {string}")
    public void the_schema_should_match_with_the_specification(String spec) {
        commonQuestions.verifyResponseSchema(lastResponse(), spec);
    }

    @Given("I prepare the Body variable with Parameter name {string} and variable {string}")
    @Given("I prepare the Body variable with Parameter name {string} and value {string}")
    public void iPrepareTheBodyVariableFileNameWithParameterNameAndValue(String arg0, String arg1) {
        String body = Serenity.sessionVariableCalled("body");
        String value;
        value = Serenity.sessionVariableCalled(arg1);
        if (value == null) {
            value = arg1;
        }
        body = replaceText(body, arg0, value);
        Serenity.setSessionVariable("body").to(body);
    }

    @And("Response Body Should Exact Match the Variable {string} with Expression {string}")
    public void responseBodyShouldMatchedTheVariableWithExpression(String item_id, String JsonExpression) {
        log.debug("responseBodyShouldMatchedTheValueWithExpression");
        String expectedValue = Serenity.sessionVariableCalled(item_id);
        if (expectedValue == null) {
            expectedValue = item_id;
        }
        String actualValue = commonQuestions.getResponseBodyValue(lastResponse(), JsonExpression);
        log.debug("Info : Expected Value : <" + expectedValue + "> & Actual Value : <" + actualValue + ">");
        commonQuestions.checkExactMatch(actualValue, expectedValue, "Should Match");
    }


    @Then("Response Body Should Exact Match the Variable {string} with Expression having variables {string}")
    public void responseBodyShouldMatchedTheVariableWithExpressionWithVariables(String variableName, String jsonExpression) {
        log.debug("responseBodyShouldMatchedTheVariableWithExpressionWithVariables");
        jsonExpression = replaceVariablesInExpressionWithValues(jsonExpression);
        log.debug("Json Expression after variables replacement - " + jsonExpression);
        responseBodyShouldMatchedTheVariableWithExpression(variableName, jsonExpression);
    }

    @And("Response Body Should Exact Match the Value {string} with Filter Expression {string}")
    public void responseBodyShouldContainsMatchedTheValueWithFilterExpression(String expectedValue, String jsonExpression) {
        log.debug("responseBodyShouldContainsMatchedTheValueWithFilterExpression");
        List<Object> list = JsonPath.read(lastResponse().getBody().asString(), jsonExpression);
        log.debug("Info : Expected Value : <" + expectedValue + "> & Actual Value : <" + list.get(0) + ">");
        commonQuestions.checkExactMatch(list.get(0).toString(), expectedValue, "Should Match");
    }

    @Then("Set Variable {string} from Response Body with Filter Expression {string}")
    public void setVariableFromResponseBodyWithFilterExpression(String variableName, String jsonExpression) {
        log.debug("setVariableFromResponseBodyWithFilterExpression");
        List<Object> list = JsonPath.read(lastResponse().getBody().asString(), jsonExpression);
        String saveValue = list.get(0).toString();
        log.debug("JSON Path : " + jsonExpression + " & Value : " + saveValue);
        Serenity.setSessionVariable(variableName).to(saveValue);
        log.debug("Variable Name : " + variableName + " & Value : " + Serenity.getCurrentSession().get(variableName).toString());
    }


    @When("I call the PUT Request service {string} endpoint {string} with Variable {string} and Parameter {string} with Body")
    public void i_call_the_put_request_service_endpoint_with_parameter_and_with_body(String serviceName, String serviceUri,
                                                                                     String variable, String parameters) {
        log.debug("i_call_the_patch_request_service_endpoint_with_parameter_and_with_body()");
        prepareUriForServiceRequest(serviceName, serviceUri, variable, parameters);
        commonActions.sendPutRequest(Serenity.getCurrentSession().get("serviceName").toString(),
                Serenity.getCurrentSession().get("uri").toString(),
                alistOfHeaders,
                Serenity.getCurrentSession().get("body").toString());
        alistOfHeaders.clear();
    }


    @Then("Set Variable {string} from Response Body with Expression using Regex {string}")
    public void setVariableFromResponseBodyUsingRegex(String variableName, String regex) {
        log.debug("setVariableFromResponseBodyUsingRegex");
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(lastResponse().getBody().asString());
        String saveValue = "";
        if (matcher.find()) {
            saveValue = matcher.group(1);
            log.info("regex : " + regex + " & Value : " + saveValue);
        } else {
            log.warn("Value NOT found");
        }
        Serenity.setSessionVariable(variableName).to(saveValue);
        log.info("Variable Name : " + variableName + " & Value : " + Serenity.getCurrentSession().get(variableName).toString());
    }


    @And("Variable value {string} is present in Response body using json filter {string} is {string}")
    public void responseBodyMatchTheVariableWithFilterExpressionIsPresent(String expectedValue, String jsonExpression, String arg2) {
        log.debug("responseBodyMatchTheVariableWithFilterExpressionIsPresent");
        List<String> list = JsonPath.read(lastResponse().getBody().asString(), jsonExpression);
        String val = Serenity.sessionVariableCalled(expectedValue);
        Boolean result = list.stream().anyMatch(item -> item.equals(val));
        log.info("Info : Expected Value : <" + val + "> & Actual Value : <" + list.get(0) + ">");
        commonQuestions.checkExactMatch(result.toString(), arg2, "Should Match");
    }

    @Given("I prepare a date variable {string} and dateformat {string} and day ahead {string}")
    public void iPrepareVariableWithDate(String var, String format, String dayAhead) {
        log.debug("iPrepareVariableWithDate");
        String date = getFutureDateTime(format, Integer.parseInt(dayAhead));
        Serenity.setSessionVariable(var).to(date);
        log.info("Info : Date set in forrmat" + format + " is " + Serenity.sessionVariableCalled(var));
    }

    @And("I read Date1 {string} and Date2 {string} having {string} as date format and stores difference of day in variable {string}")
    @And("I read startDate {string} of new product  and endDate {string} of old product having {string} as date format and stores difference of day in variable {string}")
    public void iCalculateDaysBetweenDates(String date_1, String date_2, String format, String diffDays) {
        log.debug("iCalculateDaysBetweenDates");
        String date1 = Serenity.sessionVariableCalled(date_1);
        String date2 = Serenity.sessionVariableCalled(date_2);
        long diff = getNrOfDaysBetweenTwoDates(date2, date1, format);
        log.info("Days between dates " + date1 + " and " + date2 + " is " + diff);
        Serenity.setSessionVariable(diffDays).to(diff);
    }

    @And("I read Value of Variable {string} and should matches exactly with Value {string}")
    public void iReadValueOfVariableAndShouldMatchesExactlyWithValue(String var, String val) {
        log.debug("iReadValueOfVariableAndShouldMatchesExactlyWithValue");
        String actualValue = Serenity.sessionVariableCalled(var).toString();
        commonQuestions.checkExactMatch(actualValue, val, "Should Matches ");
    }

    @And("Expected Value from Variable {string} Should Contains the Actual Value of Variable {string}")
    public void iReadValueOfVariableAndShouldMatchesPartiallyWithValue(String var, String val) {
        log.debug("iReadValueOfVariableAndShouldMatchesExactlyWithValue");
        String actualValue = Serenity.sessionVariableCalled(var).toString();
        String value = Serenity.sessionVariableCalled(val).toString();
        log.info("value " + actualValue + " partially matching with " + value);
        commonQuestions.checkContains(actualValue, value, "Should Matches ");
    }

    @And("Response Body Should Exact Match the Value of the variable {string} with Expression {string}")
    public void responseBodyShouldContainsTheValueOfTheVariableWithExpression(String variable, String jsonExpression) {
        log.debug("responseBodyMatchTheVariableExactlyWithExpression");
        String expectedValue = Serenity.sessionVariableCalled(variable);
        String actualValue = commonQuestions.getResponseBodyValue(lastResponse(), jsonExpression);
        log.info("Info : Expected Value : <" + expectedValue + "> & Actual Value : <" + actualValue + ">?");
        commonQuestions.checkExactMatch(actualValue, expectedValue, "Should Match");
    }


    @When("I call the DELETE Request for service {string} endpoint {string} with Variable {string} and Parameter {string} with Body Variable {string}")
    public void i_call_the_delete_request_service_endpoint_with_parameter_and_with_body_with_variable(String serviceName, String serviceUri, String variable, String parameters, String variable2) {
        log.debug("i_call_the_delete_request_service_endpoint_with_parameter_and_with_body_with_variable");
        variable2 = "/" + getVariableStringFromResponseBody(variable2);
        parameters = parameters + variable2;
        prepareUriForServiceRequest(serviceName, serviceUri, variable, parameters);
        commonActions.sendDeleteRequest(serviceName, Serenity.getCurrentSession().get("uri").toString(), alistOfHeaders);
        alistOfHeaders.clear();
    }


    @Given("I reset the Get Request Query param string in serenity session")
    public void iResetTheGetRequestQueryParamStringInSerenitySession() {
        log.debug("iResetTheGetRequestQueryParamStringInSerenitySession");
        setTheVariableValueInSerenitySession("queryParamsString", "");
    }


    @Given("I prepare the Get Request Query param with name {string} and with value from Variable {string}")
    public void iPrepareTheGetRequestQueryParamWithNameAndWithValueFromVariable(String queryParamName, String variableName) {
        log.debug("iPrepareTheGetRequestQueryParamWithNameAndWithValueFromVariable");
        String queryParamsStringFromSerenitySession = (String) Serenity.getCurrentSession().getOrDefault("queryParamsString", "");
        if (!queryParamsStringFromSerenitySession.isEmpty()) {
            queryParamsStringFromSerenitySession = queryParamsStringFromSerenitySession + "&" + queryParamName + "="
                    + Serenity.sessionVariableCalled(variableName);
        } else
            queryParamsStringFromSerenitySession = queryParamName + "=" + Serenity.sessionVariableCalled(variableName);
        setTheVariableValueInSerenitySession("queryParamsString", queryParamsStringFromSerenitySession);
    }
    @Given("I prepare the Delete Request Query param with id from Variable {string}")
    public void iPrepareTheDeleteRequestQueryParamWithIdFromVariable(String variableName) {
        log.debug("iPrepareTheDeleteRequestQueryParamWithIdFromVariable");
        String id = getVariableStringFromResponseBody(variableName);
        setTheVariableValueInSerenitySession("queryParamsString", "ids=" + id);
    }
    @When("I call the DELETE Request for service {string} endpoint {string} with query params from serenity session")
    public void iCallTheDELETERequestForServiceEndpointWithQueryParamsFromSerenitySession(String serviceName, String serviceUri) {
        log.debug("iCallTheDELETERequestForServiceEndpointWithQueryParamsFromSerenitySession");
        prepareUriForServiceRequest(serviceName, serviceUri, "", "");
        String uri = Serenity.getCurrentSession().get("uri").toString();
        String queryParamsStringFromSerenitySession = (String) Serenity.getCurrentSession().getOrDefault("queryParamsString", "");
        if (!queryParamsStringFromSerenitySession.isEmpty()) {
            if (uri.contains("?"))
                uri += "&" + queryParamsStringFromSerenitySession;
            else
                uri += "?" + queryParamsStringFromSerenitySession;
        }
        commonActions.sendDeleteRequest(serviceName, uri, alistOfHeaders);
        alistOfHeaders.clear();
    }

    @Given("I Concat url variables {string} and {string} and save it in variable {string}")
    public void iConcatUrlVariables(String var1, String var2, String var3) {
        String data = Serenity.sessionVariableCalled(var1) + "/" + Serenity.sessionVariableCalled(var2);
        Serenity.setSessionVariable(var3).to(data);
    }

    @Given("I Concat variables {string} and {string} and save it in variable {string}")
    public void iConcatVariables(String var1, String var2, String var3) {
        String value1 = Serenity.sessionVariableCalled(var1).toString();
        String value2 = Serenity.sessionVariableCalled(var2).toString();
        String data = value1 + value2;
        Serenity.setSessionVariable(var3).to(data);
    }

    @Given("I prepare Json Node from variable {string} and {string}")
    public void iPrepareBodyUsingJsonNode(String arg0, String arg1) {
        int arg_0 = Integer.parseInt(Serenity.sessionVariableCalled(arg0));
        int arg_1 = Integer.parseInt(Serenity.sessionVariableCalled(arg1));
        ObjectMapper mapper = new ObjectMapper();
        ObjectNode payload = mapper.createObjectNode();
        ArrayNode assetIds = mapper.createArrayNode();
        assetIds.add(arg_0);
        assetIds.add(arg_1);
        payload.set("asset_ids", assetIds);
        Serenity.setSessionVariable("body").to(payload.toString());
    }

    @Given("I prepare the Body {string} With Random String Parameters {string}")
    public void iPrepareTheWithBodyFileNameRandomStringParameters(String fileName, String parameters) {
        log.debug("iPrepareTheWithBodyFileNameParameters");
        String body;
        try {
            body = readJsonFile(fileName);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        String[] strArray = parameters.split(" ");
        for (String data : strArray) {
            String[] keyValue = data.split("=");
            body = replaceText(body, keyValue[0], keyValue[1]);
        }
        if (body.contains(SpecialBody.RANDOM_STRING.toString())) {
            body = body.replace(SpecialBody.RANDOM_STRING.toString(), String.valueOf(generateRandomInteger()));
        }
        Serenity.setSessionVariable("body").to(body);
    }

    @Given("I prepare the Body {string} With Random String Parameters {string} With Size {int}")
    public void iPrepareTheWithBodyFileNameRandomStringParameters(String fileName, String parameters, int size) {
        log.debug("iPrepareTheWithBodyFileNameParameters");
        String body;
        try {
            body = readJsonFile(fileName);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        String[] strArray = parameters.split(" ");
        for (String data : strArray) {
            String[] keyValue = data.split("=");
            body = replaceText(body, keyValue[0], keyValue[1]);
        }
        if (body.contains(SpecialBody.RANDOM_STRING.toString())) {
            body = body.replace(SpecialBody.RANDOM_STRING.toString(), String.valueOf(generateRandomInteger(size)));
        }
        Serenity.setSessionVariable("body").to(body);
    }

    @Given("I prepare the Body {string} With Both Parameters {string} and Variables {string} and Random Parameters {string} With Size {int}")
    public void iPrepareTheWithBodyFileNameParameters(String fileName, String parameters, String variableparameters, String randomparameters, int size) {
        log.debug("iPrepareTheWithBodyFileNameParameters");
        String body;
        try {
            body = readJsonFile(fileName);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        String[] strArray = parameters.split(" ");
        String[] variableStrArray = variableparameters.split(" ");
        String[] randomStrArray = randomparameters.split(" ");
        for (String data : strArray) {
            String[] keyValue = data.split("=");
            body = replaceText(body, keyValue[0], keyValue[1]);
        }
        if (body.contains(SpecialBody.WHITE_SPACE.toString())) {
            body = body.replace(SpecialBody.WHITE_SPACE.toString(), " ");
        }
        if (!variableparameters.isEmpty()) {
            for (String data : variableStrArray) {
                String[] keyValue = data.split("=");
                body = replaceText(body, keyValue[0], getVariableStringFromResponseBody(keyValue[1]));
            }
            if (body.contains(SpecialBody.WHITE_SPACE.toString())) {
                body = body.replace(SpecialBody.WHITE_SPACE.toString(), "");
            }
        }
        if (!randomparameters.isEmpty()) {
            for (String data : randomStrArray) {
                String[] keyValue = data.split("=");
                body = replaceText(body, keyValue[0], keyValue[1]);
            }
            if (body.contains(SpecialBody.RANDOM_STRING.toString())) {
                body = body.replace(SpecialBody.RANDOM_STRING.toString(), String.valueOf(generateRandomInteger(size)));
            }
        }
        Serenity.setSessionVariable("body").to(body);
    }

    @Given("I prepare form param with random phone number and set the param {string}")
    public void iPrepareFormParamWithRandomPhoneNumberAndSetTheParam(String phoneNumber) {
        Faker faker = new Faker(new Locale("en-CA"));
        String phone_no = faker.numerify("55612####");
        alistOfFormParams.add((Arrays.asList("phone_no", phone_no)));
        // Add the Phone Number to variable
        Serenity.setSessionVariable(phoneNumber).to(phone_no);
    }

    @When("I POST the Form Parameter Request Body and get Expected Response with Service {string} endpoint {string} with Variable {string} & Parameter {string}")
    public void iCallThePOSTAsFormParameterRequestBodyAndExpectedResponseWithServiceEndpointWithVariableParameter(String serviceName,
                                                                                                                  String serviceUri, String variable, String parameters) {
        log.debug("iCallThePOSTAsFormParameterRequestBodyAndExpectedResponseWithServiceEndpointWithVariableParameter()");
        prepareUriForServiceRequest(serviceName, serviceUri, variable, parameters);
        commonActions.sendPostRequestWithFormParameters(Serenity.getCurrentSession().get("serviceName").toString(),
                Serenity.getCurrentSession().get("uri").toString(),
                alistOfHeaders,
                alistOfFormParams,
                alistOfMultiPartFiles);
        alistOfHeaders.clear();
        alistOfFormParams.clear();
        alistOfMultiPartFiles.clear();
    }

    @When("I Post the Form Parameter Request Body with Dynamic uri {string}")
    public void iCallThePOSTAsFormParameterRequestBodyWithVariable(String variable) {
        log.debug("iCallThePOSTAsFormParameterRequestBodyWithVariable()");
        if (alistOfHeaders.isEmpty()) {
            try {
                alistOfHeaders.add((Arrays.asList(Serenity.getCurrentSession().get("headersKey").toString(),
                        Serenity.getCurrentSession().get("headersValue").toString())));
            } catch (Exception e) {
                Serenity.setSessionVariable("headersKey").to("Content-Type");
                Serenity.setSessionVariable("headersValue").to("application/json");
                alistOfHeaders.add((Arrays.asList(Serenity.getCurrentSession().get("headersKey").toString(),
                        Serenity.getCurrentSession().get("headersValue").toString())));
            }
        }
        String uri = getVariableStringFromResponseBody(variable);
        log.debug(" URI from the saved variable -> " + uri);
        Serenity.setSessionVariable("uri").to(uri);
        //This method is without service name
        commonActions.sendPostRequestWithFormParameters("",
                Serenity.getCurrentSession().get("uri").toString(),
                alistOfHeaders,
                alistOfFormParams,
                alistOfMultiPartFiles);
        alistOfHeaders.clear();
        alistOfFormParams.clear();
        alistOfMultiPartFiles.clear();
    }

    @Given("I prepare the request body with key {string} and prefix {string} and Variable value {string}")
    public void i_prepare_the_request_body_with_key_and_value(String headersKey, String headersPrefix, String headersValue) {
        headersValue = getVariableStringFromResponseBody(headersValue);
        if (headersPrefix.isEmpty()) {
            alistOfFormParams.add((Arrays.asList(headersKey, headersValue)));
        } else {
            headersValue = headersPrefix + " " + headersValue;
            alistOfFormParams.add((Arrays.asList(headersKey, headersValue)));
        }
    }

    @Given("I prepare the Body With Form Parameters {string}")
    public void iPrepareTheBodyWithFormParameters(String parameters) {
        String[] strArray = parameters.split(" ");
        for (String data : strArray) {
            String[] keyValue = data.split("=");
            alistOfFormParams.add((Arrays.asList(keyValue[0], keyValue[1])));
        }
    }

    @Given("I prepare the Body {string} With form Parameters {string}")
    public void iPrepareTheWithBodyFileNameFormParameters(String fileName, String parameters) throws IOException {
        log.debug("iPrepareBodyTheWithFormParameters");
        String body;
        try {
            body = readJsonFile(fileName);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        String[] strArray = parameters.split(" ");
        for (String data : strArray) {
            String[] keyValue = data.split("=");
            String json_value = Serenity.sessionVariableCalled(keyValue[1]);
            if (json_value == null) {
                json_value = keyValue[1];
            }
            body = replaceText(body, keyValue[0], json_value);
        }
        if (body.contains(SpecialBody.WHITE_SPACE.toString())) {
            body = body.replace(SpecialBody.WHITE_SPACE.toString(), " ");
        }
        try {
            JSONObject jsonObject = new JSONObject(body);
            // Get an iterator over the keys in the JSON object
            Iterator<String> keys = jsonObject.keys();
            while (keys.hasNext()) {
                String key = keys.next();
                Object value = jsonObject.get(key);
                String result = value.toString().replace("\"", "");
                alistOfFormParams.add((Arrays.asList(key, result)));
            }
        } catch (Exception e) {
            log.error(e.getStackTrace());
        }
    }

    @Given("Replace variables in expression with values")
    public String replaceVariablesInExpressionWithValues(String expression) {
        Pattern pattern = Pattern.compile("<<[^>]*>>");
        Matcher matcher = pattern.matcher(expression);
        StringBuffer sb = new StringBuffer();
        while (matcher.find()) {
            matcher.appendReplacement(sb,
                    (String) Serenity.getCurrentSession().get(
                            matcher.group().replace("<<", "").replace(">>", "")
                    )
            );
        }
        matcher.appendTail(sb);
        return sb.toString();
    }

    @And("I compare value of variable {string} with value of variable {string}")
    public void iCompareValuesFromTwoVariables(String var1, String var2) {
        log.debug("iCompareValuesFromTwoVariables");
        String value1 = Serenity.sessionVariableCalled(var1).toString();
        String value2 = Serenity.sessionVariableCalled(var2).toString();
        commonQuestions.checkExactMatch(value1, value2, "Should Matches ");
    }

    @Then("Set Variable {string} from Response Body")
    public void setVariableFromResponseBody(String variableName) {
        String saveValue = lastResponse().getBody().asPrettyString();
        Serenity.setSessionVariable(variableName).to(saveValue);
        log.info("Variable Name : " + variableName + " & Value : " + Serenity.getCurrentSession().get(variableName).toString());
    }

    @And("Read from config file where property name {string} and variable name {string}")
    public void readPropertyFromConfigFile(String property, String var) {
        log.debug("readPropertyFromConfigFile");
        String value = PropertiesManager.getProperty(property, PropertiesManager.prefix.ENVIRONMENT);
        Serenity.setSessionVariable(var).to(value);
        log.info("Property Value from config file : <" + value + ">");
    }

    @When("I call the GET Request for service {string} endpoint {string} with Variables in path {string} and other parameters {string}")
    public void iCallTheGETRequestServiceServiceNameEndpointServiceUriWithVarialbesInPathParametersAndOtherParameters(String serviceName, String serviceUri,
                                                                                                                      String pathWithVariables, String parameters) {
        log.debug("iCallTheGETRequestServiceServiceNameEndpointServiceUriWithVarialbesInPathParametersAndOtherParameters()");
        if (pathWithVariables.startsWith("/"))
            pathWithVariables = pathWithVariables.substring(1);
        StringBuilder pathParams = new StringBuilder();
        String[] tokens = pathWithVariables.split("/");
        for (String token : tokens) {
            pathParams.append("/").append(Serenity.getCurrentSession().getOrDefault(token, token));
        }
        parameters = pathParams + parameters;
        prepareUriForServiceRequest(serviceName, serviceUri, "", parameters);
        commonActions.sendGetRequest(serviceName, Serenity.getCurrentSession().get("uri").toString(), alistOfHeaders);
        alistOfHeaders.clear();
    }

    @And("Set Variable {string} with random Number of length {int} starting with {string} and use numbers {string}")
    public void setVariableWithRandomNumberOfLengthStartingWithAndUserNumbers(String variableName, int length, String startingPattern, String shouldUseNumbers) {
        log.debug("setVariableWithRandomStringOfLengthStartingWithAndUserNumbers");
        StringBuilder patternBuilder = new StringBuilder();
        Faker faker = new Faker(new Locale("en-CA"));
        for (int i = 0; i < length; i++) {
            patternBuilder.append(faker.number().numberBetween(1, 9));
        }
        String number = startingPattern + faker.numerify(patternBuilder.toString());
        setTheVariableValueInSerenitySession(variableName, number);
    }


    @When("I call the GET Request at url with Variable {string}")
    public void iCallTheGETRequestAtUrlWithVariable(String url_in_variable) throws IOException {
        log.debug("iCallTheGETRequestAtUrlWithVariable");
        alistOfHeaders.clear();
        String url = (String) Serenity.getCurrentSession().get(url_in_variable);
        commonActions.sendGetRequest(url, null);
    }

    @When("I call the GET Request at url with Variable {string} and headers")
    public void iCallTheGETRequestAtUrlWithVariableAndHeaders(String url_in_variable) throws IOException {
        log.debug("iCallTheGETRequestAtUrlWithVariable");
        String url = (String) Serenity.getCurrentSession().get(url_in_variable);
        commonActions.sendGetRequest(url, alistOfHeaders);
    }


    @And("Response header {string} value should exact match with {string}")
    public void responseHeaderValueShouldExactMatchWith(String headerName, String expectedResponseHeaderValue) {
        log.debug("responseHeaderValueShouldExactMatchWith");
        String actualValue = commonQuestions.getResponseHeaderValue(lastResponse(), headerName);
        log.info("Info : Expected Value : <" + expectedResponseHeaderValue + "> & Actual Value : <" + actualValue + ">");
        commonQuestions.checkExactMatch(actualValue, expectedResponseHeaderValue, "Should Match");
    }

    @And("Response header {string} value should contain {string}")
    public void responseHeaderValueShouldContain(String headerName, String expectedResponseHeaderValue) {
        log.debug("responseHeaderValueShouldContain");
        String actualValue = commonQuestions.getResponseHeaderValue(lastResponse(), headerName);
        log.info("Info : Expected Value : <" + expectedResponseHeaderValue + "> & Actual Value : <" + actualValue + ">");
        commonQuestions.checkContains(actualValue, expectedResponseHeaderValue, "Should Contain");
    }

    @And("Response content length should exact match with size of file {string}")
    public void responseHeaderShouldExactMatchWithSizeOfFile(String fileRelativePath) {
        log.debug("responseHeaderShouldExactMatchWithSizeOfFile");
        String responseContentLength = commonQuestions.getResponseHeaderValue(lastResponse(), "Content-Length");
        String fileAbsolutePath = Objects.requireNonNull(getClass().getClassLoader().getResource(fileRelativePath)).getPath();
        File image = new File(fileAbsolutePath);
        String fileContentLength = Long.toString(image.length());
        log.info("Info: Expected Value : <" + fileContentLength + "> & Actual Value : <" + responseContentLength + ">");
        commonQuestions.checkExactMatch(responseContentLength, fileContentLength, "Should Match");
    }

    @And("I set url encoding in the request to {string}")
    public void setUrlEncodingInSerenityRest(String encodeUrlStatus) {
        log.debug("setUrlEncodingInSerenityRest");
        boolean shouldUrlEncode = Boolean.parseBoolean(encodeUrlStatus);
        log.info(shouldUrlEncode ? "Enabling" : "Disabling" + " URL Encoding in SerenityRest !");
        SerenityRest.setUrlEncodingEnabled(shouldUrlEncode);
    }
}