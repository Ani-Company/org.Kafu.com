package app.restController;

public class TestCaseRequestModel {
    private String tag;
    private String env;
    private boolean report;
    private String url;

    TestCaseRequestModel(){

    }
    public String getTag(){
        return tag;
    }

    public void setTag(String tag){
        this.tag = tag;
    }

    public boolean getReport(){
        return report;
    }

    public void setReport(boolean report){
        this.report = report;
    }

    public String getEnvironment(){
        return env;
    }

    public void setEnvironment(String env){
        this.env = env;
    }
    public String getUrl(){
        return url;
    }
    public void setUrl(String url){
        this.url = url;
    }
}
