import { preferences } from '@kit.ArkData'
import { infoConfig } from '../constants'

class Auth {
  //获取仓库信息
  getStore() {
    return preferences.getPreferencesSync(infoConfig.context || getContext(), {
      name: infoConfig.USER_TOKEN_STORE
    })
  }

  //设置token
  async setToken(token: string) {
    const store = this.getStore()
    store.putSync(infoConfig.USER_TOKEN_KEY, token)
    await store.flush()
  }

  //获取token
  getToken() {
    const store = this.getStore()
    const result = store.getSync(infoConfig.USER_TOKEN_KEY, '') as string
    return result
  }

  //删除token
  async delToken() {
    const store = this.getStore()
    store.deleteSync(infoConfig.USER_TOKEN_KEY)
    await store.flush()
  }
}

export const auth = new Auth()