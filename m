Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E783430FAFA
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 19:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238967AbhBDSMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 13:12:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238854AbhBDSKq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 13:10:46 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7996FC06178B
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 10:10:06 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id d16so4601109wro.11
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 10:10:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nUxAXdLjhkJNUqiBcTNdD1orykfV5lPBWV6f7eDBEEk=;
        b=YS/hhQgn/ccTu+txLHLst5dnQ2u4qrZwkIRV2iqHghfJGHkoNMxuMBncBrxJXp3eYX
         z9F5USu7xrFfOwEDMdVfgUuZwCHmqpsvVVRDL8I3+ywXecWS+8zZqpAxJVDRlp/LasPG
         6OqvtX3/rYNkliAwfMHk5Hzgv9vfMZK1Fn0EqDC9a5/OSh31kVJJultFC1V3GWI9I6zn
         EOgmJ4lm/PXzCwlBo5odeeHdr855+zt4j6gFUyFJpA45frlX0cYeVMef5HxAWwK2eBpP
         IPyx7WYv+l90mMT8ECV/oiymMYGhIhh6w0eyMZ89DR5bgo5h3hh6Orqj7iUvIuSZsKzN
         jcZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nUxAXdLjhkJNUqiBcTNdD1orykfV5lPBWV6f7eDBEEk=;
        b=qKD6SGRvmPfbirFZaDpAKywL/7J5R/RS7s/hl6wqEozYbb5U1yVKsuWIAHpeYzMoQ7
         f/iJijCa6nNiW3jm3bPyyekL8LKHZPGftKlhcKEFeYJbcCkNacCGrIXUtiS68AoEpTeL
         +ws19zuKQjaTxK0f7T5CXB8vg69awTE3ZVe59xNDGq1dM/eemhWk+2fDTxoUnWL2/pQb
         kbe44co1VrtpeomzwJOH9EPm94kbvSuwUZvAl724vT0CbxXHpr0SkJ0dMOx0oFbGVzJf
         jc8+EcXMoaXrh7KQjBj+PiYURTy6YFMrYnDqwev3kejAA3cgFlt1f1h7xXabgC0ASCYQ
         CmVg==
X-Gm-Message-State: AOAM532UzF0FcSbVL3/56vUZ1ZJTIFHmG2zSn82hdn43I/ruLsIrH8Lv
        6WTXFxc6wsw431h5u4q2AFnpeA==
X-Google-Smtp-Source: ABdhPJyz4jOkt6O8pngYlFT+YRwqMS6pGKN8sBH2YpqthES7fvU0Ha0JIqCrFikesUvx+SPkHSyZUQ==
X-Received: by 2002:adf:ce89:: with SMTP id r9mr595461wrn.345.1612462205253;
        Thu, 04 Feb 2021 10:10:05 -0800 (PST)
Received: from localhost.localdomain ([88.122.66.28])
        by smtp.gmail.com with ESMTPSA id m6sm6313746wmq.13.2021.02.04.10.10.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Feb 2021 10:10:04 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, bjorn@mork.no, dcbw@redhat.com,
        carl.yin@quectel.com, mpearson@lenovo.com, cchen50@lenovo.com,
        jwjiang@lenovo.com, ivan.zhang@quectel.com,
        naveen.kumar@quectel.com, Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next v3 3/5] net: mhi: Create mhi.h
Date:   Thu,  4 Feb 2021 19:17:39 +0100
Message-Id: <1612462661-23045-4-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612462661-23045-1-git-send-email-loic.poulain@linaro.org>
References: <1612462661-23045-1-git-send-email-loic.poulain@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move mhi-net shared structures to mhi header, that will be used by
upcoming proto(s).

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/net/mhi/mhi.h | 36 ++++++++++++++++++++++++++++++++++++
 drivers/net/mhi/net.c | 33 ++-------------------------------
 2 files changed, 38 insertions(+), 31 deletions(-)
 create mode 100644 drivers/net/mhi/mhi.h

diff --git a/drivers/net/mhi/mhi.h b/drivers/net/mhi/mhi.h
new file mode 100644
index 0000000..5050e4a
--- /dev/null
+++ b/drivers/net/mhi/mhi.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/* MHI Network driver - Network over MHI bus
+ *
+ * Copyright (C) 2021 Linaro Ltd <loic.poulain@linaro.org>
+ */
+
+struct mhi_net_stats {
+	u64_stats_t rx_packets;
+	u64_stats_t rx_bytes;
+	u64_stats_t rx_errors;
+	u64_stats_t rx_dropped;
+	u64_stats_t tx_packets;
+	u64_stats_t tx_bytes;
+	u64_stats_t tx_errors;
+	u64_stats_t tx_dropped;
+	struct u64_stats_sync tx_syncp;
+	struct u64_stats_sync rx_syncp;
+};
+
+struct mhi_net_dev {
+	struct mhi_device *mdev;
+	struct net_device *ndev;
+	struct sk_buff *skbagg_head;
+	struct sk_buff *skbagg_tail;
+	const struct mhi_net_proto *proto;
+	void *proto_data;
+	struct delayed_work rx_refill;
+	struct mhi_net_stats stats;
+	u32 rx_queue_sz;
+};
+
+struct mhi_net_proto {
+	int (*init)(struct mhi_net_dev *mhi_netdev);
+	struct sk_buff * (*tx_fixup)(struct mhi_net_dev *mhi_netdev, struct sk_buff *skb);
+	void (*rx)(struct mhi_net_dev *mhi_netdev, struct sk_buff *skb);
+};
diff --git a/drivers/net/mhi/net.c b/drivers/net/mhi/net.c
index b92c2e1..58b4b7c 100644
--- a/drivers/net/mhi/net.c
+++ b/drivers/net/mhi/net.c
@@ -12,41 +12,12 @@
 #include <linux/skbuff.h>
 #include <linux/u64_stats_sync.h>
 
+#include "mhi.h"
+
 #define MHI_NET_MIN_MTU		ETH_MIN_MTU
 #define MHI_NET_MAX_MTU		0xffff
 #define MHI_NET_DEFAULT_MTU	0x4000
 
-struct mhi_net_stats {
-	u64_stats_t rx_packets;
-	u64_stats_t rx_bytes;
-	u64_stats_t rx_errors;
-	u64_stats_t rx_dropped;
-	u64_stats_t tx_packets;
-	u64_stats_t tx_bytes;
-	u64_stats_t tx_errors;
-	u64_stats_t tx_dropped;
-	struct u64_stats_sync tx_syncp;
-	struct u64_stats_sync rx_syncp;
-};
-
-struct mhi_net_dev {
-	struct mhi_device *mdev;
-	struct net_device *ndev;
-	struct sk_buff *skbagg_head;
-	struct sk_buff *skbagg_tail;
-	const struct mhi_net_proto *proto;
-	void *proto_data;
-	struct delayed_work rx_refill;
-	struct mhi_net_stats stats;
-	u32 rx_queue_sz;
-};
-
-struct mhi_net_proto {
-	int (*init)(struct mhi_net_dev *mhi_netdev);
-	struct sk_buff * (*tx_fixup)(struct mhi_net_dev *mhi_netdev, struct sk_buff *skb);
-	void (*rx)(struct mhi_net_dev *mhi_netdev, struct sk_buff *skb);
-};
-
 struct mhi_device_info {
 	const char *netname;
 	const struct mhi_net_proto *proto;
-- 
2.7.4

