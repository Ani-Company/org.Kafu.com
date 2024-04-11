package app.restController;

import app.utilities.CommandPrompt;
import app.utilities.PropertiesManager;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.web.client.RestTemplate;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.net.InetAddress;
import java.util.Arrays;
import java.util.HashMap;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import static app.utilities.CommonHelpers.readJsonFile;
import static app.utilities.CommonHelpers.replaceText;

public class ServiceLayer {

    static Logger log = LogManager.getLogger(ServiceLayer.class.getName());
    final String rp_uuid = PropertiesManager.getProperty("RP_UUID", PropertiesManager.prefix.NONE);
    public HashMap<String, Object> readSummaryFile(String filePath, String tag,String reportUrl,TestCaseResultsModel testCaseResultsModel) {
        log.debug("Summary File Path :" +filePath+ "/" + "summary.txt" );
        BufferedReader reader;
        HashMap<String,Object> map = new HashMap<>();
        try {
            reader = new BufferedReader(new FileReader(filePath+ "/" + "summary.txt"));
            String line = reader.readLine();
            String[] keyValue;
            while (line != null) {
                line = line.replace(" ","");
                line = line.replaceAll("\\s|\\r|\\n","").trim();
                if(!(line.contains("Serenityreportgenerated") || line.contains("test"))) {
                    if(!line.isEmpty()) {
                        keyValue = line.split(":");
                        map.put(keyValue[0], Integer.valueOf((keyValue[1])));
                    }
                }
                line = reader.readLine();
            }
            reader.close();
            // Calculate Test Case Passed Percentage
            testCaseResultsModel.setPassed((Integer) map.get("Passed"));
            testCaseResultsModel.setCompromised((Integer) map.get("Compromised"));
            testCaseResultsModel.setFailedwitherrors((Integer) map.get("Failedwitherrors"));
            testCaseResultsModel.setFailed((Integer) map.get("Failed"));
            testCaseResultsModel.setSkipped((Integer) map.get("Skipped"));
            testCaseResultsModel.setPending((Integer) map.get("Pending") );
            testCaseResultsModel.setIgnored((Integer) map.get("Ignored") );

            int total = testCaseResultsModel.getPassed() + testCaseResultsModel.getCompromised() + testCaseResultsModel.getFailedwitherrors()
                    + testCaseResultsModel.getFailed() + testCaseResultsModel.getSkipped() + testCaseResultsModel.getPending()
                    + testCaseResultsModel.getIgnored();

            Integer getPassPercentage = calculatePercentage(testCaseResultsModel.getPassed(),total);
            testCaseResultsModel.setPassedPercentage(getPassPercentage);
            map.put("PassedPercentage",getPassPercentage);
            map.put("tag", tag);
            map.put("ReportUrl",reportUrl);
            log.info("OK: PassedPercentage : " +testCaseResultsModel.getPassedPercentage());
            return map;
        } catch (IOException e) {
            log.error("ERROR: Please Check the readSummaryFile() " +  e.getMessage());
            map.clear();
            map.put("Try again Once Test Case Is COMPLETED by Status API:",1.0);
            return map;
        }
    }
    public static Integer calculatePercentage(int obtained, int total) {
        return obtained * 100 / total;
    }

    public boolean runMavenCommand(String path, String reportDir, String environment){
        String command = null;
        log.info("Requested Feature/Tag Testing : "+path);
        try {
            if (path.contains("@")) {
                command = "/usr/share/maven/bin/mvn -f /usr/src/app/pom.xml verify " + "-Dserenity.outputDirectory=" + reportDir + " -Dtags=" +path
                        + " -Denvironment="+environment + " -Drp.launch="+environment.toUpperCase()+"_"+path + " -Drp.uuid=" + rp_uuid;
       //         command = "/opt/apache-maven-3.8.6/bin/mvn -f pom.xml verify "+"-Dserenity.outputDirectory=" + reportDir +" -Dtags=" +path+ " -Denvironment="+environment;
      //                  + " -Drp.launch="+environment.toUpperCase()+"_"+path + " -Drp.uuid=" + rp_uuid;
            }
            if (path != null) {
                log.info("Final Command: " + command);
                new CommandPrompt().executeCommand(command);
            }
        }
        catch (Exception e){
            log.error("ERROR! Some Exception Occurred : "+ Arrays.toString(e.getStackTrace()));
            return false;
        }
        return true;
    }

    private String readTeamsPost(String tag,String executionStartTime,String reportUrl,String tcStatus,TestCaseResultsModel testCaseResultsModel){
        try {
            String computerName = InetAddress.getLocalHost().getHostName();
            String body;
            if(!tcStatus.equals("In Process")) {
                body = readJsonFile("FRAMEWORK/teams_channel/teams.json");
                body = replaceText(body, "Status", tcStatus);
                body = replaceText(body, "host", computerName);
                body = replaceText(body, "execution_start_time", executionStartTime);
                body = replaceText(body, "report_url", reportUrl);
                body = replaceText(body, "Passed", String.valueOf(testCaseResultsModel.getPassed()));
                body = replaceText(body, "Compromised", String.valueOf(testCaseResultsModel.getCompromised()));
                body = replaceText(body, "Failedwitherrors", String.valueOf(testCaseResultsModel.getFailedwitherrors()));
                body = replaceText(body, "Failed", String.valueOf(testCaseResultsModel.getFailed()));
                body = replaceText(body, "Skipped", String.valueOf(testCaseResultsModel.getSkipped()));
                body = replaceText(body, "PassedPercentage", String.valueOf(testCaseResultsModel.getPassedPercentage()));
                body = replaceText(body, "tag", tag);
                body = replaceText(body, "Pending", String.valueOf(testCaseResultsModel.getPending()));
                body = replaceText(body, "Ignored", String.valueOf(testCaseResultsModel.getIgnored()));
                return body;
            }
            else {
                throw new RuntimeException();
            }
        } catch (IOException e) {
            log.error("Some of the Value Could be null!" +e.getMessage());
            throw new RuntimeException(e);
        }
    }
    public void postResults(String env,String url,String tag,String getCurrentDateTime,String reportUrl,String tcStatus,TestCaseResultsModel testCaseResults){
        RestTemplate restTemplate = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        String body = new slackIntegration().postOnSlack(env,tag,getCurrentDateTime,reportUrl,tcStatus,testCaseResults);
        restTemplate.postForEntity(url,body,String.class);
    }
}
