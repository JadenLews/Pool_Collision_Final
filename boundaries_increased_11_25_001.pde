/**
 * Circle Collision with Swapping Velocities
 * by Ira Greenberg. 
 * 
 * Based on Keith Peter's Solution in
 * Foundation Actionscript Animation: Making Things Move!
 */
 
Ball[] balls =  { 
  new Ball(200, 400, 20), 
  new Ball(400, 100, 20) 
};

void setup() {
  size(800, 500);
}

void draw() {
  background(51);
  
  stroke(255); // Set the stroke color to white
  line(50, 50, 50, 450);
  //line(50, 50, 750, 50);
  line(50, 50, 300, 50);
  line(500, 50, 750, 50);
  // diagonal lines
  line(300, 50, 300, 0);
  line(300, 0, 500, 0);
  line(500, 0, 500, 50);
  
  line(50, 450, 750, 450);
  line(750, 50, 750, 450);

  for (Ball b : balls) {
    b.update();
    b.display();
    b.checkBoundaryCollision();
  }
  
  balls[0].checkCollision(balls[1]);
}
