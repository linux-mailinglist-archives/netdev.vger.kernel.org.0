Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE86E1BF7F4
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 14:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbgD3MMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 08:12:06 -0400
Received: from cmccmta3.chinamobile.com ([221.176.66.81]:2391 "EHLO
        cmccmta3.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbgD3MMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 08:12:06 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.19]) by rmmx-syy-dmz-app10-12010 (RichMail) with SMTP id 2eea5eaac05f2d8-cd70c; Thu, 30 Apr 2020 20:11:11 +0800 (CST)
X-RM-TRANSID: 2eea5eaac05f2d8-cd70c
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[112.1.172.204])
        by rmsmtp-syy-appsvr10-12010 (RichMail) with SMTP id 2eea5eaac05a080-c9cf6;
        Thu, 30 Apr 2020 20:11:11 +0800 (CST)
X-RM-TRANSID: 2eea5eaac05a080-c9cf6
From:   Tang Bin <tangbin@cmss.chinamobile.com>
To:     davem@davemloft.net, benh@kernel.crashing.org, andrew@lunn.ch,
        hkallweit1@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tang Bin <tangbin@cmss.chinamobile.com>,
        Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Subject: [PATCH] net: ftgmac100: Fix unused assignment
Date:   Thu, 30 Apr 2020 20:11:23 +0800
Message-Id: <20200430121123.25184-1-tangbin@cmss.chinamobile.com>
X-Mailer: git-send-email 2.20.1.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete unused initialized value in ftgmac100.c file.

Signed-off-by: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
---
 drivers/net/ethernet/faraday/ftgmac100.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index 4572797f0..a00cbdf3a 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1354,7 +1354,7 @@ static int ftgmac100_poll(struct napi_struct *napi, int budget)
 
 static int ftgmac100_init_all(struct ftgmac100 *priv, bool ignore_alloc_err)
 {
-	int err = 0;
+	int err;
 
 	/* Re-init descriptors (adjust queue sizes) */
 	ftgmac100_init_rings(priv);
@@ -1605,7 +1605,7 @@ static int ftgmac100_setup_mdio(struct net_device *netdev)
 	struct platform_device *pdev = to_platform_device(priv->dev);
 	phy_interface_t phy_intf = PHY_INTERFACE_MODE_RGMII;
 	struct device_node *np = pdev->dev.of_node;
-	int i, err = 0;
+	int i, err;
 	u32 reg;
 
 	/* initialize mdio bus */
@@ -1755,7 +1755,7 @@ static int ftgmac100_probe(struct platform_device *pdev)
 	struct net_device *netdev;
 	struct ftgmac100 *priv;
 	struct device_node *np;
-	int err = 0;
+	int err;
 
 	if (!pdev)
 		return -ENODEV;
-- 
2.20.1.windows.1



