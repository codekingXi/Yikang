import axios, { AxiosError, AxiosRequestConfig, AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios'
import { Log } from '@abner/log'

//创建实例
const instance = axios.create({
  baseURL: 'https://zhyl-harmony.itheima.net',
  timeout: 10000,
})
//请求
instance.interceptors.request.use((config: InternalAxiosRequestConfig) => {
  //注入token
  config.headers.Authorization =
    'eyJhbGciOiJIUzI1NiJ9.eyJjdXJyZW50VXNlciI6IntcInVzZXJuYW1lXCI6XCIzNTQyMzQ4NEBxcS5jb21cIixcInBhc3N3b3JkXCI6XCJcIixcIm5pY2tOYW1lXCI6XCLmiqTnkIblkZgxXCIsXCJlbWFpbFwiOlwiMzU0MjM0ODRAcXEuY29tXCIsXCJyZWFsTmFtZVwiOlwi5oqk55CG5ZGYMVwiLFwibW9iaWxlXCI6XCIxODIxMTAyMTg5NlwiLFwic2V4XCI6XCIwXCIsXCJkZXB0Tm9cIjpcIjEwMDAwMTAwNTAwMDAwMFwiLFwicG9zdE5vXCI6XCIxMDAwMDEwMDUwMDMwMDBcIixcImRhdGFTdGF0ZVwiOlwiMFwiLFwiYXZhdGFyXCI6XCJodHRwczovL3lqeS1vc3MtdmlkZW9zLm9zcy1hY2NlbGVyYXRlLmFsaXl1bmNzLmNvbS9ncnp4aHouanBnXCIsXCJpZFwiOjE2NzE0MDMyNTY1MTkwNzgyNzUsXCJjcmVhdGVUaW1lXCI6MTcxNTU2ODM5MDAwMCxcInVwZGF0ZVRpbWVcIjoxNzE1NTY4MzkwMDAwLFwiY3JlYXRlQnlcIjoxNjcxNDAzMjU2NTE5MDc4MTM4fSIsImV4cCI6MTQ2NzU2NTk0Nzd9.8PrMKBNrVVCfcI4DgICxp6oBQGqy46m3oglFQCiKtzw'
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
}, (e: AxiosError) => {
  AlertDialog.show({ message: JSON.stringify(e.message) })
  Log.error('响应异常' + JSON.stringify(e.message))
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
