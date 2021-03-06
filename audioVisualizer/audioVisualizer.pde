/**
 * 総合コンテンツ製作サークルで作成した、オーディオビジュアライザ
 * Author: Kuyuri Iroha (https://kuyri-iroha.com)
 *         さいとー (@oshakusomegane)
 *         ちゃんふり (@May_ple_T)
 * Date: July. 27, 2018
 */


void initDraw()
{
  translate(width/2, height/2);
}

SpectrumAnalyzer spec = new SpectrumAnalyzer();

void setup()
{
  size(800, 800);
  colorMode(HSB, 255);
  frameRate(60);
  
  spec.init(this, "ここに音声ファイル名");
}
Circle circle = new Circle();

void draw()
{
  background(0, 0, 15);
  initDraw();
  
  if(spec.isPlaying() == false)
  {
    spec.play();
  }
  
  ArrayList<Float> spectrum = spec.getSpectrum();
  
  translate(-width/2, -height/2);
  float circleSize = 100;
  for(int i=0; i<8; i++)
  {
    pushMatrix();
    translate((width/2)+cos(TAU/8 * i) * circleSize, (height/2)+sin(TAU/8 * i) * circleSize);
    rotate(-HALF_PI + TAU/8 * i);
    circle.draw(spectrum, 300);
    popMatrix();
  }
}
