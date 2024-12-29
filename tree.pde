// Tree.pde - Contains the CreateBranch class and tree growth logic
// Class representing an individual branch
class CreateBranch {
  float startx, starty, endx, endy; // Start and end points of the branch
  float length, degree;             // Length and angle of the branch
  float nextx, nexty;               // Intermediate point used for animated growth
  float prevx, prevy;               // Previous point used for animated growth
  boolean next_flag = true;         // Ensures a branch splits only once
  boolean draw_flag = true;         // If the branch should be drawn
  color branchColor;                // Color of the branch (entire tree)
  String person;                    // Person's branch

  // Constructor to initialize a branch with given parameters
  CreateBranch(float sx, float sy, float ex, float ey, float sl, float sd, String person) {
    startx = sx;      // Starting x-coordinate
    starty = sy;      // Starting y-coordinate
    endx = ex;        // Ending x-coordinate
    endy = ey;        // Ending y-coordinate
    length = sl;      // Length of the branch
    degree = sd;      // Angle of the branch
    nextx = startx;   // Start the growth from the starting point
    nexty = starty;
    prevx = startx;   // Initialize previous point to starting point
    prevy = starty;
    this.person = person; // Assigns person to branch
    
    // Assign the branch's color based on the person
    switch (person) {
      case "Sadie": 
        branchColor = sadieColor; 
        break;
      case "David": 
        branchColor = davidColor; 
        break;
      case "Chi": 
        branchColor = chiColor; 
        break;
      case "Lindsay": 
        branchColor = lindsayColor; 
        break;
      case "Reggie": 
        branchColor = reggieColor; 
        break;
      default: 
        branchColor = color(255); // Default fallback color
    }
  }

  void update() {
    // Gradually move the intermediate point toward the end point
    nextx += (endx - nextx) * 0.1;
    nexty += (endy - nexty) * 0.1;
  
    // Calculate stroke weight dynamically based on tree growth
    s_weight = 3.0 / (count / 100 + 1);
  
    // If the branch has finished growing (reached its endpoint)
    if (abs(nextx - endx) < 1.0 && abs(nexty - endy) < 1.0 && next_flag) {
      next_flag = false; // Prevent further splitting
      draw_flag = false; // Mark the branch as fully drawn
      nextx = endx;      // Set final position to the endpoint
      nexty = endy;
  
      // Only create new branches if the person's total branches are less than 6000
      if (getPersonBranches(person) < 5000) {
        // Randomly create 2 to 4 child branches
        int num = (int) random(2, 4);
        for (int i = 0; i < num; i++) {
          float sx = endx; // Start of the child branch is the end of the current branch
          float sy = endy;
          float sl = random(random(10.0, 20.0), length * 0.99); // Random length for the child branch
          float sd = random(-24.0, 24.0);                       // Random angle deviation for the child branch
          float ex = sx + sl * cos(radians(sd + degree + offset)); // Calculate end x-coordinate
          float ey = sy + sl * sin(radians(sd + degree + offset)); // Calculate end y-coordinate
  
          // Add the child branch only to the corresponding tree's ArrayList
          switch (person) {
            case "Sadie":
              sadieBranch.add(new CreateBranch(sx, sy, ex, ey, sl, sd + degree, "Sadie"));
              break;
            case "David":
              davidBranch.add(new CreateBranch(sx, sy, ex, ey, sl, sd + degree, "David"));
              break;
            case "Chi":
              chiBranch.add(new CreateBranch(sx, sy, ex, ey, sl, sd + degree, "Chi"));
              break;
            case "Lindsay":
              lindsayBranch.add(new CreateBranch(sx, sy, ex, ey, sl, sd + degree, "Lindsay"));
              break;
            case "Reggie":
              reggieBranch.add(new CreateBranch(sx, sy, ex, ey, sl, sd + degree, "Reggie"));
              break;
          }
        }
        count += 0.1; // Increment tree growth counter
      }
    }
  }
  
  // Function to get the number of branches for a specific person
  int getPersonBranches(String person) {
    switch (person) {
      case "Sadie":
        return sadieBranch.size();
      case "David":
        return davidBranch.size();
      case "Chi":
        return chiBranch.size();
      case "Lindsay":
        return lindsayBranch.size();
      case "Reggie":
        return reggieBranch.size();
      default:
        return 0; // Return 0 if person is not recognized
    }
  }

  // Render function to draw the branch on the canvas
  void render() {
    if (draw_flag) { // Only draw if the branch is still growing
      stroke(branchColor); // Use the tree's unique color
      strokeWeight(s_weight); // Set stroke weight dynamically
      line(prevx, prevy, nextx, nexty); // Draw the line segment
    }
    // Update previous point for the next frame
    prevx = nextx;
    prevy = nexty;
  }  
}

// Function to reset the tree once it reaches its branch limit
void resetTree(String person) {
  count = 0;    // Reset growth counter
  s_weight = 0; // Reset stroke weight
  
  int currentSteps = 0; // Steps for the current person
  float sl = 0;         // Calculated branch height
  
  // Map steps to branch height based on the person
  switch (person) {
    // Scaling height in pixels (1 pixel per 75 steps)
    case "Sadie":
      currentSteps = sadieSteps[currentStepIndex];
      sl = currentSteps / 75.0;
      break;
    case "David":
      currentSteps = davidSteps[currentStepIndex];
      sl = currentSteps / 75.0;
      break;
    case "Chi":
      currentSteps = chiSteps[currentStepIndex];
      sl = currentSteps / 75.0;
      break;
    case "Lindsay":
      currentSteps = lindsaySteps[currentStepIndex];
      sl = currentSteps / 75.0;
      break;
    case "Reggie":
      currentSteps = reggieSteps[currentStepIndex];
      sl = currentSteps / 75.0;
      break;
  }
  
  // Randomize the starting x and y positions
  float sx = random(width); // Random horizontal position on the canvas
  float sy = random(height * 0.8, height);  // Random vertical position
  
  // Randomize the initial branch length with a variation
  sl = random(sl * 0.5, sl * 3); // Varies the branch length by ±20%

  // Create the initial branch
  switch (person) {
    case "Sadie":
      sadieBranch.clear();
      sadieBranch.add(new CreateBranch(sx, sy, sx, sy - sl, sl, 0.0, "Sadie"));
      break;
    case "David":
      davidBranch.clear();
      davidBranch.add(new CreateBranch(sx, sy, sx, sy - sl, sl, 0.0, "David"));
      break;
    case "Chi":
      chiBranch.clear();
      chiBranch.add(new CreateBranch(sx, sy, sx, sy - sl, sl, 0.0, "Chi"));
      break;
    case "Lindsay":
      lindsayBranch.clear();
      lindsayBranch.add(new CreateBranch(sx, sy, sx, sy - sl, sl, 0.0, "Lindsay"));
      break;
    case "Reggie":
      reggieBranch.clear();
      reggieBranch.add(new CreateBranch(sx, sy, sx, sy - sl, sl, 0.0, "Reggie"));
      break;
  }
  // Fading effect overlay to show new trees
  fill(0, 10);
  rect(0, 0, width, height);
}
