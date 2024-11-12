import { ProductNameList } from "../../../../Index";

export function getDeviceMap(name:string){
  return ProductNameList.find(item=>item.en===name)
}