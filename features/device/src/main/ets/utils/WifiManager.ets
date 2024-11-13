import wifiManager from "@ohos.wifiManager"


class WfManager {
  checkWifi() {
    return wifiManager.isWifiActive()
  }

  scanWifi() {
    return wifiManager.getScanInfoList()
  }
}

export const wfManager = new WfManager()