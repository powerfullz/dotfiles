# 浏览器工具选择

OpenCode 里有两套浏览器能力，职责不同。按任务类型选择，不要混用。

## chrome-devtools（CDP MCP）——调试 / 开发

适用于：

- 前端调试：DOM / CSS 检查、控制台报错、网络请求分析
- 性能分析：Lighthouse、performance trace、Web Vitals、CPU / 内存 profile
- 可重复的自动化测试、页面抓取、抓取无需登录的公开页面
- 不需要用户介入的任务

它使用自己启动的隔离 Chrome（`~/.cache/chrome-devtools-mcp/chrome-profile`），没有用户的 cookie、登录态和扩展。

## browse 插件——真实浏览器 / 需要用户介入

适用于：

- 需要用户真实浏览器的 cookie、登录态、扩展或已打开标签页的任务
- 访问只有登录后才能看到的内容
- 需要用户亲自完成：登录、2FA / passkey、验证码、支付确认
- 请用户在真实页面上演示操作流程

它通过浏览器扩展驱动用户真实的 Chrome，用户可以随时接管。只有人才能完成的步骤用 `handoff` 交给用户，不要自己去解验证码或反复重试。

## 选择规则

- 调试、开发、性能、纯自动化 → `chrome-devtools`
- 需要用户的 cookie / 登录态，或需要用户介入浏览器操作 → `browse`
- 两者都能做时，优先用不打扰用户、环境隔离的 `chrome-devtools`；只有确实需要真实会话时才用 `browse`。
