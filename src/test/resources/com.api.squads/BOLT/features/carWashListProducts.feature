@BOLT @CarWash @ListProduct @Regression
Feature: Car Wash List Product Service API

  Background:
    # This Test case for Car Wash Module
    # @temp-swapnil.salunke@cafu.com
    # Total number test cases Car wash: 9
    # Total number test cases for Tyre: 2
    # Total number test cases for Emergency service: 4
    # Total number test cases for polygon: 1
    # Total number test cases for Invoice: 4
    # Total number test cases for Get Wallet Information: 1
    # Total number test cases for Cash/POS Payment: 3
    # Total number All Test cases: 23

  # ----------------------------------- Car Wash List Products Test Cases : 9 ------------------------------------------

  @BDDTEST-PE-1326 @P1 @BoltService @CarWash @ListProduct
  Scenario Outline: TestCase_Verify Car Wash List Products API returns 400 status code for not supporting vehicle
    Given I prepare the request headers with key "Cafu-JW-Access-Token" and prefix "" and Static value <token>
    Given I prepare the Body <fileName> With Parameters "<body>"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be <responseCode>
    And Verify that response is not empty

    Examples:
      | serviceName | serviceUri     | fileName                           | responseCode | body                                                                                                      | token                              |
      | "CARWASH"   | "listProducts" | "BOLT/JsonFiles/listProducts.json" | 200          | applyPromo=false lat=25.200901313365332 lng=55.27169108390808 serviceId=0VS01000000KzejGAC vehicleID=8    | "6129af88b3ca1dd7ec20b4c8e141c7aa" |
      | "CARWASH"   | "listProducts" | "BOLT/JsonFiles/listProducts.json" | 400          | applyPromo=false lat=25.200901313365332 lng=55.27169108390808 serviceId=0VS01000000KzejGAC vehicleID=1255 | "6129af88b3ca1dd7ec20b4c8e141c7aa" |
      | "CARWASH"   | "listProducts" | "BOLT/JsonFiles/listProducts.json" | 400          | applyPromo=false lat=25.200901313365332 lng=55.27169108390808 serviceId=0VS01000000KzejGAC vehicleID=2527 | "6129af88b3ca1dd7ec20b4c8e141c7aa" |
      | "CARWASH"   | "listProducts" | "BOLT/JsonFiles/listProducts.json" | 400          | applyPromo=false lat=25.200901313365332 lng=55.27169108390808 serviceId=0VS01000000KzejGAC vehicleID=329  | "6129af88b3ca1dd7ec20b4c8e141c7aa" |
      | "CARWASH"   | "listProducts" | "BOLT/JsonFiles/listProducts.json" | 500          | applyPromo=false lat=25.200901313365332 lng=55.27169108390808 serviceId=0VS01000000KzejGAC vehicleID=2429 | "6129af88b3ca1dd7ec20b4c8e141c7aa" |
      | "CARWASH"   | "listProducts" | "BOLT/JsonFiles/listProducts.json" | 400          | applyPromo=true lat=25.200901313365332 lng=55.27169108390808 serviceId=0VS01000000KzejGAC vehicleID=1255  | "6129af88b3ca1dd7ec20b4c8e141c7aa" |
      | "CARWASH"   | "listProducts" | "BOLT/JsonFiles/listProducts.json" | 400          | applyPromo=TRUE lat=25.200901313365332 lng=55.27169108390808 serviceId=0VS01000000KzejGAC vehicleID=1255  | "6129af88b3ca1dd7ec20b4c8e141c7aa" |
      | "CARWASH"   | "listProducts" | "BOLT/JsonFiles/listProducts.json" | 400          | applyPromo=\"\" lat=25.200901313365332 lng=55.27169108390808 serviceId=0VS01000000KzejGAC vehicleID=1255  | "6129af88b3ca1dd7ec20b4c8e141c7aa" |
      | "CARWASH"   | "listProducts" | "BOLT/JsonFiles/listProducts.json" | 400          | applyPromo=false lat=\"\" lng=\"\" serviceId=0VS01000000KzejGAC vehicleID=1255                            | "6129af88b3ca1dd7ec20b4c8e141c7aa" |
      | "CARWASH"   | "listProducts" | "BOLT/JsonFiles/listProducts.json" | 404          | applyPromo=false lat=0 lng=55.27169108390808 serviceId=0VS01000000KzejGAC vehicleID=1255                  | "6129af88b3ca1dd7ec20b4c8e141c7aa" |
      | "CARWASH"   | "listProducts" | "BOLT/JsonFiles/listProducts.json" | 404          | applyPromo=false lat=25.200901313365332 lng=0 serviceId=0VS01000000KzejGAC vehicleID=1255                 | "6129af88b3ca1dd7ec20b4c8e141c7aa" |
      | "CARWASH"   | "listProducts" | "BOLT/JsonFiles/listProducts.json" | 400          | applyPromo=false lat=25.200901313365332 lng=27169108390808 serviceId=\"\" vehicleID=1255                  | "6129af88b3ca1dd7ec20b4c8e141c7aa" |
      | "CARWASH"   | "listProducts" | "BOLT/JsonFiles/listProducts.json" | 404          | applyPromo=false lat=25.200901313365332 lng=27169108390808 serviceId=0 vehicleID=1255                     | "6129af88b3ca1dd7ec20b4c8e141c7aa" |
      | "CARWASH"   | "listProducts" | "BOLT/JsonFiles/listProducts.json" | 400          | applyPromo=false lat=25.200901313365332 lng=27169108390808 serviceId=0VS01000000KzejGAC vehicleID=\"\"    | "6129af88b3ca1dd7ec20b4c8e141c7aa" |

  @BDDTEST-PE-1327 @P1 @BoltService @CarWash @ListProduct
  Scenario Outline: TestCase_Verify Car Wash List Products API post call with incorrect body for not supporting vehicle
    Given I prepare the request headers with key "Cafu-JW-Access-Token" and prefix "" and Static value <token>
    Given I prepare the Body <fileName> With Parameters "<body>"
    Given I remove the parameter from the request body Parameter is <param>
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be <responseCode>
    And Verify that response is not empty

    Examples:
      | serviceName | serviceUri     | fileName                           | responseCode | body                                                                                                      | param               | token                              |
      | "CARWASH"   | "listProducts" | "BOLT/JsonFiles/listProducts.json" | 400          | applyPromo=false lat=25.200901313365332 lng=55.27169108390808 serviceId=0VS01000000KzejGAC vehicleID=1255 | "applyPromo"        | "6129af88b3ca1dd7ec20b4c8e141c7aa" |
      | "CARWASH"   | "listProducts" | "BOLT/JsonFiles/listProducts.json" | 404          | applyPromo=false lat=25.200901313365332 lng=55.27169108390808 serviceId=0VS01000000KzejGAC vehicleID=1255 | "coords"            | "6129af88b3ca1dd7ec20b4c8e141c7aa" |
      | "CARWASH"   | "listProducts" | "BOLT/JsonFiles/listProducts.json" | 404          | applyPromo=false lat=25.200901313365332 lng=55.27169108390808 serviceId=0VS01000000KzejGAC vehicleID=1255 | "serviceId"         | "6129af88b3ca1dd7ec20b4c8e141c7aa" |
      | "CARWASH"   | "listProducts" | "BOLT/JsonFiles/listProducts.json" | 200          | applyPromo=false lat=25.200901313365332 lng=55.27169108390808 serviceId=0VS01000000KzejGAC vehicleID=1255 | "vehicleEngineInfo" | "6129af88b3ca1dd7ec20b4c8e141c7aa" |

  @BDDTEST-PE-1328 @P1 @BoltService @CarWash @ListProduct
  Scenario Outline: TestCase_Verify Car Wash List Products API post call with incorrect endpoint for not supporting vehicle
    Given I prepare the request headers with key "Cafu-JW-Access-Token" and prefix "" and Static value <token>
    Given I prepare the Body With Parameters "{}"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be <responseCode>
    And Verify that response is not empty
    And Response Body Should Exact Match the Variable "serviceData not found" with Expression "ErrorMessage"

    Examples:
      | serviceName | serviceUri     | responseCode | token                              |
      | "CARWASH"   | "listProducts" | 404          | "6129af88b3ca1dd7ec20b4c8e141c7aa" |

  @BDDTEST-PE-1329 @P1 @BoltService @CarWash @ListProduct
  Scenario Outline: TestCase_Verify Car Wash List Products API post with incorrect Methodtype
    Given I prepare the request headers with key "Cafu-JW-Access-Token" and prefix "" and Static value <token>
    Given I prepare the Body <fileName> With Parameters "<body>"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable <variable> and Parameter <parameters> with Body
    Then Response Code should be <responseCode>

    Examples:
      | serviceName | serviceUri     | fileName                           | responseCode | body           | parameters | variable | token                              |
      | "CARWASH"   | "listProducts" | "BOLT/JsonFiles/listProducts.json" | 405          | vehicleID=1255 | ""         | ""       | "6129af88b3ca1dd7ec20b4c8e141c7aa" |

  @BDDTEST-PE-1754 @P1 @BoltService @CarWash @ListProduct
  Scenario Outline: TestCase_Verify Car Wash List Products API returns 200 status code with Tags, Price and Time for Premium Wash type
    Given I prepare the request headers with key "Cafu-JW-Access-Token" and prefix "" and Static value <token>
    Given I prepare the Body <fileName> With Parameters "<body>"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be <responseCode>
    And Verify that response is not empty

    #Premium Wash Car Wash Service
    And Response Body Should Contains the Value "08q01000000L9ZAAA0" with Expression "data[0].id"
    And Response Body Should Contains the Value "UAE_DBX_CW_005" with Expression "data[0].code"
    And Response Body Should Contains the Value "Premium Wash" with Expression "data[0].name"
    And Response Body Should Contains the Value "• Deep exterior & interior clean with best-in-class steamers" with Expression "data[0].description"
    And Response Body Should Contains the Value "• Cleans stains, oils, grease, dirt and odours" with Expression "data[0].description"
    And Response Body Should Contains the Value "• Includes vacuuming, and tyre foam detailing" with Expression "data[0].description"
    And Response Body Should Contains the Value "false" with Expression "data[0].isRecommended"
    And Response Body Should Contains the Value "false" with Expression "data[0].price.isEstimated"
    And Response Body Should Contains the Value "99" with Expression "data[0].price.original.amount"
    And Response Body Should Contains the Value "AED" with Expression "data[0].price.original.currency"
    And Response Body Should Contains the Value "AED 99.00" with Expression "data[0].price.original.text"
    And Response Body Should Contains the Value "99" with Expression "data[0].price.discounted.amount"
    And Response Body Should Contains the Value "AED" with Expression "data[0].price.discounted.currency"
    And Response Body Should Contains the Value "AED 99.00" with Expression "data[0].price.discounted.text"
    And Response Body Should Contains the Value "70" with Expression "data[0].timeToComplete.value"
    And Response Body Should Contains the Value "55" with Expression "data[0].timeToComplete.min"
    And Response Body Should Contains the Value "70" with Expression "data[0].timeToComplete.max"
    And Response Body Should Contains the Value "55 - 70 minutes" with Expression "data[0].timeToComplete.text"
    And Response Body Should Contains the Value "Exterior, Interior, Water" with Expression "data[0].tags"

    Examples:
      | serviceName | serviceUri     | fileName                           | responseCode | body                                                                                                   | token                              |
      | "CARWASH"   | "listProducts" | "BOLT/JsonFiles/listProducts.json" | 200          | applyPromo=false lat=25.200901313365332 lng=55.27169108390808 serviceId=0VS01000000KzeeGAC vehicleID=8 | "6129af88b3ca1dd7ec20b4c8e141c7aa" |


  @BDDTEST-PE-1791 @P1 @BoltService @CarWash @ListProduct
  Scenario Outline: TestCase_Verify Car Wash List Products API returns 200 status code with Tags, Price and Time for Classic Clean type
    Given I prepare the request headers with key "Cafu-JW-Access-Token" and prefix "" and Static value <token>
    Given I prepare the Body <fileName> With Parameters "<body>"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be <responseCode>
    And Verify that response is not empty

    #Classic Clean Car Wash Service
    And Response Body Should Contains the Value "08q01000000L9Z8AAK" with Expression "data[1].id"
    And Response Body Should Contains the Value "UAE_DBX_CW_003" with Expression "data[1].code"
    And Response Body Should Contains the Value "Classic Clean" with Expression "data[1].name"
    And Response Body Should Contains the Value "• Eco-friendly waterless cleaning" with Expression "data[1].description"
    And Response Body Should Contains the Value "• Hand washed with chemical and wax spray, and microfiber towels" with Expression "data[1].description"
    And Response Body Should Contains the Value "false" with Expression "data[1].isRecommended"
    And Response Body Should Contains the Value "false" with Expression "data[1].price.isEstimated"
    And Response Body Should Contains the Value "35" with Expression "data[1].price.original.amount"
    And Response Body Should Contains the Value "AED" with Expression "data[1].price.original.currency"
    And Response Body Should Contains the Value "AED 35.00" with Expression "data[1].price.original.text"
    And Response Body Should Contains the Value "35" with Expression "data[1].price.discounted.amount"
    And Response Body Should Contains the Value "AED" with Expression "data[1].price.discounted.currency"
    And Response Body Should Contains the Value "AED 35.00" with Expression "data[1].price.discounted.text"
    And Response Body Should Contains the Value "50" with Expression "data[1].timeToComplete.value"
    And Response Body Should Contains the Value "35" with Expression "data[1].timeToComplete.min"
    And Response Body Should Contains the Value "50" with Expression "data[1].timeToComplete.max"
    And Response Body Should Contains the Value "35 - 50 minutes" with Expression "data[1].timeToComplete.text"
    And Response Body Should Contains the Value "Exterior" with Expression "data[1].tags"

    Examples:
      | serviceName | serviceUri     | fileName                           | responseCode | body                                                                                                   | token                              |
      | "CARWASH"   | "listProducts" | "BOLT/JsonFiles/listProducts.json" | 200          | applyPromo=false lat=25.200901313365332 lng=55.27169108390808 serviceId=0VS01000000KzeeGAC vehicleID=8 | "6129af88b3ca1dd7ec20b4c8e141c7aa" |


  @BDDTEST-PE-1792 @P1 @BoltService @CarWash @ListProduct
  Scenario Outline: TestCase_Verify Car Wash List Products API returns 200 status code with Tags, Price and Time for Classic Clean + Interior type
    Given I prepare the request headers with key "Cafu-JW-Access-Token" and prefix "" and Static value <token>
    Given I prepare the Body <fileName> With Parameters "<body>"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be <responseCode>
    And Verify that response is not empty

    #Classic Clean + Interior Car Wash Service
    And Response Body Should Contains the Value "08q01000000L9Z9AAK" with Expression "data[2].id"
    And Response Body Should Contains the Value "UAE_DBX_CW_004" with Expression "data[2].code"
    And Response Body Should Contains the Value "Classic Clean + Interior" with Expression "data[2].name"
    And Response Body Should Contains the Value "• Eco-friendly waterless cleaning" with Expression "data[2].description"
    And Response Body Should Contains the Value "• Hand washed with chemical and wax spray, and microfiber towels" with Expression "data[2].description"
    And Response Body Should Contains the Value "• Interior vacuumed, and cleaned with anti-bacterial spray" with Expression "data[2].description"
    And Response Body Should Contains the Value "false" with Expression "data[2].isRecommended"
    And Response Body Should Contains the Value "false" with Expression "data[2].price.isEstimated"
    And Response Body Should Contains the Value "55" with Expression "data[2].price.original.amount"
    And Response Body Should Contains the Value "AED" with Expression "data[2].price.original.currency"
    And Response Body Should Contains the Value "AED 55.00" with Expression "data[2].price.original.text"
    And Response Body Should Contains the Value "55" with Expression "data[2].price.discounted.amount"
    And Response Body Should Contains the Value "AED" with Expression "data[2].price.discounted.currency"
    And Response Body Should Contains the Value "AED 55.00" with Expression "data[2].price.discounted.text"
    And Response Body Should Contains the Value "70" with Expression "data[2].timeToComplete.value"
    And Response Body Should Contains the Value "60" with Expression "data[2].timeToComplete.min"
    And Response Body Should Contains the Value "70" with Expression "data[2].timeToComplete.max"
    And Response Body Should Contains the Value "60 - 70 minutes" with Expression "data[2].timeToComplete.text"
    And Response Body Should Contains the Value "Exterior, Interior" with Expression "data[2].tags"

    Examples:
      | serviceName | serviceUri     | fileName                           | responseCode | body                                                                                                   | token                              |
      | "CARWASH"   | "listProducts" | "BOLT/JsonFiles/listProducts.json" | 200          | applyPromo=false lat=25.200901313365332 lng=55.27169108390808 serviceId=0VS01000000KzeeGAC vehicleID=8 | "6129af88b3ca1dd7ec20b4c8e141c7aa" |


  @BDDTEST-PE-1793 @P1 @BoltService @CarWash @ListProduct
  Scenario Outline: TestCase_Verify Car Wash List Products API returns 200 status code with Tags, Price and Time for Pressure Wash type
    Given I prepare the request headers with key "Cafu-JW-Access-Token" and prefix "" and Static value <token>
    Given I prepare the Body <fileName> With Parameters "<body>"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be <responseCode>
    And Verify that response is not empty

    #Pressure Wash Car Wash Service
    And Response Body Should Contains the Value "08q01000000LC25AAG" with Expression "data[3].id"
    And Response Body Should Contains the Value "UAE_DXB_CW_007" with Expression "data[3].code"
    And Response Body Should Contains the Value "Pressure Wash" with Expression "data[3].name"
    And Response Body Should Contains the Value "• Deep exterior water pressure wash" with Expression "data[3].description"
    And Response Body Should Contains the Value "• Cleans stubborn dirt while protecting paint" with Expression "data[3].description"
    And Response Body Should Contains the Value "• Interior vacuumed, and cleaned with anti-bacterial spray" with Expression "data[3].description"
    And Response Body Should Contains the Value "false" with Expression "data[3].isRecommended"
    And Response Body Should Contains the Value "false" with Expression "data[3].price.isEstimated"
    And Response Body Should Contains the Value "85" with Expression "data[3].price.original.amount"
    And Response Body Should Contains the Value "AED" with Expression "data[3].price.original.currency"
    And Response Body Should Contains the Value "AED 85.00" with Expression "data[3].price.original.text"
    And Response Body Should Contains the Value "85" with Expression "data[3].price.discounted.amount"
    And Response Body Should Contains the Value "AED" with Expression "data[3].price.discounted.currency"
    And Response Body Should Contains the Value "AED 85.00" with Expression "data[3].price.discounted.text"
    And Response Body Should Contains the Value "40" with Expression "data[3].timeToComplete.value"
    And Response Body Should Contains the Value "30" with Expression "data[3].timeToComplete.min"
    And Response Body Should Contains the Value "40" with Expression "data[3].timeToComplete.max"
    And Response Body Should Contains the Value "30 - 40 minutes" with Expression "data[3].timeToComplete.text"
    And Response Body Should Contains the Value "Exterior, Interior, Water" with Expression "data[3].tags"

    Examples:
      | serviceName | serviceUri     | fileName                           | responseCode | body                                                                                                   | token                              |
      | "CARWASH"   | "listProducts" | "BOLT/JsonFiles/listProducts.json" | 200          | applyPromo=false lat=25.200901313365332 lng=55.27169108390808 serviceId=0VS01000000KzeeGAC vehicleID=8 | "6129af88b3ca1dd7ec20b4c8e141c7aa" |

  @BDDTEST-PE-2561 @P1 @BoltService @CarWash @ListProduct
  Scenario Outline: TestCase_Verify Car Wash List Products API returns 200 status code with Tags, Price and Time for Premium Wash + Sanitisation Wash type
    Given I prepare the request headers with key "Cafu-JW-Access-Token" and prefix "" and Static value <token>
    Given I prepare the Body <fileName> With Parameters "<body>"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be <responseCode>
    And Verify that response is not empty

    #Premium Wash + Sanitisation Car Wash Service
    And Response Body Should Contains the Value "08q01000000L9ZCAA0" with Expression "data[4].id"
    And Response Body Should Contains the Value "UAE_DBX_CW_006" with Expression "data[4].code"
    And Response Body Should Contains the Value "Premium Wash + Sanitisation" with Expression "data[4].name"
    And Response Body Should Contains the Value "• Deep exterior & interior clean with best-in-class steamers" with Expression "data[4].description"
    And Response Body Should Contains the Value "• Cleans stains, oils, grease, dirt and odours" with Expression "data[4].description"
    And Response Body Should Contains the Value "• Includes vacuuming, tyre foam detailing, AC vent fumigation and surface disinfection" with Expression "data[4].description"
    And Response Body Should Contains the Value "false" with Expression "data[4].isRecommended"
    And Response Body Should Contains the Value "false" with Expression "data[4].price.isEstimated"
    And Response Body Should Contains the Value "149" with Expression "data[4].price.original.amount"
    And Response Body Should Contains the Value "AED" with Expression "data[4].price.original.currency"
    And Response Body Should Contains the Value "AED 149.00" with Expression "data[4].price.original.text"
    And Response Body Should Contains the Value "149" with Expression "data[4].price.discounted.amount"
    And Response Body Should Contains the Value "AED" with Expression "data[4].price.discounted.currency"
    And Response Body Should Contains the Value "AED 149.00" with Expression "data[4].price.discounted.text"
    And Response Body Should Contains the Value "75" with Expression "data[4].timeToComplete.value"
    And Response Body Should Contains the Value "60" with Expression "data[4].timeToComplete.min"
    And Response Body Should Contains the Value "75" with Expression "data[4].timeToComplete.max"
    And Response Body Should Contains the Value "60 - 75 minutes" with Expression "data[4].timeToComplete.text"
    And Response Body Should Contains the Value "Exterior, Interior, Water" with Expression "data[4].tags"

    Examples:
      | serviceName | serviceUri     | fileName                           | responseCode | body                                                                                                   | token                              |
      | "CARWASH"   | "listProducts" | "BOLT/JsonFiles/listProducts.json" | 200          | applyPromo=false lat=25.200901313365332 lng=55.27169108390808 serviceId=0VS01000000KzeeGAC vehicleID=8 | "6129af88b3ca1dd7ec20b4c8e141c7aa" |

# ------------------------------------------------------------------------------------------------------------------------------------------

    # ----------------------------------- Delete Polygon Test Cases : 1 -----------------------------------------------------------

  @BDDTEST-PE-1410 @P1 @BoltService @CarWash @DeletePolygon @Defect-Bolt-659
  Scenario Outline: TestCase_Verify delete polygon API delete call
    #preconditions create polygon
    Given I prepare the request headers with key "Cafu-JW-Access-Token" and prefix "" and Static value <token>
    Given I prepare the Body "BOLT/JsonFiles/createPolygon.json" With Parameters "<body>"
    When I call the POST Request service <serviceName> endpoint "polygon" with Variable "" and Parameter "/create" with Body
    Then Response Code should be 200

    #precondition check polygon existence
    Given I prepare the request headers with key "Cafu-JW-Access-Token" and prefix "" and Static value <token>
    When I call the GET Request for service <serviceName> endpoint "polygon" with Variable "" and other parameters "?coords=55.25624477839799,25.23789333996684&serviceCode=BC"
    Then Response Code should be 200
    Then Set Variable "POLYGONID" from Response Body with Expression "polygonId"

    #with incorrect Methodtype
    Given I prepare the request headers with key "Cafu-JW-Access-Token" and prefix "" and Static value <token>
    When I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters ""
    Then Response Code should be 400

    #delete polygon
    Given I prepare the request headers with key "Cafu-JW-Access-Token" and prefix "" and Static value <token>
    When I call the DELETE Request for service <serviceName> endpoint <serviceUri> with Variable "POLYGONID" and other parameters ""
    Then Response Code should be 204
    When I call the DELETE Request for service <serviceName> endpoint <serviceUri> with Variable "POLYGONID" and other parameters ""
    Then Response Code should be 404

    #deleted polygon retrieve
    Given I prepare the request headers with key "Cafu-JW-Access-Token" and prefix "" and Static value <token>
    When I call the GET Request for service <serviceName> endpoint "polygon" with Variable "" and other parameters "?coords=55.251287,25.0505352&serviceCode=TEST"
    Then Response Code should be 404
    Examples:
      | serviceName | serviceUri | token                                        | body             |
      | "CARWASH"   | "polygon"  | "152b61d0a51d4c031c152d3a1c13224e18e3c1f922" | name=Polygon1004 |


        # ----------------------------------- V3 - List Tyre Change Products Test Cases : 2 -----------------------------------------------------------

  @BDDTEST-PE-1607 @P1 @BoltService @CarWash @V3ListTyreChange
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
      | serviceName | serviceUri       | token                              | status | brand      | width | profile | rim | ID   | SKU           | BRAND      | MODEL | BASE      | SUBBASE        | WIDTH | PROFILE | RIM | COUNTRY | DATE | AMOUNT | CURRENCY | TEXT       |
      | "CARWASH"   | "listTyreChange" | "6129af88b3ca1dd7ec20b4c8e141c7aa" | 200    | Doublestar | 205   | 45      | 17  | 3537 | DS1PUZ2054517 | Doublestar | DSU02 | 205/45R17 | 205/45R17 88W  | 205   | 45      | 17  | China   | 2023 | 266    | AED      | AED 266.00 |
      | "CARWASH"   | "listTyreChange" | "6129af88b3ca1dd7ec20b4c8e141c7aa" | 200    | Doublestar | 235   | 55      | 18  | 3547 | DS3PS02355518 | Doublestar | DSS02 | 235/55R18 | 235/55R18 100V | 235   | 55      | 18  | China   | 2023 | 339    | AED      | AED 339.00 |
      | "CARWASH"   | "listTyreChange" | "6129af88b3ca1dd7ec20b4c8e141c7aa" | 200    | Doublestar | 245   | 45      | 19  | 3550 | DS3PUZ2454519 | Doublestar | DSU02 | 245/45R19 | 245/45R19 102W | 245   | 45      | 19  | China   | 2023 | 346    | AED      | AED 346.00 |
      | "CARWASH"   | "listTyreChange" | "6129af88b3ca1dd7ec20b4c8e141c7aa" | 200    | Doublestar | 265   | 40      | 21  | 3557 | DS1PTZ2654021 | Doublestar | DSU02 | 265/40R21 | 265/40R21 105Y | 265   | 40      | 21  | China   | 2023 | 442    | AED      | AED 442.00 |
      | "CARWASH"   | "listTyreChange" | "6129af88b3ca1dd7ec20b4c8e141c7aa" | 200    | Doublestar | 275   | 45      | 21  | 3561 | DS1PUZ2754521 | Doublestar | DSU02 | 275/45R21 | 275/45R21 110W | 275   | 45      | 21  | China   | 2023 | 468    | AED      | AED 468.00 |
      | "CARWASH"   | "listTyreChange" | "6129af88b3ca1dd7ec20b4c8e141c7aa" | 200    | Doublestar | 165   | 65      | 14  | 3564 | DS3PH01656514 | Doublestar | DH05  | 165/65R14 | 165/65R14 79T  | 165   | 65      | 14  | China   | 2023 | 231    | AED      | AED 231.00 |
      | "CARWASH"   | "listTyreChange" | "6129af88b3ca1dd7ec20b4c8e141c7aa" | 200    | Doublestar | 185   | 65      | 14  | 3565 | DS3PH01856514 | Doublestar | DH05  | 185/65R14 | 185/65R14 86H  | 185   | 65      | 14  | China   | 2023 | 247    | AED      | AED 247.00 |

  @BDDTEST-PE-1608 @P1 @BoltService @CarWash @V3ListTyreChange
  Scenario Outline: TestCase_Verify List Tyre Change Product V3 with inavalid params
    Given I prepare the request headers with key "Cafu-JW-Access-Token" and prefix "" and Static value <token>
    When I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters "?brand=<brand>&width=<width>&profile=<profile>&rim=<rim>"
    Then Response Code should be <status>
    And Response Body Should Contains the Value "[]" with Expression "data"

    Examples:
      | serviceName | serviceUri       | token                              | status | brand       | width | profile | rim |
      | "CARWASH"   | "listTyreChange" | "6129af88b3ca1dd7ec20b4c8e141c7aa" | 200    | Doublestar1 | 185   | 65      | 14  |
      | "CARWASH"   | "listTyreChange" | "6129af88b3ca1dd7ec20b4c8e141c7aa" | 200    | Doublestar  | 100   | 65      | 14  |
      | "CARWASH"   | "listTyreChange" | "6129af88b3ca1dd7ec20b4c8e141c7aa" | 200    | Doublestar  | 185   | 00      | 14  |
      | "CARWASH"   | "listTyreChange" | "6129af88b3ca1dd7ec20b4c8e141c7aa" | 200    | Doublestar  | 185   | 65      | 01  |
      | "CARWASH"   | "listTyreChange" | "6129af88b3ca1dd7ec20b4c8e141c7aa" | 200    |             | 185   | 65      | 01  |
      | "CARWASH"   | "listTyreChange" | "6129af88b3ca1dd7ec20b4c8e141c7aa" | 200    | Doublestar  |       | 65      | 01  |
      | "CARWASH"   | "listTyreChange" | "6129af88b3ca1dd7ec20b4c8e141c7aa" | 200    | Doublestar  | 185   |         | 01  |
      | "CARWASH"   | "listTyreChange" | "6129af88b3ca1dd7ec20b4c8e141c7aa" | 200    | Doublestar  | 185   | 65      |     |

        # ----------------------------------- Car Wash Completed Order Invoice Test Cases : 4 -----------------------------------------------------------
  @BDDTEST-PE-2167 @P1 @BoltService @CarWash @V3ListTyreChange
  Scenario Outline: POST Order call to send invoice of order
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    Given I prepare the request headers with key "Cafu-Jw-Access-Token" and prefix "" and Static value "152b61d0a51d4c031c152d3a1c13224e18e3c1f922"
    Given I prepare the Body <fileName> With Parameters <body>
    When I call the POST Request service <serviceName> endpoint <ServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be <responseCode>
    Examples:
      | fileName                      | body                                                                | serviceName | ServiceUri | responseCode |
      | "BOLT/JsonFiles/invoice.json" | "serialNumber=13944672 optionalEmail=temp-swapnil.salunke@cafu.com" | "CARWASH"   | "invoice"  | 200          |
      | "BOLT/JsonFiles/invoice.json" | "serialNumber=13944670 optionalEmail=temp-swapnil.salunke@cafu.com" | "CARWASH"   | "invoice"  | 404          |
      | "BOLT/JsonFiles/invoice.json" | "serialNumber=13944670 optionalEmail=temp-swapnil.salunkecafu.com"  | "CARWASH"   | "invoice"  | 404          |

  @BDDTEST-PE-2168 @P1 @BoltService @CarWash @V3ListTyreChange
  Scenario Outline: POST with incorrect Payload call to send invoice of order
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    Given I prepare the request headers with key "Cafu-Jw-Access-Token" and prefix "" and Static value "152b61d0a51d4c031c152d3a1c13224e18e3c1f922"
    Given I prepare the Body <fileName> With Parameters <body>
    Given I remove the parameter from the request body Parameter is <param>
    When I call the POST Request service <serviceName> endpoint <ServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be <responseCode>
    Examples:
      | fileName                      | body                                                                | serviceName | ServiceUri | responseCode | param          |
      | "BOLT/JsonFiles/invoice.json" | "serialNumber=13944672 optionalEmail=temp-swapnil.salunke@cafu.com" | "CARWASH"   | "invoice"  | 422          | "serialNumber" |

  @BDDTEST-PE-2169 @P1 @BoltService @CarWash @V3ListTyreChange
  Scenario Outline: POST with empty Payload call to send invoice of order
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    Given I prepare the request headers with key "Cafu-Jw-Access-Token" and prefix "" and Static value "152b61d0a51d4c031c152d3a1c13224e18e3c1f922"
    Given I prepare the Body With Parameters "{}"
    When I call the POST Request service <serviceName> endpoint <ServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be <responseCode>
    Examples:
      | serviceName | ServiceUri | responseCode |
      | "CARWASH"   | "invoice"  | 422          |

  @BDDTEST-PE-2170 @P1 @BoltService @CarWash @V3ListTyreChange
  Scenario Outline: POST with incorrect Method Type call to send invoice of order
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    Given I prepare the request headers with key "Cafu-Jw-Access-Token" and prefix "" and Static value "152b61d0a51d4c031c152d3a1c13224e18e3c1f922"
    Given I prepare the Body <fileName> With Parameters <body>
    When I call the DELETE Request for service <serviceName> endpoint <ServiceUri> with Variable "" and other parameters ""
    Then Response Code should be <responseCode>
    Examples:
      | fileName                      | body                                                                | serviceName | ServiceUri | responseCode |
      | "BOLT/JsonFiles/invoice.json" | "serialNumber=13944672 optionalEmail=temp-swapnil.salunke@cafu.com" | "CARWASH"   | "invoice"  | 405          |


    # ----------------------------------- Emergency Services Test Cases : 4 -----------------------------------------------------------
  @BDDTEST-PE-2467 @PE-2320 @P1 @BoltService @EmergencyService @CarWash
  Scenario Outline: POST Order call for to Verify emergency service with postive and negative test cases.
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    Given I prepare the request headers with key "Cafu-Jw-Access-Token" and prefix "" and Static value "152b61d0a51d4c031c152d3a1c13224e18e3c1f922"
    Given I prepare the Body <fileName> With Parameters <body>
    When I call the POST Request service <serviceName> endpoint <ServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be <responseCode>

    Examples:
      | fileName                                | body                                             | serviceName | ServiceUri  | responseCode |
      | "BOLT/JsonFiles/Emergency_Service.json" | "vehicleID=5097 customerID=3132 serviceCode=ES"  | "CARWASH"   | "emergency" | 200          |
      | "BOLT/JsonFiles/Emergency_Service.json" | "vehicleID=5097 customerID=3132 serviceCode=EJS" | "CARWASH"   | "emergency" | 200          |
      | "BOLT/JsonFiles/Emergency_Service.json" | "vehicleID=5097 customerID=3132 serviceCode=ETR" | "CARWASH"   | "emergency" | 200          |
      | "BOLT/JsonFiles/Emergency_Service.json" | "vehicleID=5097 customerID=3132 serviceCode=ET"  | "CARWASH"   | "emergency" | 200          |
      | "BOLT/JsonFiles/Emergency_Service.json" | "vehicleID=5096 customerID=3132 serviceCode=ET"  | "CARWASH"   | "emergency" | 200          |
      | "BOLT/JsonFiles/Emergency_Service.json" | "vehicleID=5097 customerID=3131 serviceCode=EA"  | "CARWASH"   | "emergency" | 400          |
      | "BOLT/JsonFiles/Emergency_Service.json" | "vehicleID=5097 customerID=3132 serviceCode=EK"  | "CARWASH"   | "emergency" | 400          |


  @BDDTEST-PE-2468 @PE-2320 @P1 @BoltService @EmergencyService @CarWash
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

  @BDDTEST-PE-2469 @PE-2320 @P1 @BoltService @EmergencyService @CarWash
  Scenario Outline: POST with empty Payload call to send emergency service
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    Given I prepare the request headers with key "Cafu-Jw-Access-Token" and prefix "" and Static value "152b61d0a51d4c031c152d3a1c13224e18e3c1f922"
    Given I prepare the Body With Parameters "{}"
    When I call the POST Request service <serviceName> endpoint <ServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be <responseCode>
    And Response Body Should Contains the Value "200005" with Expression "ErrorCode"
    And Response Body Should Contains the Value "vehicle not found with id: " with Expression "ErrorMessage"


    Examples:
      | serviceName | ServiceUri  | responseCode |
      | "CARWASH"   | "emergency" | 404          |

  @BDDTEST-PE-2470 @PE-2320 @P1 @BoltService @EmergencyService @CarWash
  Scenario Outline: POST with incorrect Method Type call to send emergency service
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    Given I prepare the request headers with key "Cafu-Jw-Access-Token" and prefix "" and Static value "152b61d0a51d4c031c152d3a1c13224e18e3c1f922"
    Given I prepare the Body <fileName> With Parameters <body>
    When I call the DELETE Request for service <serviceName> endpoint <ServiceUri> with Variable "" and other parameters ""
    Then Response Code should be <responseCode>
    Examples:
      | fileName                                | body                                          | serviceName | ServiceUri  | responseCode |
      | "BOLT/JsonFiles/Emergency_Service.json" | "vehicleID=5097 customerID=3132 productID=ES" | "CARWASH"   | "emergency" | 405          |


        # ----------------------------------- Get Wallet Information Test Cases : 1 -----------------------------------------------------------
  @BDDTEST-PE-2515 @Bolt-599 @P2 @BoltService @CarWash
  Scenario Outline: TestCase_Verify Get Wallet Credit Information
    Given I prepare the request headers with key "Cafu-JW-Access-Token" and prefix "" and Static value <token>
    When I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters ""
    Then Response Code should be <status>
    And Response Body Should Contains the Value <Service code 1> with Expression "data"
    And Response Body Should Contains the Value <Service code 2> with Expression "data"
    And Response Body Should Contains the Value <Service code 3> with Expression "data"
    And Response Body Should Contains the Value <Service code 4> with Expression "data"

    Examples:
      | serviceName | serviceUri        | token                              | status | Service code 1 | Service code 2 | Service code 3 | Service code 4 |
      | "CARWASH"   | "getwalletcredit" | "6129af88b3ca1dd7ec20b4c8e141c7aa" | 200    | "ES"           | "EJS"          | "ET"           | "ETR"          |

           # ----------------------------------- CASH/POS Payment details Test Cases : 3 -----------------------------------------------------------
  @BDDTEST-PE-2521 @Bolt-195 @P2 @BoltService @CarWash
  Scenario Outline: TestCase_Verify Post Cash/POS Payment
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    Given I prepare the request headers with key "Cafu-Jw-Access-Token" and prefix "" and Static value "152b61d0a51d4c031c152d3a1c13224e18e3c1f922"
    When I call the POST Request service <serviceName> endpoint <ServiceUri> with Variable "" and Parameter "/0WO01000003BYhdGAG/paid-by-cash" with Body
    Then Response Code should be <responseCode>

    And Response Body Should Contains the Value "0WO01000003BYhdGAG" with Expression "data.id"
    And Response Body Should Contains the Value "Successful" with Expression "data.paymentInfo.transactions.status"
    And Response Body Should Contains the Value "CASH/POS" with Expression "data.paymentInfo.transactions.paymentMethod"

    Examples:
      | serviceName | ServiceUri    | responseCode |
      | "CARWASH"   | "cashpayment" | 200          |


  @BDDTEST-PE-2522 @Bolt-195 @P1 @BoltService @EmergencyService @CarWash
  Scenario Outline: POST with Verify cash payment with invalid order id
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    Given I prepare the request headers with key "Cafu-Jw-Access-Token" and prefix "" and Static value "152b61d0a51d4c031c152d3a1c13224e18e3c1f922"
    When I call the POST Request service <serviceName> endpoint <ServiceUri> with Variable "" and Parameter "/0WO01000003BYhdG/paid-by-cash" with Body
    Then Response Code should be <responseCode>

    Examples:
      | serviceName | ServiceUri    | responseCode |
      | "CARWASH"   | "cashpayment" | 404          |

  @BDDTEST-PE-2523 @Bolt-195 @P2 @BoltService @CarWash
  Scenario Outline: POST with incorrect Method Type call to Cash/POS Payment
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    Given I prepare the request headers with key "Cafu-Jw-Access-Token" and prefix "" and Static value "152b61d0a51d4c031c152d3a1c13224e18e3c1f922"
    When I call the DELETE Request for service <serviceName> endpoint <ServiceUri> with Variable "" and other parameters ""
    Then Response Code should be <responseCode>

    Examples:
      | serviceName | ServiceUri    | responseCode |
      | "CARWASH"   | "cashpayment" | 405          |