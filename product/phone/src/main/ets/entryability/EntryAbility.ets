import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import "../utils/plugin"
import { Log } from '@abner/log';
import { auth, infoConfig, RouterConfig } from '@hm/basic';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    Log.info('Ability onDestroy');
    infoConfig.context = this.context
  }

  onDestroy(): void {
    Log.info('Ability onDestroy');
  }

  async onWindowStageCreate(windowStage: window.WindowStage): Promise<void> {
    // Main window is created, set main page for this ability
    Log.info('Ability onWindowStageCreate');
    //创建子窗口
    const win = await windowStage.createSubWindow(infoConfig.AD_WIN)
    //显示子窗口
    await win.showWindow()
    //设置子窗口内容
    win.setUIContent(RouterConfig.SPLASH_URL)
    //有token就进入首页，没有就进入登录页
    if (auth.getToken()) {
      windowStage.loadContent('pages/Index');
    } else {
      windowStage.loadContent(RouterConfig.LOGIN_URL);
    }
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    Log.info('Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    Log.info('Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    Log.info('Ability onBackground');
  }
}