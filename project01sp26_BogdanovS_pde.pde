import java.util.HashMap;
import java.util.Map;

Map<Integer, Agent> agentDict = new HashMap<>(); 
Map<Agent, Integer> deadAgentDict = new HashMap<>(); 
Map<Integer, HumanBaby> babyDict = new HashMap<>();
Map<Human, Integer> babyGrownDict = new HashMap<>();
Map<Integer, Object> rockObjDict = new HashMap<>();
Map<Integer, Object> foodObjDict = new HashMap<>();
Object poppedObj;
Agent popped; 
Agent inspecting = null;
float year = 0;

// Button
Button[] buttons; 

boolean noiseGenerated = false;

float xOff = 0.0;

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
    float yPlace = random(210, 700);
    
    Agent put = new Human(xPlace, yPlace, 0.01, 40);
    agentDict.put(i, put);
  }
  
  for(int i = 0; i < 100; i++) {
    float xRock = random(10, 850);
    float yRock = random(210, 850);
    
    float xGrass = random(10, 850); 
    float yGrass = random(210, 850); 
    
    Object newObj;
    if(i < 20){
    
      if(xRock + 50 > xGrass && yGrass + 50 > yGrass || xRock - 50 < xGrass && yRock - 50 < yGrass) {
        xRock = random(xRock + 50, (700)-xRock-50);
        yRock = random(yRock + 50, (700)-yRock-50);
      }
      
      newObj = new Rock(xRock, yRock, random(40, 60), (int)random(5, 12));
      rockObjDict.put(i, newObj);

    }
    
    newObj = new Food(xGrass, yGrass, random(10, 12), (int)random(10, 20));
    foodObjDict.put(i, newObj);
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
  
  // Background
  fill(100, 230, 0);
  rect(-1, 200, 861, 660);
  
  for(int i = 0; i < rockObjDict.size(); i++) {
     poppedObj = rockObjDict.get(i);
     
     poppedObj.display();
  }
  
  for(int i = 0; i < foodObjDict.size(); i++) {
     poppedObj = foodObjDict.get(i);
     
     poppedObj.display();
  }
  
  // Inspecting
  if(inspecting != null) {
    inspecting.display(130, 75);
    
    // Buttons to change behaviour
    for(int i = 0; i < 4; i++){
      buttons[i].display(); 
    }
    
    // The none portion (Inspecting nothing)
    fill(0);
    
    // Some global stats
    textSize(20);
    text("Mood", 320, 70);
    text(inspecting.agentFilter.baseCalc(), 600, 70);
    
    text("Relationships", 320, 110);
    text(constrain(inspecting.agentFilter.agentPerAgentMemory.size() - 1, 0, inspecting.agentFilter.agentPerAgentMemory.size()), 600, 110);
    
    text("Hunger", 320, 150);
    text(inspecting.hungry, 600, 150);
    
    text("Health", 320, 180);
    text(inspecting.health, 600, 190);
    
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
      sum += key.agentFilter.base;
      counter++;
    }
    
    pushMatrix();
    fill(100, (sum/counter) * 1000, 100);
    rect(600, 55, 200, 10); 
    popMatrix();
    
    text("Human Number", 320, 110);
    text(agentDict.size() - deadAgentDict.size(), 600, 110);
    
    text("Baby number", 320, 150);
    text(babyDict.size() - babyGrownDict.size(), 600, 150);
  }
  
  int before_size = agentDict.size();
  for(int i = 0; i < before_size; i++){
    popped = agentDict.get(i);
    
    if(popped == null) {
     continue;
    }
    
    if(popped.dead == true){
      if(deadAgentDict.get(popped) == null) deadAgentDict.put(popped, 0); 
    } else if(popped.dead == false){
      popped.colCheckObj(rockObjDict, foodObjDict);
    
      popped.soundOut();
      popped.colCheck(agentDict);
      popped.update();
      
      // Interface button
      pushMatrix();
      circle(popped.x, popped.y, 15);
      popMatrix();
      
      popped.display();
      popped.relationshipDisplay();
      
      HumanBaby check = popped.babyCheck();
      if(check != null){
       print("||" + check);
       babyDict.put(babyDict.size(), check); 
      } 
    }
    
    popped.healthUpdate();
  }
  
  for(Map.Entry<Integer, HumanBaby> entry : babyDict.entrySet()){
    HumanBaby hbPopped = entry.getValue();
    
    year += 0.1;
    
    //print("BABY WE BE POPPIN" + hbPopped);
    if(hbPopped == null || hbPopped.grown_up) continue;
    
    //print("||" + year);
    if(year >= 10){
      Human check = hbPopped.live(); 
      if(check != null) {
        agentDict.put(babyDict.size(), check);
        babyGrownDict.put(check, 0);
      }
      year = 0;
    }
    
    hbPopped.update();
    hbPopped.display();
  }

}

void mouseReleased() {
  
  if(inspecting != null) {
    for(int i = 0; i < 4; i++) {
     Button check = buttons[i];
     float distance = dist(mouseX, mouseY, check.x + check.width/2, check.y + check.height/2);
     
     if(distance <= 15) {
       
       switch(i) {
         case 0:
           inspecting.showRaycastsFlag();
           return;
         case 1: 
           inspecting.showSoundRaycastsFlag();
           return;
         case 2: 
           inspecting.showRelationshipsFlag();
           return;
         case 3:
           inspecting.reset();
           return;
       }
       
     } 
   
   
    }
   }
  
  for(Map.Entry<Integer, Agent> agent : agentDict.entrySet()){
      Agent key = agent.getValue();
      
      float distance = dist(mouseX, mouseY, key.x, key.y);
      
      //print("||" + distance);
      
      // Clicked
      if(distance <= 15) {
        inspecting = key;
        break;
      } else if (mouseY >= 200){
        inspecting = null; 
      }
   }
   
}
