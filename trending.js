const numOfGifs = 20;
const rating = 'R';
const url = 'https://api.giphy.com/v1';
const key = 'LhH2kxvrnOiFtgADwGFwI3LwhiEzfab8';
const trendingRequest = `${url}/gifs/trending?api_key=${key}&limit=${numOfGifs}&rating=${rating}`;
const randomRequest = `${url}/gifs/random?api_key=${key}`;

let data = {};

function getGifs() {
    const requestUrl = trendingRequest;
    $.ajax({
        url: requestUrl,
        success:function(response){
            data = response.data;   
            const list = document.getElementById('gifList');
            for(let i = 0; i < numOfGifs; i++){
                const src = getFixedUrl(data[i])
                const children = list.children;
                if(children[i] && children[i].src){
                    children[i].src = src;
                }else{
                    const newGif = document.createElement("img");     
                    newGif.className = "gif"
                    newGif.src = src;
                    newGif.onclick = replaceOne;
                    list.appendChild(newGif)
                }
            }
        }
    });
}

const loadingGifRequestUrl = randomRequest+"&tag=loading"
let loadGifSrc;

function preLoad(){
    $.ajax({
        url: loadingGifRequestUrl,
        success:function(response){
            data = response.data;   
            const src = getFixedUrl(data)
            loadGifSrc = src;
        }
    });
}

function replaceOne(){
    console.log(loadGifSrc)
    const inputBox = document.getElementById('inputBox');
    const searchTag = "&tag="+inputBox.value;
    const requestUrl = randomRequest+searchTag;

    var parent = document.getElementById('gifList');
    var i = 0;
    while( (this != parent.children[i]) ) {
        i++;
    }
    parent.children[i].src = loadGifSrc
    $.ajax({
        url: requestUrl,
        success:function(response){
            data = response.data;   
            const list = document.getElementById('gifList');
            const src = getFixedUrl(data)
            parent.children[i].src = src;
        }
    });
}

function getFixedUrl(data){
    return data.images['fixed_height'].url
}

const allowedKeys = {
    37: 'left',
    38: 'up',
    39: 'right',
    40: 'down',
    65: 'a',
    66: 'b'
  };
  
  const konamiCode = ['up', 'up', 'down', 'down', 'left', 'right', 'left', 'right', 'b', 'a'];
  let konamiCodePosition = 0;
  
  document.addEventListener('keydown', function(e) {
    let key = allowedKeys[e.keyCode];
    let requiredKey = konamiCode[konamiCodePosition];
  
    if (key == requiredKey) {
      konamiCodePosition++;
      if (konamiCodePosition == konamiCode.length) {
        activateCheats();
        konamiCodePosition = 0;
      }
    } else {
      konamiCodePosition = 0;
    }
  });

function activateCheats(){
    getGifs();
    alert("reset!")
}