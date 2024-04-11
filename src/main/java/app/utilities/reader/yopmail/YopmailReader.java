package app.utilities.reader.yopmail;

import org.jsoup.Connection;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;

import java.io.IOException;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

enum TypeOfEmailBody{
    TEXT,
    HTML
}
public class YopmailReader {

    private String userId;
    private String yp;

    private String yj;

    private List<String> extractedInboxEmailCodes;
    private final Map<String, String> cookies;

    private final Map<String, String> headers;

    private final Logger logger;

    private static final Map<String, YopmailReader> YopmailReaderObjectRepository = new HashMap<>();

    private final Map<String, String> urls = new HashMap<String, String>(){{
        put("homepageURL", "http://www.yopmail.com");
        put("ypExtractionPageURL", "http://www.yopmail.com/en/");
        put("userCookiesPageURL", "http://www.yopmail.com/en/");
        put("jScriptPageURL", "https://yopmail.com/ver/8.4/webmail.js");
        put("yopmailInboxPageURL", "https://yopmail.com/inbox");
        put("emailDataURL", "https://yopmail.com/mail");
    }};

    private YopmailReader(String user_id) throws Exception {
        this(user_id, false);
    }

    private YopmailReader(String user_id, boolean verbose) throws Exception {
        this.cookies = new HashMap<>();
        this.userId = user_id;
        this.headers = new HashMap<String, String>(){{
            put("Accept", "text/html,application/xhtml+xml,application/xml;" +
                    "q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;" +
                    "v=b3;" +
                    "q=0.7");
        }};
        this.logger = new Logger(verbose);

        login();
    }

    public static YopmailReader getInstance(String userId, boolean verbose) throws Exception {
        if(YopmailReaderObjectRepository.containsKey(userId))
            return YopmailReaderObjectRepository.get(userId);
        else{
            YopmailReader yReader = new YopmailReader(userId, verbose);
            YopmailReaderObjectRepository.put(userId, yReader);
        }
        return YopmailReaderObjectRepository.get(userId);
    }

    public void setUserId(String userId){
        this.userId = userId;
    }
    private void requestYopmailHomepage() throws IOException {
        RequestHelper.sendGetRequest(urls.get("homepageURL"), this.cookies, this.headers, logger);
    }
    private void extract_yp(Connection.Response response){
            Document doc = Jsoup.parse(response.body());
            this.yp = doc.selectXpath("//input[@name='yp' and @id='yp']").attr("value");
    }

    private void requestToExtractYP() throws IOException {
        extract_yp(
                RequestHelper.sendGetRequest(urls.get("ypExtractionPageURL"), this.cookies, this.headers, logger)
        );
    }

    private void requestToFetchCookiesForThisUser() throws IOException {
        String requestBody = String.format("{\"yp\" : \"%s\", \"login\": \"%s\"}", this.yp, this.userId);
        RequestHelper.sendPostRequest(urls.get("userCookiesPageURL"), requestBody, this.cookies, this.headers, logger);
    }

    private void extract_yj(Connection.Response response) throws Exception {
        String regex = "'&yj=([0-9a-zA-Z]*)&v='";
        Matcher matcher = Pattern.compile(regex).matcher(response.body());
        if(!matcher.find())
            throw new Exception("yj couldn't be extracted from script !");
        this.yj = matcher.group(1);
        logger.print("extracted yj - " + this.yj);
    }

    private void requestToWebmailJScriptToExtractYJ() throws Exception {
        extract_yj(
                RequestHelper.sendGetRequest(urls.get("jScriptPageURL"), this.cookies, this.headers, logger)
        );
    }

    private void extractInboxEmailCodes(Connection.Response response){
        Document doc = Jsoup.parse(response.body());
        List<String> inboxEmailCodes = new ArrayList<>();
        List<Element> inboxDivList = doc.selectXpath("//div[@class='m' and @id]");
        for(Element inboxDiv : inboxDivList){
            inboxEmailCodes.add(inboxDiv.attr("id"));
        }
        logger.print("Extracted email inbox ids - ");
        inboxEmailCodes.forEach(e->logger.print(e));
        this.extractedInboxEmailCodes = inboxEmailCodes;
    }

    private void requestToReadTheInbox() throws IOException {
        Map<String, String> params = new HashMap<String, String>(){{
            put("login", userId);
            put("p", "1");
            put("ctrl", "");
            put("yp", yp);
            put("yj", yj);
            put("v", "8.4");
            put("r_c", "");
            put("id", "");
            put("d", "");
        }};

        extractInboxEmailCodes(
                RequestHelper.sendGetRequest(urls.get("yopmailInboxPageURL"), params, this.cookies, this.headers, logger)
        );
    }

    private String fetchEmailData(String emailCode) throws IOException {
        Map<String, String> params = new HashMap<String, String>(){{
            put("b", userId);
            put("id", "m" + emailCode);
        }};

        return RequestHelper.sendGetRequest(urls.get("emailDataURL"), params, this.cookies, this.headers, logger).body();
    }

    public Mail prepareMailObjectFromResponse(String emailData, TypeOfEmailBody emailBodyType){
        Mail mail = new Mail();
        Document doc = Jsoup.parse(emailData);
        if(doc.selectXpath("//div[text() = 'Complete the CAPTCHA to continue']").size() > 0) {
            mail.setError("CAPTCHA encountered at Yopmail inbox ");
            return mail;
        }
        String subject = doc.selectXpath("//header/div[@class='fl']//div[contains(@class, 'ellipsis')]").text();
        String sender = doc.selectXpath("(//header/div[@class='fl']//span[contains(@class, 'ellipsis')])[1]").text();
        String time = doc.selectXpath("(//header/div[@class='fl']//span[contains(@class, 'ellipsis')])[2]").text();
        String emailBody = emailBodyType==TypeOfEmailBody.TEXT ?
                doc.selectXpath("//div[@id='mail']").text() : doc.selectXpath("//div[@id='mail']").html();
        mail.setSubject(subject);
        mail.setSender(sender);
        mail.setTime(time);
        mail.setEmailBody(emailBody);
        List<Element> links = doc.selectXpath("//div[@id='mail']//a");
        int counter = 0;
        for(Element link : links){
            String url = link.attr("href");
            String name = link.text();
            if(name.isEmpty())
                name = "link_" + ++counter;
            mail.addLink(name, url);
        }
        return mail;
    }

    private void login() throws Exception {
        requestYopmailHomepage();;
        requestToExtractYP();
        requestToFetchCookiesForThisUser();
        requestToWebmailJScriptToExtractYJ();
    }
    public List<Mail> getEmails(int countOfEmailsRequired, TypeOfEmailBody emailBodyType) throws Exception {
        logger.print(String.format("Getting emails for %s", this.userId));
        requestToReadTheInbox();
        List<Mail> emails = new ArrayList<>();
        countOfEmailsRequired = Math.min(this.extractedInboxEmailCodes.size(), countOfEmailsRequired);
        for(int counter = 0; counter < countOfEmailsRequired; counter++){
            String emailCode = this.extractedInboxEmailCodes.get(counter);
            logger.print("Reading email id#" + emailCode );
            try {
                String text = fetchEmailData(emailCode);
                emails.add(prepareMailObjectFromResponse(text, emailBodyType));
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }
        return emails;
    }

    public List<Mail> getEmails(int countOfEmailsRequired) throws Exception {
        return getEmails(countOfEmailsRequired, TypeOfEmailBody.TEXT);
    }

    public void tester() throws Exception {
        YopmailReader ypReader = YopmailReader.getInstance("b2bautomationuserauth", true);
        List<Mail> emails = ypReader.getEmails(10, TypeOfEmailBody.TEXT);
        emails.forEach(System.out::println);
    }
}
