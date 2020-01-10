Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7121D137665
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 19:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728714AbgAJSuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 13:50:05 -0500
Received: from lelv0142.ext.ti.com ([198.47.23.249]:50402 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728585AbgAJSuE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 13:50:04 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 00AInvRs100349;
        Fri, 10 Jan 2020 12:49:57 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1578682197;
        bh=uCvT9GIGwccegdRNf5Cu+QBTIlbT4QV6FT4F1pMIKLI=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=TCwPwP/NSlg50tIj9r1Dq0FFgr/3STysewfMgfbnXri4nJ7W0tvC9ezOYClxsDFo1
         bFjhEp3PVwoeO4UA0VkRiA7mXG/tmx8PpOF9TTx9C7s7r9rzgQLjpGFNSqDMklwjrq
         5EdJ1dGIdCQ9xC0/NPp85CSB3OMibOMhm2mFDwFY=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 00AInvgF100901
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 10 Jan 2020 12:49:57 -0600
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 10
 Jan 2020 12:49:57 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 10 Jan 2020 12:49:57 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 00AInvCl022740;
        Fri, 10 Jan 2020 12:49:57 -0600
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH 2/4] net: phy: DP83822: Update Kconfig with DP83825I support
Date:   Fri, 10 Jan 2020 12:47:00 -0600
Message-ID: <20200110184702.14330-3-dmurphy@ti.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200110184702.14330-1-dmurphy@ti.com>
References: <20200110184702.14330-1-dmurphy@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the Kconfig description to indicate support for the DP83825I
device as well.

Fixes: 32b12dc8fde1  ("net: phy: Add DP83825I to the DP83822 driver")
Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 drivers/net/phy/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index ed606194dbd0..8dc461f7574b 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -340,9 +340,9 @@ config DAVICOM_PHY
 	  Currently supports dm9161e and dm9131
 
 config DP83822_PHY
-	tristate "Texas Instruments DP83822 PHY"
+	tristate "Texas Instruments DP83822/825 PHYs"
 	---help---
-	  Supports the DP83822 PHY.
+	  Supports the DP83822 and DP83825I PHYs.
 
 config DP83TC811_PHY
 	tristate "Texas Instruments DP83TC811 PHY"
-- 
2.23.0

