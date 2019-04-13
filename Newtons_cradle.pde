color c = color(0);color[] mycolours = {color(0,255,255),color(255,191,0),color(255,0,255),color(255,255,0),color(64,255,0)};
float x = 50;
float y = 50;
PVector g = new PVector(0,.98);
float dt = 0.2;
float t = 0;
float l = 200;
float h = 200;
float radius = 15;
int checker =1;
PVector[] r = new PVector[11];
PVector[] v = new PVector[11];
float w[]={0,0,0,0,0,0,0,0,0,0,0};
Table table;


void setup() {
  size(500,500);
  table = new Table();
    table.addColumn("time");
  table.addColumn("ke");
r[1] = new PVector(250-4*radius, 50);
r[2] = new PVector(250-2*radius, 50);
r[3] = new PVector(250, 50);
r[4] = new PVector(250+2*radius, 50);
r[5] = new PVector(250+4*radius, 50);
r[6] = new PVector(250-4*radius, 50+l);
r[7] = new PVector(250-2*radius, 50+l);
r[8] = new PVector(250, 50+l);
r[9] = new PVector(250+2*radius, 50+l);
r[10] =PVector.add(r[5],(PVector.sub(new PVector(250+4*radius, 50+l),r[5])).rotate(-PI/6));
v[10] = new PVector(0, 0);
v[9] = new PVector(0, 0);
v[8] = new PVector(0, 0);
v[7] = new PVector(0, 0);
v[6] = new PVector(0, 0);
}

void draw() {
  background(255);
  moveposition();
  move();
  checkcollision();
  display();
  saveFrame("output/task7_####.jpg");
  t=t+dt;
}

void move() {
  PVector[] rrel =new PVector[11];
  float[] alpha = {0,0,0,0,0,0,0,0,0,0,0};
  float ke = 0;
  for (int i=10;i>5;i--){
    rrel[i] = PVector.sub(r[i], r[i-5]);
    alpha[i] = (1/l)*(g.cross((rrel[i]).normalize())).dot(new PVector (0,0,-1));
    w[i] += alpha[i]*dt;
    v[i].x=-w[i]*l*((g.normalize()).dot((rrel[i]).normalize()));
    v[i].y=+w[i]*l*(((g.normalize()).cross((rrel[i]).normalize())).mag());
    ke=ke+(v[i].x*v[i].x+v[i].y*v[i].y);
  }
  System.out.println (ke);

  
  TableRow newRow = table.addRow();
  newRow.setFloat("time", t);
  newRow.setFloat("ke", ke);
  
  saveTable(table, "data/new.csv");
}

void moveposition() {
  for (int i=10;i>5;i--){
    r[i].add(PVector.mult(v[i], dt));
    r[i] = PVector.add(r[i-5],PVector.mult(((PVector.sub(r[i],r[i-5])).normalize()),l));
  }
}

void checkcollision() {
  if (checker==1){
  leftsequence();
  }
  if(checker==-1){
  rightsequence();
  }
}

void leftsequence() {
  for (int i=10;i>6;i--){
    if ((PVector.sub(r[i],r[i-1])).mag()<2*radius){
    collisionresponse(i,i-1);
    if (i==7){
     checker=-1;
     }
  }
  }
}

void rightsequence() {
  for (int i=6;i<10;i++){
    if ((PVector.sub(r[i],r[i+1])).mag()<2*radius){
    collisionresponse(i,i+1);
    if (i==9){
     checker=1;
     }
  }
  }
}

void collisionresponse(int p1,int p2) {
  PVector relr = (PVector.sub(r[p1],r[p2]));
  //System.out.println (relr);
  float df = relr.mag();
  PVector relr1 = PVector.mult((PVector.sub(r[p1],r[p2])).normalize(),((2*radius)-df));
    //System.out.println (r[p1]);
    //System.out.println (r[p2]);
    //System.out.println (relr);
    // System.out.println (relr1);
  PVector rdummy1=PVector.add(r[p1],PVector.mult(relr1,(v[p1].dot((PVector.sub(r[p1],r[p2])).normalize()))/((PVector.sub(v[p1],v[p2])).dot((PVector.sub(r[p1],r[p2])).normalize()))));
  PVector rdummy2=PVector.sub(r[p2],PVector.mult(relr1,(v[p2].dot((PVector.sub(r[p1],r[p2])).normalize()))/((PVector.sub(v[p1],v[p2])).dot((PVector.sub(r[p1],r[p2])).normalize()))));

  if ((PVector.sub(rdummy1,rdummy2)).mag()<2*radius){
    r[p1].sub(PVector.mult(relr1,(v[p1].dot((PVector.sub(r[p1],r[p2])).normalize()))/((PVector.sub(v[p1],v[p2])).dot((PVector.sub(r[p1],r[p2])).normalize()))));
    r[p2].add(PVector.mult(relr1,(v[p2].dot((PVector.sub(r[p1],r[p2])).normalize()))/((PVector.sub(v[p1],v[p2])).dot((PVector.sub(r[p1],r[p2])).normalize()))));
    
  }
  else{
    r[p1]=rdummy1;
    r[p2]=rdummy2;
  }
  if (PVector.sub(v[p1],v[p2]).dot(relr.normalize())>0){
  PVector store =v[p1];
  v[p1]=v[p2];
  v[p2] = store;
  }
  else{
  PVector store =v[p1];
  v[p1]=v[p2];
  v[p2] = store;
  }
//System.out.println (v[p1]);
//System.out.println (v[p2]);
  w[p1]=checker*(1/l)*(float)Math.sqrt( ((v[p1].magSq())-(v[p1].dot((PVector.sub(r[p1],r[p1-5])).normalize()))*(v[p1].dot((PVector.sub(r[p1],r[p1-5])).normalize()))));
  w[p2]=checker*(1/l)*(float)Math.sqrt( ((v[p2].magSq())-(v[p2].dot((PVector.sub(r[p2],r[p2-5])).normalize()))*(v[p2].dot((PVector.sub(r[p2],r[p2-5])).normalize()))));
}



void display() {
  for (int i=10;i>5;i--){
  fill(mycolours[i-6]);
  ellipse(r[i].x,r[i].y,2*radius,2*radius);
  ellipse(r[i-5].x,r[i-5].y,2*radius/5,2*radius/5);
  line(r[i-5].x,r[i-5].y,r[i].x,r[i].y);
  } 
}
