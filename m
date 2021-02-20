Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8867A32049F
	for <lists+netdev@lfdr.de>; Sat, 20 Feb 2021 10:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbhBTJLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Feb 2021 04:11:48 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:43915 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229806AbhBTJLi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Feb 2021 04:11:38 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R521e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0UP0VSH5_1613812248;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UP0VSH5_1613812248)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 20 Feb 2021 17:10:53 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     ast@kernel.org
Cc:     daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, nathan@kernel.org, ndesaulniers@google.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] libbpf: Remove unnecessary conversion to bool
Date:   Sat, 20 Feb 2021 17:10:47 +0800
Message-Id: <1613812247-17924-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warnings:

./tools/lib/bpf/libbpf.c:1487:43-48: WARNING: conversion to bool not
needed here.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 6ae748f..5dfdbf3 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1484,7 +1484,7 @@ static int set_kcfg_value_tri(struct extern_desc *ext, void *ext_val,
 				ext->name, value);
 			return -EINVAL;
 		}
-		*(bool *)ext_val = value == 'y' ? true : false;
+		*(bool *)ext_val = value == 'y';
 		break;
 	case KCFG_TRISTATE:
 		if (value == 'y')
-- 
1.8.3.1

