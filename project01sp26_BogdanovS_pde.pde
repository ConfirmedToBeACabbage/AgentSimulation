Agent human; 
Agent humanbaby;

GenericStack<Agent> agentStack = new GenericStack<Agent>(10); 
Agent popped; 

void setup() {
  size(860, 860);
  //human = new Human(width/2, height/2, 0.01, 40);
  //humanbaby = new HumanBaby(width/2, height/2, 0.0001);
  
  for(int i = 0; i < 5; i++) {
    agentStack.push(new Human(width/2, height/2, 0.01, 40));
  }
  
  popped = agentStack.pop();
  popped.soundIntensity(200); // Simple mechanic of setting the intensity of the sound
}

void draw() {
  background(204);
  popped.soundOut();
  popped.update();
  popped.display();
}

interface Stack<T> {
  void push(T item);
  T pop();
  boolean isEmpty();
  int size();
}

class GenericStack<T> implements Stack<T> {
  private T[] stack;
  private int top;
  private int capacity;
  
  GenericStack(int cap) {
    this.capacity = cap;
    this.stack = (T[]) new Object[capacity];
    this.top = -1;
  }
  
  @Override
  void push(T item) {
    if (top == capacity - 1) {
      throw new StackOverflowError("Stack is full"); 
    }
    stack[++top] = item;
  }
  
  @Override 
  T pop(){
    if(isEmpty()){
      throw new IllegalStateException("Stack is empty"); 
    }
    return stack[top--];
  }
  
  @Override 
  boolean isEmpty(){
    return top == -1;
  }
  
  @Override 
  int size() {
   return top + 1; 
  }
  
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
    green = random(200, 255);
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
      y = constrain(y + direction_choose_y, 0, 860);
      
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

class HumanBaby extends Agent {
  HumanBabyEye centereye;
  HumanBabyHat tophat;
  int dim;
  
  HumanBaby(float xpos, float ypos, float s) { 
    super(xpos, ypos, s);
    centereye = new HumanBabyEye(this, 10);
    tophat = new HumanBabyHat(this);
    dim = 20;
  } 
  
  @Override 
  void display() {
    stroke(1);
    fill(red, blue, green);
    pushMatrix();
    translate(x, y);
    circle(0, 0, dim);
    popMatrix();
    centereye.display();
    tophat.display();
  }
}

class HumanBabyHat {
   float x1, y1, x2, y2, x3, y3;
   float red, blue, green;
   HumanBaby parentReference;
   HumanBabyHat(HumanBaby reference){
     parentReference = reference;
     red = random(0, 255);
     blue = random(0, 255);
     green = random(0, 255);
   }
   
   void display(){
    stroke(1);
    fill(red, blue, green);
    pushMatrix(); 
    x1 = parentReference.x-parentReference.dim+4;
    y1 = parentReference.y-10;
    x2 = parentReference.x;
    y2 = parentReference.y-20;
    x3 = parentReference.x+parentReference.dim-4;
    y3 = parentReference.y-10;
    triangle(x1, y1, x2, y2, x3, y3);
    popMatrix();
   }
}

class HumanBabyEye { 
  int size;
  float blink_await, blink_await_counter, blink_height, blink_direction, blink_closed_flag; 
  float eye_move;
  int eye_maximum_move, eye_counter_moved, eye_switch, eye_side_choice, eye_pause; 
  HumanBaby parentReference; 
  HumanBabyEye(HumanBaby reference, int sizeP){
    size = sizeP;
    parentReference = reference;
    blink_direction = 0;
    blink_await = 0;
    blink_height = size;
    blink_closed_flag = 0;
    eye_maximum_move = int((sizeP/(sizeP*0.01))/3);
    eye_counter_moved = 0;
    eye_switch = 0;
    eye_side_choice = int(random(0, 2));
    eye_pause = 0;
    eye_move = 0;
  }
  void display() {
    stroke(1);
    pushMatrix(); 
    translate(parentReference.x, parentReference.y);
    
    if(blink_await_counter != blink_await){
     blink_await_counter += 1; 
    } else {
      
      blink_height += (blink_direction == 0) ? -0.5 : 0.5;
      
      if(blink_height <= 0){
        blink_direction = 1; 
        blink_closed_flag = 1;
      } else if (blink_height >= size){
        blink_direction = 0;
        if(blink_closed_flag == 1){
          blink_await = int(random(60, 90));
          blink_await_counter = 0;
          blink_closed_flag = 0;
        }
      }
    }
   
    ellipse(0, 0, size, blink_height);
    popMatrix();
    
    pushMatrix();
    if(eye_pause < 60) {
     eye_pause += 1; 
    } 
    
    if (eye_pause == 60) {
      if(eye_counter_moved >= eye_maximum_move) {
        eye_switch = 1;
      } else if (eye_counter_moved < 0){
        eye_switch = 0;
        eye_side_choice = int(random(0, 2));
        eye_pause = 0;
      }
    
      if(eye_switch == 1){
        eye_counter_moved -= 1;  
        eye_move += (eye_move > 0) ? -size*0.01 : size*0.01; 
      } else if(eye_switch == 0){
        eye_counter_moved += 1;
        eye_move += (eye_side_choice == 0) ? size*0.01 : -size*0.01;
      }
    }
   
    translate(parentReference.x+eye_move, parentReference.y);
    ellipse(0, 0, size*0.1, size*0.1); 
    popMatrix();  
  }
  
}

class Human extends Agent { 

  float dim;
  HumanArm leftarm, rightarm;
  HumanEye lefteye, righteye;
  HumanFoot leftfoot, rightfoot;
  
  Human(float xpos, float ypos, float s, float d) { 
    super(xpos, ypos, s);
    leftarm = new HumanArm(this, 25, 0, 0.5);
    rightarm = new HumanArm(this, 25, 1, 0.5);
    lefteye = new HumanEye(this, 10, 0);
    righteye = new HumanEye(this, 10, 1);
    leftfoot = new HumanFoot(this, 20, 0, 0.5);
    rightfoot = new HumanFoot(this, 20, 1, 0.5);
    dim = d;
  } 
  
  @Override 
  void display() {
    noStroke();
    fill(red, blue, green);
    pushMatrix();
    translate(x, y);
    rect(0, 0, dim, dim, 28);
    popMatrix();
    leftarm.display();
    rightarm.display();
    lefteye.display();
    righteye.display();
    leftfoot.display();
    rightfoot.display();
  }
} 

class HumanArm { 
  int size, side;
  float bob_speed, rotation, max_rotation; 
  Human parentReference; 
  HumanArm(Human reference, int sizeP, int sideP, float bobSpeedP){
    size = sizeP;
    parentReference = reference;
    side = sideP;
    bob_speed = bobSpeedP;
    rotation = 0;
  }
  void display() {
    stroke(1);
    pushMatrix(); 
    
    if(side == 0) translate(parentReference.x-8, parentReference.y+10);
    else if(side == 1) translate(parentReference.x+parentReference.dim+2, parentReference.y+10);
    
    if(parentReference.idle == false) {
      if(parentReference.direction_choose_x >= 0){
        max_rotation = bob_speed;
        rotation += 0.01;
        rotation = constrain(rotation, 0, max_rotation);
      }
      else if(parentReference.direction_choose_y <= 0) {
        max_rotation = -bob_speed;
        rotation -= 0.01;
        rotation = constrain(rotation, max_rotation, 0);
      }
    } else if (parentReference.idle == true) {
      rotation += (rotation > 0) ? -0.01 : 0.01; 
    }
    
    rotate(rotation);
    rect(0, 0, size * 0.2, size * 0.9, 28);
    popMatrix();
  }
} 

class HumanEye { 
  int size, side;
  float blink_await, blink_await_counter, blink_height, blink_direction, blink_closed_flag; 
  float eye_move;
  int eye_maximum_move, eye_counter_moved, eye_switch, eye_side_choice, eye_pause; 
  Human parentReference; 
  HumanEye(Human reference, int sizeP, int sideP){
    size = sizeP;
    parentReference = reference;
    side = sideP;
    blink_direction = 0;
    blink_await = 0;
    blink_height = size;
    blink_closed_flag = 0;
    eye_maximum_move = int((sizeP/(sizeP*0.01))/3);
    eye_counter_moved = 0;
    eye_switch = 0;
    eye_side_choice = int(random(0, 2));
    eye_pause = 0;
    eye_move = 0;
  }
  void display() {
    stroke(1);
    pushMatrix(); 
    
    if(side == 0) translate(parentReference.x+6, parentReference.y+15);
    else if(side == 1) translate(parentReference.x+parentReference.dim-6, parentReference.y+15);
    
    if(blink_await_counter != blink_await){
     blink_await_counter += 1; 
    } else {
      
      blink_height += (blink_direction == 0) ? -0.5 : 0.5;
      
      if(blink_height <= 0){
        blink_direction = 1; 
        blink_closed_flag = 1;
      } else if (blink_height >= size){
        blink_direction = 0;
        if(blink_closed_flag == 1){
          blink_await = int(random(60, 90));
          blink_await_counter = 0;
          blink_closed_flag = 0;
        }
      }
    }
    
    ellipse(0, 0, size, blink_height);
    
    popMatrix();
    
    pushMatrix();
    if(eye_pause < 60) {
     eye_pause += 1; 
    } 
    
    if (eye_pause == 60) {
      if(eye_counter_moved >= eye_maximum_move) {
        eye_switch = 1;
      } else if (eye_counter_moved < 0){
        eye_switch = 0;
        eye_side_choice = int(random(0, 2));
        eye_pause = 0;
      }
    
      if(eye_switch == 1){
        eye_counter_moved -= 1;  
        eye_move += (eye_move > 0) ? -size*0.01 : size*0.01; 
      } else if(eye_switch == 0){
        eye_counter_moved += 1;
        eye_move += (eye_side_choice == 0) ? size*0.01 : -size*0.01;
      }
    }
   
    if(side == 0) translate(parentReference.x+6+eye_move, parentReference.y+15);
    else if(side == 1) translate(parentReference.x+parentReference.dim-6-size*0.1+eye_move, parentReference.y+15);
    ellipse(0, 0, size*0.1, size*0.1); 
    popMatrix();  
  }
  
}

class HumanFoot { 
  int size, side;
  float bob_speed, rotation, max_rotation; 
  Human parentReference; 
  HumanFoot(Human reference, int sizeP, int sideP, float bobSpeedP){
    size = sizeP;
    parentReference = reference;
    side = sideP;
    bob_speed = bobSpeedP;
    rotation = 0;
  }
  void display() {
    stroke(1);
    pushMatrix(); 
    
    if(side == 0) translate(parentReference.x-6, parentReference.y+parentReference.dim+1);
    else if(side == 1) translate(parentReference.x+parentReference.dim-10, parentReference.y+parentReference.dim+1);
    
    if(parentReference.idle == false) {
      if(parentReference.direction_choose_x >= 0){
        max_rotation = bob_speed;
        rotation += 0.01;
        rotation = constrain(rotation, 0, max_rotation);
      }
      else if(parentReference.direction_choose_y <= 0) {
        max_rotation = -bob_speed;
        rotation -= 0.01;
        rotation = constrain(rotation, max_rotation, 0);
      }
    } else if (parentReference.idle == true) {
      rotation += (rotation > 0) ? -0.01 : 0.01; 
    }
    
    rotate(rotation);
    rect(0, 0, size, size * 0.4, 28);
    popMatrix();
  }
} 
