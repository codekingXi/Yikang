import { Log } from "@abner/log"
import { abilityAccessCtrl, bundleManager, common } from "@kit.AbilityKit"
import { access, ble, constant } from "@kit.ConnectivityKit"
import { promptAction } from "@kit.ArkUI"
import { BlueData } from "../viewmodel"
import { JSON, util } from "@kit.ArkTS"
import { emitter } from "@kit.BasicServicesKit"

class BlueManager {
  //1.手机的蓝牙是否开启
  checkBlueOpen() {
    return access.getState() === access.BluetoothState.STATE_ON
  }

  //2.当亲应用的蓝牙是否开启
  async checkBlue() {
    try {
      const bundleInfo =
        bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)
      const atManager = abilityAccessCtrl.createAtManager()
      const result =
        atManager.checkAccessTokenSync(bundleInfo.appInfo.accessTokenId, "ohos.permission.ACCESS_BLUETOOTH")
      Log.info(`检测蓝牙权限：${result}`)
      //   0是通过 -1是没权限

      if (result === abilityAccessCtrl.GrantStatus.PERMISSION_DENIED) {
        //   无权限
        const result = await atManager.requestPermissionsFromUser(getContext(), ["ohos.permission.ACCESS_BLUETOOTH"])
        Log.info(`用户授权结果：${JSON.stringify(result)}`)
        if (result.authResults[0] === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {

          //   用户授权了 - 有权限
          if (this.checkBlueOpen()) {
            // promptAction.showToast({
            //   message: '蓝牙已启动，开始扫描'
            // })
            // this.scanDevice()
            return true
          }
          promptAction.showToast({
            message: '蓝牙未启动，需要开启'
          })
          return Promise.reject(new Error('蓝牙未启动'))
        } else {
          //   用户拒绝了 -低版本跳系统设置，高版本(beta3以上)应用内二次申请
          let context = getContext(this) as common.UIAbilityContext;
          context.startAbility({
            bundleName: 'com.huawei.hmos.settings',
            abilityName: 'com.huawei.hmos.settings.MainAbility',
            uri: 'application_info_entry',
            parameters: {
              pushParams: 'com.panpu.myapplication' // 应用包名
            }
          });
          return false
        }
      } else {
        if (this.checkBlueOpen()) {
          // promptAction.showToast({
          //   message: '蓝牙已启动，开始扫描'
          // })
          // this.scanDevice()
          return true
        }
        promptAction.showToast({
          message: '蓝牙未启动，需要开启'
        })
        return Promise.reject(new Error('蓝牙未启动'))
      }
    } catch (err) {
      Log.info('Catch error')
      promptAction.showToast({
        message: JSON.stringify(err)
      })
      return Promise.reject(err)
    }
  }

  // 3.扫描蓝牙
  scanDevice(callBack: (list: ble.ScanResult[]) => void) {
    const deviceList: ble.ScanResult[] = []
    // list是每一次的扫描结果，可能是一个，也可能是多个
    ble.on('BLEDeviceFind', (list: ble.ScanResult[]) => {
      Log.info(JSON.stringify(list))
      const newList = list.filter(item => {
        // item.deviceId扫描到每一台设备的id
        return !deviceList.some(dv => dv.deviceId === item.deviceId)
      })
      deviceList.push(...newList)
      callBack(deviceList)
    })
    ble.startBLEScan(null, {
      interval: 500,
      dutyMode: ble.ScanDuty.SCAN_MODE_LOW_POWER,
      matchMode: ble.MatchMode.MATCH_MODE_AGGRESSIVE
    })
  }

  //GattClient-保存不被回收
  currentClient: ble.GattClientDevice | null = null

  // 4.连接蓝牙设备
  connectBlue(deviceId: string, callBack: () => void) {
    // 与目标设备建立连接
    this.currentClient = ble.createGattClientDevice(deviceId)
    // 监听状态
    this.currentClient.on('BLEConnectionStateChange', (res) => {
      //如果状态是已连接
      if (res.state === constant.ProfileConnectionState.STATE_CONNECTED) {
        callBack()
        this.currentClient?.on('BLECharacteristicChange', (res) => {
          const td = util.TextDecoder.create()
          const writeData = new Uint8Array(res.characteristicValue)
          const result = JSON.parse(td.decodeToString(writeData)) as BlueData
          if (result.command === 'wifi') {
            emitter.emit('WifiConnect', {
              data: {
                status: result.status
              }
            })
          } else {
            //   开门
          }
        })
      }
    })
    // 发起链接
    this.currentClient.connect()
  }

  // 5.通过蓝牙发送数据
  // 关注点：服务是谁，特征是什么
  async sendData(data: BlueData) {
    if (this.currentClient) {
      // 获取所有的蓝牙服务 ->  eg:从门禁，血糖仪...设备中找出门禁
      const list = await this.currentClient.getServices()
      const doorService = list.find(item => item.serviceUuid.startsWith('0000AE30'))
      if (doorService) {
        // 写入特征：写入wifi账号密码到设备
        const writeObj = doorService.characteristics.find(item => item.characteristicUuid.startsWith('0000AE10'))
        if (writeObj) {
          const writeData = new util.TextEncoder().encodeInto(JSON.stringify(data))
          this.currentClient.writeCharacteristicValue({
            serviceUuid: writeObj.serviceUuid,
            characteristicUuid: writeObj.characteristicUuid,
            characteristicValue: writeData.buffer,
            descriptors: []
          }, ble.GattWriteType.WRITE)
        }
      }
    }
  }

  // 6.通知开门
  async openDoor() {
    if (this.currentClient) {
      const serviceList = await this.currentClient.getServices()
      // 1.拿到服务
      const doorService = serviceList.find(item => item.serviceUuid.startsWith('0000AE30'))
      // 2.查找特征
      if (doorService) {
        const emmitService = doorService.characteristics.find(item => item.characteristicUuid.startsWith('0000AE10'))
        if (emmitService) {
          const data: BlueData = {
            command: 'open'
          }
          const emmitData = new util.TextEncoder().encodeInto(JSON.stringify(data))
          this.currentClient.writeCharacteristicValue({
            serviceUuid: emmitService.serviceUuid,
            characteristicUuid: emmitService.characteristicUuid,
            characteristicValue: emmitData.buffer,
            descriptors: []
          }, ble.GattWriteType.WRITE)
        }
      }
    }
  }
}

export const blueManager = new BlueManager()