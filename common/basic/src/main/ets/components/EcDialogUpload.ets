import picker from '@ohos.file.picker'
import cameraPicker from '@ohos.multimedia.cameraPicker';
import camera from '@ohos.multimedia.camera';
import common from '@ohos.app.ability.common';
import { BusinessError } from '@ohos.base';
import { ResManager } from '../utils/ResManager';
import { photoAccessHelper } from '@kit.MediaLibraryKit';

@CustomDialog
export struct EcDialogUpload {
  // 控制器
  controller: CustomDialogController
  callBack:(url:string)=>void=()=>{}
  //拍照
  async takePhoto() {
    const result = await cameraPicker.pick(getContext(), [cameraPicker.PickerMediaType.PHOTO], {
      cameraPosition: camera.CameraPosition.CAMERA_POSITION_BACK
    })
    if (result) {
      this.callBack(result.resultUri)
    }
    this.controller.close()
  }

  //打开相册
  async selectPhoto() {
    const Photo = new photoAccessHelper.PhotoViewPicker()
    const results = await Photo.select({
      MIMEType: photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE,
      maxSelectNumber: 1
    })
    const result = results.photoUris[0]
    if(result){
      this.callBack(result)
    }
    this.controller.close()
  }

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
        }.onClick(() => {
          this.takePhoto()
        })

        ListItem() {
          Text('从相册选择')
            .fontColor(ResManager.EC_MAIN_COLOR)
            .fontSize(ResManager.EC_MODULE_TITLE_FS)
            .fontWeight(500)
            .width('100%')
            .textAlign(TextAlign.Center)
            .padding(15)
        }.onClick(() => {
          this.selectPhoto()
        })

        ListItem() {
          Text('取消')
            .fontColor(ResManager.EC_MID_59)
            .fontSize(ResManager.EC_MODULE_TITLE_FS)
            .fontWeight(500)
            .width('100%')
            .textAlign(TextAlign.Center)
            .padding(15)
        }.onClick(() => {
          this.controller.close()
        })
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
