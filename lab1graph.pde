int radius = 100;  
float tangentLength = 200;  
PVector[] tangentPoints = new PVector[4];  
PVector[] tangentStarts = new PVector[4];  
PVector[] tangentEnds = new PVector[4];  
PVector[] currentPoints = new PVector[4];  
float[] progresses = new float[4];  
boolean[] tangentsDone = new boolean[4]; 
int numTangents = 0; 

void setup() {
  size(400, 400);
  background(255); 
  translate(width / 2, height / 2);

  stroke(0);
  strokeWeight(2);
  ellipse(0, 0, radius * 2, radius * 2);

  for (int i = 0; i < 4; i++) {
    float angle = PI / 4 + i * (PI / 2);  
    tangentPoints[i] = new PVector(radius * cos(angle), radius * sin(angle));
    PVector direction = new PVector(-sin(angle), cos(angle));  
    tangentStarts[i] = PVector.add(tangentPoints[i], PVector.mult(direction, -tangentLength / 2));
    tangentEnds[i] = PVector.add(tangentPoints[i], PVector.mult(direction, tangentLength / 2));
    currentPoints[i] = tangentStarts[i].copy(); 
    progresses[i] = 0;  
    tangentsDone[i] = false;  
  }
}

void draw() {
  translate(width / 2, height / 2);

  stroke(255, 0, 0);  
  strokeWeight(3);

  for (int i = 0; i < numTangents + 1; i++) {
    if (progresses[i] <= 1) {
      currentPoints[i].x = lerp(tangentStarts[i].x, tangentEnds[i].x, progresses[i]);
      currentPoints[i].y = lerp(tangentStarts[i].y, tangentEnds[i].y, progresses[i]);
      line(tangentStarts[i].x, tangentStarts[i].y, currentPoints[i].x, currentPoints[i].y);
      progresses[i] += 0.01; 
    } else {
      tangentsDone[i] = true;  
    }
  }

  if (tangentsDone[numTangents] && numTangents < 3) {
    numTangents++;  
  }
}
