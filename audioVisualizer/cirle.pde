

class Circle implements visualizer
{
  Circle()
  {
  }
  void draw(ArrayList<Float> specList, float size)
  {
    float fromRad = HALF_PI;
    noFill();
    for(int i=0; i<specList.size(); i++)
    {
      float t = specList.get(i);
      t *= size;
      float toRad = fromRad + PI/specList.size();
      int h = (int)map(i, 0, specList.size()-1, 0, 255);
      stroke(h, 255, 255, 255);
      arc(0, 0, t, t, fromRad, toRad);
      fromRad = toRad;
    }
    
    fromRad = -HALF_PI;
    for(int i=specList.size()-1; 0<=i; i--)
    {
      float t = specList.get(i);
      t *=size;
      float toRad = fromRad + PI/specList.size();
      int h = (int)map(i, 0, specList.size()-1, 0, 255);
      stroke(h, 255, 255, 255);
      arc(0, 0, t, t, fromRad, toRad);
      fromRad = toRad;
    }
  }
}
