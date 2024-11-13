import wifiManager from "@ohos.wifiManager"


/**
 * WfManager类负责管理和操作WiFi相关的功能
 */
class WfManager {
  /**
   * 检查WiFi是否处于激活状态
   * @returns {boolean} 返回一个布尔值，true表示WiFi处于激活状态，false表示未激活
   */
  checkWifi() {
    return wifiManager.isWifiActive()
  }

  /**
   * 扫描并获取周围的WiFi信息列表
   * @returns {Array} 返回一个包含WiFi网络信息对象的数组，每个对象代表一个检测到的WiFi网络
   */
  scanWifi() {
    return wifiManager.getScanInfoList()
  }
}

/**
 * wifi管理实例*/
export const wfManager = new WfManager()
