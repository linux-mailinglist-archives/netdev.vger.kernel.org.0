Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E89B76048BA
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 16:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbiJSOHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 10:07:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231331AbiJSOHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 10:07:05 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC45104521;
        Wed, 19 Oct 2022 06:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666187341; x=1697723341;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=chgcknyncVODyHQH/ImrJaerjij816AgaE6KR8ZHegs=;
  b=gPFRsE9gbxlOdypmng+j5BHQNjK5+tv3yjkJsmSckSjsX9rrp5rJYpuX
   Zyt/LY1W/dFORxddv36S5Nj4lJHqiYJ65J+/v2do7D7+Id1YwouWtLRQU
   4i9GdXYwNARZrYvpdNlJ7nfYKH1EnsPH+VQ9ea31x9Z64bzBdauW8PXRD
   Gayiq+IAnbJkISosr3IdBIdkYB4k4Yl77PMUReWC8hS/lS9NS/qdafVVs
   g4/cBNe9CTP6K79oUPmBCgy2ccvplp83bezHehXO5CQwrF+q3wvD/NdCZ
   J0belaGuofowVQ33Xm/IfJx9Vq1QyaR5yGjpXgEtnEt2g4Mvq4gqfbhsN
   g==;
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="119394751"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Oct 2022 06:46:53 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 19 Oct 2022 06:46:41 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 19 Oct 2022 06:46:38 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>,
        <linux@armlinux.org.uk>, <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 2/5] net: lan966x: Rename lan966x_fdma_get_max_mtu
Date:   Wed, 19 Oct 2022 15:50:05 +0200
Message-ID: <20221019135008.3281743-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019135008.3281743-1-horatiu.vultur@microchip.com>
References: <20221019135008.3281743-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename the function lan966x_fdma_get_max_mtu to lan966x_get_max_mtu
because it doesn't have anything to do with fdma. Because of this
rename, the function is moved also in a different file.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_fdma.c | 22 +------------------
 .../ethernet/microchip/lan966x/lan966x_main.c | 19 ++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_main.h |  2 ++
 3 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
index 1dc4e6ace8b56..e0b9cd289994f 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
@@ -661,25 +661,6 @@ int lan966x_fdma_xmit(struct sk_buff *skb, __be32 *ifh, struct net_device *dev)
 	return err;
 }
 
-static int lan966x_fdma_get_max_mtu(struct lan966x *lan966x)
-{
-	int max_mtu = 0;
-	int i;
-
-	for (i = 0; i < lan966x->num_phys_ports; ++i) {
-		int mtu;
-
-		if (!lan966x->ports[i])
-			continue;
-
-		mtu = lan966x->ports[i]->dev->mtu;
-		if (mtu > max_mtu)
-			max_mtu = mtu;
-	}
-
-	return max_mtu;
-}
-
 static int lan966x_qsys_sw_status(struct lan966x *lan966x)
 {
 	return lan_rd(lan966x, QSYS_SW_STATUS(CPU_PORT));
@@ -749,8 +730,7 @@ int lan966x_fdma_change_mtu(struct lan966x *lan966x)
 	int err;
 	u32 val;
 
-	max_mtu = lan966x_fdma_get_max_mtu(lan966x);
-	max_mtu += IFH_LEN_BYTES;
+	max_mtu = lan966x_get_max_mtu(lan966x);
 
 	if (round_up(max_mtu, PAGE_SIZE) / PAGE_SIZE - 1 ==
 	    lan966x->rx.page_order)
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 6fd857880d3fe..4fa8c07039d9f 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -379,6 +379,25 @@ static netdev_tx_t lan966x_port_xmit(struct sk_buff *skb,
 	return err;
 }
 
+int lan966x_get_max_mtu(struct lan966x *lan966x)
+{
+	int max_mtu = 0;
+	int i;
+
+	for (i = 0; i < lan966x->num_phys_ports; ++i) {
+		int mtu;
+
+		if (!lan966x->ports[i])
+			continue;
+
+		mtu = lan966x->ports[i]->dev->mtu;
+		if (mtu > max_mtu)
+			max_mtu = mtu;
+	}
+
+	return max_mtu + IFH_LEN_BYTES;
+}
+
 static int lan966x_port_change_mtu(struct net_device *dev, int new_mtu)
 {
 	struct lan966x_port *port = netdev_priv(dev);
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 9656071b8289e..e05036841f825 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -333,6 +333,8 @@ void lan966x_unregister_notifier_blocks(void);
 
 bool lan966x_hw_offload(struct lan966x *lan966x, u32 port, struct sk_buff *skb);
 
+int lan966x_get_max_mtu(struct lan966x *lan966x);
+
 void lan966x_ifh_get_src_port(void *ifh, u64 *src_port);
 void lan966x_ifh_get_timestamp(void *ifh, u64 *timestamp);
 
-- 
2.38.0

