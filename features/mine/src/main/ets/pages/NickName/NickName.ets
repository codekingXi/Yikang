import { ResManager, upDataUserNameApi } from '@hm/basic/Index';
import { promptAction, router } from '@kit.ArkUI';

@Entry
@Component
struct NickName {
  @StorageProp('topHeight')
  topHeight: number = 0
  @State
  nickName: string = ''
  aboutToAppear(): void {
    const params = router.getParams() as object
    if(params&&params['name']){
      this.nickName = params['name']
    }
  }
  // 提交
  async save() {
    await upDataUserNameApi(this.nickName)
    promptAction.showToast({message:'更新成功'})
    getContext().eventHub.emit('updateUser')
  }

  build() {
    Navigation() {
      Column() {
        TextInput({ text: $$this.nickName, placeholder: '请输入昵称' })
          .height(50)
          .borderRadius(ResManager.EC_NORMAL_RD)
          .backgroundColor('#fff')
          .placeholderColor(ResManager.EC_MID_99)
        //   提交
        Button('保存', { type: ButtonType.Capsule })
          .margin({ top: 50 })
          .width(230)
          .enabled(!!this.nickName.trim())
          .onClick(() => {
            this.save()
          })
      }
      .margin({ left: 15, right: 15 })

    }
    .title('昵称')
    .padding({ top: this.topHeight })
    .titleMode(NavigationTitleMode.Mini)
    .backgroundColor(ResManager.EC_MID_BG)
  }
}