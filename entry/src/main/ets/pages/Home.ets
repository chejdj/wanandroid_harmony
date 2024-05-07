import { Api } from '../networks/Api'
import { Article } from '../networks/model/ArticlesData'
import { HomeBanner } from '../networks/model/HomeBanner'
import { PullToRefresh } from '@ohos/pulltorefresh'

@Entry
@Component
struct Home {
  @State private homeData: Array<Object> = []
  private currentPage: number = 0
  private scroller: Scroller = new Scroller()
  private loadMoreEnding: boolean = false

  aboutToAppear() {
    this.initData().then((data => {
      this.homeData = data
    }))
  }

  private initData(): Promise<Array<Object>> {
    return new Promise<Array<Object>>(async (resolver, reject) => {
      this.currentPage = 0
      while (this.homeData.length > 0) {
        this.homeData.pop()
      }
      let bannerRes = await Api.get().getHomeBanner()
      let articles = await Api.get().getHomeArticles(this.currentPage)
      if (bannerRes.isSuccess() && articles.isSuccess()) {
        let bannerList = bannerRes.data
        let articleList = []
        articleList = articleList.concat(articles.data.datas)
        let dataList = [bannerList].concat(articleList)
        this.currentPage = articles.data.curPage
        resolver(dataList)
      } else {
        reject()
      }
    })
  }

  private loadMoreArticles(): Promise<Array<Object>> {
    return new Promise<Array<Object>>(async (resolver, reject) => {
      let articles = await Api.get().getHomeArticles(this.currentPage)
      if (articles.isSuccess()) {
        this.currentPage = articles.data.curPage
        this.loadMoreEnding = articles.data.over
        resolver(articles.data.datas)
      } else {
        reject()
      }
    });
  }

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
      PullToRefresh({
        data: $homeData,
        scroller: this.scroller,
        customList: () => {
          this.ListViewLayout()
        },
        onRefresh: () => {
          return new Promise<string>((resolve, _) => {
            this.initData().then((data) => {
              this.homeData = data
              resolve("刷新成功")
            }, (_) => {
              resolve("出了一些问题")
            })
          })
        },
        onLoadMore: () => {
          return new Promise<string>((resolve, _) => {
            if (!this.loadMoreEnding) {
              this.loadMoreArticles().then((data) => {
                this.homeData = this.homeData.concat(data)
                resolve("加载成功")
              }, (_) => {
                resolve("加载失败")
              })
            } else {
              resolve("没有更多了")
            }
          })
        },
        customRefresh: null,
        customLoad: null
      })
    }.width('100%').height('100%').alignItems(HorizontalAlign.Center)
  }

  //Banner+Article的布局文件
  @Builder
  ListViewLayout() {
    List({ scroller: this.scroller }) {
      ForEach(this.homeData, (item: Object) => {
        if (item instanceof Array) {
          ListItem() {
            BannerBuilder({
              bannerList: item as Array<HomeBanner>
            })
          }
        } else {
          ListItem() {
            this.ArticleDetailLayout(item as Article)
          }.borderRadius(8).shadow({
            radius: 4,
            color: `rgba(0,0,0,0.3)`
          }
          ).width('100%').margin({
            top: 12,
            left: 12,
            right: 12
          })
        }
      })
    }.listDirection(Axis.Vertical).width('100%').height('100%').edgeEffect(EdgeEffect.None)
  }

  @Builder
  ArticleDetailLayout(item: Article) {
    Column() {
      Text(item.title)
        .fontSize(18)
        .fontColor(0x00000000)
        .margin({
          top: 8,
          bottom: 8
        })
        .width('100%')
        .padding({
          top: 8
        })
        .textAlign(TextAlign.Start)
      Text(item.desc).fontSize(12).fontColor(0xD0D0D0).margin({
        bottom: 4,
      })
      Row() {
        Text(item.superChapterName + "/" + item.chapterName).fontSize(12).fontColor(0xD0D0D0)
          .border({
            width: 1,
            color: Color.Green,
            radius: 12
          }).padding({ top: 3, bottom: 3, left: 6, right: 6 })
        Text(item.author).fontSize(12).fontColor(0xD0D0D0).margin({
          left: 8
        })
      }.margin({ bottom: 8 })
    }.width('100%').alignItems(HorizontalAlign.Start).padding({
      left: 8,
      right: 8
    })
  }
}
/**
 * 顶部Banner
 */
@Component
struct BannerBuilder {
  private swiperController: SwiperController = new SwiperController()
  @State private bannerPosition: number = 0
  bannerList: Array<HomeBanner> = []

  constructor(bannerList: Array<HomeBanner>) {
    super()
    this.bannerList = bannerList
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
        .backgroundColor(0x66000000)
    }.width('100%').height('100%').onClick((_) => {
      //TODO
    })
  }
}
