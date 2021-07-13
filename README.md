# XDTools

## Swift

### 工具方法

- 自定义print
- 屏幕宽高
- 是否是iPad设备
- 判断字符串是否为空或全是空格
- 字典转字符串/字符串转字典
- RGB定义颜色
- 随机色
- 指定位数的随机字符串
- 手机号/邮箱/数字+字母/纯数字/字母+数字+指定字符的密码正则
- 设置NSAttributedString公共方法
- UUID+钥匙串获取app唯一标识
- 获取手机型号
- 获取国内运营商
- 给图片设置透明度
- 设置指定大小的纯色图片
- 生成二维码
- 压缩图片到指定大小
- 获取时间戳
- 时间戳/毫秒时间转Date
- 时间戳/毫秒时间转时间字符串
- 年-月-日与Date相互转换
- 年-月-日-时-分-秒与Date相互转换
- Date转DateComponents（可获取年，月，日，周等）
- 获取今天、昨天、近7天、近一个月的时间戳范围
- 手机号加****
- 判断沙盒中某个文件是否存在
- 将字符串写入写入沙盒中指定文件
- 删除沙盒中指定文件
- 获取沙盒中文件里的内容
- 

### 分类

- UIView的x，y，width，height，right，bottom，centerX，centerY，size
- 图片拉伸
- 图片设置纯色
- JWT解析
- 添加千分位分隔符
- Emoji表情判断
- 多语言设置
- 设置十六进制颜色
- 导航是否可pop上一页
- 修复原生图片选择器，拍照不可拖动到边缘的系统bug

### 工具封装

- 二分法坐标系转换：XD_MapKits
- SQLite swift封装：SQLiteManager
- Alamofire网络请求封装：XDAlamofire

## OC

### 分类

- SES256加密/解密
- 导航栏item按钮分类
- 十六进制颜色转换
- 图片拉伸
- 图片等比缩放到指定尺寸
- 图片拼接
- 设置图片前景色和背景色
- 获取/设置UITextFiedl光标位置
- UIView的x，y，width，height，right，bottom，centerX，centerY，size
- 十六进制与NSData相互转换
- UTF-8与NSData相互转换
- 

### 工具方法

- MD5加密，32位大/小写，16位大/小写
- 设置NSAttributedString公共方法
- 获取缓存目录大小，清理缓存
- AFN方法封装
- 获取网络类型
- 手机号正则
- UITextView文字垂直居中
- 拷贝UIView
- 是否存在某个字体
- 判断两个颜色是否一样
- 获取AppDelegate
- 时间戳转为当前时间字符串
- 获取月份有多少天
- NSDate与年-月-日/年-月-日 时:分:秒 相互转换
- NSDate转NSDateComponents（可获取年，月，日，周等）
- NSDictionary与NSString相互转换
- 金额 分不失精度转元
- 浮点型和整型数字字符串添加千分位分隔符
- 获取指定范围内的随机整数
- 获取固定位数的随机数字字符串
- 获取固定字数的随机中文
- 获取随机位数的随机字符串
- 获取小于指定位数的随机字符串
- 从ACSII码中获取指定位数的随机字符串
- 判断是否位整型字符串
- 判断是否位浮点型字符串
- 判断字符串中是否有中文
- 返回UTF-8的NSData
- 求累加和，校验和，Checksum
- 十进制数字专为十六进制字符串
- NSData直接转为字符串显示
- 十六进制与NSData相呼转换
- 26进制字符串转10进制字符串
- 获取当前设备的ip地址
- 拍照时，照片位置不正时图片旋转
- 

### 日期格式化（XDDateFormatter）

- 时间格式化的各种类型，相互转换
- 获取月份有多少天
- 获取本周/本月第一天的NSDate
- NSdate转年月，区分中英文不同显示
- NSDate转NSDateComponents（可获取年，月，日，周等）
- NSDate与毫秒值相互转换