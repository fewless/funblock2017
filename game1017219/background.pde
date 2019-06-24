void backdraw(){//背景画像の用意
  pg.beginDraw();
  pg.background(100);//背景色
  pg.line(0,600,500,600);//床のライン
  pg.line(0,625,500,625);
  pg.fill(200);
  pg.rect(30,100,440,500);//背景の板
  pg.fill(150);
  pg.rect(0,625,500,75);//ステータスボード
  pg.fill(0);
  pg.endDraw();
}