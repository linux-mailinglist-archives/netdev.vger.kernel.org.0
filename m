Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D244B616133
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 11:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbiKBKsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 06:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbiKBKst (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 06:48:49 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C721BC5C;
        Wed,  2 Nov 2022 03:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667386127; x=1698922127;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Iwwhf/O/d8T0fxVfJANXQBVTgtQ2Jb2ze8w0FuBOqWc=;
  b=VXEbfGseOGI2hu0nYYk0mXOtBSftLqEAGvBgd5nHbIQubSjg5VdNQRWe
   hJ3Jni4sOdvM4zS8PYaai6UTxC04LiNRnNKSBov2EITNNOgMYdF1bhg1l
   sBHvNXeiqAoc0z4+X4sUBp3HDceJ+pmFHexkKXHYbLnmkEFFUy0EjDTRb
   Wp8K+3JEJCJmrRo+60zgH7KjviGwR+9jA65jyyk8b/4UNFoZS5rWVaQBQ
   DTQo+h0G+1EYzzHhp/D6G7YqvwNXxiCWS29ylbXMRj63hGkt9q4MdVpSu
   RgWEuItGFHRLA0fHAAzUivlWvzZ+ZgFouEz92G86Ypxs5ZIqNEt5BdGtC
   A==;
X-IronPort-AV: E=Sophos;i="5.95,232,1661842800"; 
   d="scan'208";a="121441476"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Nov 2022 03:48:47 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 2 Nov 2022 03:48:45 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 2 Nov 2022 03:48:41 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <pabeni@redhat.com>, <edumazet@google.com>, <olteanv@gmail.com>,
        <linux@armlinux.org.uk>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <Ian.Saturley@microchip.com>
Subject: [PATCH net-next V6 1/2] net: lan743x: Remove unused argument in lan743x_common_regs( )
Date:   Wed, 2 Nov 2022 16:18:33 +0530
Message-ID: <20221102104834.5555-2-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221102104834.5555-1-Raju.Lakkaraju@microchip.com>
References: <20221102104834.5555-1-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 drivers/net/ethernet/microchip/lan743x_ethtool.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_ethtool.c b/drivers/net/ethernet/microchip/lan743x_ethtool.c
index 88f9484cc2a7..fd59708ac4b5 100644
--- a/drivers/net/ethernet/microchip/lan743x_ethtool.c
+++ b/drivers/net/ethernet/microchip/lan743x_ethtool.c
@@ -1190,15 +1190,11 @@ static int lan743x_ethtool_set_wol(struct net_device *netdev,
 }
 #endif /* CONFIG_PM */
 
-static void lan743x_common_regs(struct net_device *dev,
-				struct ethtool_regs *regs, void *p)
-
+static void lan743x_common_regs(struct net_device *dev, void *p)
 {
 	struct lan743x_adapter *adapter = netdev_priv(dev);
 	u32 *rb = p;
 
-	memset(p, 0, (MAX_LAN743X_ETH_REGS * sizeof(u32)));
-
 	rb[ETH_PRIV_FLAGS] = adapter->flags;
 	rb[ETH_ID_REV]     = lan743x_csr_read(adapter, ID_REV);
 	rb[ETH_FPGA_REV]   = lan743x_csr_read(adapter, FPGA_REV);
@@ -1230,7 +1226,7 @@ static void lan743x_get_regs(struct net_device *dev,
 {
 	regs->version = LAN743X_ETH_REG_VERSION;
 
-	lan743x_common_regs(dev, regs, p);
+	lan743x_common_regs(dev, p);
 }
 
 static void lan743x_get_pauseparam(struct net_device *dev,
-- 
2.25.1

