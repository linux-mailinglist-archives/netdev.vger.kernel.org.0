Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01AE22A948
	for <lists+netdev@lfdr.de>; Sun, 26 May 2019 12:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727621AbfEZKej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 May 2019 06:34:39 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45933 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727438AbfEZKej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 May 2019 06:34:39 -0400
Received: by mail-pg1-f194.google.com with SMTP id w34so2786577pga.12
        for <netdev@vger.kernel.org>; Sun, 26 May 2019 03:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=bino1RT76H5hG2/rq3ukHngBD8LccXpfp1m8LxSuwIs=;
        b=UmKTMaRhD0QJBGJ6GLNPyYMTkztiol/NjLVipnzX7Qeabr76QX5BK9srBtNWIVaB6O
         NQ3BgbVOYly9RTzVhOgNAZ+OLCMAViBHAwdcz6Gmlx5VR14Vg5eRsobib33nOgVuyPba
         p/QZHifln7Wacp4n5ORp0mhmEo8BbeC/49c1z/1/gIzU7h15gTYGObk1ePeKJ2BKx+8C
         YhjBE/oDrU/rQ9v2MfZxeG8m7Zwp7+dTae/gOZ+VPG8e70IB9OroEZaC8/t+7gpBlVL+
         n5HThKh3w3LUVJM15T9X9+K84nm9ETgvV68NPPj7etMD5GpeTwwvCf9AFRYLjD/81nYt
         pQbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=bino1RT76H5hG2/rq3ukHngBD8LccXpfp1m8LxSuwIs=;
        b=C1vv1C2I4hR7N0Xs327zUp8CGO9peCDAMPSwf9EqFer+odhwA2/m3bZuWz1E2wkubz
         QVWokSG+nF17JgW8NHFjoIOsxrSFMCsre3bAeB4uNe11xp2BGoKPZfBtBLHNzVMd3YHi
         NK+kC4hWG1wm4HhuLcsJ5CBrUQaqvYtLJa6FYUsMGwxAHVgaIKGnRXp36MxWKfD3VBIl
         eb15GgiRjyDjsG7grHpXvytCtftk7oJd2Yp2Eb1QwrjKvL+J49l8AHwZySVbEAHEuiSf
         Wgd0K2fs7C8xISj+5NWQZ/K+CUVmJYOH551K2Q1vqUUqNjzUSsEr7qVrREn6eLzaIq7/
         OO1A==
X-Gm-Message-State: APjAAAUzZcVVZCh2y16ySI8trOlpX4Wk3u5e6w/zTjjVl2LGrYkFc7qC
        flfl3JQ8K3dvnWMela6gClbrZmj0yUg=
X-Google-Smtp-Source: APXvYqyMLk9fzCerdbhTg5g//qal9Y0vS20FA5G1UVdgIUd5G/Qhx7SE1oRv9AUTesNiZcuILB+Hzg==
X-Received: by 2002:a65:610b:: with SMTP id z11mr99456551pgu.204.1558866878500;
        Sun, 26 May 2019 03:34:38 -0700 (PDT)
Received: from localhost.localdomain (220-135-242-219.HINET-IP.hinet.net. [220.135.242.219])
        by smtp.googlemail.com with ESMTPSA id t64sm14073191pjb.0.2019.05.26.03.34.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 May 2019 03:34:38 -0700 (PDT)
From:   Chang-Hsien Tsai <luke.tw@gmail.com>
To:     netdev@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net,
        Chang-Hsien Tsai <luke.tw@gmail.com>
Subject: [PATCH] [PATCH bpf] style fix in while(!feof()) loop
Date:   Sun, 26 May 2019 10:32:11 +0000
Message-Id: <20190526103211.12608-1-luke.tw@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

use fgets() as the while loop condition.

Signed-off-by: Chang-Hsien Tsai <luke.tw@gmail.com>
---
 tools/bpf/bpftool/xlated_dumper.c           | 4 +---
 tools/testing/selftests/bpf/trace_helpers.c | 4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/tools/bpf/bpftool/xlated_dumper.c b/tools/bpf/bpftool/xlated_dumper.c
index 0bb17bf88b18..494d7ae3614d 100644
--- a/tools/bpf/bpftool/xlated_dumper.c
+++ b/tools/bpf/bpftool/xlated_dumper.c
@@ -31,9 +31,7 @@ void kernel_syms_load(struct dump_data *dd)
 	if (!fp)
 		return;
 
-	while (!feof(fp)) {
-		if (!fgets(buff, sizeof(buff), fp))
-			break;
+	while (fgets(buff, sizeof(buff), fp)) {
 		tmp = reallocarray(dd->sym_mapping, dd->sym_count + 1,
 				   sizeof(*dd->sym_mapping));
 		if (!tmp) {
diff --git a/tools/testing/selftests/bpf/trace_helpers.c b/tools/testing/selftests/bpf/trace_helpers.c
index 9a9fc6c9b70b..b47f205f0310 100644
--- a/tools/testing/selftests/bpf/trace_helpers.c
+++ b/tools/testing/selftests/bpf/trace_helpers.c
@@ -30,9 +30,7 @@ int load_kallsyms(void)
 	if (!f)
 		return -ENOENT;
 
-	while (!feof(f)) {
-		if (!fgets(buf, sizeof(buf), f))
-			break;
+	while (fgets(buf, sizeof(buf), f)) {
 		if (sscanf(buf, "%p %c %s", &addr, &symbol, func) != 3)
 			break;
 		if (!addr)
-- 
2.17.1

