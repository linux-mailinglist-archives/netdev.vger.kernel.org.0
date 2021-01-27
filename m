Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD3530615F
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 17:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234376AbhA0QzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 11:55:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233825AbhA0QyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 11:54:20 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A531C061574
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 08:53:39 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id e15so2286612wme.0
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 08:53:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5LKEwNd0woDrm/FI4/GE1OIO9In2ycXgwHk8R+XlR18=;
        b=y/mZU9k/xDVKhuFr7ASa4Kua81/qVwswTjEHpFQDQwxWO5WoN9hQAOMMLgJcSBQq6V
         pPyexjHsSGy2jmJ70Y43xqoZ+8KStH6NYEMLvju+FGSJA44npkW4m9woiZq8VcbIBkj/
         1PW/GsZG3M+Iw/1sUIQ0AC+pdv2nOJLzUzQ/nNPXOEyzVWfMLOESIHJdpGOopLBaZrDE
         xQdjvdoWd4KNWsgO1LHcPx7ceEXw4G3t3QUd86nty/2ZpEuX12mv4qv87GroUi8t/3rb
         DFw9Suw/saL4LZqB5iNs5FzxcMyq4RWC3+LaeOaflozi1HsgfWfOU7iK+J1OldhT8Tmx
         1kLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5LKEwNd0woDrm/FI4/GE1OIO9In2ycXgwHk8R+XlR18=;
        b=F4u2Q8a5K+6zO9YlQFJNWjLIg8a/Hqk5DQZDRPG3sTqZwEY/R363puOuZqLOjfP0E/
         dqr0R9Rxa6T3KJLKwOxpNeikEzEBmCbpUoqGx4sMQIApgS/Ojqvvj5rVf//ERW1yZO22
         fMm14os0CVQvrGzTeHuWW7gv58cEbACdwK0JtlYpa2NC08PoEv1vNxLsjQFG3A8vxt+j
         hVW3Eutw5jJIZLZBjgRAdgFoADS9xyOERVgUQ6lwJHfnjd22/ok+JB9tnedumnO9zzFu
         x+d7Gi4eE364kVEKICzzQwtCgHwGJr7TuLxzCf97WTHQkq2YiAXFcD9wTaVoO/NGUkgb
         pTLQ==
X-Gm-Message-State: AOAM5327UXAOSdWH1kmw7zf0DAWxAkEkR0ElFXkep8/DiJldrJ/OoEwG
        FDOabU0NtNNTcsUSYGrQo69mJg==
X-Google-Smtp-Source: ABdhPJyalz3FU9EWSttgBFUd98dJQEaadHPMuh738dHskmN/SKqurJJheFEMbd14dqNPPG5b/tn6eA==
X-Received: by 2002:a1c:a90f:: with SMTP id s15mr5081210wme.154.1611766418020;
        Wed, 27 Jan 2021 08:53:38 -0800 (PST)
Received: from localhost.localdomain ([88.122.66.28])
        by smtp.gmail.com with ESMTPSA id m82sm3077042wmf.29.2021.01.27.08.53.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 Jan 2021 08:53:37 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, carl.yin@quectel.com,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next 2/3] net: mhi: Add dedicated folder
Date:   Wed, 27 Jan 2021 18:01:16 +0100
Message-Id: <1611766877-16787-2-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1611766877-16787-1-git-send-email-loic.poulain@linaro.org>
References: <1611766877-16787-1-git-send-email-loic.poulain@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a dedicated mhi directory for mhi-net, mhi-net is going to
be split into differente files (for additional protocol support).

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/net/Makefile     |   2 +-
 drivers/net/mhi/Makefile |   3 +
 drivers/net/mhi/net.c    | 379 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/mhi_net.c    | 379 -----------------------------------------------
 4 files changed, 383 insertions(+), 380 deletions(-)
 create mode 100644 drivers/net/mhi/Makefile
 create mode 100644 drivers/net/mhi/net.c
 delete mode 100644 drivers/net/mhi_net.c

diff --git a/drivers/net/Makefile b/drivers/net/Makefile
index 36e2e41..f4990ff 100644
--- a/drivers/net/Makefile
+++ b/drivers/net/Makefile
@@ -36,7 +36,7 @@ obj-$(CONFIG_GTP) += gtp.o
 obj-$(CONFIG_NLMON) += nlmon.o
 obj-$(CONFIG_NET_VRF) += vrf.o
 obj-$(CONFIG_VSOCKMON) += vsockmon.o
-obj-$(CONFIG_MHI_NET) += mhi_net.o
+obj-$(CONFIG_MHI_NET) += mhi/
 
 #
 # Networking Drivers
diff --git a/drivers/net/mhi/Makefile b/drivers/net/mhi/Makefile
new file mode 100644
index 0000000..0acf989
--- /dev/null
+++ b/drivers/net/mhi/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_MHI_NET) += mhi_net.o
+
+mhi_net-y := net.o
diff --git a/drivers/net/mhi/net.c b/drivers/net/mhi/net.c
new file mode 100644
index 0000000..aa3a5e0
--- /dev/null
+++ b/drivers/net/mhi/net.c
@@ -0,0 +1,379 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* MHI Network driver - Network over MHI bus
+ *
+ * Copyright (C) 2020 Linaro Ltd <loic.poulain@linaro.org>
+ */
+
+#include <linux/if_arp.h>
+#include <linux/mhi.h>
+#include <linux/mod_devicetable.h>
+#include <linux/module.h>
+#include <linux/netdevice.h>
+#include <linux/skbuff.h>
+#include <linux/u64_stats_sync.h>
+
+#define MHI_NET_MIN_MTU		ETH_MIN_MTU
+#define MHI_NET_MAX_MTU		0xffff
+#define MHI_NET_DEFAULT_MTU	0x4000
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
+	atomic_t rx_queued;
+	struct u64_stats_sync tx_syncp;
+	struct u64_stats_sync rx_syncp;
+};
+
+struct mhi_net_dev {
+	struct mhi_device *mdev;
+	struct net_device *ndev;
+	const struct mhi_net_proto *proto;
+	void *proto_data;
+	struct delayed_work rx_refill;
+	struct mhi_net_stats stats;
+	u32 rx_queue_sz;
+};
+
+struct mhi_net_proto {
+	int (*init)(struct mhi_net_dev *dev);
+	struct sk_buff * (*tx_fixup)(struct net_device *ndev, struct sk_buff *skb);
+	int (*rx_fixup)(struct net_device *ndev, struct sk_buff *skb);
+};
+
+struct mhi_device_info {
+	const char *netname;
+	const struct mhi_net_proto *proto;
+};
+
+static int mhi_ndo_open(struct net_device *ndev)
+{
+	struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
+
+	/* Feed the rx buffer pool */
+	schedule_delayed_work(&mhi_netdev->rx_refill, 0);
+
+	/* Carrier is established via out-of-band channel (e.g. qmi) */
+	netif_carrier_on(ndev);
+
+	netif_start_queue(ndev);
+
+	return 0;
+}
+
+static int mhi_ndo_stop(struct net_device *ndev)
+{
+	struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
+
+	netif_stop_queue(ndev);
+	netif_carrier_off(ndev);
+	cancel_delayed_work_sync(&mhi_netdev->rx_refill);
+
+	return 0;
+}
+
+static int mhi_ndo_xmit(struct sk_buff *skb, struct net_device *ndev)
+{
+	struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
+	const struct mhi_net_proto *proto = mhi_netdev->proto;
+	struct mhi_device *mdev = mhi_netdev->mdev;
+	int err;
+
+	if (proto && proto->tx_fixup) {
+		skb = proto->tx_fixup(mhi_netdev->ndev, skb);
+		if (unlikely(!skb))
+			goto exit_drop;
+	}
+
+	err = mhi_queue_skb(mdev, DMA_TO_DEVICE, skb, skb->len, MHI_EOT);
+	if (unlikely(err)) {
+		net_err_ratelimited("%s: Failed to queue TX buf (%d)\n",
+				    ndev->name, err);
+		dev_kfree_skb_any(skb);
+		goto exit_drop;
+	}
+
+	if (mhi_queue_is_full(mdev, DMA_TO_DEVICE))
+		netif_stop_queue(ndev);
+
+	return NETDEV_TX_OK;
+
+exit_drop:
+	u64_stats_update_begin(&mhi_netdev->stats.tx_syncp);
+	u64_stats_inc(&mhi_netdev->stats.tx_dropped);
+	u64_stats_update_end(&mhi_netdev->stats.tx_syncp);
+
+	return NETDEV_TX_OK;
+}
+
+static void mhi_ndo_get_stats64(struct net_device *ndev,
+				struct rtnl_link_stats64 *stats)
+{
+	struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
+	unsigned int start;
+
+	do {
+		start = u64_stats_fetch_begin_irq(&mhi_netdev->stats.rx_syncp);
+		stats->rx_packets = u64_stats_read(&mhi_netdev->stats.rx_packets);
+		stats->rx_bytes = u64_stats_read(&mhi_netdev->stats.rx_bytes);
+		stats->rx_errors = u64_stats_read(&mhi_netdev->stats.rx_errors);
+		stats->rx_dropped = u64_stats_read(&mhi_netdev->stats.rx_dropped);
+	} while (u64_stats_fetch_retry_irq(&mhi_netdev->stats.rx_syncp, start));
+
+	do {
+		start = u64_stats_fetch_begin_irq(&mhi_netdev->stats.tx_syncp);
+		stats->tx_packets = u64_stats_read(&mhi_netdev->stats.tx_packets);
+		stats->tx_bytes = u64_stats_read(&mhi_netdev->stats.tx_bytes);
+		stats->tx_errors = u64_stats_read(&mhi_netdev->stats.tx_errors);
+		stats->tx_dropped = u64_stats_read(&mhi_netdev->stats.tx_dropped);
+	} while (u64_stats_fetch_retry_irq(&mhi_netdev->stats.tx_syncp, start));
+}
+
+static const struct net_device_ops mhi_netdev_ops = {
+	.ndo_open               = mhi_ndo_open,
+	.ndo_stop               = mhi_ndo_stop,
+	.ndo_start_xmit         = mhi_ndo_xmit,
+	.ndo_get_stats64	= mhi_ndo_get_stats64,
+};
+
+static void mhi_net_setup(struct net_device *ndev)
+{
+	ndev->header_ops = NULL;  /* No header */
+	ndev->type = ARPHRD_RAWIP;
+	ndev->hard_header_len = 0;
+	ndev->addr_len = 0;
+	ndev->flags = IFF_POINTOPOINT | IFF_NOARP;
+	ndev->netdev_ops = &mhi_netdev_ops;
+	ndev->mtu = MHI_NET_DEFAULT_MTU;
+	ndev->min_mtu = MHI_NET_MIN_MTU;
+	ndev->max_mtu = MHI_NET_MAX_MTU;
+	ndev->tx_queue_len = 1000;
+}
+
+static void mhi_net_dl_callback(struct mhi_device *mhi_dev,
+				struct mhi_result *mhi_res)
+{
+	struct mhi_net_dev *mhi_netdev = dev_get_drvdata(&mhi_dev->dev);
+	const struct mhi_net_proto *proto = mhi_netdev->proto;
+	struct sk_buff *skb = mhi_res->buf_addr;
+	int remaining;
+
+	remaining = atomic_dec_return(&mhi_netdev->stats.rx_queued);
+
+	if (unlikely(mhi_res->transaction_status)) {
+		dev_kfree_skb_any(skb);
+
+		/* MHI layer stopping/resetting the DL channel */
+		if (mhi_res->transaction_status == -ENOTCONN)
+			return;
+
+		u64_stats_update_begin(&mhi_netdev->stats.rx_syncp);
+		u64_stats_inc(&mhi_netdev->stats.rx_errors);
+		u64_stats_update_end(&mhi_netdev->stats.rx_syncp);
+	} else {
+		u64_stats_update_begin(&mhi_netdev->stats.rx_syncp);
+		u64_stats_inc(&mhi_netdev->stats.rx_packets);
+		u64_stats_add(&mhi_netdev->stats.rx_bytes, mhi_res->bytes_xferd);
+		u64_stats_update_end(&mhi_netdev->stats.rx_syncp);
+
+		switch (skb->data[0] & 0xf0) {
+		case 0x40:
+			skb->protocol = htons(ETH_P_IP);
+			break;
+		case 0x60:
+			skb->protocol = htons(ETH_P_IPV6);
+			break;
+		default:
+			skb->protocol = htons(ETH_P_MAP);
+			break;
+		}
+
+		skb_put(skb, mhi_res->bytes_xferd);
+
+		if (proto && proto->rx_fixup)
+			proto->rx_fixup(mhi_netdev->ndev, skb);
+		else
+			netif_rx(skb);
+	}
+
+	/* Refill if RX buffers queue becomes low */
+	if (remaining <= mhi_netdev->rx_queue_sz / 2)
+		schedule_delayed_work(&mhi_netdev->rx_refill, 0);
+}
+
+static void mhi_net_ul_callback(struct mhi_device *mhi_dev,
+				struct mhi_result *mhi_res)
+{
+	struct mhi_net_dev *mhi_netdev = dev_get_drvdata(&mhi_dev->dev);
+	struct net_device *ndev = mhi_netdev->ndev;
+	struct mhi_device *mdev = mhi_netdev->mdev;
+	struct sk_buff *skb = mhi_res->buf_addr;
+
+	/* Hardware has consumed the buffer, so free the skb (which is not
+	 * freed by the MHI stack) and perform accounting.
+	 */
+	dev_consume_skb_any(skb);
+
+	u64_stats_update_begin(&mhi_netdev->stats.tx_syncp);
+	if (unlikely(mhi_res->transaction_status)) {
+
+		/* MHI layer stopping/resetting the UL channel */
+		if (mhi_res->transaction_status == -ENOTCONN) {
+			u64_stats_update_end(&mhi_netdev->stats.tx_syncp);
+			return;
+		}
+
+		u64_stats_inc(&mhi_netdev->stats.tx_errors);
+	} else {
+		u64_stats_inc(&mhi_netdev->stats.tx_packets);
+		u64_stats_add(&mhi_netdev->stats.tx_bytes, mhi_res->bytes_xferd);
+	}
+	u64_stats_update_end(&mhi_netdev->stats.tx_syncp);
+
+	if (netif_queue_stopped(ndev) && !mhi_queue_is_full(mdev, DMA_TO_DEVICE))
+		netif_wake_queue(ndev);
+}
+
+static void mhi_net_rx_refill_work(struct work_struct *work)
+{
+	struct mhi_net_dev *mhi_netdev = container_of(work, struct mhi_net_dev,
+						      rx_refill.work);
+	struct net_device *ndev = mhi_netdev->ndev;
+	struct mhi_device *mdev = mhi_netdev->mdev;
+	int size = READ_ONCE(ndev->mtu);
+	struct sk_buff *skb;
+	int err;
+
+	while (atomic_read(&mhi_netdev->stats.rx_queued) < mhi_netdev->rx_queue_sz) {
+		skb = netdev_alloc_skb(ndev, size);
+		if (unlikely(!skb))
+			break;
+
+		err = mhi_queue_skb(mdev, DMA_FROM_DEVICE, skb, size, MHI_EOT);
+		if (unlikely(err)) {
+			net_err_ratelimited("%s: Failed to queue RX buf (%d)\n",
+					    ndev->name, err);
+			kfree_skb(skb);
+			break;
+		}
+
+		atomic_inc(&mhi_netdev->stats.rx_queued);
+
+		/* Do not hog the CPU if rx buffers are consumed faster than
+		 * queued (unlikely).
+		 */
+		cond_resched();
+	}
+
+	/* If we're still starved of rx buffers, reschedule later */
+	if (unlikely(!atomic_read(&mhi_netdev->stats.rx_queued)))
+		schedule_delayed_work(&mhi_netdev->rx_refill, HZ / 2);
+}
+
+static struct device_type wwan_type = {
+	.name = "wwan",
+};
+
+static int mhi_net_probe(struct mhi_device *mhi_dev,
+			 const struct mhi_device_id *id)
+{
+	const struct mhi_device_info *info = (struct mhi_device_info *)id->driver_data;
+	struct device *dev = &mhi_dev->dev;
+	struct mhi_net_dev *mhi_netdev;
+	struct net_device *ndev;
+	int err;
+
+	ndev = alloc_netdev(sizeof(*mhi_netdev), info->netname,
+			    NET_NAME_PREDICTABLE, mhi_net_setup);
+	if (!ndev)
+		return -ENOMEM;
+
+	mhi_netdev = netdev_priv(ndev);
+	dev_set_drvdata(dev, mhi_netdev);
+	mhi_netdev->ndev = ndev;
+	mhi_netdev->mdev = mhi_dev;
+	mhi_netdev->proto = info->proto;
+	SET_NETDEV_DEV(ndev, &mhi_dev->dev);
+	SET_NETDEV_DEVTYPE(ndev, &wwan_type);
+
+	/* All MHI net channels have 128 ring elements (at least for now) */
+	mhi_netdev->rx_queue_sz = 128;
+
+	INIT_DELAYED_WORK(&mhi_netdev->rx_refill, mhi_net_rx_refill_work);
+	u64_stats_init(&mhi_netdev->stats.rx_syncp);
+	u64_stats_init(&mhi_netdev->stats.tx_syncp);
+
+	/* Start MHI channels */
+	err = mhi_prepare_for_transfer(mhi_dev);
+	if (err)
+		goto out_err;
+
+	err = register_netdev(ndev);
+	if (err)
+		goto out_err;
+
+	if (mhi_netdev->proto) {
+		err = mhi_netdev->proto->init(mhi_netdev);
+		if (err)
+			goto out_err_proto;
+	}
+
+	return 0;
+
+out_err_proto:
+	unregister_netdev(ndev);
+out_err:
+	free_netdev(ndev);
+	return err;
+}
+
+static void mhi_net_remove(struct mhi_device *mhi_dev)
+{
+	struct mhi_net_dev *mhi_netdev = dev_get_drvdata(&mhi_dev->dev);
+
+	unregister_netdev(mhi_netdev->ndev);
+
+	mhi_unprepare_from_transfer(mhi_netdev->mdev);
+
+	free_netdev(mhi_netdev->ndev);
+}
+
+static const struct mhi_device_info mhi_hwip0 = {
+	.netname = "mhi_hwip%d",
+};
+
+static const struct mhi_device_info mhi_swip0 = {
+	.netname = "mhi_swip%d",
+};
+
+static const struct mhi_device_id mhi_net_id_table[] = {
+	/* Hardware accelerated data PATH (to modem IPA), protocol agnostic */
+	{ .chan = "IP_HW0", .driver_data = (kernel_ulong_t)&mhi_hwip0 },
+	/* Software data PATH (to modem CPU) */
+	{ .chan = "IP_SW0", .driver_data = (kernel_ulong_t)&mhi_swip0 },
+	{}
+};
+MODULE_DEVICE_TABLE(mhi, mhi_net_id_table);
+
+static struct mhi_driver mhi_net_driver = {
+	.probe = mhi_net_probe,
+	.remove = mhi_net_remove,
+	.dl_xfer_cb = mhi_net_dl_callback,
+	.ul_xfer_cb = mhi_net_ul_callback,
+	.id_table = mhi_net_id_table,
+	.driver = {
+		.name = "mhi_net",
+		.owner = THIS_MODULE,
+	},
+};
+
+module_mhi_driver(mhi_net_driver);
+
+MODULE_AUTHOR("Loic Poulain <loic.poulain@linaro.org>");
+MODULE_DESCRIPTION("Network over MHI");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/net/mhi_net.c b/drivers/net/mhi_net.c
deleted file mode 100644
index aa3a5e0..0000000
--- a/drivers/net/mhi_net.c
+++ /dev/null
@@ -1,379 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/* MHI Network driver - Network over MHI bus
- *
- * Copyright (C) 2020 Linaro Ltd <loic.poulain@linaro.org>
- */
-
-#include <linux/if_arp.h>
-#include <linux/mhi.h>
-#include <linux/mod_devicetable.h>
-#include <linux/module.h>
-#include <linux/netdevice.h>
-#include <linux/skbuff.h>
-#include <linux/u64_stats_sync.h>
-
-#define MHI_NET_MIN_MTU		ETH_MIN_MTU
-#define MHI_NET_MAX_MTU		0xffff
-#define MHI_NET_DEFAULT_MTU	0x4000
-
-struct mhi_net_stats {
-	u64_stats_t rx_packets;
-	u64_stats_t rx_bytes;
-	u64_stats_t rx_errors;
-	u64_stats_t rx_dropped;
-	u64_stats_t tx_packets;
-	u64_stats_t tx_bytes;
-	u64_stats_t tx_errors;
-	u64_stats_t tx_dropped;
-	atomic_t rx_queued;
-	struct u64_stats_sync tx_syncp;
-	struct u64_stats_sync rx_syncp;
-};
-
-struct mhi_net_dev {
-	struct mhi_device *mdev;
-	struct net_device *ndev;
-	const struct mhi_net_proto *proto;
-	void *proto_data;
-	struct delayed_work rx_refill;
-	struct mhi_net_stats stats;
-	u32 rx_queue_sz;
-};
-
-struct mhi_net_proto {
-	int (*init)(struct mhi_net_dev *dev);
-	struct sk_buff * (*tx_fixup)(struct net_device *ndev, struct sk_buff *skb);
-	int (*rx_fixup)(struct net_device *ndev, struct sk_buff *skb);
-};
-
-struct mhi_device_info {
-	const char *netname;
-	const struct mhi_net_proto *proto;
-};
-
-static int mhi_ndo_open(struct net_device *ndev)
-{
-	struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
-
-	/* Feed the rx buffer pool */
-	schedule_delayed_work(&mhi_netdev->rx_refill, 0);
-
-	/* Carrier is established via out-of-band channel (e.g. qmi) */
-	netif_carrier_on(ndev);
-
-	netif_start_queue(ndev);
-
-	return 0;
-}
-
-static int mhi_ndo_stop(struct net_device *ndev)
-{
-	struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
-
-	netif_stop_queue(ndev);
-	netif_carrier_off(ndev);
-	cancel_delayed_work_sync(&mhi_netdev->rx_refill);
-
-	return 0;
-}
-
-static int mhi_ndo_xmit(struct sk_buff *skb, struct net_device *ndev)
-{
-	struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
-	const struct mhi_net_proto *proto = mhi_netdev->proto;
-	struct mhi_device *mdev = mhi_netdev->mdev;
-	int err;
-
-	if (proto && proto->tx_fixup) {
-		skb = proto->tx_fixup(mhi_netdev->ndev, skb);
-		if (unlikely(!skb))
-			goto exit_drop;
-	}
-
-	err = mhi_queue_skb(mdev, DMA_TO_DEVICE, skb, skb->len, MHI_EOT);
-	if (unlikely(err)) {
-		net_err_ratelimited("%s: Failed to queue TX buf (%d)\n",
-				    ndev->name, err);
-		dev_kfree_skb_any(skb);
-		goto exit_drop;
-	}
-
-	if (mhi_queue_is_full(mdev, DMA_TO_DEVICE))
-		netif_stop_queue(ndev);
-
-	return NETDEV_TX_OK;
-
-exit_drop:
-	u64_stats_update_begin(&mhi_netdev->stats.tx_syncp);
-	u64_stats_inc(&mhi_netdev->stats.tx_dropped);
-	u64_stats_update_end(&mhi_netdev->stats.tx_syncp);
-
-	return NETDEV_TX_OK;
-}
-
-static void mhi_ndo_get_stats64(struct net_device *ndev,
-				struct rtnl_link_stats64 *stats)
-{
-	struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
-	unsigned int start;
-
-	do {
-		start = u64_stats_fetch_begin_irq(&mhi_netdev->stats.rx_syncp);
-		stats->rx_packets = u64_stats_read(&mhi_netdev->stats.rx_packets);
-		stats->rx_bytes = u64_stats_read(&mhi_netdev->stats.rx_bytes);
-		stats->rx_errors = u64_stats_read(&mhi_netdev->stats.rx_errors);
-		stats->rx_dropped = u64_stats_read(&mhi_netdev->stats.rx_dropped);
-	} while (u64_stats_fetch_retry_irq(&mhi_netdev->stats.rx_syncp, start));
-
-	do {
-		start = u64_stats_fetch_begin_irq(&mhi_netdev->stats.tx_syncp);
-		stats->tx_packets = u64_stats_read(&mhi_netdev->stats.tx_packets);
-		stats->tx_bytes = u64_stats_read(&mhi_netdev->stats.tx_bytes);
-		stats->tx_errors = u64_stats_read(&mhi_netdev->stats.tx_errors);
-		stats->tx_dropped = u64_stats_read(&mhi_netdev->stats.tx_dropped);
-	} while (u64_stats_fetch_retry_irq(&mhi_netdev->stats.tx_syncp, start));
-}
-
-static const struct net_device_ops mhi_netdev_ops = {
-	.ndo_open               = mhi_ndo_open,
-	.ndo_stop               = mhi_ndo_stop,
-	.ndo_start_xmit         = mhi_ndo_xmit,
-	.ndo_get_stats64	= mhi_ndo_get_stats64,
-};
-
-static void mhi_net_setup(struct net_device *ndev)
-{
-	ndev->header_ops = NULL;  /* No header */
-	ndev->type = ARPHRD_RAWIP;
-	ndev->hard_header_len = 0;
-	ndev->addr_len = 0;
-	ndev->flags = IFF_POINTOPOINT | IFF_NOARP;
-	ndev->netdev_ops = &mhi_netdev_ops;
-	ndev->mtu = MHI_NET_DEFAULT_MTU;
-	ndev->min_mtu = MHI_NET_MIN_MTU;
-	ndev->max_mtu = MHI_NET_MAX_MTU;
-	ndev->tx_queue_len = 1000;
-}
-
-static void mhi_net_dl_callback(struct mhi_device *mhi_dev,
-				struct mhi_result *mhi_res)
-{
-	struct mhi_net_dev *mhi_netdev = dev_get_drvdata(&mhi_dev->dev);
-	const struct mhi_net_proto *proto = mhi_netdev->proto;
-	struct sk_buff *skb = mhi_res->buf_addr;
-	int remaining;
-
-	remaining = atomic_dec_return(&mhi_netdev->stats.rx_queued);
-
-	if (unlikely(mhi_res->transaction_status)) {
-		dev_kfree_skb_any(skb);
-
-		/* MHI layer stopping/resetting the DL channel */
-		if (mhi_res->transaction_status == -ENOTCONN)
-			return;
-
-		u64_stats_update_begin(&mhi_netdev->stats.rx_syncp);
-		u64_stats_inc(&mhi_netdev->stats.rx_errors);
-		u64_stats_update_end(&mhi_netdev->stats.rx_syncp);
-	} else {
-		u64_stats_update_begin(&mhi_netdev->stats.rx_syncp);
-		u64_stats_inc(&mhi_netdev->stats.rx_packets);
-		u64_stats_add(&mhi_netdev->stats.rx_bytes, mhi_res->bytes_xferd);
-		u64_stats_update_end(&mhi_netdev->stats.rx_syncp);
-
-		switch (skb->data[0] & 0xf0) {
-		case 0x40:
-			skb->protocol = htons(ETH_P_IP);
-			break;
-		case 0x60:
-			skb->protocol = htons(ETH_P_IPV6);
-			break;
-		default:
-			skb->protocol = htons(ETH_P_MAP);
-			break;
-		}
-
-		skb_put(skb, mhi_res->bytes_xferd);
-
-		if (proto && proto->rx_fixup)
-			proto->rx_fixup(mhi_netdev->ndev, skb);
-		else
-			netif_rx(skb);
-	}
-
-	/* Refill if RX buffers queue becomes low */
-	if (remaining <= mhi_netdev->rx_queue_sz / 2)
-		schedule_delayed_work(&mhi_netdev->rx_refill, 0);
-}
-
-static void mhi_net_ul_callback(struct mhi_device *mhi_dev,
-				struct mhi_result *mhi_res)
-{
-	struct mhi_net_dev *mhi_netdev = dev_get_drvdata(&mhi_dev->dev);
-	struct net_device *ndev = mhi_netdev->ndev;
-	struct mhi_device *mdev = mhi_netdev->mdev;
-	struct sk_buff *skb = mhi_res->buf_addr;
-
-	/* Hardware has consumed the buffer, so free the skb (which is not
-	 * freed by the MHI stack) and perform accounting.
-	 */
-	dev_consume_skb_any(skb);
-
-	u64_stats_update_begin(&mhi_netdev->stats.tx_syncp);
-	if (unlikely(mhi_res->transaction_status)) {
-
-		/* MHI layer stopping/resetting the UL channel */
-		if (mhi_res->transaction_status == -ENOTCONN) {
-			u64_stats_update_end(&mhi_netdev->stats.tx_syncp);
-			return;
-		}
-
-		u64_stats_inc(&mhi_netdev->stats.tx_errors);
-	} else {
-		u64_stats_inc(&mhi_netdev->stats.tx_packets);
-		u64_stats_add(&mhi_netdev->stats.tx_bytes, mhi_res->bytes_xferd);
-	}
-	u64_stats_update_end(&mhi_netdev->stats.tx_syncp);
-
-	if (netif_queue_stopped(ndev) && !mhi_queue_is_full(mdev, DMA_TO_DEVICE))
-		netif_wake_queue(ndev);
-}
-
-static void mhi_net_rx_refill_work(struct work_struct *work)
-{
-	struct mhi_net_dev *mhi_netdev = container_of(work, struct mhi_net_dev,
-						      rx_refill.work);
-	struct net_device *ndev = mhi_netdev->ndev;
-	struct mhi_device *mdev = mhi_netdev->mdev;
-	int size = READ_ONCE(ndev->mtu);
-	struct sk_buff *skb;
-	int err;
-
-	while (atomic_read(&mhi_netdev->stats.rx_queued) < mhi_netdev->rx_queue_sz) {
-		skb = netdev_alloc_skb(ndev, size);
-		if (unlikely(!skb))
-			break;
-
-		err = mhi_queue_skb(mdev, DMA_FROM_DEVICE, skb, size, MHI_EOT);
-		if (unlikely(err)) {
-			net_err_ratelimited("%s: Failed to queue RX buf (%d)\n",
-					    ndev->name, err);
-			kfree_skb(skb);
-			break;
-		}
-
-		atomic_inc(&mhi_netdev->stats.rx_queued);
-
-		/* Do not hog the CPU if rx buffers are consumed faster than
-		 * queued (unlikely).
-		 */
-		cond_resched();
-	}
-
-	/* If we're still starved of rx buffers, reschedule later */
-	if (unlikely(!atomic_read(&mhi_netdev->stats.rx_queued)))
-		schedule_delayed_work(&mhi_netdev->rx_refill, HZ / 2);
-}
-
-static struct device_type wwan_type = {
-	.name = "wwan",
-};
-
-static int mhi_net_probe(struct mhi_device *mhi_dev,
-			 const struct mhi_device_id *id)
-{
-	const struct mhi_device_info *info = (struct mhi_device_info *)id->driver_data;
-	struct device *dev = &mhi_dev->dev;
-	struct mhi_net_dev *mhi_netdev;
-	struct net_device *ndev;
-	int err;
-
-	ndev = alloc_netdev(sizeof(*mhi_netdev), info->netname,
-			    NET_NAME_PREDICTABLE, mhi_net_setup);
-	if (!ndev)
-		return -ENOMEM;
-
-	mhi_netdev = netdev_priv(ndev);
-	dev_set_drvdata(dev, mhi_netdev);
-	mhi_netdev->ndev = ndev;
-	mhi_netdev->mdev = mhi_dev;
-	mhi_netdev->proto = info->proto;
-	SET_NETDEV_DEV(ndev, &mhi_dev->dev);
-	SET_NETDEV_DEVTYPE(ndev, &wwan_type);
-
-	/* All MHI net channels have 128 ring elements (at least for now) */
-	mhi_netdev->rx_queue_sz = 128;
-
-	INIT_DELAYED_WORK(&mhi_netdev->rx_refill, mhi_net_rx_refill_work);
-	u64_stats_init(&mhi_netdev->stats.rx_syncp);
-	u64_stats_init(&mhi_netdev->stats.tx_syncp);
-
-	/* Start MHI channels */
-	err = mhi_prepare_for_transfer(mhi_dev);
-	if (err)
-		goto out_err;
-
-	err = register_netdev(ndev);
-	if (err)
-		goto out_err;
-
-	if (mhi_netdev->proto) {
-		err = mhi_netdev->proto->init(mhi_netdev);
-		if (err)
-			goto out_err_proto;
-	}
-
-	return 0;
-
-out_err_proto:
-	unregister_netdev(ndev);
-out_err:
-	free_netdev(ndev);
-	return err;
-}
-
-static void mhi_net_remove(struct mhi_device *mhi_dev)
-{
-	struct mhi_net_dev *mhi_netdev = dev_get_drvdata(&mhi_dev->dev);
-
-	unregister_netdev(mhi_netdev->ndev);
-
-	mhi_unprepare_from_transfer(mhi_netdev->mdev);
-
-	free_netdev(mhi_netdev->ndev);
-}
-
-static const struct mhi_device_info mhi_hwip0 = {
-	.netname = "mhi_hwip%d",
-};
-
-static const struct mhi_device_info mhi_swip0 = {
-	.netname = "mhi_swip%d",
-};
-
-static const struct mhi_device_id mhi_net_id_table[] = {
-	/* Hardware accelerated data PATH (to modem IPA), protocol agnostic */
-	{ .chan = "IP_HW0", .driver_data = (kernel_ulong_t)&mhi_hwip0 },
-	/* Software data PATH (to modem CPU) */
-	{ .chan = "IP_SW0", .driver_data = (kernel_ulong_t)&mhi_swip0 },
-	{}
-};
-MODULE_DEVICE_TABLE(mhi, mhi_net_id_table);
-
-static struct mhi_driver mhi_net_driver = {
-	.probe = mhi_net_probe,
-	.remove = mhi_net_remove,
-	.dl_xfer_cb = mhi_net_dl_callback,
-	.ul_xfer_cb = mhi_net_ul_callback,
-	.id_table = mhi_net_id_table,
-	.driver = {
-		.name = "mhi_net",
-		.owner = THIS_MODULE,
-	},
-};
-
-module_mhi_driver(mhi_net_driver);
-
-MODULE_AUTHOR("Loic Poulain <loic.poulain@linaro.org>");
-MODULE_DESCRIPTION("Network over MHI");
-MODULE_LICENSE("GPL v2");
-- 
2.7.4

