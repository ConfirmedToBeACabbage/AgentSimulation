abstract class Agent {
  
  // Default parameters
  float x, y, speed;
  float direction_choose_x, direction_choose_y, moving_time, idle_time;
  boolean idle;
  float red, blue, green;
  int max_idle;
  
  // Sound 
  SoundWave agentSound = new SoundWave(this, 0);
  
  // Filter 
  Filter agentFilter = new Filter(this);
  
  // Debug Flags
  boolean showRelationships = false;
  boolean showRaycasts = false; 
  boolean showSoundRaycasts = false;
  
  // General Flags
  boolean processing = false;
  boolean newAgent = false;
  boolean babyHad = false;
  boolean starving = false;
  
  // Object Flags
  boolean agentOnRock = false;
  boolean agentOnFood = false;
  
  boolean dead = false;
  
  // Agent items
  int eaten = 1;
  int relationships = 1;
  int kids = 1;
  
  float hungry = 0; // Loses itself by 0.01 every cycle
  float health = 100; // If starving loses itself by 0.01
  
  // On Object check
  Object rock; 
  Object food; 
  
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
        direction_choose_x = random(-4, 4);
        direction_choose_y = random(-4, 4);
     
        moving_time = 0;
        idle_time = 0;
      }
      
      x = constrain(x + direction_choose_x, 0, 860);
      y = constrain(y + direction_choose_y, 210, 850);
      
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
    double change_x = this.x - (from.x + from.halfActualSize());
    double change_y = this.y - (from.y + from.halfActualSize());
    
    double angle = Math.atan2(change_y, change_x);
    double[] calc = {(from.x + from.halfActualSize()) + (from.halfActualSize()/2) * Math.cos(angle), (from.y + from.halfActualSize()) + (from.halfActualSize()/2) * Math.sin(angle)};
    return calc;
  }
  
  double[] GetObjectPosition(Object from){
    float[] getValues = from.returnValues();
    double change_x = this.x - (getValues[0] + getValues[2]/2);
    double change_y = this.y - (getValues[1] + getValues[2]/2);
    
    double angle = Math.atan2(change_y, change_x);
    double[] calc = {(getValues[0]) + (getValues[2]/2) * Math.cos(angle), (getValues[1]) + (getValues[2]/2) * Math.sin(angle)};
    return calc;
  }
  
  // Health update
  void healthUpdate(){
    if(health <= 0) dead = true;
    
    if(hungry <= 5) hungry += 0.00001;
    
    if(hungry >= 30){
      health -= 5; 
    }
    
    if(this.rock != null && !this.agentOnRock){
      this.hungry += 5;
      this.health -= 20;
      
      this.hungry = constrain(this.hungry, 0, 100);
      this.health = constrain(this.health, 0, 100);
      
      this.agentOnRock = true;
    }
    
    if(this.food != null && !this.agentOnFood){
      this.hungry -= 5;
      this.health += 10;
      
      this.hungry = constrain(this.hungry, 0, 100);
      this.health = constrain(this.health, 0, 100);
      
      this.agentOnFood = true;
    }
  }
  
  // Baby check 
  HumanBaby babyCheck() {
    if(babyHad) return null;
    if(this.agentFilter.base >= 0.1 && this.health >= 50){
      this.babyHad = true;
      //print("MAKING BABY");
      //print(x);
      //print(y);
      return new HumanBaby(x, y, speed);
    }
    return null;
  }
  
  // The collision checking for objects
  void colCheckObj(Map<Integer, Object> rockDict, Map<Integer, Object> foodDict){
    
    // Loop rocks
      // If we hit a rock we process a base of -0.1
      
    // Loop food 
      // If we hit food we process a base of 0.5
  
    // Independent check
    if(this.rock != null) {
      double[] other_pos = GetObjectPosition(this.rock);
      float distance = dist(this.x + this.halfActualSize(), this.y + this.halfActualSize(), (float)other_pos[0], (float)other_pos[1]);
      
      if(distance >= this.rock.returnValues()[2]){
        this.rock = null;
        this.agentOnRock = false; 
      }
    }
    
    if(this.food != null) {
      double[] other_pos = GetObjectPosition(this.food);
      float distance = dist(this.x + this.halfActualSize(), this.y + this.halfActualSize(), (float)other_pos[0], (float)other_pos[1]);
      
      if(distance >= this.food.returnValues()[2]){
        this.food = null;
        this.agentOnRock = false; 
      }
    }
    
    if(this.rock == null) {
      for(Map.Entry<Integer, Object> entry : rockDict.entrySet()){
        Object key = entry.getValue();
        
        double[] other_pos = GetObjectPosition(key);
        float distance = dist(this.x + this.halfActualSize(), this.y + this.halfActualSize(), (float)other_pos[0], (float)other_pos[1]);
        
        // DEBUG
        //pushMatrix();
        //line(this.x + this.halfActualSize(), this.y + this.halfActualSize(), (float)other_pos[0], (float)other_pos[1]); 
        ////print("||" + distance);
        //popMatrix();
        
        if(distance <= key.returnValues()[2] && !this.agentOnRock){
          this.rock = key;
          this.agentFilter.baseInteraction("rock", this);
          break;
        } 
      
      }  
    }
    
    if(this.food == null) {
       for(Map.Entry<Integer, Object> entry : foodDict.entrySet()){
        Object key = entry.getValue();
        
        double[] other_pos = GetObjectPosition(key);
        float distance = dist(this.x + this.halfActualSize(), this.y + this.halfActualSize(), (float)other_pos[0], (float)other_pos[1]);
        
        if(distance <= key.returnValues()[2] && !this.agentOnFood){
          this.food = key;
          this.agentFilter.baseInteraction("food", this);
          key.reset();
          break;
        } 
      
      }
      
    }
   
  }
  
  // We should check collision for any soundwaves
  void colCheck(Map<Integer, Agent> agentDict) {
    
    for(Map.Entry<Integer, Agent> agent : agentDict.entrySet()){
      Agent key = agent.getValue();
      
      if (key != this){
      
        // Get the relative positions for the sound wave
        if(key.agentSound != null){
          pushMatrix();
          double[] other_pos = GetSoundWavePosition(key);
          float distance = dist(this.x, this.y, (float)other_pos[0], (float)other_pos[1]);
          if(showSoundRaycasts) line(this.x + this.halfActualSize(), this.y + this.halfActualSize(), (float)other_pos[0], (float)other_pos[1]); 
          popMatrix();
          
          // This is if we're catching a sound either to us or from the side 
          if(distance <= 50 && this.agentSound.talking == false) {
            
            this.agentFilter.processSound(key.agentSound);
            
            return; // We're only processing one interaction at a time
          }
        }
       
        
        // Get the relative positions for the other agent compared to yourself
        pushMatrix();
        double[] other_pos_agent = GetAgentPosition(key);
        if(showRaycasts) line(this.x + this.halfActualSize(), this.y + this.halfActualSize(), (float)other_pos_agent[0], (float)other_pos_agent[1]);
        popMatrix();
        
        float distance_agent = dist(this.x, this.y, (float)other_pos_agent[0], (float)other_pos_agent[1]);
        if(distance_agent <= 50 && this.agentSound.talking == false) {
          agentSound = this.agentFilter.makeDefaultSound(); 
          this.agentSound.talking = true;
        }
        
      }
       //<>//
    }
    
  }
  
  void relationshipDisplay() {
    Map<Agent, Float> getRelationship = this.agentFilter.getRelationships();
    
    if(showRelationships){
       for(Map.Entry<Agent, Float> entry : getRelationship.entrySet()){
        Agent key = entry.getKey();
        
        if(key == this || key.dead == true) continue;
        
        double[] other_pos_agent = GetAgentPosition(key);
        
        print("TEST: " + entry.getValue().floatValue() + "||" );
        strokeWeight(entry.getValue().floatValue() * 2);
        
        pushMatrix();
        line(this.x + this.halfActualSize(), this.y + this.halfActualSize(), (float)other_pos_agent[0], (float)other_pos_agent[1]);
        popMatrix();
      } 
    }
    
    strokeWeight(1);
  }
  
  // Sound functionality
  void soundOut() {
    if(this.agentSound != null){
      agentSound.update();
      agentSound.display(); 
    }
  }
  
  // Debugging interfaces
  void showRelationshipsFlag(){
    this.showRelationships = !this.showRelationships;
  }
  
  void showRaycastsFlag(){
    this.showRaycasts = !this.showRaycasts;
  }
  
  void showSoundRaycastsFlag(){
    this.showSoundRaycasts = !this.showSoundRaycasts;
  }
  
  void reset() {
     agentSound = this.agentFilter.makeDefaultSound(); 
     agentFilter = new Filter(this);
     x = random(100, 700);
     y = random(400, 700);
     moving_time = 0;
     idle = false;
     red = random(200, 255);
     blue = random(200, 255);
     green = random(100, 180);
     max_idle = int(random(60, 90));
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
  
  // Tone of wave
  double base; 
  
  // Flag
  boolean talking = false;
  
  Agent origin;
  
  SoundWave(Agent origin, double base){
    this.origin = origin;
    this.base = base;
    intensity = 0;
    maxInt = 100;
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
   }
   
   if(reverse == 1){
     intensity -= 1;
   } else if(reverse == 0) {
     intensity += 1; 
     talking = false;
   }
  }
  
  void display() {
    noFill();
    stroke(0.1);
    pushMatrix();
    translate(origin.x+origin.halfActualSize(), origin.y+origin.halfActualSize());
    circle(0, 0, intensity); 
    popMatrix();
  }
}

// The filter through which the agent views everything
class Filter { 
  
  // Reference
  Agent parentReference; 
  
  // Base 
  float base = 0;
  
  // Memory related items
  Map<Float, Agent> agentInteractionMemory = new HashMap<>();
  Map<Agent, Float> agentPerAgentMemory = new HashMap<>();
  
  // Flags
  boolean talking = false;
    
  Filter(Agent getReference){ 
    parentReference = getReference;
  }
  
  Map<Agent, Float> getRelationships(){
    return this.agentPerAgentMemory;
  }
  
  float baseCalc(){
    if(this.agentInteractionMemory.size() == 0){
      return this.base; 
    }
    
    float sum = 0.1;
    int count = 1;
    for(Map.Entry<Float, Agent> entry : agentInteractionMemory.entrySet()){
      sum += entry.getKey();
      count++; 
    }
    
    float avg = sum/count;
    
    this.base = avg;
    
    return this.base;
  }
  
  void baseInteraction(String identity, Agent reference) { 
    
    float base = 0;
    
    switch(identity){ 
      case "rock":
        base = -0.1;
      case "food":
        base = 0.5;
      case "baby": 
        base = 1.0;
    }
    
    agentInteractionMemory.put(base, reference);
    
    // Process
    this.baseCalc();
  }
  
  SoundWave makeDefaultSound(){
    float sum = 0.1;
    int count = 1;
    for(Map.Entry<Float, Agent> entry : agentInteractionMemory.entrySet()){
      sum += entry.getKey();
      count++; 
    }
    
    float avg = sum/count;
    //print("AVERAGE SOUND: " + avg);
    
    return new SoundWave(parentReference, avg);
  }
  
  SoundWave processSound(SoundWave sound) {
    
    Agent origin = sound.origin;
    
    baseCalc();
    
    SoundWave soundSend = new SoundWave(parentReference, base);
    
    if(origin != parentReference) {
      
      // Process
      float eatRatio = (parentReference.eaten/origin.eaten);
      float relRatio = (parentReference.relationships/origin.relationships);
      float kidsRatio = (parentReference.kids/origin.kids);
      
      float normal = (eatRatio + relRatio + kidsRatio);
      
      this.agentInteractionMemory.put(base/normal, origin);
      
      // This puts the base in the agent memory
      if(this.agentPerAgentMemory.get(origin) == null) this.agentPerAgentMemory.put(origin, base/this.agentPerAgentMemory.size());
      else {
        this.agentPerAgentMemory.put(origin, (this.agentPerAgentMemory.get(origin) + base)/this.agentPerAgentMemory.size()+1);
      }
      
    }
    
    return soundSend;
  } //<>// //<>// //<>// //<>// //<>//
  
}
