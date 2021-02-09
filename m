Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43783314B15
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 10:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbhBIJBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 04:01:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbhBII6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 03:58:46 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F9C8C06178C
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 00:58:00 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id b3so20641702wrj.5
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 00:58:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nUxAXdLjhkJNUqiBcTNdD1orykfV5lPBWV6f7eDBEEk=;
        b=og0zYNFuIfnOyzDZ+rF4cq10kfF2FN328svbr8HZVYuYvn332y0r8UUG8iPVwejzAU
         kais7gmM0lW1Rw6nigqK1urngPaCjqxbBZdAH10oHPSBgyYQiDJRKqNCZtYEO8UJctrV
         mP9OIxwaJPyjb4n4iftCSOYq9yxTiQtqiz6DNMzPab2mmC0kqkYuQ8hWfyodVQRSmsdy
         gIDOgHBRAqi95KOFuNxUMh7QHzQKOtdEyQOvwoqFpKpOx4a+vgZusL9SOfkL1C9BP70c
         WQ/u7rYLUXn+Bd1RqETSubtdAkL2BbbXXLGCw3iT0IMz+PU7hHeXy6lB8gIqdFVoIuAa
         /hiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nUxAXdLjhkJNUqiBcTNdD1orykfV5lPBWV6f7eDBEEk=;
        b=qHuqqfSMzOqag2he2SwccjgvhB3LfAfHem9INCDOLNHtbVLc/1nO1BPW/o3bIQXbR1
         7A6O0+3ieDf8dIe0Hbqk1h+H/XJ7QVwVrpgEon4mx6ZbeUBOV2uY9tepFYsh36RnGxSD
         236FVzUgzBM8FmUW2j6VKwIpRkmnPxElxRkDnmK4ktL4jOfQcoHHoKqOP/JNlz9n/FtI
         MXfjskrH8H4+nHDbpPHUrMCkei2Y1cyr9T/Hl9QPUYwgKVAUBAC1SJhDZyC8qloHHANI
         kd3s6Mm23ZPwdM/09B5UAXDodCL+q/50tEWrQn+/Xe16FUvfK6FHt3Cwhb+C85Ixyd2a
         5qyQ==
X-Gm-Message-State: AOAM533LFLtiCRMNBJGYALaEoco/qfvh+uCVAOc8Kw7sXLsObnUdFUD7
        nkj8OLi5Apx97a/jBqYkFvQAeQ==
X-Google-Smtp-Source: ABdhPJxoAkNZE4VJncT3E3NsI9XK2XcG2SvLJ8EYTbV0odgHwffJaY/rMsfY9Br2UH2uK7ADPe7w5A==
X-Received: by 2002:a05:6000:cd:: with SMTP id q13mr24186024wrx.138.1612861079021;
        Tue, 09 Feb 2021 00:57:59 -0800 (PST)
Received: from localhost.localdomain ([88.122.66.28])
        by smtp.gmail.com with ESMTPSA id d3sm38348693wrp.79.2021.02.09.00.57.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Feb 2021 00:57:58 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, bjorn@mork.no, dcbw@redhat.com,
        carl.yin@quectel.com, mpearson@lenovo.com, cchen50@lenovo.com,
        jwjiang@lenovo.com, ivan.zhang@quectel.com,
        naveen.kumar@quectel.com, ivan.mikhanchuk@quectel.com,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next v5 3/5] net: mhi: Create mhi.h
Date:   Tue,  9 Feb 2021 10:05:56 +0100
Message-Id: <1612861558-14487-4-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612861558-14487-1-git-send-email-loic.poulain@linaro.org>
References: <1612861558-14487-1-git-send-email-loic.poulain@linaro.org>
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

