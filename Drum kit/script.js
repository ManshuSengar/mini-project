window.addEventListener("keydown",function(e){
    let key=document.querySelectorAll(".key");
    let audio=document.querySelectorAll("audio");

    let keyp=document.querySelectorAll(".keyp");
    for(let i=0;i<key.length;i++){
        // console.log(key[i].classList)
        if(key[i].classList.contains(e.key)){
            audio[i].currentTime=0;
            key[i].classList.add("keyp");
            // console.log(key);
            setTimeout(()=>{
            key[i].classList.remove("keyp");  
            },300);
            
            // console.log(key);
            audio[i].play();
            // keyp[i].classList.toggle("key");
            // key[i].classList.add("key");
        }
        
        
    
           
        
            
            
            // key[i].classList.remove("keyp");
            // audio.play();
           
            
        }
            
    
    
})
