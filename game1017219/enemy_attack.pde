void enemy_attack(int V){//ブロックイベントの発生
  
  if((V !=0)&&(stage !=1)){//存在しない０ブロックへの命中を拒否(ダミー用）
   int way = int(random(2,20));//乱数での確率分布
    
   if       (way <= 9 ){
    blockhp[V] = 3;//　爆弾
    fill(255,0,0);
    ellipse((V-9*((V-1)/9))*50 ,80+(V/10)*20 ,10 ,10);
   }else if (way <= 14){
    blockhp[V] = 4;//　射撃
   }else if (way <= 16){
    blockhp[V] = 5;//　丸ノコ
   }else if (way <= 17){
    blockhp[V] = 6;//　回復d
    image(medical, (V-9*((V-1)/9))*50 ,80+(V/10)*20);
   }
  }
  }