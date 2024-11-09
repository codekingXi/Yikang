import { Log } from '@abner/log'
import day from 'dayjs'
//day.js初始化
day.locale('zh-cn')
//log初始化
Log.init({
  tag: "yk-yl",
  domain: 0xEC00,
  close: false,
  isHilog: true,
  showLogLocation: true,
  logSize: 200
})