Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 260F92A8B2D
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 01:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732775AbgKFAMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 19:12:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732750AbgKFAMm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 19:12:42 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7E65C0613CF
        for <netdev@vger.kernel.org>; Thu,  5 Nov 2020 16:12:41 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id t14so2551717pgg.1
        for <netdev@vger.kernel.org>; Thu, 05 Nov 2020 16:12:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=IkpA71KX129Kn+dj86QAGM5+X4reANdRCWspxwQExj8=;
        b=Ys5FNiZLFdU3jxjs8FEoRQ7WNij3+2HjIkYCTLujbUq3jy5f4ZHKGvnbhe3yxqf20z
         J1Zca479OKW+VyweOlXPLJeQQq+OIhN98zqbshyj04wMpJOMieiasQLr5F4JmosscMOp
         q5KlJKaxMaTvB0x7yXmtWwDSFWeXCArRZaR74Ph640I6v3nEf0/LLKFwSMwteN9QZXD4
         8IaoHcIDnJjCPwiayCzdaoiedJtqr/IOLgwwOPumGfXI7IfkGPBUucwAg5UV91QIeNF0
         5VQhlBgryY0kBUDZpi2sfYPGWi7MbJdtaDNgCzQVgwPrN+qLpc7+ou1FXHgQjkynMYTa
         hzmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=IkpA71KX129Kn+dj86QAGM5+X4reANdRCWspxwQExj8=;
        b=tC8fXp+1POa+OnR9MeFPOWuqUIxm5Yr4ySOy/s1MNnganCkYfbi2K3zIz9qhO9xUsI
         ExnBTChwPdT1gGH+IfPMJU7Mv0Qphhl34wvc6ieXbPnXOrnmEIxrRMT1OrGCLjctIUBv
         sWAZHYeeOEml4pNrgtCqvVpaeNEGtNBJsL/pL52lKuUkztdwrXSf2rimWtEZzle1SfPD
         NZUwW9hvTHUOD+ABAgM6zz5zkaXdiGq4Ev8Hpb7BuNNImWlHW6qU7ZEFYcJ36LWJexc9
         1RZnzCPop0X9d8M/V530RU6zrwImcooqqZxhyFQI6JhYokqSDd7xcKf6qx1DKEi8lIY9
         h5CA==
X-Gm-Message-State: AOAM531qHNZSoaXSrJw2dhtdJY6/zN8fpg2N5TAGtf7BhZAv0R2nomXD
        IPsmoPzMitLOzlsmnO0ApzEBjCVcgXTxNw==
X-Google-Smtp-Source: ABdhPJy8pEb/X0SXAk9rvwxKLDNGrIaJ2U/Pi/eIg7gfAjIqqpLcn/TE1bAW+1gZq37Z0VW4JamsYQ==
X-Received: by 2002:a17:90a:db48:: with SMTP id u8mr4837664pjx.93.1604621560977;
        Thu, 05 Nov 2020 16:12:40 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id 22sm3236009pjb.40.2020.11.05.16.12.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2020 16:12:40 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 8/8] ionic: useful names for booleans
Date:   Thu,  5 Nov 2020 16:12:20 -0800
Message-Id: <20201106001220.68130-9-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201106001220.68130-1-snelson@pensando.io>
References: <20201106001220.68130-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With a few more uses of true and false in function calls, we
need to give them some useful names so we can tell from the
calling point what we're doing.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_dev.c |  2 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 16 ++++++++--------
 drivers/net/ethernet/pensando/ionic/ionic_lif.h |  6 ++++++
 3 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index dc5fbc2704f3..318db5f77fdb 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -25,7 +25,7 @@ static void ionic_watchdog_cb(struct timer_list *t)
 	hb = ionic_heartbeat_check(ionic);
 
 	if (hb >= 0)
-		ionic_link_status_check_request(ionic->lif, false);
+		ionic_link_status_check_request(ionic->lif, CAN_NOT_SLEEP);
 }
 
 void ionic_init_devinfo(struct ionic *ionic)
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 7e4ea4ecc912..9dde9d50c866 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1074,22 +1074,22 @@ static int ionic_lif_addr(struct ionic_lif *lif, const u8 *addr, bool add,
 
 static int ionic_addr_add(struct net_device *netdev, const u8 *addr)
 {
-	return ionic_lif_addr(netdev_priv(netdev), addr, true, true);
+	return ionic_lif_addr(netdev_priv(netdev), addr, ADD_ADDR, CAN_SLEEP);
 }
 
 static int ionic_ndo_addr_add(struct net_device *netdev, const u8 *addr)
 {
-	return ionic_lif_addr(netdev_priv(netdev), addr, true, false);
+	return ionic_lif_addr(netdev_priv(netdev), addr, ADD_ADDR, CAN_NOT_SLEEP);
 }
 
 static int ionic_addr_del(struct net_device *netdev, const u8 *addr)
 {
-	return ionic_lif_addr(netdev_priv(netdev), addr, false, true);
+	return ionic_lif_addr(netdev_priv(netdev), addr, DEL_ADDR, CAN_SLEEP);
 }
 
 static int ionic_ndo_addr_del(struct net_device *netdev, const u8 *addr)
 {
-	return ionic_lif_addr(netdev_priv(netdev), addr, false, false);
+	return ionic_lif_addr(netdev_priv(netdev), addr, DEL_ADDR, CAN_NOT_SLEEP);
 }
 
 static void ionic_lif_rx_mode(struct ionic_lif *lif, unsigned int rx_mode)
@@ -1197,7 +1197,7 @@ static void ionic_set_rx_mode(struct net_device *netdev, bool can_sleep)
 
 static void ionic_ndo_set_rx_mode(struct net_device *netdev)
 {
-	ionic_set_rx_mode(netdev, false);
+	ionic_set_rx_mode(netdev, CAN_NOT_SLEEP);
 }
 
 static __le64 ionic_netdev_features_to_nic(netdev_features_t features)
@@ -1788,7 +1788,7 @@ static int ionic_txrx_init(struct ionic_lif *lif)
 	if (lif->netdev->features & NETIF_F_RXHASH)
 		ionic_lif_rss_init(lif);
 
-	ionic_set_rx_mode(lif->netdev, true);
+	ionic_set_rx_mode(lif->netdev, CAN_SLEEP);
 
 	return 0;
 
@@ -2796,7 +2796,7 @@ static int ionic_station_set(struct ionic_lif *lif)
 		 */
 		if (!ether_addr_equal(ctx.comp.lif_getattr.mac,
 				      netdev->dev_addr))
-			ionic_lif_addr(lif, netdev->dev_addr, true, true);
+			ionic_lif_addr(lif, netdev->dev_addr, ADD_ADDR, CAN_SLEEP);
 	} else {
 		/* Update the netdev mac with the device's mac */
 		memcpy(addr.sa_data, ctx.comp.lif_getattr.mac, netdev->addr_len);
@@ -2813,7 +2813,7 @@ static int ionic_station_set(struct ionic_lif *lif)
 
 	netdev_dbg(lif->netdev, "adding station MAC addr %pM\n",
 		   netdev->dev_addr);
-	ionic_lif_addr(lif, netdev->dev_addr, true, true);
+	ionic_lif_addr(lif, netdev->dev_addr, ADD_ADDR, CAN_SLEEP);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 0224dfd24b8a..9bed42719ae5 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -13,6 +13,12 @@
 
 #define IONIC_MAX_NUM_NAPI_CNTR		(NAPI_POLL_WEIGHT + 1)
 #define IONIC_MAX_NUM_SG_CNTR		(IONIC_TX_MAX_SG_ELEMS + 1)
+
+#define ADD_ADDR	true
+#define DEL_ADDR	false
+#define CAN_SLEEP	true
+#define CAN_NOT_SLEEP	false
+
 #define IONIC_RX_COPYBREAK_DEFAULT	256
 #define IONIC_TX_BUDGET_DEFAULT		256
 
-- 
2.17.1

