import { SongItemType } from "./music"

export enum PlayMode {
  ORDER = "order",
  LOOP = "loop",
  RANDOM = "random"
}


export interface currentMusic {
  img: string
  name: string
  author: string
  url: string
  time: number
  duration: number
  isPlay: boolean
  playIndex: number
  playList: SongItemType[]
  playMode:PlayMode
  id: string
}

export class GlobalMusic implements currentMusic {
  id: string = ""
  img: string = ""  // 音乐封面
  name: string = ""  // 音乐名称
  author: string = ""  // 作者
  url: string = ""  // 当前播放链接
  time: number = 0  // 播放时间
  duration: number = 0  // 音乐的播放时长
  isPlay: boolean = false  // 是否正在播放
  playIndex: number = 0  // 当前播放的索引
  playList: Array<SongItemType> = []  // 播放列表
  playMode: PlayMode = PlayMode.ORDER
  reset(): void {
    this.img = ""
    this.name = ""
    this.author = ""
    this.url = ""
    this.time = 0
    this.duration = 0
    this.isPlay = false
    this.playIndex = 0
    this.playList = []
    this.playMode = PlayMode.ORDER
  }
}