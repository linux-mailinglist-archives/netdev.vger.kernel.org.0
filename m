Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB6B39B0D5
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 05:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbhFDDZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 23:25:28 -0400
Received: from m12-16.163.com ([220.181.12.16]:51891 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229751AbhFDDZ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 23:25:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=GaloG
        VRnJ+ciWXgmnofAmTQuwkkw4n+7zb6jnzrgJpM=; b=KsF5SQzdds+W+/+QM2zJ7
        rtvYXbz3R6IaBapgE+jfoMKY2MFyy7kIGOxTIaOjfIEm+BAojVTa9+tiBTrbIu5k
        xIjoDyddVTXLECgDFRUY5K0vCHt53JhdULzVUzEP58zuUNOOxLXWErMVe/y3EtlW
        zxY+CnomgSXhLlKEI03+dg=
Received: from COOL-20201222LC.ccdomain.com (unknown [218.94.48.178])
        by smtp12 (Coremail) with SMTP id EMCowADX39eInLlgrbx2vA--.15368S2;
        Fri, 04 Jun 2021 11:22:50 +0800 (CST)
From:   dingsenjie@163.com
To:     richardcochran@gmail.com, andrew@lunn.ch, hkallweit1@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dingsenjie <dingsenjie@yulong.com>
Subject: [PATCH] net: phy: Simplify the return expression of dp83640_ack_interrupt
Date:   Fri,  4 Jun 2021 11:22:24 +0800
Message-Id: <20210604032224.136268-1-dingsenjie@163.com>
X-Mailer: git-send-email 2.21.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EMCowADX39eInLlgrbx2vA--.15368S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrKw4UXryDuryrtF13Cry5twb_yoW3AFb_Gr
        yxZa13WF1jkFyUKr1ktws0vr93KF4vvryIvF18K39xWrW3Xw1F93y09ry7tFWDWr43AF97
        ur13Cw4aqry5JjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUnahF7UUUUU==
X-Originating-IP: [218.94.48.178]
X-CM-SenderInfo: 5glqw25hqmxvi6rwjhhfrp/1tbipQqnyFUMehejDQAAsa
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: dingsenjie <dingsenjie@yulong.com>

Simplify the return expression.

Signed-off-by: dingsenjie <dingsenjie@yulong.com>
---
 drivers/net/phy/dp83640.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/phy/dp83640.c b/drivers/net/phy/dp83640.c
index 0d79f68..bcd14ec 100644
--- a/drivers/net/phy/dp83640.c
+++ b/drivers/net/phy/dp83640.c
@@ -1141,12 +1141,7 @@ static int dp83640_config_init(struct phy_device *phydev)
 
 static int dp83640_ack_interrupt(struct phy_device *phydev)
 {
-	int err = phy_read(phydev, MII_DP83640_MISR);
-
-	if (err < 0)
-		return err;
-
-	return 0;
+	return phy_read(phydev, MII_DP83640_MISR);
 }
 
 static int dp83640_config_intr(struct phy_device *phydev)
-- 
1.9.1


