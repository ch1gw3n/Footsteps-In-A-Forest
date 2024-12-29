// Main.pde - Contains setup(), draw(), and CSV sorting/printing
import processing.sound.*;

SoundFile song;                   // SoundFile object for background audio
SplashScreen splashScreen;        // SplashScreen object for the opening screen
boolean isSplashActive = true;    // Tracks whether the splash screen is active
float rButtonX, rButtonY, rButtonWidth, rButtonHeight;  // Reset button variables

// Fonts for title, date, description
PFont titleFont;    
PFont dateFont;     
PFont descriptionFont; 

// Table to store the CSV data
Table stepData;      

// Branch data for group members
ArrayList<CreateBranch> lindsayBranch = new ArrayList<>();
ArrayList<CreateBranch> sadieBranch   = new ArrayList<>();
ArrayList<CreateBranch> davidBranch   = new ArrayList<>();
ArrayList<CreateBranch> chiBranch     = new ArrayList<>();
ArrayList<CreateBranch> reggieBranch  = new ArrayList<>();

float offset = -90.0; // Angle offset to orient the tree vertically
float count;          // Keeps track of tree growth progress
float s_weight;       // Stroke weight (branch thickness)
color treeColor;      // Unique color assigned to the tree

// Array to store step data for each date 
int[] lindsaySteps;         
int[] davidSteps;         
int[] sadieSteps;         
int[] chiSteps;  
int[] reggieSteps;         

// Index to track which step count to use
int currentStepIndex = 0;  

// Our colors
color lindsayColor = color(120, 20, 20);  // red
color davidColor   = color(220, 130, 20); // yellow
color sadieColor   = color(75, 100, 165); // blue
color chiColor     = color(160, 65, 150); // purple
color reggieColor  = color(80, 140, 90);  // green

void setup() {
  fullScreen();

  // Load the audio file for background music
  song = new SoundFile(this, "stepSonification.mp3");
  
  // Load fonts for text display
  titleFont = createFont("OffBit-Bold.otf", 36);       
  dateFont = createFont("Nitti-Normal.ttf", 24);     
  descriptionFont = createFont("Nitti-Normal.ttf", 20); 
    
  // Initialize the splash screen, active on start
  splashScreen = new SplashScreen(titleFont, dateFont);  
  isSplashActive = true;
  
  textAlign(CENTER, TOP); 
  textSize(32); 
  fill(0); 
  loadCSV(); 
  
  // Configure the reset button, within date box
  rButtonWidth = 200;
  rButtonHeight = 40;
  rButtonX = 20 + 500 / 2 - 100; // Center of date display box
  rButtonY = 20 + 160 / 2 + 30;  // Slightly below center of date box
  
  // Initialize the root branches for each person
  lindsayBranch.add(new CreateBranch(width / 6, height, width / 6, height - 80, 80.0, 0.0, "Lindsay"));
  sadieBranch.add(new CreateBranch(width / 3, height, width / 3, height - 80, 80.0, 0.0, "Sadie"));
  davidBranch.add(new CreateBranch(width / 2, height, width / 2, height - 80, 80.0, 0.0, "David"));
  chiBranch.add(new CreateBranch(5 * width / 6, height, 5 * width / 6, height - 80, 80.0, 0.0, "Chi"));
  reggieBranch.add(new CreateBranch(2 * width / 3, height, 2 * width / 3, height - 80, 80.0, 0.0, "Reggie"));

  // Fading effect overlay needed for first set of trees
  fill(0, 15);
  rect(0, 0, width, height);
  
  // Check data is being read and sorted by date
  printSortedCSVData();
}

void draw() {
  if (isSplashActive) {
    // If splash screen is active, display it and check for button click
    if (mousePressed && splashScreen.isButtonClicked(mouseX, mouseY)) {
      isSplashActive = false;    // Deactivate the splash screen
      return; 
    }
    splashScreen.display();      // Show the splash screen
    return;
  }

  // Reset the program when the song ends
  if (!song.isPlaying()) {
    resetProgram();
  }


  // IF PROGRAM IS RUNNING
  if (currentStepIndex < stepData.getRowCount()) {
    String currentDate = stepData.getString(currentStepIndex, "Date/Time");
    
    // Date text box, left-aligned
    fill(230);
    noStroke();
    rect(20, 20, 300, 160, 10);
    
    // Date text
    fill(0);
    textFont(dateFont);
    textAlign(CENTER, CENTER);
    textSize(24);
    float boxCenterX = 20 + 300 / 2;
    float boxCenterY = 20 + 160 / 2;
    text("Date: " + currentDate, boxCenterX, boxCenterY - 30);

    // Title and project description text box, center-aligned
    fill(230);
    noStroke();
    float centerX = (width / 2);
    rect(centerX - 300, 20, 600, 160, 10);

    // Title text
    fill(0);
    textFont(titleFont);
    textAlign(CENTER, CENTER);
    text("FOOTSTEPS OF A FOREST", centerX, 60);

    // Project description text
    textFont(descriptionFont);
    textAlign(CENTER, TOP);
    String description = "This project visualizes step count data through a generative "
                         + "forest, exploring connections between movement and time.";
    float descriptionX = centerX - 290;
    float descriptionY = 100;
    float descriptionWidth = 580;
    text(description, descriptionX, descriptionY, descriptionWidth, 100);

    // Drawing the reset button
    fill(rButtonColor);
    textFont(descriptionFont);
    textSize(18);
    textAlign(CENTER, CENTER);
    rect(rButtonX - rButtonWidth / 2, rButtonY - rButtonHeight / 2, rButtonWidth, rButtonHeight, 5);
    fill(255);
    text("Reset Program", rButtonX, rButtonY);
    
    // Reset button color after 1 second
    if (rButtonClicked && millis() - rButtonClickedTime > 500) {
      rButtonClicked = false;
      rButtonColor = color(0);
    }

    // Color key text box, right-aligned
    fill(230);
    noStroke();
    rect(width - 320, 20, 300, 160, 10);
    
    // Key labels & colors
    textFont(descriptionFont);
    textAlign(LEFT, CENTER);
    float keyStartX = width - 300 + 30;  
    float keyStartY = 40;                
    float keySpacing = 30;               

    // Names & corresponding colors
    String[] names = {"Lindsay", "David", "Chi", "Sadie", "Reggie"};
    color[] colors = {lindsayColor, davidColor, chiColor, sadieColor, reggieColor};
    for (int i = 0; i < names.length; i++) {
      fill(0);
      text(names[i] + ":", keyStartX, keyStartY + i * keySpacing);
      fill(colors[i]);
      ellipse(keyStartX + textWidth(names[i] + ": ") + 10, keyStartY + i * keySpacing, 15, 15);
    }
    
    // Rendering & updating each person's trees
    for (int i = 0; i < lindsayBranch.size(); i++) {
      CreateBranch bL = lindsayBranch.get(i);
      bL.render(); 
      bL.update(); 
    }
    for (int i = 0; i < sadieBranch.size(); i++) {
      CreateBranch bS = sadieBranch.get(i);
      bS.render(); 
      bS.update();  
    }
    for (int i = 0; i < davidBranch.size(); i++) {
      CreateBranch bD = davidBranch.get(i);
      bD.render();  
      bD.update();  
    }
    for (int i = 0; i < reggieBranch.size(); i++) {
      CreateBranch bR = reggieBranch.get(i);
      bR.render(); 
      bR.update();  
    }
    for (int i = 0; i < chiBranch.size(); i++) {
      CreateBranch bC = chiBranch.get(i);
      bC.render();  
      bC.update();
    }
    
    // Once the step index hits a year, reset for a new tree
    if (currentStepIndex == 365) {
      resetTree("Sadie");
      resetTree("David");
      resetTree("Chi");
      resetTree("Lindsay");
      resetTree("Reggie");
    }
    currentStepIndex++;
    //println("Index No: " + currentStepIndex);
  } else {
    currentStepIndex = 0;
  }
}

// Variables for tracking button state
boolean rButtonClicked = false;  // Tracks if the reset button is clicked
float rButtonClickedTime = 0;    // Stores the time when the reset button was clicked
color rButtonColor = color(0);   // Stores the color of the reset button

// Function to handle mouse press events
void mousePressed() {
  if (isSplashActive) {
    isSplashActive = false; // Exit the splash screen
    background(0);          // Set the background to black
    song.play();            // Start playing the song
  
  } else {
    // Check if the Reset button is clicked
    if (mouseX > rButtonX - rButtonWidth / 2 && mouseX < rButtonX + rButtonWidth / 2 &&
        mouseY > rButtonY - rButtonHeight / 2 && mouseY < rButtonY + rButtonHeight / 2) {
      println("Reset button clicked");
      rButtonClicked = true;            // Set the button as clicked
      rButtonClickedTime = millis();    // Record the time of the click
      rButtonColor = color(255, 0, 0);  // Change color to red when clicked
      resetProgram();                   // Call the function to reset the program
    }
  }
}

void resetProgram() {
  currentStepIndex = 0; // Reset the current step index
  background(0);        // Reset the background to black
  song.jump(0);         // Restart the song from the beginning
    
  // Clear each branch
  lindsayBranch.clear();
  sadieBranch.clear();
  davidBranch.clear();
  reggieBranch.clear();
  chiBranch.clear();
  println("Program reset");
  
  // New trees
  regenerateTrees();
}

// Function to regenerate trees (recreate initial tree branches)
void regenerateTrees() {
  // Add the initial root branch for each person (you can adjust positions and other parameters)
  lindsayBranch.add(new CreateBranch(width / 6, height, width / 6, height - 80, 80.0, 0.0, "Lindsay"));
  sadieBranch.add(new CreateBranch(width / 3, height, width / 3, height - 80, 80.0, 0.0, "Sadie"));
  davidBranch.add(new CreateBranch(width / 2, height, width / 2, height - 80, 80.0, 0.0, "David"));
  chiBranch.add(new CreateBranch(5 * width / 6, height, 5 * width / 6, height - 80, 80.0, 0.0, "Chi"));
  reggieBranch.add(new CreateBranch(2 * width / 3, height, 2 * width / 3, height - 80, 80.0, 0.0, "Reggie"));
}

// Function to load the CSV data
void loadCSV() {
  stepData = loadTable("step-data.csv", "header"); 
  if (stepData == null) {
    println("Error: Could not load CSV file---");
    exit();
  }
  println("CSV file loaded successfully---");  
  
  // Extract data values from each person's column
  lindsaySteps = new int[stepData.getRowCount()];
  for (int i = 0; i < stepData.getRowCount(); i++) {
    lindsaySteps[i] = stepData.getInt(i, "Lindsay Steps"); 
  }
  davidSteps = new int[stepData.getRowCount()];
  for (int i = 0; i < stepData.getRowCount(); i++) {
    davidSteps[i] = stepData.getInt(i, "David Steps");
  }
  sadieSteps = new int[stepData.getRowCount()];
  for (int i = 0; i < stepData.getRowCount(); i++) {
    sadieSteps[i] = stepData.getInt(i, "Sadie Steps");
  }
  chiSteps = new int[stepData.getRowCount()];
  for (int i = 0; i < stepData.getRowCount(); i++) {
    chiSteps[i] = stepData.getInt(i, "Chi Steps");
  }
  reggieSteps = new int[stepData.getRowCount()];
  for (int i = 0; i < stepData.getRowCount(); i++) {
    reggieSteps[i] = stepData.getInt(i, "Reggie Steps"); 
  }
}

void printSortedCSVData() {
  println("Sorting and printing CSV data...---\n");
  
  // Convert table rows to a list of maps for sorting
  ArrayList<HashMap<String, String>> rows = new ArrayList<HashMap<String, String>>();
  for (TableRow row : stepData.rows()) {
    HashMap<String, String> map = new HashMap<String, String>();
    for (String column : stepData.getColumnTitles()) {
      map.put(column, row.getString(column)); 
    }
    rows.add(map);
  }
  
  // Sort rows by "Date/Time" in descending order
  rows.sort((a, b) -> int(b.get("Date/Time")) - int(a.get("Date/Time")));
  
  // Print sorted data 
  String[] columns = stepData.getColumnTitles();
  String header = String.join(", ", columns); 
  println(header); 
  for (HashMap<String, String> row : rows) {
    StringBuilder rowText = new StringBuilder();
    for (String column : columns) {
      rowText.append(row.get(column)).append(", "); 
    }
    println(rowText.toString().trim());
  }
}
