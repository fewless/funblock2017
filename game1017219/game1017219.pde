//1017219 筒井康平

import ddf.minim.*;//効果音系

PImage tlp[] = new PImage[3];//主人公画像配列
PImage arm[] = new PImage[3];//銃の画像配列
PImage arm1;//銃(ライフル)の画像
PImage arm2;//銃(ショットガン)の画像
PImage medical;//アイテム画像
PImage saw;//丸ノコ画像

PGraphics pg;//背景

int now_mode=0;//現在の状態把握]
PFont fontA,fontB;

Minim minim;//効果音系
AudioSample Rifle, Shotgun, eneShot, burst, reload, lock, saws,grenade,grenade_fire;

void setup() {
  size(500, 700, P3D);//画面サイズ、方式
  rectMode(CENTER);//rectを中心方式に
  textSize(25);

  minim = new Minim(this);
  Rifle = minim.loadSample("rifle.mp3", 2048);//ライフル
  Shotgun = minim.loadSample("shotgun.mp3", 2048);//ショットガン
  grenade = minim.loadSample("grenade.mp3", 2048);//グレラン爆発音
  grenade_fire = minim.loadSample("grenade_fire.mp3", 2048);//グレラン発射音
  eneShot = minim.loadSample("eneshot.mp3", 2048);//敵の射撃
  burst = minim.loadSample("burst.mp3", 2048);//爆発音
  lock = minim.loadSample("lock.mp3", 2048);//ロックオン
  reload = minim.loadSample("reload.mp3", 2048);//リスタート
  saws = minim.loadSample("saws.mp3", 2048);//丸ノコ

  for (int tlps=0; tlps < tlp.length; tlps++) {//主人公画像読み込み
    tlp[tlps] = loadImage("run"+ tlps +".png");
  }

  for (int k=0; k < arm.length; k++) {//主人公画像読み込み
    arm[k] = loadImage("arm"+ k +".png");
  }
  medical=loadImage("medical.png");//回復アイテムの読み込み
  saw = loadImage("saw.png");//丸ノコ画像読み込み

  pg = createGraphics(500, 700);//背景の用意
  backdraw();

  imageMode(CENTER);//imageを中心方式に

 fontA = loadFont("BodoniMTPosterCompressed-48.vlw");
 fontB = loadFont("BookAntiqua-48.vlw");
}

//////////////変数宣言/////////////////////////

//システム可変
int howManyBlocks = 100;
boolean starter = false;
float startmouse;
boolean bossBreak = false;

//移動関連
float hMove=0, vMove=0;//水平入力
boolean hMoveAct;//水平制御

float horizontal=250, vertical=560;//主機座標

boolean vMoving;//ジャンプ認識
float vMoveTime=0;//ジャンプ経過時間
float vMoveCal=0;//ジャンプ計算用
int vMoveAct=0;//ジャンプ制御

int movepicture;//移動画像制御

//射撃管制
int weapon=0;//装備中の武器
String weapon_name = "FULL AUTO RIFLE";//装備中武器の名前
boolean reloading = false;//リロード中

PVector XYshoot;//射撃ベクトル
int shootCount = 0;//射撃ディレイ計測
int blockhp[]=new int[howManyBlocks];//ブロックの数
int blockTime[]=new int[howManyBlocks];//ブロックの攻撃処理
float degree0, degree1, degree2;//射撃角度の判定用

float Bwidth, Bheight;//距離計算用
float memoryDistance1=0, memoryDistance2=0;
int whereBreak;//破壊ブロックの確認

float[] grenadeX = new float[5], grenadeY = new float[5];//グレネードランチャーの加速度
boolean[] grenade_moving = new boolean[5];
int grenade_num = 0;//発射中のグレネード管理
int grenadeTime[] = new int[5];
float[] greX = new float[5],greY = new float[5];

//敵射撃管制
float a, b;//敵射撃汎用変数
int moveMode[]= new int[howManyBlocks];//丸ノコ移動モード
float viM[]= new float[howManyBlocks];
float hoM[]= new float[howManyBlocks];
float memoryVirtical[]= new float [howManyBlocks];
String RL[]=new String[howManyBlocks];//丸ノコの移動方向
String alreadyHit[]= new String[howManyBlocks];//丸ノコ多段ヒット対策

//ステータス関連
int HP=100;
float timestart;//時間計測
float timecount;//計算用
int destroy=0;
String clas;
int end=0;

//////////////稼動部/////////////////////////

void draw() {

  if (now_mode ==0){//スタート待機
  background(255);
    fill(0);
    textFont(fontB);
    textSize(55);
    text("BREAKOUT", 100, 200);//タイトル表示
    if(starter == true){
      text("GOODLUCK", 100,400,-1000);
    }
    fill(255);
    translate(0,200,0);
    box(100,700,1000);
    translate(500,0,0);
    box(100,700,1000);
    
        if(starter == false){
    camera(width/2,height/2,500,
    mouseX*2-width/2,height/2,0,
    0,1,0);
    }else{
    camera(width/2,height/2 , 500-30*(100-time),
    time*(startmouse*2-width/2)/100 +width/2,height/2,-30*(100-time),
    0,1,0);
    time -= 1;
    if(time == 0){
       now_mode=1;//          稼動モードへ
      timestart = millis();//計測開始
      time = 1000;
      camera();
    }
    }
    
    if(time != 0){
    fill(0);
    rotateY(PI/2);
    translate(-400,300,100);
    textSize(40);
    text("STAGE LIST", 0, 0);
    textFont(fontA);
    textSize(30);
    text("SHOOTING RANGE", 0, 50);
    text("BREAKOUT", 0, 80);
    
    rotateY(PI);
    textAlign(RIGHT);
    translate(0,0,-300);
    textFont(fontB);
    textSize(40);
    text("WEAPON LIST", 0, 0);
    textFont(fontA);
    textSize(30);
    text("FULL AUTO RIFLE", 0, 50);
    text("SHOTGUN", 0, 80);
    text("GRENADE LUNCHER", 0, 110);
    textAlign(LEFT);
    }

    
    if ((mousePressed == true)&&(mouseX < width/3)) {//押したとき
    if((278<mouseY)&&(mouseY<349)){
    startmouse = mouseX;
    starter = true;
    stage = 1;
    }else if((372<mouseY)&&(mouseY<445)){
          startmouse = mouseX;
    starter = true;
    stage = 2;
    }

    }
  } else if (now_mode == 3) {//ゲームオーバー

    fill(200, 230);
    rect(width/2, height/2, width, height);//薄いヴェール
    fill(0);
    textSize(55);
    text("FINISH", 150, 100);//終わりの合図
    textSize(25);
    text("HP: "+HP+"*10000 = "+(HP*10000), 50, 300);//残りHPスコア
    text("HIT: "+destroy+"*1000 = "+(destroy*1000), 50, 350);//撃破数スコア
    text("TIME: "+nf(timecount, 2, 2)+"*1000 = "+int(timecount*1000), 50, 400);//タイムスコア
    if(bossBreak == true){
    text("BOSS_BREAK:100000 ", 50, 450);
    destroy += 100;
    }
    int score=int((HP*10000)+(destroy*1000)+(timecount*1000));//合計スコア
    text("SCORE: "+score, 50, 500);
    if (score <= 50000) {//ランクの判定
      clas = "RECRUIT";
    } else if (score <=90000) {
      clas = "PRIVATE";
    } else if (score <=125000) {
      clas = "VETERAN";
    } else if (score <=155000) {
      clas = "ELITE";
    } else if (score <=180000) {
      clas = "SPECIAL FORCE";
    } else {
      clas = "MARSHAL";
    }
    text("CLASS: "+clas, 50, 550);//ランクの表示
    text("press any key to continue", 50, 650);//何か押して
    now_mode = 4;//リスタート待機へ移行
  } else if (now_mode ==4) {//リスタート待機
    if (end ==0) {
      delay(1500);//　　　即リスタート対策
      keyPressed = false;
      end =1;
    }

    if (keyPressed==true) {//初期化
      for (int w=0; w<100; w++) {//配列の最初期化
        blockhp[w]=0;
        blockTime[w]=0;
      }
      HP = 100;//HPの初期化
      end =0;//リスタート用
      horizontal=250;//主機の初期化
      vertical=560;
      bossHp = 30;
      if(stage != 1){
      stage = 2;
      }
      now_mode=1;//ゲームリスタート・稼動モードへ
      reload.trigger();//効果音
      timestart = millis();//計測開始
    }
  } else if (now_mode ==1) {//稼動モード


    /////////////特殊//////////////////////////
    textFont(fontB);
    stroke(0);
    background(255);
    fill(0);
    image(pg, width/2, height/2);//背景の表示

    fill(200);//左右の柱
    translate(-20, 350, 0);
    box(100, 500, 100);//左の柱
    translate(540, 0, 0);
    box(100, 500, 100);//右の柱
    translate(-520, -350, 0);

    fill(0);

    float nowTime=millis();//時間の測定
    timecount = (timestart-nowTime)/1000;
    if(stage == 1){
    timecount = timecount + 1000;
    }else{
       timecount = timecount + 30000;
    }
    textSize(45);
    text(timecount, 150, 50);//残り時間の表示
    textSize(25);
    text("  LIFE : "+HP+ "  　BREAK : "+destroy, 0, 650);//HPの表示
    text(weapon_name, 0, 675);//武器の名前

    destroy =0;
    for (int i=0; i<100; i++) {//撃破数の計測
      if (blockhp[i] != 0) {
        destroy += 1;
      }
    }

    if ((timecount <= 0)|| (HP <= 0) || ((stage == 1)&&(destroy >= 99))) {//ゲームオーバーの判定
      if (timecount <0) {
        timecount = 0;//時間マイナス対策
      }
      now_mode =3;
    }
    
    if((stage == 2)&&(destroy >= 99)){//ボス
    timestart +=50000;
    stage = 3;
    }
    
      if(stage == 3){
      BOSS();
      bossatack();
      bossarm();
      if(bossHp <1){
        now_mode =3;
        bossBreak = true;
      }
      
    }
    ////////////移動系//////////////////////////
    if (keyPressed == true) {
      if (key == 'd') {
        hMove = 8;         //右への移動
        hMoveAct = true;
      } else if ( key == 'a') {
        hMove = -8;//左への移動
        hMoveAct = true;
      }

      if ((key == 'w')&&(vMoving == false)) {//ジャンプ処理
        vMoveCal = 30;
        vMoving = true;//ジャンプ中
      }
    }

    if (vMoving == true) {//ジャンプ中の処理
      vMoveTime += 1;
      vMove = vMoveCal * vMoveTime - (2 * vMoveTime*vMoveTime)/2;//自由落下の公式

      if (vMove <= 0) {//着地
        vMove = 0;
        vMoveTime = 0;
        vMoving = false;//ジャンプの終了
      }
    }
    

    if (hMove == 0) {//主人公の画像選択
      movepicture = 0;
    } else if (hMove >=2) {
      movepicture = 1;//右に移動中
    } else {
      movepicture = 2;//左に移動中
    }

    horizontal += hMove;//横への移動量加算

    if (horizontal <=45) {//左右への移動制限
      horizontal = 45;
    } else if (455 <= horizontal) {
      horizontal = 455;
    }

    vertical =560 - vMove;//垂直座標の計算
    image(tlp[movepicture], horizontal, vertical+25);//主人公の画像表示


    //////////////////////////射撃系////////////////////////////////////////////////
    target();//ターゲットサイトの表示

    if (shootCount > 0) {//射撃ディレイのカウント
      shootCount += 1;
      if ( weapon == 0) {
        if (shootCount >=8) {
          shootCount = 0;
        }
      } else if ( weapon == 1) {
        if (shootCount >=80) {
          shootCount = 0;
        }
      }else if(weapon == 2){
       if(shootCount >=20){
         shootCount = 0;
      }
    }
    }
//println(key);
    //////////////////////////ブロック//////////////////////////////////////////////

    for (int i=1; i<10; i++) {
      for (int k=0; k<blockhp.length/9; k++) {
        if (blockhp[i+k*9] == 0) {
          rect(i*50, 80+k*20, 40, 10);//ブロックの表示
        }
      }
    }

    ////////////////////その他////////////////////////////////////////
    //camera(-horizontal/30+width/2+10, 350, 600, // 視点X, 視点Y, 視点Z
    //     -horizontal/30+width/2+10, 350, 0, // 中心点X, 中心点Y, 中心点Z
    //     0.0, 1.0, 0.0); // 天地X, 天地Y, 天地Z
         
    attacking();//敵攻撃の継続処理
    weapon_action();

    if (mousePressed == true) {//マウスクリックで射撃
      shot();
    }
  }
}

void keyReleased() {//キー離した判定；移動指示の初期化
key = ' ';//キー入力初期化
 if (key != 'w') {//ジャンプの場合は横移動の初期化をしない
    hMove = 0;
    if (hMoveAct == true) {
      if (key == 'd') {
        hMove = -8;         //右への移動
        hMoveAct = false;
     } else if(key =='a'){
        hMove = 8;//左への移動
       hMoveAct = false;
      }
 }
}
}

void mouseWheel(MouseEvent e) {
  if ( e.getAmount() < 0 ) {
    weapon += 1;
    if (weapon > arm.length-1) {
      weapon = 0;
    }
  } else {
    weapon -= 1;
    if (weapon < 0) {
      weapon = arm.length-1;
    }
  }

  if (weapon == 0) {
    weapon_name = "FULL AUTO RIFLE";
  } else if (weapon == 1) {
    weapon_name = "SHOTGUN";
  } else if (weapon == 2) {
    weapon_name = "GRENADE LUNCHER";
  }
}
////////////////終了/////////////////////////////////////////

void stop() {
  minim.stop();
}