Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C93D2312B45
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 08:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbhBHHxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 02:53:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbhBHHx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 02:53:26 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C080C06178C
        for <netdev@vger.kernel.org>; Sun,  7 Feb 2021 23:52:39 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id z6so15876162wrq.10
        for <netdev@vger.kernel.org>; Sun, 07 Feb 2021 23:52:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nUxAXdLjhkJNUqiBcTNdD1orykfV5lPBWV6f7eDBEEk=;
        b=AfYc/0Iows13/JMtkrIcj3smCNTE0D6ybhCjZJtfxLd6lxUmj//dMBYyTLLod1iJl/
         LHgvwiBu68GljKg/feTOTmZ/cMsA3ZNU4JOnADH2HzorB/0+XMEVh7pc2pq6RKy1kzRf
         KHcBXFRDcdchhlRsO9+UU831E425fFaJdaXY11DMkhYnSvJsZCNWfkSGqWtDfdEVH5P6
         1aQbQuareOyeVIVfF/faUQoNcvQXjYwfpTml20H0Bn1eq2MYB4Idw+WqomuT0gv9I3CB
         QcbL2six580lAuIuyEtyhx1tHPzPAwVfpj4OCzTq5ZjQz2jff7aYPHyv31D8MPiWPgi5
         0RGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nUxAXdLjhkJNUqiBcTNdD1orykfV5lPBWV6f7eDBEEk=;
        b=k6PJJPQboYstsRGF0uEKIc5kmhtTcojpsTcdVX27cUjXxxXZ6mEYxfQtUeu7qZUa+m
         2Nymj5DreeheZqynfVBpfq0pAxFwswd9jwF17b8Hj1qRBHM0HKCyDGWWlR33e/vblcg/
         m1J0z0vnBiFb4GIeTs6ta3ud+YPm866wY23JnAFnrjYJ6l0CvUjK5sQk2fNaHfa6qW1j
         s4usyqH4cPWMafStfersy1z3DUbPIY/uPsQCxtQ0kHSpgYrrZZxqe3Ekjk+q0scgg0x9
         ikxJcKYWAibtnMgwhkFdbLlXRN4jEdtVxgny/itVuQWZq98J3FZYIF8ukZZJbBlcSKEF
         +wPw==
X-Gm-Message-State: AOAM5315V89f+b4JXJYPQCvVGJEg4WgGrXvKRNW55HU41Q9h1N94tudj
        9bw0oAGLN9zAxPt4ryIgJ6TXjq9R9AkKYQ==
X-Google-Smtp-Source: ABdhPJyRf5WciVjLZqF4dwS3sgFYuW6novfxMqXAWW9E2DkueXylAFY7AFrqhxCsnCl8xRXxf9Nk1w==
X-Received: by 2002:a05:6000:104f:: with SMTP id c15mr18301365wrx.239.1612770758083;
        Sun, 07 Feb 2021 23:52:38 -0800 (PST)
Received: from localhost.localdomain ([2a01:e0a:490:8730:2c22:849b:ef6a:c4b9])
        by smtp.gmail.com with ESMTPSA id g16sm18784952wmi.30.2021.02.07.23.52.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 07 Feb 2021 23:52:37 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
Cc:     netdev@vger.kernel.org, bjorn@mork.no, dcbw@redhat.com,
        carl.yin@quectel.com, mpearson@lenovo.com, cchen50@lenovo.com,
        jwjiang@lenovo.com, ivan.zhang@quectel.com,
        naveen.kumar@quectel.com, ivan.mikhanchuk@quectel.com,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next v4 3/5] net: mhi: Create mhi.h
Date:   Mon,  8 Feb 2021 09:00:35 +0100
Message-Id: <1612771237-3782-4-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612771237-3782-1-git-send-email-loic.poulain@linaro.org>
References: <1612771237-3782-1-git-send-email-loic.poulain@linaro.org>
To:     unlisted-recipients:; (no To-header on input)
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

