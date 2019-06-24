int stage;
int time = 100;

int bossballX,bossballY,bossDx=8,bossDy=8;
int bossHp = 30;
void BOSS(){
  fill(0);
  rect(bossballX,80,80,20);
  bossballX += bossDx;
  bossballY += bossDy;
   ellipse(bossballX,bossballY,20,20);

  
  if (bossballX <45){
    bossDx =8;
    impact1Y =bossballY;
    imTime1 =1;
    
  }else if(455<bossballX){
      bossDx =-8;
      impact2Y =bossballY;
      imTime2 =1;
 }
 if (bossballY <90){
   bossDy = 8;
 }else if(600<bossballY){
    bossDy =-8;
    impact3X =bossballX;
    imTime3 =1;
 }
}


int impact1Y,imTime1;//右
int impact2Y,imTime2;//左
int impact3X,imTime3;//床

void bossatack(){
      if((1<=imTime1)&&(imTime1 <=30)){
       if((impact1Y + imTime1*15)<600){
         for(int r=1;r<10;r++){//爆発エフェクト
           noStroke();
           fill(255,0,0,255-r*25);
           ellipse(45,impact1Y + imTime1*15,sq(r),sq(r));
         }
           if(dist(45,impact1Y + imTime1*15,horizontal,vertical) <=50){//命中判定
            HP -= 1;
          }
       }
       if(50 < (impact1Y - imTime1*15)){
         for(int r=1;r<10;r++){//爆発エフェクト
           noStroke();
           fill(255,0,0,255-r*25);
           ellipse(45,impact1Y - imTime1*15,sq(r),sq(r));
         }
         if(dist(45,impact1Y - imTime1*15,horizontal,vertical) <=50){//命中判定
            HP -= 1;
          }
       }
       imTime1 +=1;
      }
      
      if((1<=imTime2)&&(imTime2 <=30)){
       if((impact2Y + imTime2*15)<600){
         for(int r=1;r<10;r++){//爆発エフェクト
           noStroke();
           fill(255,0,0,255-r*25);
           ellipse(455,impact2Y + imTime2*15,sq(r),sq(r));
         }
          if(dist(455,impact2Y + imTime2*15,horizontal,vertical) <=50){//命中判定
            HP -= 1;
          }
       }
       if(50 < (impact2Y - imTime2*15)){
         for(int r=1;r<10;r++){//爆発エフェクト
           noStroke();
           fill(255,0,0,255-r*25);
           ellipse(455,impact2Y - imTime2*15,sq(r),sq(r));
         }
         if(dist(455,impact2Y - imTime2*15,horizontal,vertical) <=50){//命中判定
            HP -= 1;
          }
       }
       imTime2 +=1;
      }
      
      if((1<=imTime3)&&(imTime3 <=30)){
       if((impact3X + imTime3*15)<455){
         for(int r=1;r<10;r++){//爆発エフェクト
           noStroke();
           fill(255,0,0,255-r*25);
           ellipse(impact3X + imTime3*15,600,sq(r),sq(r));
         }
          if(dist(impact3X + imTime3*15,600,horizontal,vertical) <=50){//命中判定
            HP -= 1;
          }
       }
       if(45 < (impact3X - imTime3*15)){
         for(int r=1;r<10;r++){//爆発エフェクト
           noStroke();
           fill(255,0,0,255-r*25);
           ellipse(impact3X - imTime3*15,600,sq(r),sq(r));
         }
         if(dist(impact3X - imTime3*15,600,horizontal,vertical) <=50){//命中判定
            HP -= 1;
          }
       }
       imTime3 +=1;
      }
  
}

int bossAtime=0;
int whoAttack=0;
float[] XX=new float[30];

void bossarm(){
  bossAtime +=1;
  if(bossAtime == 15){
    bossAtime = 0;
    blockhp[whoAttack] =int(random(3,13));
    blockTime[whoAttack]=0;
    whoAttack +=1;
    if(whoAttack == 30){
      whoAttack =0;
    }
  }
    
  for(int i=0;i<30;i++){
/////////////////////////////爆弾///////////////////////////////////////////
      if((3 <=blockhp[i] )&&(blockhp[i]<=4) ){
        fill(255,0,0);//赤く
        if(blockTime[i] == 0){
          XX[i]=bossballX;
        }
        blockTime[i] += 1;//時間経過
        float vM=80+sq(blockTime[i])/8;//爆弾の移動
        float hM=XX[i];
        
        ellipse(hM,vM ,10 ,10);//表示
        if(vM >= 600){//着弾

          for(int r=1;r<10;r++){//爆発エフェクト
            noStroke();
           fill(255,0,0,255-r*25);
           ellipse(hM,vM,sq(r)*3,sq(r)*3);
          }
          blockhp[i]=20;//無力化
          burst.trigger();//効果音
            
          if(dist(hM,vM,horizontal,vertical) <=150){//命中判定
            HP -= 1;
          }
        }
        fill(255);//元に戻す
        stroke(0);
      }
      
/////////////////////////////射撃//////////////////////////////////////////
       if(blockhp[i] == 5){
        fill(0,0);
        if(blockTime[i] == 0){
          XX[i]=bossballX;
        }
        
        blockTime[i] += 1;//時間の経過
        
        if(blockTime[i] == 1){
        lock.trigger();//効果音
        a=horizontal;//主機の位置把握
        b=vertical;
        }
        
        arc(a,b,100,100,0,((PI*2)/30)*blockTime[i]);//ロックオン演出

      if(blockTime[i] >= 30){
        blockhp[i]=20;//無力化
        eneShot.trigger();//効果音
        
        float x4 =XX[i];//位置の把握
        float y4 =80;
        PVector enemyP= new PVector(a-x4,b-y4);//ベクトル計算
        enemyP.normalize();//単位ベクトル化
        enemyP.mult(1000);//直線状に射撃（スカラー倍）
        strokeWeight(10);
        stroke(255,0,0);//赤く
        line(x4,y4,x4 + enemyP.x,y4 + enemyP.y);//射撃線描写\\
        strokeWeight(1);
        stroke(0);
        
        translate(x4,y4);
    float deg1 = degrees( atan2( a-x4, b-y4 ));//射撃角度
    float deg2 = degrees( atan2( horizontal-x4, vertical-y4));//現在の主機の角度
        translate(-x4,-y4);
   
   //////角度を単純比較できるように正に変換////
    if(deg1 <=0){
      deg1 = 360 + deg1;
    }
    if(deg2 <=0){
      deg2 = 360 + deg2; 
    }

    //////////////////////////////////////////
        
    if(abs(deg1-deg2) <=2){//命中判定{   blockhp[i]=20;
    HP -=1;
      }
       }
      }
      
/////////////////////////////丸ノコ///////////////////////////////////////////
      if(blockhp[i] == 6){
        blockTime[i] += 1;//時間経過
        //////////初回起動/////////
        
        if(blockTime[i] == 1){//初回のみ起動・左右の判定
         XX[i]=bossballX;
         saws.trigger();//効果音・丸ノコ
         moveMode[i]=0;
         viM[i]=XX[i];
         if( viM[i] <=250 ){
          RL[i] ="left";//左に向かう
         }else{
          RL[i] ="right";//右に向かう
         }
        }
        
        //////////////////////////
        
        if(moveMode[i] == 0){//第一段階　左右への移動
         if(RL[i] == "left"){//左パターン
          hoM[i]=XX[i]-sq(blockTime[i])/16;
         }else{
          hoM[i]=XX[i]+sq(blockTime[i])/16;
         }
        viM[i]=80+sq(blockTime[i])/32;//縦方向の移動
        
        if(hoM[i] <= 45 ){
          hoM[i] = 45;
          moveMode[i] = 1;
        }else if(hoM[i] >= 455){
          hoM[i] = 455;
          moveMode[i] = 1;
        }
        
        }else if(moveMode[i] == 1){//第二段階　壁沿いの落下
         memoryVirtical[i] =viM[i];
         viM[i]=memoryVirtical[i]+sq(blockTime[i])/128;
         if(viM[i] >=600){
           moveMode[i] = 2;
          viM[i] = 600;
        }
        }else{//第三段階　床面での移動
           if(RL[i] == "left"){
             hoM[i] +=50;
           }else{
             hoM[i] -=50;
          }
        }
        
        translate(hoM[i],viM[i]);//表示
        if(RL[i] == "left"){
         rotate(-blockTime[i]);
         image(saw,0,0);//表示
         rotate(blockTime[i]);
        }else{
         rotate(blockTime[i]);
         image(saw,0,0);//表示
         rotate(-blockTime[i]);
        }
         translate(-hoM[i],-viM[i]);
       
        
        if((hoM[i] <=-25) || (525<=hoM[i])){//終わり
           blockhp[i]=20;//無力化
        }
          if(alreadyHit[i] != "YES"){  
           if(dist(hoM[i],viM[i],horizontal,vertical) <=100){//命中判定
             HP -= 1;
             alreadyHit[i] = "YES";
           }
        }
      }
       }
  }