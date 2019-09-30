Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83CA8C26D6
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 22:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731003AbfI3UlS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 16:41:18 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36244 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726314AbfI3UlR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 16:41:17 -0400
Received: by mail-pg1-f193.google.com with SMTP id t14so8025257pgs.3
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 13:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FIXOF1RqlyUo0JFT87PiHhCmDbMWJ3DTSFBjZOdOMyY=;
        b=QqLG9Q6pbxC3aroUtThx44LT4DuvA8VYl6sxkYuDNBUth/cZQ/TXazRat8Eh8TG0k/
         LYrTUEjOrp0p6FPst/MXEBswjzLnZkTiTOBPXmh6MjC3642kfIl3aTLt82mWudpen1+N
         +mloe9Ab4qC+VAbaIhgrcRrKq3qjuJYiL5ao4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FIXOF1RqlyUo0JFT87PiHhCmDbMWJ3DTSFBjZOdOMyY=;
        b=NDSSQOoCYOXCBo2QOrsPwduNHNE3Py8bU0dycCg3S53UuRKjALJdFSxPCeSDgyTA7f
         j+QI2jQaO+2BLvEU2y5a+LnEqSNK2j29W+bl5nx5C/8fXm4Mdww+p4uLKp+vFcjDwtg1
         dutxd8zqcBLq2dpbv2kzSMDTcfMBfWU2uupnUklw5qTQSy/HdT+CHPTW+hpKM8Yv/HLe
         yKRHFXOsaFq7aemQZto2PtjZJy/ydwcbKoaFP4yUT1KV1G8yPyMXd0Ovj4vEinRQ7hFO
         Y2w+EjbGpOj7Z0UP5Q9qfXKY4gsd9EMVMmqNjjYUHaDB5B92YVAHywoCff6KC99qddLX
         8FVg==
X-Gm-Message-State: APjAAAVCz+Dt1VjPFf59Sx/mJ9Mt0R3LiEBwWhBa6jCP0zg3sIVpNakH
        E8G47T01tmTcncygp1HrsCtKMGFgKPM=
X-Google-Smtp-Source: APXvYqzHfR5kKVVovlLpvGggRpmL4l4Gy6Aok6wABhnyogEaTRoP3eao2Csw0JE3SDaYrZvu+e+6sg==
X-Received: by 2002:a17:90a:3546:: with SMTP id q64mr969051pjb.13.1569872354249;
        Mon, 30 Sep 2019 12:39:14 -0700 (PDT)
Received: from pmalani2.mtv.corp.google.com ([2620:15c:202:201:172e:4646:c089:ce59])
        by smtp.gmail.com with ESMTPSA id a13sm12907043pfg.10.2019.09.30.12.39.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 12:39:13 -0700 (PDT)
From:   Prashant Malani <pmalani@chromium.org>
To:     hayeswang@realtek.com, davem@davemloft.net
Cc:     grundler@chromium.org, netdev@vger.kernel.org,
        nic_swsd@realtek.com, Prashant Malani <pmalani@chromium.org>
Subject: [PATCH net-next v3] r8152: Use guard clause and fix comment typos
Date:   Mon, 30 Sep 2019 12:38:18 -0700
Message-Id: <20190930193817.139261-1-pmalani@chromium.org>
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use a guard clause in tx_bottom() to reduce the indentation of the
do-while loop.

Also, fix a couple of spelling and grammatical mistakes in the
r8152_csum_workaround() function comment.

Change-Id: I460befde150ad92248fd85b0f189ec2df2ab8431
Signed-off-by: Prashant Malani <pmalani@chromium.org>
Reviewed-by: Grant Grundler <grundler@chromium.org>
Acked-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 08726090570e1..2c1faa8cf5fc9 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -1688,7 +1688,7 @@ static struct tx_agg *r8152_get_tx_agg(struct r8152 *tp)
 }
 
 /* r8152_csum_workaround()
- * The hw limites the value the transport offset. When the offset is out of the
+ * The hw limits the value of the transport offset. When the offset is out of
  * range, calculate the checksum by sw.
  */
 static void r8152_csum_workaround(struct r8152 *tp, struct sk_buff *skb,
@@ -2179,6 +2179,7 @@ static void tx_bottom(struct r8152 *tp)
 
 	do {
 		struct tx_agg *agg;
+		struct net_device *netdev = tp->netdev;
 
 		if (skb_queue_empty(&tp->tx_queue))
 			break;
@@ -2188,24 +2189,23 @@ static void tx_bottom(struct r8152 *tp)
 			break;
 
 		res = r8152_tx_agg_fill(tp, agg);
-		if (res) {
-			struct net_device *netdev = tp->netdev;
+		if (!res)
+			continue;
 
-			if (res == -ENODEV) {
-				rtl_set_unplug(tp);
-				netif_device_detach(netdev);
-			} else {
-				struct net_device_stats *stats = &netdev->stats;
-				unsigned long flags;
+		if (res == -ENODEV) {
+			rtl_set_unplug(tp);
+			netif_device_detach(netdev);
+		} else {
+			struct net_device_stats *stats = &netdev->stats;
+			unsigned long flags;
 
-				netif_warn(tp, tx_err, netdev,
-					   "failed tx_urb %d\n", res);
-				stats->tx_dropped += agg->skb_num;
+			netif_warn(tp, tx_err, netdev,
+				   "failed tx_urb %d\n", res);
+			stats->tx_dropped += agg->skb_num;
 
-				spin_lock_irqsave(&tp->tx_lock, flags);
-				list_add_tail(&agg->list, &tp->tx_free);
-				spin_unlock_irqrestore(&tp->tx_lock, flags);
-			}
+			spin_lock_irqsave(&tp->tx_lock, flags);
+			list_add_tail(&agg->list, &tp->tx_free);
+			spin_unlock_irqrestore(&tp->tx_lock, flags);
 		}
 	} while (res == 0);
 }
-- 
2.23.0.444.g18eeb5a265-goog

