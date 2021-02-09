Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5D4314B12
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 10:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbhBIJA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 04:00:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbhBII6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 03:58:46 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE49C06178B
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 00:58:00 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id g10so20682987wrx.1
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 00:58:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cf0LfcfRp3bcgJncg1NSTu2ZamMvFp0Ok+t82TG7INQ=;
        b=wkXWJVHk1a1ASiHT4GG8k4wYKwOHUIGnYRfUub15qz2cmdZVk7ES4MQ9sdw9PZ5+mJ
         TyM/atkZ20KuKdRrHHW2GfiuG8trvCAmf12efEeIuH8oBkNbKuDuKLDW6AliFdZ+npMy
         VK1qxsFbe1l5RxVrFCq5Gt3fM5Zdsfsan1XjuciWd9CHZSdmrZ8rwxqkj3QHvxpUkUSw
         AtvgsNe9fsvLpKFDGhL5W5/4rbgTvFQANmUNqM70yigUPHjYwmkUi+goPScJmKSHt1Do
         T9wce+KnxbOsvnSwXs/RPrD3AMfyjY+0eStzYt9YDoRNT9sxxfekIKwIMJuBvhZ7HyiF
         PQeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cf0LfcfRp3bcgJncg1NSTu2ZamMvFp0Ok+t82TG7INQ=;
        b=ZDC85ewLU3BW5FSEX3J2OuIOoyq6nr3sI70IWmhcYN56oEmSqBF9pUpkblZ8t/5aTV
         JdzNrwDGKyba8g/HRlvAT6zoaJip11FmB5a2/Q1Ch2vTbQpZwn7XQxYDa8fUNxRb0HQ4
         RzJVMv2lRPmPTp0S22weLK0/edM3go6+Jnx7dsTHiAmv5bUj+CqPZMV/dpqeyefilx5S
         9KNvEBYQCBLJN1MPZvcCkVPPjQd4eH6N4NF/ja/y6IKUeSl9Qows8QOtcIA4pkTz310I
         XXvZIBKxJQGhMZQ4E9j1fWpRkkm5DZ+Ca8J480JPb9pOX5n5IvaakVPwZL3yu0UfvU6W
         s8EQ==
X-Gm-Message-State: AOAM53031zKL0PhTBGY0In/PXgho2LIwSHA6PdurtLycYBLUQDAXgvHj
        oUvBPbJ2MPQeHy05F+Vp+QseiMJk1hB2TCM2
X-Google-Smtp-Source: ABdhPJz/cR1XKN/oGV+Wyv2w7fZ68IW+CJtdhAw6PBx6Sc7aF368l2n949hZYH9EbyDD6D+dHnBstw==
X-Received: by 2002:a5d:4f84:: with SMTP id d4mr23940308wru.374.1612861077973;
        Tue, 09 Feb 2021 00:57:57 -0800 (PST)
Received: from localhost.localdomain ([88.122.66.28])
        by smtp.gmail.com with ESMTPSA id d3sm38348693wrp.79.2021.02.09.00.57.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Feb 2021 00:57:57 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, bjorn@mork.no, dcbw@redhat.com,
        carl.yin@quectel.com, mpearson@lenovo.com, cchen50@lenovo.com,
        jwjiang@lenovo.com, ivan.zhang@quectel.com,
        naveen.kumar@quectel.com, ivan.mikhanchuk@quectel.com,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next v5 2/5] net: mhi: Add dedicated folder
Date:   Tue,  9 Feb 2021 10:05:55 +0100
Message-Id: <1612861558-14487-3-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612861558-14487-1-git-send-email-loic.poulain@linaro.org>
References: <1612861558-14487-1-git-send-email-loic.poulain@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a dedicated mhi directory for mhi-net, mhi-net is going to
be split into differente files (for additional protocol support).

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/net/Makefile     |   2 +-
 drivers/net/mhi/Makefile |   3 +
 drivers/net/mhi/net.c    | 429 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/mhi_net.c    | 429 -----------------------------------------------
 4 files changed, 433 insertions(+), 430 deletions(-)
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
index 0000000..b92c2e1
--- /dev/null
+++ b/drivers/net/mhi/net.c
@@ -0,0 +1,429 @@
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
+		skb = proto->tx_fixup(mhi_netdev, skb);
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
+static struct sk_buff *mhi_net_skb_agg(struct mhi_net_dev *mhi_netdev,
+				       struct sk_buff *skb)
+{
+	struct sk_buff *head = mhi_netdev->skbagg_head;
+	struct sk_buff *tail = mhi_netdev->skbagg_tail;
+
+	/* This is non-paged skb chaining using frag_list */
+	if (!head) {
+		mhi_netdev->skbagg_head = skb;
+		return skb;
+	}
+
+	if (!skb_shinfo(head)->frag_list)
+		skb_shinfo(head)->frag_list = skb;
+	else
+		tail->next = skb;
+
+	head->len += skb->len;
+	head->data_len += skb->len;
+	head->truesize += skb->truesize;
+
+	mhi_netdev->skbagg_tail = skb;
+
+	return mhi_netdev->skbagg_head;
+}
+
+static void mhi_net_dl_callback(struct mhi_device *mhi_dev,
+				struct mhi_result *mhi_res)
+{
+	struct mhi_net_dev *mhi_netdev = dev_get_drvdata(&mhi_dev->dev);
+	const struct mhi_net_proto *proto = mhi_netdev->proto;
+	struct sk_buff *skb = mhi_res->buf_addr;
+	int free_desc_count;
+
+	free_desc_count = mhi_get_free_desc_count(mhi_dev, DMA_FROM_DEVICE);
+
+	if (unlikely(mhi_res->transaction_status)) {
+		switch (mhi_res->transaction_status) {
+		case -EOVERFLOW:
+			/* Packet can not fit in one MHI buffer and has been
+			 * split over multiple MHI transfers, do re-aggregation.
+			 * That usually means the device side MTU is larger than
+			 * the host side MTU/MRU. Since this is not optimal,
+			 * print a warning (once).
+			 */
+			netdev_warn_once(mhi_netdev->ndev,
+					 "Fragmented packets received, fix MTU?\n");
+			skb_put(skb, mhi_res->bytes_xferd);
+			mhi_net_skb_agg(mhi_netdev, skb);
+			break;
+		case -ENOTCONN:
+			/* MHI layer stopping/resetting the DL channel */
+			dev_kfree_skb_any(skb);
+			return;
+		default:
+			/* Unknown error, simply drop */
+			dev_kfree_skb_any(skb);
+			u64_stats_update_begin(&mhi_netdev->stats.rx_syncp);
+			u64_stats_inc(&mhi_netdev->stats.rx_errors);
+			u64_stats_update_end(&mhi_netdev->stats.rx_syncp);
+		}
+	} else {
+		skb_put(skb, mhi_res->bytes_xferd);
+
+		if (mhi_netdev->skbagg_head) {
+			/* Aggregate the final fragment */
+			skb = mhi_net_skb_agg(mhi_netdev, skb);
+			mhi_netdev->skbagg_head = NULL;
+		}
+
+		u64_stats_update_begin(&mhi_netdev->stats.rx_syncp);
+		u64_stats_inc(&mhi_netdev->stats.rx_packets);
+		u64_stats_add(&mhi_netdev->stats.rx_bytes, skb->len);
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
+		if (proto && proto->rx)
+			proto->rx(mhi_netdev, skb);
+		else
+			netif_rx(skb);
+	}
+
+	/* Refill if RX buffers queue becomes low */
+	if (free_desc_count >= mhi_netdev->rx_queue_sz / 2)
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
+	while (!mhi_queue_is_full(mdev, DMA_FROM_DEVICE)) {
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
+		/* Do not hog the CPU if rx buffers are consumed faster than
+		 * queued (unlikely).
+		 */
+		cond_resched();
+	}
+
+	/* If we're still starved of rx buffers, reschedule later */
+	if (mhi_get_free_desc_count(mdev, DMA_FROM_DEVICE) == mhi_netdev->rx_queue_sz)
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
+	mhi_netdev->skbagg_head = NULL;
+	mhi_netdev->proto = info->proto;
+	SET_NETDEV_DEV(ndev, &mhi_dev->dev);
+	SET_NETDEV_DEVTYPE(ndev, &wwan_type);
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
+	/* Number of transfer descriptors determines size of the queue */
+	mhi_netdev->rx_queue_sz = mhi_get_free_desc_count(mhi_dev, DMA_FROM_DEVICE);
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
+	if (mhi_netdev->skbagg_head)
+		kfree_skb(mhi_netdev->skbagg_head);
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
index b92c2e1..0000000
--- a/drivers/net/mhi_net.c
+++ /dev/null
@@ -1,429 +0,0 @@
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
-		skb = proto->tx_fixup(mhi_netdev, skb);
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
-static struct sk_buff *mhi_net_skb_agg(struct mhi_net_dev *mhi_netdev,
-				       struct sk_buff *skb)
-{
-	struct sk_buff *head = mhi_netdev->skbagg_head;
-	struct sk_buff *tail = mhi_netdev->skbagg_tail;
-
-	/* This is non-paged skb chaining using frag_list */
-	if (!head) {
-		mhi_netdev->skbagg_head = skb;
-		return skb;
-	}
-
-	if (!skb_shinfo(head)->frag_list)
-		skb_shinfo(head)->frag_list = skb;
-	else
-		tail->next = skb;
-
-	head->len += skb->len;
-	head->data_len += skb->len;
-	head->truesize += skb->truesize;
-
-	mhi_netdev->skbagg_tail = skb;
-
-	return mhi_netdev->skbagg_head;
-}
-
-static void mhi_net_dl_callback(struct mhi_device *mhi_dev,
-				struct mhi_result *mhi_res)
-{
-	struct mhi_net_dev *mhi_netdev = dev_get_drvdata(&mhi_dev->dev);
-	const struct mhi_net_proto *proto = mhi_netdev->proto;
-	struct sk_buff *skb = mhi_res->buf_addr;
-	int free_desc_count;
-
-	free_desc_count = mhi_get_free_desc_count(mhi_dev, DMA_FROM_DEVICE);
-
-	if (unlikely(mhi_res->transaction_status)) {
-		switch (mhi_res->transaction_status) {
-		case -EOVERFLOW:
-			/* Packet can not fit in one MHI buffer and has been
-			 * split over multiple MHI transfers, do re-aggregation.
-			 * That usually means the device side MTU is larger than
-			 * the host side MTU/MRU. Since this is not optimal,
-			 * print a warning (once).
-			 */
-			netdev_warn_once(mhi_netdev->ndev,
-					 "Fragmented packets received, fix MTU?\n");
-			skb_put(skb, mhi_res->bytes_xferd);
-			mhi_net_skb_agg(mhi_netdev, skb);
-			break;
-		case -ENOTCONN:
-			/* MHI layer stopping/resetting the DL channel */
-			dev_kfree_skb_any(skb);
-			return;
-		default:
-			/* Unknown error, simply drop */
-			dev_kfree_skb_any(skb);
-			u64_stats_update_begin(&mhi_netdev->stats.rx_syncp);
-			u64_stats_inc(&mhi_netdev->stats.rx_errors);
-			u64_stats_update_end(&mhi_netdev->stats.rx_syncp);
-		}
-	} else {
-		skb_put(skb, mhi_res->bytes_xferd);
-
-		if (mhi_netdev->skbagg_head) {
-			/* Aggregate the final fragment */
-			skb = mhi_net_skb_agg(mhi_netdev, skb);
-			mhi_netdev->skbagg_head = NULL;
-		}
-
-		u64_stats_update_begin(&mhi_netdev->stats.rx_syncp);
-		u64_stats_inc(&mhi_netdev->stats.rx_packets);
-		u64_stats_add(&mhi_netdev->stats.rx_bytes, skb->len);
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
-		if (proto && proto->rx)
-			proto->rx(mhi_netdev, skb);
-		else
-			netif_rx(skb);
-	}
-
-	/* Refill if RX buffers queue becomes low */
-	if (free_desc_count >= mhi_netdev->rx_queue_sz / 2)
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
-	while (!mhi_queue_is_full(mdev, DMA_FROM_DEVICE)) {
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
-		/* Do not hog the CPU if rx buffers are consumed faster than
-		 * queued (unlikely).
-		 */
-		cond_resched();
-	}
-
-	/* If we're still starved of rx buffers, reschedule later */
-	if (mhi_get_free_desc_count(mdev, DMA_FROM_DEVICE) == mhi_netdev->rx_queue_sz)
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
-	mhi_netdev->skbagg_head = NULL;
-	mhi_netdev->proto = info->proto;
-	SET_NETDEV_DEV(ndev, &mhi_dev->dev);
-	SET_NETDEV_DEVTYPE(ndev, &wwan_type);
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
-	/* Number of transfer descriptors determines size of the queue */
-	mhi_netdev->rx_queue_sz = mhi_get_free_desc_count(mhi_dev, DMA_FROM_DEVICE);
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
-	if (mhi_netdev->skbagg_head)
-		kfree_skb(mhi_netdev->skbagg_head);
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

