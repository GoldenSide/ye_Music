// Start.ets


@Builder
export function  StartBuilder() {
  Start()
}


@Component
struct Start {
  @State message: string = '欢迎来到 Start 页面';
  @State countSeconds: number = 5;
  pathStack: NavPathStack = new NavPathStack();

  // 页面生命周期：页面显示时触发
  onPageShow() {
    console.log('Start page onPageShow');
    // 可以在这里执行页面显示时的初始化操作，如数据加载
  }

  // 页面生命周期：页面隐藏时触发
  onPageHide() {
    console.log('Start page onPageHide');
    // 可以在这里执行页面隐藏时的清理操作
  }

  // 组件生命周期：组件即将出现时触发
  aboutToAppear() {
    console.log('Start page aboutToAppear');
    setTimeout(() => {
      this.pathStack.replacePathByName('Layout', null,false )
    }, 3000)
  }

  // 组件生命周期：组件即将消失时触发
  aboutToDisappear() {
    console.log('Start page aboutToDisappear');
  }



  build() {
    NavDestination(){
      Stack({
        alignContent:Alignment.TopEnd
      }) {
        Image($r('app.media.ad')).width('100%').height('100%')
          .expandSafeArea( [ SafeAreaType.SYSTEM ],[SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])

        Button('跳转')
          .width(60)
          .height(40)
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .backgroundColor(Color.Gray)
          .margin({ right: 20, top: 20 })
          .onClick(() => {
            this.pathStack.replacePathByName('Layout', null,false )
          })
      }

    }.onReady((context: NavDestinationContext) =>
      this.pathStack = context.pathStack
    )
  }
}