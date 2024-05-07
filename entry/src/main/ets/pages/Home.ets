import { Api } from '../networks/Api'
import { HomeBanner } from '../networks/model/HomeBanner'

@Entry
@Component
struct Home {
  build() {
    Column() {
      Text("首页")
        .fontSize(20)
        .fontColor(0xFFFFFF)
        .padding({
          top: 32,
          bottom: 16
        })
        .backgroundColor(0xFFD81B60)
        .width('100%')
        .textAlign(TextAlign.Center)
      BannerBuilder()
    }.width('100%').alignItems(HorizontalAlign.Center)
  }
}

/**
 * 顶部Banner
 */
@Component
struct BannerBuilder {
  private swiperController: SwiperController = new SwiperController()
  @State private bannerPosition: number = 0
  @State private bannerList: Array<HomeBanner> = []

  aboutToAppear() {
    Api.get().getHomeBanner().then((data) => {
      this.bannerList = data.data
    })
  }

  build() {
    Stack() {
      Swiper(this.swiperController) {
        ForEach(this.bannerList, (item) => {
          this.bannerItemBuilder(item)
        })
      }
      .autoPlay(true)
      .loop(true)
      .index(this.bannerPosition)
      .indicatorStyle({
        right: 16,
        bottom: 0
      }
      )
      .onChange((index) => {
        this.bannerPosition = index
      })
      .width('100%')
      .height(220)
    }
  }

  @Builder
  bannerItemBuilder(data: HomeBanner) {
    Stack({ alignContent: Alignment.Bottom }) {
      Image(data.imagePath).objectFit(ImageFit.Cover).width('100%').height('100%')
      Text(data.title)
        .width('100%')
        .padding({ left: 16, top: 6, right: 16, bottom: 6 })
        .fontColor(0xFFFFFFFF)
        .fontSize(15)
        .maxLines(1)
    }.width('100%').height('100%').onClick((_) => {

    })
  }
}
