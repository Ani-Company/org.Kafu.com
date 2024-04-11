package app.utilities;

import com.amazonaws.auth.AWSCredentialsProvider;
import com.amazonaws.auth.BasicSessionCredentials;
import com.amazonaws.auth.profile.ProfileCredentialsProvider;
import com.amazonaws.auth.profile.ProfilesConfigFile;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.model.Bucket;
import com.amazonaws.services.s3.transfer.MultipleFileUpload;
import com.amazonaws.services.s3.transfer.TransferManager;
import com.amazonaws.services.s3.transfer.TransferManagerBuilder;
import com.amazonaws.services.securitytoken.AWSSecurityTokenServiceClient;
import com.amazonaws.services.securitytoken.model.AssumeRoleRequest;
import com.amazonaws.services.securitytoken.model.AssumeRoleResult;
import com.amazonaws.services.sqs.AmazonSQS;
import com.amazonaws.services.sqs.AmazonSQSClientBuilder;
import com.amazonaws.services.sqs.model.Message;
import com.amazonaws.services.sqs.model.ReceiveMessageRequest;
import com.amazonaws.services.sqs.model.SendMessageRequest;

import java.io.File;
import java.util.List;
import java.util.logging.Logger;

public class AwsHelper {
    private static AmazonS3 s3;
    private final static String ROLE_ARN = PropertiesManager.getProperty("AWS_ROLE_ARN", PropertiesManager.prefix.NONE);
    private final static String SESSION_NAME = "test";
    private static final String bucketName = PropertiesManager.getProperty("AWS_BUCKET_NAME", PropertiesManager.prefix.NONE);
    private static final String profileName = PropertiesManager.getProperty("AWS_PROFILE_NAME", PropertiesManager.prefix.NONE);
    private static final String sqs_iot_url = PropertiesManager.getProperty("AWS_SQS_IOT_URL", PropertiesManager.prefix.NONE);
    static Logger log = Logger.getLogger(AwsHelper.class.getName());
    private static void init() {

        File configFile = new File(System.getProperty("user.home"), ".aws/credentials");

        AWSCredentialsProvider credentialsProvider = new ProfileCredentialsProvider(
                new ProfilesConfigFile(configFile), profileName);

        if (credentialsProvider.getCredentials() == null) {
            throw new RuntimeException("No AWS security credentials found");
        }

        AWSSecurityTokenServiceClient stsClient = new AWSSecurityTokenServiceClient(credentialsProvider.getCredentials());
        AssumeRoleRequest assumeRequest = new AssumeRoleRequest()
                .withRoleArn(ROLE_ARN)
                .withDurationSeconds(3600)
                .withRoleSessionName(SESSION_NAME);
        System.out.println(assumeRequest);
        AssumeRoleResult assumeResult = stsClient.assumeRole(assumeRequest);

        BasicSessionCredentials temporaryCredentials
                = new BasicSessionCredentials(
                assumeResult.getCredentials().getAccessKeyId(),
                assumeResult.getCredentials().getSecretAccessKey(),
                assumeResult.getCredentials().getSessionToken());

        s3 = new AmazonS3Client(temporaryCredentials);
    }
    private static void listBuckets() {
        List<Bucket> buckets = s3.listBuckets();
        log.info("You have " + buckets.size() + "Amazon S3 bucket(s).");
        if (buckets.size() > 0) {
            for (Bucket bucket : buckets) {
                log.info(bucket.getName());
            }
        }
    }

    public static void writeToBucket(String folderPath) {
        init();
        //listBuckets();
        File file = new File(folderPath);
        log.info("File Path : " + file.getPath() + " Name : "+ file.getName());
        if (file.exists()) {
            TransferManager tm = TransferManagerBuilder.standard().withS3Client(s3).build();
            try {
                MultipleFileUpload uploadDirectory = tm.uploadDirectory(bucketName, file.getName(), file, true);
                uploadDirectory.waitForCompletion();
                log.info("Total Percentage Transferred: "  + uploadDirectory.getProgress().getPercentTransferred());
            } catch (Exception e) {
                log.info(e.getMessage());
            }
            tm.shutdownNow();
        }
    }
    private static void sqsPublish(){
        AmazonSQS sqs = AmazonSQSClientBuilder.standard().withRegion(Regions.CA_CENTRAL_1).build();
        String messageBody = "\"{\"\"ts\"\": \"\"1671181443\"\", \"\"lat\"\": \"\"45.7802\"\", \"\"lon\"\": \"\"-74.0416\"\", \"\"spd\"\": \"\"0.09\"\", \"\"temp\"\": 33, \"\"x_ts\"\": 1671181438, \"\"y_ts\"\": 1671181438, \"\"z_ts\"\": 1671181438, \"\"state\"\": \"\"STATE_STOP_DC_CHARGE\"\", \"\"bms_id\"\": 0, \"\"dbc_ver\"\": 0, \"\"gps_fix\"\": \"\"12\"\", \"\"temp_ts\"\": 1671181440, \"\"x_accel\"\": 0.01, \"\"y_accel\"\": -0.5, \"\"z_accel\"\": -0.04, \"\"bytes_rx\"\": \"\"90199\"\", \"\"bytes_tx\"\": \"\"646624\"\", \"\"pack_soc\"\": 0, \"\"truck_id\"\": \"\"CAFUTRON_CANADA_02\"\", \"\"bms_state\"\": \"\"STATE_STOP_DC_CHARGE\"\", \"\"device_id\"\": \"\"Y121KWA0084\"\", \"\"pack_volt\"\": 0, \"\"stack_amp\"\": 0, \"\"stack_cap\"\": 228, \"\"stack_soc\"\": 0, \"\"tenant_id\"\": \"\"2\"\", \"\"ts_gps_rd\"\": \"\"1671181441\"\", \"\"fw_maj_rev\"\": 1, \"\"fw_min_rev\"\": 2, \"\"stack_temp\"\": 0, \"\"stack_volt\"\": 0, \"\"fault_array\"\": \"\"010101010101010101010\"\", \"\"fw_patch_ver\"\": 3, \"\"gps_datetime\"\": \"\"2022-12-16 09:03:59\"\", \"\"pack_current\"\": 0, \"\"stack_energy\"\": 140.9, \"\"cell_ave_volt\"\": 0, \"\"cell_max_volt\"\": 0, \"\"cell_min_volt\"\": 0, \"\"pack_temp_avg\"\": 0, \"\"pack_temp_max\"\": 0, \"\"pack_temp_min\"\": 0, \"\"stack_max_temp\"\": 0, \"\"stack_min_temp\"\": 0, \"\"cell_max_volt_sn\"\": 0, \"\"cell_min_volt_sn\"\": 0, \"\"pack_temp_max_sn\"\": 0, \"\"pack_temp_min_sn\"\": 0, \"\"pack_rated_energy\"\": 140.9, \"\"stack_max_temp_sn\"\": 0, \"\"stack_min_temp_sn\"\": 0, \"\"pack_cell_volt_avg\"\": 0, \"\"pack_cell_volt_max\"\": 0, \"\"pack_cell_volt_min\"\": 0, \"\"pack_rated_capacity\"\": 228, \"\"pack_cell_volt_max_sn\"\": 0, \"\"pack_cell_volt_min_sn\"\": 0}\"\n";
        SendMessageRequest sendMessageRequest = new SendMessageRequest(sqs_iot_url, messageBody);
        sqs.sendMessage(sendMessageRequest);
        //verifyMessage(queueUrl,sqs);
        sqs.shutdown();
    }

    private static void verifyMessage(String queueUrl,AmazonSQS sqs){
        ReceiveMessageRequest receiveMessageRequest = new ReceiveMessageRequest(queueUrl);
        List<Message> messages = sqs.receiveMessage(receiveMessageRequest).getMessages();
        for (Message message : messages) {
            log.info("Message Body: " + message.getBody());
            if (message.getBody().equals("Hello, SQS!")) {
                log.info("Success: Message was published and received successfully.");
            } else {
                log.info("Failure: Unexpected message content.");
            }
        }
    }
    /*public static void main(String args[]) {
       // listBuckets();
        sqsPublish();
        //writeToBucket("/tmp/report_2023.02.02.16.01.10/");
        System.exit(0);
    }*/
}