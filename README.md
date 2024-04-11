# Getting started with REST API testing with Serenity and Cucumber 6

This is a  CAFU API Automation project for Serenity with Cucumber 6 and RestAssured to ensure the API automated testing

# Development Languages and libraries
Name Version
1. Language  JAVA 11
2. Serenity_BDD 2.4.51
3. Serenity_Cucumber 6 2.4.51
4. REST_Assured 4.3.3
5. Spring_Boot 2.3.12.RELEASE

# Work on Local
1. Install JAVA 8 Configure JAVA_HOME
2. Install Maven 3 Configure MAVEN_HOME
3. Clone the Project from GIT LAB (Make sure you have the access of Repo)
4. Open the POM.XML File in any editor (Recommended is InteliJ Idea Community Edition)
5. Open CMD Prompt and Go to Project Director. (POM.xml File path)
6. RUN MAVEN Command (mvn clean install) and wait for Dependencies to be Installed in your local .m2 directory.
7. Now go to file "Applicaton.java" and run the file.
8. The Spring Boot Application will be started on the default port 8080 _(Make Sure port is available)_
9. Now Open the browser and send the request http://localhost:8080/health , response should be {"up":"running"}
10. 

# How to add Test Cases
1. Write Test Case(s) the Feature File in the Respective SERVICE folder under resources.
2. Open the /src/test/{service}/{module} folder.
3. Three Classes required to add for new test Case.
    a. stepdefinitions -
             (module)steps - create new methods as per the test case defined in the feature file.
    b.actions -
             {module}actions - Define the actions like GET or POST to support your test case
             {module}questions - Define the Validations or assertion as per the acceptance criteria
4. Define the Proper Tag in the feature file
    a.@testsuite - This could be “sanity”, “regression” or  “smoke”
    b.@testtype - This could be “functional”
    c.@service - This could be name of your service which Test Case belongs
    d.@priority - Priority could be HIGH - 5 , Medium - 3 & Low - 1


# Rest API details

1. curl http://localhost:8080/health
Response : {"status":up}

2. curl http://localhost:8080/cafu/api/v1/{notification}
Response : {
  "featureName":"notification",
  "Result":"Executed successfully",
  "ReportPath":"http://localhost:63342/serenity-cucumber4-apitests/target/site/serenity/index.html"
}

# Configurations
Below is the same for the PILOT-BFF Base Url for Default, DEV and Staging Environment.
Value can be updated in the file src/test/resources/serenity.conf

environments.default.BASEURL_PILOT-BFF "https://pilot-bff.ca.dev.cafu.app"
environments.dev.BASEURL_PILOT-BFF "https://pilot-bff.ca.dev.cafu.app"
environments.staging.BASEURL_PILOT-BFF "https://pilot-bff.ca.staging.cafu.app"

## Execute Scenarios by Tags

This Framework further extend to help us to execute custom scenarios and organize it.
For Example: if you want to test only Customer-BFF scenarios, you can execute the test scenarios using tag -> **'@Customer-Bff'**.

Following are the list of tags available for our execution,

###### Execute all the Services ->

**@Regression**

###### Execute specific Module ->

| **_Services_**  | **_Tags_**         |
|-----------------|--------------------|
| B2B             | @B2B               |
| BOLT            | @BOLT              |
| EV_CUSTOMER     | @EV_CUSTOMER       |
| EV_OPS          | @EV_OPS            |
| EV_PILOT        | @EV_PILOT          |
| LOYALTY_REWARDS | @LOYALTY_REWARDS   |
| PAYMENTS        | @LEGACYPAYMENTS    |
| ROUTING         | @ROUTING           |

###### Execute specific Service ->

| **_Services_**       	             | **_Tags_**                      |
|------------------------------------|---------------------------------|
| Addresses            	             | @Addresses                      |
| Assets               	             | @Assets                         |
| Catalog              	             | @Catalog                        |
| Content              	             | @Content                        |
| Customer BFF         	             | @Customer-Bff                   |
| Identity             	             | @Identity                       |
| Identity Auth        	             | @Identity-Auth                  |
| Internal BFF         	             | @Internal-BFF                   |
| Logistics            	             | @Logistics                      |
| Notification         	             | @Notification                   |
| Operational Assets   	             | @Operational-Assets             |
| Orders               	             | @Orders                         |
| Payments             	             | @Payments                       |
| Payments Gateway     	             | @Payment-Gateway                |
| Pilot BFF            	             | @Pilot-Bff                      |
| Pilot                	             | @Pilot                          |
| Vehicle Connectivity 	             | @Vehicle-Connectivity           |
| Legacy Payments Applepay Adyen   	 | @LegacyPaymentsApplePayAdyen    |
| Legacy Payments Applepay Checkout	 | @LegacyPaymentsApplePayCheckout |
| Legacy Payments Card Checkout	     | @LegacyPaymentsCardCheckout     |
| B2b Admin Asset       	            | @b2b-assets                     |
| B2b Admin V1 Asset    	            | @b2b-clients                    |
| B2b Analytics		     	              | @b2b-orders				                 |
| B2b Auth	               	          | @cafu-business-backend	         |
| B2b Clients		                      | @b2b-clients				                |
| B2b Clients Asset	       	         | @b2b-assets					                |
| b2b EWD Clients	       	           | @b2b-clients				                |
| B2b Orders		       	               | @b2b-orders-v2  @b2b-orders     |
| B2b ProductPricing	                | @cafu-business-backend	         |
| B2b Projects	                      | @cafu-business-backend	         |
| B2b Locations	                     | @cafu-business-backend	         |
| B2b Pocs	                          | @cafu-business-backend	         |
| B2B Service Limit                   | @b2b-orders-v2                  | 


###### Execution based on Jira Tickets ->

| **_Jira Level_**  | **_Tags_**               |
|-------------------|--------------------------|
| Story             | @BDDSTORY-PE-XX          |
| Test            	 | @BDDTEST-PE-XX           |
| Defect            | @DEFECT-{ProjectCode}-XX |

* XX represents ID number of the jira ticket
* {ProjectCode} represents Project ID, example: @DEFECT-EV-468

###### Execution Based on Priority ->

| **_Priority Level_** | **_Tags_** |
|----------------------|------------|
| Priority 1           | @P1        |
| Priority 2           | @P2        |
| Priority 3           | @P3        |

Example: If you want to execute Priority 1 cases for Identity Services, you need to provide -> **@Identity @P1**

###### Execute Sanity Cases for BFF Services ->

| **_Services_**  | **_Tags_**                                                                                           |
|-----------------|------------------------------------------------------------------------------------------------------|
| Customer Bff    | @sanity-customer-bff and @sanity-customer-bff-delete                                                 |
| Pilot Bff       | @sanity-pilot-bff                                                                                    |
| Payments Legacy | @Verify_all_payment_get_functions, @Compare_adyen_and_checkout_response and @VerifyLegacyInstrument  |


## Want to learn more?
For more information about Serenity BDD, you can read the [**Serenity BDD Book**](https://serenity-bdd.github.io/theserenitybook/latest/index.html), the official online Serenity documentation source. Other sources include:
* **[Byte-sized Serenity BDD](https://www.youtube.com/channel/UCav6-dPEUiLbnu-rgpy7_bw/featured)** - tips and tricks about Serenity BDD
* [**Serenity BDD Blog**](https://johnfergusonsmart.com/category/serenity-bdd/) - regular articles about Serenity BDD
* [**The Serenity Dojo**](https://www.serenity-dojo.com) - Tailored BDD and Test Automation Training and Mentoring

## Branch Name & Commit Message Rules
* Branch name - <TICKETNumber><SquadName><ServiceName>
example :
1. PE-1234_pilot_locationService
2. PE-9876_bolt_catalogService
3. PE-2312_pe_fixTestCases

* Commit Message : <Goal>:<ShortDescription>
Examples
1. Feature:NewTestCaseForPILOTLocation
2. Fix:TestCase Fix for Customer Team
*

##Contact
 mukesh.mangal@cafu.com
