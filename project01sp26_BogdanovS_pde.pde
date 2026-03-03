import java.util.Hashtable;
import java.util.Dictionary;

Agent human; 
Agent humanbaby;

Dictionary<Integer, Agent> agentDict = new Hashtable<>(); 
Agent popped; 

void setup() {
  size(860, 860);
  //human = new Human(width/2, height/2, 0.01, 40);
  //humanbaby = new HumanBaby(width/2, height/2, 0.0001);
  
  for(int i = 0; i < 5; i++) {
    agentDict.put(i, new Human(random(100, 700), random(450, 700), 0.01, 40));
  }
}

void draw() {
  background(204);
  for(int i = 0; i < agentDict.size(); i++){
    popped = agentDict.get(i);
    // Going to be part of mechanic testing
    //popped.soundIntensity(200); // Simple mechanic of setting the intensity of the sound
    //popped.soundOut();
    
    popped.update();
    popped.display();
  }
}
