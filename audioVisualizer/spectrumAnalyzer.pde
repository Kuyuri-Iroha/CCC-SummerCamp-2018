/**
 * オーディオスペクトラムを取得する
 * 参考 : https://goo.gl/yYstJ2
 */

import ddf.minim.*;
import ddf.minim.analysis.*;


class SpectrumAnalyzer
{
  final int MAXBAND = 48;  
  Minim       minim;               //minimオブジェクト
  AudioPlayer player;              //演奏クラス
  FFT         fft;                 //FFT解析クラス
  float     specSize;              //周波数分解幅
  float     initBand;              //分解Hz
  int       stepCount;             //表示するサンプリング単位幅
  int       wakuX, wakuY;          //外枠の描画原点
  int       wakuWidth, wakuHeight; //外枠の幅と高さ
  int       barWidth;              //棒グラフの幅
  int       bandHz[] =  {   43, 43, 43, 43, 43, 43, 43, 43, 
    43, 43, 43, 43, 43, 43, 43, 43, 
    86, 86, 86, 86, 86, 86, 86, 86, 
    172, 172, 172, 172, 688, 688, 688, 688, 
    215, 215, 344, 344, 516, 516, 688, 688, 
    1032, 1032, 1204, 1376, 1548, 1720, 1892, 2064 };


  boolean isPlaying()
  {
    return player.isPlaying();
  }

  void init(Object fileSystemHandler, String audioFile)
  {
    //画面中央にスペクトルグラフを描画する
    wakuX = 10;
    wakuY = 10;
    wakuWidth = 620;
    wakuHeight = 460;


    //音楽読み込み
    minim = new Minim(fileSystemHandler);
    player = minim.loadFile(audioFile); 

    //FFT設定
    fft = new FFT( player.bufferSize(), player.sampleRate()); 

    //周波数分解幅を取得
    //全周波数を、この数の個数に分割して分析可能。通常は513
    specSize = fft.specSize();

    //HANN窓指定。minimではHAMMINGより精度が高そう・・・
    fft.window( FFT.HANN );

    //初期分解Hz(getBandWidth)を求める
    //分解幅1つ単位のHz。
    //例えば分解Hzが 43 なら、43 × 513 = 22059Hzまで解析可能
    initBand = fft.getBandWidth();

    //棒グラフの幅
    barWidth = wakuWidth / MAXBAND;
  }

  void play()
  {
    player.play();
  }

  ArrayList<Float> getSpectrum()
  {
    if ( player.isPlaying() == false )
    {
      return new ArrayList();
    }

    ArrayList<Float> res = new ArrayList<Float>();

    //FFT開始(左右混合分析)
    //左のみなら player.left、右のみなら player.right を指定
    fft.forward( player.mix );

    int ToStep = 0;      //ここから
    int FromStep = 0;    //ここまでの振幅を平均する

    //スペクトルグラフ描画
    for ( int index = 0; index < MAXBAND; index++ )
    {
      //指定されたHz単位の平均を採取するため
      //計算範囲を求める   
      int bandStep = (int)( bandHz[index] / initBand );
      if ( bandStep < 1 ) { 
        bandStep = 1;
      }

      ToStep = ToStep + Math.round( bandStep );
      if ( ToStep > specSize )
      { 
        ToStep = (int)specSize;
      }   

      //平均値を計算
      float bandAv = 0;
      for ( int j = FromStep; j < ToStep; j++ )
      {      
        //振幅をDBに変換
        float bandDB = 0; 
        if ( fft.getBand( j ) != 0 ) {   
          bandDB = 2 * ( 20 * ((float)Math.log10(fft.getBand(j))) + 40);
          if ( bandDB < 0 ) { 
            bandDB = 0;
          }
        }      
        bandAv = bandAv + bandDB;
      }    
      res.add(map(bandAv / bandStep, 0, 250, 0, 1.0));  //平均値
      FromStep = ToStep;
    }

    return new ArrayList<Float>(res);
  }
}
