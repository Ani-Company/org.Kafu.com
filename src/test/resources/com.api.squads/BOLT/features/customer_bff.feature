@BOLT @BDDSTORY-PE-54 @Customer-Bff-2_0 @Customer-Bff-Bolt @Bolt-CAFU2 @Regression
Feature: [TECH] [BOLT] Test Cases Design For CUSTOMER-BFF Services
  [TECH] [BOLT] Test Cases Design For CUSTOMER-BFF Services

  Background:
    # This Test case for Customer BFF Module
    # Total Number of Test Cases for Assets Module : 28
    # Total Number of Test Cases for Content Assets Module : 7
    # Total Number of Test Cases for Location Module : 10
    # Total Number of Test Cases for Catalog Module : 2
    # Total Number of Test Cases for Timeslot Module : 2
    # QA Owner - Magesh Jayakumar, Anirudho Sengupta, Swapnil Salunke
    # Total : 48


  @BDDTEST-PE-2809
  Scenario Outline: "User able to Retrieve all assets subtypes With 200 OK Response"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    When I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameters>
    Then Response Code should be <responseCode>
    And Verify that response is not empty
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/customer_bff_assets_subtypes.json"
    And Response Body Should Exact Match the Value "<subType>" with Expression "data[0].type"
    And Response Body Should not blank with Expression "data[0].icon_url"
    And Response Body Should Exact Match the Value "<subType>" with Expression "data[1].type"
    And Response Body Should not blank with Expression "data[1].icon_url"
    And Response Body Should Exact Match the Value "<subType>" with Expression "data[2].type"
    And Response Body Should not blank with Expression "data[2].icon_url"
    And Response Body Should Exact Match the Value "<subType>" with Expression "data[3].type"
    And Response Body Should not blank with Expression "data[3].icon_url"

    Examples:
      | serviceName    | serviceUri          | parameters                          | responseCode | subType | headerValue |
      | "CUSTOMER-BFF" | "assetssubtype_2_0" | "/boat/subtypes?page=1&per_page=20" | 200          | boat    | "en-US"     |
      | "CUSTOMER-BFF" | "assetssubtype_2_0" | "/boat/subtypes"                    | 200          | boat    | "en-US"     |

  @BDDTEST-PE-2810
  Scenario Outline: "User unable to Retrieve the assets subtypes With 400 / 404 Error Response"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    When I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameters>
    Then Response Code should be <responseCode>
    And Response Body Should Exact Match the Value <Message> with Expression "error_code"
    Examples:
      | serviceName    | serviceUri          | parameters                             | responseCode | Message            | headerValue |
      | "CUSTOMER-BFF" | "assetssubtype_2_0" | "/boat/subtypes?page=1&per_page=sfedf" | 400          | "validation_error" | "en-US"     |
      | "CUSTOMER-BFF" | "assetssubtype_2_0" | "/boat/subtypesa?page=1&per_page=20"   | 404          | "not_found"        | "en-US"     |

  @BDDTEST-PE-2812
  Scenario Outline: "User able to Retrieve the license plate details for UAE With 200 OK Response"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    When I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameters>
    Then Response Code should be <responseCode>
    And Verify that response is not empty
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/customer_bff_assets_licenseplateUAE.json"
    And Response Body Should Exact Match the Value "alphanumeric" with Expression "data[0].sections[0].characters"
    And Response Body Should Exact Match the Value "1" with Expression "data[0].sections[0].min"
    And Response Body Should Exact Match the Value "5" with Expression "data[0].sections[0].max"
    And Response Body Should Exact Match the Value "Plate number" with Expression "data[0].sections[0].label"
    And Response Body Should Exact Match the Value "true" with Expression "data[0].sections[0].required"
    And Response Body Should Exact Match the Value "2" with Expression "data[0].sections[0].order_column"
    And Response Body Should Exact Match the Value "alphanumeric" with Expression "data[0].sections[1].characters"
    And Response Body Should Exact Match the Value "0" with Expression "data[0].sections[1].min"
    And Response Body Should Exact Match the Value "3" with Expression "data[0].sections[1].max"
    And Response Body Should Exact Match the Value "Code" with Expression "data[0].sections[1].label"
    And Response Body Should Exact Match the Value "false" with Expression "data[0].sections[1].required"
    And Response Body Should Exact Match the Value "1" with Expression "data[0].sections[1].order_column"

    Examples:
      | serviceName    | serviceUri               | parameters                         | responseCode | headerValue |
      | "CUSTOMER-BFF" | "assetslicenseplate_2_0" | "?page=1&per_page=20&country_id=1" | 200          | "en-US"     |

  @BDDTEST-PE-2813
  Scenario Outline: "User able to Retrieve the license plate details for Non UAE With 200 OK Response"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    When I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameters>
    Then Response Code should be <responseCode>
    And Verify that response is not empty
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/customer_bff_assets_licenseplateNonUAE.json"
    And Response Body Should Exact Match the Value "alphanumeric" with Expression "data[0].sections[0].characters"
    And Response Body Should Exact Match the Value "1" with Expression "data[0].sections[0].min"
    And Response Body Should Exact Match the Value "8" with Expression "data[0].sections[0].max"
    And Response Body Should Exact Match the Value "Plate number" with Expression "data[0].sections[0].label"
    And Response Body Should Exact Match the Value "true" with Expression "data[0].sections[0].required"
    And Response Body Should Exact Match the Value "1" with Expression "data[0].sections[0].order_column"

    Examples:
      | serviceName    | serviceUri               | parameters                         | responseCode | headerValue |
      | "CUSTOMER-BFF" | "assetslicenseplate_2_0" | "?page=1&per_page=20&country_id=2" | 200          | "en-US"     |

  @BDDTEST-PE-2814
  Scenario Outline: "User able to Retrieve the license plate details for Emirates With 200 OK Response"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    When I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameters>
    Then Response Code should be <responseCode>
    And Verify that response is not empty
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/customer_bff_assets_licenseplateEmirates.json"
    And Response Body Should Exact Match the Value "alphanumeric" with Expression "data[0].sections[0].characters"
    And Response Body Should Exact Match the Value "1" with Expression "data[0].sections[0].min"
    And Response Body Should Exact Match the Value "5" with Expression "data[0].sections[0].max"
    And Response Body Should Exact Match the Value "Plate number" with Expression "data[0].sections[0].label"
    And Response Body Should Exact Match the Value "true" with Expression "data[0].sections[0].required"
    And Response Body Should Exact Match the Value "1" with Expression "data[0].sections[0].order_column"
    And Response Body Should Exact Match the Value "alphanumeric" with Expression "data[0].sections[1].characters"
    And Response Body Should Exact Match the Value "0" with Expression "data[0].sections[1].min"
    And Response Body Should Exact Match the Value "3" with Expression "data[0].sections[1].max"
    And Response Body Should Exact Match the Value "Code" with Expression "data[0].sections[1].label"
    And Response Body Should Exact Match the Value "false" with Expression "data[0].sections[1].required"
    And Response Body Should Exact Match the Value "2" with Expression "data[0].sections[1].order_column"

    Examples:
      | serviceName    | serviceUri               | parameters                         | responseCode | headerValue |
      | "CUSTOMER-BFF" | "assetslicenseplate_2_0" | "?page=1&per_page=20&country_id=3" | 200          | "en-US"     |


  @BDDTEST-PE-2815
  Scenario Outline: "User unable to Retrieve the license plate details With 400 / 404 Error Response"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    When I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameters>
    Then Response Code should be <responseCode>
    And Response Body Should Exact Match the Value <Message> with Expression "error_code"
    Examples:
      | serviceName    | serviceUri               | parameters                               | responseCode | Message            | headerValue |
      | "CUSTOMER-BFF" | "assetslicenseplate_2_0" | "?page=1&per_page=dsdf&country_id=sdgfg" | 400          | "validation_error" | "en-US"     |
      | "CUSTOMER-BFF" | "assetslicenseplate_2_0" | "a?page=1&per_page=20&country_id=1"      | 404          | "not_found"        | "en-US"     |

  @BDDTEST-PE-2768
  Scenario Outline: "User able to Retrieve all available Non UAE Countries With 200 OK Response"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    When I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameters> Without Lang Header
    Then Response Code should be <responseCode>
    And Verify that response is not empty
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/getCountries.json"
    And Response Body Should Exact Match the Value "2" with Expression "data[1].id"
    And Response Body Should Exact Match the Value "Canada" with Expression "data[1].name"
    And Response Body Should Exact Match the Value "Canada" with Expression "data[1].long_name"
    Examples:
      | serviceName    | serviceUri     | parameters            | responseCode | headerValue |
      | "CUSTOMER-BFF" | "location_2_0" | "?page=1&per_page=20" | 200          | "en-US"     |
      | "CUSTOMER-BFF" | "location_2_0" | ""                    | 200          | "en-US"     |

  @BDDTEST-PE-2787
  Scenario Outline: "User unable to Retrieve all available Non UAE Countries With 400 Bad Request/ 404 Not Found Response"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    When I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameters>
    Then Response Code should be <responseCode>
    And Response Body Should Exact Match the Value <Message> with Expression "error_code"
    Examples:
      | serviceName    | serviceUri     | parameters                | responseCode | Message            | headerValue |
      | "CUSTOMER-BFF" | "location_2_0" | "?page=1&per_page=sdgdsg" | 400          | "validation_error" | "en-US"     |
      | "CUSTOMER-BFF" | "location_2_0" | "e?page=1&per_page=20"    | 404          | "not_found"        | "en-US"     |

  @BDDTEST-PE-2783 @P1 @BoltService
  Scenario Outline: User able to Retrieve Countries With 200 OK Response
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    When I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameters> Without Lang Header
    Then Response Code should be <arg0>
    And Verify that response is not empty
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/customer_bff_countries.json"
    Examples:
      | serviceName    | serviceUri  | parameters            | arg0 | headerValue |
      | "CUSTOMER-BFF" | "countries" | "?page=1&per_page=20" | 200  | "en-US"     |

  @BDDTEST-PE-2952 @P1 @BoltService
  Scenario Outline: User gets 404 when retrieving Countries With invalid URI
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    When I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameters>
    Then Response Code should be <arg0>
    And Verify that response is not empty
    Examples:
      | serviceName    | serviceUri  | parameters             | arg0 | headerValue |
      | "CUSTOMER-BFF" | "countries" | "c?page=1&per_page=20" | 404  | "en-US"     |

  @BDDTEST-PE-2953 @P1 @BoltService @CarWash
  Scenario Outline: GET with incorrect Method Type call to Customer-BFF Countries
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    When I call the DELETE Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameters>
    Then Response Code should be <arg0>
    And Verify that response is not empty
    Examples:
      | serviceName    | serviceUri  | parameters            | arg0 | headerValue |
      | "CUSTOMER-BFF" | "countries" | "?page=1&per_page=20" | 404  | "en-US"     |

  @BDDTEST-PE-2785 @P1 @BoltService
  Scenario Outline: User able to Retrieve Cities With 200 OK Response
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    When I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameters> Without Lang Header
    Then Response Code should be <arg0>
    And Verify that response is not empty
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/customer_bff_cities.json"
    Examples:
      | serviceName    | serviceUri | parameters                         | arg0 | headerValue |
      | "CUSTOMER-BFF" | "cities"   | "?page=1&per_page=20&country_id=1" | 200  | "en-US"     |

  @BDDTEST-PE-2954 @P1 @BoltService
  Scenario Outline: User gets 404 when retrieving Cities With invalid URI
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    When I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameters>
    Then Response Code should be <arg0>
    And Verify that response is not empty
    Examples:
      | serviceName    | serviceUri | parameters             | arg0 | headerValue |
      | "CUSTOMER-BFF" | "cities"   | "a?page=1&per_page=20" | 404  | "en-US"     |

  @BDDTEST-PE-2955 @P1 @BoltService @CarWash
  Scenario Outline: GET with incorrect Method Type call to Customer-BFF Cities
    When I call the DELETE Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameters>
    Then Response Code should be <arg0>
    And Verify that response is not empty
    Examples:
      | serviceName    | serviceUri | parameters            | arg0 |
      | "CUSTOMER-BFF" | "cities"   | "?page=1&per_page=20" | 404  |

  @BDDTEST-PE-2839 @P2
  Scenario Outline: "^User able Get the Contents with all Successful Responses"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    Given I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters "/informational-drawer?content_key=parking_details"
    Then Response Code should be <arg0>
    And Verify that response is not empty
    And Response Body Should not blank with Expression "data.content.title"
    And Response Body Should not blank with Expression "data.content.url"
    And Response Body Should not blank with Expression "data.cta"
    And Response Body Should not blank with Expression "data.cta_background_color"
    And Response Body Should not blank with Expression "data.cta_text_color"
    And Response Body Should not blank with Expression "data.description"
    And Response Body Should not blank with Expression "data.description_color"
    And Response Body Should not blank with Expression "data.entry_text"
    And Response Body Should not blank with Expression "data.title"
    And Response Body Should not blank with Expression "data.title_color"
    And Response Body Should not blank with Expression "data.key"

    Examples:
      | serviceName    | serviceUri | arg0 | headerValue |
      | "CUSTOMER-BFF" | "content"  | 200  | "en-US"     |

  @BDDTEST-PE-2920
  Scenario Outline: "User should be able to Create,Fetch,Update and Delete Address"
    Given I prepare the Body "BOLT/JsonFiles/authPayload.json" With Parameters "<authBody>"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    When I call the POST Request service "CUSTOMER-BFF" endpoint <loginServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 200
    And Set Variable "SESSION" from Response Body with Expression "session"

    # Create Login Token
    Given I prepare the Body "BOLT/JsonFiles/tokenPayload.json" With Parameters "code=1111"
    Given I prepare the Body variable with Parameter name "session" and variable "SESSION"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    When I call the POST Request service "CUSTOMER-BFF" endpoint <tokenServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 200
    Then Set Variable "REFRESH_TOKEN" from Response Body with Expression "refresh_token"
    Then Set Variable "ACCESS_TOKEN" from Response Body with Expression "access_token"

    # Post call for Creating Address
    Given I prepare the request headers with key "Authorization" and prefix "Bearer" and Variable value "ACCESS_TOKEN"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    When I prepare the Body <AddressBody> With Parameters "<AddressValues>"
    And I call the POST Request service "CUSTOMER-BFF" endpoint "addresses" with Variable "" and Parameter "" with Body
    Then Response Code should be 200
    And Set Variable "id" from Response Body with Expression "address.id"

    # Get call for fetching Address
    Given I prepare the request headers with key "Authorization" and prefix "Bearer" and Variable value "ACCESS_TOKEN"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    When I call the GET Request for service "CUSTOMER-BFF" endpoint "addresses" with Variable "id" and other parameters ""
    Then Response Code should be 200
    And Response Body Should Exact Match the Value "OldGym2" with Expression "address.name"
    And Response Body Should Exact Match the Value "Thisisagym" with Expression "address.notes"

    # Patch call for updating Address
    Given I prepare the request headers with key "Authorization" and prefix "Bearer" and Variable value "ACCESS_TOKEN"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    Given I prepare the Body <AddressBody> With Parameters "<patchedValues>"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    When I call the PATCH Request service "CUSTOMER-BFF" endpoint "addresses" with Variable "id" and Parameter "" with Body
    Then Response Code should be 200

    # Get call for fetching updated Address
    Given I prepare the request headers with key "Authorization" and prefix "Bearer" and Variable value "ACCESS_TOKEN"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    When I call the GET Request for service "CUSTOMER-BFF" endpoint "addresses" with Variable "id" and other parameters ""
    Then Response Code should be 200
    And Response Body Should Exact Match the Value "NewGym2" with Expression "address.name"
    And Response Body Should Exact Match the Value "Thisisanothergym" with Expression "address.notes"

    # Delete call for  Address
    Given I prepare the request headers with key "Authorization" and prefix "Bearer" and Variable value "ACCESS_TOKEN"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    When I call the DELETE Request for service "CUSTOMER-BFF" endpoint "addresses" with Variable "id" and other parameters ""
    Then Response Code should be 204
    Examples:
      | loginServiceUri | tokenServiceUri | authBody                  | AddressBody                       | AddressValues                                                                                                                     | patchedValues                                                                                                                           | headerValue |
      | "auth_bff_2_0"  | "authtoken_2_0" | code=971 number=585597134 | "BOLT/JsonFiles/AddressBody.json" | name=OldGym2 lat=25.204198539249326 lng=55.26279587298632 type=custom area=AlBadiaHillsideVillage notes=Thisisagym countryCode=ae | name=NewGym2 lat=25.204198539249326 lng=55.26279587298632 type=custom area=AlBadiaHillsideVillage notes=Thisisanothergym countryCode=ae | "en-US"     |

  @BDDTEST-PE-2921
  Scenario Outline: "User should be able to Create Address with existing name"
    Given I prepare the Body "BOLT/JsonFiles/authPayload.json" With Parameters "<authBody>"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    When I call the POST Request service "CUSTOMER-BFF" endpoint <loginServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 200
    And Set Variable "SESSION" from Response Body with Expression "session"

    # Create Login Token
    Given I prepare the Body "BOLT/JsonFiles/tokenPayload.json" With Parameters "code=1111"
    Given I prepare the Body variable with Parameter name "session" and variable "SESSION"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    When I call the POST Request service "CUSTOMER-BFF" endpoint <tokenServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 200
    Then Set Variable "REFRESH_TOKEN" from Response Body with Expression "refresh_token"
    Then Set Variable "ACCESS_TOKEN" from Response Body with Expression "access_token"

    # Post call for Creating Address
    Given I prepare the request headers with key "Authorization" and prefix "Bearer" and Variable value "ACCESS_TOKEN"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    When I prepare the Body <AddressBody> With Parameters "<AddressValues>"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    And I call the POST Request service "CUSTOMER-BFF" endpoint "addresses" with Variable "" and Parameter "" with Body
    Then Response Code should be either 200 OR 422

    Given I prepare the request headers with key "Authorization" and prefix "Bearer" and Variable value "ACCESS_TOKEN"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    When I prepare the Body <AddressBody> With Parameters "<AddressValues>"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    And I call the POST Request service "CUSTOMER-BFF" endpoint "addresses" with Variable "" and Parameter "" with Body
    Then Response Code should be 200

    Examples:
      | loginServiceUri | tokenServiceUri | authBody                  | AddressBody                       | AddressValues                                                                                                                            | headerValue |
      | "auth_bff_2_0"  | "authtoken_2_0" | code=971 number=529955465 | "BOLT/JsonFiles/AddressBody.json" | name=cafuoffice0002 lat=25.204198539249326 lng=55.26279587298632 type=custom area=AlBadiaHillsideVillage notes=Thisisagym countryCode=ae | "en-US"     |

  @BDDTEST-PE-2869
  Scenario Outline: "User should be able to Edit vehicles for Car and MotorCycle Asset Type"
    Given I prepare the Body "BOLT/JsonFiles/authPayload.json" With Parameters "<authBody>"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    When I call the POST Request service <serviceName> endpoint <loginServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 200
    And Set Variable "SESSION" from Response Body with Expression "session"

    # Create Login Token
    Given I prepare the Body "BOLT/JsonFiles/tokenPayload.json" With Parameters "code=1111"
    Given I prepare the Body variable with Parameter name "session" and variable "SESSION"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    When I call the POST Request service <serviceName> endpoint <tokenServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 200
    Then Set Variable "REFRESH_TOKEN" from Response Body with Expression "refresh_token"
    Then Set Variable "ACCESS_TOKEN" from Response Body with Expression "access_token"

    # Get the make
    Given I prepare the request headers with key "Authorization" and prefix "Bearer" and Variable value "ACCESS_TOKEN"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the GET Request for service "CUSTOMER-BFF" endpoint <makeServiceUri> with Variable "" and other parameters <parameters>
    Then Response Code should be 200
    Then Set Variable "MAKE_ID" from Response Body with Expression "data[0].id"

    # Get the models
    Given I prepare the request headers with key "Authorization" and prefix "Bearer" and Variable value "ACCESS_TOKEN"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the GET Request for service "CUSTOMER-BFF" endpoint <makeServiceUri> with Variable "MAKE_ID" and other parameters <modelParameters>
    Then Response Code should be 200
    Then Set Variable "MODEL_ID" from Response Body with Expression "data[0].id"
    Then Set Variable "SUB_TYPE" from Response Body with Expression "data[0].asset_subtype_key"

    #Create Assets
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    Given I prepare the request headers with key "Authorization" and prefix "Bearer" and Variable value "ACCESS_TOKEN"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <createVehicleFileName> With Both Parameters "<createVehicleBody>" and Variables "subtype=SUB_TYPE model_id=MODEL_ID" and Random Parameters "plate_number=RANDOM_STRING" With Size 5
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be <responseCode>
    Then Set Variable "ASSET_ID" from Response Body with Expression "asset.id"

    # Edit Vehicles
    Given I prepare the request headers with key "Authorization" and prefix "" and Variable value "ACCESS_TOKEN"
    Given I prepare the Body <editVehicleFileName> With Parameters "<editVehicleBody>"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ASSET_ID" and Parameter "" with Body
    Then Response Code should be <responseCode>
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/editvehicles_by_ID.json"
    And Response Body Should Exact Match the Value "red" with Expression "asset.exterior_color_type"
    And Response Body Should Exact Match the Value "2" with Expression "asset.registration_plate.city_id"
    And Response Body Should Exact Match the Value "87394" with Expression "asset.registration_plate.sections[1]"

    #Delete Asset
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    Given I prepare the request headers with key "Authorization" and prefix "Bearer" and Variable value "ACCESS_TOKEN"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the DELETE Request for service <serviceName> endpoint <serviceUri> with Variable "ASSET_ID" and other parameters ""
    Then Response Code should be 204


    Examples:
      | authBody                  | serviceName    | makeServiceUri | loginServiceUri | tokenServiceUri | serviceUri       | responseCode | editVehicleFileName                | createVehicleFileName                | editVehicleBody                                                                   | createVehicleBody                                                | parameters                                                      | modelParameters                              |
      | code=971 number=585597134 | "CUSTOMER-BFF" | "vehicle_make" | "auth_bff_2_0"  | "authtoken_2_0" | "boltassets_2_0" | 200          | "BOLT/JsonFiles/editVehicles.json" | "BOLT/JsonFiles/createVehicles.json" | type=car city_id=2 country_id=1 exterior_color_type=red plate_number=87394        | type=car city_id=1 country_id=1 exterior_color_type=white        | "?page=1&per_page=20&asset_type_key=car&sort=popularity"        | "/models?page=1&per_page=20&sort=popularity" |
      | code=971 number=585597134 | "CUSTOMER-BFF" | "vehicle_make" | "auth_bff_2_0"  | "authtoken_2_0" | "boltassets_2_0" | 200          | "BOLT/JsonFiles/editVehicles.json" | "BOLT/JsonFiles/createVehicles.json" | type=motorcycle city_id=2 country_id=1 exterior_color_type=red plate_number=87394 | type=motorcycle city_id=1 country_id=1 exterior_color_type=white | "?page=1&per_page=20&asset_type_key=motorcycle&sort=popularity" | "/models?page=1&per_page=20&sort=popularity" |

  @BDDTEST-PE-3122
  Scenario Outline: "User should be able to Edit vehicles for Other Asset Type
    Given I prepare the Body "BOLT/JsonFiles/authPayload.json" With Parameters "<authBody>"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    When I call the POST Request service <serviceName> endpoint <loginServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 200
    And Set Variable "SESSION" from Response Body with Expression "session"

    # Create Login Token
    Given I prepare the Body "BOLT/JsonFiles/tokenPayload.json" With Parameters "code=1111"
    Given I prepare the Body variable with Parameter name "session" and variable "SESSION"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    When I call the POST Request service <serviceName> endpoint <tokenServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 200
    Then Set Variable "REFRESH_TOKEN" from Response Body with Expression "refresh_token"
    Then Set Variable "ACCESS_TOKEN" from Response Body with Expression "access_token"

    #Create Assets
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    Given I prepare the request headers with key "Authorization" and prefix "Bearer" and Variable value "ACCESS_TOKEN"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <createAssetsFileName> With Parameters "<createVehicleBody>"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter <parameters> with Body
    Then Response Code should be <responseCode>
    Then Set Variable "ASSET_ID" from Response Body with Expression "asset.id"

    # Edit Vehicles
    Given I prepare the request headers with key "Authorization" and prefix "" and Variable value "ACCESS_TOKEN"
    Given I prepare the Body <editVehicleFileName> With Parameters "<editVehicleBody>"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ASSET_ID" and Parameter "" with Body
    Then Response Code should be <responseCode>
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/editvehiclesboat_by_ID.json"
    And Response Body Should Exact Match the Value <assetType> with Expression "asset.type"
    And Response Body Should Exact Match the Value <subType> with Expression "asset.subtype"
    And Response Body Should Exact Match the Value "red" with Expression "asset.exterior_color_type"
    And Response Body Should Exact Match the Value "2" with Expression "asset.registration_plate.city_id"
    And Response Body Should Exact Match the Value "87394" with Expression "asset.registration_plate.sections[1]"

    #Delete Asset
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    Given I prepare the request headers with key "Authorization" and prefix "Bearer" and Variable value "ACCESS_TOKEN"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the DELETE Request for service <serviceName> endpoint <serviceUri> with Variable "ASSET_ID" and other parameters <parameters>
    Then Response Code should be 204


    Examples:
      | authBody                  | serviceName    | loginServiceUri | tokenServiceUri | serviceUri       | responseCode | editVehicleFileName                             | createAssetsFileName                           | editVehicleBody                                                                                        | createVehicleBody                                                                                                  | parameters | assetType         | subType   |
      | code=971 number=585597134 | "CUSTOMER-BFF" | "auth_bff_2_0"  | "authtoken_2_0" | "boltassets_2_0" | 200          | "BOLT/JsonFiles/editVehiclesForOtherTypes.json" | "BOLT/JsonFiles/createVehiclesOtherTypes.json" | type=bus subtype=bus city_id=2 country_id=1 plate_number=87394 exterior_color_type=red                 | type=bus subtype=bus name=Mybus city_id=1 country_id=1 plate_number=87395 exterior_color_type=white                | ""         | "bus"             | "bus"     |
      | code=971 number=585597134 | "CUSTOMER-BFF" | "auth_bff_2_0"  | "authtoken_2_0" | "boltassets_2_0" | 200          | "BOLT/JsonFiles/editVehiclesForOtherTypes.json" | "BOLT/JsonFiles/createVehiclesOtherTypes.json" | type=truck subtype=truck city_id=2 country_id=1 plate_number=87394 exterior_color_type=red             | type=truck subtype=truck name=Mybus city_id=1 country_id=1 plate_number=87395 exterior_color_type=white            | ""         | "truck"           | "truck"   |
      | code=971 number=585597134 | "CUSTOMER-BFF" | "auth_bff_2_0"  | "authtoken_2_0" | "boltassets_2_0" | 200          | "BOLT/JsonFiles/editVehiclesForOtherTypes.json" | "BOLT/JsonFiles/createVehiclesOtherTypes.json" | type=heavy-equipment subtype=minivan city_id=2 country_id=1 plate_number=87394 exterior_color_type=red | type=heavy-equipment subtype=minivan name=MyHE city_id=1 country_id=1 plate_number=87395 exterior_color_type=white | ""         | "heavy-equipment" | "minivan" |

  @BDDTEST-3678
  Scenario Outline: "User should be able to Edit vehicles for Boat Asset Type"
    Given I prepare the Body "BOLT/JsonFiles/authPayload.json" With Parameters "<authBody>"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    When I call the POST Request service <serviceName> endpoint <loginServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 200
    And Set Variable "SESSION" from Response Body with Expression "session"

    # Create Login Token
    Given I prepare the Body "BOLT/JsonFiles/tokenPayload.json" With Parameters "code=1111"
    Given I prepare the Body variable with Parameter name "session" and variable "SESSION"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    When I call the POST Request service <serviceName> endpoint <tokenServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 200
    Then Set Variable "REFRESH_TOKEN" from Response Body with Expression "refresh_token"
    Then Set Variable "ACCESS_TOKEN" from Response Body with Expression "access_token"

    #Create Assets
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    Given I prepare the request headers with key "Authorization" and prefix "Bearer" and Variable value "ACCESS_TOKEN"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <createVehicleFileName> With Random String Parameters "boatnumber=RANDOM_STRING plate_number=RANDOM_STRING" With Size 5
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter <parameters> with Body
    Then Response Code should be <responseCode>
    Then Set Variable "ASSET_ID" from Response Body with Expression "asset.id"

    # Edit Vehicles
    Given I prepare the request headers with key "Authorization" and prefix "" and Variable value "ACCESS_TOKEN"
    Given I prepare the Body <editVehicleFileName> With Parameters "<editVehicleBody>"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ASSET_ID" and Parameter "" with Body
    Then Response Code should be <responseCode>
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/editvehiclesboat_by_ID.json"
    And Response Body Should Exact Match the Value <assetType> with Expression "asset.type"
    And Response Body Should Exact Match the Value <subType> with Expression "asset.subtype"
    And Response Body Should Exact Match the Value "white" with Expression "asset.exterior_color_type"
    And Response Body Should Exact Match the Value "2" with Expression "asset.registration_plate.city_id"
    And Response Body Should Exact Match the Value "87394" with Expression "asset.registration_plate.sections[1]"
    And Response Body Should Exact Match the Value "updateBoat" with Expression "asset.attributes.name"

    #Delete Asset
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    Given I prepare the request headers with key "Authorization" and prefix "Bearer" and Variable value "ACCESS_TOKEN"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the DELETE Request for service <serviceName> endpoint <serviceUri> with Variable "ASSET_ID" and other parameters <parameters>
    Then Response Code should be 204


    Examples:
      | authBody                  | serviceName    | loginServiceUri | tokenServiceUri | serviceUri       | responseCode | editVehicleFileName                       | createVehicleFileName                    | editVehicleBody                                                                                                     | parameters | assetType | subType               |
      | code=971 number=585597134 | "CUSTOMER-BFF" | "auth_bff_2_0"  | "authtoken_2_0" | "boltassets_2_0" | 200          | "BOLT/JsonFiles/editVehiclesForBoat.json" | "BOLT/JsonFiles/createVehiclesBoat.json" | boatname=updateBoat subtype=marine-craft-12-24m city_id=2 country_id=1 plate_number=87394 exterior_color_type=white | ""         | "boat"    | "marine-craft-12-24m" |

  @BDDTEST-PE-2870
  Scenario Outline: "User should not be able to Edit vehicles with 422 Validation Error"
    Given I prepare the Body With Parameters "{\"phone_number\": {\"code\": \"971\",\"number\": \"585597134\"}}"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    When I call the POST Request service <serviceName> endpoint <loginServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 200
    And Set Variable "SESSION" from Response Body with Expression "session"

    # Create Login Token
    Given I prepare the Body "BOLT/JsonFiles/tokenPayload.json" With Parameters "code=1111"
    Given I prepare the Body variable with Parameter name "session" and variable "SESSION"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    When I call the POST Request service <serviceName> endpoint <tokenServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 200
    Then Set Variable "REFRESH_TOKEN" from Response Body with Expression "refresh_token"
    Then Set Variable "ACCESS_TOKEN" from Response Body with Expression "access_token"

    # Edit Vehicles
    Given I prepare the request headers with key "Authorization" and prefix "" and Variable value "ACCESS_TOKEN"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    Given I prepare the Body <editVehicleFileName> Without Parameter updates in Request
    Given I prepare the Body <editVehicleFileName> With Parameters "<editVehicleBody>"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter <negativeParameters> with Body
    Then Response Code should be <responseCode>

    Examples:
      | serviceName    | loginServiceUri | tokenServiceUri | serviceUri       | responseCode | editVehicleFileName                | negativeParameters | headerValue | editVehicleBody                                                                                                                 |
      | "CUSTOMER-BFF" | "auth_bff_2_0"  | "authtoken_2_0" | "boltassets_2_0" | 422          | "BOLT/JsonFiles/editVehicles.json" | "/3097873438"      | "en-US"     | type=car subtype=hatchback city_id=2 country_id=1 exterior_color_type=red registration_plate_id=2 model_id=2 plate_number=87394 |

  @BDDTEST-PE-2871
  Scenario Outline: "User should not be able to Edit vehicles with 400 Error"
    Given I prepare the Body With Parameters "{\"phone_number\": {\"code\": \"971\",\"number\": \"585597134\"}}"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    When I call the POST Request service <serviceName> endpoint <loginServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 200
    And Set Variable "SESSION" from Response Body with Expression "session"

    # Create Login Token
    Given I prepare the Body "BOLT/JsonFiles/tokenPayload.json" With Parameters "code=1111"
    Given I prepare the Body variable with Parameter name "session" and variable "SESSION"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    When I call the POST Request service <serviceName> endpoint <tokenServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 200
    Then Set Variable "REFRESH_TOKEN" from Response Body with Expression "refresh_token"
    Then Set Variable "ACCESS_TOKEN" from Response Body with Expression "access_token"

    # Edit Vehicles
    Given I prepare the request headers with key "Authorization" and prefix "" and Variable value "ACCESS_TOKEN"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    Given I prepare the Body <editVehicleFileName> With Parameters "<editVehicleBody>"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter <negativeParameters> with Body
    Then Response Code should be <responseCode>

    Examples:
      | serviceName    | loginServiceUri | tokenServiceUri | serviceUri       | responseCode | editVehicleFileName                | negativeParameters | headerValue | editVehicleBody                                                                                                                 |
      | "CUSTOMER-BFF" | "auth_bff_2_0"  | "authtoken_2_0" | "boltassets_2_0" | 400          | "BOLT/JsonFiles/editVehicles.json" | "/dgdg"            | "en-US"     | type=car subtype=hatchback city_id=2 country_id=1 exterior_color_type=red registration_plate_id=2 model_id=2 plate_number=87394 |

  @BDDTEST-PE-2891
  Scenario Outline: "User able Get the Contents assets type based on vertical with 200 Successful Responses"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    Given I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameters> Without Lang Header
    Then Response Code should be <arg0>
    And Verify that response is not empty
    And the schema should match with the specification defined in <fileName>
    And Response Body Should Contains the Value 'car' with Expression "data[0].type"

    Examples:
      | serviceName    | serviceUri                  | arg0 | parameters           | fileName                                                                | headerValue |
      | "CUSTOMER-BFF" | "boltcontentassettypes_2_0" | 200  | "?vertical=car-wash" | "com/api/squads/BOLT/schema/customer_bff_content_assets_types.json"     | "en"        |
      | "CUSTOMER-BFF" | "boltcontentassettypes_2_0" | 200  | "?vertical=fuel"     | "com/api/squads/BOLT/schema/customer_bff_content_assets_all_types.json" | "en"        |

  @BDDTEST-PE-2892
  Scenario Outline: "User should not be able to Get the Contents assets type based on vertical with 404/422 Responses"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    Given I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameters> Without Lang Header
    Then Response Code should be <arg0>
    And Response Body Should Contains the Value <errorMessage> with Expression "message"

    Examples:
      | serviceName    | serviceUri                  | arg0 | parameters          | errorMessage                | headerValue |
      | "CUSTOMER-BFF" | "boltcontentassettypes_2_0" | 422  | "?vetical=car-wash" | "contentful empty response" | "en"        |
      | "CUSTOMER-BFF" | "boltcontentassettypes_2_0" | 404  | "\dsgdf"            | "Not Found"                 | "en"        |

  @BDDTEST-PE-3009
  Scenario Outline: "User able to get the Product Screen Content with all 200 Successful Responses"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    Given I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameters> Without Lang Header
    Then Response Code should be <arg0>
    And Verify that response is not empty
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/customer_bff_content_product_screen.json"

    Examples:
      | serviceName    | serviceUri | arg0 | parameters                                                              | headerValue |
      | "CUSTOMER-BFF" | "content"  | 200  | "/screens/product-selection?platform=ios&content_location=car-wash"     | "en"        |
      | "CUSTOMER-BFF" | "content"  | 200  | "/screens/product-selection?platform=android&content_location=car-wash" | "en"        |

  @BDDTEST-PE-3010
  Scenario Outline: "User should not be able Get the Product Screen Content with all 400/404/422 Successful Responses"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <lang>
    Given I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameters> Without Lang Header
    Then Response Code should be <arg0>

    Examples:
      | serviceName    | serviceUri | arg0 | parameters                                                              | lang |
      | "CUSTOMER-BFF" | "content"  | 400  | "/screens/product-selection?platform=ios&content_location=car-wash"     | ""   |
      | "CUSTOMER-BFF" | "content"  | 404  | "/screens/product-selectio?platform=ios&content_location=car-wash"      | "en" |
      | "CUSTOMER-BFF" | "content"  | 400  | "/screens/product-selection?platform=android&content_location=car-wash" | ""   |
      | "CUSTOMER-BFF" | "content"  | 404  | "/screens/product-selectio?platform=android&content_location=car-wash"  | "en" |
      | "CUSTOMER-BFF" | "content"  | 422  | "/screens/product-selection?platform=sgdfg&content_location=car-wash"   | "en" |

  @BDDTEST-PE-3006
  Scenario Outline: "User should be able to Set Default vehicles"
    Given I prepare the Body "BOLT/JsonFiles/authPayload.json" With Parameters "<authBody>"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    When I call the POST Request service <serviceName> endpoint <loginServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 200
    And Set Variable "SESSION" from Response Body with Expression "session"

    # Create Login Token
    Given I prepare the Body "BOLT/JsonFiles/tokenPayload.json" With Parameters "code=1111"
    Given I prepare the Body variable with Parameter name "session" and variable "SESSION"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    When I call the POST Request service <serviceName> endpoint <tokenServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 200
    Then Set Variable "REFRESH_TOKEN" from Response Body with Expression "refresh_token"
    Then Set Variable "ACCESS_TOKEN" from Response Body with Expression "access_token"

    # Get the make
    Given I prepare the request headers with key "Authorization" and prefix "Bearer" and Variable value "ACCESS_TOKEN"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the GET Request for service "CUSTOMER-BFF" endpoint <makeServiceUri> with Variable "" and other parameters <makeParameters>
    Then Response Code should be 200
    Then Set Variable "MAKE_ID" from Response Body with Expression "data[0].id"

    # Get the models
    Given I prepare the request headers with key "Authorization" and prefix "Bearer" and Variable value "ACCESS_TOKEN"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the GET Request for service "CUSTOMER-BFF" endpoint <makeServiceUri> with Variable "MAKE_ID" and other parameters <modelParameters>
    Then Response Code should be 200
    Then Set Variable "MODEL_ID" from Response Body with Expression "data[0].id"
    Then Set Variable "SUB_TYPE" from Response Body with Expression "data[0].asset_subtype_key"

    #Create Assets
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    Given I prepare the request headers with key "Authorization" and prefix "Bearer" and Variable value "ACCESS_TOKEN"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <createVehicleFileName> With Both Parameters "<createVehicleBody>" and Variables "subtype=SUB_TYPE model_id=MODEL_ID" and Random Parameters "plate_number=RANDOM_STRING" With Size 5
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter <parameters> with Body
    Then Response Code should be 200
    Then Set Variable "ASSET_ID" from Response Body with Expression "asset.id"

    #Set Default Asset
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    Given I prepare the request headers with key "Authorization" and prefix "Bearer" and Variable value "ACCESS_TOKEN"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ASSET_ID" and Parameter '/default' with Body
    Then Response Code should be 204

    #Delete Asset
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    Given I prepare the request headers with key "Authorization" and prefix "Bearer" and Variable value "ACCESS_TOKEN"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the DELETE Request for service <serviceName> endpoint <serviceUri> with Variable "ASSET_ID" and other parameters <parameters>
    Then Response Code should be 204

    Examples:
      | authBody                  | serviceName    | makeServiceUri | loginServiceUri | tokenServiceUri | serviceUri       | createVehicleFileName                | parameters | createVehicleBody                                         | makeParameters                                           | modelParameters                              |
      | code=971 number=585597134 | "CUSTOMER-BFF" | "vehicle_make" | "auth_bff_2_0"  | "authtoken_2_0" | "boltassets_2_0" | "BOLT/JsonFiles/createVehicles.json" | ""         | type=car city_id=1 country_id=1 exterior_color_type=white | "?page=1&per_page=20&asset_type_key=car&sort=popularity" | "/models?page=1&per_page=20&sort=popularity" |


  @BDDTEST-PE-3008
  Scenario Outline: "User should be able to Delete vehicles"
    Given I prepare the Body "BOLT/JsonFiles/authPayload.json" With Parameters "<authBody>"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    When I call the POST Request service <serviceName> endpoint <loginServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 200
    And Set Variable "SESSION" from Response Body with Expression "session"

    # Create Login Token
    Given I prepare the Body "BOLT/JsonFiles/tokenPayload.json" With Parameters "code=1111"
    Given I prepare the Body variable with Parameter name "session" and variable "SESSION"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    When I call the POST Request service <serviceName> endpoint <tokenServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 200
    Then Set Variable "REFRESH_TOKEN" from Response Body with Expression "refresh_token"
    Then Set Variable "ACCESS_TOKEN" from Response Body with Expression "access_token"

    # Get the make
    Given I prepare the request headers with key "Authorization" and prefix "Bearer" and Variable value "ACCESS_TOKEN"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the GET Request for service "CUSTOMER-BFF" endpoint <makeServiceUri> with Variable "" and other parameters <makeParameters>
    Then Response Code should be 200
    Then Set Variable "MAKE_ID" from Response Body with Expression "data[0].id"

    # Get the models
    Given I prepare the request headers with key "Authorization" and prefix "Bearer" and Variable value "ACCESS_TOKEN"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the GET Request for service "CUSTOMER-BFF" endpoint <makeServiceUri> with Variable "MAKE_ID" and other parameters <modelParameters>
    Then Response Code should be 200
    Then Set Variable "MODEL_ID" from Response Body with Expression "data[0].id"
    Then Set Variable "SUB_TYPE" from Response Body with Expression "data[0].asset_subtype_key"

    #Create Assets
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    Given I prepare the request headers with key "Authorization" and prefix "Bearer" and Variable value "ACCESS_TOKEN"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <createVehicleFileName> With Both Parameters "<createVehicleBody>" and Variables "subtype=SUB_TYPE model_id=MODEL_ID" and Random Parameters "plate_number=RANDOM_STRING" With Size 5
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter <parameters> with Body
    Then Response Code should be 200
    Then Set Variable "ASSET_ID" from Response Body with Expression "asset.id"

    #Delete Asset
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    Given I prepare the request headers with key "Authorization" and prefix "Bearer" and Variable value "ACCESS_TOKEN"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the DELETE Request for service <serviceName> endpoint <serviceUri> with Variable "ASSET_ID" and other parameters <parameters>
    Then Response Code should be 204

    Examples:
      | authBody                  | serviceName    | makeServiceUri | loginServiceUri | tokenServiceUri | serviceUri       | parameters | createVehicleFileName                | createVehicleBody                                         | makeParameters                                           | modelParameters                              |
      | code=971 number=585597134 | "CUSTOMER-BFF" | "vehicle_make" | "auth_bff_2_0"  | "authtoken_2_0" | "boltassets_2_0" | ""         | "BOLT/JsonFiles/createVehicles.json" | type=car city_id=1 country_id=1 exterior_color_type=white | "?page=1&per_page=20&asset_type_key=car&sort=popularity" | "/models?page=1&per_page=20&sort=popularity" |

  @BDDTEST-PE-3044
  Scenario Outline: "User able Get the list of assets with 200 Successful Responses"
    # Get Session ID
    Given I prepare the Body With Parameters "{\"phone_number\": {\"code\": \"971\",\"number\": \"585597134\"}}"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    When I call the POST Request service <serviceName> endpoint <loginServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 200
    And Set Variable "SESSION" from Response Body with Expression "session"

    # Create Login Token
    Given I prepare the Body "BOLT/JsonFiles/tokenPayload.json" With Parameters "code=1111"
    Given I prepare the Body variable with Parameter name "session" and variable "SESSION"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    When I call the POST Request service <serviceName> endpoint <tokenServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 200
    Then Set Variable "REFRESH_TOKEN" from Response Body with Expression "refresh_token"
    Then Set Variable "ACCESS_TOKEN" from Response Body with Expression "access_token"

    #Create Assets
    Given I prepare the request headers with key "Authorization" and prefix "" and Variable value "ACCESS_TOKEN"
    When I call the GET Request for service <serviceName> endpoint <authServiceUri> with Variable "" and other parameters <parameters>
    And Set Variable "USERID" from Response Body with Expression "me.id"
    Given I prepare the Body <createVehicleFileName> With Parameters "<createVehicleBody>"
    Given I prepare the Body variable with Parameter name "user_id" and variable "USERID"
    Given I prepare the request headers with key "Authorization" and prefix "" and Variable value "ACCESS_TOKEN"
    When I call the POST Request service <assetsServiceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body

    Given I prepare the request headers with key "Authorization" and prefix "" and Variable value "ACCESS_TOKEN"
    When I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameters>
    Then Response Code should be <arg0>
    And Verify that response is not empty

    Examples:
      | assetsServiceName | authServiceUri | serviceName    | serviceUri       | arg0 | parameters            | loginServiceUri | tokenServiceUri | createVehicleFileName              | createVehicleBody                                                                                           |
      | "ASSETS"          | "authme_2_0"   | "CUSTOMER-BFF" | "boltassets_2_0" | 200  | "?page=1&per_page=20" | "auth_bff_2_0"  | "authtoken_2_0" | "BOLT/JsonFiles/createAssets.json" | type=car subtype=sedan name=Mycar city_id=1 country_id=1 exterior_color=white model_id=1 plate_number=87395 |

  @BDDTEST-PE-3045
  Scenario Outline: "User should not be able Get the list of assets with 400 Successful Responses"
    # Get Session ID
    Given I prepare the Body With Parameters "{\"phone_number\": {\"code\": \"971\",\"number\": \"585597134\"}}"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    When I call the POST Request service <serviceName> endpoint <loginServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 200
    And Set Variable "SESSION" from Response Body with Expression "session"

    # Create Login Token
    Given I prepare the Body "BOLT/JsonFiles/tokenPayload.json" With Parameters "code=1111"
    Given I prepare the Body variable with Parameter name "session" and variable "SESSION"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    When I call the POST Request service <serviceName> endpoint <tokenServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 200
    Then Set Variable "REFRESH_TOKEN" from Response Body with Expression "refresh_token"
    Then Set Variable "ACCESS_TOKEN" from Response Body with Expression "access_token"

    Given I prepare the request headers with key "Authorization" and prefix "" and Variable value "ACCESS_TOKEN"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    When I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameters> Without Lang Header
    Then Response Code should be <arg0>

    Examples:
      | serviceName    | serviceUri       | arg0 | parameters                | loginServiceUri | tokenServiceUri | headerValue |
      | "CUSTOMER-BFF" | "boltassets_2_0" | 400  | "?page=1&per_page=dfgdfg" | "auth_bff_2_0"  | "authtoken_2_0" | "en-US"     |


  @BDDTEST-PE-3130
  Scenario Outline: "User able to get the Vehicle Make type based on asset_type with 200 Successful Responses"
    Given I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en"
    And I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameters>
    Then Response Code should be <arg0>
    And Verify that response is not empty
    And the schema should match with the specification defined in <fileName>

    Examples:
      | serviceName    | serviceUri     | arg0 | parameters                                       | fileName                                     |
      | "CUSTOMER-BFF" | "vehicle_make" | 200  | "?asset_type_key=car&sort=popularity"            | "com/api/squads/BOLT/schema/make_by_ID.json" |
      | "CUSTOMER-BFF" | "vehicle_make" | 200  | "?asset_type_key=car&sort=alphabetically"        | "com/api/squads/BOLT/schema/make_by_ID.json" |
      | "CUSTOMER-BFF" | "vehicle_make" | 200  | "?asset_type_key=motorcycle&sort=popularity"     | "com/api/squads/BOLT/schema/make_by_ID.json" |
      | "CUSTOMER-BFF" | "vehicle_make" | 200  | "?asset_type_key=motorcycle&sort=alphabetically" | "com/api/squads/BOLT/schema/make_by_ID.json" |


  @BDDTEST-PE-3131
  Scenario Outline: "User unable Get the Vehicle Make type based on invalid asset_type with 422 as the response code"
    Given I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en"
    And I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameters>
    Then Response Code should be <arg0>

    Examples:
      | serviceName    | serviceUri     | arg0 | parameters                                 |
      | "CUSTOMER-BFF" | "vehicle_make" | 422  | "?asset_type_key=bike&sort=popularity"     |
      | "CUSTOMER-BFF" | "vehicle_make" | 422  | "?asset_type_key=car&sort=pplrty"          |
      | "CUSTOMER-BFF" | "vehicle_make" | 422  | "?asset_type_key=bike&sort=alphabetically" |
      | "CUSTOMER-BFF" | "vehicle_make" | 422  | "?asset_type_key=car&sort=alphabeticaly"   |


  @BDDTEST-PE-3136
  Scenario Outline: "User able to change sequence of response using filter"
    Given I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en"
    And I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameters>
    Then Response Code should be <arg0>
    Then Set Variable "FIRST_VALUE" from Response Body with Expression "data[0].name"
    Then Set Variable "SECOND_VALUE" from Response Body with Expression "data[1].name"
    Then Alphabetical Order should be "FIRST_VALUE" and "SECOND_VALUE"

    Examples:
      | serviceName    | serviceUri     | arg0 | parameters                                |
      | "CUSTOMER-BFF" | "vehicle_make" | 200  | "?asset_type_key=car&sort=alphabetically" |


  @BDDTEST-PE-3133
  Scenario Outline: "User should be able to Create vehicles for car and motorcycle asset types With 200 Response"
    Given I prepare the Body "BOLT/JsonFiles/authPayload.json" With Parameters "<authBody>"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    When I call the POST Request service <serviceName> endpoint <loginServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 200
    And Set Variable "SESSION" from Response Body with Expression "session"

    # Create Login Token
    Given I prepare the Body "BOLT/JsonFiles/tokenPayload.json" With Parameters "code=1111"
    Given I prepare the Body variable with Parameter name "session" and variable "SESSION"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    When I call the POST Request service <serviceName> endpoint <tokenServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 200
    Then Set Variable "REFRESH_TOKEN" from Response Body with Expression "refresh_token"
    Then Set Variable "ACCESS_TOKEN" from Response Body with Expression "access_token"

    # Get the make
    Given I prepare the request headers with key "Authorization" and prefix "Bearer" and Variable value "ACCESS_TOKEN"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the GET Request for service "CUSTOMER-BFF" endpoint <makeServiceUri> with Variable "" and other parameters <makeParameters>
    Then Response Code should be 200
    Then Set Variable "MAKE_ID" from Response Body with Expression "data[0].id"

    # Get the models
    Given I prepare the request headers with key "Authorization" and prefix "Bearer" and Variable value "ACCESS_TOKEN"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the GET Request for service "CUSTOMER-BFF" endpoint <makeServiceUri> with Variable "MAKE_ID" and other parameters <modelParameters>
    Then Response Code should be 200
    Then Set Variable "MODEL_ID" from Response Body with Expression "data[0].id"
    Then Set Variable "SUB_TYPE" from Response Body with Expression "data[0].asset_subtype_key"

    #Create Assets
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    Given I prepare the request headers with key "Authorization" and prefix "Bearer" and Variable value "ACCESS_TOKEN"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    Given I prepare the Body <createVehicleFileName> With Both Parameters "<createVehicleBody>" and Variables "subtype=SUB_TYPE model_id=MODEL_ID" and Random Parameters "plate_number=RANDOM_STRING" With Size 5
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter <parameters> with Body
    Then Response Code should be <responseCode>
    And the schema should match with the specification defined in <schemaFileName>
    And Response Body Should not blank with Expression "asset.id"
    And Response Body Should Exact Match the Value <vehicleType> with Expression "asset.type"
    And Response Body Should Exact Match the Value "red" with Expression "asset.exterior_color_type"
    And Response Body Should Exact Match the Value "1" with Expression "asset.registration_plate.country_id"
    And Response Body Should Exact Match the Value "2" with Expression "asset.registration_plate.city_id"

    Examples:
      | authBody                  | serviceName    | loginServiceUri | makeServiceUri | tokenServiceUri | serviceUri       | responseCode | createVehicleFileName                | vehicleType  | createVehicleBody                                                                      | parameters | headerValue | schemaFileName                                              | makeParameters                                                  | modelParameters                              |
      | code=971 number=585597134 | "CUSTOMER-BFF" | "auth_bff_2_0"  | "vehicle_make" | "authtoken_2_0" | "boltassets_2_0" | 200          | "BOLT/JsonFiles/createVehicles.json" | "car"        | type=car city_id=2 country_id=1 exterior_color_type=red registration_plate_id=2        | ""         | "en-US"     | "com/api/squads/BOLT/schema/customer_bff_createassets.json" | "?page=1&per_page=20&asset_type_key=car&sort=popularity"        | "/models?page=1&per_page=20&sort=popularity" |
      | code=971 number=585597134 | "CUSTOMER-BFF" | "auth_bff_2_0"  | "vehicle_make" | "authtoken_2_0" | "boltassets_2_0" | 200          | "BOLT/JsonFiles/createVehicles.json" | "motorcycle" | type=motorcycle city_id=2 country_id=1 exterior_color_type=red registration_plate_id=2 | ""         | "en-US"     | "com/api/squads/BOLT/schema/customer_bff_createassets.json" | "?page=1&per_page=20&asset_type_key=motorcycle&sort=popularity" | "/models?page=1&per_page=20&sort=popularity" |

  @BDDTEST-PE-3789
  Scenario Outline: "User should be able to Create vehicles for other asset types With 200 Response"
    Given I prepare the Body "BOLT/JsonFiles/authPayload.json" With Parameters "<authBody>"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    When I call the POST Request service <serviceName> endpoint <loginServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 200
    And Set Variable "SESSION" from Response Body with Expression "session"

    # Create Login Token
    Given I prepare the Body "BOLT/JsonFiles/tokenPayload.json" With Parameters "code=1111"
    Given I prepare the Body variable with Parameter name "session" and variable "SESSION"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    When I call the POST Request service <serviceName> endpoint <tokenServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 200
    Then Set Variable "REFRESH_TOKEN" from Response Body with Expression "refresh_token"
    Then Set Variable "ACCESS_TOKEN" from Response Body with Expression "access_token"

    #Create Assets
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    Given I prepare the request headers with key "Authorization" and prefix "Bearer" and Variable value "ACCESS_TOKEN"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    Given I prepare the Body <createVehicleFileName> With Both Parameters "<createVehicleBody>" and Variables "" and Random Parameters "plate_number=RANDOM_STRING" With Size 5
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter <parameters> with Body
    Then Response Code should be <responseCode>
    And the schema should match with the specification defined in <schemaFileName>
    And Response Body Should not blank with Expression "asset.id"
    And Response Body Should Exact Match the Value <vehicleType> with Expression "asset.type"
    And Response Body Should Exact Match the Value <vehicleSubType> with Expression "asset.subtype"
    And Response Body Should Exact Match the Value "red" with Expression "asset.exterior_color_type"
    And Response Body Should Exact Match the Value "1" with Expression "asset.registration_plate.country_id"
    And Response Body Should Exact Match the Value "2" with Expression "asset.registration_plate.city_id"

    Examples:
      | authBody                  | serviceName    | loginServiceUri | tokenServiceUri | serviceUri       | responseCode | createVehicleFileName                          | vehicleType       | vehicleSubType | createVehicleBody                                                                                           | parameters | headerValue | schemaFileName                                                        |
      | code=971 number=585597134 | "CUSTOMER-BFF" | "auth_bff_2_0"  | "authtoken_2_0" | "boltassets_2_0" | 200          | "BOLT/JsonFiles/createVehiclesOtherTypes.json" | "bus"             | "bus"          | type=bus subtype=bus city_id=2 country_id=1 exterior_color_type=red registration_plate_id=2                 | ""         | "en-US"     | "com/api/squads/BOLT/schema/customer_bff_createassetsothertypes.json" |
      | code=971 number=585597134 | "CUSTOMER-BFF" | "auth_bff_2_0"  | "authtoken_2_0" | "boltassets_2_0" | 200          | "BOLT/JsonFiles/createVehiclesOtherTypes.json" | "truck"           | "truck"        | type=truck subtype=truck city_id=2 country_id=1 exterior_color_type=red registration_plate_id=2             | ""         | "en-US"     | "com/api/squads/BOLT/schema/customer_bff_createassetsothertypes.json" |
      | code=971 number=585597134 | "CUSTOMER-BFF" | "auth_bff_2_0"  | "authtoken_2_0" | "boltassets_2_0" | 200          | "BOLT/JsonFiles/createVehiclesOtherTypes.json" | "heavy-equipment" | "minivan"      | type=heavy-equipment subtype=minivan city_id=2 country_id=1 exterior_color_type=red registration_plate_id=2 | ""         | "en-US"     | "com/api/squads/BOLT/schema/customer_bff_createassetsothertypes.json" |

  @BDDTEST-PE-3679
  Scenario Outline: "User should be able to Create vehicles for BOAT With 200 Response"
    Given I prepare the Body "BOLT/JsonFiles/authPayload.json" With Parameters "<authBody>"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    When I call the POST Request service <serviceName> endpoint <loginServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 200
    And Set Variable "SESSION" from Response Body with Expression "session"

    # Create Login Token
    Given I prepare the Body "BOLT/JsonFiles/tokenPayload.json" With Parameters "code=1111"
    Given I prepare the Body variable with Parameter name "session" and variable "SESSION"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    When I call the POST Request service <serviceName> endpoint <tokenServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 200
    Then Set Variable "REFRESH_TOKEN" from Response Body with Expression "refresh_token"
    Then Set Variable "ACCESS_TOKEN" from Response Body with Expression "access_token"

    #Create Assets
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    Given I prepare the request headers with key "Authorization" and prefix "Bearer" and Variable value "ACCESS_TOKEN"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    Given I prepare the Body <createVehicleFileName> With Random String Parameters "boatnumber=RANDOM_STRING plate_number=RANDOM_STRING" With Size 5
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter <parameters> with Body
    Then Response Code should be <responseCode>
    And the schema should match with the specification defined in <schemaFileName>
    And Response Body Should not blank with Expression "asset.id"
    And Response Body Should not blank with Expression "asset.type"
    And Response Body Should not blank with Expression "asset.exterior_color_type"
    And Response Body Should not blank with Expression "asset.registration_plate.country_id"
    And Response Body Should not blank with Expression "asset.registration_plate.city_id"
    And Response Body Should not blank with Expression "asset.registration_plate.sections[0]"
    And Response Body Should not blank with Expression "asset.registration_plate.sections[1]"

    Examples:
      | authBody                  | serviceName    | loginServiceUri | tokenServiceUri | serviceUri       | responseCode | createVehicleFileName                    | vehicleType | vehicleSubType      | parameters | headerValue | schemaFileName                                                  |
      | code=971 number=585597134 | "CUSTOMER-BFF" | "auth_bff_2_0"  | "authtoken_2_0" | "boltassets_2_0" | 200          | "BOLT/JsonFiles/createVehiclesBoat.json" | "boat"      | "marine-craft-<12m" | ""         | "en-US"     | "com/api/squads/BOLT/schema/customer_bff_createassetsboat.json" |

  @BDDTEST-PE-3134
  Scenario Outline: "User should not be able to Create vehicles for Car Asset Type With 404/422 Error"
    Given I prepare the Body "BOLT/JsonFiles/authPayload.json" With Parameters "<authBody>"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    When I call the POST Request service <serviceName> endpoint <loginServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 200
    And Set Variable "SESSION" from Response Body with Expression "session"

    # Create Login Token
    Given I prepare the Body "BOLT/JsonFiles/tokenPayload.json" With Parameters "code=1111"
    Given I prepare the Body variable with Parameter name "session" and variable "SESSION"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    When I call the POST Request service <serviceName> endpoint <tokenServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 200
    Then Set Variable "REFRESH_TOKEN" from Response Body with Expression "refresh_token"
    Then Set Variable "ACCESS_TOKEN" from Response Body with Expression "access_token"

    #Create Assets
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    Given I prepare the request headers with key "Authorization" and prefix "Bearer" and Variable value "ACCESS_TOKEN"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    Given I prepare the Body <createVehicleFileName> With Parameters "<createVehicleBody>"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter <parameters> with Body
    Then Response Code should be <responseCode>
    And Response Body Should Exact Match the Value <message> with Expression "error_code"

    Examples:
      | authBody                  | serviceName    | loginServiceUri | tokenServiceUri | serviceUri       | responseCode | createVehicleFileName                | createVehicleBody                                                                                                                | parameters | headerValue | message         |
      | code=971 number=585597134 | "CUSTOMER-BFF" | "auth_bff_2_0"  | "authtoken_2_0" | "boltassets_2_0" | 404          | "BOLT/JsonFiles/createVehicles.json" | type=car subtype=hatchback city_id=2 country_id=1 exterior_color_type=red registration_plate_id=2 model_id=2 plate_number=87394  | "dgfdh"    | "en-US"     | "not_found"     |
      | code=971 number=585597134 | "CUSTOMER-BFF" | "auth_bff_2_0"  | "authtoken_2_0" | "boltassets_2_0" | 422          | "BOLT/JsonFiles/createVehicles.json" | type=s345 subtype=hatchback city_id=2 country_id=1 exterior_color_type=red registration_plate_id=2 model_id=2 plate_number=87394 | ""         | "en-US"     | "generic_error" |

  @BDDTEST-PE-3135
  Scenario Outline: "User should not be able to Create vehicles for Car Asset Type With 400 Error"
    Given I prepare the Body "BOLT/JsonFiles/authPayload.json" With Parameters "<authBody>"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    When I call the POST Request service <serviceName> endpoint <loginServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 200
    And Set Variable "SESSION" from Response Body with Expression "session"

    # Create Login Token
    Given I prepare the Body "BOLT/JsonFiles/tokenPayload.json" With Parameters "code=1111"
    Given I prepare the Body variable with Parameter name "session" and variable "SESSION"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    When I call the POST Request service <serviceName> endpoint <tokenServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 200
    Then Set Variable "REFRESH_TOKEN" from Response Body with Expression "refresh_token"
    Then Set Variable "ACCESS_TOKEN" from Response Body with Expression "access_token"

    #Create Assets
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    Given I prepare the request headers with key "Authorization" and prefix "Bearer" and Variable value "ACCESS_TOKEN"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    Given I prepare the Body With Parameters "{sdvfdvdfv}"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter <parameters> with Body
    Then Response Code should be <responseCode>
    And Response Body Should Exact Match the Value <message> with Expression "error_code"

    Examples:
      | authBody                  | serviceName    | loginServiceUri | tokenServiceUri | serviceUri       | responseCode | parameters | headerValue | message            |
      | code=971 number=585597134 | "CUSTOMER-BFF" | "auth_bff_2_0"  | "authtoken_2_0" | "boltassets_2_0" | 400          | ""         | "en-US"     | "validation_error" |


  @BDDTEST-PE-3137
  Scenario Outline: "User able to get the Vehicle Model type based on asset_type with 200 Successful Responses"
    Given I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en"
    And I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameters>
    Then Response Code should be <arg0>
    And Verify that response is not empty
    And the schema should match with the specification defined in <fileName>

    Examples:
      | serviceName    | serviceUri     | arg0 | parameters                             | fileName                                      |
      | "CUSTOMER-BFF" | "vehicle_make" | 200  | "/1/models?asset_subtype_key=sedan"    | "com/api/squads/BOLT/schema/model_by_ID.json" |
      | "CUSTOMER-BFF" | "vehicle_make" | 200  | "/1/models?asset_subtype_key=suv"      | "com/api/squads/BOLT/schema/model_by_ID.json" |
      | "CUSTOMER-BFF" | "vehicle_make" | 200  | "/897/models?asset_subtype_key=jetski" | "com/api/squads/BOLT/schema/model_by_ID.json" |


  @BDDTEST-PE-3138
  Scenario Outline: "User unable to Get the Vehicle Model type based on invalid asset_subtype with 422 as the response code"
    Given I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en"
    And I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameters>
    Then Response Code should be <arg0>

    Examples:
      | serviceName    | serviceUri     | arg0 | parameters                            |
      | "CUSTOMER-BFF" | "vehicle_make" | 422  | "/1/models?asset_subtype_key=sedn"    |
      | "CUSTOMER-BFF" | "vehicle_make" | 422  | "/1/models?asset_subtype_key=svu"     |
      | "CUSTOMER-BFF" | "vehicle_make" | 422  | "/897/models?asset_subtype_key=jetsk" |

  @BDDTEST-PE-3178
  Scenario Outline: "User able to get the Vehicle Model type based on asset_type with 200 Successful Responses"
    Given I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en"
    And I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameters>
    Then Response Code should be <arg0>
    And Verify that response is not empty

    Examples:
      | serviceName    | serviceUri     | arg0 | parameters                                          |
      | "CUSTOMER-BFF" | "vehicle_make" | 200  | "/1/models?asset_subtype_key=coupe"                 |
      | "CUSTOMER-BFF" | "vehicle_make" | 200  | "/1/models?asset_subtype_key=hatchback"             |
      | "CUSTOMER-BFF" | "vehicle_make" | 200  | "/1/models?asset_subtype_key=liftback"              |
      | "CUSTOMER-BFF" | "vehicle_make" | 200  | "/1/models?asset_subtype_key=pickup"                |
      | "CUSTOMER-BFF" | "vehicle_make" | 200  | "/1/models?asset_subtype_key=van"                   |
      | "CUSTOMER-BFF" | "vehicle_make" | 200  | "/1/models?asset_subtype_key=minivan"               |
      | "CUSTOMER-BFF" | "vehicle_make" | 200  | "/897/models?asset_subtype_key=marine-craft-<12m"   |
      | "CUSTOMER-BFF" | "vehicle_make" | 200  | "/897/models?asset_subtype_key=marine-craft-12-24m" |
      | "CUSTOMER-BFF" | "vehicle_make" | 200  | "/897/models?asset_subtype_key=marine-craft->24m"   |

  @BDDTEST-PE-3185
  Scenario Outline: "User able to get the Asset Subtypes with 200 Response code"
    Given I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en"
    And I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameters>
    Then Response Code should be <arg0>
    And Verify that response is not empty
    And the schema should match with the specification defined in <fileName>
    And Response Body Should Exact Match the Value <subType> with Expression "data[0].type"


    Examples:
      | serviceName    | serviceUri          | arg0 | parameters             | fileName                                                       | subType      |
      | "CUSTOMER-BFF" | "assetssubtype_2_0" | 200  | "/car/subtypes"        | "com/api/squads/BOLT/schema/customer_bff_assets_subtypes.json" | "car"        |
      | "CUSTOMER-BFF" | "assetssubtype_2_0" | 200  | "/boat/subtypes"       | "com/api/squads/BOLT/schema/customer_bff_assets_subtypes.json" | "boat"       |
      | "CUSTOMER-BFF" | "assetssubtype_2_0" | 200  | "/motorcycle/subtypes" | "com/api/squads/BOLT/schema/customer_bff_assets_subtypes.json" | "motorcycle" |
      | "CUSTOMER-BFF" | "assetssubtype_2_0" | 200  | "/bus/subtypes"        | "com/api/squads/BOLT/schema/customer_bff_assets_subtypes.json" | "bus"        |
      | "CUSTOMER-BFF" | "assetssubtype_2_0" | 200  | "/truck/subtypes"      | "com/api/squads/BOLT/schema/customer_bff_assets_subtypes.json" | "truck "     |


  @BDDTEST-PE-3189
  Scenario Outline: "User unable to get the Asset subtype with 400/404 as the response code"
    Given I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en"
    And I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameters>
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value <Message> with Expression "error_code"

    Examples:
      | serviceName    | serviceUri          | arg0 | parameters              | Message            |
      | "CUSTOMER-BFF" | "assetssubtype_2_0" | 400  | "/cars/subtypes"        | "validation_error" |
      | "CUSTOMER-BFF" | "assetssubtype_2_0" | 400  | "/trcku/subtypes"       | "validation_error" |
      | "CUSTOMER-BFF" | "assetssubtype_2_0" | 404  | "/bus/sbtypes"          | "not_found"        |
      | "CUSTOMER-BFF" | "assetssubtype_2_0" | 404  | "/motorcycles/sutbypes" | "not_found"        |


  @BDDTEST-PE-3335
  Scenario Outline: "User able to get the Emergency Bubble details with 200 Response code"
    Given I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en"
    And I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameters>
    Then Response Code should be <arg0>
    And Verify that response is not empty
    And the schema should match with the specification defined in <fileName>
    And Response Body Should Exact Match the Value <subType> with Expression "data[0].app_location"

    Examples:
      | serviceName    | serviceUri            | arg0 | parameters                                           | fileName                                                                 | subType           |
      | "CUSTOMER-BFF" | "content_screens_2_0" | 200  | "?content_location=battery-service&platform=android" | "com/api/squads/BOLT/schema/customer_bff_content_product-selection.json" | "battery-service" |
      | "CUSTOMER-BFF" | "content_screens_2_0" | 200  | "?content_location=battery-service&platform=ios"     | "com/api/squads/BOLT/schema/customer_bff_content_product-selection.json" | "battery-service" |


  @BDDTEST-PE-3340
  Scenario Outline: "User should not be able to fetch Emergency Bubble details with 400/422 Response Code"
    Given I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en"
    And I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameters>
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value <Message> with Expression "error_code"

    Examples:
      | serviceName    | serviceUri            | arg0 | parameters                                            | Message            |
      | "CUSTOMER-BFF" | "content_screens_2_0" | 400  | "?content_location=battery-service"                   | "validation_error" |
      | "CUSTOMER-BFF" | "content_screens_2_0" | 400  | "?platform=android"                                   | "validation_error" |
      | "CUSTOMER-BFF" | "content_screens_2_0" | 400  | "?platform=ios"                                       | "validation_error" |
      | "CUSTOMER-BFF" | "content_screens_2_0" | 422  | "?content_location=battery-service&platform=ioscncbn" | "generic_error"    |


  @BDDTEST-PE-3390
  Scenario Outline: "User is able to fetch BOT details with 200 Response Code"
    Given I prepare the request headers with key "Accept" and prefix "" and Static value "application/json"
    And I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameters>
    Then Response Code should be <arg0>
    And Verify that response is not empty
    And Response Body Should Exact Match the Value <name> with Expression "data[0].verticals.name"
    And Response Body Should Exact Match the Value <pricing_type> with Expression "data[0].variations.pricing.type"
    And Response Body Should not blank with Expression "data[0].id"
    And Response Body Should not blank with Expression "data[0].short_description"
    And Response Body Should not blank with Expression "data[0].short_name"
    And Response Body Should not blank with Expression "data[0].status"
    And Response Body Should not blank with Expression "data[0].type"
    And Response Body Should not blank with Expression "data[0].variations.id"
    And Response Body Should not blank with Expression "data[0].variations.name"
    And Response Body Should not blank with Expression "data[0].variations.status"
    And Response Body Should not blank with Expression "data[0].variations.duration_minutes"
    And Response Body Should not blank with Expression "data[0].variations.pricing.price"
    And Response Body Should not blank with Expression "data[0].variations.media.brands.id"
    And Response Body Should not blank with Expression "data[0].variations.media.brands.url"
    And Response Body Should not blank with Expression "data[0].variations.media.content.id"
    And Response Body Should not blank with Expression "data[0].variations.media.content.url"
    And Response Body Should not blank with Expression "data[0].verticals.id"

    Examples:
      | serviceName    | serviceUri          | arg0 | parameters                                                                           | name                 | pricing_type |
      | "CUSTOMER-BFF" | "catalog_items_2_0" | 200  | "?verticals=tyre&include=variations,verticals,pricing&media.include=variations"      | "[Tyre Services]"    | "[per-unit]" |
      | "CUSTOMER-BFF" | "catalog_items_2_0" | 200  | "?verticals=battery&include=variations,verticals,pricing&media.include=variations"   | "[Battery Services]" | "[per-unit]" |
      | "CUSTOMER-BFF" | "catalog_items_2_0" | 200  | "?verticals=servicing&include=variations,pricing,verticals&media.include=variations" | "[Servicing]"        | "[per-unit]" |


  @BDDTEST-PE-3391
  Scenario Outline: "User is able to fetch Emergency Screen details with 200 Response Code"
    Given I prepare the request headers with key "Accept" and prefix "" and Static value "application/json"
    And I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameters>
    Then Response Code should be <arg0>
    And Verify that response is not empty
    And Response Body Should Exact Match the Value <name> with Expression "data[0].verticals.name"
    And Response Body Should Exact Match the Value <pricing_type> with Expression "data[0].variations.pricing.type"
    And Response Body Should Exact Match the Value <first_service> with Expression "data[0].short_name"
    And Response Body Should Exact Match the Value <second_service> with Expression "data[1].short_name"
    And Response Body Should Exact Match the Value <third_service> with Expression "data[2].short_name"
    And Response Body Should Exact Match the Value <fourth_service> with Expression "data[3].short_name"
    And Response Body Should Exact Match the Value <fifth_service> with Expression "data[4].short_name"
    And Response Body Should not blank with Expression "data[0].id"
    And Response Body Should not blank with Expression "data[0].variations.id"
    And Response Body Should not blank with Expression "data[0].verticals.id"
    And Response Body Should not blank with Expression "data[1].id"
    And Response Body Should not blank with Expression "data[1].variations.id"
    And Response Body Should not blank with Expression "data[1].verticals.id"
    And Response Body Should not blank with Expression "data[2].id"
    And Response Body Should not blank with Expression "data[2].variations.id"
    And Response Body Should not blank with Expression "data[2].verticals.id"
    And Response Body Should not blank with Expression "data[3].id"
    And Response Body Should not blank with Expression "data[3].variations.id"
    And Response Body Should not blank with Expression "data[3].verticals.id"
    And Response Body Should not blank with Expression "data[4].id"
    And Response Body Should not blank with Expression "data[4].variations.id"
    And Response Body Should not blank with Expression "data[4].verticals.id"

    Examples:
      | serviceName    | serviceUri          | arg0 | parameters                                                                           | name                   | pricing_type | first_service    | second_service | third_service       | fourth_service         | fifth_service |
      | "CUSTOMER-BFF" | "catalog_items_2_0" | 200  | "?verticals=emergency&include=variations,pricing,verticals&media.include=variations" | "[Emergency Services]" | "[per-unit]" | "Emergency fuel" | "Jump start"   | "Spare tyre change" | "Tyre pressure top-up" | "Tow"         |

  @BDDTEST-PE-3448
  Scenario Outline: "User able to get the Timeslots for Carwash with 200 Response code"
    Given I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en"
    And I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameters>
    Then Response Code should be <arg0>
    And Verify that response is not empty
    And the schema should match with the specification defined in <fileName>
    And Response Body Should not blank with Expression "data[0].timeslots.id"
    And Response Body Should not blank with Expression "data[0].timeslots.starts_at"
    And Response Body Should not blank with Expression "data[0].timeslots.ends_at"
    And Response Body Should Contains the Current Date Value "yyyy-MM-dd'T'" with Expression "data[0].date"
#    And Response Body Should Contains the Current Date Value {string} with Expression "data[0].date"

    Examples:
      | serviceName    | serviceUri      | arg0 | parameters                     | fileName                                                 |
      | "CUSTOMER-BFF" | "timeslots_2_0" | 200  | "?lat=25.197525&lng=55.274288" | "com/api/squads/BOLT/schema/customer_bff_timeslots.json" |
      | "CUSTOMER-BFF" | "timeslots_2_0" | 200  | "?lat=25.197525&lng=55.274288" | "com/api/squads/BOLT/schema/customer_bff_timeslots.json" |
      | "CUSTOMER-BFF" | "timeslots_2_0" | 200  | "?lat=25.197525&lng=55.274288" | "com/api/squads/BOLT/schema/customer_bff_timeslots.json" |
      | "CUSTOMER-BFF" | "timeslots_2_0" | 200  | "?lat=25.197525&lng=55.274288" | "com/api/squads/BOLT/schema/customer_bff_timeslots.json" |

  @BDDTEST-PE-3449
  Scenario Outline: "User is unable to fetch Timeslots for Carwash if incorrect/incomplete parameters/headers provided"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    Given I prepare the request headers with key "Accept-Language" and prefix "" and Static value <lang>
    And I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameters>
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value <Message> with Expression "error_code"

    Examples:
      | serviceName    | serviceUri      | arg0 | parameters                     | Message            | lang  |
      | "CUSTOMER-BFF" | "timeslots_2_0" | 422  | ""                             | "validation_error" | "en"  |
      | "CUSTOMER-BFF" | "timeslots_2_0" | 422  | "?lng=55.274288"               | "validation_error" | "en"  |
      | "CUSTOMER-BFF" | "timeslots_2_0" | 422  | "?lat=25.197525"               | "validation_error" | "en"  |
      | "CUSTOMER-BFF" | "timeslots_2_0" | 422  | "?lat=25.197525&lng=55.274288" | "validation_error" | "ety" |
      | "CUSTOMER-BFF" | "timeslots_2_0" | 400  | "?lat=25.197525&lng=55.274288" | "validation_error" | ""    |
      | "CUSTOMER-BFF" | "timeslots_2_0" | 404  | "lat=25.197525&lng=55.274288"  | "not_found"        | "en"  |