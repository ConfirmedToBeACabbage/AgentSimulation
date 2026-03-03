import java.util.HashMap;
import java.util.Map;

Agent human; 
Agent humanbaby;

Map<Integer, Agent> agentDict = new HashMap<>(); 
Agent popped; 

// Distance object
Map<Agent, Float> agentDistDict = new HashMap<>();

void setup() {
  size(860, 860);
  //human = new Human(width/2, height/2, 0.01, 40);
  //humanbaby = new HumanBaby(width/2, height/2, 0.0001);
  
  for(int i = 0; i < 10; i++) {
    Agent put = new Human(random(100, 700), random(450, 700), 0.01, 40);
    agentDict.put(i, put);
    agentDistDict.put(put, float(0));
  }
}

void draw() {
  background(204);
  for(int i = 0; i < agentDict.size(); i++){
    popped = agentDict.get(i);
    // Going to be part of mechanic testing
    popped.soundOut();
    popped.colCheck(agentDict);
    popped.update();
    popped.display();
  }
}
