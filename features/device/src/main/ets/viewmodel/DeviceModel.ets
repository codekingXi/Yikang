export class Device {
  name: string = ''
  icon: Resource | string = ''
}

export class DeviceCate {
  title: string = ''
  list: Device[] = []
  cb?: () => void = () => {
  }
}

//  2. 未绑定设备列表
export interface DeviceItem {
  iotId: string
  nodeId: string
  deviceName: string
  isSelected: boolean
}

export interface UnBindProductItem {
  productId: string
  productName: string
  // 是否展开：false 没有点击查看更多 | true 点击了查看更多
  isExpand: boolean
  deviceList: DeviceItem[]
}

export class DeviceItemModel implements DeviceItem {
  iotId: string = ''
  nodeId: string = ''
  deviceName: string = ''
  isSelected: boolean = false

  constructor(model: DeviceItem) {
    this.iotId = model.iotId
    this.nodeId = model.nodeId
    this.deviceName = model.deviceName
    this.isSelected = model.isSelected
  }
}

export class UnBindProductItemModel implements UnBindProductItem {
  productId: string = ''
  productName: string = ''
  isExpand: boolean = false
  deviceList: DeviceItem[] = []

  constructor(model: UnBindProductItem) {
    this.productId = model.productId
    this.productName = model.productName
    this.isExpand = model.isExpand
    this.deviceList = model.deviceList
  }
}

// 下发给设备的数据类型(和硬件工程师约定)
export interface BlueData {
  status?: 200 | 400 //200成功,400失败
  msg?: string //提示信息
  command?: 'open' | 'wifi' //下发硬件执行
  data?: string[] //连接wifi-> [account,password]
}
