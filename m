Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 096CF324B09
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 08:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234064AbhBYHLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 02:11:43 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:55724 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233159AbhBYHJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 02:09:33 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0UPWUmt0_1614236919;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UPWUmt0_1614236919)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 25 Feb 2021 15:08:47 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     ast@kernel.org
Cc:     daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] kallsyms: make arch_get_kallsym static
Date:   Thu, 25 Feb 2021 15:08:37 +0800
Message-Id: <1614236917-80472-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following sparse warning:

kernel/kallsyms.c:457:12: warning: symbol 'arch_get_kallsym' was not
declared. Should it be static?

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 kernel/kallsyms.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 8043a90..a26f98e 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -454,7 +454,7 @@ struct kallsym_iter {
 	int show_value;
 };
 
-int __weak arch_get_kallsym(unsigned int symnum, unsigned long *value,
+static int __weak arch_get_kallsym(unsigned int symnum, unsigned long *value,
 			    char *type, char *name)
 {
 	return -EINVAL;
-- 
1.8.3.1

