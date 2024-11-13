import { Device, DeviceCate, DeviceItem, DeviceItemModel, UnBindProductItemModel } from '../../viewmodel/DeviceModel'
import router from '@ohos.router'
import { getDeviceMap, ResManager, RouterConfig } from '@hm/basic/Index'
import { getMyDeviceListApi, unbindDeviceApi } from '../../api'
import { promptAction } from '@kit.ArkUI'

// 设备选择
@Entry
@Component
struct MyDevice {
  @StorageProp('topHeight')
  topHeight: number = 0
  scroller: Scroller = new Scroller()
  @State
  private devices: UnBindProductItemModel[] = []

  // 解绑
  unbind(item: DeviceItemModel) {
    AlertDialog.show({
      title: '解除确认',
      message: '确认要解除该设备吗？',
      primaryButton: {
        value: '取消',
        fontColor: ResManager.EC_MID_59,
        action: () => {

        }
      },
      secondaryButton: {
        value: '确定',
        fontColor: ResManager.EC_MAIN_COLOR,
        action: async () => {
          await unbindDeviceApi(item.iotId)
          this.devices = await getMyDeviceListApi()
          promptAction.showToast({
            message: '解绑成功'
          })
        }
      },
      alignment: DialogAlignment.Center
    })
  }

  async aboutToAppear() {
    this.devices = await getMyDeviceListApi()
  }

  build() {
    // 导航栏
    Navigation() {
      Column() {
        // 设备列表
        Scroll(this.scroller) {
          Column({ space: 20 }) {
            ForEach(this.devices, (product: UnBindProductItemModel) => {
              Column() {
                // 标题
                Text(getDeviceMap(product.productName)?.cn)
                  .fontColor(ResManager.EC_MID_19)
                  .fontSize(ResManager.EC_MODULE_TITLE_FS)
                  .fontWeight(500)
                  .margin({ bottom: 18 })
                // 内容
                GridRow({ columns: 2, gutter: { x: 10, y: 10 } }) {
                  ForEach(product.deviceList, (device: DeviceItemModel, i: number) => {
                    GridCol() {
                      Stack({ alignContent: Alignment.TopEnd }) {
                        Column({ space: 10 }) {
                          Image(getDeviceMap(product.productName)?.icon)
                            .width(80)
                            .aspectRatio(1)
                          Text(device.deviceName)
                            .fontColor(ResManager.EC_MID_19)
                            .fontSize(ResManager.EC_SMALL_FS)
                        }
                        .width('100%')
                        .padding({ top: 30, bottom: 20 })
                        .borderRadius(8)
                        .backgroundColor(ResManager.EC_MID_WHITE)
                        .onClick(() => {
                          router.pushUrl({
                            url: RouterConfig.DEVICE_DOOR_CONTROL_URL
                          })
                        })

                        Text('解绑')
                          .fontColor(ResManager.EC_MAIN_COLOR)
                          .fontSize(ResManager.EC_SMALL_FS)
                          .margin({ top: 10, right: 10 })
                          .onClick(() => {
                            this.unbind(device)
                          })

                      }
                    }
                    .onClick(() => {
                      router.back()
                    })
                  })
                }
              }
              .width('100%')
              .alignItems(HorizontalAlign.Start)
            })
          }
          .width('100%')
        }
        .scrollable(ScrollDirection.Vertical) // 滚动方向纵向
        .scrollBar(BarState.Off) // 滚动条常驻显示
      }
      .width('100%')
      .height('100%')
      .backgroundColor(ResManager.EC_MID_BG)
      .padding(15)

    }
    .title('我的设备')
    .titleMode(NavigationTitleMode.Mini)
    .padding({ top: this.topHeight })
    .backgroundColor(ResManager.EC_MID_BG)
  }
}