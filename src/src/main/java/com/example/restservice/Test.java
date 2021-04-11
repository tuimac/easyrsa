import java.io.*;
import java.nio.charset.Charset;

public class Test {
    public static void main(String[] args) throws InterruptedException, IOException {
        Runtime run = Runtime.getRuntime();
        Process p = run.exec("./test.sh");
        p.waitFor();
        System.out.println("Hello world!");
        int result = p.exitValue();
        System.out.println(result);
    }    
}
