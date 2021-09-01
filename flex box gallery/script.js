let panel=document.querySelectorAll(".panel");
let p0=document.querySelectorAll(".p0");
let p2=document.querySelectorAll(".p2");

for(let i=0;i<panel.length;i++)
{
    panel[i].addEventListener("click",function(e){
        p0[i].classList.toggle("pa0");
        p2[i].classList.toggle("pa2");
        // e.currentTarget.style['transition']="transform 0.5s"
        // e.currentTarget.childNodes[1].style.fontSize="5rem";
        if(e.currentTarget.classList.contains("panelafter"))
        {
            console.log("true");
            e.currentTarget.classList.remove("panelafter");
            e.currentTarget.classList.add("panel");

        }
        else{
            console.log("false");
            e.currentTarget.classList.toggle("panelafter");
        }
        
        
        // console.log( e.currentTarget.childNodes.classList.toggle("panels"));  

    });
}