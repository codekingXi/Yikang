import router from '@ohos.router'
import { EcDialogUpload, getUserApi, ResManager,
  RouterConfig,
  upDataUserAvatarApi, uploadFile, UserData } from '@hm/basic/Index'
import { EcLoading } from '@itheima/wing-care'
import { fileIo } from '@kit.CoreFileKit'
import { FormData } from '@ohos/axios'
import { Log } from '@abner/log'
import { promptAction } from '@kit.ArkUI'


@Entry
@Component
struct Setting {
  @StorageProp('topHeight')
  topHeight: number = 0
  // 加载弹窗
  loadDialog: CustomDialogController = new CustomDialogController({
    // 使用自定义弹层组件
    builder: EcLoading({tip:'上传中...'}),
    alignment: DialogAlignment.Center,
    autoCancel:false,
    customStyle:true
  })
  // 上传弹层控制
  uploadDialog: CustomDialogController = new CustomDialogController({
    // 使用自定义弹层组件
    builder: EcDialogUpload({
      callBack:(url:string)=>{
        //获取到选择的图片
        this.loadDialog.open()
        this.upload(url)
      }
    }),
    alignment: DialogAlignment.Bottom
  })
  @State
  user: UserData = {} as UserData

  async getUserInfo() {
    this.user = await getUserApi()
  }

  aboutToAppear(): void {
    this.getUserInfo()
  }

  async upload(url:string){
    const file = fileIo.openSync(url,fileIo.OpenMode.READ_ONLY)
    const path = getContext().cacheDir+'/'+file.name
    fileIo.copyFileSync(file.fd,path)
    const formData = new FormData()
    formData.append('file',`internal://cache${file.name}`)
    const result = await uploadFile(formData)
    Log.info('upload success')
    //前台更新
    this.user.avatar = result
    //后台更新
    upDataUserAvatarApi(result)
    this.loadDialog.close()
    //提示用户头像上传成功
    promptAction.showToast({message:'更新成功'})
    getContext().eventHub.emit('updateUser')
  }
  @Builder
  cellItem(title: string, showName:boolean = false) {
    Row() {
      Text(title)
        .fontColor(ResManager.EC_MID_19)
        .fontSize(ResManager.EC_MODULE_TITLE_FS)
        .fontWeight(500)
      Row({ space: 10 }) {
        if (showName) {
          // 昵称修改
          Text(this.user.nickName||'匿名用户')
            .fontColor(ResManager.EC_MID_59)
            .fontSize(ResManager.EC_NORMAL_FS)
            .onClick(() => {
              router.pushUrl({
                url: RouterConfig.USER_NAME_URL,
                params:{
                  name:this.user.nickName
                }
              })
            })
        } else {
          // 上传
          Image(this.user.avatar||'https://img2.baidu.com/it/u=130573784,2479509663&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=534')
            .width(34)
            .aspectRatio(1)
            .borderRadius(17)
            .onClick(() => {
              this.uploadDialog.open()
            })
        }
        Image($r('app.media.ic_arrow_black'))
          .width(7)
          .height(16)
      }
    }
    .width('100%')
    .padding({ top: 14, bottom: 14 })
    .justifyContent(FlexAlign.SpaceBetween)
  }

  build() {
    Navigation() {
      Column() {
        Column() {
          List() {
            ListItem() {
              this.cellItem('头像')
            }

            ListItem() {
              this.cellItem('昵称',true)
            }
          }
          .width('100%')
          .height('auto')
          .padding({ left: 14, right: 18, })
          .divider({ strokeWidth: 1, color: ResManager.EC_MID_LINE })
        }
        .margin({
          top: ResManager.EC_CONTENT_SPACE,
          left: ResManager.EC_CONTENT_SPACE,
          right: ResManager.EC_CONTENT_SPACE
        })
        // .width('100%')
        .backgroundColor('#fff')
        .borderRadius(ResManager.EC_NORMAL_RD)
      }
      .width('100%')
      .height('100%')
      .backgroundColor(ResManager.EC_MID_BG)
    }
    .title('个人设置')
    .padding({ top: this.topHeight })
    .titleMode(NavigationTitleMode.Mini)
  }
}