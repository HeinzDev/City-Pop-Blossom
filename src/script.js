import { audioTracks } from './matriz.js';
  
  const numberOfTracks = audioTracks.length;
  let currentTrackIndex = -1;
  let isPaused = false;
  let isRunning = false;
  let volume = 1;
  let volChange = 0.2;
  
  const audioElements = audioTracks.map(({ file }) => new Audio(file));
  
  export function city() {
    playNextTrack();
    console.log('city!!');
  }

  export function pauseButton(){
    if(isPaused) {
      const currentAudio = audioElements[currentTrackIndex];
      currentAudio.play();
      isPaused = false;
    } else {
      const currentAudio = audioElements[currentTrackIndex];
      currentAudio.pause();
      isPaused = true;
    }
  }

  export function getRandomTrackIndex() {
    let newIndex;
    do {
      newIndex = Math.floor(Math.random() * numberOfTracks);
    } while (newIndex === currentTrackIndex);
    return newIndex;
  }
  
  export function playNextTrack() {
    currentTrackIndex = getRandomTrackIndex();
    const { name, artist } = audioTracks[currentTrackIndex];
    updateUI(name, artist);
    playCurrentTrack();
  }
  
  export function playCurrentTrack() {
    pauseAllTracks();
    const currentAudio = audioElements[currentTrackIndex];
    currentAudio.volume = volume;
    currentAudio.play();
    isRunning = true;
  }
  
  export function pauseAllTracks() {
    audioElements.forEach((audio) => audio.pause());
  }
  
  export function updateUI(trackName, artistName) {
    document.getElementById('button').innerHTML = trackName;
    document.getElementById('name').innerHTML = artistName;
  }

  export function setVolume(value){
    lonliness.volume = value;
    summer.volume = value;
    jajauma.volume = value;
    gravitation.volume = value;
}

// bottom buttons
function pauseAction(){
  if(isPaused==false && isRunning==true){
      isPaused = true;
      console.log('is paused:'+ isPaused)
      console.log('isRunning:'+ isRunning)      
      document.getElementById("pause").innerHTML = "Play";
      pauseAllTracks();

  } else if(isPaused==true && isRunning==true){
      isPaused = false;
      console.log('is paused:'+ isPaused)
      console.log('isRunning:'+ isRunning) 
      document.getElementById("pause").innerHTML = "Pause";
      playCurrentTrack()
  }
}

function plus(){
  const currentAudio = audioElements[currentTrackIndex];
  volume = volume + volChange;
  if(volume>1)volume=1;
  currentAudio.volume = volume
}

function minus(){
  const currentAudio = audioElements[currentTrackIndex];
  volume = volume - volChange;
  if(volume<0)volume=0;
  currentAudio.volume = volume
}

document.getElementById('button').addEventListener('click', city);
document.getElementById('volumeMinus').addEventListener('click', minus);
document.getElementById('volumePlus').addEventListener('click', plus);
document.getElementById('pause').addEventListener('click', pauseAction);

export default {
  city,
  pauseButton,
  getRandomTrackIndex,
  playNextTrack,
  playCurrentTrack,
  pauseAllTracks,
  updateUI,
  setVolume
};