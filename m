Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2632B0C7D
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 19:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgKLSWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 13:22:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726597AbgKLSW0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 13:22:26 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58935C0613D1
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 10:22:26 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id b63so1696527pfg.12
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 10:22:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nYyiBvwXnhoNpusYUXNGEBo8iKVCfwhxeCA6lYkUDiw=;
        b=fLE6hK4d9AwikahZF7no8WcWQJN37qlYN7PPEHki1htjpOK1qOhxCTalQNSLwrBh83
         rOOEubq1RECocf/2ttQOOYDjl1rv5HHp1yk4E3m8ZZ46VE4Zrdwz7AiI6EneyYPlwIA9
         idDrx5g3QA4LLxZL2qLMgIBGZUndWqAFLxnu3AsvrxjP+NFWraQF9Msr6Vd1EitgoSLg
         9AMM36iinn/8zDh3LgJGJBaYgYbHPA6yVmF4eu7axR4Tob18B6/XA1G58DH2h+/bBEr/
         POS133H/T6BPQy5rVFwP/O+g5l6eLEn1k0Og5gHm4dbX5OJHuP8XOvSHCzxcnxw7nbyA
         OXZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nYyiBvwXnhoNpusYUXNGEBo8iKVCfwhxeCA6lYkUDiw=;
        b=mTN1bwzaH9oMpVJcQAPpOKzJmawxmrQFCY1e9DlRsrKNY7pogwFxoVLxScU4LZvL/6
         nDm7sy67MaY1MZNCabnmAQp0wQ1Rtj56jwI3x2+x/5zsUpMbGCF4fFvS+cKnngteLMxR
         2A8h/5EOO2QIuUL2HC132ny7KNG9kmMjFztsIRPeU4UUTZsU3o37sgQrjptbV7xYrNxF
         Anah8nd07liwuff+C8d4Bv1oYsLsY+qL+pEbNgDSjHF59FVgz5EoXGf5g4t9xRcUDTz5
         3g76876e99t7NBBVolAfMtjkqDXdCT59BpmrSkEFYm4MXdO+qr/yt8Kyypckn5K1ZbAP
         9wsg==
X-Gm-Message-State: AOAM531Vci8deHCqDn2GbcE2eDYLhMUJQeKyNZr90BRuzJKfM73u+p8G
        sik2u9IrlGKDJPR6p1T3Wnq3dguvrUVn6g==
X-Google-Smtp-Source: ABdhPJyMUxgSvpqQcR/xonwhDSoOptTI1O4xCnNq0faXvRYg+l1C6MFaKY07uq3EG/SALzsTyRL8wQ==
X-Received: by 2002:a17:90a:f68e:: with SMTP id cl14mr432219pjb.193.1605205345460;
        Thu, 12 Nov 2020 10:22:25 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id m6sm7152292pfa.61.2020.11.12.10.22.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Nov 2020 10:22:24 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v3 net-next 8/8] ionic: useful names for booleans
Date:   Thu, 12 Nov 2020 10:22:08 -0800
Message-Id: <20201112182208.46770-9-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201112182208.46770-1-snelson@pensando.io>
References: <20201112182208.46770-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With a few more uses of true and false in function calls, we
need to give them some useful names so we can tell from the
calling point what we're doing.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
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
index 7408755bac17..deabd813e3fe 100644
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
@@ -1784,7 +1784,7 @@ static int ionic_txrx_init(struct ionic_lif *lif)
 	if (lif->netdev->features & NETIF_F_RXHASH)
 		ionic_lif_rss_init(lif);
 
-	ionic_set_rx_mode(lif->netdev, true);
+	ionic_set_rx_mode(lif->netdev, CAN_SLEEP);
 
 	return 0;
 
@@ -2792,7 +2792,7 @@ static int ionic_station_set(struct ionic_lif *lif)
 		 */
 		if (!ether_addr_equal(ctx.comp.lif_getattr.mac,
 				      netdev->dev_addr))
-			ionic_lif_addr(lif, netdev->dev_addr, true, true);
+			ionic_lif_addr(lif, netdev->dev_addr, ADD_ADDR, CAN_SLEEP);
 	} else {
 		/* Update the netdev mac with the device's mac */
 		memcpy(addr.sa_data, ctx.comp.lif_getattr.mac, netdev->addr_len);
@@ -2809,7 +2809,7 @@ static int ionic_station_set(struct ionic_lif *lif)
 
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

