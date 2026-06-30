

import { avSession } from "@kit.AVSessionKit"
import { backgroundTaskManager } from "@kit.BackgroundTasksKit"
import { wantAgent } from "@kit.AbilityKit"
import { GlobalMusic } from "../models/globalMusic"
import { AvPlayerManager } from "./avPlayer"
import { SongItemType } from "../models/music"

export class AvSessionManager {

  session: avSession.AVSession | null = null
  async init(context: Context) {
    this.session = await avSession.createAVSession(context, 'bgPlay', 'audio' )
    this.registerEvent()
  }
   currentMusic:GlobalMusic | undefined= AppStorage.get('GlobalMusic')

//   申请长时任务
  async requestBackgroundTask() {
    let wantAgentInfo: wantAgent.WantAgentInfo = {
      // 点击通知后，将要执行的动作列表
      // 添加需要被拉起应用的bundleName和abilityName
      wants: [
        {
          bundleName: 'com.example.ye_music',
          abilityName: 'EntryAbility'
        }
      ],
      // 指定点击通知栏消息后的动作是拉起ability
      actionType: wantAgent.OperationType.START_ABILITY,
      // 使用者自定义的一个私有值
      requestCode: 0,
      // 点击通知后，动作执行属性
      actionFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG],
      // 车钥匙长时任务子类型，从API version 16开始支持。只有申请bluetoothInteraction类型的长时任务，车钥匙子类型才能生效。
      // 确保extraInfo参数中的Key值为backgroundTaskManager.BackgroundModeType.SUB_MODE，否则子类型不生效。
      // extraInfo: {
      // [backgroundTaskManager.BackgroundModeType.SUB_MODE] :backgroundTaskManager.BackgroundSubMode.CAR_KEY
      // }
    }
    const want= await wantAgent.getWantAgent(wantAgentInfo)

      await backgroundTaskManager.startBackgroundRunning(getContext(), backgroundTaskManager.BackgroundMode.AUDIO_PLAYBACK,
        want)
  }

//  设置元数据
  setAVMetadata(song:SongItemType){
   this.session?.setAVMetadata({
     assetId:song.id || '',
     title:song.name || '',
     mediaImage: song.img || '',
      artist:song.author || '',
     duration:this.currentMusic?.duration || 0
   })
  }
  // 设置播放状态
  setAVPlayState(isPlay:boolean){
    this.session?.setAVPlaybackState({
      state: isPlay?avSession.PlaybackState.PLAYBACK_STATE_PLAY : avSession.PlaybackState. PLAYBACK_STATE_PAUSE,
      speed:1,
      position:{
        elapsedTime: this.currentMusic?.time || 0,
        updateTime: new Date().getTime(),
      },
      duration: this.currentMusic?.duration || 0
    })
  }
//   注册事件
  registerEvent() {
   this.session?.on("play", () => {
     AvPlayerManager.getInstance().playPause()
  })
  this.session?.on('pause', () => {
    AvPlayerManager.getInstance().playPause()
  })
  this.session?.on('playPrevious', () => {
    AvPlayerManager.getInstance().prev()
  })
    this.session?.on('playNext', () => {
      AvPlayerManager.getInstance().next()
    })
  this.session?.on('seek', (value:number) => {
    AvPlayerManager.getInstance().seekPlay(value)
  })

    this.session?.activate()

  }
}

export const  sessionManager:AvSessionManager=new AvSessionManager()