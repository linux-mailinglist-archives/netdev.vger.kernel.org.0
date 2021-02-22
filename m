Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 821F8321365
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 10:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbhBVJsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 04:48:05 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:34681 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230304AbhBVJr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 04:47:57 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R921e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UPCheCh_1613987227;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UPCheCh_1613987227)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 22 Feb 2021 17:47:13 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] netdevsim: fib: remove unneeded semicolon
Date:   Mon, 22 Feb 2021 17:47:04 +0800
Message-Id: <1613987224-33151-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warnings:

./drivers/net/netdevsim/fib.c:564:2-3: Unneeded semicolon.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/netdevsim/fib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index 46fb414..11b43ce 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -561,7 +561,7 @@ static void nsim_fib6_rt_nh_del(struct nsim_fib6_rt *fib6_rt,
 err_fib6_rt_nh_del:
 	for (i--; i >= 0; i--) {
 		nsim_fib6_rt_nh_del(fib6_rt, rt_arr[i]);
-	};
+	}
 	nsim_fib_rt_fini(&fib6_rt->common);
 	kfree(fib6_rt);
 	return ERR_PTR(err);
-- 
1.8.3.1

