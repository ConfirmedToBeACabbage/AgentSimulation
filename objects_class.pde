interface Object { 
  void display();
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
      float offsetX = random(-3, 3);
      float offsetY = random(-3, 3);
      float xnext = x + cos(angle) * (dim / 2 + offsetX);
      float ynext = y + sin(angle) * (dim / 2 + offsetY);
      vertices[i] = new PVector(xnext, ynext);
    }
  }
  
  void display(){
    fill(190, 190, 190);
    beginShape();
    for(PVector v : vertices) { 
      vertex(v.x, v.y); 
    }
    endShape(CLOSE);
  }

}

class Grass implements Object { 
  float x, y, dim;
  
  Grass(float x, float y, float dim) {
    this.x = x;
    this.y = y;
    this.dim = dim;    
  }
  
  void display() {
    stroke(1);
    fill(0, 240, 0);
    pushMatrix();
    translate(x, y);
    circle(0, 0, dim);
    popMatrix();
  }
  
}
