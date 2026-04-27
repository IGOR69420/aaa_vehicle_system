window.addEventListener("message", function(e){
    if(e.data.action==="open"){
        power.value=e.data.tuning.power
        grip.value=e.data.tuning.grip
        turbo.checked=e.data.tuning.turbo
    }

    if(e.data.action==="leaderboard"){
        console.log(e.data.data)
    }
})

function apply(){
fetch(`https://${GetParentResourceName()}/applyTuning`,{
method:"POST",
body:JSON.stringify({
power:parseFloat(power.value),
grip:parseFloat(grip.value),
turbo:turbo.checked
})
})
}

function closeMenu(){
fetch(`https://${GetParentResourceName()}/close`,{method:"POST"})
}