8051-music-alarm
================

8051-music-alarm


satimsa@gmail.com

元智大學通訊系微電腦系統專題
鬧鈴為”望春風”  (循環播放)，可於DB中修改
使用Timer 0 Interrupt來計時
使用Timer 1 Interrupt來掃描四個七段顯示器(配合7448僅使用一個Port)
使用 INT1(P3.3) Interrupt 來控制P1 的LED燈往high bit 平移(配合微動開關)
鬧鐘使用說明:
共有四個按鈕開關，由左而右依序為:
時+1 or 撥放音樂│分+1│設定現在時間│設定鬧鐘時間
關閉(鬧鈴)撥放音樂方法:四顆按鈕一起按下
灰色按鈕為鬧鈴功能 開啟/關閉  (壓/放)


腳位:
P1、P0:LED燈 (P0需並聯10K歐姆提升電阻到正電)
P2.0~2.3 接入7447or7448解碼器 (輸出電壓可能過弱，需加入放大器或7408升壓)
P2.4~2.7依序接入四個(共陰)七段顯示器的com腳位
P3.7為讀秒閃爍LED燈腳位
P3.6連接喇叭(可透過放大器)
P3.5鬧鐘啟動開關
P3.4按鈕開關-進入鬧鐘設定模式
P3.3微動開關(配合SR-LATCH)-控制P1的跑馬燈
P3.2按鈕開關-進入時間設定模式
P3.1按鈕開關-時+1
P3.0按鈕開關-分+1/撥放音樂
振盪器為12MHZ