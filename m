Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 032C561EB84
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 08:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbiKGHPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 02:15:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiKGHP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 02:15:27 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C0013D3A;
        Sun,  6 Nov 2022 23:15:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667805317; x=1699341317;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=b04ZHSDXDlEVTBVuOPBDEtMi6B7HphF2Zh1z2L5q7Es=;
  b=cvimVq+klBs9lbC6h9QeOwCzwBd5UpFQTsQoTycfZj+/zjjMkLdoPrJ0
   jgV3E+wR0z5rsYiWnZ/6eyfjkB4b2CBX6qjcJKhV17anx3pCcoKVr2XBa
   zaYNE5BjKeFqCy66H3P0l/Lcs5tdvM/tOwPYYVmky+jl8dUN67Iq//3hx
   jNq6v1KsEPjOKa5H8eXPpQKsmm+q7s83hc2dcEzD+SzJEfFfTfkTtzJKV
   1ciaV+1178579FLp0Z6tN/+54gD3AmbAOVXfxomqUm0Vu+YZvk6v0Kk/J
   lEUF5FFkVOsecxrgvDm9ECw7MZiADASZLNULOuYpg5NM/Yy4fveBALdeR
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="182205961"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Nov 2022 00:15:16 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 7 Nov 2022 00:15:07 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 7 Nov 2022 00:15:04 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <pabeni@redhat.com>, <edumazet@google.com>, <olteanv@gmail.com>,
        <linux@armlinux.org.uk>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <Ian.Saturley@microchip.com>
Subject: [PATCH net-next V7 1/2] net: lan743x: Remove unused argument in lan743x_common_regs( )
Date:   Mon, 7 Nov 2022 12:44:49 +0530
Message-ID: <20221107071450.669700-2-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221107071450.669700-1-Raju.Lakkaraju@microchip.com>
References: <20221107071450.669700-1-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the unused argument (i.e. struct ethtool_regs *regs) in
lan743x_common_regs( ) function arguments.

Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
---
Change List:
===========
V6 -> V7:
 - Revert the memset change in lan743x_common_regs( ) function

 drivers/net/ethernet/microchip/lan743x_ethtool.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_ethtool.c b/drivers/net/ethernet/microchip/lan743x_ethtool.c
index 88f9484cc2a7..aa1d79a9a1f2 100644
--- a/drivers/net/ethernet/microchip/lan743x_ethtool.c
+++ b/drivers/net/ethernet/microchip/lan743x_ethtool.c
@@ -1190,9 +1190,7 @@ static int lan743x_ethtool_set_wol(struct net_device *netdev,
 }
 #endif /* CONFIG_PM */
 
-static void lan743x_common_regs(struct net_device *dev,
-				struct ethtool_regs *regs, void *p)
-
+static void lan743x_common_regs(struct net_device *dev, void *p)
 {
 	struct lan743x_adapter *adapter = netdev_priv(dev);
 	u32 *rb = p;
@@ -1230,7 +1228,7 @@ static void lan743x_get_regs(struct net_device *dev,
 {
 	regs->version = LAN743X_ETH_REG_VERSION;
 
-	lan743x_common_regs(dev, regs, p);
+	lan743x_common_regs(dev, p);
 }
 
 static void lan743x_get_pauseparam(struct net_device *dev,
-- 
2.25.1

