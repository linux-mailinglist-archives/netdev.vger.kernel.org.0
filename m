Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 778B061EDEB
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 09:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbiKGI5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 03:57:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231518AbiKGI5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 03:57:10 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701C515836;
        Mon,  7 Nov 2022 00:57:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667811426; x=1699347426;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=b04ZHSDXDlEVTBVuOPBDEtMi6B7HphF2Zh1z2L5q7Es=;
  b=R1mXRyuNhvCtzyJWpTLj95ILVzHuB/BMaisar4c3M5TqF2l2qnZLmKPf
   bKeyaRguTRbzKxT5Wq9D+rpaaD7K8e8t+IX/SOalTM1gJ3raWSjjEhEDD
   D8+OyJLXmsY5V2yvqym5spioLFEzKy1n80BCTFc5DGddNsftB4wHMLwKq
   8TjPPvDOOZ5BodQ+PFdq8asKsxT3GrfkiY5KOl2PbvVR59MlyqFFYZolC
   2wxh9rBgZJ5/+wOiCU8EXRA2azHxhPkhT9JhZ6eyyghOC60r3pXt8+IcZ
   NbqVQF5SlCmF7Xgbx5HSaUisuKi2xNvyqajxwx5YbvOPpJFDPGpR7n4Dq
   g==;
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="198684710"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Nov 2022 01:57:04 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 7 Nov 2022 01:57:01 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 7 Nov 2022 01:56:57 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <pabeni@redhat.com>, <edumazet@google.com>, <olteanv@gmail.com>,
        <linux@armlinux.org.uk>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <Ian.Saturley@microchip.com>
Subject: [PATCH net-next V7 1/2] net: lan743x: Remove unused argument in lan743x_common_regs( )
Date:   Mon, 7 Nov 2022 14:26:49 +0530
Message-ID: <20221107085650.991470-2-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221107085650.991470-1-Raju.Lakkaraju@microchip.com>
References: <20221107085650.991470-1-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

