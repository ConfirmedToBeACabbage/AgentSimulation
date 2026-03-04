abstract class Agent {
  
  // Default parameters
  float x, y, speed;
  float direction_choose_x, direction_choose_y, moving_time, idle_time;
  boolean idle;
  float red, blue, green;
  int max_idle;
  
  // Sound 
  SoundWave agentSound = new SoundWave(this, 0.8);
  
  // Filter 
  Filter agentFilter = new Filter(this, 0.8);
  
  // Collision checking
  Map<Agent, Float> neighbours = new HashMap<>();
  
  // Debug Flags
  boolean showRelationships = false;
  boolean showRaycasts = false; 
  boolean showSoundRaycasts = false;
  
  Agent(float xpos, float ypos, float s) { 
    x = xpos; 
    y = ypos; 
    speed = s;
    moving_time = 0;
    idle = false;
    red = random(200, 255);
    blue = random(200, 255);
    green = random(100, 180);
    max_idle = int(random(60, 90));
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
  
      if (idle_time == max_idle) {
       idle = false;
       idle_time = 0;
      }
    }
  }
  
  double[] GetSoundWavePosition(Agent from) { 
    double change_x = this.x - (from.agentSound.x + from.halfActualSize());
    double change_y = this.y - (from.agentSound.y + from.halfActualSize());
    
    double angle = Math.atan2(change_y, change_x);
    double[] calc = {(from.x + from.halfActualSize()) + from.agentSound.intensity/2 * Math.cos(angle), (from.y + from.halfActualSize()) + from.agentSound.intensity/2 * Math.sin(angle)};
    return calc;
  }
  
  double[] GetAgentPosition(Agent from){
    double change_x = this.x - (from.agentSound.x + from.halfActualSize());
    double change_y = this.y - (from.agentSound.y + from.halfActualSize());
    
    double angle = Math.atan2(change_y, change_x);
    double[] calc = {(from.x + from.halfActualSize()) + (from.halfActualSize()/2) * Math.cos(angle), (from.y + from.halfActualSize()) + (from.halfActualSize()/2) * Math.sin(angle)};
    return calc;
  }
  
  // We should check collision for any soundwaves
  void colCheck(Map<Integer, Agent> agentDict) {
    
    for(Map.Entry<Integer, Agent> agent : agentDict.entrySet()){
      Agent key = agent.getValue();
      
      if (key.agentSound.intensity != 0 && key != this){
      
        pushMatrix();
        double[] other_pos = GetSoundWavePosition(key);
        float distance = dist(this.x, this.y, (float)other_pos[0], (float)other_pos[1]);
        line(this.x + this.halfActualSize(), this.y + this.halfActualSize(), (float)other_pos[0], (float)other_pos[1]);
        popMatrix();
        
        pushMatrix();
        double[] other_pos_agent = GetAgentPosition(key);
        //line(this.x + this.halfActualSize(), this.y + this.halfActualSize(), (float)other_pos_agent[0], (float)other_pos_agent[1]);
        popMatrix();
        
        //print(" " + distance);
        
        float distance_agent = dist(this.x, this.y, (float)other_pos_agent[0], (float)other_pos_agent[1]);
        if(distance_agent <= 300 && this.agentSound.talking == false) {
          float random_talk = random(0, 10);
          if(random_talk == 1){
            agentSound = agentFilter.process(this.agentSound); // Set new sound according to own experience
          }
        }
        
        // If the soundwave is close to our character we then act on it
        if(distance <= 50 && this.agentSound.talking == false) {
          agentSound = agentFilter.process(key.agentSound); // Set new sound
          //print("||" + agentSound.maxInt);
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
  abstract void display(float xGet, float yGet);
  abstract float halfActualSize();
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
   if(intensity >= maxInt) {
     reverse = 1;
   } else if(intensity < 0) {
     reverse = -1;
     talking = false;
   }
   
   if(reverse == 1){
     intensity -= 1;
   } else if(reverse == 0) {
     intensity += 1; 
   }
  }
  
  void display() {
    noFill();
    stroke(0.1);
    pushMatrix();
    translate(referenceParent.x+referenceParent.halfActualSize(), referenceParent.y+referenceParent.halfActualSize());
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
      double result = 0;
      
      // Adding up 
      if(sumDictionary.get(key) == null) {
        sumDictionary.put(key, zero); 
        result = 1;
      } 
      
      if (key == input.referenceParent) {
        double weight = (relationshipDictionary.get(key) != null) ? 2 : 1;
        result = value + sumDictionary.get(key) + weight;
        sumDictionary.put(key, result); 
      }
      
      overall_average += result; //<>//
    }
    
    // Overall average to update the mood
    mood = sigmoid(mood * overall_average);
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
     
    //print("||" + average_sum * mood);
    SoundWave response = new SoundWave(parentReference, average_sum * mood);
    return response; 
  }
  
  public double getMood() { 
    return this.mood;
  }
  
  double sigmoid(double x) {
    return 1 / (1 + Math.exp(-x));
  }
  
}
