import g4p_controls.*;

int gridSize = 4; 
PVector[][] points = new PVector[gridSize][gridSize];

PVector[] curvePoints = {
  new PVector(150, -150, 30),
  new PVector(-5, 50, 140),
  new PVector(100, -100, 70),
  new PVector(-150, 10, 80)
};

GWindow winX, winY, winZ;

void setup() {
  size(600, 600, P3D);
  setupControlPoints();

  winX = GWindow.getWindow(this, "Projection on X=0", 50, 50, 400, 400, P3D);
  winX.addDrawHandler(this, "drawXProjection");

  winY = GWindow.getWindow(this, "Projection on Y=0", 500, 50, 400, 400, P3D);
  winY.addDrawHandler(this, "drawYProjection");

  winZ = GWindow.getWindow(this, "Projection on Z=0", 950, 50, 400, 400, P3D);
  winZ.addDrawHandler(this, "drawZProjection");
}

void draw() {
  background(255);
  lights();
  translate(width / 2, height / 2, -200);
  rotateX(PI / 4);
  rotateY(PI / 4);

  drawSurface();  
  drawCurve(color(255, 0, 0)); 
}

void setupControlPoints() {
  float spacing = 100;
  for (int i = 0; i < gridSize; i++) {
    for (int j = 0; j < gridSize; j++) {
      float x = (i - gridSize / 2) * spacing;
      float y = (j - gridSize / 2) * spacing;
      float z = random(-50, 50); 
      points[i][j] = new PVector(x, y, z);
    }
  }
}

void drawSurface() {
  int resolution = 20;
  fill(200); 
  noStroke();
  for (float u = 0; u <= 1; u += 1.0 / resolution) {
    beginShape(TRIANGLE_STRIP);
    for (float v = 0; v <= 1; v += 1.0 / resolution) {
      PVector p1 = evaluateBicubic(u, v);
      PVector p2 = evaluateBicubic(u + 1.0 / resolution, v);
      vertex(p1.x, p1.y, p1.z);
      vertex(p2.x, p2.y, p2.z);
    }
    endShape();
  }
}

PVector evaluateBicubic(float u, float v) {
  float[] Bu = bernstein(u);
  float[] Bv = bernstein(v);

  PVector p = new PVector();
  for (int i = 0; i < gridSize; i++) {
    for (int j = 0; j < gridSize; j++) {
      PVector cp = points[i][j];
      p.x += Bu[i] * Bv[j] * cp.x;
      p.y += Bu[i] * Bv[j] * cp.y;
      p.z += Bu[i] * Bv[j] * cp.z;
    }
  }
  return p;
}

void drawCurve(int clr) {
  stroke(clr);
  strokeWeight(3);
  noFill();
  
  beginShape();
  for (float t = 0; t <= 1; t += 0.01) {
    PVector p = cubicInterpolation(curvePoints, t);
    vertex(p.x, p.y, p.z);
  }
  endShape();
}

PVector cubicInterpolation(PVector[] points, float t) {
  float[] B = bernstein(t);
  
  PVector result = new PVector();
  for (int i = 0; i < points.length; i++) {
    result.x += B[i] * points[i].x;
    result.y += B[i] * points[i].y;
    result.z += B[i] * points[i].z;
  }
  return result;
}

float[] bernstein(float t) {
  return new float[] {
    (1 - t) * (1 - t) * (1 - t),
    3 * t * (1 - t) * (1 - t),
    3 * t * t * (1 - t),
    t * t * t
  };
}

void drawXProjection(PApplet appc, GWinData data) {
  appc.background(255);
  appc.lights();
  appc.translate(appc.width / 2, appc.height / 2);
  appc.rotateY(PI / 2); 
  drawSurfaceInWindow(appc);
  drawCurveInWindow(appc, color(0, 0, 255)); 
}

// Проекція на площину Y = 0
void drawYProjection(PApplet appc, GWinData data) {
  appc.background(255);
  appc.lights();
  appc.translate(appc.width / 2, appc.height / 2);
  appc.rotateX(PI / 2); 
  drawSurfaceInWindow(appc);
  drawCurveInWindow(appc, color(0, 255, 0)); 
}

void drawZProjection(PApplet appc, GWinData data) {
  appc.background(255);
  appc.lights();
  appc.translate(appc.width / 2, appc.height / 2);
  drawSurfaceInWindow(appc); 
  drawCurveInWindow(appc, color(255, 0, 0)); 
}

void drawSurfaceInWindow(PApplet appc) {
  int resolution = 20;
  appc.fill(200); 
  appc.noStroke();
  appc.beginShape(TRIANGLE_STRIP);
  for (float u = 0; u <= 1; u += 1.0 / resolution) {
    for (float v = 0; v <= 1; v += 1.0 / resolution) {
      PVector p1 = evaluateBicubic(u, v);
      PVector p2 = evaluateBicubic(u + 1.0 / resolution, v);
      appc.vertex(p1.x, p1.y, p1.z);
      appc.vertex(p2.x, p2.y, p2.z);
    }
  }
  appc.endShape();
}

void drawCurveInWindow(PApplet appc, int clr) {
  appc.stroke(clr);
  appc.strokeWeight(3);
  appc.noFill();
  
  appc.beginShape();
  for (float t = 0; t <= 1; t += 0.01) {
    PVector p = cubicInterpolation(curvePoints, t);
    appc.vertex(p.x, p.y, p.z);
  }
  appc.endShape();
}
