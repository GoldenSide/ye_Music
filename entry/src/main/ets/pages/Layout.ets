import { Recommend } from './Recommend';
import { Find } from './Find';
import { Moment } from './Moment';
import { Mine } from './Mine';

interface  TabClass{
  text:string
  icon:ResourceStr
}

@Builder
export function  LayoutBuilder(){
  Layout()
}



@Component
struct Layout {
  @State message: string = '布局页';
  pathStack: NavPathStack = AppStorage.get('pathStack')?? new NavPathStack()
  tabData: TabClass[] = [
    { text: '推荐', icon: $r('app.media.ic_recommend') },
    { text: '发现', icon: $r('app.media.ic_find') },
    { text: '动态', icon: $r('app.media.ic_moment') },
    { text: '我的', icon: $r('app.media.ic_mine') }
  ];
  @State currentTabIndex: number = 1;

  @Builder tabBuilder(item: TabClass,index: number){
     Column({space:4}) {
       Image(item.icon)
         .width(this.currentTabIndex === index?24:20)
         .height(this.currentTabIndex === index?24:20)
         .fillColor(this.currentTabIndex === index ? '#E85A88': '#63AAAA')
       Text(item.text)
         .fontColor(this.currentTabIndex === index ? '#E85A88' : '#63AAAA')
         .fontSize(this.currentTabIndex === index?14:12)
     }
  }

  build() {
    NavDestination(){
      Tabs({
        barPosition: BarPosition.End
      }){
         ForEach(this.tabData, (item: TabClass, index: number) => {
           TabContent(){
             if (this.currentTabIndex  === 0) {
               Recommend()
             } else if (this.currentTabIndex === 1) {
               Find()
             } else if (this.currentTabIndex === 2) {
               Moment()
             } else if (this.currentTabIndex === 3) {
               Mine()
             }
           }
           .tabBar(this.tabBuilder(item,index)).backgroundColor('#131215')
           .expandSafeArea( [ SafeAreaType.SYSTEM ],[SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
         })
      }
      .onChange((index: number) => {
        this.currentTabIndex = index;
      })
      .backgroundColor('#2B3F42')
      .expandSafeArea( [ SafeAreaType.SYSTEM ],[SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    }.onReady((context: NavDestinationContext) =>
    this.pathStack = context.pathStack
    )
  }
}