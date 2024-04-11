

import io.cucumber.junit.CucumberOptions;
import net.serenitybdd.cucumber.CucumberWithSerenity;
import org.junit.runner.RunWith;

@RunWith(CucumberWithSerenity.class)
@CucumberOptions(
        plugin = {"pretty"},
       monochrome = true,
      //  dryRun = true,
        // features = "src/test/resources/com/api/squads/pilot_bff/features/test.feature",
                //"src/test/resources/com/api/squads/vehicleConnectivity/features/vehicleConnectivity.feature",
             //   "src/test/resources/com/api/squads/operationalAssets/features/operationalAssets.feature",
              //  "src/test/resources/com/api/squads/assets/features/assets.feature",
               // "src/test/resources/com/api/squads/addresses/features/pilot_bff.feature"
        //glue = , {"src/test/java/api/services/"}
        // tags = "@BDDTEST-PE-1221"
//      features = {"classpath:/com/api/squads/EV_CUSTOMER/UI/login.feature"}
//        features = {"classpath:/com/api/squads/Legacy_Fuel_Customer_UI/SanityTest.feature"}
        features = {"classpath:/com/api/squads/"}
)
public class CucumberTestSuite {
}
