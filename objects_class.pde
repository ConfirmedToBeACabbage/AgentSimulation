interface Object {
  String identifier();
  void display();
  float[] returnValues();
  void reset();
}

class Rock implements Object {
  float x, y, dim;
  int sides; 

  PVector[] vertices;

  Rock(float x, float y, float dim, int sides){
    this.x = x;
    this.y = y;
    this.dim = dim;
    this.sides = sides;
    
    this.vertices = new PVector[sides];
    
    for(int i = 0; i < sides; i++) {
      float angle = TWO_PI / sides * i; 
      float offsetX = random(-6, 6);
      float offsetY = random(-6, 6);
      float xnext = x + cos(angle) * (dim / 2 + offsetX);
      float ynext = y + sin(angle) * (dim / 2 + offsetY);
      vertices[i] = new PVector(xnext, ynext);
    }
  }
  
  void display(){
    fill(190, 190, 190);
    pushMatrix();
    beginShape();
    for(PVector v : vertices) { 
      vertex(v.x, v.y); 
    }
    endShape(CLOSE);
    popMatrix();
  }
  
  String identifier() { 
    return "rock"; 
  }
  
  float[] returnValues(){
    return new float[]{x, y, dim/2}; 
  }
  
  void reset(){}

}

class Food implements Object { 
  float x, y, dim;
  int sides; 

  PVector[] vertices;

  Food(float x, float y, float dim, int sides){
    this.x = x;
    this.y = y;
    this.dim = dim;
    this.sides = sides;
    
    this.vertices = new PVector[sides];
    
    for(int i = 0; i < sides; i++) {
      float angle = TWO_PI / sides * i; 
      float offsetX = random(-1, 1);
      float offsetY = random(-1, 1);
      float xnext = x + cos(angle) * (dim / 2 + offsetX);
      float ynext = y + sin(angle) * (dim / 2 + offsetY);
      vertices[i] = new PVector(xnext, ynext);
    }
  }
  
  void display(){
    fill(0, 255, 0);
    pushMatrix();
    translate(x, y);
    beginShape();
    for(PVector v : vertices) { 
      vertex(v.x, v.y); 
    }
    endShape(CLOSE);
    popMatrix();
  }
  
  String identifier() { 
    return "food"; 
  }
  
  float[] returnValues(){
    return new float[]{x, y, dim/2}; 
  }
  
  void reset(){
    this.x = random(0, 850);
    this.y = random(200, 850);
  }
  
}
