
import java.io.*;

import static java.lang.ProcessBuilder.Redirect;

public class SplitJob {

	private static final BufferedReader in = new BufferedReader(new InputStreamReader(System.in));


	public static void main(String[] args) {

		final Runtime runtime = Runtime.getRuntime();
		int numThreads = runtime.availableProcessors();
		Process[] procs = new Process[numThreads];

		try {
		
			ProcessBuilder builder = new ProcessBuilder(args);
			builder.redirectError(Redirect.INHERIT);
		
			for (int i = 0; i < numThreads; i++) {
				procs[i] = builder.start();
			}
		
			for (int i = 0; ; i = (i + 1) % numThreads) {
	
				String s = in.readLine();

				if (s == null)
					break;

				byte[] data = (s + '\n').getBytes();
				procs[i].getOutputStream().write(data, 0, data.length);
				procs[i].getOutputStream().flush();
			}
		
			for (Process proc : procs) {
			
				proc.getOutputStream().close();
				int exitCode = proc.waitFor();
				
				if (exitCode != 0) {
					System.err.printf("[Error] %s stopped with exit code: %d\n", args[0], exitCode);
					System.exit(2);
				}
			}
			
		} catch (Exception e) {
			System.err.printf("[Error] %s: %s\n", e.getClass().getName(), e.getMessage());
			System.exit(1);
		}
	}
}
