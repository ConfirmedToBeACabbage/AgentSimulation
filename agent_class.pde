abstract class Agent {
  
  // Default parameters
  float x, y, speed;
  float direction_choose_x, direction_choose_y, moving_time, idle_time;
  boolean idle;
  float red, blue, green;
  
  // Sound 
  SoundWave agentSound = new SoundWave(this, 0.8);
  
  // Filter 
  Filter agentFilter = new Filter(this, 0.8);
  
  // Collision checking
  Map<Agent, Float> neighbours = new HashMap<>();
  
  Agent(float xpos, float ypos, float s) { 
    x = xpos; 
    y = ypos; 
    speed = s;
    moving_time = 0;
    idle = false;
    red = random(200, 255);
    blue = random(200, 255);
    green = random(100, 180);
  } 
  
  void update(){ 
    if(idle == false) {
      moving_time += 1;
      
      if(moving_time == 30){
        idle = true;
        direction_choose_x = random(-1, 1);
        direction_choose_y = random(-1, 1);
     
        moving_time = 0;
        idle_time = 0;
      }
      
      x = constrain(x + direction_choose_x, 0, 860);
      y = constrain(y + direction_choose_y, 450, 700);
      
    } else {
      idle_time += 1;
  
      if (idle_time == 60) {
       idle = false;
       idle_time = 0;
      }
    }
  }
  
  double[] GetSoundWavePosition(Agent from) { 
    double change_x = this.x - from.agentSound.x;
    double change_y = this.y - from.agentSound.y;
    
    double angle = Math.atan2(change_y, change_x);
    double[] calc = {from.x + from.agentSound.intensity * Math.cos(angle), from.y + from.agentSound.intensity * Math.sin(angle)};
    return calc;
  }
  
  double[] GetAgentPosition(Agent from){
    double change_x = this.x - from.x;
    double change_y = this.y - from.y;
    
    double angle = Math.atan2(change_y, change_x);
    double[] calc = {from.x + 20 * Math.cos(angle), from.y + 20 * Math.sin(angle)};
    return calc;
  }
  
  // We should check collision for any soundwaves
  void colCheck(Map<Integer, Agent> agentDict) {
    
    for(Map.Entry<Integer, Agent> agent : agentDict.entrySet()){
      Agent key = agent.getValue();
      
      if (key.agentSound.intensity != 0 && key != this){
      
        double[] other_pos = GetSoundWavePosition(key);
        float distance = dist(this.x, this.y, (float)other_pos[0], (float)other_pos[1]);
        pushMatrix();
        double[] other_pos_agent = GetAgentPosition(key);
        line(this.x, this.y, (float)other_pos_agent[0], (float)other_pos_agent[1]);
        popMatrix();
        
        //print(" " + distance);
        
        float distance_agent = dist(this.x, this.y, (float)other_pos_agent[0], (float)other_pos_agent[1]);
        if(distance_agent <= 100 && this.agentSound.talking == false) {
          float random_talk = random(0, 10);
          if(random_talk == 1){
            agentSound = agentFilter.process(this.agentSound); // Set new sound according to own experience
          }
        }
        
        // If the soundwave is close to our character we then act on it
        if(distance <= 50 && this.agentSound.talking == false) {
          agentSound = agentFilter.process(key.agentSound); // Set new sound
          print("||" + agentSound.maxInt);
        }
        
      }
       //<>//
    }
    
  }
  
  // Sound functionality
  void soundOut() {
    agentSound.update();
    agentSound.display();
  }
  
  abstract void display();
}

class SoundWave { 
  float x, y; 
  float curr_size;
  float intensity, maxInt;
  int reverse = 0;
  
  boolean talking = false;
  
  // Tone of wave
  double tone; 
  
  Agent referenceParent;
  SoundWave(Agent referenceParentP, double toneP){
    referenceParent = referenceParentP;
    tone = toneP;
    intensity = 0;
    maxInt = (float)tone * 100;
    print(maxInt);
  }
  
  void setIntensity(int intensityP) {
    maxInt = intensityP;
    reverse = 0;
  }
  
  void update(){
   if(intensity == maxInt) {
     talking = false;
     reverse = 1;
   }
   if(reverse == 1 && intensity != 0) {
     intensity -= 1;
   } else if (intensity <= maxInt){
     intensity += 1; 
     talking = true;
   }
  }
  
  void display() {
    noFill();
    stroke(0.1);
    pushMatrix();
    translate(referenceParent.x+20, referenceParent.y+20);
    circle(0, 0, intensity); 
    popMatrix();
  }
}

// The filter through which the agent views everything
class Filter { 
  
  // Memory portion
  Map<Agent, Double> memoryDictionary = new HashMap<>(); 
  
  // Current relationships 
  Map<Agent, Double> relationshipDictionary = new HashMap<>();
  
  // Current Status
  double mood; 
  
  // Reference
  Agent parentReference; 
  
  Filter(Agent getReference, double moodP){ 
    mood = moodP; 
    parentReference = getReference;
    memoryDictionary.put(parentReference, moodP);
  }
  
  // Filter Process
  SoundWave process(SoundWave input) {
    Map<Agent, Double> sumDictionary = new HashMap<>(); //<>//
    double zero = 1; //<>//
    double overall_average = 1; //<>//
    
    for(Map.Entry<Agent, Double> entry : memoryDictionary.entrySet()){ //<>//
      // Sum up all of your memory 
      // Get an average of per agent (so the memories on average for the agents)
      // Get an overall average
      // Use the average of per agent to update relationship scales
      // Use the overall overage influence the response
      
      Agent key = entry.getKey();
      double value = entry.getValue();
      
      // Adding up 
      if(sumDictionary.get(key) == null) {
        sumDictionary.put(key, zero); 
        overall_average += 1;
      } else { 
        double weight = (relationshipDictionary.get(key) != null) ? 2 : 1;
        double result = value + sumDictionary.get(key) + weight;
        sumDictionary.put(key, result); 
        overall_average += result; //<>//
      }
    }
    
    // Overall average to update the mood
    mood *= overall_average;
    double average_sum = 1;
    
    // Use the average of per agent to update relationship scales
    for(Map.Entry<Agent, Double> entry : sumDictionary.entrySet()){
       
      Agent key = entry.getKey();
      double value = entry.getValue();
      
      if(relationshipDictionary.get(key) == null) {
        relationshipDictionary.put(key, zero); 
        average_sum += zero;
      } else { 
        double result = value * mood;
        relationshipDictionary.put(key, result); 
        average_sum += result;
      }
      
    }
    
    SoundWave response = new SoundWave(parentReference, average_sum * mood);
    return response; 
  }
  
  public double getMood() { 
    return this.mood;
  }
  
}
