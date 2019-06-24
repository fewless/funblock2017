void weapon_action(){
  for(int k=0;k<5;k++){
  if(grenade_moving[k] == true){
    fill(0);
    float nowX = greX[k] + grenadeX[k]*20*grenadeTime[k];
    float nowY = greY[k] + grenadeY[k]*20*grenadeTime[k]  +  sq(3*grenadeTime[k])/32 +13;
    ellipse(nowX , nowY ,10,10);
    grenadeTime[k] += 1;
    
    for(int i=1;i<blockhp.length;i++){
    if((( (i-9*((i-1)/9))*50 - 20 < nowX)&&(nowX < (i-9*((i-1)/9))*50 + 20)&&
       (80+((i-1)/9)*20 - 10 < nowY)&&( nowY< 80+((i-1)/9)*20 + 10)&&
       (blockhp[i] == 0))||(nowY > 600)){//当たり判定
        grenade.trigger();
        grenadeTime[k] = 0;
        grenade_moving[k] = false;
        for(int r=1;r<10;r++){//爆発エフェクト
           noStroke();
           fill(255,0,0,255-r*25);
           ellipse(nowX,nowY,sq(r)*2,sq(r)*2);
         }
         for(int t=1;t<blockhp.length;t++){
           if((blockhp[t] == 0)&&(dist(nowX,nowY,(t-9*((t-1)/9))*50,80+((t-1)/9)*20) <=50)){//命中判定
             blockhp[t] = 1;
             enemy_attack(t);
          }
         }
         return;
       }
    }
  }
}}