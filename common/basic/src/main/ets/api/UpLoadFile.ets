import { FormData } from "@ohos/axios";
import { request } from "../utils/Request";
/**
 * 文件上传接口*/
export function uploadFile(data:FormData):Promise<string> {
  return request({
    url:'/common/upload',
    method:'post',
    context:getContext(),
    headers:{
      "Content-Type":"multipart/form-data"
    },
    data
  })
}