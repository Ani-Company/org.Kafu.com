package app.utilities.reader.yopmail;

import org.jsoup.Connection;
import org.jsoup.Jsoup;

import java.io.IOException;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

public class RequestHelper {

    private static final List<String> userAgents = Arrays.asList(
            "Chrome/114.0.0.0",
            "Safari/537.36",
            "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko)",
            "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:47.0) Gecko/20100101 Firefox/47.0",
            "Opera/9.80 (Macintosh; Intel Mac OS X; U; en) Presto/2.2.15 Version/10.00",
            "Edg/91.0.864.59");

    private static String getRandomUserAgent(){
        Random rand = new Random();
        return userAgents.get(rand.nextInt(userAgents.size()));
    }

    private static String getTime(){
        return LocalTime.now().format(DateTimeFormatter.ofPattern("HH:mm"));
    }

    private static void addLocalTimeToCookies(Map<String, String> cookies){
        cookies.put("ytime", getTime());
    }
    public static Connection.Response sendGetRequest(String url, Map<String, String> params, Map<String, String> cookies, Map<String, String> headers, Logger logger) throws IOException {
        addLocalTimeToCookies(cookies);
        StringBuilder queryParamPath = new StringBuilder();
        params.forEach((k,v) -> {
            queryParamPath.append("&").append(k).append("=").append(v);
        });
        if(!queryParamPath.toString().isEmpty())
            url = url + "?" + queryParamPath.substring(1);
        String userAgent = getRandomUserAgent();
        Connection connection = Jsoup.connect(url)
                .userAgent(userAgent)
                .cookies(cookies)
                .headers(headers)
                .ignoreContentType(true);
        logger.print("url - " + url + "\nCookies - " + cookies + "\n" + "user-agent - " + userAgent + "\n" + "params - " + params);
        Connection.Response response = connection.execute();
        logger.print("Response Code - " + response.statusMessage());
        logger.print("Response Cookies - ");
        response.cookies().forEach((key, value) -> logger.print(key + " => " + value));
        logger.print(" ------------------------------------ ");
        cookies.putAll(response.cookies());
        return response;
    }

    public static Connection.Response sendGetRequest(String url, Map<String, String> cookies, Map<String, String> headers, Logger logger) throws IOException {
        return sendGetRequest(url, new HashMap<>(), cookies, headers, logger);
    }


    public static Connection.Response sendPostRequest(String url, String requestBody, Map<String, String> cookies, Map<String, String> headers, Logger logger) throws IOException {
        String userAgent = getRandomUserAgent();
        Connection.Response response = Jsoup.connect(url)
                .method(Connection.Method.POST)
                .cookies(cookies)
                .userAgent(userAgent)
                .requestBody(requestBody)
                .execute();
        logger.print("url - " + url + "\nCookies - " + cookies + "\n" + "user-agent - " + userAgent + "\n" + "data - " + requestBody);
        logger.print("Response Code - " + response.statusMessage());
        logger.print("Response Cookies - ");
        response.cookies().forEach((key, value) -> logger.print(key + " => " + value));
        logger.print(" ------------------------------------ ");
        cookies.putAll(response.cookies());
        return response;
    }
}
