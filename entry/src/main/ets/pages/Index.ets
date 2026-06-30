
@Entry
@Component
struct Index {
  @StorageLink('pathStack') pathStack: NavPathStack = new NavPathStack();

  build() {
    Navigation(this.pathStack){
    }.onAppear(() => {
       this.pathStack.pushPathByName('Start', null,false )
    }).hideNavBar(true)
  }
}