let play=document.querySelector(".play");
let pre=document.querySelector(".pre");
let next=document.querySelector(".next");
let pause = document.querySelector(".pause");
let name=document.querySelector("#songName");
var clicker=1;
let index =1;
let playlist={
    1:"/musics/1.mp3",
    2:"/musics/2.mp3",
    3:"/musics/3.mp3",
    4:"/musics/4.mp3",
    5:"/musics/5.mp3",
    6:"/musics/6.mp3",
    7:"/musics/7.mp3",
    8:"/musics/8.mp3",
    9:"/musics/9.mp3",
    10:"/musics/10.mp3",
 } 
//  var audio = new Audio(playlist[1]);

var audio = new Audio(playlist[index]);

play.addEventListener('click',function(e){
    name.innerText=index;
   
    if(clicker==1){
        audio.play();

        clicker = 2;
        e.currentTarget.classList.add("pause");
        e.currentTarget.classList.remove("play");

    }
    else{
        audio.pause();
        clicker = 1;
        e.currentTarget.classList.add("play");
        e.currentTarget.classList.remove("pause");
    }
});

next.addEventListener('click',function(e){
    audio.pause();
    if(index== 10)
    {
        index = 1;
    }
    else
    index++;
    audio = new Audio(playlist[index]);
    name.innerText=index;
   
    if( play.classList.contains("play")){
        play.classList.add("pause");
       play.classList.remove("play");
    }
    
    audio.play();
});
pre.addEventListener('click',function(e){
    audio.pause();
    if(index== 1)
    {
        index = 10;
    }
    else
    index--;
    audio = new Audio(playlist[index]);
    name.innerText=index;
    if( play.classList.contains("play")){
        play.classList.add("pause");
       play.classList.remove("play");
    }
    
    audio.play();
});