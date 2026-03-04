import java.util.HashMap;
import java.util.Map;

Map<Integer, Agent> agentDict = new HashMap<>(); 
Agent popped; 
Agent inspecting = null;

int numbBaby = 0;

// Button
Button[] buttons; 

class Button { 
  float x, y, width, height;
  String text;
  
  Button(float x, float y, float width, float height, String text) {
    this.x = x; 
    this.y = y;
    this.width = width;
    this.height = height;
    this.text = text;
  }
  
  void display(){
    fill(0);
    textSize(10);
    text(this.text, x+9, y+13);
    noFill();
    rect(x, y, width, height); 
  }
}

void setup() {
  size(860, 860);
  
  // Init agents
  for(int i = 0; i < 10; i++) {
    float xPlace = random(100, 700);
    float yPlace = random(350, 700);
    
    Agent put = new Human(xPlace, yPlace, 0.01, 40);
    agentDict.put(i, put);
  }
  
  // Init buttons
  buttons = new Button[4];
  buttons[0] = new Button(360, 10, 40, 20, "XRay");
  buttons[1] = new Button(410, 10, 55, 20, "CircleRay");
  buttons[2] = new Button(470, 10, 70, 20, "Relationships");
  buttons[3] = new Button(550, 10, 40, 20, "Reset");
}

void draw() {
  background(204);
  
  // The line that borders the simulation area and then interface
  line(0, 200, 860, 200);
  
  // The line for the agent view
  line(300, 0, 300, 200);
  
  // Buttons to change behaviour
  for(int i = 0; i < 4; i++){
    buttons[i].display(); 
  }
  
  // Inspecting
  if(inspecting != null) {
    inspecting.display(130, 75);
  } else {
    
    // The none portion (Inspecting nothing)
    fill(0);
    textSize(100);
    text("None", 35, 125);
    
    // Some global stats
    textSize(30);
    text("Average Mood", 320, 70);
    
    int counter = 0;
    float sum = 0;
    for(Map.Entry<Integer, Agent> agent : agentDict.entrySet()){
      Agent key = agent.getValue();
      sum += (float)key.agentFilter.mood;
      counter++;
    }
    
    pushMatrix();
    rect(600, 55, sum/counter * 100, 10); 
    popMatrix();
    
    text("Human Number", 320, 110);
    text(agentDict.size(), 600, 110);
    
    text("Baby number", 320, 150);
    text(numbBaby, 600, 150);
  }
  
  for(int i = 0; i < agentDict.size(); i++){
    popped = agentDict.get(i);
    
    popped.soundOut();
    popped.colCheck(agentDict);
    popped.update();
    
    // Interface button
    pushMatrix();
    circle(popped.x, popped.y, 15);
    popMatrix();
    
    popped.display();
  }  
}

void mouseReleased() {
  
  for(Map.Entry<Integer, Agent> agent : agentDict.entrySet()){
      Agent key = agent.getValue();
      
      float distance = dist(mouseX, mouseY, key.x, key.y);
      
      print("||" + distance);
      
      // Clicked
      if(distance <= 15) {
        inspecting = key;
        break;
      } else {
        inspecting = null; 
      }
    }
   
}
