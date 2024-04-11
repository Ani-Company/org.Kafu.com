package app.restController;


public class TestCaseResultsModel {

    private Integer Passed;
    private Integer Compromised;
    private Integer Failedwitherrors;
    private Integer Failed;
    private Integer Skipped;
    private Integer PassedPercentage;
    private Integer Pending;
    private Integer Ignored;

    public Integer getPassed(){
        return Passed;
    }
    public void setPassed(Integer Passed){
        this.Passed = Passed;
    }

    public Integer getCompromised(){
        return Compromised;
    }
    public void setCompromised(Integer Compromised){
        this.Compromised = Compromised;
    }
    public Integer getFailedwitherrors(){
        return Failedwitherrors;
    }

    public void setFailedwitherrors(Integer Failedwitherrors){
        this.Failedwitherrors = Failedwitherrors;
    }
    public Integer getFailed(){
        return Failed;
    }
    public void setFailed(Integer Failed){
        this.Failed = Failed;
    }
    public Integer getSkipped(){
        return Skipped;
    }
    public void setSkipped(Integer Skipped){
        this.Skipped = Skipped;
    }
    public Integer getPassedPercentage(){
        return PassedPercentage;
    }
    public void setPassedPercentage(Integer PassedPercentage){
        this.PassedPercentage = PassedPercentage;
    }
    public Integer getPending(){
        return Pending;
    }
    public void setPending(Integer Pending){
        this.Pending = Pending;
    }
    public Integer getIgnored(){
        return Ignored;
    }
    public void setIgnored(Integer Ignored){
        this.Ignored = Ignored;
    }
}
