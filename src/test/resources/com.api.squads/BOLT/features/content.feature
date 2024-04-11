@BOLT @Content-2_0 @BDDSTORY-PE-54 @Bolt-CAFU2 @Content @Regression
Feature: [TECH] [BOLT] Test Cases Design For Content Services in BOLT
  [TECH] [BOLT] Test Cases Design For Content Services in BOLT

  Background:
    # This Test case for City Service Module
    # Total Number of Test Cases for Content Module : 10
    # QA Owner - Magesh Jayakumar, Anirudho Sengupta, Swapnil Salunke
    # Total : 10

	# --------------------------Cafu 2.0---------------------------------------------------------------#

  @BDDTEST-PE-2918
  Scenario Outline: "User able Get the Content Service Information Drawer with all Successful Responses"
    Given I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters "/informational-drawer?content_key=parking_details"
    Then Response Code should be <arg0>
    And Verify that response is not empty
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/content_informational_drawer.json"
    And Response Body Should Exact Match the Value "true" with Expression "data.items[0].show_informational_drawer"
    And Response Body Should Exact Match the Value "image/png" with Expression "data.items[0].content.type"
    And Response Body Should not blank with Expression "data.items[0].content.title"
    And Response Body Should not blank with Expression "data.items[0].content.url"
    And Response Body Should not blank with Expression "data.items[0].cta"
    And Response Body Should not blank with Expression "data.items[0].cta_background_color"
    And Response Body Should not blank with Expression "data.items[0].cta_text_color"
    And Response Body Should not blank with Expression "data.items[0].description"
    And Response Body Should not blank with Expression "data.items[0].description_color"
    And Response Body Should not blank with Expression "data.items[0].entry_text"
    And Response Body Should not blank with Expression "data.items[0].title"
    And Response Body Should not blank with Expression "data.items[0].title_color"
    And Response Body Should not blank with Expression "data.items[0].key"

    Examples:
      | serviceName | serviceUri | arg0 |
      | "CONTENT"   | "content"  | 200  |

  @BDDTEST-PE-2919
  Scenario Outline: "User should not be able Get the Content Service Information Drawer with 400/404 Responses"
    Given I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameters>
    Then Response Code should be <arg0>

    Examples:
      | serviceName | serviceUri | arg0 | parameters                                         |
      | "CONTENT"   | "content"  | 400  | "/informational-drawer?conten_key=parking_details" |
      | "CONTENT"   | "content"  | 404  | "/informationa-drawer?content_key=parking_details" |

  @BDDTEST-PE-3000
  Scenario Outline: "User able Get the Product Screen Content with all 200 Successful Responses"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en"
    Given I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameters> Without Lang Header
    Then Response Code should be <arg0>
    And Verify that response is not empty
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/content_product_screen.json"

    Examples:
      | serviceName | serviceUri | arg0 | parameters                                                              |
      | "CONTENT"   | "content"  | 200  | "/screens/product-selection?platform=ios&content_location=car-wash"     |
      | "CONTENT"   | "content"  | 200  | "/screens/product-selection?platform=android&content_location=car-wash" |

  @BDDTEST-PE-3001
  Scenario Outline: "User should not be able Get the Product Screen Content with all 400/404/422 Successful Responses"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <lang>
    Given I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameters> Without Lang Header
    Then Response Code should be <arg0>

    Examples:
      | serviceName | serviceUri | arg0 | parameters                                                              | lang |
      | "CONTENT"   | "content"  | 400  | "/screens/product-selection?platform=ios&content_location=car-wash"     | ""   |
      | "CONTENT"   | "content"  | 404  | "/screens/product-selectio?platform=ios&content_location=car-wash"      | "en" |
      | "CONTENT"   | "content"  | 400  | "/screens/product-selection?platform=android&content_location=car-wash" | ""   |
      | "CONTENT"   | "content"  | 404  | "/screens/product-selectio?platform=android&content_location=car-wash"  | "en" |
      | "CONTENT"   | "content"  | 422  | "/screens/product-selection?platform=sgdfg&content_location=car-wash"   | "en" |

