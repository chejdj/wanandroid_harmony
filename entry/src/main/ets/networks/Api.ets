import http from '@ohos.net.http';
import { HomeBanner } from './model/HomeBanner';
import { Response } from './model/Response';

let BASE_URL: string = "https://www.wanandroid.com/"

async function requestSync<T>(path: string, method: http.RequestMethod, extraData?: Object):
  Promise<Response<T>> {
  return new Promise<Response<T>>((resolve, _) => {
    let url = BASE_URL + path
    let httpRequest = http.createHttp()
    httpRequest.request(url, {
      method: method,
      expectDataType: http.HttpDataType.OBJECT,
      extraData: extraData
    }, (err, data) => {
      let res = new Response<T>()
      if (!err && data.responseCode == 200) {
        if (typeof data.result === 'string') {
          Object.assign(res, JSON.parse(data.result))
        } else {
          Object.assign(res, data.result)
        }
      } else {
        res.errorCode = data?.responseCode ?? -1
        res.errorMsg = err?.message ??""
      }
      resolve(res)
    })
  });
}

export class Api {
  private static instance: Api;

  private constructor() {
  }

  static get(): Api {
    if (Api.instance == undefined) {
      Api.instance = new Api();
    }
    return Api.instance
  }

  async getHomeBanner(): Promise<Response<Array<HomeBanner>>> {
    return requestSync("banner/json", http.RequestMethod.GET)
  }
}