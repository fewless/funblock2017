  void shot(){//射撃処理
 
  if((shootCount == 0)&&(stage !=3)){//射撃ディレイ確認
  
///////////////////////////////////アサルトライフル//////////////////////////

  if(weapon == 0){//アサルトライフル
  Rifle.trigger();//効果音
  
  XYshoot = new PVector(mouseX-horizontal,mouseY-vertical);//ベクトル計算
  for(float lo=1;150>lo;lo++){//座標を伸ばしていく
  XYshoot.normalize();//単位ベクトル化
  XYshoot.mult(lo*5.0);//直線状に射撃（スカラー倍）
  for(int i=1;i<blockhp.length;i++){//命中判定の前準備
   if(( (i-9*((i-1)/9))*50 - 20 < horizontal +XYshoot.x)&&(horizontal +XYshoot.x < (i-9*((i-1)/9))*50 + 20)&&
       (80+((i-1)/9)*20 - 10 < vertical + XYshoot.y)&&( vertical +XYshoot.y< 80+((i-1)/9)*20 + 10)&&
       (blockhp[i] == 0)){//当たり判定
         blockhp[i] = 1;
         enemy_attack(i);
         line(horizontal,vertical+13,horizontal + XYshoot.x,vertical + XYshoot.y - 13);//射撃線描写
         shootCount += 1;
         return;
       }
  }
  }
  line(horizontal,vertical+13,horizontal + XYshoot.x,vertical + XYshoot.y - 13);//命中しなかった場合の射撃線
  
////////////////////////////ショットガン///////////////////////////////////////////////////////////

  }else if(weapon == 1){//ショットガン
  Shotgun.trigger();//効果音
  
  for(int r=0;r<12;r++){
    float shotgun_corX = random(-150,150);
    float shotgun_corY = random(-150,150);
  
    for(float lo=1;150>lo;lo++){//座標を伸ばしていく
  XYshoot = new PVector(mouseX-horizontal + shotgun_corX*lo/150.0,mouseY-vertical + shotgun_corY*lo/150.0);//ベクトル計算
  XYshoot.normalize();//単位ベクトル化
  XYshoot.mult(lo*5.0);//直線状に射撃（スカラー倍）
  for(int i=1;i<blockhp.length;i++){//命中判定の前準備
   if(( (i-9*((i-1)/9))*50 - 20 < horizontal +XYshoot.x)&&(horizontal +XYshoot.x < (i-9*((i-1)/9))*50 + 20)&&
       (80+((i-1)/9)*20 - 10 < vertical + XYshoot.y)&&( vertical +XYshoot.y< 80+((i-1)/9)*20 + 10)&&
       (blockhp[i] == 0)){//当たり判定
         blockhp[i] = 1;
         enemy_attack(i);
         line(horizontal,vertical+13,horizontal + XYshoot.x,vertical + XYshoot.y - 13);//射撃線描写
         shootCount += 1;
         i += blockhp.length;
         lo += 200;
  }
  }
  if(lo == 149){
         line(horizontal,vertical+13,horizontal + XYshoot.x,vertical + XYshoot.y - 13);//命中しなかった場合の射撃線
  }
  }
  }

  
/////////////////////////////////////////グレネードランチャー////////////////////////////////////////////////////
  }else if(weapon == 2){//グレネードランチャー
  grenade_fire.trigger();//効果音
  
  XYshoot = new PVector(mouseX-horizontal,mouseY-vertical);//ベクトル計算
  XYshoot.normalize();//単位ベクトル化
  grenadeX[grenade_num] = XYshoot.x;//角度
  grenadeY[grenade_num] = XYshoot.y;
  grenade_moving[grenade_num] = true; 
  greX[grenade_num] = horizontal;//発射位置
  greY[grenade_num] = vertical;
  grenade_num += 1;
  if(grenade_num > 4){
    grenade_num = 0;
  }
  
  }
  
   shootCount += 1;//発射後ディレイの開始
   
}else if((shootCount == 0)&&(stage ==3)){//ボス用判定/////////////////////////////////////////////////////////////////////////////

///////////////////////////////////アサルトライフル//////////////////////////

  if(weapon == 0){//アサルトライフル
  Rifle.trigger();//効果音
  
  XYshoot = new PVector(mouseX-horizontal,mouseY-vertical);//ベクトル計算
  for(float lo=1;150>lo;lo++){//座標を伸ばしていく
  XYshoot.normalize();//単位ベクトル化
  XYshoot.mult(lo*5.0);//直線状に射撃（スカラー倍）
   if(( bossballX -40 < horizontal +XYshoot.x)&&(horizontal +XYshoot.x < bossballX +40)&&
       (80 -10 < vertical + XYshoot.y)&&( vertical +XYshoot.y< 80 + 10)){
         bossHp -= 1;
         line(horizontal,vertical+13,horizontal + XYshoot.x,vertical + XYshoot.y - 13);//射撃線描写
         shootCount += 1;
         return;
       }
  }
  line(horizontal,vertical+13,horizontal + XYshoot.x,vertical + XYshoot.y - 13);//命中しなかった場合の射撃線
  
////////////////////////////ショットガン///////////////////////////////////////////////////////////

  }else if(weapon == 1){//ショットガン
  Shotgun.trigger();//効果音
  
  for(int r=0;r<12;r++){
    float shotgun_corX = random(-150,150);
    float shotgun_corY = random(-150,150);
  
    for(float lo=1;150>lo;lo++){//座標を伸ばしていく
  XYshoot = new PVector(mouseX-horizontal + shotgun_corX*lo/150.0,mouseY-vertical + shotgun_corY*lo/150.0);//ベクトル計算
  XYshoot.normalize();//単位ベクトル化
  XYshoot.mult(lo*5.0);//直線状に射撃（スカラー倍）
   if((  bossballX -40 < horizontal +XYshoot.x)&&(horizontal +XYshoot.x <  bossballX +40)&&
       (80 - 10 < vertical + XYshoot.y)&&( vertical +XYshoot.y< 80 + 10)){
         bossHp -= 1;
         line(horizontal,vertical+13,horizontal + XYshoot.x,vertical + XYshoot.y - 13);//射撃線描写
         shootCount += 1;
         lo += 200;
  }
  if(lo == 149){
         line(horizontal,vertical+13,horizontal + XYshoot.x,vertical + XYshoot.y - 13);//命中しなかった場合の射撃線
  }
  }
  }

  
/////////////////////////////////////////グレネードランチャー////////////////////////////////////////////////////
  }else if(weapon == 2){//グレネードランチャー
  grenade_fire.trigger();//効果音
  
  XYshoot = new PVector(mouseX-horizontal,mouseY-vertical);//ベクトル計算
  XYshoot.normalize();//単位ベクトル化
  grenadeX[grenade_num] = XYshoot.x;//角度
  grenadeY[grenade_num] = XYshoot.y;
  grenade_moving[grenade_num] = true; 
  greX[grenade_num] = horizontal;//発射位置
  greY[grenade_num] = vertical;
  grenade_num += 1;
  if(grenade_num > 4){
    grenade_num = 0;
  }
  
  }
  
   shootCount += 1;//発射後ディレイの開始

}
}