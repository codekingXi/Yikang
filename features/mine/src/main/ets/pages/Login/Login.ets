import { auth, loginApi, ResManager } from '@hm/basic';
import { authentication } from '@kit.AccountKit';
import { util } from '@kit.ArkTS';
import { promptAction, router } from '@kit.ArkUI';

@Entry
@Component
struct Login {
  // 华为登录
  async login() {
    // 创建授权请求，并设置参数
    let authRequest = new authentication.HuaweiIDProvider().createAuthorizationWithHuaweiIDRequest();
    // 获取手机号需要传如下scope，传参数之前需要先申请对应scope权限,才能返回对应数据
    authRequest.scopes = ['phone'];
    // 获取code需传如下permission
    authRequest.permissions = ['serviceauthcode'];
    // 用户是否需要登录授权，该值为true且用户未登录或未授权时，会拉起用户登录或授权页面
    authRequest.forceAuthorization = true;
    // 用于防跨站点请求伪造，非空字符串即可
    authRequest.state = util.generateRandomUUID();
    try {
      let controller = new authentication.AuthenticationController(getContext(this));
      const result = await controller.executeRequest(authRequest) as authentication.AuthorizationWithHuaweiIDResponse;
      let state = result.state;
      if (state && authRequest.state != state) {
        return promptAction.showToast({ message: JSON.stringify(result) });
      }
      let authorizationWithHuaweiIDCredential = result.data!;
      let code = authorizationWithHuaweiIDCredential.authorizationCode!;
      // 开发者处理code
      const token = await loginApi({
        clientId:'112506057',
        clientSecret:'eaa37c3f071f60f94d7d6c2a158e3d89986484238cb34bc12b8d5f82a7db17dd',
        code
      })
      auth.setToken(token)
      router.replaceUrl({
        url:'pages/Index'
      })
    } catch (error) {
      promptAction.showToast({ message: error.message });

    }
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      Column() {
        // app 信息
        Column() {
          Image($r("app.media.pic_login_icon"))
            .width(124)
            .height(76)
            .margin({ bottom: 20 })
          Text() {
            Span('翼康养老')
              .fontColor('#000')
              .fontSize(24)
              .fontWeight(700)
          }
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .backgroundColor('#fff')

        Button({ stateEffect: true }) {
          Row({ space: 6.5 }) {
            Image(ResManager.IC_HUAWEI)
              .width(24)
              .aspectRatio(1)
            Text('华为登录')
              .fontColor('#fff')
              .fontWeight(500)
              .fontSize(ResManager.EC_MODULE_TITLE_FS)
          }
        }
        .margin({ top: 150 })
        .width(250)
        .height(40)
        .backgroundColor(ResManager.EC_MAIN_COLOR)
        .onClick(() => {
          this.login()
        })
      }
    }
    .width('100%')
    .height('100%')
  }
}