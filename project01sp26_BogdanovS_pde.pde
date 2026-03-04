import java.util.HashMap;
import java.util.Map;

Agent human; 
Agent humanbaby;

Map<Integer, Agent> agentDict = new HashMap<>(); 
Agent popped; 
Agent inspecting = null;

void setup() {
  size(860, 860);
  
  for(int i = 0; i < 2; i++) {
    float xPlace = random(100, 700);
    float yPlace = random(350, 700);
    
    Agent put = new Human(xPlace, yPlace, 0.01, 40);
    agentDict.put(i, put);
  }
}

void draw() {
  background(204);
  
  // The line that borders the simulation area and then interface
  line(0, 200, 860, 200);
  
  // The line for the agent view
  line(300, 0, 300, 200);
  
  // Inspecting
  if(inspecting != null) {
    inspecting.display(130, 75);
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
