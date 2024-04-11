package app.restController;

class CafuSampleTest {

    private String message;

    // Required for JSON deserialization
    CafuSampleTest() {
    }

    public CafuSampleTest(String message) {
        this.message = message;
    }

    public String getMessage() {
        return message;
    }
}
