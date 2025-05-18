#!/usr/bin/env bash
cd $(dirname "$0")

max_date=""
max_file=""

for f in tipafiles/app.xxtouch.ios_*.tipa; do
  # 提取倒数第1个 '-' 后到 .tipa 前的日期部分
  base="${f##*/}"                # 防止有路径，取文件名部分
  date_part="${base##*-}"        # 先去掉最后一个 '-'
  date_part="${date_part%%.*}"   # 再去掉扩展名（点后内容）
  if [[ -z "$max_date" || "$date_part" > "$max_date" ]]; then
    max_date="$date_part"
    max_file="$f"
  fi
done

cat latest-version-template | sed s/{{VERSION}}/1.3.8-$max_date/g > api/latest-version

dpkg-scanpackages -m ./debfiles > Packages
bzip2 -c Packages > Packages.bz2
gzip -c Packages > Packages.gz