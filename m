Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE523D38E1
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 12:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232514AbhGWJ6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 05:58:14 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:45974 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231871AbhGWJ6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 05:58:11 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0Ughmuvt_1627036712;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0Ughmuvt_1627036712)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 23 Jul 2021 18:38:43 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     lxu@maxlinear.com
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        chongjiapeng <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] net: phy: Remove unused including <linux/version.h>
Date:   Fri, 23 Jul 2021 18:38:27 +0800
Message-Id: <1627036707-73334-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: chongjiapeng <jiapeng.chong@linux.alibaba.com>

Eliminate the follow versioncheck warning:

./drivers/net/phy/mxl-gpy.c: 9 linux/version.h not needed.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: chongjiapeng <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/phy/mxl-gpy.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
index 12a02d8..2d5d508 100644
--- a/drivers/net/phy/mxl-gpy.c
+++ b/drivers/net/phy/mxl-gpy.c
@@ -6,7 +6,6 @@
  *
  */
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/bitfield.h>
 #include <linux/phy.h>
-- 
1.8.3.1

