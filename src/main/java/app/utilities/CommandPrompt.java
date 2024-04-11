package app.utilities;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.concurrent.TimeUnit;

public class CommandPrompt {
    public void executeCommand(String command){
        Process p = null;
        try {
            p = Runtime.getRuntime().exec(command);
        } catch (IOException e) {
            System.err.println("Error on exec() method");
            e.printStackTrace();
        }

        try {
            assert p != null;
            copy(p.getInputStream(), System.out);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        try {
            p.waitFor();
            p.waitFor(60, TimeUnit.SECONDS);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
    }
    static void copy(InputStream in, OutputStream out) throws IOException {
        while (true) {
            int c = in.read();
            if (c == -1)
                break;
            out.write((char) c);
        }
    }

}
