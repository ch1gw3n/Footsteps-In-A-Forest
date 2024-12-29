
class SplashScreen {
  float buttonX, buttonY, buttonWidth, buttonHeight;
  boolean isButtonPressed = false;
  float titleY, subtitleY, namesY, buttonPadding;
  PFont titleFont;  
  PFont dateFont;  
  PImage logo; 

  SplashScreen(PFont titleFont, PFont dateFont) {
    this.titleFont = titleFont;
    this.dateFont = dateFont;
    
    logo = loadImage("tree-logo.png");
    logo.resize(200, 0); // Resize width to 200 pixels, maintain aspect ratio

    buttonWidth = 150;
    buttonHeight = 50;

    // Set positions and padding
    titleY = height / 2 - 100;     // Adjusted title position
    subtitleY = titleY + 135;       // Padding below the title
    namesY = subtitleY + 70;       // Padding below the subtitle
    buttonPadding = 100;           // Padding below the names
    buttonX = width / 2 - buttonWidth / 2;
    buttonY = namesY + buttonPadding;
  }

  void display() {
    // Set the background to black
    background(0);
    
    // Display the logo image above the title
    float logoX = width / 2 - logo.width / 2; 
    float logoY = titleY - logo.height - 10; 
    image(logo, logoX, logoY);
    
    // Set the font for the title
    textFont(titleFont);
    fill(255); 
    textAlign(CENTER, CENTER);
    textSize(52); // Larger font size for the title
    text("FOOTSTEPS OF A FOREST", width / 2, titleY + 20);
    textSize(40);
    text("a data self portrait", width / 2, titleY + 70);

    // Set the font for the subtitle and names
    textFont(dateFont);
    fill(255); 
    textSize(24); 
    text("Created by:", width / 2, subtitleY);

    // Names text
    textSize(24);
    text("David Benenhaley, Lindsay Clifford,", width / 2, namesY); 
    text("Sadie Hendrickson, Chi Nguyen, Reggie Wigfall", width / 2, namesY + 30);

    // Draw Start button
    fill(50, 205, 50); 
    rect(buttonX, buttonY, buttonWidth, buttonHeight, 10); 

    // Start button text
    fill(255);
    textSize(24);
    text("Start", buttonX + buttonWidth / 2, buttonY + buttonHeight / 2);
  }

  boolean isButtonClicked(float mouseX, float mouseY) {
    return mouseX > buttonX && mouseX < buttonX + buttonWidth &&
           mouseY > buttonY && mouseY < buttonY + buttonHeight;
  }

  void handleButtonPress() {
    isButtonPressed = true; // Update flag when button is pressed
  }
}
