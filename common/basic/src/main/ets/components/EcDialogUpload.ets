import picker from '@ohos.file.picker'
import cameraPicker from '@ohos.multimedia.cameraPicker';
import camera from '@ohos.multimedia.camera';
import common from '@ohos.app.ability.common';
import { BusinessError } from '@ohos.base';
import { ResManager } from '../utils/ResManager';

@CustomDialog
export struct EcDialogUpload {
  // 控制器
  controller: CustomDialogController

  build() {
    Column() {
      // 选项列表
      List() {
        ListItem() {
          Text('拍照')
            .fontColor(ResManager.EC_MAIN_COLOR)
            .fontSize(ResManager.EC_MODULE_TITLE_FS)
            .fontWeight(500)
            .width('100%')
            .textAlign(TextAlign.Center)
            .padding(15)
        }

        ListItem() {
          Text('从相册选择')
            .fontColor(ResManager.EC_MAIN_COLOR)
            .fontSize(ResManager.EC_MODULE_TITLE_FS)
            .fontWeight(500)
            .width('100%')
            .textAlign(TextAlign.Center)
            .padding(15)
        }

        ListItem() {
          Text('取消')
            .fontColor(ResManager.EC_MID_59)
            .fontSize(ResManager.EC_MODULE_TITLE_FS)
            .fontWeight(500)
            .width('100%')
            .textAlign(TextAlign.Center)
            .padding(15)
        }
      }
      .width('100%')
      .height('auto')
      .divider({ strokeWidth: 0.5, color: ResManager.EC_MID_LINE })
      .padding(ResManager.EC_CONTENT_SPACE)
      .backgroundColor('#fff')
      .borderRadius(ResManager.EC_NORMAL_RD)

    }
  }
}
