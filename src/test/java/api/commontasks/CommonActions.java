package api.commontasks;


import app.utilities.PropertiesManager;
import io.restassured.RestAssured;
import io.restassured.config.EncoderConfig;
import io.restassured.http.ContentType;
import io.restassured.response.Response;
import io.restassured.specification.RequestSpecification;
import net.serenitybdd.core.Serenity;
import net.serenitybdd.core.environment.EnvironmentSpecificConfiguration;
import net.serenitybdd.rest.SerenityRest;
import net.thucydides.core.annotations.Step;
import net.thucydides.core.guice.Injectors;
import net.thucydides.core.util.EnvironmentVariables;
import org.apache.commons.io.FileUtils;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.io.IOException;
import java.sql.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import static net.serenitybdd.rest.SerenityRest.lastResponse;

public class CommonActions {
  static Logger log = LogManager.getLogger(CommonActions.class.getName());
  public Response response;
  private static Connection c = null;
  private static Statement stmt = null;
  private static ResultSet rs = null;
  private boolean bffEnabled = true;
  private String serviceUrl = null;
  @Step("Send POST Request")
  public void sendPostRequest(String serviceName, String uri, List<List<String>> listOfHeaders, String body) {
   // String setAccept_Language = PropertiesManager.getProperty("Accept_Language", PropertiesManager.prefix.NONE);
    RequestSpecification requestSpecification = SerenityRest.given().log().body();
    createBaseUrl(serviceName,uri,requestSpecification);
    if(listOfHeaders !=null){
      listOfHeaders.forEach(name ->requestSpecification.header(name.get(0),name.get(1)));
      log.debug(listOfHeaders.toString());
    }

  //  requestSpecification.body(body);
    log.info("[POST] Service Uri : " + serviceUrl);
    log.info("Request Body : \n "+body);
    response = requestSpecification.body(body).post(serviceUrl);
    log.debug("[POST] ResponseBody : " + lastResponse().getBody().asPrettyString());
    serviceUrl = null;
  }

  @Step("Send POST Request With form params")
  public void sendPostRequestWithFormParameters(String serviceName, String uri, List<List<String>> listOfHeaders,
                                                List<List<String>> listOfFormParams, List<List<String>> listOfMultiPartFiles) {
    String setAccept_Language = PropertiesManager.getProperty("Accept_Language",PropertiesManager.prefix.NONE);
    RequestSpecification requestSpecification = SerenityRest.given().config(RestAssured.config().
            encoderConfig(EncoderConfig.encoderConfig().encodeContentTypeAs("multipart/form-data", ContentType.URLENC)));

    if(serviceName.isEmpty()) {
      bffEnabled = false;
      serviceUrl = uri;
    } else {
      createBaseUrl(serviceName, uri, requestSpecification);
    }
    if(listOfHeaders !=null){
      listOfHeaders.forEach(name ->requestSpecification.header(name.get(0),name.get(1)));
      log.debug(listOfHeaders.toString());
    }
    if(listOfFormParams!=null){
      listOfFormParams.forEach(name ->requestSpecification.formParam(name.get(0),name.get(1)));
      log.debug(listOfFormParams.toString());
    }
    if(listOfMultiPartFiles!=null){
      listOfMultiPartFiles.forEach(name -> {
        try {
          requestSpecification.multiPart(
                  name.get(0),
                  name.get(2),
                  FileUtils.readFileToByteArray(new File(name.get(1))));
        } catch (IOException e) {
          throw new RuntimeException(e);
        }
      });
    }
    log.debug("[POST] Service Uri : " + serviceUrl);
    response = requestSpecification.headers("Accept-Language", setAccept_Language).post(serviceUrl);
    log.debug("[POST] ResponseBody : " + lastResponse().getBody().asPrettyString());
    serviceUrl = null;
  }

  @Step("Send POST Request Without Request Body")
  public void sendPostRequest(String serviceName, String uri, List<List<String>> listOfHeaders) {
    String setAccept_Language = PropertiesManager.getProperty("Accept_Language",PropertiesManager.prefix.NONE);
    RequestSpecification requestSpecification = SerenityRest.given().log().body();
    createBaseUrl(serviceName,uri,requestSpecification);
    if(listOfHeaders !=null){
      listOfHeaders.forEach(name ->requestSpecification.header(name.get(0),name.get(1)));
      log.debug(listOfHeaders.toString());
    }
    log.info("[POST] Service Uri : " + serviceUrl);
    response = requestSpecification.headers("Accept-Language", setAccept_Language).post(serviceUrl);
    log.debug("[POST] ResponseBody : " + lastResponse().getBody().asPrettyString());
    serviceUrl = null;
  }

  @Step("Send PATCH Request")
  public void sendPatchRequest(String serviceName, String uri, List<List<String>> listOfHeaders, String body) {
    String setAccept_Language = PropertiesManager.getProperty("Accept_Language",PropertiesManager.prefix.NONE);
    RequestSpecification requestSpecification = SerenityRest.given().log().body();
    createBaseUrl(serviceName,uri,requestSpecification);
    if(listOfHeaders !=null){
      listOfHeaders.forEach(name ->requestSpecification.header(name.get(0),name.get(1)));
      log.debug(listOfHeaders.toString());
    }

    requestSpecification.headers("Accept-Language",setAccept_Language).body(body);
    log.info("[PATCH] Service Uri : " + serviceUrl);
    log.info("Request Body : \n "+body);
    response = requestSpecification.patch(serviceUrl);
    log.debug("[PATCH] ResponseBody : " + lastResponse().getBody().asPrettyString());
    serviceUrl = null;
  }

  @Step("Send GET Request")
  public void sendGetRequest(String serviceName, String uri,List<List<String>> listOfHeaders) {
    RequestSpecification requestSpecification = SerenityRest.given().log().body();
    createBaseUrl(serviceName,uri,requestSpecification);
    log.info("[GET] Service Uri : " + serviceUrl);
    String setAccept_Language = PropertiesManager.getProperty("Accept_Language",PropertiesManager.prefix.NONE);
    if(listOfHeaders !=null){
      listOfHeaders.forEach(name ->requestSpecification.header(name.get(0),name.get(1)));
      log.debug(listOfHeaders.toString());
    }
    requestSpecification.headers("Accept-Language",setAccept_Language);
    response = requestSpecification.get(serviceUrl);
    log.debug("[GET] ResponseBody : " + lastResponse().getBody().asPrettyString());
    serviceUrl = null;
  }

  @Step("Send GET Request Without Lang Header")
  public void sendGetRequestWithOutAcceptLanguageHeader(String serviceName, String uri,List<List<String>> listOfHeaders) {
    RequestSpecification requestSpecification = SerenityRest.given().log().body();
    createBaseUrl(serviceName,uri,requestSpecification);
    log.info("[GET] Service Uri : " + serviceUrl);
    if(listOfHeaders !=null){
      listOfHeaders.forEach(name ->requestSpecification.header(name.get(0),name.get(1)));
      log.info(listOfHeaders.toString());
    }
    response = requestSpecification.get(serviceUrl);
    log.debug("[GET] ResponseBody : " + lastResponse().getBody().asPrettyString());
    serviceUrl = null;
  }

  @Step("Send GET Request")
  public void sendGetRequest(String url, List<List<String>> listOfHeaders) {
    RequestSpecification requestSpecification = SerenityRest.given().log().body();
    if(listOfHeaders !=null){
      listOfHeaders.forEach(name ->requestSpecification.header(name.get(0),name.get(1)));
      log.debug(listOfHeaders.toString());
    }
    log.info("[GET] Service Uri : " + url);
    response = requestSpecification.get(url);
    log.debug("[GET] ResponseBody : " + lastResponse().getBody().asPrettyString());
  }


  @Step("Send DELETE Request")
  public void sendDeleteRequest(String serviceName, String uri,List<List<String>> listOfHeaders) {
    String setAccept_Language = PropertiesManager.getProperty("Accept_Language",PropertiesManager.prefix.NONE);
    RequestSpecification requestSpecification = SerenityRest.given().log().body();
    createBaseUrl(serviceName,uri,requestSpecification);
    log.info("[DELETE] Service Uri : " + serviceUrl);
    if(listOfHeaders !=null){
      listOfHeaders.forEach(name ->requestSpecification.header(name.get(0),name.get(1)));
      log.debug(listOfHeaders.toString());
    }
    requestSpecification.headers("Accept-Language",setAccept_Language);
    response = requestSpecification.delete(serviceUrl);
    log.debug("[DELETE] ResponseBody : " + lastResponse().getBody().asPrettyString());
    serviceUrl = null;
  }

  @Step("Send DELETE Request with Request Body")
  public void sendDeleteRequestWithRequestBody(String serviceName, String uri,List<List<String>> listOfHeaders, String body) {
    String setAccept_Language = PropertiesManager.getProperty("Accept_Language",PropertiesManager.prefix.NONE);
    RequestSpecification requestSpecification = SerenityRest.given().log().body();
    createBaseUrl(serviceName,uri,requestSpecification);
    log.info("[DELETE] Service Uri : " + serviceUrl);
    if(listOfHeaders !=null){
      listOfHeaders.forEach(name ->requestSpecification.header(name.get(0),name.get(1)));
      log.debug(listOfHeaders.toString());
    }
    requestSpecification.headers("Accept-Language",setAccept_Language).body(body);
    log.info("Request Body : \n "+body);
    response = requestSpecification.delete(serviceUrl);
    log.debug("[DELETE] ResponseBody : " + lastResponse().getBody().asPrettyString());
    serviceUrl = null;
  }


  public static String getUrlFromProperty(String ServiceName){
    EnvironmentVariables environmentVariables = Injectors.getInjector()
            .getInstance(EnvironmentVariables.class);
    return EnvironmentSpecificConfiguration.from(environmentVariables)
            .getProperty("BASEURL_"+ServiceName);
  }
  private void createBaseUrl(String serviceName,String uri,RequestSpecification requestSpecification){
    if(bffEnabled) {
      // Set Customer/Pilot BFF URL and Access Token
      HashMap hm;
      hm = PropertiesManager.getBffURL();
      if(hm!=null) {
        serviceUrl = hm.get("BFF_URL").toString();
        requestSpecification.headers("Authorization", "Bearer " + hm.get("ACCESS_TOKEN").toString());
      }
      bffEnabled = false;
    }
    if(serviceUrl == null && !bffEnabled){
      serviceUrl = getUrlFromProperty(serviceName);
      bffEnabled = false;
    }
    serviceUrl = serviceUrl + uri;
  }

  public Connection getDbConnection(String dbUrl, String dbName, String username, String password){
    Connection dbConnection = null;
    try {
      Class.forName("org.postgresql.Driver");
      dbConnection = DriverManager
              .getConnection(dbUrl+dbName,username, password);
      dbConnection.setAutoCommit(false);
      log.debug("Opened database successfully");
    } catch ( Exception e ) {
      log.error( e.getClass().getName()+": "+ e.getMessage() );
      System.exit(0);
    }
    return dbConnection;
  }
  @Step("^I am connected with the database {string}")
  public void createDbConnection(String dbName){
    String DB_URL = PropertiesManager.getProperty("DB_URL",PropertiesManager.prefix.ENVIRONMENT);
    String DB_USERNAME = PropertiesManager.getProperty("DB_USERNAME",PropertiesManager.prefix.ENVIRONMENT);
    String DB_PASSWORD = PropertiesManager.getProperty("DB_PASSWORD",PropertiesManager.prefix.ENVIRONMENT);
    c = getDbConnection(DB_URL, dbName, DB_USERNAME, DB_PASSWORD);
  }

  @Step("I am connected with the b2b database {String}")
  public void createB2BDbConnection(String dbName){
    String DB_URL = PropertiesManager.getProperty("B2B_DB_URL",PropertiesManager.prefix.ENVIRONMENT);
    String DB_USERNAME = PropertiesManager.getProperty("B2B_DB_USERNAME",PropertiesManager.prefix.ENVIRONMENT);
    String DB_PASSWORD = PropertiesManager.getProperty("B2B_DB_PASSWORD",PropertiesManager.prefix.ENVIRONMENT);
    c = getDbConnection(DB_URL, dbName, DB_USERNAME, DB_PASSWORD);
  }

  @Step("^I run the select query {string}")
  public void runQuery(String query){
    try {
      stmt = c.createStatement();
      rs = stmt.executeQuery( query );
      log.info("Query Executed Successfully!");
    } catch (SQLException e) {
      log.error("ERROR!" +e.getMessage());
      throw new RuntimeException(e);
    }
  }
  @Step("^I run the Update query {string} with Status {status}")
  public void runUpdateQueryForStatus(String query,String status) throws SQLException {
    try {
      PreparedStatement statement = c.prepareStatement(query);
      statement.setString(1,status);
      int rows =  statement.executeUpdate();
      log.info("Query Executed Successfully!" +rows);
      statement.close();
    } catch (SQLException e) {
      log.error("ERROR!" +e.getMessage());
      throw new RuntimeException(e);
    }
    finally {
      c.commit();
     // c.close();
    }
  }
  @Step("^I run the Update query {string} with Id {status}")
  public void runUpdateQueryForID(String query, Integer item_id) throws SQLException {
    try {
      PreparedStatement statement = c.prepareStatement(query);
      statement.setInt(1,item_id);
      int rows =  statement.executeUpdate();
      log.info("Query Executed Successfully!" +rows);
      statement.close();
    } catch (SQLException e) {
      log.error("ERROR!" +e.getMessage());
      throw new RuntimeException(e);
    }
    finally {
      c.commit();
      // c.close();
    }
  }

  @Step("^I run the Update query {string}")
  public void runUpdateQuery(String query) throws SQLException {
    try {
      PreparedStatement statement = c.prepareStatement(query);
      int rows =  statement.executeUpdate();
      log.info("Query Executed Successfully!" +rows);
      statement.close();
    } catch (SQLException e) {
      log.info("ERROR!" +e.getMessage());
      throw new RuntimeException(e);
    }
    finally {
      c.commit();
      // c.close();
    }
  }

  @Step("^I run the Delete query {string}")
  public void runDeleteQuery(String query) throws SQLException {
    try {
      PreparedStatement statement = c.prepareStatement(query);
      int rows =  statement.executeUpdate();
      log.info("DELETE Query Executed Successfully!" +rows);
      statement.close();
    } catch (SQLException e) {
      log.error("ERROR!" +e.getMessage());
      throw new RuntimeException(e);
    }
    finally {
      c.commit();
       c.close();
    }
  }

  @Step("^I Get the Values of Columns {string}")
  public Map<Object,Object> getValuesOfColumns(Map<Object,Object> cName) throws SQLException {
    try {
      rs.next();
      for (Object key : cName.keySet()) {
        try {
          cName.put(key, rs.getObject(key.toString()));
          log.info("Column Label & Value : " + key + "=" + cName.get(key));
        } catch (SQLException e) {
          assert rs != null;
          rs.close();
          stmt.close();
          c.close();
          throw new RuntimeException(e);
        }
      }
    }catch (Exception e){
      log.error("ERROR:Exception In the Database Table!");
    }
    finally {
      log.info("Closing DB Connections!");
      assert rs != null;
      rs.close();
      stmt.close();
      c.close();
      log.info("DB Operation done successfully!");
    }
    return cName;
  }
  @Step("Send GET Request With Query Param")
  public void sendGetRequestWithQueryParam(String serviceName, String uri,String paramName, String paramValue, List<List<String>> listOfHeaders) {
    String setAccept_Language = PropertiesManager.getProperty("Accept_Language",PropertiesManager.prefix.NONE);
    RequestSpecification requestSpecification = SerenityRest.given().queryParam(paramName, paramValue).log().body();
    createBaseUrl(serviceName,uri,requestSpecification);
    log.info("[GET] Service Uri with Query Param : " + serviceUrl);
    if(listOfHeaders !=null){
      listOfHeaders.forEach(name ->requestSpecification.header(name.get(0),name.get(1)));
    }
    requestSpecification.headers("Accept-Language",setAccept_Language);
    response = requestSpecification.get(serviceUrl);
    log.debug("[GET] ResponseBody : " + lastResponse().getBody().asPrettyString());
  }
  @Step("^I Get the Values of Column {string}")
  public Object getValuesOfColumn(String cName) throws SQLException {
    Object columnValue;
    try {
      rs.next();
      columnValue =  rs.getObject(cName);
    }
    catch (Exception e){
      assert rs != null;
      rs.close();
      stmt.close();
      c.close();
      throw new RuntimeException(e);
    }
    finally {
      log.info("Closing DB Connections!");
      assert rs != null;
      rs.close();
      stmt.close();
      c.close();
      log.info("DB Operation done successfully!");
    }
    return columnValue;
  }

  @Step("Send POST Request With form params")
  public void sendPostRequest(String serviceName, String uri, List<List<String>> listOfHeaders, List<List<String>> listOfFormParams, List<List<String>> listOfMultiPartFiles) {
    String setAccept_Language = PropertiesManager.getProperty("Accept_Language",PropertiesManager.prefix.NONE);
    RequestSpecification requestSpecification = SerenityRest.given().config(RestAssured.config().encoderConfig(EncoderConfig.encoderConfig().encodeContentTypeAs("multipart/form-data", ContentType.TEXT)));
    createBaseUrl(serviceName,uri,requestSpecification);
    if(listOfHeaders !=null){
      listOfHeaders.forEach(name ->requestSpecification.header(name.get(0),name.get(1)));
      log.debug(listOfHeaders.toString());
    }
    if(listOfFormParams!=null){
      listOfFormParams.forEach(name ->requestSpecification.formParam(name.get(0),name.get(1)));
      log.debug(listOfFormParams.toString());
    }
    if(listOfMultiPartFiles!=null){
      listOfMultiPartFiles.forEach(name -> {
        try {
          requestSpecification.multiPart(
                  name.get(0),
                  name.get(2),
                  FileUtils.readFileToByteArray(new File(name.get(1))));
        } catch (IOException e) {
          throw new RuntimeException(e);
        }
      });
    }
    log.info("[POST] Service Uri : " + serviceUrl);

    response = requestSpecification.headers("Accept-Language", setAccept_Language).post(serviceUrl);
    log.debug("[POST] ResponseBody : " + lastResponse().getBody().asPrettyString());
    serviceUrl = null;
  }

  @Step("Convert HTML to JSON")
  public void convertHtmlToJson(){
    String body = lastResponse().getBody().asPrettyString()
            .replace("<html>", " ")
            .replace("/<html>", " ")
            .replace("<body>", " ")
            .replace("/<body>", " ");
    JSONObject jsonObject;
    try {
      jsonObject = new JSONObject(body);
    } catch (JSONException e) {
      log.debug("Error In HTML Response" +e.getMessage());
      throw new RuntimeException(e);
    }
    log.debug("[POST] Response Converted From [HTML] To [JSON] Response Body : " + jsonObject);
    Serenity.setSessionVariable("ResponseBody").to(jsonObject);
  }

  @Step("Send PUT Request")
  public void sendPutRequest(String serviceName, String uri, List<List<String>> listOfHeaders, String body) {
    String setAccept_Language = PropertiesManager.getProperty("Accept_Language",PropertiesManager.prefix.NONE);
    RequestSpecification requestSpecification = SerenityRest.given().log().body();
    createBaseUrl(serviceName,uri,requestSpecification);
    if(listOfHeaders !=null){
      listOfHeaders.forEach(name ->requestSpecification.header(name.get(0),name.get(1)));
      log.info(listOfHeaders.toString());
    }

    requestSpecification.headers("Accept-Language",setAccept_Language).body(body);
    log.info("[PUT] Service Uri : " + serviceUrl);
    log.info("Request Body : \n "+body);
    response = requestSpecification.put(serviceUrl);
    log.debug("[PUT] ResponseBody : " + lastResponse().getBody().asPrettyString());
    serviceUrl = null;
  }
}