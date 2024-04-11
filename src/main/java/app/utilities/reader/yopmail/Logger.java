package app.utilities.reader.yopmail;

public class Logger {

    private final boolean verbose;

    Logger(boolean verbose){
        this.verbose = verbose;
    }

    public void print(String message){
        if(this.verbose){
            System.out.println(message);
        }
    }
}
