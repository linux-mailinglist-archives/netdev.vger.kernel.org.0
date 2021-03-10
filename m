Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8C0B333332
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 03:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232182AbhCJCfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 21:35:51 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:41265 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232043AbhCJCfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 21:35:37 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0URB1F74_1615343728;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0URB1F74_1615343728)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 10 Mar 2021 10:35:34 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] netdevsim: fib: Remove redundant code
Date:   Wed, 10 Mar 2021 10:35:27 +0800
Message-Id: <1615343727-96723-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warnings:

./drivers/net/netdevsim/fib.c:874:5-8: Unneeded variable: "err". Return
"0" on line 889.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/netdevsim/fib.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index 46fb414..db794f9 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -871,8 +871,6 @@ static int nsim_fib6_event(struct nsim_fib_data *data,
 
 static int nsim_fib_event(struct nsim_fib_event *fib_event)
 {
-	int err = 0;
-
 	switch (fib_event->family) {
 	case AF_INET:
 		nsim_fib4_event(fib_event->data, &fib_event->fen_info,
@@ -886,7 +884,7 @@ static int nsim_fib_event(struct nsim_fib_event *fib_event)
 		break;
 	}
 
-	return err;
+	return 0;
 }
 
 static int nsim_fib4_prepare_event(struct fib_notifier_info *info,
-- 
1.8.3.1

