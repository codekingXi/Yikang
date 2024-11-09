import { request } from "../utils/Request";
import { LoginParams } from "../viewModels";
/**
 * 登录接口*/
export function loginApi(data:LoginParams):Promise<string>{
  return request({
    url:'/employee/login',
    method:'post',
    data
  })
}