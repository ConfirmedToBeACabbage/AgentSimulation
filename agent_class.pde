abstract class Agent {
  float x, y, speed;
  float direction_choose_x, direction_choose_y, moving_time, idle_time;
  boolean idle;
  float red, blue, green;
  
  SoundWave agentSound = new SoundWave(this);
  
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
        direction_choose_y = random(-1, direction_choose_x);
     
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
  
  void soundOut() {
    agentSound.update();
    agentSound.display();
  }
  
  void soundIntensity(int intensity){
    agentSound.setIntensity(intensity); 
  }
  
  abstract void display();
}

class SoundWave { 
  float x, y; 
  float curr_size;
  float intensity, maxInt;
  int reverse = 0;
  
  Agent referenceParent;
  SoundWave(Agent referenceParentP){
    intensity = 0;
    referenceParent = referenceParentP;
  }
  
  void setIntensity(int intensityP) {
    maxInt = intensityP;
    reverse = 0;
  }
  
  void update(){
   if(intensity == maxInt) reverse = 1;
   if(reverse == 1 && intensity != 0) {
     intensity -= 1;
   } else {
     intensity += 1; 
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
