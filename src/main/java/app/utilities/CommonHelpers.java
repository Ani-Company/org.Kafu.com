package app.utilities;

import org.apache.commons.lang3.RandomStringUtils;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.*;

public class CommonHelpers {
    private final static String inputJsonFilePath = File.separator + "com" + File.separator + "api" + File.separator + "squads" + File.separator;
    private final static String tempFilePath = "/tmp/execution.txt";

    public static String generateUUID() {
        UUID uuid = UUID.randomUUID();
        String uuidAsString = uuid.toString();
        System.out.println(uuidAsString);
        return uuidAsString;
    }

    public static int generateRandomInteger() {
        // Generate 6 digit random integers
        //return rand.nextInt(999999);
        return generateRandomInteger(6);
    }

    public static int generateRandomInteger(int size) {
        Random rand = new Random();
        // Generate 4 digit random integers
        //return rand.nextInt(9999);
        return Integer.parseInt(RandomStringUtils.random(size, false, true));
    }

    public static FileReader getJsonFilePath(String fileNameWithDirectory)
            throws IOException {
        Path resourceDirectory = Paths.get("src", "test", "resources");
        String absolutePath = resourceDirectory.toFile().getAbsolutePath();
        System.out.println(absolutePath);

        Path path = Paths.get(absolutePath + inputJsonFilePath + fileNameWithDirectory);
        FileReader fileReader = new FileReader(path.toFile());

        return fileReader;
    }

    public static String readJsonFile(String fileNameWithDirectory)
            throws IOException {
        Path resourceDirectory = Paths.get("src", "test", "resources");
        String absolutePath = resourceDirectory.toFile().getAbsolutePath();
        System.out.println(absolutePath);

        Path path = Paths.get(absolutePath + inputJsonFilePath + fileNameWithDirectory);
        BufferedReader reader = Files.newBufferedReader(path);
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line);
            sb.append("\n");
        }
        reader.close();
        return sb.toString();
    }

    public static String replaceText(String inputContents, String sourceToBeReplace, String targetToBeReplaced) {
        inputContents = inputContents.replace("{" + sourceToBeReplace + "}", targetToBeReplaced);
        return inputContents;
    }

    public static String getCurrentDateTime(String dateFormat) {
        Date date = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat(dateFormat);
        sdf.setTimeZone(TimeZone.getTimeZone(PropertiesManager.getProperty("Time_Zone", PropertiesManager.prefix.NONE)));
        return sdf.format(date);
    }

    public static String getFutureDateTime(String dateFormat, int daysToAdd) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern(dateFormat);
        // Get the current date
        LocalDate currentDate = LocalDate.now();
        LocalDate futureDate = currentDate.plusDays(daysToAdd);
        return futureDate.format(formatter);

    }

    public static long getNrOfDaysBetweenTwoDates(String startDate, String endDate, String dateFormat) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern(dateFormat);
        LocalDate date_1 = LocalDate.parse(startDate, formatter);
        LocalDate date_2 = LocalDate.parse(endDate, formatter);
        long daysBetween = ChronoUnit.DAYS.between(date_1, date_2);
        return daysBetween;

    }

    public static String getCurrentDateTimeWithSDF(String seconds) {
        int getSecond = Integer.parseInt(seconds);
        String dateFormat = "yyyy-MM-dd'T'HH:mm:ss";
        SimpleDateFormat sdf = new SimpleDateFormat(dateFormat);
        TimeZone time_zone = TimeZone.getTimeZone(PropertiesManager.getProperty("Time_Zone", PropertiesManager.prefix.NONE));
        sdf.setTimeZone(time_zone);
        Calendar calendar = Calendar.getInstance(time_zone);
//        sdf.setTimeZone(calendar.getTimeZone());
        calendar.set(Calendar.SECOND, (calendar.get(Calendar.SECOND) + getSecond));
        String getFinalDate = sdf.format(calendar.getTime());
        return getFinalDate + "Z";
    }

    public static void writeFile(Map<String, String> hm) {
        try {
            FileWriter myWriter = new FileWriter(tempFilePath);
            for (String s : hm.keySet()
            ) {
                myWriter.write(s);
                myWriter.write(":");
                myWriter.write(hm.get(s));
                myWriter.write(",");
            }
            myWriter.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static String readFile() {
        BufferedReader reader;
        String setPropertiesEnv = "dev";
        try {
            reader = new BufferedReader(new FileReader(tempFilePath));
            String line = reader.readLine();
            String[] getEnv;
            System.out.println(line);
            getEnv = line.split(",");
            for (int i = 0; i <= getEnv.length; i++) {
                if (getEnv[i].contains("Environment")) {
                    getEnv = getEnv[1].split(":");
                    System.out.println(getEnv[1]);
                    setPropertiesEnv = getEnv[1];
                    break;
                }
            }
            reader.close();
        } catch (IOException e) {
            //e.printStackTrace();
            return setPropertiesEnv;
        }
        return setPropertiesEnv;
    }
}
