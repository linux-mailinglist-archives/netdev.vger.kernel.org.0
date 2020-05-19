Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBE51D94FE
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 13:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728690AbgESLPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 07:15:07 -0400
Received: from cmccmta2.chinamobile.com ([221.176.66.80]:50475 "EHLO
        cmccmta2.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726505AbgESLPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 07:15:07 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.13]) by rmmx-syy-dmz-app06-12006 (RichMail) with SMTP id 2ee65ec3bfa990d-50d27; Tue, 19 May 2020 19:14:49 +0800 (CST)
X-RM-TRANSID: 2ee65ec3bfa990d-50d27
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[112.25.154.146])
        by rmsmtp-syy-appsvr07-12007 (RichMail) with SMTP id 2ee75ec3bfa6822-03241;
        Tue, 19 May 2020 19:14:48 +0800 (CST)
X-RM-TRANSID: 2ee75ec3bfa6822-03241
From:   Tang Bin <tangbin@cmss.chinamobile.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tang Bin <tangbin@cmss.chinamobile.com>,
        Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Subject: [PATCH] net/amd: Remove the extra blank lines
Date:   Tue, 19 May 2020 19:15:29 +0800
Message-Id: <20200519111529.12016-1-tangbin@cmss.chinamobile.com>
X-Mailer: git-send-email 2.20.1.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the extra blank lines in the file au1000_eth.c

Signed-off-by: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
---
 drivers/net/ethernet/amd/au1000_eth.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/amd/au1000_eth.c b/drivers/net/ethernet/amd/au1000_eth.c
index 75e9074d8..7988e7df1 100644
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
@@ -608,7 +606,6 @@ static void au1000_reset_mac_unlocked(struct net_device *dev)
 	}
 
 	aup->mac_enabled = 0;
-
 }
 
 static void au1000_reset_mac(struct net_device *dev)
@@ -649,7 +646,6 @@ au1000_setup_hw_rings(struct au1000_private *aup, void __iomem *tx_base)
 /*
  * ethtool operations
  */
-
 static void
 au1000_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
@@ -682,7 +678,6 @@ static const struct ethtool_ops au1000_ethtool_ops = {
 	.set_link_ksettings = phy_ethtool_set_link_ksettings,
 };
 
-
 /*
  * Initialize the interface.
  *
-- 
2.20.1.windows.1



