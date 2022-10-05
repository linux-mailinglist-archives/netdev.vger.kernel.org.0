Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE965F5428
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 14:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbiJEMFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 08:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiJEMFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 08:05:11 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B864E1B787
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 05:05:09 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id ay36so10633175wmb.0
        for <netdev@vger.kernel.org>; Wed, 05 Oct 2022 05:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=KRm1i/FjODl/xyx7vhUvSFcaqvqmNQu9ppzqZg/T/ms=;
        b=QGdPK5xtP16USepja+6IFY3t0sutFWFGuiF9aUcx9bJ9o7194uWmKtswuYqxAcv5bM
         wb7omhj6AzKSYZMBjH+0czzPCKIpToHkvmOLK6XCgOpFJKRKJ+pFrxM2YhgeI0/lp0eL
         uZZTaQb2flYHuara6S0m/L0zo45uO7Hv+bITBTHsqNknbOJEpr1jppFU+9TO8TQ3xtEF
         XqN20K+U3vpTgv7KVs3wMINFnUg0O/JuVRlXB/HjlDf+RzQdZp0wDbLK4pSg15o7VjA7
         45Pu97RZd1ibCcOQK47w1fRItxg1Jmgg6cDVvRbQDbUyLxVZx4NtrBtczwsOugyQGmJm
         GxoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=KRm1i/FjODl/xyx7vhUvSFcaqvqmNQu9ppzqZg/T/ms=;
        b=QX5/XvCAxSLp9+8w4gcg5iZZkPuWuAykPmBKXIuJhdlQzB+nGAFaAdIwuI2gxCd/SM
         M5S7Pkdo90wW21h9Lul0M3jzxjpxWasQqoWyk5Adb5TGLXXxRBqvfi7X772vgdTWRkO+
         7DhHZU4H1Bkw/zS4u/oIYpQ3fGQXCdVn0d3rbieD1fFngmgE1eDrGAtrwDyKOQpP6iJY
         bbv4Y9LyHjNBibTet6q2pL7f/gkhb/qSciu3VW7crYVsjvQvgSkOR55tudD4gPXxFDp2
         cU8UmuByZVWaDXR1p/Vvo2oFD4kAkuHWBjN5JHorqCk6mM/r052ks0WOCY+pfRKaYBoV
         UHAQ==
X-Gm-Message-State: ACrzQf2LDf/i3zs7vMDGFXuHmkLHr6gaQeKDhjmpBn4lGv7dXWzxw+FK
        hfLt1CUKSRKKHrGMDTB+5DCUJg==
X-Google-Smtp-Source: AMsMyM7AnYe1pqnRsauylbxoTUQU0jGRG2FZqzUPWskH9jW2VW09NmxOnIodOZ/Ey98Lc3/tpRT91Q==
X-Received: by 2002:a05:600c:35c5:b0:3b4:bf50:f84a with SMTP id r5-20020a05600c35c500b003b4bf50f84amr2972425wmq.22.1664971508060;
        Wed, 05 Oct 2022 05:05:08 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id v16-20020a5d6790000000b0022e3e7813f0sm7799583wru.107.2022.10.05.05.05.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 05:05:07 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, edumazet@google.com, khalasa@piap.pl,
        kuba@kernel.org, pabeni@redhat.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 1/4] net: ethernet: xscale: fix space style issues
Date:   Wed,  5 Oct 2022 12:04:58 +0000
Message-Id: <20221005120501.3527435-1-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix all checkpatch issue about space/newlines.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index 3b0c5f177447..71d36ff7cd1b 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -115,7 +115,6 @@
 #define DEFAULT_RX_CNTRL0	RX_CNTRL0_RX_EN
 #define DEFAULT_CORE_CNTRL	CORE_MDC_EN
 
-
 /* NPE message codes */
 #define NPE_GETSTATUS			0x00
 #define NPE_EDB_SETPORTADDRESS		0x01
@@ -141,7 +140,6 @@
 #define NPE_NOTIFY_MAC_RECOVERY_DONE	0x16
 #define NPE_MAC_RECOVERY_START		0x17
 
-
 #ifdef __ARMEB__
 typedef struct sk_buff buffer_t;
 #define free_buffer dev_kfree_skb
@@ -247,7 +245,6 @@ struct desc {
 #endif
 };
 
-
 #define rx_desc_phys(port, n)	((port)->desc_tab_phys +		\
 				 (n) * sizeof(struct desc))
 #define rx_desc_ptr(port, n)	(&(port)->desc_tab[n])
@@ -260,6 +257,7 @@ struct desc {
 static inline void memcpy_swab32(u32 *dest, u32 *src, int cnt)
 {
 	int i;
+
 	for (i = 0; i < cnt; i++)
 		dest[i] = swab32(src[i]);
 }
@@ -566,7 +564,6 @@ static void ixp4xx_mdio_remove(void)
 	mdiobus_free(mdio_bus);
 }
 
-
 static void ixp4xx_adjust_link(struct net_device *dev)
 {
 	struct port *port = netdev_priv(dev);
@@ -597,7 +594,6 @@ static void ixp4xx_adjust_link(struct net_device *dev)
 		    dev->name, port->speed, port->duplex ? "full" : "half");
 }
 
-
 static inline void debug_pkt(struct net_device *dev, const char *func,
 			     u8 *data, int len)
 {
@@ -616,7 +612,6 @@ static inline void debug_pkt(struct net_device *dev, const char *func,
 #endif
 }
 
-
 static inline void debug_desc(u32 phys, struct desc *desc)
 {
 #if DEBUG_DESC
@@ -661,7 +656,6 @@ static inline void queue_put_desc(unsigned int queue, u32 phys,
 	   length and queues >= 32 don't support this check anyway. */
 }
 
-
 static inline void dma_unmap_tx(struct port *port, struct desc *desc)
 {
 #ifdef __ARMEB__
@@ -674,7 +668,6 @@ static inline void dma_unmap_tx(struct port *port, struct desc *desc)
 #endif
 }
 
-
 static void eth_rx_irq(void *pdev)
 {
 	struct net_device *dev = pdev;
@@ -792,7 +785,6 @@ static int eth_poll(struct napi_struct *napi, int budget)
 	return received;		/* not all work done */
 }
 
-
 static void eth_txdone_irq(void *unused)
 {
 	u32 phys;
@@ -932,7 +924,6 @@ static netdev_tx_t eth_xmit(struct sk_buff *skb, struct net_device *dev)
 	return NETDEV_TX_OK;
 }
 
-
 static void eth_set_mcast_list(struct net_device *dev)
 {
 	struct port *port = netdev_priv(dev);
@@ -976,7 +967,6 @@ static void eth_set_mcast_list(struct net_device *dev)
 		     &port->regs->rx_control[0]);
 }
 
-
 static int eth_ioctl(struct net_device *dev, struct ifreq *req, int cmd)
 {
 	if (!netif_running(dev))
@@ -1046,7 +1036,6 @@ static const struct ethtool_ops ixp4xx_ethtool_ops = {
 	.set_link_ksettings = phy_ethtool_set_link_ksettings,
 };
 
-
 static int request_queues(struct port *port)
 {
 	int err;
@@ -1157,6 +1146,7 @@ static void destroy_queues(struct port *port)
 		for (i = 0; i < RX_DESCS; i++) {
 			struct desc *desc = rx_desc_ptr(port, i);
 			buffer_t *buff = port->rx_buff_tab[i];
+
 			if (buff) {
 				dma_unmap_single(&port->netdev->dev,
 						 desc->data - NET_IP_ALIGN,
@@ -1167,6 +1157,7 @@ static void destroy_queues(struct port *port)
 		for (i = 0; i < TX_DESCS; i++) {
 			struct desc *desc = tx_desc_ptr(port, i);
 			buffer_t *buff = port->tx_buff_tab[i];
+
 			if (buff) {
 				dma_unmap_tx(port, desc);
 				free_buffer(buff);
@@ -1320,6 +1311,7 @@ static int eth_close(struct net_device *dev)
 			struct desc *desc;
 			u32 phys;
 			int n = queue_get_desc(port->plat->txreadyq, port, 1);
+
 			BUG_ON(n < 0);
 			desc = tx_desc_ptr(port, n);
 			phys = tx_desc_phys(port, n);
-- 
2.35.1

