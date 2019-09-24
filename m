Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C62C0BC0D9
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 06:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbfIXEBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 00:01:12 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44195 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725308AbfIXEBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 00:01:11 -0400
Received: by mail-pf1-f193.google.com with SMTP id q21so377666pfn.11
        for <netdev@vger.kernel.org>; Mon, 23 Sep 2019 21:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/HTbESlNScSqELL4JUFiAPbXeIkl4QdAMqs3CGrqeYE=;
        b=g8+Q1fiyU3hNYz8f1+p/k50vxkU8Yuqf0L0ccW1SWobWim/RyMnhDrIH2T5j/I33Fm
         Raq83QiQHp6w92RteRyp07e3S4XNuUwNH4jzEdBwy0JS9wDe5t+qW5EjUifuNT5TbvAA
         oAiG7xNAFOCac7cSFMBuPIEh+1nlJv1M6vhmw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/HTbESlNScSqELL4JUFiAPbXeIkl4QdAMqs3CGrqeYE=;
        b=mNMp2/tQnPAoV7hlLJA3GcC1iSvCDl8BPXi6mMqoBTXFvphrJgn4o5eXm+3mjNqBof
         1/9Z9JAAF5pJ/4mGs3HhLzxhpljrahuWd8Ut6JG6J/SfBUfZ5NnRsDCJ6kLveQ/WmMsv
         n5fu2QT1LtvNmZMSNJ4x1HS/hASOxes8z/QYHiK9cN49pO2qmOXT7dJs3U0nD//064oc
         fiFZWgU8bRjElcNghB/BONTN4T98NMbJk2Tv0Jg4wzM1tL/sTC+SSJ7PbXWpYQtbNjbx
         Df1I7RZlajIPpN14AsROIwEM3N2DONATry6GGfRaUmQmGv2DMXlBmXDk4esfdf2mtpTW
         anZg==
X-Gm-Message-State: APjAAAVMZx1V95bmuyPM9s7bpLyCDRhoyTCfTUi6zXiKhoAIJwVZBOaj
        F020N4sYcbDFzN4NKzNsnjQvHw==
X-Google-Smtp-Source: APXvYqxGzjmc1Q8Rav9H9/DNFfhDMpdSloPy4GT+A3miIT30W/H1PBnBDcJfDt1dmOg2DASa4271fQ==
X-Received: by 2002:a63:514f:: with SMTP id r15mr1038948pgl.418.1569297670967;
        Mon, 23 Sep 2019 21:01:10 -0700 (PDT)
Received: from pmalani2.mtv.corp.google.com ([2620:15c:202:201:172e:4646:c089:ce59])
        by smtp.gmail.com with ESMTPSA id n1sm301361pfa.12.2019.09.23.21.01.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Sep 2019 21:01:10 -0700 (PDT)
From:   Prashant Malani <pmalani@chromium.org>
To:     hayeswang@realtek.com
Cc:     grundler@chromium.org, netdev@vger.kernel.org,
        nic_swsd@realtek.com, Prashant Malani <pmalani@chromium.org>
Subject: [PATCH v2] r8152: Use guard clause and fix comment typos
Date:   Mon, 23 Sep 2019 21:00:53 -0700
Message-Id: <20190924040052.71713-1-pmalani@chromium.org>
X-Mailer: git-send-email 2.23.0.351.gc4317032e6-goog
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
2.23.0.351.gc4317032e6-goog

