import { ResManager } from '../utils'
import { router } from '@kit.ArkUI'
import { RouterConfig } from '../constants'

class DeviceBuilderParam {
  title: string = ''
  icon: ResourceStr = ''
  pos: 'x' | 'y' = 'x'
  url: string = ''
}

@Builder
export function DeviceBuilder() {
  Row({ space: 10 }) {
    careItem({
      title: '设备安装',
      icon: $r('app.media.icon_home_sbaz'),
      pos: 'y',
      url: RouterConfig.DEVICE_SETUP_URL
    })
    careItem({
      title: '设备绑定',
      icon: $r('app.media.icon_home_sbkz'),
      pos: 'y',
      url: RouterConfig.DEVICE_BIND_URL
    })
    careItem({
      title: '我的设备',
      icon: $r('app.media.icon_home_wdsb'),
      pos: 'y',
      url: RouterConfig.DEVICE_MY_URL
    })
    careItem({
      title: '报警设备',
      icon: $r('app.media.icon_home_bjsb'),
      pos: 'y',
      url: RouterConfig.DEVICE_ALARM_URL
    })
  }
  .width('100%')
  .justifyContent(FlexAlign.SpaceBetween)
}

// 模块item
@Builder
function careItem(param: DeviceBuilderParam) {
  if (param.pos === 'x') {
    // 护理工作台
    Row({ space: 10 }) {
      Image(param.icon)
        .width(48)
        .aspectRatio(1)
      Text(param.title)
        .fontColor(ResManager.EC_MID_19)
        .fontSize(ResManager.EC_NORMAL_FS)
    }
    .padding({
      top: 20,
      bottom: 23,
      left: 13,
      right: 13
    })
    
    .modStyle()
    .onClick(() => {
      router.pushUrl({
        url: param.url
      })
    })
  } else {
    // 设备管理
    Column({ space: 10 }) {
      Image(param.icon)
        .width(40)
        .aspectRatio(1)
      Text(param.title)
        .fontColor(ResManager.EC_MID_19)
        .fontSize(ResManager.EC_SMALL_FS)
    }
    .padding({ top: 23, bottom: 23 })
    .modStyle()
    .onClick(() => {
      router.pushUrl({
        url: param.url
      })
    })
  }
}


// 可复用样式
@Styles
function modStyle() {
  .borderRadius(8)
  .layoutWeight(1)
  .backgroundColor(ResManager.EC_MID_WHITE)
}