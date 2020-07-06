Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6F2215A15
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 16:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729350AbgGFO4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 10:56:21 -0400
Received: from cmccmta1.chinamobile.com ([221.176.66.79]:6839 "EHLO
        cmccmta1.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729229AbgGFO4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 10:56:21 -0400
X-Greylist: delayed 547 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Jul 2020 10:56:18 EDT
Received: from spf.mail.chinamobile.com (unknown[172.16.121.1]) by rmmx-syy-dmz-app02-12002 (RichMail) with SMTP id 2ee25f033961a8e-4271c; Mon, 06 Jul 2020 22:46:57 +0800 (CST)
X-RM-TRANSID: 2ee25f033961a8e-4271c
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[112.0.156.39])
        by rmsmtp-syy-appsvr01-12001 (RichMail) with SMTP id 2ee15f03395dfa9-abca0;
        Mon, 06 Jul 2020 22:46:57 +0800 (CST)
X-RM-TRANSID: 2ee15f03395dfa9-abca0
From:   Tang Bin <tangbin@cmss.chinamobile.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tang Bin <tangbin@cmss.chinamobile.com>,
        Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Subject: [PATCH] net/amd: Remove needless assignment and the extra brank lines
Date:   Mon,  6 Jul 2020 22:47:01 +0800
Message-Id: <20200706144701.7500-1-tangbin@cmss.chinamobile.com>
X-Mailer: git-send-email 2.20.1.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The variable 'err = -ENODEV;' in au1000_probe() is
duplicate, so remove redundant one. And remove the
extra blank lines in the file au1000_eth.c

Signed-off-by: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
---
 drivers/net/ethernet/amd/au1000_eth.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/amd/au1000_eth.c b/drivers/net/ethernet/amd/au1000_eth.c
index 089a4fbc6..7dd8f2104 100644
--- a/drivers/net/ethernet/amd/au1000_eth.c
+++ b/drivers/net/ethernet/amd/au1000_eth.c
@@ -243,7 +243,6 @@ MODULE_VERSION(DRV_VERSION);
  * ps: make sure the used irqs are configured properly in the board
  * specific irq-map
  */
-
 static void au1000_enable_mac(struct net_device *dev, int force_reset)
 {
 	unsigned long flags;
@@ -558,7 +557,6 @@ static int au1000_mii_probe(struct net_device *dev)
 	return 0;
 }
 
-
 /*
  * Buffer allocation/deallocation routines. The buffer descriptor returned
  * has the virtual and dma address of a buffer suitable for
@@ -649,7 +647,6 @@ au1000_setup_hw_rings(struct au1000_private *aup, void __iomem *tx_base)
 /*
  * ethtool operations
  */
-
 static void
 au1000_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
@@ -682,7 +679,6 @@ static const struct ethtool_ops au1000_ethtool_ops = {
 	.set_link_ksettings = phy_ethtool_set_link_ksettings,
 };
 
-
 /*
  * Initialize the interface.
  *
@@ -1258,7 +1254,6 @@ static int au1000_probe(struct platform_device *pdev)
 		aup->rx_db_inuse[i] = pDB;
 	}
 
-	err = -ENODEV;
 	for (i = 0; i < NUM_TX_DMA; i++) {
 		pDB = au1000_GetFreeDB(aup);
 		if (!pDB)
-- 
2.20.1.windows.1



