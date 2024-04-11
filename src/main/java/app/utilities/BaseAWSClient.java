package app.utilities;

import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicSessionCredentials;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.transfer.MultipleFileUpload;
import com.amazonaws.services.s3.transfer.TransferManager;
import com.amazonaws.services.s3.transfer.TransferManagerBuilder;
import com.amazonaws.services.securitytoken.AWSSecurityTokenService;
import com.amazonaws.services.securitytoken.AWSSecurityTokenServiceClientBuilder;
import com.amazonaws.services.securitytoken.model.AssumeRoleRequest;
import com.amazonaws.services.securitytoken.model.Credentials;

import java.io.File;
import java.util.logging.Logger;

public class BaseAWSClient {
    private static AmazonS3 s3Client;
    private final static String ROLE_ARN = System.getenv("AWS_ROLE_ARN");
    private final static String SESSION_NAME = "test";
    private static final String bucketName = PropertiesManager.getProperty("AWS_BUCKET_NAME", PropertiesManager.prefix.NONE);
    static Logger log = Logger.getLogger(BaseAWSClient.class.getName());
    protected static AmazonS3 getS3Client(){
        log.info("ROLE_ARN : " + ROLE_ARN);
        final Regions awsRegion = Regions.CA_CENTRAL_1;
        BasicSessionCredentials sessionCredentials;
        if (s3Client == null){
            log.info("Creating New S3 Connection");
            s3Client = AmazonS3ClientBuilder.standard().withRegion(awsRegion).build();
            /*final AssumeRoleRequest assumeRole = new AssumeRoleRequest().withRoleArn(ROLE_ARN).withRoleSessionName(SESSION_NAME);
            final AWSSecurityTokenService sts = AWSSecurityTokenServiceClientBuilder.standard().withRegion(awsRegion).build();
            final Credentials credentials = sts.assumeRole(assumeRole).getCredentials();
            sessionCredentials = new BasicSessionCredentials(
                    credentials.getAccessKeyId(),
                    credentials.getSecretAccessKey(),
                    credentials.getSessionToken()
            );
            s3Client = AmazonS3ClientBuilder.standard().withRegion(awsRegion).withCredentials(new AWSStaticCredentialsProvider(sessionCredentials)).build();
            */
        }
        return s3Client;
    }
    public static void uploadFilesToS3(String folderPath) {
        s3Client = getS3Client();
        log.info("Get Region: " + s3Client.getRegionName());
        if(s3Client!=null) {
            log.info("Starting File Transfer to S3!" + bucketName);
            File file = new File(folderPath);
            log.info("File Path : " + file.getPath() + " Name : " + file.getName());
            if (file.exists()) {
                TransferManager tm = TransferManagerBuilder.standard().withS3Client(s3Client).build();
                try {
                    MultipleFileUpload uploadDirectory = tm.uploadDirectory(bucketName, file.getName(), file, true);
                    uploadDirectory.waitForCompletion();
                    log.info("Total Percentage Transferred: " + uploadDirectory.getProgress().getPercentTransferred());
                } catch (Exception e) {
                    log.info(e.getMessage());
                }
            }
        }
    }
}
