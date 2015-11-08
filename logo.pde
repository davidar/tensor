final int UNIT = 500;
final int SIZE = (int)(UNIT * (1 + sqrt(2)));
final float A = sqrt(0.5);
final float B = sqrt(2);
final float C = 1 + sqrt(0.5);
final float D = 1 + sqrt(2);

void settings() {
  size(SIZE, SIZE);
}

void setup() {
  background(0, 0);
  noStroke();
  blendMode(ADD);
  scale(UNIT);
  colorMode(HSB, 1.0);
  
  // /
  //
  fill(0, 1, 0.25);
  beginShape();
  vertex(A,0);
  vertex(C,0);
  vertex(C,1);
  vertex(1,C);
  vertex(0,C);
  vertex(0,A);
  endShape(CLOSE);
  
  //  -
  //
  fill(0.125, 1, 0.25);
  beginShape();
  vertex(A,0);
  vertex(C,0);
  vertex(D,A);
  vertex(C,B);
  vertex(A,B);
  vertex(0,A);
  endShape(CLOSE);
  
  //   \
  //
  fill(0.25, 1, 0.25);
  beginShape();
  vertex(A,0);
  vertex(C,0);
  vertex(D,A);
  vertex(D,C);
  vertex(B,C);
  vertex(A,1);
  endShape(CLOSE);
  
  //   |
  //   |
  fill(0.375, 1, 0.25);
  beginShape();
  vertex(C,0);
  vertex(D,A);
  vertex(D,C);
  vertex(C,D);
  vertex(1,C);
  vertex(1,A);
  endShape(CLOSE);
  
  //
  //   /
  fill(0.5, 1, 0.25);
  beginShape();
  vertex(D,A);
  vertex(D,C);
  vertex(C,D);
  vertex(A,D);
  vertex(A,B);
  vertex(B,A);
  endShape(CLOSE);
  
  //
  //  -
  fill(0.625, 1, 0.25);
  beginShape();
  vertex(0,C);
  vertex(A,1);
  vertex(C,1);
  vertex(D,C);
  vertex(C,D);
  vertex(A,D);
  endShape(CLOSE);
  
  //
  // \
  fill(0.75, 1, 0.25);
  beginShape();
  vertex(A,D);
  vertex(C,D);
  vertex(C,B);
  vertex(1,A);
  vertex(0,A);
  vertex(0,C);
  endShape(CLOSE);
  
  // |
  // |
  fill(0.875, 1, 0.25);
  beginShape();
  vertex(A,0);
  vertex(B,A);
  vertex(B,C);
  vertex(A,D);
  vertex(0,C);
  vertex(0,A);
  endShape(CLOSE);
  
  save("logo.png");
}