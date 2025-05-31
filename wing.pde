class Ball {
   PVector HTL = new PVector(100, 100);
  PVector HTM = new PVector(500, 75);
  PVector HTR = new PVector(900, 100);
  PVector HBL = new PVector(100, 500);
  PVector HBR = new PVector(900, 500);
  PVector HBM = new PVector(500, 525);
  PVector position;
  public PVector velocity;
  boolean ontable = true;
  public String team = "";
  int grace = 0;
  int red;
  int green;
  int blue;

  public float radius, m;
  public boolean click = true;

  Ball(float x, float y, float r_, int red, int green, int blue, int team) {
    position = new PVector(x, y);
    PVector velo = new PVector(0, 0);
    //velocity = PVector.random2D();
    velocity = velo;
    velocity.mult(3);
    radius = r_;
    m = radius*.1;
    this.red = red;
    this.green = green;
    this.blue = blue;
    this.team += team;
  }

  void update() {
    position.add(velocity);
    velocity = new PVector(velocity.x * .985, velocity.y * .985);
    if (velocity.x == 0 && velocity.y == 0){
      click = true;
    }
    else{
      click = false;
    }
  }

  boolean checkBoundaryCollision(Ball[] balls, Ball ball) {
    PVector distV1 = PVector.sub(ball.position , HTL);
    float dist1 = distV1.mag();
    
    PVector distV2 = PVector.sub(ball.position , HTM);
    float dist2 = distV2.mag();
    
    PVector distV3 = PVector.sub(ball.position , HTR);
    float dist3 = distV3.mag();
    
    PVector distV4 = PVector.sub(ball.position , HBL);
    float dist4 = distV4.mag();
    
    PVector distV5 = PVector.sub(ball.position , HBR);
    float dist5 = distV5.mag();
    
    PVector distV6 = PVector.sub(ball.position , HBM);
    float dist6 = distV6.mag();
    float radius = ball.radius * 1.5;
    if (dist1 < radius || dist2 < radius || dist3 < radius || dist4 < radius || dist5 < radius || dist6 < radius){
      if (ball == balls[0]){
        balls[0].ontable = false;
        ball.velocity = new PVector(0, 0);
        return false;
      }
      else{
      ball.ontable = false;
      return true;
      }
    }
    if (velocity.x < .01 && velocity.y < .01 && velocity.x > -.01 && velocity.x > -.01){
      click = true;
    }
    else{
      click = false;
    }
    return false;
  }

  void checkCollision(Ball other) {

    // Get distances between the balls components
    PVector distanceVect = PVector.sub(other.position, position);

    // Calculate magnitude of the vector separating the balls
    float distanceVectMag = distanceVect.mag();

    // Minimum distance before they are touching
    float minDistance = radius + other.radius;

    if (distanceVectMag < minDistance) {
      float distanceCorrection = (minDistance-distanceVectMag)/2.0;
      PVector d = distanceVect.copy();
      PVector correctionVector = d.normalize().mult(distanceCorrection);
      other.position.add(correctionVector);
      position.sub(correctionVector);

      // get angle of distanceVect
      float theta  = distanceVect.heading();
      // precalculate trig values
      float sine = sin(theta);
      float cosine = cos(theta);

      /* bTemp will hold rotated ball positions. You 
       just need to worry about bTemp[1] position*/
      PVector[] bTemp = {
        new PVector(), new PVector()
      };

      /* this ball's position is relative to the other
       so you can use the vector between them (bVect) as the 
       reference point in the rotation expressions.
       bTemp[0].position.x and bTemp[0].position.y will initialize
       automatically to 0.0, which is what you want
       since b[1] will rotate around b[0] */
      bTemp[1].x  = cosine * distanceVect.x + sine * distanceVect.y;
      bTemp[1].y  = cosine * distanceVect.y - sine * distanceVect.x;

      // rotate Temporary velocities
      PVector[] vTemp = {
        new PVector(), new PVector()
      };

      vTemp[0].x  = cosine * velocity.x + sine * velocity.y;
      vTemp[0].y  = cosine * velocity.y - sine * velocity.x;
      vTemp[1].x  = cosine * other.velocity.x + sine * other.velocity.y;
      vTemp[1].y  = cosine * other.velocity.y - sine * other.velocity.x;

      /* Now that velocities are rotated, you can use 1D
       conservation of momentum equations to calculate 
       the final velocity along the x-axis. */
      PVector[] vFinal = {  
        new PVector(), new PVector()
      };

      // final rotated velocity for b[0]
      vFinal[0].x = ((m - other.m) * vTemp[0].x + 2 * other.m * vTemp[1].x) / (m + other.m);
      vFinal[0].y = vTemp[0].y;

      // final rotated velocity for b[0]
      vFinal[1].x = ((other.m - m) * vTemp[1].x + 2 * m * vTemp[0].x) / (m + other.m);
      vFinal[1].y = vTemp[1].y;

      // hack to avoid clumping
      //bTemp[0].x += vFinal[0].x;
      //bTemp[1].x += vFinal[1].x;

      /* Rotate ball positions and velocities back
       Reverse signs in trig expressions to rotate 
       in the opposite direction */
      // rotate balls
      PVector[] bFinal = { 
        new PVector(), new PVector()
      };

      bFinal[0].x = cosine * bTemp[0].x - sine * bTemp[0].y;
      bFinal[0].y = cosine * bTemp[0].y + sine * bTemp[0].x;
      bFinal[1].x = cosine * bTemp[1].x - sine * bTemp[1].y;
      bFinal[1].y = cosine * bTemp[1].y + sine * bTemp[1].x;

      // update balls to screen position
      other.position.x = position.x + bFinal[1].x;
      other.position.y = position.y + bFinal[1].y;

      position.add(bFinal[0]);

      // update velocities
      velocity.x = cosine * vFinal[0].x - sine * vFinal[0].y;
      velocity.y = cosine * vFinal[0].y + sine * vFinal[0].x;
      other.velocity.x = cosine * vFinal[1].x - sine * vFinal[1].y;
      other.velocity.y = cosine * vFinal[1].y + sine * vFinal[1].x;
      //check new velo for both
      if (velocity.x == 0 && velocity.y == 0){
      click = true;
    }
    else{
      click = false;
    }
    //other ball
    if (other.velocity.x == 0 && other.velocity.y == 0){
      other.click = true;
    }
    else{
      other.click = false;
    }
    //fix clumping
    float deltax = other.position.x - this.position.x;
    float deltay = other.position.y - this.position.y;
    double deltac = Math.sqrt((deltax * deltax) + (deltay * deltay));
    PVector distt = new PVector(deltax, deltay);
    float womp = (float)deltac;
    float amount = Math.abs(minDistance / womp);
    //amount = amount / 1.8;
    other.position = new PVector(this.position.x + (amount * deltax), this.position.y + (amount * deltay));
    }
  }

  void display() {
    noStroke();
    fill(red, green, blue);
    ellipse(position.x, position.y, radius*2, radius*2);
    fill(255);
    textSize(25);
    text( this.team, this.position.x - 5, this.position.y + 5);  
  }
}
