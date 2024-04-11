@BOLT @Companies-2_0 @BDDSTORY-PE-2925 @Organizations
Feature: [TECH] [BOLT] Test Cases Design For Organizations Services in BOLT
  [TECH] [BOLT] Test Cases Design For Organizations Services in BOLT

  Background:
    # This Test case for City Service Module
    # Total Number of Test Cases for Companies Module : 21
    # Total Number of Test Cases for Stores Module : 30
    # Total Number of Test Cases for Company docs Module : 4
    # Total Number of Test Cases for Company pocs Module : 6
    # Total Number of Test Cases for Store docs Module : 5
    # Total Number of Test Cases for Store pocs Module : 10
    # QA Owner - Magesh Jayakumar
    # Total : 76

	# --------------------------Cafu 2.0---------------------------------------------------------------#

  @BDDTEST-PE-2926
  Scenario Outline: "User should be able to get the companies details by ID with all Successful Responses"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    Given I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameter>
    Then Response Code should be <arg0>
    And Verify that response is not empty
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/companies_by_ID.json"
    And Response Body Should Exact Match the Value <status> with Expression "company.status"
    And Response Body Should Exact Match the Value <ID> with Expression "company.id"
    And Response Body Should not blank with Expression "company.name"
    And Response Body Should not blank with Expression "company.trade_license_no"
    And Response Body Should not blank with Expression "company.tax_registration_no"
    And Response Body Should not blank with Expression "company.description"
    And Response Body Should not blank with Expression "company.logo_media_id"
    And Response Body Should not blank with Expression "company.website_urls"
    And Response Body Should not blank with Expression "company.emails"
    And Response Body Should not blank with Expression "company.phone_numbers"
    And Response Body Should not blank with Expression "company.address_id"
    And Response Body Should not blank with Expression "company.parent_id"
    And Response Body Should not blank with Expression "company.created_at"
    And Response Body Should not blank with Expression "company.updated_at"

    Examples:
      | serviceName     | serviceUri  | arg0 | parameter | status       | ID  | headerValue |
      | "ORGANIZATIONS" | "companies" | 200  | "/1"      | "blocked"    | "1" | "en-US"     |
      | "ORGANIZATIONS" | "companies" | 200  | "/2"      | "unverified" | "2" | "en-US"     |
      | "ORGANIZATIONS" | "companies" | 200  | "/4"      | "verified"   | "4" | "en-US"     |

  @BDDTEST-PE-2927
  Scenario Outline: "User should not be able get the details by ID with 400/404 Response"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    Given I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameters> Without Lang Header
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value <errorMessage> with Expression "error_code"

    Examples:
      | serviceName     | serviceUri  | arg0 | parameters  | errorMessage                 | headerValue |
      | "ORGANIZATIONS" | "companies" | 400  | "/dsfdg"    | "validation_error"           | "en-US"     |
      | "ORGANIZATIONS" | "companies" | 404  | "/215342"   | "companies_record_not_found" | "en-US"     |
      | "ORGANIZATIONS" | "companies" | 404  | "/dsfdsg/1" | "not_found"                  | "en-US"     |
      | "ORGANIZATIONS" | "companies" | 400  | "/1"        | "validation_error"           | ""          |
      | "ORGANIZATIONS" | "companies" | 422  | "/1"        | "validation_error"           | "sdvxcvxbv" |

  @BDDTEST-PE-2929
  Scenario Outline: "User should be able to create companies with 201 Successful Responses"
    Given I prepare the Body With Parameters "{\"name\": \"XYZ Holdings\"}"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be <arg0>
    And Verify that response is not empty
    And Response Body Should Exact Match the Value <status> with Expression "company.status"
    And Response Body Should not blank with Expression "company.id"
    And Response Body Should not blank with Expression "company.name"
    And Response Body Should not blank with Expression "company.created_at"
    And Response Body Should not blank with Expression "company.updated_at"

    Examples:
      | serviceName     | serviceUri  | arg0 | status       |
      | "ORGANIZATIONS" | "companies" | 201  | "unverified" |

  @BDDTEST-PE-2930
  Scenario Outline: "User should not be able to create companies with 422/400/404 Responses"
    Given I prepare the Body With Parameters <Body>
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter <Parameters> with Body
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value <errorMessage> with Expression "error_code"

    Examples:
      | serviceName     | serviceUri  | arg0 | Body                             | errorMessage       | Parameters | headerValue |
      | "ORGANIZATIONS" | "companies" | 422  | "{\"name\": \"\"}"               | "validation_error" | ""         | "en-US"     |
      | "ORGANIZATIONS" | "companies" | 400  | "{\"name\": \"\"XYZ Holdings\"}" | "validation_error" | ""         | "en-US"     |
      | "ORGANIZATIONS" | "companies" | 404  | ""                               | "not_found"        | "sgkgksjg" | "en-US"     |
      | "ORGANIZATIONS" | "companies" | 400  | "{\"name\": \"XYZ Holdings\"}"   | "validation_error" | ""         | ""          |
      | "ORGANIZATIONS" | "companies" | 422  | "{\"name\": \"XYZ Holdings\"}"   | "validation_error" | ""         | "xzvxbcvb"  |

  @BDDTEST-PE-2932
  Scenario Outline: "User should be able to patch companies service with 200 Successful Responses"
    # Create Company
    Given I prepare the Body <createFileName> Without Parameter updates in Request
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And Set Variable "ID" from Response Body with Expression "company.id"

    # Create doc with company_trade_license
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <docFileName> With Random String Parameters "RANDOM=RANDOM_STRING"
    Given I prepare the Body variable with Parameter name "company_id" and variable "ID"
    Given I prepare the Body variable with Parameter name "type" and value "company_trade_license"
    When I call the POST Request service <serviceName> endpoint <docServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/createCompanyDocs.json"

    # Create doc with company_tax_cert
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <docFileName> With Random String Parameters "RANDOM=RANDOM_STRING"
    Given I prepare the Body variable with Parameter name "company_id" and variable "ID"
    Given I prepare the Body variable with Parameter name "type" and value "company_tax_cert"
    When I call the POST Request service <serviceName> endpoint <docServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/createCompanyDocs.json"

    # Create Company Pocs
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    Given I prepare the Body <pocFileName> With Parameters "<pocBody>"
    Given I prepare the Body variable with Parameter name "company_id" and variable "ID"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the POST Request service <serviceName> endpoint <pocServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty

    # Update Company
    Given I prepare the Body <editFileName> With Parameters "<companyBody>"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter "" with Body
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value "Alphabets_Inc_Ltd_Testing" with Expression "company.name"
    And Response Body Should Exact Match the Value "TLN_129" with Expression "company.trade_license_no"
    And Response Body Should Exact Match the Value "TRN_5678" with Expression "company.tax_registration_no"
    And Response Body Should Exact Match the Value "We provide tyre change service testing" with Expression "company.description"
    And Response Body Should Exact Match the Value "55437" with Expression "company.logo_media_id"
    And Response Body Should Exact Match the Value "https://www.example2.com" with Expression "company.website_urls[0]"
    And Response Body Should Exact Match the Value "john.doe1@example.com" with Expression "company.emails[0]"
    And Response Body Should Exact Match the Value "+971543334410" with Expression "company.phone_numbers[0]"
    And Response Body Should Exact Match the Value "66232" with Expression "company.address_id"
    And Response Body Should Exact Match the Value "2" with Expression "company.parent_id"
    And Response Body Should not blank with Expression "company.documents[0].id"
    And Response Body Should not blank with Expression "company.documents[0].company_id"
    And Response Body Should not blank with Expression "company.documents[0].type"
    And Response Body Should not blank with Expression "company.documents[0].media_id"
    And Response Body Should not blank with Expression "company.documents[0].expiry_date"
    And Response Body Should not blank with Expression "company.documents[0].created_at"
    And Response Body Should not blank with Expression "company.documents[0].updated_at"
    And Response Body Should not blank with Expression "company.point_of_contacts[0].id"
    And Response Body Should not blank with Expression "company.point_of_contacts[0].company_id"
    And Response Body Should not blank with Expression "company.point_of_contacts[0].first_name"
    And Response Body Should not blank with Expression "company.point_of_contacts[0].last_name"
    And Response Body Should not blank with Expression "company.point_of_contacts[0].phone_number"
    And Response Body Should not blank with Expression "company.point_of_contacts[0].created_at"
    And Response Body Should not blank with Expression "company.point_of_contacts[0].updated_at"

    Examples:
      | serviceName     | serviceUri  | docServiceUri | pocServiceUri | docFileName                                           | pocFileName                             | arg0 | createFileName                      | editFileName                        | companyBody                                                                          | pocBody                                                                         |
      | "ORGANIZATIONS" | "companies" | "companydocs" | "companypocs" | "BOLT/JsonFiles/createCompanyDocsBasedonCompany.json" | "BOLT/JsonFiles/createCompanyPocs.json" | 200  | "BOLT/JsonFiles/createCompany.json" | "BOLT/JsonFiles/updateCompany.json" | name=Alphabets_Inc_Ltd_Testing trade_license_no=TLN_129 tax_registration_no=TRN_5678 | first_name=John last_name=Doe phone_number=+971443022221 email=user@example.com |

  @BDDTEST-PE-2933
  Scenario Outline: "User should not be able to update companies with 400/404 Responses"
    Given I prepare the Body With Parameters <Body>
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter <Parameters> with Body
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value <errorMessage> with Expression "error_code"

    Examples:
      | serviceName     | serviceUri  | arg0 | errorMessage                 | Parameters | Body                                                                    | headerValue |
      | "ORGANIZATIONS" | "companies" | 400  | "validation_error"           | "/1"       | "{\"name\": \"Alphabets Inc 1\",\"emails\": \"john.doe1@example.com\"}" | "en-US"     |
      | "ORGANIZATIONS" | "companies" | 404  | "not_found"                  | "sgkgksjg" | ""                                                                      | "en-US"     |
      | "ORGANIZATIONS" | "companies" | 404  | "companies_record_not_found" | "/1565"    | "{\"name\": \"XYZ Holdings\"}"                                          | "en-US"     |
      | "ORGANIZATIONS" | "companies" | 400  | "validation_error"           | "/1"       | "{\"name\": \"Alphabets Inc 1\"}"                                       | ""          |
      | "ORGANIZATIONS" | "companies" | 422  | "validation_error"           | "/1"       | "{\"name\": \"Alphabets Inc 1\"}"                                       | "dsdvfcb"   |

  @BDDTEST-PE-2994
  Scenario Outline: "User should be able to archive companies service with 200 Successful Responses"
    # Create Company
    Given I prepare the Body <createFileName> Without Parameter updates in Request
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And Set Variable "ID" from Response Body with Expression "company.id"

    # Archive Company
    Given I prepare the Body With Parameters <Body>
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter <parameters> with Body
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value <Message> with Expression "message"

    Examples:
      | serviceName     | serviceUri  | arg0 | createFileName                      | parameters | Message | Body |
      | "ORGANIZATIONS" | "companies" | 200  | "BOLT/JsonFiles/createCompany.json" | "/archive" | "ok"    | ""   |

  @BDDTEST-PE-2995
  Scenario Outline: "User should not be able to archive companies with 404 Responses"
    Given I prepare the Body With Parameters <Body>
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter <Parameters> with Body
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value <errorMessage> with Expression "error_code"

    Examples:
      | serviceName     | serviceUri  | arg0 | errorMessage       | Parameters   | Body | headerValue |
      | "ORGANIZATIONS" | "companies" | 404  | "not_found"        | "/4/archiv"  | ""   | "en-US"     |
      | "ORGANIZATIONS" | "companies" | 400  | "validation_error" | "/4/archive" | ""   | ""          |
      | "ORGANIZATIONS" | "companies" | 422  | "validation_error" | "/4/archive" | ""   | "sdcdsvdvd" |

  @BDDTEST-PE-2996
  Scenario Outline: "User should be able to block companies service with 200 Successful Responses"
    # Create Company
    Given I prepare the Body <createFileName> Without Parameter updates in Request
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And Set Variable "ID" from Response Body with Expression "company.id"

    # Create doc with company_trade_license
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <docFileName> With Random String Parameters "RANDOM=RANDOM_STRING"
    Given I prepare the Body variable with Parameter name "company_id" and variable "ID"
    Given I prepare the Body variable with Parameter name "type" and value "company_trade_license"
    When I call the POST Request service <serviceName> endpoint <docServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/createCompanyDocs.json"

    # Create doc with company_tax_cert
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <docFileName> With Random String Parameters "RANDOM=RANDOM_STRING"
    Given I prepare the Body variable with Parameter name "company_id" and variable "ID"
    Given I prepare the Body variable with Parameter name "type" and value "company_tax_cert"
    When I call the POST Request service <serviceName> endpoint <docServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/createCompanyDocs.json"

     # Create Company Pocs
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    Given I prepare the Body <pocFileName> With Parameters "<pocBody>"
    Given I prepare the Body variable with Parameter name "company_id" and variable "ID"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the POST Request service <serviceName> endpoint <pocServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty

    # Block Company
    Given I prepare the Body With Parameters <Body>
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter <parameters> with Body
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value "blocked" with Expression "company.status"
    And Response Body Should not blank with Expression "company.documents[0].id"
    And Response Body Should not blank with Expression "company.documents[0].company_id"
    And Response Body Should not blank with Expression "company.documents[0].type"
    And Response Body Should not blank with Expression "company.documents[0].media_id"
    And Response Body Should not blank with Expression "company.documents[0].expiry_date"
    And Response Body Should not blank with Expression "company.documents[0].created_at"
    And Response Body Should not blank with Expression "company.documents[0].updated_at"
    And Response Body Should not blank with Expression "company.point_of_contacts[0].id"
    And Response Body Should not blank with Expression "company.point_of_contacts[0].company_id"
    And Response Body Should not blank with Expression "company.point_of_contacts[0].first_name"
    And Response Body Should not blank with Expression "company.point_of_contacts[0].last_name"
    And Response Body Should not blank with Expression "company.point_of_contacts[0].phone_number"
    And Response Body Should not blank with Expression "company.point_of_contacts[0].created_at"
    And Response Body Should not blank with Expression "company.point_of_contacts[0].updated_at"

    Examples:
      | serviceName     | serviceUri  | docServiceUri | pocServiceUri | arg0 | createFileName                      | docFileName                                           | pocFileName                             | parameters | Body | pocBody                                                                         |
      | "ORGANIZATIONS" | "companies" | "companydocs" | "companypocs" | 200  | "BOLT/JsonFiles/createCompany.json" | "BOLT/JsonFiles/createCompanyDocsBasedonCompany.json" | "BOLT/JsonFiles/createCompanyPocs.json" | "/block"   | ""   | first_name=John last_name=Doe phone_number=+971443022221 email=user@example.com |

  @BDDTEST-PE-2997
  Scenario Outline: "User should not be able to block companies with 404 Responses"
    Given I prepare the Body With Parameters <Body>
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter <Parameters> with Body
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value <errorMessage> with Expression "error_code"

    Examples:
      | serviceName     | serviceUri  | arg0 | errorMessage       | Parameters | Body | headerValue |
      | "ORGANIZATIONS" | "companies" | 404  | "not_found"        | "/4/bloc"  | ""   | "en-US"     |
      | "ORGANIZATIONS" | "companies" | 400  | "validation_error" | "/4/block" | ""   | ""          |
      | "ORGANIZATIONS" | "companies" | 422  | "validation_error" | "/4/block" | ""   | "vsdxvdfvf" |

  @BDDTEST-PE-3124
  Scenario Outline: "User should be able to verify an unverified company using verify service with 200 Successful Responses"
    # Create Company
    Given I prepare the Body <createFileName> Without Parameter updates in Request
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And Set Variable "ID" from Response Body with Expression "company.id"

    # Update Company
    Given I prepare the Body <editFileName> With Parameters "<companyBody>"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter "" with Body
    Then Response Code should be 200

    # Create doc with company_trade_license
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <docFileName> With Random String Parameters "RANDOM=RANDOM_STRING"
    Given I prepare the Body variable with Parameter name "company_id" and variable "ID"
    Given I prepare the Body variable with Parameter name "type" and value "company_trade_license"
    When I call the POST Request service <serviceName> endpoint <docServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/createCompanyDocs.json"

    # Create doc with company_tax_cert
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <docFileName> With Random String Parameters "RANDOM=RANDOM_STRING"
    Given I prepare the Body variable with Parameter name "company_id" and variable "ID"
    Given I prepare the Body variable with Parameter name "type" and value "company_tax_cert"
    When I call the POST Request service <serviceName> endpoint <docServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/createCompanyDocs.json"

     # Create Company Pocs
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    Given I prepare the Body <pocFileName> With Parameters "<pocBody>"
    Given I prepare the Body variable with Parameter name "company_id" and variable "ID"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the POST Request service <serviceName> endpoint <pocServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty

    # Verify Company
    Given I prepare the Body With Parameters <Body>
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter <parameters> with Body
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value "verified" with Expression "company.status"
    And Response Body Should not blank with Expression "company.documents[0].id"
    And Response Body Should not blank with Expression "company.documents[0].company_id"
    And Response Body Should not blank with Expression "company.documents[0].type"
    And Response Body Should not blank with Expression "company.documents[0].media_id"
    And Response Body Should not blank with Expression "company.documents[0].expiry_date"
    And Response Body Should not blank with Expression "company.documents[0].created_at"
    And Response Body Should not blank with Expression "company.documents[0].updated_at"
    And Response Body Should not blank with Expression "company.point_of_contacts[0].id"
    And Response Body Should not blank with Expression "company.point_of_contacts[0].company_id"
    And Response Body Should not blank with Expression "company.point_of_contacts[0].first_name"
    And Response Body Should not blank with Expression "company.point_of_contacts[0].last_name"
    And Response Body Should not blank with Expression "company.point_of_contacts[0].phone_number"
    And Response Body Should not blank with Expression "company.point_of_contacts[0].created_at"
    And Response Body Should not blank with Expression "company.point_of_contacts[0].updated_at"

    Examples:
      | serviceName     | serviceUri  | docServiceUri | pocServiceUri | arg0 | createFileName                      | pocFileName                             | parameters | Body | editFileName                        | companyBody                                                                          | docFileName                                           | pocBody                                                                         |
      | "ORGANIZATIONS" | "companies" | "companydocs" | "companypocs" | 200  | "BOLT/JsonFiles/createCompany.json" | "BOLT/JsonFiles/createCompanyPocs.json" | "/verify"  | ""   | "BOLT/JsonFiles/updateCompany.json" | name=Alphabets_Inc_Ltd_Testing trade_license_no=TLN_129 tax_registration_no=TRN_5678 | "BOLT/JsonFiles/createCompanyDocsBasedonCompany.json" | first_name=John last_name=Doe phone_number=+971443022221 email=user@example.com |

  @BDDTEST-PE-3125
  Scenario Outline: "User should be able to verify a blocked company using verify service with 200 Successful Responses"
    # Create Company
    Given I prepare the Body <createFileName> Without Parameter updates in Request
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And Set Variable "ID" from Response Body with Expression "company.id"

    # Update Company
    Given I prepare the Body <editFileName> With Parameters "<companyBody>"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter "" with Body
    Then Response Code should be 200

    # Block Company
    Given I prepare the Body With Parameters <Body>
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter <parameters> with Body
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value "blocked" with Expression "company.status"

     # Create doc with company_trade_license
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <docFileName> With Random String Parameters "RANDOM=RANDOM_STRING"
    Given I prepare the Body variable with Parameter name "company_id" and variable "ID"
    Given I prepare the Body variable with Parameter name "type" and value "company_trade_license"
    When I call the POST Request service <serviceName> endpoint <docServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/createCompanyDocs.json"

    # Create doc with company_tax_cert
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <docFileName> With Random String Parameters "RANDOM=RANDOM_STRING"
    Given I prepare the Body variable with Parameter name "company_id" and variable "ID"
    Given I prepare the Body variable with Parameter name "type" and value "company_tax_cert"
    When I call the POST Request service <serviceName> endpoint <docServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/createCompanyDocs.json"

     # Verify Company
    Given I prepare the Body With Parameters <Body>
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter <verifyParameters> with Body
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value "verified" with Expression "company.status"

    Examples:
      | serviceName     | serviceUri  | docServiceUri | arg0 | createFileName                      | parameters | Body | verifyParameters | editFileName                        | companyBody                                                                          | docFileName                                           |
      | "ORGANIZATIONS" | "companies" | "companydocs" | 200  | "BOLT/JsonFiles/createCompany.json" | "/block"   | ""   | "/verify"        | "BOLT/JsonFiles/updateCompany.json" | name=Alphabets_Inc_Ltd_Testing trade_license_no=TLN_129 tax_registration_no=TRN_5678 | "BOLT/JsonFiles/createCompanyDocsBasedonCompany.json" |

  @BDDTEST-PE-3126
  Scenario Outline: "User should not be able to verify a company by removing each mandatory sections with 422 validation error"
    # Create Company
    Given I prepare the Body <createFileName> Without Parameter updates in Request
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And Set Variable "ID" from Response Body with Expression "company.id"

    # Update Company
    Given I prepare the Body <editFileName> With Parameters "<companyBody>"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    Given I remove the parameter from the request body Parameter is <removeKey>
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter "" with Body
    Then Response Code should be 200

    # Verify Company
    Given I prepare the Body With Parameters <Body>
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter <parameters> with Body
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value <error_code> with Expression "error_code"
    And Response Body Should Exact Match the Value <message> with Expression "message"

    Examples:
      | serviceName     | serviceUri  | arg0 | createFileName                      | parameters | Body | editFileName                        | removeKey             | companyBody                                                                          | error_code                              | message                                            | headerValue |
      | "ORGANIZATIONS" | "companies" | 422  | "BOLT/JsonFiles/createCompany.json" | "/verify"  | ""   | "BOLT/JsonFiles/updateCompany.json" | "trade_license_no"    | name=Alphabets_Inc_Ltd_Testing trade_license_no=TLN_129 tax_registration_no=TRN_5678 | "unable_to_verify_company_trade_lic_no" | "api.errors.unable_to_verify_company_trade_lic_no" | "en-US"     |
      | "ORGANIZATIONS" | "companies" | 422  | "BOLT/JsonFiles/createCompany.json" | "/verify"  | ""   | "BOLT/JsonFiles/updateCompany.json" | "tax_registration_no" | name=Alphabets_Inc_Ltd_Testing trade_license_no=TLN_129 tax_registration_no=TRN_5678 | "unable_to_verify_company_tax_reg_no"   | "api.errors.unable_to_verify_company_tax_reg_no"   | "en-US"     |

  @BDDTEST-PE-3127
  Scenario Outline: "User should not be able to verify a company by removing all mandatory sections with 422 validation error"
    # Create Company
    Given I prepare the Body <createFileName> Without Parameter updates in Request
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And Set Variable "ID" from Response Body with Expression "company.id"

    # Update Company
    Given I prepare the Body <editFileName> With Parameters "<companyBody>"
    Given I remove the parameter from the request body Parameter is "name"
    Given I remove the parameter from the request body Parameter is "trade_license_no"
    Given I remove the parameter from the request body Parameter is "tax_registration_no"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter "" with Body
    Then Response Code should be 200

    # Verify Company
    Given I prepare the Body With Parameters <Body>
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter <parameters> with Body
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value <error_code> with Expression "error_code"
    And Response Body Should Exact Match the Value <message> with Expression "message"

    Examples:
      | serviceName     | serviceUri  | arg0 | createFileName                      | parameters | Body | editFileName                        | companyBody                                                                          | error_code                              | message                                            |
      | "ORGANIZATIONS" | "companies" | 422  | "BOLT/JsonFiles/createCompany.json" | "/verify"  | ""   | "BOLT/JsonFiles/updateCompany.json" | name=Alphabets_Inc_Ltd_Testing trade_license_no=TLN_129 tax_registration_no=TRN_5678 | "unable_to_verify_company_trade_lic_no" | "api.errors.unable_to_verify_company_trade_lic_no" |

  @BDDTEST-PE-3128
  Scenario Outline: "User should not be able to verify companies with 404 Responses"
    Given I prepare the Body With Parameters <Body>
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter <Parameters> with Body
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value <errorMessage> with Expression "error_code"

    Examples:
      | serviceName     | serviceUri  | arg0 | errorMessage                 | Parameters     | Body | headerValue |
      | "ORGANIZATIONS" | "companies" | 404  | "not_found"                  | "/4/verif"     | ""   | "en-US"     |
      | "ORGANIZATIONS" | "companies" | 404  | "companies_record_not_found" | "/4786/verify" | ""   | "en-US"     |
      | "ORGANIZATIONS" | "companies" | 400  | "validation_error"           | "/4/verify"    | ""   | ""          |
      | "ORGANIZATIONS" | "companies" | 422  | "validation_error"           | "/4/verify"    | ""   | "szfdfhf"   |

  @BDDTEST-PE-3247
  Scenario Outline: "User should be able to create stores with 201 Successful Responses"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <createStoreFileName> With Parameters "<createStoreBody>"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be <arg0>
    And Verify that response is not empty
    And Response Body Should Exact Match the Value <status> with Expression "store.status"
    And Response Body Should not blank with Expression "store.company_id"
    And Response Body Should not blank with Expression "store.id"
    And Response Body Should not blank with Expression "store.created_at"
    And Response Body Should not blank with Expression "store.updated_at"
    And Response Body Should Exact Match the Value <name> with Expression "store.name"

    Examples:
      | serviceName     | serviceUri | arg0 | status       | name            | createStoreFileName                | createStoreBody    |
      | "ORGANIZATIONS" | "stores"   | 201  | "unverified" | "Example_Store" | "BOLT/JsonFiles/createStores.json" | name=Example_Store |

  @BDDTEST-PE-3248
  Scenario Outline: "User should be not able to create stores with 400/404/422 Responses"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    Given I prepare the Body With Parameters <Body>
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter <parameter> with Body
    Then Response Code should be <arg0>
    And Verify that response is not empty
    And Response Body Should Exact Match the Value <errorMessage> with Expression "error_code"

    Examples:
      | serviceName     | serviceUri | arg0 | headerValue | errorMessage       | parameter | Body                                               |
      | "ORGANIZATIONS" | "stores"   | 422  | "en-US"     | "validation_error" | ""        | "{\"name\": \"\"}"                                 |
      | "ORGANIZATIONS" | "stores"   | 400  | ""          | "validation_error" | ""        | ""                                                 |
      | "ORGANIZATIONS" | "stores"   | 422  | "asfsdf"    | "validation_error" | ""        | "{\"name\": \"XYZ Holdings\",\"company_id\": 100}" |
      | "ORGANIZATIONS" | "stores"   | 404  | "en-US"     | "not_found"        | "/dsvfgf" | ""                                                 |

  @BDDTEST-PE-3249
  Scenario Outline: "User should be able to get the store details by ID with all Successful Responses"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    Given I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameter>
    Then Response Code should be <arg0>
    And Verify that response is not empty
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/stores_by_ID.json"
    And Response Body Should Exact Match the Value <status> with Expression "store.status"
    And Response Body Should Exact Match the Value <ID> with Expression "store.id"
    And Response Body Should not blank with Expression "store.company_id"
    And Response Body Should not blank with Expression "store.created_at"
    And Response Body Should not blank with Expression "store.updated_at"
    And Response Body Should not blank with Expression "store.name"

    Examples:
      | serviceName     | serviceUri | arg0 | parameter | status       | ID  | headerValue |
      | "ORGANIZATIONS" | "stores"   | 200  | "/1"      | "unverified" | "1" | "en-US"     |

  @BDDTEST-PE-3250
  Scenario Outline: "User should be not able to get the store details by ID with 400/422/404 Response"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    Given I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameter> Without Lang Header
    Then Response Code should be <arg0>
    And Verify that response is not empty
    And Response Body Should Exact Match the Value <errorMessage> with Expression "error_code"

    Examples:
      | serviceName     | serviceUri | arg0 | parameter  | headerValue | errorMessage       |
      | "ORGANIZATIONS" | "stores"   | 422  | "/1"       | "sgdhfhf"   | "validation_error" |
      | "ORGANIZATIONS" | "stores"   | 404  | "/1/sdfds" | "en-US"     | "not_found"        |
      | "ORGANIZATIONS" | "stores"   | 400  | "/1"       | ""          | "validation_error" |

  @BDDTEST-PE-3253
  Scenario Outline: "User should be able to unverify a verified company using admin configuration service with 200 Successful Responses"
    # Create Company
    Given I prepare the Body <createFileName> Without Parameter updates in Request
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And Set Variable "ID" from Response Body with Expression "company.id"

    # Update Company
    Given I prepare the Body <editFileName> With Parameters "<companyBody>"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter "" with Body
    Then Response Code should be 200

    # Create doc with company_trade_license
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <docFileName> With Random String Parameters "RANDOM=RANDOM_STRING"
    Given I prepare the Body variable with Parameter name "company_id" and variable "ID"
    Given I prepare the Body variable with Parameter name "type" and value "company_trade_license"
    When I call the POST Request service <serviceName> endpoint <docServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/createCompanyDocs.json"

    # Create doc with company_tax_cert
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <docFileName> With Random String Parameters "RANDOM=RANDOM_STRING"
    Given I prepare the Body variable with Parameter name "company_id" and variable "ID"
    Given I prepare the Body variable with Parameter name "type" and value "company_tax_cert"
    When I call the POST Request service <serviceName> endpoint <docServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/createCompanyDocs.json"

    # Verify Company
    Given I prepare the Body With Parameters <Body>
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter <parameters> with Body
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value "verified" with Expression "company.status"

    # Update Company to Unverify
    Given I prepare the Body With Parameters <unVerifyBody>
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter <confirmParameters> with Body
    Then Response Code should be 200
    And Response Body Should Exact Match the Value "unverified" with Expression "company.status"

    Examples:
      | serviceName     | serviceUri  | docServiceUri | arg0 | createFileName                      | docFileName                                           | parameters | confirmParameters | Body | editFileName                        | unVerifyFileName                                | companyBody                                                                          | unVerifyBody                      |
      | "ORGANIZATIONS" | "companies" | "companydocs" | 200  | "BOLT/JsonFiles/createCompany.json" | "BOLT/JsonFiles/createCompanyDocsBasedonCompany.json" | "/verify"  | "?confirm=1"      | ""   | "BOLT/JsonFiles/updateCompany.json" | "BOLT/JsonFiles/updateCompanyTradeLicense.json" | name=Alphabets_Inc_Ltd_Testing trade_license_no=TLN_129 tax_registration_no=TRN_5678 | "{\"trade_license_no\": \"\"}"    |
      | "ORGANIZATIONS" | "companies" | "companydocs" | 200  | "BOLT/JsonFiles/createCompany.json" | "BOLT/JsonFiles/createCompanyDocsBasedonCompany.json" | "/verify"  | "?confirm=1"      | ""   | "BOLT/JsonFiles/updateCompany.json" | "BOLT/JsonFiles/updateCompanyTradeLicense.json" | name=Alphabets_Inc_Ltd_Testing trade_license_no=TLN_129 tax_registration_no=TRN_5678 | "{\"tax_registration_no\": \"\"}" |

  @BDDTEST-PE-3254
  Scenario Outline: "User should be unable to unverify a verified company using admin configuration service with 202/422 Successful Responses"
    # Create Company
    Given I prepare the Body <createFileName> Without Parameter updates in Request
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And Set Variable "ID" from Response Body with Expression "company.id"

    # Update Company
    Given I prepare the Body <editFileName> With Parameters "<companyBody>"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter "" with Body
    Then Response Code should be 200

    # Create doc with company_trade_license
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <docFileName> With Random String Parameters "RANDOM=RANDOM_STRING"
    Given I prepare the Body variable with Parameter name "company_id" and variable "ID"
    Given I prepare the Body variable with Parameter name "type" and value "company_trade_license"
    When I call the POST Request service <serviceName> endpoint <docServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/createCompanyDocs.json"

    # Create doc with company_tax_cert
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <docFileName> With Random String Parameters "RANDOM=RANDOM_STRING"
    Given I prepare the Body variable with Parameter name "company_id" and variable "ID"
    Given I prepare the Body variable with Parameter name "type" and value "company_tax_cert"
    When I call the POST Request service <serviceName> endpoint <docServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/createCompanyDocs.json"

    # Verify Company
    Given I prepare the Body With Parameters <Body>
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter <parameters> with Body
    Then Response Code should be 200
    And Response Body Should Exact Match the Value "verified" with Expression "company.status"

    # Update Company to Unverify
    Given I prepare the Body <unVerifyFileName> With Parameters "<unVerifyBody>"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter <confirmParameters> with Body
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value <Message> with Expression "message"

    Examples:
      | serviceName     | serviceUri  | docServiceUri | arg0 | createFileName                      | docFileName                                           | parameters | confirmParameters | Body | editFileName                        | companyBody                                                                          | unVerifyFileName                                | unVerifyBody                                          | Message                                                                            |
      | "ORGANIZATIONS" | "companies" | "companydocs" | 202  | "BOLT/JsonFiles/createCompany.json" | "BOLT/JsonFiles/createCompanyDocsBasedonCompany.json" | "/verify"  | ""                | ""   | "BOLT/JsonFiles/updateCompany.json" | name=Alphabets_Inc_Ltd_Testing trade_license_no=TLN_129 tax_registration_no=TRN_5678 | "BOLT/JsonFiles/updateCompanyTradeLicense.json" | tax_registration_no=TRN_5678                          | "unable_to_delete_company_trade_license_no.verified_company.confirmation_required" |
      | "ORGANIZATIONS" | "companies" | "companydocs" | 422  | "BOLT/JsonFiles/createCompany.json" | "BOLT/JsonFiles/createCompanyDocsBasedonCompany.json" | "/verify"  | "?confirm=2"      | ""   | "BOLT/JsonFiles/updateCompany.json" | name=Alphabets_Inc_Ltd_Testing trade_license_no=TLN_129 tax_registration_no=TRN_5678 | "BOLT/JsonFiles/updateCompanyName.json"         | trade_license_no=TLN_129 tax_registration_no=TRN_5678 | "api.errors.validation_error"                                                      |

  @BDDTEST-PE-3255
  Scenario Outline: "User should be unable to unverify a verified company using admin configuration service with 400 Bad Responses"
    # Create Company
    Given I prepare the Body <createFileName> Without Parameter updates in Request
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And Set Variable "ID" from Response Body with Expression "company.id"

    # Update Company
    Given I prepare the Body <editFileName> With Parameters "<companyBody>"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter "" with Body
    Then Response Code should be 200

    # Create doc with company_trade_license
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <docFileName> With Random String Parameters "RANDOM=RANDOM_STRING"
    Given I prepare the Body variable with Parameter name "company_id" and variable "ID"
    Given I prepare the Body variable with Parameter name "type" and value "company_trade_license"
    When I call the POST Request service <serviceName> endpoint <docServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/createCompanyDocs.json"

    # Create doc with company_tax_cert
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <docFileName> With Random String Parameters "RANDOM=RANDOM_STRING"
    Given I prepare the Body variable with Parameter name "company_id" and variable "ID"
    Given I prepare the Body variable with Parameter name "type" and value "company_tax_cert"
    When I call the POST Request service <serviceName> endpoint <docServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/createCompanyDocs.json"

    # Verify Company
    Given I prepare the Body With Parameters <Body>
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter <parameters> with Body
    Then Response Code should be 200
    And Response Body Should Exact Match the Value "verified" with Expression "company.status"

    # Update Company to Unverify
    Given I prepare the Body With Parameters <updateBody>
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter <confirmParameters> with Body
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value <Message> with Expression "message"

    Examples:
      | serviceName     | serviceUri  | docServiceUri | docFileName                                           | arg0 | createFileName                      | parameters | confirmParameters | Body | editFileName                        | companyBody                                                                          | updateBody  | Message                                                           |
      | "ORGANIZATIONS" | "companies" | "companydocs" | "BOLT/JsonFiles/createCompanyDocsBasedonCompany.json" | 400  | "BOLT/JsonFiles/createCompany.json" | "/verify"  | "?confirm=1"      | ""   | "BOLT/JsonFiles/updateCompany.json" | name=Alphabets_Inc_Ltd_Testing trade_license_no=TLN_129 tax_registration_no=TRN_5678 | "sdvfdbdfb" | "api.errors.invalid character 's' looking for beginning of value" |

  @BDDTEST-PE-3288
  Scenario Outline: "User should be able to Create, Delete, Read company docs with 201/200/204 response"
    # Create Company Docs
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <createFileName> With Random String Parameters "RANDOM=RANDOM_STRING"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/createCompanyDocs.json"
    And Set Variable "ID" from Response Body with Expression "document.id"
    And Response Body Should not blank with Expression "document.company_id"
    And Response Body Should not blank with Expression "document.created_at"
    And Response Body Should not blank with Expression "document.expiry_date"
    And Response Body Should not blank with Expression "document.id"
    And Response Body Should not blank with Expression "document.media_id"
    And Response Body Should not blank with Expression "document.type"
    And Response Body Should not blank with Expression "document.updated_at"

    # Read Company Docs
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "ID" and other parameters "" Without Lang Header
    Then Response Code should be 200
    And Verify that response is not empty
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/createCompanyDocs.json"
    And Response Body Should not blank with Expression "document.company_id"
    And Response Body Should not blank with Expression "document.created_at"
    And Response Body Should not blank with Expression "document.expiry_date"
    And Response Body Should not blank with Expression "document.id"
    And Response Body Should not blank with Expression "document.media_id"
    And Response Body Should not blank with Expression "document.type"
    And Response Body Should not blank with Expression "document.updated_at"

    # List Company Docs
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "ID" and other parameters <parameters> Without Lang Header
    Then Response Code should be 200
    And Verify that response is not empty
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/createCompanyDocs.json"
    And Response Body Should Exact Match the Value "100" with Expression "document.company_id"
    And Response Body Should Exact Match the Value of the variable "ID" with Expression "document.id"
    And Response Body Should Exact Match the Value "company_trade_license" with Expression "document.type"
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/createCompanyDocs.json"

    # Delete Company Docs
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I call the DELETE Request for service <serviceName> endpoint <serviceUri> with Variable "ID" and other parameters <confirmParameters>
    Then Response Code should be 204
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "ID" and other parameters "" Without Lang Header
    Then Response Code should be 404

    Examples:
      | serviceName     | serviceUri    | createFileName                          | parameters                                                        | confirmParameters |
      | "ORGANIZATIONS" | "companydocs" | "BOLT/JsonFiles/createCompanyDocs.json" | "?page=1&per_page=20&company_ids=100&types=company_trade_license" | "?confirm=1"      |

  @BDDTEST-PE-3289
  Scenario Outline: "User should be not able to read the company docs by ID with 400/422/404 Response"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    Given I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameter> Without Lang Header
    Then Response Code should be <arg0>
    And Verify that response is not empty
    And Response Body Should Exact Match the Value <errorMessage> with Expression "error_code"

    Examples:
      | serviceName     | serviceUri    | arg0 | parameter    | headerValue | errorMessage                         |
      | "ORGANIZATIONS" | "companydocs" | 422  | "/1"         | "sgdhfhf"   | "validation_error"                   |
      | "ORGANIZATIONS" | "companydocs" | 404  | "/145546576" | "en-US"     | "company_documents_record_not_found" |
      | "ORGANIZATIONS" | "companydocs" | 400  | "/1"         | ""          | "validation_error"                   |
      | "ORGANIZATIONS" | "companydocs" | 404  | "/1/sdf"     | "en-US"     | "not_found"                          |

  @BDDTEST-PE-3290
  Scenario Outline: "User should be not able to list the company docs by ID with 400/422/404 Response"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    Given I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameter> Without Lang Header
    Then Response Code should be <arg0>
    And Verify that response is not empty
    And Response Body Should Exact Match the Value <errorMessage> with Expression "error_code"

    Examples:
      | serviceName     | serviceUri    | arg0 | parameter                                                                 | headerValue | errorMessage       |
      | "ORGANIZATIONS" | "companydocs" | 422  | "/1?page=1&per_page=20&company_ids=100&types=company_trade_license"       | "sgdhfhf"   | "validation_error" |
      | "ORGANIZATIONS" | "companydocs" | 404  | "/1/sdfds?page=1&per_page=20&company_ids=100&types=company_trade_license" | "en-US"     | "not_found"        |
      | "ORGANIZATIONS" | "companydocs" | 400  | "/1?page=1&per_page=20&company_ids=100&types=company_trade_license"       | ""          | "validation_error" |

  @BDDTEST-PE-3291
  Scenario Outline: "User should be not able to create the company docs by ID with 400/422/404 Response"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    Given I prepare the Body With Parameters <responseBody>
    And I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter <parameter> with Body
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value <errorMessage> with Expression "error_code"

    Examples:
      | serviceName     | serviceUri | arg0 | parameter | errorMessage       | headerValue | responseBody                                                                                                                  |
      | "ORGANIZATIONS" | "stores"   | 422  | ""        | "validation_error" | "dsfdsgsg"  | "{\"company_id\": 100,\"type\": \"company_trade_license\",\"media_id\": \"45656\",\"expiry_date\": \"2027-10-29T14:32:15Z\"}" |
      | "ORGANIZATIONS" | "stores"   | 404  | "/sdfds"  | "not_found"        | "en-US"     | "{\"company_id\": 100,\"type\": \"company_trade_license\",\"media_id\": \"45656\",\"expiry_date\": \"2027-10-29T14:32:15Z\"}" |
      | "ORGANIZATIONS" | "stores"   | 400  | ""        | "validation_error" | ""          | "{\"company_id\": 100,\"type\": \"company_trade_license\",\"media_id\": \"45656\",\"expiry_date\": \"2027-10-29T14:32:15Z\"}" |
      | "ORGANIZATIONS" | "stores"   | 400  | ""        | "validation_error" | ""          | "{\"company_id\": 100"                                                                                                        |

  @BDDTEST-PE-3292
  Scenario Outline: "User should be able to list stores with both company id and status 200 response"
    # List Stores
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameters> Without Lang Header
    Then Response Code should be 200
    And Verify that response is not empty
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/listStores.json"
    And Response Body Should Exact Match the Value <status> with Expression "data[0].status"

    Examples:
      | serviceName     | serviceUri | parameters                                                | status       |
      | "ORGANIZATIONS" | "stores"   | "?page=1&per_page=20&statuses=unverified&company_ids=100" | "unverified" |
      | "ORGANIZATIONS" | "stores"   | "?statuses=unverified&company_ids=100"                    | "unverified" |
      | "ORGANIZATIONS" | "stores"   | "?page=1&statuses=unverified&company_ids=100"             | "unverified" |
      | "ORGANIZATIONS" | "stores"   | "?per_page=20&statuses=unverified&company_ids=100"        | "unverified" |

  @BDDTEST-PE-3293
  Scenario Outline: "User should be able to list stores with both company id 200 response"
    # List Stores
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameters> Without Lang Header
    Then Response Code should be 200
    And Verify that response is not empty
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/listStores.json"
    And Response Body Should Exact Match the Value <ID> with Expression "data[0].company_id"

    Examples:
      | serviceName     | serviceUri | parameters                            | ID    |
      | "ORGANIZATIONS" | "stores"   | "?page=1&per_page=20&company_ids=100" | "100" |
      | "ORGANIZATIONS" | "stores"   | "?company_ids=100"                    | "100" |
      | "ORGANIZATIONS" | "stores"   | "?page=1&company_ids=100"             | "100" |
      | "ORGANIZATIONS" | "stores"   | "?per_page=20&company_ids=100"        | "100" |

  @BDDTEST-PE-3294
  Scenario Outline: "User should be able to list stores with status 200 response"
    # List Stores
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameters> Without Lang Header
    Then Response Code should be 200
    And Verify that response is not empty
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/listStores.json"
    And Response Body Should Exact Match the Value <status> with Expression "data[0].status"

    Examples:
      | serviceName     | serviceUri | parameters                                | status       |
      | "ORGANIZATIONS" | "stores"   | "?page=1&per_page=20&statuses=unverified" | "unverified" |
      | "ORGANIZATIONS" | "stores"   | "?statuses=unverified"                    | "unverified" |
      | "ORGANIZATIONS" | "stores"   | "?page=1&statuses=unverified"             | "unverified" |
      | "ORGANIZATIONS" | "stores"   | "?per_page=20&statuses=unverified"        | "unverified" |

  @BDDTEST-PE-3295
  Scenario Outline: "User should not be able to list stores with both company id and status 400/422 response"
    # List Stores
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    Given I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameters> Without Lang Header
    Then Response Code should be <arg0>
    And Verify that response is not empty
    And Response Body Should Exact Match the Value <errorMessage> with Expression "error_code"

    Examples:
      | serviceName     | serviceUri | parameters                                                   | headerValue | arg0 | errorMessage       |
      | "ORGANIZATIONS" | "stores"   | "?page=1&per_page=20&statuses=unverified&company_ids=100"    | "sgdfhfgh"  | 422  | "validation_error" |
      | "ORGANIZATIONS" | "stores"   | "?statuses=unverified&company_ids=100"                       | ""          | 400  | "validation_error" |
      | "ORGANIZATIONS" | "stores"   | "dgd?page=1&per_page=20&statuses=unverified&company_ids=100" | "en-US"     | 404  | "not_found"        |
      | "ORGANIZATIONS" | "stores"   | "?per_page=20&statuses=1&company_ids=100"                    | "en-US"     | 400  | "validation_error" |
      | "ORGANIZATIONS" | "stores"   | "?per_page=20&statuses=unverified&company_ids=dfd"           | "en-US"     | 400  | "validation_error" |

  @BDDTEST-PE-3317
  Scenario Outline: "User should be able to verify unverified store with verified company 200 Successful Responses"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <createStoreFileName> With Parameters "<createStoreBody>"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And Set Variable "ID" from Response Body with Expression "store.id"
    Given I prepare the Body With Parameters <Body>
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter "/verify" with Body
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value <status> with Expression "store.status"


    Examples:
      | serviceName     | serviceUri | arg0 | status     | createStoreFileName                               | createStoreBody    | Body |
      | "ORGANIZATIONS" | "stores"   | 200  | "verified" | "BOLT/JsonFiles/createStoresVerifiedCompany.json" | name=Example_Store | ""   |

  @BDDTEST-PE-3318
  Scenario Outline: "User should be able to verify blocked store with verified company 200 Successful Responses"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <createStoreFileName> With Parameters "<createStoreBody>"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And Set Variable "ID" from Response Body with Expression "store.id"
    Given I prepare the Body With Parameters <Body>
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter "/block" with Body
    Then Response Code should be <arg0>
    Given I prepare the Body With Parameters <Body>
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter "/verify" with Body
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value <status> with Expression "store.status"


    Examples:
      | serviceName     | serviceUri | arg0 | status     | createStoreFileName                               | createStoreBody    | Body |
      | "ORGANIZATIONS" | "stores"   | 200  | "verified" | "BOLT/JsonFiles/createStoresVerifiedCompany.json" | name=Example_Store | ""   |

  @BDDTEST-PE-3319
  Scenario Outline: "User should not be able to verify unverified store with unverified company 400 validation error Response"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <createStoreFileName> With Parameters "<createStoreBody>"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And Set Variable "ID" from Response Body with Expression "store.id"
    Given I prepare the Body With Parameters <Body>
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter "/verify" with Body
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value <errorMessage> with Expression "error_code"


    Examples:
      | serviceName     | serviceUri | arg0 | errorMessage                                | createStoreFileName                | createStoreBody    | Body |
      | "ORGANIZATIONS" | "stores"   | 422  | "unable_to_verify_store_unverified_company" | "BOLT/JsonFiles/createStores.json" | name=Example_Store | ""   |

  @BDDTEST-PE-3320
  Scenario Outline: "User should not be able to verify blocked store with unverified company 400 validation error Response"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <createStoreFileName> With Parameters "<createStoreBody>"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And Set Variable "ID" from Response Body with Expression "store.id"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter "/block" with Body
    Then Response Code should be 200
    Given I prepare the Body With Parameters <Body>
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter "/verify" with Body
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value <errorMessage> with Expression "error_code"


    Examples:
      | serviceName     | serviceUri | arg0 | errorMessage                                | createStoreFileName                | createStoreBody    | Body |
      | "ORGANIZATIONS" | "stores"   | 422  | "unable_to_verify_store_unverified_company" | "BOLT/JsonFiles/createStores.json" | name=Example_Store | ""   |

  @BDDTEST-PE-3321
  Scenario Outline: "User should not be able to verify unverified store with blocked company 400 validation error Response"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <createStoreFileName> With Parameters "<createStoreBody>"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And Set Variable "ID" from Response Body with Expression "store.id"
    Given I prepare the Body With Parameters <Body>
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter "/verify" with Body
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value <errorMessage> with Expression "error_code"


    Examples:
      | serviceName     | serviceUri | arg0 | errorMessage                                | createStoreFileName                              | createStoreBody    | Body |
      | "ORGANIZATIONS" | "stores"   | 422  | "unable_to_verify_store_unverified_company" | "BOLT/JsonFiles/createStoresBlockedCompany.json" | name=Example_Store | ""   |

  @BDDTEST-PE-3322
  Scenario Outline: "User should not be able to verify blocked store with blocked company 400 validation error Response"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <createStoreFileName> With Parameters "<createStoreBody>"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And Set Variable "ID" from Response Body with Expression "store.id"
    Given I prepare the Body With Parameters <Body>
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter "/block" with Body
    Then Response Code should be 200
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter "/verify" with Body
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value <errorMessage> with Expression "error_code"


    Examples:
      | serviceName     | serviceUri | arg0 | errorMessage                                | createStoreFileName                              | createStoreBody    | Body |
      | "ORGANIZATIONS" | "stores"   | 422  | "unable_to_verify_store_unverified_company" | "BOLT/JsonFiles/createStoresBlockedCompany.json" | name=Example_Store | ""   |

  @BDDTEST-PE-3323
  Scenario Outline: "User should not be able to verify/block/archive stores with status 400/422/404 response"
    Given I prepare the Body With Parameters <Body>
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter <parameters> with Body
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value <errorMessage> with Expression "error_code"

    Examples:
      | serviceName     | serviceUri | parameters        | headerValue | arg0 | errorMessage              | Body |
      | "ORGANIZATIONS" | "stores"   | "/1/verify"       | "sgdfhfgh"  | 422  | "validation_error"        | ""   |
      | "ORGANIZATIONS" | "stores"   | "/1/verify"       | ""          | 400  | "validation_error"        | ""   |
      | "ORGANIZATIONS" | "stores"   | "/1/verify/a"     | "en-US"     | 404  | "not_found"               | ""   |
      | "ORGANIZATIONS" | "stores"   | "/100000/verify"  | "en-US"     | 404  | "stores_record_not_found" | ""   |
      | "ORGANIZATIONS" | "stores"   | "/1/block"        | "sgdfhfgh"  | 422  | "validation_error"        | ""   |
      | "ORGANIZATIONS" | "stores"   | "/1/block"        | ""          | 400  | "validation_error"        | ""   |
      | "ORGANIZATIONS" | "stores"   | "/1/block/a"      | "en-US"     | 404  | "not_found"               | ""   |
      | "ORGANIZATIONS" | "stores"   | "/100000/block"   | "en-US"     | 404  | "stores_record_not_found" | ""   |
      | "ORGANIZATIONS" | "stores"   | "/1/archive"      | "sgdfhfgh"  | 422  | "validation_error"        | ""   |
      | "ORGANIZATIONS" | "stores"   | "/1/archive"      | ""          | 400  | "validation_error"        | ""   |
      | "ORGANIZATIONS" | "stores"   | "/1/archive/a"    | "en-US"     | 404  | "not_found"               | ""   |
      | "ORGANIZATIONS" | "stores"   | "/100000/archive" | "en-US"     | 404  | "stores_record_not_found" | ""   |

  @BDDTEST-PE-3324
  Scenario Outline: "User should be able to block unverified store with unverified company 200 Successful Responses"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <createStoreFileName> With Parameters "<createStoreBody>"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And Set Variable "ID" from Response Body with Expression "store.id"
    Given I prepare the Body With Parameters <Body>
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter "/block" with Body
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value <status> with Expression "store.status"


    Examples:
      | serviceName     | serviceUri | arg0 | status    | createStoreFileName                | createStoreBody    | Body |
      | "ORGANIZATIONS" | "stores"   | 200  | "blocked" | "BOLT/JsonFiles/createStores.json" | name=Example_Store | ""   |

  @BDDTEST-PE-3325
  Scenario Outline: "User should be able to block unverified store with verified company 200 Successful Responses"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <createStoreFileName> With Parameters "<createStoreBody>"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And Set Variable "ID" from Response Body with Expression "store.id"
    Given I prepare the Body With Parameters <Body>
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter "/block" with Body
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value <status> with Expression "store.status"


    Examples:
      | serviceName     | serviceUri | arg0 | status    | createStoreFileName                               | createStoreBody    | Body |
      | "ORGANIZATIONS" | "stores"   | 200  | "blocked" | "BOLT/JsonFiles/createStoresVerifiedCompany.json" | name=Example_Store | ""   |

  @BDDTEST-PE-3326
  Scenario Outline: "User should be able to block verified store with verified company 200 Successful Responses"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <createStoreFileName> With Parameters "<createStoreBody>"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And Set Variable "ID" from Response Body with Expression "store.id"
    Given I prepare the Body With Parameters <Body>
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter "/verify" with Body
    Then Response Code should be <arg0>
    Given I prepare the Body With Parameters <Body>
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter "/block" with Body
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value <status> with Expression "store.status"


    Examples:
      | serviceName     | serviceUri | arg0 | status    | createStoreFileName                               | createStoreBody    | Body |
      | "ORGANIZATIONS" | "stores"   | 200  | "blocked" | "BOLT/JsonFiles/createStoresVerifiedCompany.json" | name=Example_Store | ""   |

  @BDDTEST-PE-3327
  Scenario Outline: "User should be able to block unverified store with blocked company 200 Successful Responses"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <createStoreFileName> With Parameters "<createStoreBody>"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And Set Variable "ID" from Response Body with Expression "store.id"
    Given I prepare the Body With Parameters <Body>
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter "/block" with Body
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value <status> with Expression "store.status"


    Examples:
      | serviceName     | serviceUri | arg0 | status    | createStoreFileName                              | createStoreBody    | Body |
      | "ORGANIZATIONS" | "stores"   | 200  | "blocked" | "BOLT/JsonFiles/createStoresBlockedCompany.json" | name=Example_Store | ""   |

  @BDDTEST-PE-3328
  Scenario Outline: "User should be able to archive unverified store with unverified company 200 Successful Responses"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <createStoreFileName> With Parameters "<createStoreBody>"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And Set Variable "ID" from Response Body with Expression "store.id"
    Given I prepare the Body With Parameters <Body>
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter "/archive" with Body
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value <Message> with Expression "message"


    Examples:
      | serviceName     | serviceUri | arg0 | Message | createStoreFileName                | createStoreBody    | Body |
      | "ORGANIZATIONS" | "stores"   | 200  | "ok"    | "BOLT/JsonFiles/createStores.json" | name=Example_Store | ""   |

  @BDDTEST-PE-3329
  Scenario Outline: "User should be able to archive blocked store with unverified company 200 Successful Responses"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <createStoreFileName> With Parameters "<createStoreBody>"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And Set Variable "ID" from Response Body with Expression "store.id"
    Given I prepare the Body With Parameters <Body>
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter "/block" with Body
    Then Response Code should be 200
    Given I prepare the Body With Parameters <Body>
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter "/archive" with Body
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value <Message> with Expression "message"


    Examples:
      | serviceName     | serviceUri | arg0 | Message | createStoreFileName                | createStoreBody    | Body |
      | "ORGANIZATIONS" | "stores"   | 200  | "ok"    | "BOLT/JsonFiles/createStores.json" | name=Example_Store | ""   |

  @BDDTEST-PE-3330
  Scenario Outline: "User should be able to archive blocked store with blocked company 200 Successful Responses"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <createStoreFileName> With Parameters "<createStoreBody>"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And Set Variable "ID" from Response Body with Expression "store.id"
    Given I prepare the Body With Parameters <Body>
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter "/block" with Body
    Then Response Code should be 200
    Given I prepare the Body With Parameters <Body>
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter "/archive" with Body
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value <Message> with Expression "message"


    Examples:
      | serviceName     | serviceUri | arg0 | Message | createStoreFileName                              | createStoreBody    | Body |
      | "ORGANIZATIONS" | "stores"   | 200  | "ok"    | "BOLT/JsonFiles/createStoresBlockedCompany.json" | name=Example_Store | ""   |

  @BDDTEST-PE-3331
  Scenario Outline: "User should be able to archive unverified store with blocked company 200 Successful Responses"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <createStoreFileName> With Parameters "<createStoreBody>"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And Set Variable "ID" from Response Body with Expression "store.id"
    Given I prepare the Body With Parameters <Body>
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter "/archive" with Body
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value <Message> with Expression "message"


    Examples:
      | serviceName     | serviceUri | arg0 | Message | createStoreFileName                              | createStoreBody    | Body |
      | "ORGANIZATIONS" | "stores"   | 200  | "ok"    | "BOLT/JsonFiles/createStoresBlockedCompany.json" | name=Example_Store | ""   |

  @BDDTEST-PE-3332
  Scenario Outline: "User should be able to archive blocked store with verified company 200 Successful Responses"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <createStoreFileName> With Parameters "<createStoreBody>"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And Set Variable "ID" from Response Body with Expression "store.id"
    Given I prepare the Body With Parameters <Body>
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter "/block" with Body
    Then Response Code should be 200
    Given I prepare the Body With Parameters <Body>
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter "/archive" with Body
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value <Message> with Expression "message"


    Examples:
      | serviceName     | serviceUri | arg0 | Message | createStoreFileName                               | createStoreBody    | Body |
      | "ORGANIZATIONS" | "stores"   | 200  | "ok"    | "BOLT/JsonFiles/createStoresVerifiedCompany.json" | name=Example_Store | ""   |

  @BDDTEST-PE-3333
  Scenario Outline: "User should be able to archive unverified store with verified company 200 Successful Responses"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <createStoreFileName> With Parameters "<createStoreBody>"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And Set Variable "ID" from Response Body with Expression "store.id"
    Given I prepare the Body With Parameters <Body>
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter "/archive" with Body
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value <Message> with Expression "message"


    Examples:
      | serviceName     | serviceUri | arg0 | Message | createStoreFileName                               | createStoreBody    | Body |
      | "ORGANIZATIONS" | "stores"   | 200  | "ok"    | "BOLT/JsonFiles/createStoresVerifiedCompany.json" | name=Example_Store | ""   |

  @BDDTEST-PE-3334
  Scenario Outline: "User should be able to archive verified store with verified company 200 Successful Responses"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <createStoreFileName> With Parameters "<createStoreBody>"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And Set Variable "ID" from Response Body with Expression "store.id"
    Given I prepare the Body With Parameters <Body>
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter "/verify" with Body
    Then Response Code should be 200
    Given I prepare the Body With Parameters <Body>
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter "/archive" with Body
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value <Message> with Expression "message"


    Examples:
      | serviceName     | serviceUri | arg0 | Message | createStoreFileName                               | createStoreBody    | Body |
      | "ORGANIZATIONS" | "stores"   | 200  | "ok"    | "BOLT/JsonFiles/createStoresVerifiedCompany.json" | name=Example_Store | ""   |

  @BDDTEST-PE-3384
  Scenario Outline: "User should be able to Create, Delete, Read company pocs with 201/200/204 response"
    # Create Company Pocs
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    Given I prepare the Body <createFileName> With Parameters "<PocBody>"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/createCompanyPocs.json"
    And Set Variable "ID" from Response Body with Expression "point_of_contact.id"
    And Response Body Should not blank with Expression "point_of_contact.company_id"
    And Response Body Should not blank with Expression "point_of_contact.created_at"
    And Response Body Should not blank with Expression "point_of_contact.email"
    And Response Body Should not blank with Expression "point_of_contact.first_name"
    And Response Body Should not blank with Expression "point_of_contact.last_name"
    And Response Body Should not blank with Expression "point_of_contact.phone_number"
    And Response Body Should not blank with Expression "point_of_contact.updated_at"

    # Read Company Pocs
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "ID" and other parameters "" Without Lang Header
    Then Response Code should be 200
    And Verify that response is not empty
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/createCompanyPocs.json"
    And Response Body Should not blank with Expression "point_of_contact.company_id"
    And Response Body Should not blank with Expression "point_of_contact.created_at"
    And Response Body Should not blank with Expression "point_of_contact.email"
    And Response Body Should not blank with Expression "point_of_contact.first_name"
    And Response Body Should not blank with Expression "point_of_contact.last_name"
    And Response Body Should not blank with Expression "point_of_contact.phone_number"
    And Response Body Should not blank with Expression "point_of_contact.updated_at"

    # List Company Pocs
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "ID" and other parameters <parameters> Without Lang Header
    Then Response Code should be 200
    And Verify that response is not empty
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/createCompanyPocs.json"
    And Response Body Should Exact Match the Value <companyID> with Expression "point_of_contact.company_id"
    And Response Body Should Exact Match the Value of the variable "ID" with Expression "point_of_contact.id"
    And Response Body Should Exact Match the Value "user@example.com" with Expression "point_of_contact.email"
    And Response Body Should Exact Match the Value "John" with Expression "point_of_contact.first_name"
    And Response Body Should Exact Match the Value "Doe" with Expression "point_of_contact.last_name"
    And Response Body Should Exact Match the Value "+971443022221" with Expression "point_of_contact.phone_number"
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/createCompanyPocs.json"

    # Update Company Pocs
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <createFileName> With Parameters "<updatePocBody>"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter "" with Body
    Then Response Code should be 200
    And Response Body Should Exact Match the Value "user1@example.com" with Expression "point_of_contact.email"
    And Response Body Should Exact Match the Value "John1" with Expression "point_of_contact.first_name"
    And Response Body Should Exact Match the Value "Doe1" with Expression "point_of_contact.last_name"
    And Response Body Should Exact Match the Value "+971443022220" with Expression "point_of_contact.phone_number"

    # Delete Company Pocs
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I call the DELETE Request for service <serviceName> endpoint <serviceUri> with Variable "ID" and other parameters ""
    Then Response Code should be 204
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "ID" and other parameters "" Without Lang Header
    Then Response Code should be 404

    Examples:
      | serviceName     | serviceUri    | createFileName                          | parameters                            | PocBody                                                                                        | updatePocBody                                                                                     | companyID |
      | "ORGANIZATIONS" | "companypocs" | "BOLT/JsonFiles/createCompanyPocs.json" | "?page=1&per_page=20&company_ids=100" | company_id=100 first_name=John last_name=Doe phone_number=+971443022221 email=user@example.com | company_id=100 first_name=John1 last_name=Doe1 phone_number=+971443022220 email=user1@example.com | "100"     |
      | "ORGANIZATIONS" | "companypocs" | "BOLT/JsonFiles/createCompanyPocs.json" | "?page=1&per_page=20&company_ids=387" | company_id=387 first_name=John last_name=Doe phone_number=+971443022221 email=user@example.com | company_id=387 first_name=John1 last_name=Doe1 phone_number=+971443022220 email=user1@example.com | "387"     |
      | "ORGANIZATIONS" | "companypocs" | "BOLT/JsonFiles/createCompanyPocs.json" | "?page=1&per_page=20&company_ids=388" | company_id=388 first_name=John last_name=Doe phone_number=+971443022221 email=user@example.com | company_id=388 first_name=John1 last_name=Doe1 phone_number=+971443022220 email=user1@example.com | "388"     |

  @BDDTEST-PE-3385
  Scenario Outline: "User should be not able to create the company pocs with 400/422/404 Response"
   # Create Company Pocs
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    Given I prepare the Body <createFileName> With Parameters "<PocBody>"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    Given I remove the parameter from the request body Parameter is <param>
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter <parameter> with Body
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value <errorCode> with Expression "error_code"

    Examples:
      | serviceName     | serviceUri    | createFileName                          | parameter | arg0 | headerValue    | PocBody                                                                                         | errorCode          | param          |
      | "ORGANIZATIONS" | "companypocs" | "BOLT/JsonFiles/createCompanyPocs.json" | ""        | 400  | ""             | company_id=100 first_name=John last_name=Doe phone_number=+971443022221 email=user@example.com  | "validation_error" | ""             |
      | "ORGANIZATIONS" | "companypocs" | "BOLT/JsonFiles/createCompanyPocs.json" | ""        | 422  | "en-UScvfvfgv" | company_id=387 first_name=John last_name=Doe phone_number=+971443022221 email=user@example.com  | "validation_error" | ""             |
      | "ORGANIZATIONS" | "companypocs" | "BOLT/JsonFiles/createCompanyPocs.json" | "/fef"    | 404  | "en-US"        | company_id=388 first_name=John last_name=Doe phone_number=+971443022221 email=user@example.com  | "not_found"        | ""             |
      | "ORGANIZATIONS" | "companypocs" | "BOLT/JsonFiles/createCompanyPocs.json" | ""        | 422  | "en-US"        | company_id=null first_name=John last_name=Doe phone_number=+971443022221 email=user@example.com | "validation_error" | ""             |
      | "ORGANIZATIONS" | "companypocs" | "BOLT/JsonFiles/createCompanyPocs.json" | ""        | 422  | "en-US"        | company_id=null first_name=John last_name=Doe phone_number=+971443022221 email=user@example.com | "validation_error" | "first_name"   |
      | "ORGANIZATIONS" | "companypocs" | "BOLT/JsonFiles/createCompanyPocs.json" | ""        | 422  | "en-US"        | company_id=null first_name=John last_name=Doe phone_number=+971443022221 email=user@example.com | "validation_error" | "last_name"    |
      | "ORGANIZATIONS" | "companypocs" | "BOLT/JsonFiles/createCompanyPocs.json" | ""        | 422  | "en-US"        | company_id=null first_name=John last_name=Doe phone_number=+971443022221 email=user@example.com | "validation_error" | "phone_number" |
      | "ORGANIZATIONS" | "companypocs" | "BOLT/JsonFiles/createCompanyPocs.json" | ""        | 422  | "en-US"        | company_id=null first_name=John last_name=Doe phone_number=+971443022221 email=user@example.com | "validation_error" | "email"        |

  @BDDTEST-PE-3386
  Scenario Outline: "User should be not able to read the company pocs with 400/422/404 Response"
   # Read Company Pocs
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    Given I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameter> Without Lang Header
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value <errorCode> with Expression "error_code"

    Examples:
      | serviceName     | serviceUri    | errorCode          | arg0 | headerValue | parameter |
      | "ORGANIZATIONS" | "companypocs" | "validation_error" | 400  | ""          | "/1"      |
      | "ORGANIZATIONS" | "companypocs" | "validation_error" | 422  | "en-USdsfd" | "/1"      |
      | "ORGANIZATIONS" | "companypocs" | "not_found"        | 404  | "en-US"     | "/1/sdf"  |

  @BDDTEST-PE-3387
  Scenario Outline: "User should be not able to list the company pocs with 400/422/404 Response"
   # List Company Pocs
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    Given I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameter> Without Lang Header
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value <errorCode> with Expression "error_code"

    Examples:
      | serviceName     | serviceUri    | errorCode          | arg0 | headerValue | parameter                                 |
      | "ORGANIZATIONS" | "companypocs" | "validation_error" | 400  | ""          | "?page=1&per_page=20&company_ids=100"     |
      | "ORGANIZATIONS" | "companypocs" | "validation_error" | 422  | "en-USdsfd" | "?page=1&per_page=20&company_ids=100"     |
      | "ORGANIZATIONS" | "companypocs" | "validation_error" | 422  | "en-US"     | "?page=1&per_page=20"                     |
      | "ORGANIZATIONS" | "companypocs" | "not_found"        | 404  | "en-US"     | "7yhg?page=1&per_page=20&company_ids=100" |
      | "ORGANIZATIONS" | "companypocs" | "validation_error" | 400  | "en-US"     | "?page=1&per_page=20&company_ids=dfdg"    |

  @BDDTEST-PE-3388
  Scenario Outline: "User should be not able to delete the company pocs with 400/422/404 Response"
   # Delete Company Pocs
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    Given I call the DELETE Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameter>
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value <errorCode> with Expression "error_code"
    Examples:
      | serviceName     | serviceUri    | errorCode          | arg0 | headerValue | parameter |
      | "ORGANIZATIONS" | "companypocs" | "validation_error" | 400  | ""          | "/1"      |
      | "ORGANIZATIONS" | "companypocs" | "validation_error" | 422  | "en-USdsfd" | "/1"      |
      | "ORGANIZATIONS" | "companypocs" | "not_found"        | 404  | "en-US"     | "7yhg"    |

  @BDDTEST-PE-3389
  Scenario Outline: "User should be not able to patch the company pocs with 400/422/404 Response"
   # Patch Company Pocs
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    Given I prepare the Body <createFileName> With Parameters "<PocBody>"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter <parameter> with Body
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value <errorCode> with Expression "error_code"

    Examples:
      | serviceName     | serviceUri    | createFileName                          | parameter | arg0 | headerValue    | PocBody                                                                            | errorCode          |
      | "ORGANIZATIONS" | "companypocs" | "BOLT/JsonFiles/createCompanyPocs.json" | "/1"      | 400  | ""             | first_name=John1 last_name=Doe1 phone_number=+971443022220 email=user1@example.com | "validation_error" |
      | "ORGANIZATIONS" | "companypocs" | "BOLT/JsonFiles/createCompanyPocs.json" | "/1"      | 422  | "en-UScvfvfgv" | first_name=John1 last_name=Doe1 phone_number=+971443022220 email=user1@example.com | "validation_error" |
      | "ORGANIZATIONS" | "companypocs" | "BOLT/JsonFiles/createCompanyPocs.json" | "fef"     | 404  | "en-US"        | first_name=John1 last_name=Doe1 phone_number=+971443022220 email=user1@example.com | "not_found"        |

  @BDDTEST-PE-3416
  Scenario Outline: "User should be able to update stores with 200 Successful Responses"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <createStoreFileName> With Parameters "<createStoreBody>"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And Set Variable "ID" from Response Body with Expression "store.id"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body With Parameters "{\"name\": \"Example_Store1\"}"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter "" with Body
    Then Response Code should be <arg0>
    And Verify that response is not empty
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/updateStores.json"
    And Response Body Should Exact Match the Value "Example_Store1" with Expression "store.name"

    Examples:
      | serviceName     | serviceUri | arg0 | createStoreFileName                | createStoreBody    |
      | "ORGANIZATIONS" | "stores"   | 200  | "BOLT/JsonFiles/createStores.json" | name=Example_Store |

  @BDDTEST-PE-3417
  Scenario Outline: "User should be not able to update the stores with 400/422/404 Response"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <createStoreFileName> With Parameters "<createStoreBody>"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And Set Variable "ID" from Response Body with Expression "store.id"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    Given I prepare the Body With Parameters "{\"name\": \"Example_Store1\"}"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter <parameters> with Body
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value <Message> with Expression "error_code"

    Examples:
      | serviceName     | serviceUri | arg0 | createStoreFileName                | createStoreBody    | headerValue   | parameters | Message            |
      | "ORGANIZATIONS" | "stores"   | 400  | "BOLT/JsonFiles/createStores.json" | name=Example_Store | ""            | ""         | "validation_error" |
      | "ORGANIZATIONS" | "stores"   | 422  | "BOLT/JsonFiles/createStores.json" | name=Example_Store | "en-USefefrf" | ""         | "validation_error" |
      | "ORGANIZATIONS" | "stores"   | 404  | "BOLT/JsonFiles/createStores.json" | name=Example_Store | ""            | "/ddf"     | "not_found"        |

  @BDDTEST-PE-3418
  Scenario Outline: "User should be able to list companies with status 200 response"
    # List companies
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameters> Without Lang Header
    Then Response Code should be 200
    And Verify that response is not empty
    And Response Body Should Exact Match the Value <status> with Expression "data[0].status"

    Examples:
      | serviceName     | serviceUri  | parameters                                             | status       |
      | "ORGANIZATIONS" | "companies" | "?page=1&per_page=20&statuses=unverified&parent_ids=2" | "unverified" |
      | "ORGANIZATIONS" | "companies" | "?page=1&per_page=20&statuses=verified&parent_ids=2"   | "verified"   |
      | "ORGANIZATIONS" | "companies" | "?page=1&per_page=20&statuses=blocked&parent_ids=2"    | "blocked"    |
      | "ORGANIZATIONS" | "companies" | "?page=1&per_page=20&statuses=unverified"              | "unverified" |
      | "ORGANIZATIONS" | "companies" | "?page=1&per_page=20&statuses=verified"                | "verified"   |
      | "ORGANIZATIONS" | "companies" | "?page=1&per_page=20&statuses=blocked"                 | "blocked"    |

  @BDDTEST-PE-3419
  Scenario Outline: "User should not be able to list companies with status 400/422/404 response"
    # List companies
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    Given I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "" and other parameters <parameters> Without Lang Header
    Then Response Code should be <arg0>
    And Verify that response is not empty
    And Response Body Should Exact Match the Value <message> with Expression "error_code"

    Examples:
      | serviceName     | serviceUri  | parameters                                                | arg0 | headerValue | message            |
      | "ORGANIZATIONS" | "companies" | "?page=1&per_page=20&statuses=unverified&parent_ids=2"    | 400  | ""          | "validation_error" |
      | "ORGANIZATIONS" | "companies" | "?page=1&per_page=20&statuses=verified&parent_ids=2"      | 422  | "en-USdgfg" | "validation_error" |
      | "ORGANIZATIONS" | "companies" | "dfd?page=1&per_page=20&statuses=blocked&parent_ids=2"    | 404  | "en-US"     | "not_found"        |
      | "ORGANIZATIONS" | "companies" | "?page=1&per_page=20&statuses=23&parent_ids=2"            | 400  | "en-US"     | "validation_error" |
      | "ORGANIZATIONS" | "companies" | "?page=1&per_page=20&statuses=unverified&parent_ids=sdfd" | 400  | "en-US"     | "validation_error" |

  @BDDTEST-PE-3420
  Scenario Outline: "User should be able to unverify a verified company by removing the company docs with 200 Successful Responses"
    # Create Company
    Given I prepare the Body <createFileName> Without Parameter updates in Request
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And Set Variable "ID" from Response Body with Expression "company.id"

    # Update Company
    Given I prepare the Body <editFileName> With Parameters "<companyBody>"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter "" with Body
    Then Response Code should be 200

    # Create doc with company_trade_license
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <docFileName> With Random String Parameters "RANDOM=RANDOM_STRING"
    Given I prepare the Body variable with Parameter name "company_id" and variable "ID"
    Given I prepare the Body variable with Parameter name "type" and value "company_trade_license"
    When I call the POST Request service <serviceName> endpoint <docsServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/createCompanyDocs.json"
    And Set Variable "DOCUMENTIDTRADELICENSE" from Response Body with Expression "document.id"

    # Create doc with company_tax_cert
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <docFileName> With Random String Parameters "RANDOM=RANDOM_STRING"
    Given I prepare the Body variable with Parameter name "company_id" and variable "ID"
    Given I prepare the Body variable with Parameter name "type" and value "company_tax_cert"
    When I call the POST Request service <serviceName> endpoint <docsServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/createCompanyDocs.json"
    And Set Variable "DOCUMENTIDTAXCERT" from Response Body with Expression "document.id"

    # Verify Company
    Given I prepare the Body With Parameters <Body>
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter <parameters> with Body
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value "verified" with Expression "company.status"

     # Delete Company Docs Trade licence
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I call the DELETE Request for service <serviceName> endpoint <docsServiceUri> with Variable "DOCUMENTIDTRADELICENSE" and other parameters <confirmParameters>
    Then Response Code should be 204
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"

    # Delete Company Docs Company cert
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I call the DELETE Request for service <serviceName> endpoint <docsServiceUri> with Variable "DOCUMENTIDTAXCERT" and other parameters <confirmParameters>
    Then Response Code should be 204
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"

     # List Company Docs
    Given I call the GET Request for service <serviceName> endpoint <docsServiceUri> with Variable "DOCUMENTIDTRADELICENSE" and other parameters "" Without Lang Header
    Then Response Code should be 404

     # List Company
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I call the GET Request for service <serviceName> endpoint <serviceUri> with Variable "ID" and other parameters ""
    Then Response Code should be <arg0>
    And Verify that response is not empty
    And Response Body Should Exact Match the Value "unverified" with Expression "company.status"

    Examples:
      | serviceName     | serviceUri  | docsServiceUri | docFileName                                           | arg0 | createFileName                      | parameters | Body | editFileName                        | companyBody                                                                          | createCompanyDocs                                     | confirmParameters |
      | "ORGANIZATIONS" | "companies" | "companydocs"  | "BOLT/JsonFiles/createCompanyDocsBasedonCompany.json" | 200  | "BOLT/JsonFiles/createCompany.json" | "/verify"  | ""   | "BOLT/JsonFiles/updateCompany.json" | name=Alphabets_Inc_Ltd_Testing trade_license_no=TLN_129 tax_registration_no=TRN_5678 | "BOLT/JsonFiles/createCompanyDocsBasedonCompany.json" | "?confirm=1"      |

  @BDDTEST-PE-3421
  Scenario Outline: "User should be able to block a store by blocking the company with 200 Successful Responses"
    # Create Company
    Given I prepare the Body <createFileName> Without Parameter updates in Request
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And Set Variable "ID" from Response Body with Expression "company.id"

    # Update Company
    Given I prepare the Body <editFileName> With Parameters "<companyBody>"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter "" with Body
    Then Response Code should be 200

    # Create doc with company_trade_license
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <docFileName> With Random String Parameters "RANDOM=RANDOM_STRING"
    Given I prepare the Body variable with Parameter name "company_id" and variable "ID"
    Given I prepare the Body variable with Parameter name "type" and value "company_trade_license"
    When I call the POST Request service <serviceName> endpoint <docServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/createCompanyDocs.json"

    # Create doc with company_tax_cert
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <docFileName> With Random String Parameters "RANDOM=RANDOM_STRING"
    Given I prepare the Body variable with Parameter name "company_id" and variable "ID"
    Given I prepare the Body variable with Parameter name "type" and value "company_tax_cert"
    When I call the POST Request service <serviceName> endpoint <docServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/createCompanyDocs.json"

    # Verify Company
    Given I prepare the Body With Parameters <Body>
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter <parameters> with Body
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value "verified" with Expression "company.status"

    # Create Store
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <createStoreFileName> With Variables "company_id=ID"
    When I call the POST Request service <serviceName> endpoint <storesServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And Set Variable "STOREID" from Response Body with Expression "store.id"

    # Verify Store
    Given I prepare the Body With Parameters <Body>
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the PATCH Request service <serviceName> endpoint <storesServiceUri> with Variable "STOREID" and Parameter <parameters> with Body
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value "verified" with Expression "store.status"

     # Blocked Company
    Given I prepare the Body With Parameters <Body>
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter "/block" with Body
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value "blocked" with Expression "company.status"

    # Verify stores are blocked
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I call the GET Request for service <serviceName> endpoint <storesServiceUri> with Variable "STOREID" and other parameters "" Without Lang Header
    Then Response Code should be 200
    And Verify that response is not empty
    And Response Body Should Exact Match the Value "blocked" with Expression "store.status"

    Examples:
      | serviceName     | serviceUri  | docServiceUri | storesServiceUri | arg0 | docFileName                                           | createFileName                      | parameters | Body | editFileName                        | companyBody                                                                          | createStoreFileName                              |
      | "ORGANIZATIONS" | "companies" | "companydocs" | "stores"         | 200  | "BOLT/JsonFiles/createCompanyDocsBasedonCompany.json" | "BOLT/JsonFiles/createCompany.json" | "/verify"  | ""   | "BOLT/JsonFiles/updateCompany.json" | name=Alphabets_Inc_Ltd_Testing trade_license_no=TLN_129 tax_registration_no=TRN_5678 | "BOLT/JsonFiles/createStoresBasedonCompany.json" |

  @BDDTEST-PE-3422
  Scenario Outline: "User should be able to unverify a store by unverifying the company with 200 Successful Responses"
    # Create Company
    Given I prepare the Body <createFileName> Without Parameter updates in Request
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And Set Variable "ID" from Response Body with Expression "company.id"

    # Update Company
    Given I prepare the Body <editFileName> With Parameters "<companyBody>"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter "" with Body
    Then Response Code should be <arg0>

    # Create doc with company_trade_license
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <docFileName> With Random String Parameters "RANDOM=RANDOM_STRING"
    Given I prepare the Body variable with Parameter name "company_id" and variable "ID"
    Given I prepare the Body variable with Parameter name "type" and value "company_trade_license"
    When I call the POST Request service <serviceName> endpoint <docServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/createCompanyDocs.json"

    # Create doc with company_tax_cert
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <docFileName> With Random String Parameters "RANDOM=RANDOM_STRING"
    Given I prepare the Body variable with Parameter name "company_id" and variable "ID"
    Given I prepare the Body variable with Parameter name "type" and value "company_tax_cert"
    When I call the POST Request service <serviceName> endpoint <docServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/createCompanyDocs.json"

    # Verify Company
    Given I prepare the Body With Parameters <Body>
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter <parameters> with Body
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value "verified" with Expression "company.status"

    # Create Store
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <createStoreFileName> With Variables "company_id=ID"
    When I call the POST Request service <serviceName> endpoint <storesServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And Set Variable "STOREID" from Response Body with Expression "store.id"

    # Verify Store
    Given I prepare the Body With Parameters <Body>
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the PATCH Request service <serviceName> endpoint <storesServiceUri> with Variable "STOREID" and Parameter <parameters> with Body
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value "verified" with Expression "store.status"

     # Unverify Company
    Given I prepare the Body With Parameters "{\"trade_license_no\": \"\"}"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    When I call the PATCH Request service <serviceName> endpoint <serviceUri> with Variable "ID" and Parameter "?confirm=1" with Body
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value "unverified" with Expression "company.status"

    # Verify stores are unverified
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I call the GET Request for service <serviceName> endpoint <storesServiceUri> with Variable "STOREID" and other parameters "" Without Lang Header
    Then Response Code should be <arg0>
    And Verify that response is not empty
    And Response Body Should Exact Match the Value "unverified" with Expression "store.status"

    Examples:
      | serviceName     | serviceUri  | docServiceUri | docFileName                                           | storesServiceUri | arg0 | createFileName                      | parameters | Body | editFileName                        | companyBody                                                                          | createStoreFileName                              |
      | "ORGANIZATIONS" | "companies" | "companydocs" | "BOLT/JsonFiles/createCompanyDocsBasedonCompany.json" | "stores"         | 200  | "BOLT/JsonFiles/createCompany.json" | "/verify"  | ""   | "BOLT/JsonFiles/updateCompany.json" | name=Alphabets_Inc_Ltd_Testing trade_license_no=TLN_129 tax_registration_no=TRN_5678 | "BOLT/JsonFiles/createStoresBasedonCompany.json" |

  @BDDTEST-PE-3512
  Scenario Outline: "User should be able to create store docs with 201 Successful Responses"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <createStoreFileName> With Parameters "<createStoreBody>"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be <arg0>
    And Verify that response is not empty
    And Set Variable "STOREID" from Response Body with Expression "store.id"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <createStoreDocFileName> With Random String Parameters "RANDOM=RANDOM_STRING"
    Given I prepare the Body variable with Parameter name "store_id" and variable "STOREID"
    Given I prepare the Body variable with Parameter name "expiry_date" and value <expireDate>
    When I call the POST Request service <serviceName> endpoint <storesDocServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be <arg0>
    And Verify that response is not empty
    And Response Body Should not blank with Expression "document.id"
    And Response Body Should not blank with Expression "document.store_id"
    And Response Body Should not blank with Expression "document.store_id"
    And Response Body Should not blank with Expression "document.media_id"
    And Response Body Should not blank with Expression "document.expiry_date"
    And Response Body Should not blank with Expression "document.created_at"
    And Response Body Should not blank with Expression "document.updated_at"

    Examples:
      | serviceName     | serviceUri | storesDocServiceUri | arg0 | createStoreDocFileName                 | createStoreFileName                               | createStoreBody    | expireDate             |
      | "ORGANIZATIONS" | "stores"   | "companystoresdocs" | 201  | "BOLT/JsonFiles/createStoresDocs.json" | "BOLT/JsonFiles/createStores.json"                | name=Example_Store | "2029-10-29T14:32:15Z" |
      | "ORGANIZATIONS" | "stores"   | "companystoresdocs" | 201  | "BOLT/JsonFiles/createStoresDocs.json" | "BOLT/JsonFiles/createStoresVerifiedCompany.json" | name=Example_Store | "2029-10-29T14:32:15Z" |
      | "ORGANIZATIONS" | "stores"   | "companystoresdocs" | 201  | "BOLT/JsonFiles/createStoresDocs.json" | "BOLT/JsonFiles/createStoresBlockedCompany.json"  | name=Example_Store | "2029-10-29T14:32:15Z" |

  @BDDTEST-PE-3510
  Scenario Outline: "User should not be able to create store docs with 400/404/422 Responses"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    Given I prepare the Body <createStoreDocFileName> With Random String Parameters "RANDOM=RANDOM_STRING"
    Given I prepare the Body variable with Parameter name "store_id" and value "<storeID>"
    Given I prepare the Body variable with Parameter name "expiry_date" and value <expireDate>
    When I call the POST Request service <serviceName> endpoint <storesDocServiceUri> with Variable "" and Parameter <parameters> with Body
    Then Response Code should be <arg0>
    And Verify that response is not empty
    And Response Body Should Exact Match the Value <Message> with Expression "error_code"

    Examples:
      | serviceName     | storesDocServiceUri | arg0 | createStoreDocFileName                 | headerValue  | Message            | parameters   | expireDate             | storeID    |
      | "ORGANIZATIONS" | "companystoresdocs" | 422  | "BOLT/JsonFiles/createStoresDocs.json" | "en-USfdgfg" | "validation_error" | ""           | "2029-10-29T14:32:15Z" | 555        |
      | "ORGANIZATIONS" | "companystoresdocs" | 400  | "BOLT/JsonFiles/createStoresDocs.json" | ""           | "validation_error" | ""           | "2029-10-29T14:32:15Z" | 555        |
      | "ORGANIZATIONS" | "companystoresdocs" | 422  | "BOLT/JsonFiles/createStoresDocs.json" | "en-US"      | "validation_error" | ""           | "2021-10-29T14:32:15Z" | 555        |
      | "ORGANIZATIONS" | "companystoresdocs" | 404  | "BOLT/JsonFiles/createStoresDocs.json" | "en-US"      | "not_found"        | "ddf454grry" | "2029-10-29T14:32:15Z" | 3456576576 |
      | "ORGANIZATIONS" | "companystoresdocs" | 404  | "BOLT/JsonFiles/createStoresDocs.json" | "en-US"      | "not_found"        | "ddf454grry" | "2029-10-29T14:32:15Z" | 555        |

  @BDDTEST-PE-3511
  Scenario Outline: "User should not be able to create store docs with 422 Bad Data Entity Error Responses"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    Given I prepare the Body With Parameters <Body>
    When I call the POST Request service <serviceName> endpoint <storesDocServiceUri> with Variable "" and Parameter <parameters> with Body
    Then Response Code should be <arg0>
    And Verify that response is not empty
    And Response Body Should Exact Match the Value <Message> with Expression "error_code"

    Examples:
      | serviceName     | storesDocServiceUri | arg0 | Body                                                                                                                                 | headerValue | Message            | parameters |
      | "ORGANIZATIONS" | "companystoresdocs" | 400  | "{\"store_id\": \"\",\"type\": \"store_bank_details\",\"media_id\": \"496-302-5380\",\"expiry_date\": \"2029-10-29T14:32:15Z\"}"     | "en-US"     | "validation_error" | ""         |
      | "ORGANIZATIONS" | "companystoresdocs" | 422  | "{\"store_id\": 555,\"type\": \"store_bank_details\",\"media_id\": \"\",\"expiry_date\": \"2029-10-29T14:32:15Z\"}"                  | "en-US"     | "validation_error" | ""         |
      | "ORGANIZATIONS" | "companystoresdocs" | 422  | "{\"store_id\": 555,\"type\": \"\",\"media_id\": \"496-302-5380\",\"expiry_date\": \"2029-10-29T14:32:15Z\"}"                        | "en-US"     | "validation_error" | ""         |
      | "ORGANIZATIONS" | "companystoresdocs" | 400  | "{\"store_id\": 555,\"type\": \"store_bank_detailsdcfdf\",\"media_id\": \"496-302-5380\",\"expiry_date\": \"2029-10-29T14:32:15Z\"}" | "en-US"     | "validation_error" | ""         |
      | "ORGANIZATIONS" | "companystoresdocs" | 422  | "{\"store_id\": null,\"type\": \"store_bank_details\",\"media_id\": \"496-302-5380\",\"expiry_date\": \"2029-10-29T14:32:15Z\"}"     | "en-US"     | "validation_error" | ""         |
      | "ORGANIZATIONS" | "companystoresdocs" | 400  | "{\"store_id\": null,\"type\": \"\",\"media_id\": \"\",\"expiry_date\": \"\"}"                                                       | "en-US"     | "validation_error" | ""         |

  @BDDTEST-PE-3509
  Scenario Outline: "User should be able to read store docs with 200 Successful Responses"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <createStoreFileName> With Parameters "<createStoreBody>"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And Set Variable "STOREID" from Response Body with Expression "store.id"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <createStoreDocFileName> With Random String Parameters "RANDOM=RANDOM_STRING"
    Given I prepare the Body variable with Parameter name "store_id" and variable "STOREID"
    Given I prepare the Body variable with Parameter name "expiry_date" and value <expireDate>
    When I call the POST Request service <serviceName> endpoint <storesDocServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And Set Variable "STOREDOCID" from Response Body with Expression "document.id"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I call the GET Request for service <serviceName> endpoint <storesDocServiceUri> with Variable "STOREDOCID" and other parameters "" Without Lang Header
    Then Response Code should be <arg0>
    And Verify that response is not empty
    And Response Body Should not blank with Expression "document.id"
    And Response Body Should Exact Match the Variable "STOREID" with Expression "document.store_id"
    And Response Body Should not blank with Expression "document.media_id"
    And Response Body Should not blank with Expression "document.expiry_date"
    And Response Body Should not blank with Expression "document.created_at"
    And Response Body Should not blank with Expression "document.updated_at"

    Examples:
      | serviceName     | serviceUri | storesDocServiceUri | arg0 | createStoreDocFileName                 | createStoreFileName                | createStoreBody    | expireDate             |
      | "ORGANIZATIONS" | "stores"   | "companystoresdocs" | 200  | "BOLT/JsonFiles/createStoresDocs.json" | "BOLT/JsonFiles/createStores.json" | name=Example_Store | "2029-10-29T14:32:15Z" |

  @BDDTEST-PE-3508
  Scenario Outline: "User should not be able to read store docs with 400/422/404 Responses"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    Given I call the GET Request for service <serviceName> endpoint <storesDocServiceUri> with Variable "" and other parameters <parameters> Without Lang Header
    Then Response Code should be <arg0>
    And Verify that response is not empty
    And Response Body Should Exact Match the Value <message> with Expression "error_code"

    Examples:
      | serviceName     | storesDocServiceUri | arg0 | message            | headerValue   | parameters |
      | "ORGANIZATIONS" | "companystoresdocs" | 400  | "validation_error" | ""            | "/13"      |
      | "ORGANIZATIONS" | "companystoresdocs" | 422  | "validation_error" | "en-USdfdfdg" | "/13"      |
      | "ORGANIZATIONS" | "companystoresdocs" | 404  | "not_found"        | ""            | "safdsf"   |

  @BDDTEST-PE-3532
  Scenario Outline: "User should be able to create store pocs with 201 Successful Responses"
    Given I prepare the Body With Parameters "{\"name\": \"XYZ Holdings\"}"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And Set Variable "ID" from Response Body with Expression "company.id"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <createStoreFileName> With Parameters "<createStoreBody>"
    Given I prepare the Body variable with Parameter name "company_id" and variable "ID"
    When I call the POST Request service <serviceName> endpoint <storesServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And Set Variable "STOREID" from Response Body with Expression "store.id"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <createStoresPocFileName> Without Parameter updates in Request
    Given I prepare the Body variable with Parameter name "store_id" and variable "STOREID"
    When I call the POST Request service <serviceName> endpoint <storesPocServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be <arg0>
    And Verify that response is not empty
    And Response Body Should not blank with Expression "point_of_contact.id"
    And Response Body Should not blank with Expression "point_of_contact.store_id"
    And Response Body Should Exact Match the Value "John" with Expression "point_of_contact.first_name"
    And Response Body Should Exact Match the Value "Doe" with Expression "point_of_contact.last_name"
    And Response Body Should Exact Match the Value "+971443022221" with Expression "point_of_contact.phone_number"
    And Response Body Should Exact Match the Value "user@example.com" with Expression "point_of_contact.email"
    And Response Body Should not blank with Expression "point_of_contact.created_at"
    And Response Body Should not blank with Expression "point_of_contact.updated_at"

    Examples:
      | serviceName     | serviceUri  | storesServiceUri | storesPocServiceUri | createStoreFileName                              | arg0 | createStoreBody    | createStoresPocFileName                |
      | "ORGANIZATIONS" | "companies" | "stores"         | "storespocs"        | "BOLT/JsonFiles/createStoresBasedonCompany.json" | 201  | name=Example_Store | "BOLT/JsonFiles/createStoresPocs.json" |

  @BDDTEST-PE-3533
  Scenario Outline: "User should not be able to create store pocs with 400/422/404 Responses"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    Given I prepare the Body With Parameters "<createStoreBody>"
    When I call the POST Request service <serviceName> endpoint <storesPocServiceUri> with Variable "" and Parameter <parameters> with Body
    Then Response Code should be <arg0>
    And Verify that response is not empty
    And Response Body Should Exact Match the Value <message> with Expression "error_code"

    Examples:
      | serviceName     | storesPocServiceUri | arg0 | createStoreBody                                                                                                                         | message            | headerValue  | parameters  |
      | "ORGANIZATIONS" | "storespocs"        | 422  | {\"store_id\": 733,\"first_name\": \"\",\"last_name\": \"Doe\",\"phone_number\": \"+971443022221\",\"email\": \"user@example.com\"}     | "validation_error" | "en-US"      | ""          |
      | "ORGANIZATIONS" | "storespocs"        | 422  | {\"store_id\": 733,\"first_name\": \"John\",\"last_name\": \"\",\"phone_number\": \"+971443022221\",\"email\": \"user@example.com\"}    | "validation_error" | "en-US"      | ""          |
      | "ORGANIZATIONS" | "storespocs"        | 422  | {\"store_id\": 733,\"first_name\": \"John\",\"last_name\": \"Doe\",\"phone_number\": \"\",\"email\": \"user@example.com\"}              | "validation_error" | "en-US"      | ""          |
      | "ORGANIZATIONS" | "storespocs"        | 422  | {\"store_id\": 733,\"first_name\": \"John\",\"last_name\": \"Doe\",\"phone_number\": \"+971443022221\",\"email\": \"\"}                 | "validation_error" | "en-US"      | ""          |
      | "ORGANIZATIONS" | "storespocs"        | 422  | {\"store_id\": 733,\"first_name\": \"\",\"last_name\": \"\",\"phone_number\": \"\",\"email\": \"\"}                                     | "validation_error" | "en-US"      | ""          |
      | "ORGANIZATIONS" | "storespocs"        | 422  | {\"store_id\": 733,\"first_name\": \"John\",\"last_name\": \"Doe\",\"phone_number\": \"+971443022221\",\"email\": \"user@example\"}     | "validation_error" | "en-US"      | ""          |
      | "ORGANIZATIONS" | "storespocs"        | 422  | {\"store_id\": 733,\"first_name\": \"John\",\"last_name\": \"Doe\",\"phone_number\": \"*971443022221\",\"email\": \"user@example.com\"} | "validation_error" | "en-US"      | ""          |
      | "ORGANIZATIONS" | "storespocs"        | 422  | {\"store_id\": 733}                                                                                                                     | "validation_error" | "en-US"      | ""          |
      | "ORGANIZATIONS" | "storespocs"        | 400  | {\"store_id\": 733,\"first_name\": \"John\",\"last_name\": \"Doe\",\"phone_number\": \"+971443022221\",\"email\": \"user@example.com\"} | "validation_error" | ""           | ""          |
      | "ORGANIZATIONS" | "storespocs"        | 422  | {\"store_id\": 733,\"first_name\": \"John\",\"last_name\": \"Doe\",\"phone_number\": \"+971443022221\",\"email\": \"user@example.com\"} | "validation_error" | "en-USdvfgf" | ""          |
      | "ORGANIZATIONS" | "storespocs"        | 404  | {\"store_id\": 733,\"first_name\": \"John\",\"last_name\": \"Doe\",\"phone_number\": \"+971443022221\",\"email\": \"user@example.com\"} | "not_found"        | "en-USdvfgf" | "sdfdsfdgd" |
      | "ORGANIZATIONS" | "storespocs"        | 422  | {}                                                                                                                                      | "validation_error" | "en-US"      | ""          |

  @BDDTEST-PE-3534
  Scenario Outline: "User should be able to read store pocs with 200 Successful Responses"
    Given I prepare the Body With Parameters "{\"name\": \"XYZ Holdings\"}"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And Set Variable "ID" from Response Body with Expression "company.id"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <createStoreFileName> With Parameters "<createStoreBody>"
    Given I prepare the Body variable with Parameter name "company_id" and variable "ID"
    When I call the POST Request service <serviceName> endpoint <storesServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And Set Variable "STOREID" from Response Body with Expression "store.id"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <createStoresPocFileName> Without Parameter updates in Request
    Given I prepare the Body variable with Parameter name "store_id" and variable "STOREID"
    When I call the POST Request service <serviceName> endpoint <storesPocServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And Set Variable "POCID" from Response Body with Expression "point_of_contact.id"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I call the GET Request for service <serviceName> endpoint <storesPocServiceUri> with Variable "POCID" and other parameters "" Without Lang Header
    Then Response Code should be <arg0>
    And Response Body Should not blank with Expression "point_of_contact.id"
    And Response Body Should not blank with Expression "point_of_contact.store_id"
    And Response Body Should not blank with Expression "point_of_contact.first_name"
    And Response Body Should not blank with Expression "point_of_contact.last_name"
    And Response Body Should not blank with Expression "point_of_contact.phone_number"
    And Response Body Should not blank with Expression "point_of_contact.email"
    And Response Body Should not blank with Expression "point_of_contact.created_at"
    And Response Body Should not blank with Expression "point_of_contact.updated_at"


    Examples:
      | serviceName     | serviceUri  | storesServiceUri | storesPocServiceUri | createStoreFileName                              | arg0 | createStoreBody    | createStoresPocFileName                |
      | "ORGANIZATIONS" | "companies" | "stores"         | "storespocs"        | "BOLT/JsonFiles/createStoresBasedonCompany.json" | 200  | name=Example_Store | "BOLT/JsonFiles/createStoresPocs.json" |

  @BDDTEST-PE-3535
  Scenario Outline: "User should not be able to read store pocs with 400/422/404 Responses"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    Given I call the GET Request for service <serviceName> endpoint <storesPocServiceUri> with Variable "" and other parameters <parameters> Without Lang Header
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value <message> with Expression "error_code"

    Examples:
      | serviceName     | storesPocServiceUri | arg0 | message            | headerValue | parameters |
      | "ORGANIZATIONS" | "storespocs"        | 400  | "validation_error" | ""          | "/1"       |
      | "ORGANIZATIONS" | "storespocs"        | 422  | "validation_error" | "en-USegdg" | "/1"       |
      | "ORGANIZATIONS" | "storespocs"        | 400  | "validation_error" | "en-US"     | "/dgdfg"   |
      | "ORGANIZATIONS" | "storespocs"        | 404  | "not_found"        | "en-US"     | "dgdfg"    |

  @BDDTEST-PE-3629
  Scenario Outline: "User should be able to list store pocs with 200 Successful Responses"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I call the GET Request for service <serviceName> endpoint <storesPocServiceUri> with Variable "" and other parameters <parameter> Without Lang Header
    Then Response Code should be <arg0>
    And Response Body Should not blank with Expression "data[0].id"
    And Response Body Should not blank with Expression "data[0].store_id"
    And Response Body Should not blank with Expression "data[0].first_name"
    And Response Body Should not blank with Expression "data[0].last_name"
    And Response Body Should not blank with Expression "data[0].phone_number"
    And Response Body Should not blank with Expression "data[0].email"
    And Response Body Should not blank with Expression "data[0].created_at"
    And Response Body Should not blank with Expression "data[0].updated_at"
    And the schema should match with the specification defined in "com/api/squads/BOLT/schema/listStoresPoc.json"

    Examples:
      | serviceName     | storesPocServiceUri | arg0 | parameter                         |
      | "ORGANIZATIONS" | "storespocs"        | 200  | "?page=1&per_page=20&store_ids=1" |

  @BDDTEST-PE-3630
  Scenario Outline: "User should not be able to list store pocs with 400/404/422 Responses"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    Given I call the GET Request for service <serviceName> endpoint <storesPocServiceUri> with Variable "" and other parameters <parameter> Without Lang Header
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value <message> with Expression "error_code"

    Examples:
      | serviceName     | storesPocServiceUri | arg0 | parameter                                   | message            | headerValue  |
      | "ORGANIZATIONS" | "storespocs"        | 400  | "?page=1&per_page=20&store_ids=1"           | "validation_error" | ""           |
      | "ORGANIZATIONS" | "storespocs"        | 422  | "?page=1&per_page=20&store_ids=1"           | "validation_error" | "en-USdsfdf" |
      | "ORGANIZATIONS" | "storespocs"        | 404  | "dsvdfgfgfd?page=1&per_page=20&store_ids=1" | "not_found"        | "en-US"      |
      | "ORGANIZATIONS" | "storespocs"        | 400  | "?page=1&per_page=20&store_ids=ddfg"        | "validation_error" | "en-US"      |

  @BDDTEST-PE-3631
  Scenario Outline: "User should be able to delete store pocs with 204 Successful Responses"
    Given I prepare the Body With Parameters "{\"name\": \"XYZ Holdings\"}"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And Set Variable "ID" from Response Body with Expression "company.id"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <createStoreFileName> With Parameters "<createStoreBody>"
    Given I prepare the Body variable with Parameter name "company_id" and variable "ID"
    When I call the POST Request service <serviceName> endpoint <storesServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And Set Variable "STOREID" from Response Body with Expression "store.id"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <createStoresPocFileName> Without Parameter updates in Request
    Given I prepare the Body variable with Parameter name "store_id" and variable "STOREID"
    When I call the POST Request service <serviceName> endpoint <storesPocServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And Set Variable "POCID" from Response Body with Expression "point_of_contact.id"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I call the DELETE Request for service <serviceName> endpoint <storesPocServiceUri> with Variable "POCID" and other parameters ""
    Then Response Code should be <arg0>

    Examples:
      | serviceName     | serviceUri  | storesServiceUri | storesPocServiceUri | createStoreFileName                              | arg0 | createStoreBody    | createStoresPocFileName                |
      | "ORGANIZATIONS" | "companies" | "stores"         | "storespocs"        | "BOLT/JsonFiles/createStoresBasedonCompany.json" | 204  | name=Example_Store | "BOLT/JsonFiles/createStoresPocs.json" |

  @BDDTEST-PE-3632
  Scenario Outline: "User should not be able to delete store pocs with 400/404/422 Successful Responses"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    Given I call the DELETE Request for service <serviceName> endpoint <storesPocServiceUri> with Variable "" and other parameters <parameter>
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value <message> with Expression "error_code"

    Examples:
      | serviceName     | storesPocServiceUri | arg0 | headerValue | message                                    | parameter     |
      | "ORGANIZATIONS" | "storespocs"        | 400  | ""          | "validation_error"                         | "/1"          |
      | "ORGANIZATIONS" | "storespocs"        | 422  | "en-USdfd"  | "validation_error"                         | "/1"          |
      | "ORGANIZATIONS" | "storespocs"        | 404  | "en-US"     | "not_found"                                | "/1/sdsdvd"   |
      | "ORGANIZATIONS" | "storespocs"        | 404  | "en-US"     | "store_point_of_contacts_record_not_found" | "/1090980808" |

  @BDDTEST-PE-3633
  Scenario Outline: "User should be able to update store pocs with 200 Successful Responses"
    Given I prepare the Body With Parameters "{\"name\": \"XYZ Holdings\"}"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the POST Request service <serviceName> endpoint <serviceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And Set Variable "ID" from Response Body with Expression "company.id"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <createStoreFileName> With Parameters "<createStoreBody>"
    Given I prepare the Body variable with Parameter name "company_id" and variable "ID"
    When I call the POST Request service <serviceName> endpoint <storesServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And Set Variable "STOREID" from Response Body with Expression "store.id"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    Given I prepare the Body <createStoresPocFileName> Without Parameter updates in Request
    Given I prepare the Body variable with Parameter name "store_id" and variable "STOREID"
    When I call the POST Request service <serviceName> endpoint <storesPocServiceUri> with Variable "" and Parameter "" with Body
    Then Response Code should be 201
    And Verify that response is not empty
    And Set Variable "POCID" from Response Body with Expression "point_of_contact.id"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    Given I prepare the Body <updateStoresPocFileName> Without Parameter updates in Request
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value "en-US"
    When I call the PATCH Request service <serviceName> endpoint <storesPocServiceUri> with Variable "POCID" and Parameter "" with Body
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value "John1" with Expression "point_of_contact.first_name"
    And Response Body Should Exact Match the Value "Doe1" with Expression "point_of_contact.last_name"
    And Response Body Should Exact Match the Value "+971443022220" with Expression "point_of_contact.phone_number"
    And Response Body Should Exact Match the Value "user1@example.com" with Expression "point_of_contact.email"

    Examples:
      | serviceName     | serviceUri  | storesServiceUri | storesPocServiceUri | createStoreFileName                              | arg0 | createStoreBody    | createStoresPocFileName                | updateStoresPocFileName               |
      | "ORGANIZATIONS" | "companies" | "stores"         | "storespocs"        | "BOLT/JsonFiles/createStoresBasedonCompany.json" | 200  | name=Example_Store | "BOLT/JsonFiles/createStoresPocs.json" | "BOLT/JsonFiles/updateStoresPoc.json" |

  @BDDTEST-PE-3634
  Scenario Outline: "User should not be able to update store pocs with 400/422/404 Responses"
    Given I prepare the request headers with key "Content-Type" and prefix "" and Static value "application/json"
    Given I prepare the Body With Parameters "<Body>"
    And I prepare the request headers with key "Accept-Language" and prefix "" and Static value <headerValue>
    When I call the PATCH Request service <serviceName> endpoint <storesPocServiceUri> with Variable "" and Parameter <parameter> with Body
    Then Response Code should be <arg0>
    And Response Body Should Exact Match the Value <message> with Expression "error_code"

    Examples:
      | serviceName     | storesPocServiceUri | arg0 | parameter  | Body                                                                              | message                                            | headerValue   |
      | "ORGANIZATIONS" | "storespocs"        | 422  | "/1"       | {\"first_name\": \"\",\"last_name\": \"\",\"phone_number\": \"\",\"email\": \"\"} | "unable_to_update_store_poc_with_all_blank_fields" | "en-US"       |
      | "ORGANIZATIONS" | "storespocs"        | 400  | "/1"       |                                                                                   | "validation_error"                                 | ""            |
      | "ORGANIZATIONS" | "storespocs"        | 422  | "/1"       |                                                                                   | "validation_error"                                 | "en-USdfgfdg" |
      | "ORGANIZATIONS" | "storespocs"        | 404  | "/1/dfdsf" |                                                                                   | "not_found"                                        | "en-USdfgfdg" |
      | "ORGANIZATIONS" | "storespocs"        | 400  | "/1"       | {}                                                                                | "validation_error"                                 | "en-US"       |


