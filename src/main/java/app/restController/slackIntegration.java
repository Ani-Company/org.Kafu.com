package app.restController;

import java.io.BufferedReader;
import java.io.IOException;
import java.net.InetAddress;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Locale;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import static app.utilities.CommonHelpers.readJsonFile;
import static app.utilities.CommonHelpers.replaceText;

public class slackIntegration {
    static Logger log = LogManager.getLogger(slackIntegration.class.getName());
    static final String slackProperties = "slack.properties";
    public String postOnSlack(String env,String tag,String executionStartTime,String reportUrl,String tcStatus,TestCaseResultsModel testCaseResultsModel){

        try {
            String computerName = InetAddress.getLocalHost().getHostName();
            String body;
            String serviceName = tag.replace("@","").replace("-2_0","");
            if(!tcStatus.equals("In Process")) {
                body = readJsonFile("FRAMEWORK/integrations/slack.json");
                if(env.equalsIgnoreCase("prod"))
                {
                    body = readJsonFile("FRAMEWORK/integrations/slack_prod.json");
                    body = replaceText(body, "copyTo", String.valueOf(readFile(slackProperties,"RM")));
                }
                body = replaceText(body, "env", env.toUpperCase(Locale.ROOT));
                body = replaceText(body, "tag", tag);
                body = replaceText(body, "serviceName", serviceName);
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
                body = replaceText(body, "Pending", String.valueOf(testCaseResultsModel.getPending()));
                body = replaceText(body, "Ignored", String.valueOf(testCaseResultsModel.getIgnored()));
                body = replaceText(body, "assignedTo", String.valueOf(readFile(slackProperties,serviceName)));
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

    public static StringBuffer readFile(String fileNameWithDirectory,String serviceName)
            throws IOException {
        Path resourceDirectory = Paths.get("src","test","resources");
        String absolutePath = resourceDirectory.toFile().getAbsolutePath();
        Path path = Paths.get(absolutePath + "/"  + fileNameWithDirectory);
        BufferedReader reader = Files.newBufferedReader(path);
        String line;
        String[] memberID;
        StringBuffer sb = new StringBuffer();
        String prefix = "";
        while((line=reader.readLine())!=null)
        {
            if(line.contains(serviceName.toUpperCase()+"_"))
            {
                sb.append(prefix);
                sb.append("<@");
                log.info("Looking Member Name & ID: <"+ line+ "> from file :" +
                        " <"+fileNameWithDirectory +"> for Service : " +serviceName);
                memberID = line.split("=");
                sb.append(memberID[1]);
                sb.append(">");
                prefix = ",";
            }
        }
        reader.close();
        return sb;
    }
}