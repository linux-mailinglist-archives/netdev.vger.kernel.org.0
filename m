Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC09B2A7094
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 23:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732438AbgKDWeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 17:34:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732250AbgKDWeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 17:34:10 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0241AC0613CF
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 14:34:10 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id t14so88235pgg.1
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 14:34:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nGSoe4Dy6+c/A+ugpSKq4ECZ+0Rs3hgJNVkOfrFbJs8=;
        b=fVSxzvQf4JQWN49jxW1tYgeqKxrJZDrwhHs0vzdOauWzj69O9e7X+BYAHaQ8YGWg7d
         y6tKlApCW3eIbeBYd8Tq+duIrVK8z7FUgb8S/ChxdjewNStXMHXf+ZItyvWvYXW9STu8
         PyL3uPcYntjFpD9NImPAk5E6uU9DLsx7pljihuBpmiD5ygVK94A4Ttf4qzyFJ4t/M5BM
         1zEvpW0H/gn6WJBG/7qlHoQY9pjy2m/JMSMLYui+P/o5GstFO6QuSMkamx7MFv/LyvFn
         tL+7HJfMNilhlaWI0P/IrksFRQuSZ8QPGUVvfWnuZWSvmdBsq6IRX9Q8fFjnJvJELH0c
         pxog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nGSoe4Dy6+c/A+ugpSKq4ECZ+0Rs3hgJNVkOfrFbJs8=;
        b=uGZPpG20qZvUY8MfvxamdqqI1nf6ixi63wWr0mnZBYAZUCvrr4Aszv1hGxQqM2OJ+x
         mwh7xae2MYYeaol0q6WGHLxSJVUo8fHvlZpbeYqAg8cEX4S0ahPfKSvrhmtPBS99eAG0
         JFs2PQo/Eh+JDhGasqQSm8jo59rCnanyuohE5Aa2ulG6UM8q7NmhLhNKJyYZSgrvRRnN
         LryPgJJ0XkujMATbJ4wEu6IQRjw3x3E1M7K9h6s1QNmaF4fp+Kf2+qkwpTAvEU376ZfZ
         NsyFFGP5+U89T7A/GUzTCCswOOe8akO8gZB5960/67JvFH1b6B+sr/wZhQHPI/s483mP
         A1Tw==
X-Gm-Message-State: AOAM530PF9SDwFEA/3nzKG/Q5IXsEco2bp0VWdV4F8MKOjZAJuT0G1we
        47cEYLIawDsP/7DOjQG791QcPPF7qpr+zA==
X-Google-Smtp-Source: ABdhPJzkjznxtnBPi37fFauLfe7YVTZTE/UdRgJYEsb6B/JLscIZgkh1Ly9ATBAXPDerVz73rNac5Q==
X-Received: by 2002:a17:90a:8b93:: with SMTP id z19mr75142pjn.123.1604529249341;
        Wed, 04 Nov 2020 14:34:09 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id z10sm3284559pff.218.2020.11.04.14.34.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Nov 2020 14:34:08 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 6/6] ionic: useful names for booleans
Date:   Wed,  4 Nov 2020 14:33:54 -0800
Message-Id: <20201104223354.63856-7-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201104223354.63856-1-snelson@pensando.io>
References: <20201104223354.63856-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With a few more uses of true and false in function calls, we
need to give them some useful names so we can tell from the
calling point what we're doing.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 16 ++++++++--------
 drivers/net/ethernet/pensando/ionic/ionic_lif.h |  8 ++++++++
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index a58bb572b23b..a0d2989a0d8d 100644
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
@@ -1214,7 +1214,7 @@ static void ionic_set_rx_mode(struct net_device *netdev, bool from_ndo)
 
 static void ionic_ndo_set_rx_mode(struct net_device *netdev)
 {
-	ionic_set_rx_mode(netdev, true);
+	ionic_set_rx_mode(netdev, FROM_NDO);
 }
 
 static __le64 ionic_netdev_features_to_nic(netdev_features_t features)
@@ -1805,7 +1805,7 @@ static int ionic_txrx_init(struct ionic_lif *lif)
 	if (lif->netdev->features & NETIF_F_RXHASH)
 		ionic_lif_rss_init(lif);
 
-	ionic_set_rx_mode(lif->netdev, false);
+	ionic_set_rx_mode(lif->netdev, NOT_FROM_NDO);
 
 	return 0;
 
@@ -2813,7 +2813,7 @@ static int ionic_station_set(struct ionic_lif *lif)
 		 */
 		if (!ether_addr_equal(ctx.comp.lif_getattr.mac,
 				      netdev->dev_addr))
-			ionic_lif_addr(lif, netdev->dev_addr, true, true);
+			ionic_lif_addr(lif, netdev->dev_addr, ADD_ADDR, CAN_SLEEP);
 	} else {
 		/* Update the netdev mac with the device's mac */
 		memcpy(addr.sa_data, ctx.comp.lif_getattr.mac, netdev->addr_len);
@@ -2830,7 +2830,7 @@ static int ionic_station_set(struct ionic_lif *lif)
 
 	netdev_dbg(lif->netdev, "adding station MAC addr %pM\n",
 		   netdev->dev_addr);
-	ionic_lif_addr(lif, netdev->dev_addr, true, true);
+	ionic_lif_addr(lif, netdev->dev_addr, ADD_ADDR, CAN_SLEEP);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 0224dfd24b8a..493de679b498 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -13,6 +13,14 @@
 
 #define IONIC_MAX_NUM_NAPI_CNTR		(NAPI_POLL_WEIGHT + 1)
 #define IONIC_MAX_NUM_SG_CNTR		(IONIC_TX_MAX_SG_ELEMS + 1)
+
+#define ADD_ADDR	true
+#define DEL_ADDR	false
+#define CAN_SLEEP	true
+#define CAN_NOT_SLEEP	false
+#define FROM_NDO	true
+#define NOT_FROM_NDO	false
+
 #define IONIC_RX_COPYBREAK_DEFAULT	256
 #define IONIC_TX_BUDGET_DEFAULT		256
 
-- 
2.17.1

