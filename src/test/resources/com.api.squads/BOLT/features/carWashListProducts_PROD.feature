@BOLT @CarWash_PRODUCTION @ListProduct @Regression
Feature: Car Wash List Product Service API

  Background:
    # This Test case for Car Wash Module
    # @temp-swapnil.salunke@cafu.com
    # Total number test cases Car wash: 1
    # Total number test cases for Tyre: 2
    # Total number test cases for Emergency service: 1
    # Total number test cases for Invoice: 1
    # Total number test cases for Get Wallet Information: 1
    # Total number test cases for Cash/POS Payment: 1
    # Total number All Test cases: 7

  # ----------------------------------- Car Wash List Products Test Cases : 1 ------------------------------------------


  @BDDTEST-PE-1328 @P1 @BoltService @CarWash @ListProduct @PROD_BOLT
  Scenario Outline: TestCase_Verify Car Wash List Products API post call with incorrect endpoint for not supporting vehicle
    Given I prepare the request headers with key "Cafu-JW-Access-Token" and prefix "" and Static value <token>
    Given I prepare the Body With Parameters "{}"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be <responseCode>
    And Verify that response is not empty
    And Response Body Should Exact Match the Variable "serviceData not found" with Expression "ErrorMessage"

    Examples:
      | serviceName | serviceUri     | responseCode | token                                        |
      | "CARWASH"   | "listProducts" | 404          | "0d673bc3b31442401c152d30161925441fedc4fd2f" |


# ------------------------------------------------------------------------------------------------------------------------------------------

        # ----------------------------------- V3 - List Tyre Change Products Test Cases : 2 -----------------------------------------------------------

  @BDDTEST-PE-1607 @P1 @BoltService @CarWash @V3ListTyreChange @PROD_BOLT
  Scenario Outline: TestCase_Verify List Tyre Change Product V3
    Given I prepare the request headers with key "Cafu-JW-Access-Token" and prefix "" and Static value <token>
    When I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters "?brand=<brand>&width=<width>&profile=<profile>&rim=<rim>"
    Then Response Code should be <status>
    And Response Body Should Contains the Value "<ID>" with Expression "data.id"
    And Response Body Should Contains the Value "<SKU>" with Expression "data.sku"
    And Response Body Should Contains the Value "<BRAND>" with Expression "data.brand"
    And Response Body Should Contains the Value "<MODEL>" with Expression "data.model"
    And Response Body Should Contains the Value "<BASE>" with Expression "data.base"
    And Response Body Should Contains the Value "<SUBBASE>" with Expression "data.subBase"
    And Response Body Should Contains the Value "<WIDTH>" with Expression "data.dimensions.width"
    And Response Body Should Contains the Value "<PROFILE>" with Expression "data.dimensions.profile"
    And Response Body Should Contains the Value "<RIM>" with Expression "data.dimensions.rim"
    And Response Body Should Contains the Value "<COUNTRY>" with Expression "data.manufacturingCountry.country"
    And Response Body Should Contains the Value "<DATE>" with Expression "data.manufacturingDate"
    And Response Body Should Contains the Value "<AMOUNT>" with Expression "data.price.amount"
    And Response Body Should Contains the Value "<CURRENCY>" with Expression "data.price.currency"
    And Response Body Should Contains the Value "<TEXT>" with Expression "data.price.text"
    And Response Body Should Contains the Value "3 Years" with Expression "data.warranty"
    And Response Body Should Contains the Value "" with Expression "data.itemId"
    And Response Body Should Contains the Value "" with Expression "data.itemStatus"
    And Response Body Should Contains the Value "3+1 Offer" with Expression "data.offer"

    Examples:
      | serviceName | serviceUri       | token                                        | status | brand      | width | profile | rim | ID   | SKU           | BRAND      | MODEL | BASE      | SUBBASE        | WIDTH | PROFILE | RIM | COUNTRY | DATE | AMOUNT | CURRENCY | TEXT       |
      | "CARWASH"   | "listTyreChange" | "0d673bc3b31442401c152d30161925441fedc4fd2f" | 200    | Doublestar | 205   | 45      | 17  | 3537 | DS1PUZ2054517 | Doublestar | DSU02 | 205/45R17 | 205/45R17 88W  | 205   | 45      | 17  | China   | 2023 | 266    | AED      | AED 266.00 |
      | "CARWASH"   | "listTyreChange" | "0d673bc3b31442401c152d30161925441fedc4fd2f" | 200    | Doublestar | 235   | 55      | 18  | 3547 | DS3PS02355518 | Doublestar | DSS02 | 235/55R18 | 235/55R18 100V | 235   | 55      | 18  | China   | 2023 | 339    | AED      | AED 339.00 |
      | "CARWASH"   | "listTyreChange" | "0d673bc3b31442401c152d30161925441fedc4fd2f" | 200    | Doublestar | 245   | 45      | 19  | 3550 | DS3PUZ2454519 | Doublestar | DSU02 | 245/45R19 | 245/45R19 102W | 245   | 45      | 19  | China   | 2023 | 346    | AED      | AED 346.00 |
      | "CARWASH"   | "listTyreChange" | "0d673bc3b31442401c152d30161925441fedc4fd2f" | 200    | Doublestar | 265   | 40      | 21  | 3557 | DS1PTZ2654021 | Doublestar | DSU02 | 265/40R21 | 265/40R21 105Y | 265   | 40      | 21  | China   | 2023 | 442    | AED      | AED 442.00 |
      | "CARWASH"   | "listTyreChange" | "0d673bc3b31442401c152d30161925441fedc4fd2f" | 200    | Doublestar | 275   | 45      | 21  | 3561 | DS1PUZ2754521 | Doublestar | DSU02 | 275/45R21 | 275/45R21 110W | 275   | 45      | 21  | China   | 2023 | 468    | AED      | AED 468.00 |
      | "CARWASH"   | "listTyreChange" | "0d673bc3b31442401c152d30161925441fedc4fd2f" | 200    | Doublestar | 165   | 65      | 14  | 3564 | DS3PH01656514 | Doublestar | DH05  | 165/65R14 | 165/65R14 79T  | 165   | 65      | 14  | China   | 2023 | 231    | AED      | AED 231.00 |
      | "CARWASH"   | "listTyreChange" | "0d673bc3b31442401c152d30161925441fedc4fd2f" | 200    | Doublestar | 185   | 65      | 14  | 3565 | DS3PH01856514 | Doublestar | DH05  | 185/65R14 | 185/65R14 86H  | 185   | 65      | 14  | China   | 2023 | 247    | AED      | AED 247.00 |

  @BDDTEST-PE-1608 @P1 @BoltService @CarWash @V3ListTyreChange @PROD_BOLT
  Scenario Outline: TestCase_Verify List Tyre Change Product V3 with inavalid params
    Given I prepare the request headers with key "Cafu-JW-Access-Token" and prefix "" and Static value <token>
    When I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters "?brand=<brand>&width=<width>&profile=<profile>&rim=<rim>"
    Then Response Code should be <status>
    And Response Body Should Contains the Value "[]" with Expression "data"

    Examples:
      | serviceName | serviceUri       | token                                        | status | brand       | width | profile | rim |
      | "CARWASH"   | "listTyreChange" | "0d673bc3b31442401c152d30161925441fedc4fd2f" | 200    | Doublestar1 | 185   | 65      | 14  |
      | "CARWASH"   | "listTyreChange" | "0d673bc3b31442401c152d30161925441fedc4fd2f" | 200    | Doublestar  | 100   | 65      | 14  |
      | "CARWASH"   | "listTyreChange" | "0d673bc3b31442401c152d30161925441fedc4fd2f" | 200    | Doublestar  | 185   | 00      | 14  |
      | "CARWASH"   | "listTyreChange" | "0d673bc3b31442401c152d30161925441fedc4fd2f" | 200    | Doublestar  | 185   | 65      | 01  |
      | "CARWASH"   | "listTyreChange" | "0d673bc3b31442401c152d30161925441fedc4fd2f" | 200    |             | 185   | 65      | 01  |
      | "CARWASH"   | "listTyreChange" | "0d673bc3b31442401c152d30161925441fedc4fd2f" | 200    | Doublestar  |       | 65      | 01  |
      | "CARWASH"   | "listTyreChange" | "0d673bc3b31442401c152d30161925441fedc4fd2f" | 200    | Doublestar  | 185   |         | 01  |
      | "CARWASH"   | "listTyreChange" | "0d673bc3b31442401c152d30161925441fedc4fd2f" | 200    | Doublestar  | 185   | 65      |     |

        # ----------------------------------- Car Wash Completed Order Invoice Test Cases : 1 -----------------------------------------------------------
  @BDDTEST-PE-2169 @P1 @BoltService @CarWash @V3ListTyreChange @PROD_BOLT
  Scenario Outline: POST with empty Payload call to send invoice of order
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    Given I prepare the request headers with key "Cafu-Jw-Access-Token" and prefix "" and Static value "152b61d0a51d4c031c152d3a1c13224e18e3c1f922"
    Given I prepare the Body With Parameters "{}"
    When I call the POST Request service <serviceName> endpoint <ServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be <responseCode>
    Examples:
      | serviceName | ServiceUri | responseCode |
      | "CARWASH"   | "invoice"  | 422          |

      # ----------------------------------- Emergency Services Test Cases : 1 -----------------------------------------------------------

  @BDDTEST-PE-2468 @PE-2320 @P1 @BoltService @EmergencyService @CarWash @PROD_BOLT
  Scenario Outline: POST with Verify emergency service without mandetory parameters.
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    Given I prepare the request headers with key "Cafu-Jw-Access-Token" and prefix "" and Static value "152b61d0a51d4c031c152d3a1c13224e18e3c1f922"
    Given I prepare the Body <fileName> With Parameters <body>
    Given I remove the parameter from the request body Parameter is <param>
    When I call the POST Request service <serviceName> endpoint <ServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be <responseCode>
    Examples:
      | fileName                                | body                                            | serviceName | ServiceUri  | responseCode | param        |
      | "BOLT/JsonFiles/Emergency_Service.json" | "vehicleID=5097 customerID=3132 serviceCode=ES" | "CARWASH"   | "emergency" | 400          | "vehicleID"  |
      | "BOLT/JsonFiles/Emergency_Service.json" | "vehicleID=5097 customerID=3132 serviceCode=ES" | "CARWASH"   | "emergency" | 400          | "customerID" |
      | "BOLT/JsonFiles/Emergency_Service.json" | "vehicleID=5097 customerID=3132 serviceCode=ES" | "CARWASH"   | "emergency" | 400          | "productID"  |


        # ----------------------------------- Get Wallet Information Test Cases : 1 -----------------------------------------------------------
  @BDDTEST-PE-2515 @Bolt-599 @P2 @BoltService @CarWash @PROD_BOLT
  Scenario Outline: TestCase_Verify Get Wallet Credit Information
    Given I prepare the request headers with key "Cafu-JW-Access-Token" and prefix "" and Static value <token>
    When I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters ""
    Then Response Code should be <status>
    And Response Body Should Contains the Value <Service code 1> with Expression "data"
    And Response Body Should Contains the Value <Service code 2> with Expression "data"
    And Response Body Should Contains the Value <Service code 3> with Expression "data"
    And Response Body Should Contains the Value <Service code 4> with Expression "data"

    Examples:
      | serviceName | serviceUri        | token                                        | status | Service code 1 | Service code 2 | Service code 3 | Service code 4 |
      | "CARWASH"   | "getwalletcredit" | "0d673bc3b31442401c152d30161925441fedc4fd2f" | 200    | "ES"           | "EJS"          | "ET"           | "ETR"          |

           # ----------------------------------- CASH/POS Payment details Test Cases : 1 -----------------------------------------------------------

  @BDDTEST-PE-2522 @Bolt-195 @P1 @BoltService @EmergencyService @CarWash @PROD_BOLT
  Scenario Outline: POST with Verify cash payment with invalid order id
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    Given I prepare the request headers with key "Cafu-Jw-Access-Token" and prefix "" and Static value "152b61d0a51d4c031c152d3a1c13224e18e3c1f922"
    When I call the POST Request service <serviceName> endpoint <ServiceUri> with Variable "" and Parameter "/0WO01000003BYhdG/paid-by-cash" with Body
    Then Response Code should be <responseCode>

    Examples:
      | serviceName | ServiceUri    | responseCode |
      | "CARWASH"   | "cashpayment" | 404          |

