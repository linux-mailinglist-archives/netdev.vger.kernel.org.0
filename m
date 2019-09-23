Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE12BBE74
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 00:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503299AbfIWW1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 18:27:07 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36323 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391471AbfIWW1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Sep 2019 18:27:07 -0400
Received: by mail-pg1-f193.google.com with SMTP id h17so6294531pgb.3
        for <netdev@vger.kernel.org>; Mon, 23 Sep 2019 15:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wqHJEfnIbRtLqtK88X+1XhoduUQK2CVqI04lWzjuPyM=;
        b=R4gSVl3OUPlh/GAPF/Qpb/mi7tkqU7XrlzMdhqWb94VCewjp9KHVmG6/Jq5VQISet5
         STPcsxMKygpadxITdCJCn49479hXzgUoW0kwYuZqDsgmYI1wS7DF6kHG93nvmdyCc877
         aABFjEif7Uq/2R/PLuys6+ix2bKjNLe0wlcds=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wqHJEfnIbRtLqtK88X+1XhoduUQK2CVqI04lWzjuPyM=;
        b=uMyZ9kJWOmf0qN/IsdEsnpNIH2fTXWUb0py3YW7+K8AgiB0ByEj7eng0A+OoSyixZ6
         4VcWxBUSrxOS16I2YH0hObOwQzZR5KN5LQZfO7jtFd/M17xAXkf7tT5X5non5JVOBspm
         jziWZk+ycHYer/47UdhzAR7Ai/ZTtqlZNdL5TfiWfmNeARf1mbhhCWFhlMFsJyZO9T2E
         MDO2cHlDslDBM/pWpa0MG3mkf1YygUBoVglspe9377d+8Yi1vuVHYjyNVduYuYj1JEZB
         zOiJ4XOCYsMvUYtsvcAu+jpe4/aHvSpit2BLNx4fp/QC018cSVRcsHDFvn7gzVZWRJjn
         6THg==
X-Gm-Message-State: APjAAAXLqVf2OrVWekIpAOE8jN42OLgB1+irWzubyGLtgHVu4rTHwseh
        FS4ayBTb3g0nsZ18In64k25p4g==
X-Google-Smtp-Source: APXvYqw7UUjK3Olr/c8rAvm80/Bn2c9jWqBiADcKQTDUiG2nggObk2Uw2PjD/91AnJJABTonEuQCNg==
X-Received: by 2002:a17:90a:fa95:: with SMTP id cu21mr1910318pjb.43.1569277626059;
        Mon, 23 Sep 2019 15:27:06 -0700 (PDT)
Received: from pmalani2.mtv.corp.google.com ([2620:15c:202:201:172e:4646:c089:ce59])
        by smtp.gmail.com with ESMTPSA id r187sm11511495pfc.105.2019.09.23.15.27.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Sep 2019 15:27:05 -0700 (PDT)
From:   Prashant Malani <pmalani@chromium.org>
To:     hayeswang@realtek.com
Cc:     grundler@chromium.org, netdev@vger.kernel.org,
        nic_swsd@realtek.com, Prashant Malani <pmalani@chromium.org>
Subject: [PATCH] r8152: Use guard clause and fix comment typos
Date:   Mon, 23 Sep 2019 15:26:57 -0700
Message-Id: <20190923222657.253628-1-pmalani@chromium.org>
X-Mailer: git-send-email 2.23.0.351.gc4317032e6-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use a guard clause in tx_bottom() to reduce the indentation of the
do-while loop. In doing so, convert the do-while to a while to make the
guard clause checks consistent.

Also, fix a couple of spelling and grammatical mistakes in the
r8152_csum_workaround() function comment.

Change-Id: I460befde150ad92248fd85b0f189ec2df2ab8431
Signed-off-by: Prashant Malani <pmalani@chromium.org>
Reviewed-by: Grant Grundler <grundler@chromium.org>
---
 drivers/net/usb/r8152.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 08726090570e1..82bc69a5b24fb 100644
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
@@ -2177,8 +2177,9 @@ static void tx_bottom(struct r8152 *tp)
 {
 	int res;
 
-	do {
+	while (1) {
 		struct tx_agg *agg;
+		struct net_device *netdev = tp->netdev;
 
 		if (skb_queue_empty(&tp->tx_queue))
 			break;
@@ -2188,26 +2189,25 @@ static void tx_bottom(struct r8152 *tp)
 			break;
 
 		res = r8152_tx_agg_fill(tp, agg);
-		if (res) {
-			struct net_device *netdev = tp->netdev;
+		if (!res)
+			break;
 
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
-	} while (res == 0);
+	}
 }
 
 static void bottom_half(unsigned long data)
-- 
2.23.0.351.gc4317032e6-goog

