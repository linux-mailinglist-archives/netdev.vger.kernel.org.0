Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1934E3FF3E2
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 21:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347196AbhIBTKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 15:10:48 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:50378 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243515AbhIBTKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 15:10:47 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 182J9je1121683;
        Thu, 2 Sep 2021 14:09:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1630609785;
        bh=n27CbArJ67svAxFYP0MPqAa6xQ+flI6xfI+ZXy9HJ0w=;
        h=From:To:CC:Subject:Date;
        b=ASJjR+q61OFXVPZFPNzakd/u0fSBV6ECOY452sxCNu9lr4MZky/opgewZY22qq0jt
         JqP7TGbG3VXK/vQXo9qqzXpbQ/CU+80jxHEXJs3iUWRY4jt2POcR1MEzaQF2jXyAX6
         l5DpiXfEalHU3wmCMZfAgXkTL+N5BQgjNWUhjMKc=
Received: from DLEE104.ent.ti.com (dlee104.ent.ti.com [157.170.170.34])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 182J9ins032846
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 2 Sep 2021 14:09:45 -0500
Received: from DLEE112.ent.ti.com (157.170.170.23) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Thu, 2
 Sep 2021 14:09:44 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Thu, 2 Sep 2021 14:09:44 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 182J9i6r103730;
        Thu, 2 Sep 2021 14:09:44 -0500
From:   <hnagalla@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <geet.modi@ti.com>, <vikram.sharma@ti.com>, <hnagalla@ti.com>
Subject: [PATCH] net: phy: dp83tc811: modify list of interrupts enabled at initialization
Date:   Thu, 2 Sep 2021 14:09:44 -0500
Message-ID: <20210902190944.4963-1-hnagalla@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hari Nagalla <hnagalla@ti.com>

Disable the over voltage interrupt at initialization to meet typical
application requirement.

Signed-off-by: Hari Nagalla <hnagalla@ti.com>
Signed-off-by: Geet Modi <geet.modi@ti.com>
Signed-off-by: Vikram Sharma <vikram.sharma@ti.com>
---
 drivers/net/phy/dp83tc811.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/phy/dp83tc811.c b/drivers/net/phy/dp83tc811.c
index 7ea32fb77190..452a39d96bd8 100644
--- a/drivers/net/phy/dp83tc811.c
+++ b/drivers/net/phy/dp83tc811.c
@@ -226,7 +226,6 @@ static int dp83811_config_intr(struct phy_device *phydev)
 				DP83811_POLARITY_INT_EN |
 				DP83811_SLEEP_MODE_INT_EN |
 				DP83811_OVERTEMP_INT_EN |
-				DP83811_OVERVOLTAGE_INT_EN |
 				DP83811_UNDERVOLTAGE_INT_EN);
 
 		err = phy_write(phydev, MII_DP83811_INT_STAT2, misr_status);
-- 
2.17.1

