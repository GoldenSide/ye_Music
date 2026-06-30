import { media } from '@kit.MediaKit';
import { GlobalMusic,PlayMode } from '../models/globalMusic';
import { SongItemType } from '../models/music';
import { sessionManager } from './avSessionManager';


export class  AvPlayerManager {
   player:media.AVPlayer|null=null;
   currentSong:GlobalMusic=new GlobalMusic()
   private static instance: AvPlayerManager | null = null;

   async  init(){
     if(this.player){
       return
     }
     this.player =await media.createAVPlayer();
     this.player.on('stateChange',  (state) => {
       if(state==='initialized'){
         this.player?.prepare()
       }else if(state==='prepared'){
         this.player?.play()
         this.currentSong.isPlay=true
       }else if( state==='completed'){
          this.next(true)
       }
     })

     this.player.on('durationUpdate',(duration)=>{
       this.currentSong.duration=duration
       this.updateSongStatus()
       sessionManager.setAVMetadata(this.currentSong.playList[this.currentSong.playIndex])
     })
     this.player.on('timeUpdate',(time)=>{
       this.currentSong.time=time
       this.updateSongStatus()
       sessionManager.setAVPlayState( this.currentSong.isPlay)
     })
   }
   updateSongStatus(){
     AppStorage.setOrCreate('GlobalMusic',this.currentSong)
   }

   singPlay(song:SongItemType){
     const inList= this.currentSong.playList.some((item) => item.id === song.id)
     if(inList){
          if(this.currentSong.url===song.url){
            this.player?.play()
            this.currentSong.isPlay=true
          }else{
            this.currentSong.playIndex=this.currentSong.playList.indexOf(song)
            this.changeSong()
          }
     }else{
       this.currentSong.playList.unshift(song)
       this.currentSong.playIndex=0
       this.changeSong()
     }
     this.updateSongStatus()
     sessionManager.requestBackgroundTask()
     sessionManager.setAVPlayState( this.currentSong.isPlay)
   }
   // 切歌
   async changeSong()  {
     await this.player?.reset()
     this.currentSong.duration=0
     this.currentSong.time=0
     this.currentSong.img=this.currentSong.playList[this.currentSong.playIndex].img
     this.currentSong.name= this.currentSong.playList[this.currentSong.playIndex].name
     this.currentSong.author= this.currentSong.playList[this.currentSong.playIndex].author
     this.currentSong.url= this.currentSong.playList[this.currentSong.playIndex].url
     this.player!.url=this.currentSong.url
     this.updateSongStatus()
   }

   seekPlay(value:number){
     this.player?.seek(value)
   }
   // 下一首
   next(autoNext?:boolean){
     if(this.currentSong.playMode===PlayMode.RANDOM){
       this.currentSong.playIndex=Math.floor(Math.random()*this.currentSong.playList.length)
     }else if(this.currentSong.playMode===PlayMode.LOOP&&autoNext){
       this.currentSong.playIndex=this.currentSong.playIndex
     }else {
         if(this.currentSong.playIndex===this.currentSong.playList.length-1){
           this.currentSong.playIndex=0
         }else{
           this.currentSong.playIndex++
         }
     }
     this.singPlay(this.currentSong.playList[this.currentSong.playIndex])
   }
   // 上一首
   prev(){
     if(this.currentSong.playMode===PlayMode.RANDOM){
       this.currentSong.playIndex=Math.floor(Math.random()*this.currentSong.playList.length)
     }else{
       if(this.currentSong.playIndex===0){
         this.currentSong.playIndex=this.currentSong.playList.length-1
       }else{
         this.currentSong.playIndex--
       }
     }
     this.singPlay(this.currentSong.playList[this.currentSong.playIndex])
   }

   /**
    * 删除指定歌曲
    * @param index
    */
   deleteMusic(index:number){
     if(this.currentSong.playIndex===index){
       if(this.currentSong.playList.length>1){
         this.currentSong.playList.splice(index,1)
         if(this.currentSong.playIndex>=  this.currentSong.playList.length){
           this.currentSong.playIndex=0
         }
         this.changeSong()
       }else{
         this.currentSong.reset()
         this.updateSongStatus()
         this.player?.reset()

       }
     }else {
       if(this.currentSong.playIndex>index){
         this.currentSong.playIndex--
       }
       this.currentSong.playList.splice(index,1)
     }
   }

  playPause(){
    this.currentSong.isPlay? this.player!.pause():this.player!.play()
    this.currentSong.isPlay=!this.currentSong.isPlay
    this.updateSongStatus()
    sessionManager.setAVPlayState( this.currentSong.isPlay)
  }
   static  getInstance(){
     if(AvPlayerManager.instance==null){
       AvPlayerManager.instance = new AvPlayerManager();
     }
     return  AvPlayerManager.instance
   }

}
