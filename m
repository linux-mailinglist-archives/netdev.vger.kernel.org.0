Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 158C938C36F
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 11:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236753AbhEUJls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 05:41:48 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:54784 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233006AbhEUJlr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 05:41:47 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UZbOECL_1621590016;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UZbOECL_1621590016)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 21 May 2021 17:40:21 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     andrew@lunn.ch
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] net: phy: Fix inconsistent indenting
Date:   Fri, 21 May 2021 17:40:14 +0800
Message-Id: <1621590014-66912-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eliminate the follow smatch warning:

drivers/net/phy/phy_device.c:2886 phy_probe() warn: inconsistent
indenting.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/phy/phy_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 0a2d8be..1539ea0 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2883,7 +2883,7 @@ static int phy_probe(struct device *dev)
 	/* Disable the interrupt if the PHY doesn't support it
 	 * but the interrupt is still a valid one
 	 */
-	 if (!phy_drv_supports_irq(phydrv) && phy_interrupt_is_valid(phydev))
+	if (!phy_drv_supports_irq(phydrv) && phy_interrupt_is_valid(phydev))
 		phydev->irq = PHY_POLL;
 
 	if (phydrv->flags & PHY_IS_INTERNAL)
-- 
1.8.3.1

