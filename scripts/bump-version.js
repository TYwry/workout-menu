// 部署前把 sw.js 與 index.html 的版本號換成目前時間（兩邊一定相同）
const fs = require('fs');
const path = require('path');
const d = new Date();
const p = (n) => String(n).padStart(2, '0');
// 版本號精確到秒：同一分鐘內部署兩次，手機也能收到第二次的更新
const ver = `${d.getFullYear()}.${p(d.getMonth() + 1)}.${p(d.getDate())}-${p(d.getHours())}${p(d.getMinutes())}${p(d.getSeconds())}`;
for (const f of ['public/sw.js', 'public/index.html']) {
  const file = path.join(__dirname, '..', f);
  const src = fs.readFileSync(file, 'utf8');
  const re = /const APP_VERSION = '[^']*';/;
  // 用「找不找得到版本號這一行」判斷，同一分鐘內重複部署（版本號相同）也不會誤判
  if (!re.test(src)) { console.error(`找不到版本號：${f}`); process.exit(1); }
  const out = src.replace(re, `const APP_VERSION = '${ver}';`);
  fs.writeFileSync(file, out, 'utf8');
}
console.log(`新版本號：${ver}`);
