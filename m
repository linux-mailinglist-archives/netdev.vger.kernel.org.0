Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78387137667
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 19:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728806AbgAJSuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 13:50:07 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:56390 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728668AbgAJSuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 13:50:05 -0500
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 00AInvYM079455;
        Fri, 10 Jan 2020 12:49:57 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1578682197;
        bh=+ia6TERcPXinkZXd+gzuCsh1q+nImZu2BXPpq4xXPUU=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=yo+kSL82o9/C6VS6h9GgH7qimdovCZ6KxB0dP/u3XHCW74wmgcHHbBOAlHZAZcnwQ
         ADFZLaPVNw36oTZVewLo/GO9z+DVwCN6V5VaOml7DJVBFmrJREhOpufEoT/eg7+1/v
         P/syrvTYBewnHfQVrppz48CyPFx4xJ82WIpSfSQ8=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 00AInv1i082407
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 10 Jan 2020 12:49:57 -0600
Received: from DFLE107.ent.ti.com (10.64.6.28) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 10
 Jan 2020 12:49:57 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 10 Jan 2020 12:49:57 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 00AInu7X121098;
        Fri, 10 Jan 2020 12:49:56 -0600
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH 1/4] net: phy: DP83TC811: Fix typo in Kconfig
Date:   Fri, 10 Jan 2020 12:46:59 -0600
Message-ID: <20200110184702.14330-2-dmurphy@ti.com>
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

Fix typo in the Kconfig for the DP83TC811 as it indicates support for
the DP83TC822 which is incorrect.

Fixes: 6d749428788b {"net: phy: DP83TC811: Introduce support for the DP83TC811 phy")
Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 drivers/net/phy/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 5848219005d7..ed606194dbd0 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -345,9 +345,9 @@ config DP83822_PHY
 	  Supports the DP83822 PHY.
 
 config DP83TC811_PHY
-	tristate "Texas Instruments DP83TC822 PHY"
+	tristate "Texas Instruments DP83TC811 PHY"
 	---help---
-	  Supports the DP83TC822 PHY.
+	  Supports the DP83TC811 PHY.
 
 config DP83848_PHY
 	tristate "Texas Instruments DP83848 PHY"
-- 
2.23.0

