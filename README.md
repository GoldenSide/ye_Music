# yeMusic - 鸿蒙音乐播放器

一款基于 HarmonyOS ArkTS 开发的仿网易云音乐风格的音乐播放器应用。

## 项目简介

yeMusic 是一个使用 ArkTS (ArkUI) 开发的 HarmonyOS 原生音乐应用，采用声明式 UI 开发范式，实现了音乐播放、歌单浏览、播放列表管理等核心功能，并支持后台播放与通知栏控制。

## 技术栈

- **开发框架**: HarmonyOS ArkTS (ArkUI 声明式开发)
- **目标 SDK**: API 6.1.1 (24)
- **运行系统**: HarmonyOS
- **包名**: `com.example.ye_music`
- **版本**: 1.0.0

## 功能特性

### 已实现功能

- **启动页**: 3 秒广告倒计时，支持手动跳过
- **底部导航**: 推荐 / 发现 / 动态 / 我的 四大 Tab 切换
- **推荐页面**:
  - 顶部搜索栏
  - 轮播图 Banner（自动播放）
  - 每日推荐（横向滚动）
  - 推荐歌单（横向滚动）
- **发现页面**:
  - 猜你喜欢歌曲列表
  - 当前播放状态可视化（波形动画）
  - 点击歌曲进入播放页
- **播放页面**:
  - CD 唱片旋转 + 唱针动画效果
  - 背景毛玻璃模糊效果（随封面变化）
  - 歌曲信息展示（歌名、歌手）
  - 进度条拖动与时间显示
  - 播放控制：播放/暂停、上一首、下一首
  - 三种播放模式：顺序播放、随机播放、单曲循环
  - 播放列表面板（上滑呼出）
  - 左滑删除歌曲
  - 点赞、评论、分享、下载按钮（UI 展示）
- **后台播放**:
  - AVSession 音频会话管理
  - 长时任务后台保活
  - 通知栏播放控制（播放/暂停/上一首/下一首/进度）

### 待开发功能

- 动态页面
- 我的页面
- 用户登录
- 搜索功能
- 歌单详情页
- 本地音乐扫描

## 项目结构

```
yeMusic/
├── AppScope/                    # 应用全局配置
│   ├── app.json5               # 应用级配置（包名、版本、图标等）
│   └── resources/              # 全局资源
├── entry/                       # 主模块
│   ├── src/main/
│   │   ├── ets/
│   │   │   ├── components/     # 公共组件
│   │   │   │   └── titleBuilder.ets
│   │   │   ├── data/           # 数据层
│   │   │   │   └── recommendDaily.ets
│   │   │   ├── entryability/   # Ability 入口
│   │   │   │   └── EntryAbility.ets
│   │   │   ├── entrybackupability/  # 备份能力
│   │   │   │   └── EntryBackupAbility.ets
│   │   │   ├── models/         # 数据模型
│   │   │   │   ├── music.ets          # 歌曲类型定义
│   │   │   │   └── globalMusic.ets    # 全局音乐状态
│   │   │   ├── pages/          # 页面
│   │   │   │   ├── Index.ets         # 应用入口页
│   │   │   │   ├── Start.ets         # 启动广告页
│   │   │   │   ├── Layout.ets        # 底部导航布局页
│   │   │   │   ├── Recommend.ets     # 推荐页
│   │   │   │   ├── Find.ets          # 发现页
│   │   │   │   ├── Moment.ets        # 动态页（占位）
│   │   │   │   ├── Mine.ets          # 我的页（占位）
│   │   │   │   └── Play.ets          # 播放页
│   │   │   └── tools/          # 工具类
│   │   │       ├── avPlayer.ets           # 音频播放器管理（单例）
│   │   │       └── avSessionManager.ets   # AVSession 会话管理
│   │   ├── resources/          # 资源文件（图片、颜色、字符串等）
│   │   └── module.json5        # 模块配置
│   ├── ohosTest/               # 单元测试
│   ├── test/                   # 测试目录
│   └── build-profile.json5     # 模块构建配置
├── hvigor/                      # 构建工具配置
├── build-profile.json5          # 项目构建配置
├── oh-package.json5             # 项目依赖配置
└── hvigorfile.ts                # 构建脚本
```

## 核心架构

### 播放器架构

采用 **单例模式** 管理全局播放器实例，通过 `AppStorage` 实现状态共享。

- [AvPlayerManager](entry/src/main/ets/tools/avPlayer.ets)：音频播放器核心类，封装 AVPlayer 的播放、暂停、切歌、进度控制等操作
- [AvSessionManager](entry/src/main/ets/tools/avSessionManager.ets)：AVSession 会话管理，负责后台播放与通知栏控制
- [GlobalMusic](entry/src/main/ets/models/globalMusic.ets)：全局音乐状态模型，存储当前播放歌曲、播放列表、播放模式等

### 导航架构

使用 `Navigation` + `NavPathStack` 实现页面路由管理，通过 `@StorageLink('pathStack')` 在各页面间共享导航栈。

页面路由：
- `Start` → 启动页
- `Layout` → 主布局（底部 Tab）
- `Play` → 播放页

### 状态管理

| 状态 | 存储方式 | 说明 |
|------|---------|------|
| pathStack | AppStorage | 导航路由栈 |
| GlobalMusic | AppStorage | 全局音乐播放状态 |

## 快速开始

### 环境要求

- DevEco Studio 5.0+
- HarmonyOS SDK API 6.1.1 (24)
- Node.js 16+

### 安装与运行

1. **克隆项目**
   ```bash
   git clone <repository-url>
   cd yeMusic
   ```

2. **使用 DevEco Studio 打开项目**

3. **同步依赖**
   - 等待 oh-package 依赖自动同步
   - 或手动执行 hvigor 同步

4. **连接设备或启动模拟器**

5. **运行项目**
   - 点击 Run 按钮
   - 或使用命令：`hvigorw assembleHap`

### 权限说明

应用需申请以下权限：

- `ohos.permission.INTERNET` — 网络权限（加载在线音乐与图片）
- `ohos.permission.KEEP_BACKGROUND_RUNNING` — 后台运行权限（音乐后台播放）

## 数据说明

当前版本使用 Mock 数据进行演示，音乐与图片资源均来自网络：

- 歌曲资源：阿里云 OSS 存储的在线音频文件
- 封面图片：在线图片资源
- 歌单数据：内置静态数据

## 开发说明

### 添加新页面

1. 在 `entry/src/main/ets/pages/` 下创建新的 `.ets` 文件
2. 使用 `@Builder` 导出页面构建函数
3. 在路由栈中通过 `pathStack.pushPathByName('PageName', null)` 跳转

### 添加新歌曲

在 [Find.ets](entry/src/main/ets/pages/Find.ets) 或 [Play.ets](entry/src/main/ets/pages/Play.ets) 的 `songs` 数组中添加歌曲对象：

```typescript
{
  img: '封面图片URL',
  name: '歌曲名称',
  author: '歌手',
  url: '音频URL',
  id: '唯一标识'
}
```

### 播放模式

`PlayMode` 枚举定义了三种播放模式：

- `ORDER` — 顺序播放
- `RANDOM` — 随机播放
- `LOOP` — 单曲循环

## 目录说明

| 目录 | 说明 |
|------|------|
| `components/` | 可复用的自定义组件 |
| `data/` | 数据源与数据处理 |
| `models/` | TypeScript 接口与类定义 |
| `pages/` | 页面级组件 |
| `tools/` | 工具类与管理器 |
| `entryability/` | UIAbility 入口 |

## License

MIT
