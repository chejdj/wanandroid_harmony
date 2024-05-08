import { Home } from './Home'

@Entry
@Component
struct Index {
  @State
  private currentIndex: number = 0

  build() {
    Tabs({ barPosition: BarPosition.End }) {
      TabContent() {
        Home()
      }.tabBar(this.TabBuilder('首页', 0, $r('app.media.menu_home_selected'), $r('app.media.menu_home')))

      TabContent() {
        Text('体系')
      }
      .tabBar(this.TabBuilder('体系', 1, $r('app.media.menu_architecture_selected'), $r('app.media.menu_architecture')))

      TabContent() {
        Text('公众号')
      }.tabBar(this.TabBuilder('公众号', 2, $r('app.media.menu_wechat_selected'), $r('app.media.menu_wechat')))

      TabContent() {
        Text('项目')
      }.tabBar(this.TabBuilder('项目', 3, $r('app.media.menu_project_selected'), $r('app.media.menu_project')))
    }.onChange((index => {
      this.currentIndex = index
    }))
  }

  @Builder
  TabBuilder(title: string, targetIndex: number, selectedImg: Resource, normalImg: Resource) {
    Column() {
      Image(this.currentIndex == targetIndex ? selectedImg : normalImg)
        .size({ width: 25, height: 25 })
        .objectFit(ImageFit.Contain)
      Text(title).fontColor(this.currentIndex == targetIndex ? '#ffff4444' : '#ff000000').fontSize(12).margin({
        top: 2
      })
    }
  }
}