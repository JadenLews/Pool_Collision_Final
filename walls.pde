class wall{
// Position of left hand side of floor
PVector base1;
// Position of right hand side of floor
PVector base2;
// Length of floor
float baseLength;

// An array of subpoints along the floor path
PVector[] coords;

// Variables related to moving ball
PVector position;
PVector velocity;
float r;
float speed = 3.5;
void setting(PVector one, PVector two){
  base1 = one;
  base2 = two;
}
void collide(Ball ball) {
  createGround();

  // start ellipse at middle top of screen
  position = ball.position;
  r = ball.radius;

  // calculate initial random velocity
  velocity = ball.velocity;
}

void check(Ball ball) {
  // calculate base top normal
  PVector baseDelta = PVector.sub(base2, base1);
  baseDelta.normalize();
  PVector normal = new PVector(-baseDelta.y, baseDelta.x);

  // normalized incidence vector
  PVector incidence = PVector.mult(velocity, -1);
  //incidence.normalize();

  // detect and handle collision
  if (ball.grace <= 0){
  for (int i=0; i<coords.length; i++) {
    // check distance between ellipse and base top coordinates
    if (PVector.dist(position, coords[i]) < r) {
      ball.grace = 8;

      // calculate dot product of incident vector and base top normal 
      float dot = incidence.dot(normal);

      // calculate reflection vector
      // assign reflection vector to direction vector
       ball.velocity.set((2*normal.x*dot - incidence.x), (2*normal.y*dot - incidence.y), 0);
      ball.position = new PVector(ball.position.x, ball.position.y);
    }
  }
  }
  else{
  }
}


// Calculate variables for the ground
void createGround() {
  // calculate length of base top
  baseLength = PVector.dist(base1, base2);

  // fill base top coordinate array
  coords = new PVector[ceil(baseLength)];
  for (int i=0; i<coords.length; i++) {
    coords[i] = new PVector();
    coords[i].x = base1.x + ((base2.x-base1.x)/baseLength)*i;
    coords[i].y = base1.y + ((base2.y-base1.y)/baseLength)*i;
  }
}
}
