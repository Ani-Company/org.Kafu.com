package api.commontasks;


import io.appium.java_client.TouchAction;
import io.appium.java_client.android.AndroidDriver;
import io.appium.java_client.android.AndroidElement;
import io.appium.java_client.touch.offset.PointOption;
import net.serenitybdd.core.pages.WebElementFacade;
import net.thucydides.core.webdriver.WebDriverFacade;
import org.junit.Assert;
import org.openqa.selenium.Dimension;
import org.openqa.selenium.Keys;
import org.openqa.selenium.Point;
import org.openqa.selenium.interactions.Actions;


import java.time.Duration;
import java.time.temporal.ChronoUnit;

import static net.serenitybdd.core.Serenity.getDriver;

public class MobileCommonSteps {

    AndroidDriver<AndroidElement> androidDriver() {
        return (AndroidDriver<AndroidElement>)
                ((WebDriverFacade) getDriver()).getProxiedDriver();
    }
    public void waitUntilPageAppear (WebElementFacade pageLayout){
        pageLayout.withTimeoutOf(Duration.of(30, ChronoUnit.SECONDS))
                .waitUntilVisible(); }

    public void inputString(String text, WebElementFacade element) throws InterruptedException {
        element.click();
        new Actions(androidDriver()).sendKeys(text).perform();
    }
    public void clickElement( WebElementFacade element) {
        element.click();
    }

    public void assertText (String text, WebElementFacade element) {
        Assert.assertEquals(text, element.getText());
    }

    public boolean elementIsVisible (WebElementFacade element){
        try {
            if (element.isDisplayed() )
                return true; }
        catch (org.openqa.selenium.NoSuchElementException e) {
            return false;
        }
        return false;
    }

    public boolean elementIsChecked (WebElementFacade element) {
        return (element.getAttribute("checked").equals("true"));
    }

    public boolean containsText ( String text, WebElementFacade element) {
        if (element.getText().contains(text)) {
            return true;
        }
        else return false;
    }

    public void waitForPageLoaded() throws InterruptedException {
        Thread.sleep(5000);
    }

    public void pressEnter (){
        new Actions(androidDriver()).sendKeys(Keys.ENTER).build().perform();
    }

    public void pressEscape (){
        new Actions(androidDriver()).sendKeys(Keys.ESCAPE).build().perform();
    }
    public void swipeTo (WebElementFacade element) {
        Point elementLocation = element.getLocation();
        Dimension elementSize = element.getSize();

// Calculate the start and end points for the swipe gesture
        int startX = elementLocation.getX() + elementSize.getWidth() / 2;
        int startY = elementLocation.getY() + elementSize.getHeight() - 10;
        int endY = elementLocation.getY() + 10;

// Perform the swipe gesture using TouchAction class
        TouchAction action = new TouchAction(androidDriver());
        action.press(PointOption.point(startX, startY))
                .waitAction()
                .moveTo(PointOption.point(startX, endY))
                .release()
                .perform();
    }



}

