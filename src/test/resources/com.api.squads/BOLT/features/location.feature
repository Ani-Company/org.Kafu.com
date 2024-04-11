@BOLT @Locations-2_0 @BDDSTORY-PE-2957 @Locations @Regression
Feature: [TECH] [BOLT] Test Cases Design For BOLT Addresses Services
  [TECH] [BOLT] Test Cases Design For BOLT Addresses Services

  Background:
    # This Test case for BOLT Addresses API Service Module
    # Total Number of Test Cases for Addresses Module : 5
    # Total Number of Test Cases for Country Module : 2
    # Total Number of Test Cases for City Module : 2
    # QA Owner - Magesh Jayakumar, Anirudho Sengupta, Swapnil Salunke
    # Total : 9

   # Address Test Cases : 2
  @BDDTEST-PE-2958
  Scenario Outline: "User able to Create,Get and Delete the Address with all Successful Responses"
    # Create Login Session
    Given I prepare the Body "BOLT/JsonFiles/authPayload.json" With Parameters "<authBody>"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    When I call the POST Request service <authServiceName> endpoint <loginServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 200
    And Set Variable "SESSION" from Response Body with Expression "session"

    # Create Login Token
    Given I prepare the Body "BOLT/JsonFiles/tokenPayload.json" With Parameters "code=1111"
    Given I prepare the Body variable with Parameter name "session" and variable "SESSION"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    When I call the POST Request service <authServiceName> endpoint <tokenServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 200
    Then Set Variable "ACCESS_TOKEN" from Response Body with Expression "access_token"

    # Fetch User ID
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the request headers with key "Authorization" and prefix "Bearer" and Variable value "ACCESS_TOKEN"
    When I call the GET Request for service <authServiceName> endpoint <userIDUri> with Variable "" and other parameters ""
    And Set Variable "USERID" from Response Body with Expression "me.id"
    Given I prepare the Body <fileName> With Random String Parameters "RANDOM=RANDOM_STRING"
    Given I prepare the Body variable with Parameter name "user_id" and variable "USERID"
    Given I prepare the Body variable with Parameter name "address" and variable "Dubai Mall Road"
    Given I prepare the Body variable with Parameter name "organization_id" and value "0"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be <responseCode>
    And Verify that response is not empty
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/createAddress.json"
    And Response Body Should Exact Match the Value of the variable "USERID" with Expression "address.user_id"
    And Response Body Should not blank with Expression "address.full_address"
    And Response Body Should not blank with Expression "address.name"
    And Response Body Should not blank with Expression "address.category"
    And Response Body Should not blank with Expression "address.country_id"
    And Response Body Should not blank with Expression "address.country.name"
    And Response Body Should not blank with Expression "address.country.long_name"
    And Response Body Should not blank with Expression "address.country.iso3"
    And Response Body Should not blank with Expression "address.country.iso2"
    And Response Body Should not blank with Expression "address.country.currency_code"
    And Response Body Should not blank with Expression "address.city.country.id"
    And Response Body Should not blank with Expression "address.city.country.name"
    And Response Body Should not blank with Expression "address.city.country.long_name"
    And Response Body Should not blank with Expression "address.city.country.iso3"
    And Response Body Should not blank with Expression "address.city.country.iso2"
    And Response Body Should not blank with Expression "address.city.country.currency_code"
    Then Set Variable "ADDRESS_ID" from Response Body with Expression "address.id"
    When I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "ADDRESS_ID" and other parameters ""
    Then Response Code should be 200
    And Verify that response is not empty
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/address_by_ID.json"
    And Response Body Should Exact Match the Value of the variable "USERID" with Expression "address.user_id"
    And Response Body Should not blank with Expression "address.full_address"
    And Response Body Should not blank with Expression "address.name"
    And Response Body Should not blank with Expression "address.category"
    And Response Body Should not blank with Expression "address.country_id"
    And Response Body Should not blank with Expression "address.country.name"
    And Response Body Should not blank with Expression "address.country.long_name"
    And Response Body Should not blank with Expression "address.country.iso3"
    And Response Body Should not blank with Expression "address.country.iso2"
    And Response Body Should not blank with Expression "address.country.currency_code"
    And Response Body Should not blank with Expression "address.city.country.id"
    And Response Body Should not blank with Expression "address.city.country.name"
    And Response Body Should not blank with Expression "address.city.country.long_name"
    And Response Body Should not blank with Expression "address.city.country.iso3"
    And Response Body Should not blank with Expression "address.city.country.iso2"
    And Response Body Should not blank with Expression "address.city.country.currency_code"
    When I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters "?page=1&per_page=20"
    Then Response Code should be 422
    And Verify that response is not empty
    Given I prepare the Body <fileName> With Random String Parameters "RANDOM=RANDOM_STRING"
    Given I prepare the Body variable with Parameter name "user_id" and variable "USERID"
    Given I prepare the Body variable with Parameter name "organization_id" and value "0"
    Given I prepare the Body variable with Parameter name "address" and variable "Dubaimall"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ADDRESS_ID" and Parameter "" with Body
    Then Response Code should be 200
    And Verify that response is not empty
    And Response Body Should Exact Match the Value of the variable "USERID" with Expression "address.user_id"
    And Response Body Should Exact Match the Value "Dubaimall" with Expression "address.full_address"
    When I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters "?page=1&per_page=20&user_ids=1efa658b-932d-47e7-93b3-8e375207f4a2"
    Then Response Code should be 200
    And Verify that response is not empty
    When I call the DELETE Request for service <serviceName> endpoint <serviceUri> with Variable "ADDRESS_ID" and other parameters ""
    Then Response Code should be 204
    And Verify that response is empty
    When I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "ADDRESS_ID" and other parameters ""
    Then Response Code should be 404
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "ADDRESS_ID" and other parameters ""
    And Verify that response should contains "not_found"
    Examples:
      | authServiceName | serviceName | loginServiceUri | tokenServiceUri | userIDUri    | serviceUri  | fileName                                           | responseCode | authBody                  | body                                                      |
      | "CUSTOMER-BFF"  | "ADDRESSES" | "auth_bff_2_0"  | "authtoken_2_0" | "authme_2_0" | "addresses" | "BOLT/JsonFiles/createAddressInternalService.json" | 201          | code=971 number=585597134 | address=Dubai category=custom country_id=1 name=Dubai3545 |

  @BDDTEST-PE-3055
  Scenario Outline: User should not able to create Address with 400//404/422 response
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    Given I prepare the Body <fileName> With Random String Parameters "RANDOM=RANDOM_STRING"
    Given I prepare the Body variable with Parameter name "address" and variable "Dubai Mall Road"
    Given I prepare the Body variable with Parameter name "user_id" and value "1efa658b-932d-47e7-93b3-8e375207f4a2"
    Given I prepare the Body variable with Parameter name "organization_id" and value "1"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <language>
    Given I remove the parameter from the request body Parameter is <param>
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter <parameters> with Body
    Then Response Code should be <responseCode>
    And Verify that response is not empty
    And Response Body Should Exact Match the Variable <Message> with Expression "error_code"
    Examples:
      | serviceName | serviceUri  | fileName                                                    | responseCode | param        | parameters | Message            | language |
      | "ADDRESSES" | "addresses" | "BOLT/JsonFiles/createAddressInternalService.json"          | 422          | "address"    | ""         | "validation_error" | "en-US"  |
      | "ADDRESSES" | "addresses" | "BOLT/JsonFiles/createAddressInternalService.json"          | 422          | "category"   | ""         | "validation_error" | "en-US"  |
      | "ADDRESSES" | "addresses" | "BOLT/JsonFiles/createAddressInternalService.json"          | 422          | "country_id" | ""         | "validation_error" | "en-US"  |
      | "ADDRESSES" | "addresses" | "BOLT/JsonFiles/createAddressInternalService.json"          | 422          | "name"       | ""         | "validation_error" | "en-US"  |
      | "ADDRESSES" | "addresses" | "BOLT/JsonFiles/createAddressInternalService.json"          | 404          | ""           | "sdfdsfvd" | "not_found"        | "en-US"  |
      | "ADDRESSES" | "addresses" | "BOLT/JsonFiles/createAddressInternalServiceErrorCase.json" | 400          | ""           | ""         | "validation_error" | "en-US"  |

  @BDDTEST-PE-3056
  Scenario Outline: User should not able to create Address with 422 response on removing user_id and organization_id
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    Given I prepare the Body <fileName> With Random String Parameters "RANDOM=RANDOM_STRING"
    Given I prepare the Body variable with Parameter name "user_id" and value "1efa658b-932d-47e7-93b3-8e375207f4a2"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <language>
    Given I remove the parameter from the request body Parameter is "user_id"
    Given I remove the parameter from the request body Parameter is "organization_id"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter <parameters> with Body
    Then Response Code should be <responseCode>
    And Verify that response is not empty
    And Response Body Should Exact Match the Variable <Message> with Expression "error_code"
    Examples:
      | serviceName | serviceUri  | fileName                                             | responseCode | parameters | Message            | language |
      | "ADDRESSES" | "addresses" | "BOLT/JsonFiles/createAddressBothHeaderRemoved.json" | 422          | ""         | "validation_error" | "en-US"  |

  @BDDTEST-PE-3513
  Scenario Outline: User should be able to create Address with 201 response by only having organization_id
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    Given I prepare the Body <fileName> With Random String Parameters "RANDOM=RANDOM_STRING"
    Given I prepare the Body variable with Parameter name "user_id" and value ""
    Given I prepare the Body variable with Parameter name "address" and value "Dubai Mall Road"
    Given I prepare the Body variable with Parameter name "organization_id" and value "1"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <language>
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter <parameters> with Body
    Then Response Code should be <responseCode>
    And Verify that response is not empty

    Examples:
      | serviceName | serviceUri  | fileName                                           | responseCode | parameters | language |
      | "ADDRESSES" | "addresses" | "BOLT/JsonFiles/createAddressInternalService.json" | 201          | ""         | "en-US"  |

  @BDDTEST-PE-3514
  Scenario Outline: User should be able to create Address with 201 response by only having user_ID
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    Given I prepare the Body <fileName> With Random String Parameters "RANDOM=RANDOM_STRING"
    Given I prepare the Body variable with Parameter name "user_id" and value "1efa658b-932d-47e7-93b3-8e375207f4a2"
    Given I prepare the Body variable with Parameter name "address" and value "Dubai Mall Road"
    Given I remove the parameter from the request body Parameter is "organization_id"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <language>
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter <parameters> with Body
    Then Response Code should be <responseCode>
    And Verify that response is not empty

    Examples:
      | serviceName | serviceUri  | fileName                                                      | responseCode | parameters | language |
      | "ADDRESSES" | "addresses" | "BOLT/JsonFiles/createAddressInternalServiceRemoveOrgID.json" | 201          | ""         | "en-US"  |

        # Country Test Cases : 2
  @BDDTEST-PE-2959
  Scenario Outline: "User able to Create,Update,Get and Delete the Country with all Successful Responses"
    Given I prepare the Body <fileName> With Parameters "currency_code=INR flag_emoji=INRflag iso2=IN iso3=IND long_name=INDIA name=INDIA"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "?page=1&per_page=4" with Body
    Then Response Code should be <responseCode>
    And Verify that response is not empty
    Then Set Variable "Country_ID" from Response Body with Expression "country.id"

    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/createCountry.json"
    And Response Body Should not blank with Expression "country.name"
    And Response Body Should not blank with Expression "country.long_name"
    And Response Body Should not blank with Expression "country.iso2"
    And Response Body Should not blank with Expression "country.iso3"
    And Response Body Should not blank with Expression "country.currency_code"
    And Response Body Should not blank with Expression "country.flag_emoji"

    Given I prepare the Body <fileName> With Parameters "currency_code=INR flag_emoji=INRflag iso2=IN iso3=IND long_name=INDIAA name=INDIAA"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "Country_ID" and Parameter "" with Body
    Then Response Code should be 200
    And Verify that response is not empty
    And Response Body Should Exact Match the Value "INDIAA" with Expression "country.name"
    And Response Body Should Exact Match the Value "INDIAA" with Expression "country.long_name"
    And Response Body Should Exact Match the Value "IN" with Expression "country.iso2"
    And Response Body Should Exact Match the Value "IND" with Expression "country.iso3"
    And Response Body Should Exact Match the Value "INR" with Expression "country.currency_code"
    And Response Body Should Exact Match the Value "INRflag" with Expression "country.flag_emoji"
    When I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "Country_ID" and other parameters ""
    Then Response Code should be 200
    And Verify that response is not empty
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/country_by_ID.json"

    And Response Body Should not blank with Expression "country.name"
    And Response Body Should not blank with Expression "country.long_name"
    And Response Body Should not blank with Expression "country.iso2"
    And Response Body Should not blank with Expression "country.iso3"
    And Response Body Should not blank with Expression "country.currency_code"
    And Response Body Should not blank with Expression "country.flag_emoji"

    When I call the DELETE Request for service <serviceName> endpoint <serviceUri> with Variable "Country_ID" and other parameters ""
    Then Response Code should be 204

    Examples:
      | serviceName | serviceUri | fileName                        | responseCode |
      | "ADDRESSES" | "country"  | "BOLT/JsonFiles/countries.json" | 201          |

  @BDDTEST-PE-3114
  Scenario Outline: User should not able to create Country with 400//404/422 response
    Given I prepare the Body <fileName> With Parameters "<body>"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <language>
    Given I remove the parameter from the request body Parameter is <param>
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter <parameters> with Body
    Then Response Code should be <responseCode>
    And Verify that response is not empty
    And Response Body Should Exact Match the Variable <Message> with Expression "error_code"
    Examples:
      | serviceName | serviceUri | fileName                        | responseCode | body                                                                             | param           | parameters | Message            | language |
      | "ADDRESSES" | "country"  | "BOLT/JsonFiles/countries.json" | 422          | currency_code=INR flag_emoji=INRflag iso2=IN iso3=IND long_name=INDIA name=INDIA | "currency_code" | ""         | "validation_error" | "en-US"  |
      | "ADDRESSES" | "country"  | "BOLT/JsonFiles/countries.json" | 422          | currency_code=INR flag_emoji=INRflag iso2=IN iso3=IND long_name=INDIA name=INDIA | "flag_emoji"    | ""         | "validation_error" | "en-US"  |
      | "ADDRESSES" | "country"  | "BOLT/JsonFiles/countries.json" | 422          | currency_code=INR flag_emoji=INRflag iso2=IN iso3=IND long_name=INDIA name=INDIA | "iso2"          | ""         | "validation_error" | "en-US"  |
      | "ADDRESSES" | "country"  | "BOLT/JsonFiles/countries.json" | 422          | currency_code=INR flag_emoji=INRflag iso2=IN iso3=IND long_name=INDIA name=INDIA | "iso3"          | ""         | "validation_error" | "en-US"  |
      | "ADDRESSES" | "country"  | "BOLT/JsonFiles/countries.json" | 422          | currency_code=INR flag_emoji=INRflag iso2=IN iso3=IND long_name=INDIA name=INDIA | "long_name"     | ""         | "validation_error" | "en-US"  |
      | "ADDRESSES" | "country"  | "BOLT/JsonFiles/countries.json" | 422          | currency_code=INR flag_emoji=INRflag iso2=IN iso3=IND long_name=INDIA name=INDIA | "name"          | ""         | "validation_error" | "en-US"  |
      | "ADDRESSES" | "country"  | "BOLT/JsonFiles/countries.json" | 404          | currency_code=INR flag_emoji=INRflag iso2=IN iso3=IND long_name=INDIA name=INDIA | ""              | "sdfdsfvd" | "not_found"        | "en-US"  |

     # City Test Cases : 2
  @BDDTEST-PE-2748
  Scenario Outline: "User able to Create,Update,Get and Delete the City with all Successful Responses"
    Given I prepare the Body <fileName> With Parameters "country_id=7 iata3=DAB name=Pune"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be <responseCode>
    And Verify that response is not empty
    Then Set Variable "City_ID" from Response Body with Expression "city.id"
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/createCity.json"
    And Response Body Should not blank with Expression "city.name"
    And Response Body Should not blank with Expression "city.iata3"
    And Response Body Should not blank with Expression "city.country_id"


    Given I prepare the Body <fileName> With Parameters "country_id=7 iata3=DMB name=Madras"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "City_ID" and Parameter "" with Body
    Then Response Code should be 200
    And Verify that response is not empty
    And Response Body Should Exact Match the Value "Madras" with Expression "city.name"
    And Response Body Should Exact Match the Value "DMB" with Expression "city.iata3"
    And Response Body Should Exact Match the Value "7" with Expression "city.country_id"

    When I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "City_ID" and other parameters ""
    Then Response Code should be 200
    And Verify that response is not empty
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/city_by_ID.json"
    And Response Body Should not blank with Expression "city.name"
    And Response Body Should not blank with Expression "city.iata3"
    And Response Body Should not blank with Expression "city.country_id"

    When I call the DELETE Request for service <serviceName> endpoint <serviceUri> with Variable "City_ID" and other parameters ""
    Then Response Code should be 204

    Examples:
      | serviceName | serviceUri | fileName                     | responseCode |
      | "ADDRESSES" | "cities"   | "BOLT/JsonFiles/cities.json" | 201          |

  @BDDTEST-PE-3115
  Scenario Outline: User should not able to create City with 400//404/422 response
    Given I prepare the Body <fileName> With Parameters "<body>"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <language>
    Given I remove the parameter from the request body Parameter is <param>
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter <parameters> with Body
    Then Response Code should be <responseCode>
    And Verify that response is not empty
    And Response Body Should Exact Match the Variable <Message> with Expression "error_code"
    Examples:
      | serviceName | serviceUri | fileName                     | responseCode | body                                | param        | parameters | Message            | language |
      | "ADDRESSES" | "cities"   | "BOLT/JsonFiles/cities.json" | 422          | country_id=7 iata3=DCB name=Chennai | "country_id" | ""         | "validation_error" | "en-US"  |
      | "ADDRESSES" | "cities"   | "BOLT/JsonFiles/cities.json" | 422          | country_id=7 iata3=DCB name=Chennai | "iata3"      | ""         | "validation_error" | "en-US"  |
      | "ADDRESSES" | "cities"   | "BOLT/JsonFiles/cities.json" | 422          | country_id=7 iata3=DCB name=Chennai | "name"       | ""         | "validation_error" | "en-US"  |
      | "ADDRESSES" | "cities"   | "BOLT/JsonFiles/cities.json" | 404          | country_id=7 iata3=DCB name=Chennai | ""           | "sdfdsfvd" | "not_found"        | "en-US"  |
