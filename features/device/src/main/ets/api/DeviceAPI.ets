import { request } from "@hm/basic";
import { UnBindProductItemModel } from "../viewmodel";

export function getUnBindDeviceListApi():Promise<UnBindProductItemModel[]> {
  return request<UnBindProductItemModel[]>({
    url: '/employee/iot/deviceTree',
    method: 'get'
  });
}