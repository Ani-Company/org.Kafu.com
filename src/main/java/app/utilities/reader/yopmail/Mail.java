package app.utilities.reader.yopmail;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

public class Mail {

    private String subject;
    private String sender;
    private String time;

    private String emailBody;

    private Map<String, String> linksInPage;

    private String error;

    public Mail(){
        this.linksInPage = new LinkedHashMap<>();
    }
    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getSender() {
        return sender;
    }

    public void setSender(String sender) {
        this.sender = sender;
    }

    public String getTime() {
        return time;
    }

    public Map<String, String> getLinksInPage() {
        return linksInPage;
    }


    public void setTime(String time) {
        this.time = time;
    }

    public String getEmailBody() {
        return emailBody;
    }

    public void setEmailBody(String emailBody) {
        this.emailBody = emailBody;
    }

    public void setLinksInPage(Map<String, String> linksInPage) {
        this.linksInPage = linksInPage;
    }

    public void addLink(String name, String url){
        this.linksInPage.put(name, url);
    }

    public String getError() {
        return error;
    }

    public void setError(String error) {
        this.error = error;
    }

    @Override
    public String toString() {
        return "Mail{" +
                "subject='" + subject + '\'' +
                ", sender='" + sender + '\'' +
                ", time='" + time + '\'' +
                ", emailBody='" + emailBody + '\'' +
                ", linksInPage=" + linksInPage +
                ", error='" + error + '\'' +
                '}';
    }


}
