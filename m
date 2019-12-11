Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 092F511BB4F
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 19:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731327AbfLKSPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 13:15:39 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:36101 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731306AbfLKSPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 13:15:38 -0500
Received: by mail-yw1-f68.google.com with SMTP id n184so2544549ywc.3;
        Wed, 11 Dec 2019 10:15:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Mwy/S/J6wsO8PbfLfst4z2PfBZ7YuKvJG/igovMyno0=;
        b=KJHGYsG0OY2Y9l/PncY7IQlms2PwWHCni33ygsVrhF9FXN2OpdgOht71AJDKcaccdj
         MsZLTfHdSa19JawfWKP+Sog7nzSW7B20rkmdfiGtOyLpmpPOFxmQqggfP3OutKzIZceG
         5w4iyIDNgyLEA80j/82e2E7MJtKNXMnPZaVgWdt4xvuD4+tpU1oGcFXfwb86G3gnfu4j
         n5MHfnbAg5iOJBAPHudVP4F18V1oMYLp48uMQ5tVXxNYR6qSZVL3Vkc3TGVUxvDkrz8z
         TGrXNsznE8SfS/gdCNy+FN/mmQVpQO7ip8goNarhEiQtECfLMWFFQrMciFh2VHuY0PvW
         xqOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Mwy/S/J6wsO8PbfLfst4z2PfBZ7YuKvJG/igovMyno0=;
        b=hg22QjXK/C0bPbI8Qu/qW/6H2IbS7y802qvucV3OPa2ePu+oWCLzt+RRyM3jctEDqq
         m4ldiuMmwjNS6aZCCEUSl6cNa+CfzmhKrxkM8NhSg0+7JKN+PBWsSJSbS7Qxu7kV638j
         c/XxUSJyscryhYLPsAjHaee2VJWKnTzZVWUgPDwHToRWv6FR+hktYfDgxH11eiqmcnoJ
         fM/3+hn8Y2islbduq+vYKLcxAhuevAO/DL/fzFlQNwFzY9hwd8h98yDq3VZtFz0GrNM/
         PB3KmtkM7XyIEEhNZjTRl4eSvx1AWXVlVkUSDozYc6aaxtirlpHzi6UDIyqiILbBD+nR
         AEXQ==
X-Gm-Message-State: APjAAAV/ktAvsLdZ6W6QLQC9Aq/tuMA/dQ2uco+qHD5eHXfC6fn2HG+A
        Jwm7/K0U2ppdP3rcPswNLzOJXKnHtBEP2A==
X-Google-Smtp-Source: APXvYqwUgZ48VcZDEX6jLUogQueS6jlPgBzrZ6tj6XT+JacAtvRER7pgE5YU4zBsreOXIgTWlhcYmQ==
X-Received: by 2002:a81:680b:: with SMTP id d11mr815196ywc.457.1576088136728;
        Wed, 11 Dec 2019 10:15:36 -0800 (PST)
Received: from karen ([2604:2d80:d68a:cf00:a4bc:8e08:1748:387f])
        by smtp.gmail.com with ESMTPSA id 204sm1304497ywx.21.2019.12.11.10.15.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 10:15:36 -0800 (PST)
From:   Scott Schafer <schaferjscott@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     Scott Schafer <schaferjscott@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 21/23] staging: qlge: Fix WARNING: suspect code indent for conditional statements
Date:   Wed, 11 Dec 2019 12:12:50 -0600
Message-Id: <323c4dfd64eef1ca15404e45d69ae260ee3e87f4.1576086080.git.schaferjscott@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1576086080.git.schaferjscott@gmail.com>
References: <cover.1576086080.git.schaferjscott@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix indentation for conditionals in qlge_ethtool.c and qlge_main.c

Signed-off-by: Scott Schafer <schaferjscott@gmail.com>
---
 drivers/staging/qlge/qlge_ethtool.c |  4 ++--
 drivers/staging/qlge/qlge_main.c    | 18 +++++++++---------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/qlge/qlge_ethtool.c b/drivers/staging/qlge/qlge_ethtool.c
index abed932c3694..0bb70b465389 100644
--- a/drivers/staging/qlge/qlge_ethtool.c
+++ b/drivers/staging/qlge/qlge_ethtool.c
@@ -529,8 +529,8 @@ void ql_check_lb_frame(struct ql_adapter *qdev,
 	if ((*(skb->data + 3) == 0xFF) &&
 	    (*(skb->data + frame_size / 2 + 10) == 0xBE) &&
 	    (*(skb->data + frame_size / 2 + 12) == 0xAF)) {
-			atomic_dec(&qdev->lb_count);
-			return;
+		atomic_dec(&qdev->lb_count);
+		return;
 	}
 }
 
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 9427386e4a1e..102da1fe9899 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -4121,11 +4121,11 @@ static struct net_device_stats *qlge_get_stats(struct net_device
 	/* Get RX stats. */
 	pkts = mcast = dropped = errors = bytes = 0;
 	for (i = 0; i < qdev->rss_ring_count; i++, rx_ring++) {
-			pkts += rx_ring->rx_packets;
-			bytes += rx_ring->rx_bytes;
-			dropped += rx_ring->rx_dropped;
-			errors += rx_ring->rx_errors;
-			mcast += rx_ring->rx_multicast;
+		pkts += rx_ring->rx_packets;
+		bytes += rx_ring->rx_bytes;
+		dropped += rx_ring->rx_dropped;
+		errors += rx_ring->rx_errors;
+		mcast += rx_ring->rx_multicast;
 	}
 	ndev->stats.rx_packets = pkts;
 	ndev->stats.rx_bytes = bytes;
@@ -4136,9 +4136,9 @@ static struct net_device_stats *qlge_get_stats(struct net_device
 	/* Get TX stats. */
 	pkts = errors = bytes = 0;
 	for (i = 0; i < qdev->tx_ring_count; i++, tx_ring++) {
-			pkts += tx_ring->tx_packets;
-			bytes += tx_ring->tx_bytes;
-			errors += tx_ring->tx_errors;
+		pkts += tx_ring->tx_packets;
+		bytes += tx_ring->tx_bytes;
+		errors += tx_ring->tx_errors;
 	}
 	ndev->stats.tx_packets = pkts;
 	ndev->stats.tx_bytes = bytes;
@@ -4432,7 +4432,7 @@ static int ql_init_device(struct pci_dev *pdev, struct net_device *ndev,
 	} else {
 		err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (!err)
-		       err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
+			err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 	}
 
 	if (err) {
-- 
2.20.1

