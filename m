Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B896E322424
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 03:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbhBWC3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 21:29:47 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:26866 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229991AbhBWC3p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 21:29:45 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R331e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UPJc9GU_1614047328;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UPJc9GU_1614047328)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 23 Feb 2021 10:28:53 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH v2] netdevsim: fib: remove unneeded semicolon
Date:   Tue, 23 Feb 2021 10:28:46 +0800
Message-Id: <1614047326-16478-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warnings:

./drivers/net/netdevsim/fib.c:564:2-3: Unneeded semicolon.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
Changes in v2:
  - Remove the braces.

 drivers/net/netdevsim/fib.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index 46fb414..3acfe27 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -559,9 +559,8 @@ static void nsim_fib6_rt_nh_del(struct nsim_fib6_rt *fib6_rt,
 	return fib6_rt;
 
 err_fib6_rt_nh_del:
-	for (i--; i >= 0; i--) {
+	for (i--; i >= 0; i--)
 		nsim_fib6_rt_nh_del(fib6_rt, rt_arr[i]);
-	};
 	nsim_fib_rt_fini(&fib6_rt->common);
 	kfree(fib6_rt);
 	return ERR_PTR(err);
-- 
1.8.3.1

