package app.utilities;


import net.serenitybdd.core.environment.EnvironmentSpecificConfiguration;
import net.thucydides.core.guice.Injectors;
import net.thucydides.core.util.EnvironmentVariables;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Properties;
import java.util.logging.Logger;

import static app.utilities.CommonHelpers.readFile;

public class PropertiesManager {
    public enum prefix{ENVIRONMENT,NONE}

    private static String envPrefix = "";
    private static Properties prop = null;
    static Logger log = Logger.getLogger(PropertiesManager.class.getName());
    private static String setPropertiesEnv = null;
    public static void createInstance(){
        setPropertiesEnv = readFile();
        prop = new Properties();
        String fileName = System.getProperty("propertiesFile","./src/test/resources/config_"+setPropertiesEnv+".properties").trim();
        InputStream input;
        try {
            //input = ClassLoader.getSystemClassLoader().getResourceAsStream(fileName);
            input = Files.newInputStream(Paths.get(fileName));
            prop.load(input);
            envPrefix = prop.getProperty("executionEnv");

        } catch (IOException io) {
            io.printStackTrace();
        }
    }

    public static HashMap getBffURL(){
        HashMap hm = new HashMap();
        hm.put("BFF_URL",null);
        hm.put("ACCESS_TOKEN",null);
        try{
            String customer_bff_enabled = PropertiesManager.getProperty("CUSTOMER_BFF_ENABLED", prefix.NONE);
            String pilot_bff_enabled = PropertiesManager.getProperty("PILOT_BFF_ENABLED", prefix.NONE);
            String internal_bff_enabled=PropertiesManager.getProperty("INTERNAL_BFF_ENABLED", prefix.NONE);
            if(customer_bff_enabled.equalsIgnoreCase("true")){
                hm.put("BFF_URL",getUrlFromProperty("CUSTOMER-BFF"));
                hm.put("ACCESS_TOKEN",PropertiesManager.getProperty("CUSTOMER_BFF_TOKEN",
                        prefix.ENVIRONMENT));
                return hm;
            }
            if(pilot_bff_enabled.equalsIgnoreCase("true")){
                hm.put("BFF_URL",getUrlFromProperty("PILOT-BFF"));
                hm.put("ACCESS_TOKEN",PropertiesManager.getProperty("PILOT_BFF_TOKEN",
                        prefix.ENVIRONMENT));
                return hm;
            }
            if(internal_bff_enabled.equalsIgnoreCase("true")){
                hm.put("BFF_URL",getUrlFromProperty("INTERNAL-BFF"));
                hm.put("ACCESS_TOKEN",PropertiesManager.getProperty("INTERNAL_BFF_TOKEN",
                        prefix.ENVIRONMENT));
                return hm;
            }
        }
        catch (Exception e){
            log.info("Missing Property : CUSTOMER_BFF_ENABLED, PILOT_BFF_ENABLED or INTERNAL_BFF_ENABLED in the Config.Properties file");
            return null;
        }
        return null;
    }

    public static String getUrlFromProperty(String ServiceName){
        EnvironmentVariables environmentVariables = Injectors.getInjector()
                .getInstance(EnvironmentVariables.class);
        return EnvironmentSpecificConfiguration.from(environmentVariables)
                .getProperty("BASEURL_"+ServiceName);
    }
    public static String getProperty(String propertyName){
        return getProperty(propertyName, prefix.ENVIRONMENT);
    }
    public static String getProperty(String propertyName,prefix _prefix){
        String toReturn = null;
        if(prop == null){
            createInstance();
        }
       switch (_prefix) {
                case ENVIRONMENT:
                    log.info("Property : " + prop.getProperty(envPrefix + "_" + propertyName));
                    toReturn = prop.getProperty(envPrefix + "_" + propertyName);
                    break;

                case NONE:
                    toReturn = prop.getProperty(propertyName);
                    break;
            }
        return toReturn;
    }
}
