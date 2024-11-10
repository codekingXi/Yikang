import { request } from "../utils/Request";
import { LoginParams, UserData } from "../viewModels";

/**
 * 登录接口*/
export function loginApi(data: LoginParams): Promise<string> {
  return request({
    url: '/employee/login',
    method: 'post',
    data
  })
}

/**
 * 用户信息查询接口*/
export function getUserApi(): Promise<UserData> {
  return request({
    url: '/employee/user',
    method: 'get'
  })
}

/**
 * 用户头像修改接口*/
export function upDataUserAvatarApi(avatar: string): Promise<null> {
  return request({
    url: '/employee/user/updateAvatar',
    method: 'put',
    params: {
      avatar: avatar
    }
  })
}
/**
 * 用户昵称修改接口*/
export function upDataUserNameApi(name: string): Promise<null> {
  return request({
    url: '/employee/user/updateNickname',
    method: 'put',
    params: {
      nickName:name
    }
  })
}