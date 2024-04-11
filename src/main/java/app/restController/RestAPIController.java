package app.restController;


import app.utilities.CommandPrompt;
import app.utilities.CommonHelpers;
import app.utilities.PropertiesManager;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.*;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import static app.utilities.BaseAWSClient.uploadFilesToS3;

@RestController
@RequestMapping("/cafu/api/v1")
public class RestAPIController {

    static Logger log = LogManager.getLogger(RestAPIController.class.getName());
    private List<CafuSampleTest> cafuSampleTests;
    TestCaseResultsModel testCaseResultsModel = new TestCaseResultsModel();

    TestCaseRequestModel testCaseRequestModel = new TestCaseRequestModel();

    static Map<String, String> hashMap = new HashMap<String, String>() {{
        put("Status", "No Started!");
    }};
    String getCurrentDateTime;
    String reportDir;
    String reportUrl = PropertiesManager.getProperty("REPORT_PORTAL", PropertiesManager.prefix.NONE);
    private ServiceLayer serviceLayer = new ServiceLayer();
    private String testCaseTag = null;
    private String environment = null;

    public RestAPIController() {
        cafuSampleTests = new ArrayList<>();
        cafuSampleTests.add(new CafuSampleTest("Welcome In Cafu API Automation!"));
        cafuSampleTests.add(new CafuSampleTest("Hello World!"));
        cafuSampleTests.add(new CafuSampleTest("Enjoy Automation!"));
        cafuSampleTests.add(new CafuSampleTest("This is Latest Build?"));
    }

    @GetMapping("/random")
    public CafuSampleTest getRandom() {
        return cafuSampleTests.get(new Random().nextInt(cafuSampleTests.size()));
    }

    @RequestMapping(value = "/request", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<String> requestForTestCase(@RequestBody TestCaseRequestModel requestBody) {
        hashMap.clear();
        testCaseRequestModel.setUrl(PropertiesManager.getProperty("SLACK_CHANNEL_WEBHOOK", PropertiesManager.prefix.NONE));
        getCurrentDateTime = CommonHelpers.getCurrentDateTime("yyyy.MM.dd.HH.mm.ss.SSS");
        reportDir = "/tmp/report_" + getCurrentDateTime;
        String path = requestBody.getTag();
        environment = requestBody.getEnvironment();
        if(environment == null)
        {
            environment = "dev";
        }
        log.info("Request Started");
        // An Async task always executes in new thread
        hashMap.put("TAG", path);
        hashMap.put("Status", "In Process");
        hashMap.put("Environment",environment);
        setTestCaseStatus();
        testCaseTag = hashMap.get("TAG");
        //String s3ReportUrl = PropertiesManager.getProperty("AWS_REPORT_URL", PropertiesManager.prefix.NONE)
          //      + "report_" + getCurrentDateTime + "/index.html";
        String s3ReportUrl = "https://d2d5l0tb7auuuw.cloudfront.net/" + "report_" + getCurrentDateTime + "/index.html";
        new Thread(() -> {
            CommonHelpers.writeFile(hashMap);
            serviceLayer.runMavenCommand(path, reportDir, environment);
            if (requestBody.getReport()) {
                log.info("Ready to Upload the File on AWS S3 Bucket : " + reportDir);
               // uploadFilesToS3(reportDir);
                log.info("Uploading Finished to s3ReportUrl : <" + s3ReportUrl + ">");
            }
            hashMap.put("ReportUrl", reportUrl);
            log.info("Test Case Execution FINISHED!");
            hashMap.put("Status", "COMPLETED");
        }).start();

        return ResponseEntity.ok("{\n" +
                "  \"featureName\":\"" + path + "\",\n" +
              //  "  \"s3ReportUrl\":\"" + s3ReportUrl + "\",\n" +
                "  \"Result\":\"Request Execution Started!Check the Status API & Wait for Completed\"\n" +
                "}");
    }

    @GetMapping("/maven")
    public ResponseEntity<String> installMaven() {
        log.info("Downloading MAVEN Dependencies.... Wait()");
        String command = "/usr/share/maven/bin/mvn -f /usr/src/app/pom.xml" + " clean install -DskipTests";
        //String command = "/opt/apache-maven-3.8.6/bin/mvn -f pom.xml clean install -DskipTests";
        new CommandPrompt().executeCommand(command);
        log.info("FINISHED MAVEN Dependencies.Ready for Request!");
        return ResponseEntity.ok("OK");
    }

    @GetMapping("/status")
    public static ResponseEntity<?> setTestCaseStatus() {
        return new ResponseEntity<>(hashMap, HttpStatus.OK);
    }

    @PostMapping
    @ResponseStatus(HttpStatus.OK)
    public void returnResponse(@RequestBody CafuSampleTest cafuSampleTest) {
        cafuSampleTests.add(cafuSampleTest);
    }

    @GetMapping("/results")
    @ResponseBody
    public ResponseEntity<?> getResultsSummary() {
        log.info("Results API For Test Case Tag : " + testCaseTag);
        HashMap<String,Object> summaryResultsMap;
        try{
            if (hashMap.get("Status").equals("COMPLETED")) {
                summaryResultsMap = new ServiceLayer().readSummaryFile(reportDir, testCaseTag, reportUrl,testCaseResultsModel);
                log.info("Posting Results on Slack #automation-service-gitlab");
                postOnSlackChannel();
                return new ResponseEntity<>(summaryResultsMap, HttpStatus.OK);
            }
        }
        catch (Exception e){
            log.error("ERROR: Exception Occurred! Test Cases Might Not be Executed for that Tag -->" +testCaseTag);
            hashMap.put("Status","ERROR");
            hashMap.remove("ReportUrl");
            hashMap.put("Message","Error In Execution Check the Logs!");
            return new ResponseEntity<>(hashMap, HttpStatus.INTERNAL_SERVER_ERROR);
        }
        return new ResponseEntity<>(hashMap, HttpStatus.OK);
    }

    @PostMapping
    @RequestMapping(value = "/teams/share", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<HashMap<String, String>> postOnTeamsChannel() {
        String url = String.valueOf(testCaseRequestModel.getUrl());
        log.info("Teams Channel Url: " +url);
        try {
            new ServiceLayer().postResults(environment,url, testCaseTag,
                    getCurrentDateTime, reportUrl, hashMap.get("Status"),testCaseResultsModel);
            return new ResponseEntity<>(HttpStatus.ACCEPTED);
        } catch (Exception e) {
            log.warn("Are You Sure? You executed the Test Case & Trigger the Results API!" + e.getMessage());
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping
    @RequestMapping(value = "/slack/share", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<HashMap<String, String>> postOnSlackChannel() {
        log.info("Slack Channel Url: " + testCaseRequestModel.getUrl());
        try {
            new ServiceLayer().postResults(environment,testCaseRequestModel.getUrl(), testCaseTag,
                    getCurrentDateTime, reportUrl, hashMap.get("Status"),testCaseResultsModel);
            return new ResponseEntity<>(HttpStatus.ACCEPTED);
        } catch (Exception e) {
            log.warn("Are You Sure? You executed the Test Case & Trigger the Results API!" + e.getMessage());
            hashMap.remove("ReportUrl");
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
