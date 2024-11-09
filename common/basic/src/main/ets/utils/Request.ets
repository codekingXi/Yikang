import axios, { AxiosError, AxiosRequestConfig, AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios'
import { Log } from '@abner/log'
import { auth } from './Auth'
import { promptAction, router } from '@kit.ArkUI'
import { RouterConfig } from '../../../../Index'

//创建实例
const instance = axios.create({
  baseURL: 'https://zhyl-harmony.itheima.net',
  timeout: 10000,
})
//请求
instance.interceptors.request.use((config: InternalAxiosRequestConfig) => {
  //获取token
  const token = auth.getToken()
  if(token){
    //注入token
    config.headers.Authorization = token
  }
  return config
}, (e: AxiosError) => {
  AlertDialog.show({ message: JSON.stringify(e.message) })
  Log.error('请求异常' + JSON.stringify(e.message))
  return Promise.reject(e)
})
//响应
instance.interceptors.response.use((res: AxiosResponse) => {
  if (res.data && res.data.code !== 200) {
    return Promise.reject(new Error(res.data.msg))
  }
  Log.info('请求成功' + JSON.stringify(res.data.data))
  return res.data.data
}, async (e: AxiosError) => {
  if(e.response?.status===401){
    //token失效
    promptAction.showToast({message:'登录失败'})
    await auth.delToken()
    router.replaceUrl({
      url:RouterConfig.LOGIN_URL
    })
  }else {
    Log.error('响应异常'+JSON.stringify(e))
  }
  return Promise.reject(e)
})

/**
 * 发起请求的通用函数
 * @template Response 响应结果的类型，默认为 null
 * @template DataParms 请求参数的类型，默认为 null
 * @param config 请求配置对象
 */
export function request<Response = null, DataParms = null>(config: AxiosRequestConfig<DataParms>) {
  return instance<null, Response, DataParms>(config)
}
