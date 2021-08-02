Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E64DC3DD15E
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 09:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232435AbhHBHlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 03:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232657AbhHBHlA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 03:41:00 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0448BC06179B
        for <netdev@vger.kernel.org>; Mon,  2 Aug 2021 00:40:50 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id e25-20020a05600c4b99b0290253418ba0fbso10412401wmp.1
        for <netdev@vger.kernel.org>; Mon, 02 Aug 2021 00:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hUOsCz0pSdGsRzhNSHUwzNKr556uN1YzmgXzUOnAQok=;
        b=dhmeD43TvY4a53XXPvhU4OqQK7QNLXdg3fXGL+/3RqeVl5LwV/lUwNdycUywzYqoIz
         Et0O0w1VE3h8hH0r5jwC705ryzUOnQxN2PxsuSzWkRe4Q8rBwPMxH9WObC/TD8kAvMFw
         s+RjYbn18PJ6VbofN5IuKa7WmjYybvBKDAfsoWUSVPsWqmf6TPSQbXYu5pgsesv2UVDE
         p+5UbhrwP4PDTShdCJCJmE05LEmA3kB226Wyd6qtroBzSoCoS2Wn3Voq3Amyxjgan/hE
         o0drczkdurWc/8a2Sx4Zw80WaVXO+86snxJ1bfwjIDsYNjSRHj1JALmgJDkYgJryPgQ1
         nPVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hUOsCz0pSdGsRzhNSHUwzNKr556uN1YzmgXzUOnAQok=;
        b=JaDqB0383kokwRrUJ8ScUsPqBHV0oO/qAIqFHvXiUV66Kv38XyY7hm5ufL4gK1xmzL
         z3KZv+C/UaptOjdrms1erPHMIrNvQ92RpxP76ZBXXvPXXT0ieU6bADnnp2oe++JOpYNk
         DgUKg8/3Q9rOuPGdzBF7w0VCRov6CSvVni4jReIbq5spiKd2iABl/8TU9hBtJ2hKyvnB
         DmjiOyLBl38vq6Wl/MsGIKwbLhH5ozz9dipW1823HROqLNJv6FK8DFwHGdCH5ZHKNNB9
         Lt+oOrlzrAsq2C5yFKurkVUg4kRFu1/4yKXr+XPUfbMaRyq4TodIJOedfU2m5cPqjOEX
         UWZw==
X-Gm-Message-State: AOAM532n9LMoubLfJHiBmgMX3NdHZkEBElnvw2fY4+eYOKD3YkmipVTB
        Op9Db0XZUQesbNWqNem+Ejc3QRjhJDnvBKQb
X-Google-Smtp-Source: ABdhPJycTzskjQCBikoJaADxSRREvf4cfJt3u2QKv+fj1EGfsCcmB0M3rpTxuLZ66KVyMZOSeHULlQ==
X-Received: by 2002:a05:600c:3509:: with SMTP id h9mr14970080wmq.81.1627890047879;
        Mon, 02 Aug 2021 00:40:47 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:69b5:b274:5cfc:ef2])
        by smtp.gmail.com with ESMTPSA id c190sm1616216wma.21.2021.08.02.00.40.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Aug 2021 00:40:47 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
Cc:     netdev@vger.kernel.org, johannes@sipsolutions.net,
        richard.laing@alliedtelesis.co.nz,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next RESEND 2/2] net: mhi: Remove MBIM protocol
Date:   Mon,  2 Aug 2021 09:51:03 +0200
Message-Id: <1627890663-5851-3-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1627890663-5851-1-git-send-email-loic.poulain@linaro.org>
References: <1627890663-5851-1-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=davem@davemloft.net kuba@kernel.org ryazanov.s.a@gmail.com
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MBIM protocol has now been integrated in a proper WWAN driver. We
can then revert back to a simpler driver for mhi_net, which is used
for raw IP or QMAP protocol (via rmnet link).

- Remove protocol management
- Remove WWAN framework usage (only valid for mbim)
- Remove net/mhi directory for a simpler mhi_net.c file

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/net/Kconfig          |   4 +-
 drivers/net/Makefile         |   2 +-
 drivers/net/mhi/Makefile     |   3 -
 drivers/net/mhi/mhi.h        |  41 ----
 drivers/net/mhi/net.c        | 487 -------------------------------------------
 drivers/net/mhi/proto_mbim.c | 310 ---------------------------
 drivers/net/mhi_net.c        | 418 +++++++++++++++++++++++++++++++++++++
 7 files changed, 421 insertions(+), 844 deletions(-)
 delete mode 100644 drivers/net/mhi/Makefile
 delete mode 100644 drivers/net/mhi/mhi.h
 delete mode 100644 drivers/net/mhi/net.c
 delete mode 100644 drivers/net/mhi/proto_mbim.c
 create mode 100644 drivers/net/mhi_net.c

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 6977f82..12b1a3c 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -431,10 +431,10 @@ config VSOCKMON
 config MHI_NET
 	tristate "MHI network driver"
 	depends on MHI_BUS
-	select WWAN
 	help
 	  This is the network driver for MHI bus.  It can be used with
-	  QCOM based WWAN modems (like SDX55).  Say Y or M.
+	  QCOM based WWAN modems for IP or QMAP/rmnet protocol (like SDX55).
+	  Say Y or M.
 
 endif # NET_CORE
 
diff --git a/drivers/net/Makefile b/drivers/net/Makefile
index 7ffd2d0..bfbe2a7 100644
--- a/drivers/net/Makefile
+++ b/drivers/net/Makefile
@@ -36,7 +36,7 @@ obj-$(CONFIG_GTP) += gtp.o
 obj-$(CONFIG_NLMON) += nlmon.o
 obj-$(CONFIG_NET_VRF) += vrf.o
 obj-$(CONFIG_VSOCKMON) += vsockmon.o
-obj-$(CONFIG_MHI_NET) += mhi/
+obj-$(CONFIG_MHI_NET) += mhi_net.o
 
 #
 # Networking Drivers
diff --git a/drivers/net/mhi/Makefile b/drivers/net/mhi/Makefile
deleted file mode 100644
index f71b9f8..0000000
--- a/drivers/net/mhi/Makefile
+++ /dev/null
@@ -1,3 +0,0 @@
-obj-$(CONFIG_MHI_NET) += mhi_net.o
-
-mhi_net-y := net.o proto_mbim.o
diff --git a/drivers/net/mhi/mhi.h b/drivers/net/mhi/mhi.h
deleted file mode 100644
index 1d0c499..0000000
--- a/drivers/net/mhi/mhi.h
+++ /dev/null
@@ -1,41 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-or-later */
-/* MHI Network driver - Network over MHI bus
- *
- * Copyright (C) 2021 Linaro Ltd <loic.poulain@linaro.org>
- */
-
-struct mhi_net_stats {
-	u64_stats_t rx_packets;
-	u64_stats_t rx_bytes;
-	u64_stats_t rx_errors;
-	u64_stats_t rx_dropped;
-	u64_stats_t rx_length_errors;
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
-	int msg_enable;
-	unsigned int mru;
-};
-
-struct mhi_net_proto {
-	int (*init)(struct mhi_net_dev *mhi_netdev);
-	struct sk_buff * (*tx_fixup)(struct mhi_net_dev *mhi_netdev, struct sk_buff *skb);
-	void (*rx)(struct mhi_net_dev *mhi_netdev, struct sk_buff *skb);
-};
-
-extern const struct mhi_net_proto proto_mbim;
diff --git a/drivers/net/mhi/net.c b/drivers/net/mhi/net.c
deleted file mode 100644
index 0cc7dcd..0000000
--- a/drivers/net/mhi/net.c
+++ /dev/null
@@ -1,487 +0,0 @@
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
-#include <linux/wwan.h>
-
-#include "mhi.h"
-
-#define MHI_NET_MIN_MTU		ETH_MIN_MTU
-#define MHI_NET_MAX_MTU		0xffff
-#define MHI_NET_DEFAULT_MTU	0x4000
-
-/* When set to false, the default netdev (link 0) is not created, and it's up
- * to user to create the link (via wwan rtnetlink).
- */
-static bool create_default_iface = true;
-module_param(create_default_iface, bool, 0);
-
-struct mhi_device_info {
-	const char *netname;
-	const struct mhi_net_proto *proto;
-};
-
-static int mhi_ndo_open(struct net_device *ndev)
-{
-	struct mhi_net_dev *mhi_netdev = wwan_netdev_drvpriv(ndev);
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
-	struct mhi_net_dev *mhi_netdev = wwan_netdev_drvpriv(ndev);
-
-	netif_stop_queue(ndev);
-	netif_carrier_off(ndev);
-	cancel_delayed_work_sync(&mhi_netdev->rx_refill);
-
-	return 0;
-}
-
-static netdev_tx_t mhi_ndo_xmit(struct sk_buff *skb, struct net_device *ndev)
-{
-	struct mhi_net_dev *mhi_netdev = wwan_netdev_drvpriv(ndev);
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
-	struct mhi_net_dev *mhi_netdev = wwan_netdev_drvpriv(ndev);
-	unsigned int start;
-
-	do {
-		start = u64_stats_fetch_begin_irq(&mhi_netdev->stats.rx_syncp);
-		stats->rx_packets = u64_stats_read(&mhi_netdev->stats.rx_packets);
-		stats->rx_bytes = u64_stats_read(&mhi_netdev->stats.rx_bytes);
-		stats->rx_errors = u64_stats_read(&mhi_netdev->stats.rx_errors);
-		stats->rx_dropped = u64_stats_read(&mhi_netdev->stats.rx_dropped);
-		stats->rx_length_errors = u64_stats_read(&mhi_netdev->stats.rx_length_errors);
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
-		if (proto && proto->rx) {
-			proto->rx(mhi_netdev, skb);
-		} else {
-			u64_stats_update_begin(&mhi_netdev->stats.rx_syncp);
-			u64_stats_inc(&mhi_netdev->stats.rx_packets);
-			u64_stats_add(&mhi_netdev->stats.rx_bytes, skb->len);
-			u64_stats_update_end(&mhi_netdev->stats.rx_syncp);
-			netif_rx(skb);
-		}
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
-	struct sk_buff *skb;
-	unsigned int size;
-	int err;
-
-	size = mhi_netdev->mru ? mhi_netdev->mru : READ_ONCE(ndev->mtu);
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
-static int mhi_net_newlink(void *ctxt, struct net_device *ndev, u32 if_id,
-			   struct netlink_ext_ack *extack)
-{
-	const struct mhi_device_info *info;
-	struct mhi_device *mhi_dev = ctxt;
-	struct mhi_net_dev *mhi_netdev;
-	int err;
-
-	info = (struct mhi_device_info *)mhi_dev->id->driver_data;
-
-	/* For now we only support one link (link context 0), driver must be
-	 * reworked to break 1:1 relationship for net MBIM and to forward setup
-	 * call to rmnet(QMAP) otherwise.
-	 */
-	if (if_id != 0)
-		return -EINVAL;
-
-	if (dev_get_drvdata(&mhi_dev->dev))
-		return -EBUSY;
-
-	mhi_netdev = wwan_netdev_drvpriv(ndev);
-
-	dev_set_drvdata(&mhi_dev->dev, mhi_netdev);
-	mhi_netdev->ndev = ndev;
-	mhi_netdev->mdev = mhi_dev;
-	mhi_netdev->skbagg_head = NULL;
-	mhi_netdev->proto = info->proto;
-	mhi_netdev->mru = mhi_dev->mhi_cntrl->mru;
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
-	if (extack)
-		err = register_netdevice(ndev);
-	else
-		err = register_netdev(ndev);
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
-	unregister_netdevice(ndev);
-out_err:
-	free_netdev(ndev);
-	return err;
-}
-
-static void mhi_net_dellink(void *ctxt, struct net_device *ndev,
-			    struct list_head *head)
-{
-	struct mhi_net_dev *mhi_netdev = wwan_netdev_drvpriv(ndev);
-	struct mhi_device *mhi_dev = ctxt;
-
-	if (head)
-		unregister_netdevice_queue(ndev, head);
-	else
-		unregister_netdev(ndev);
-
-	mhi_unprepare_from_transfer(mhi_dev);
-
-	kfree_skb(mhi_netdev->skbagg_head);
-
-	dev_set_drvdata(&mhi_dev->dev, NULL);
-}
-
-static const struct wwan_ops mhi_wwan_ops = {
-	.priv_size = sizeof(struct mhi_net_dev),
-	.setup = mhi_net_setup,
-	.newlink = mhi_net_newlink,
-	.dellink = mhi_net_dellink,
-};
-
-static int mhi_net_probe(struct mhi_device *mhi_dev,
-			 const struct mhi_device_id *id)
-{
-	const struct mhi_device_info *info = (struct mhi_device_info *)id->driver_data;
-	struct mhi_controller *cntrl = mhi_dev->mhi_cntrl;
-	struct net_device *ndev;
-	int err;
-
-	err = wwan_register_ops(&cntrl->mhi_dev->dev, &mhi_wwan_ops, mhi_dev,
-				WWAN_NO_DEFAULT_LINK);
-	if (err)
-		return err;
-
-	if (!create_default_iface)
-		return 0;
-
-	/* Create a default interface which is used as either RMNET real-dev,
-	 * MBIM link 0 or ip link 0)
-	 */
-	ndev = alloc_netdev(sizeof(struct mhi_net_dev), info->netname,
-			    NET_NAME_PREDICTABLE, mhi_net_setup);
-	if (!ndev) {
-		err = -ENOMEM;
-		goto err_unregister;
-	}
-
-	SET_NETDEV_DEV(ndev, &mhi_dev->dev);
-
-	err = mhi_net_newlink(mhi_dev, ndev, 0, NULL);
-	if (err)
-		goto err_release;
-
-	return 0;
-
-err_release:
-	free_netdev(ndev);
-err_unregister:
-	wwan_unregister_ops(&cntrl->mhi_dev->dev);
-
-	return err;
-}
-
-static void mhi_net_remove(struct mhi_device *mhi_dev)
-{
-	struct mhi_net_dev *mhi_netdev = dev_get_drvdata(&mhi_dev->dev);
-	struct mhi_controller *cntrl = mhi_dev->mhi_cntrl;
-
-	/* WWAN core takes care of removing remaining links */
-	wwan_unregister_ops(&cntrl->mhi_dev->dev);
-
-	if (create_default_iface)
-		mhi_net_dellink(mhi_dev, mhi_netdev->ndev, NULL);
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
-static const struct mhi_device_info mhi_hwip0_mbim = {
-	.netname = "mhi_mbim%d",
-	.proto = &proto_mbim,
-};
-
-static const struct mhi_device_id mhi_net_id_table[] = {
-	/* Hardware accelerated data PATH (to modem IPA), protocol agnostic */
-	{ .chan = "IP_HW0", .driver_data = (kernel_ulong_t)&mhi_hwip0 },
-	/* Software data PATH (to modem CPU) */
-	{ .chan = "IP_SW0", .driver_data = (kernel_ulong_t)&mhi_swip0 },
-	/* Hardware accelerated data PATH (to modem IPA), MBIM protocol */
-	{ .chan = "IP_HW0_MBIM", .driver_data = (kernel_ulong_t)&mhi_hwip0_mbim },
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
diff --git a/drivers/net/mhi/proto_mbim.c b/drivers/net/mhi/proto_mbim.c
deleted file mode 100644
index 761d90b..0000000
--- a/drivers/net/mhi/proto_mbim.c
+++ /dev/null
@@ -1,310 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/* MHI Network driver - Network over MHI bus
- *
- * Copyright (C) 2021 Linaro Ltd <loic.poulain@linaro.org>
- *
- * This driver copy some code from cdc_ncm, which is:
- * Copyright (C) ST-Ericsson 2010-2012
- * and cdc_mbim, which is:
- * Copyright (c) 2012  Smith Micro Software, Inc.
- * Copyright (c) 2012  Bjørn Mork <bjorn@mork.no>
- *
- */
-
-#include <linux/ethtool.h>
-#include <linux/if_vlan.h>
-#include <linux/ip.h>
-#include <linux/mii.h>
-#include <linux/netdevice.h>
-#include <linux/wwan.h>
-#include <linux/skbuff.h>
-#include <linux/usb.h>
-#include <linux/usb/cdc.h>
-#include <linux/usb/usbnet.h>
-#include <linux/usb/cdc_ncm.h>
-
-#include "mhi.h"
-
-#define MBIM_NDP16_SIGN_MASK 0x00ffffff
-
-/* Usual WWAN MTU */
-#define MHI_MBIM_DEFAULT_MTU 1500
-
-/* 3500 allows to optimize skb allocation, the skbs will basically fit in
- * one 4K page. Large MBIM packets will simply be split over several MHI
- * transfers and chained by the MHI net layer (zerocopy).
- */
-#define MHI_MBIM_DEFAULT_MRU 3500
-
-struct mbim_context {
-	u16 rx_seq;
-	u16 tx_seq;
-};
-
-static void __mbim_length_errors_inc(struct mhi_net_dev *dev)
-{
-	u64_stats_update_begin(&dev->stats.rx_syncp);
-	u64_stats_inc(&dev->stats.rx_length_errors);
-	u64_stats_update_end(&dev->stats.rx_syncp);
-}
-
-static void __mbim_errors_inc(struct mhi_net_dev *dev)
-{
-	u64_stats_update_begin(&dev->stats.rx_syncp);
-	u64_stats_inc(&dev->stats.rx_errors);
-	u64_stats_update_end(&dev->stats.rx_syncp);
-}
-
-static int mbim_rx_verify_nth16(struct sk_buff *skb)
-{
-	struct mhi_net_dev *dev = wwan_netdev_drvpriv(skb->dev);
-	struct mbim_context *ctx = dev->proto_data;
-	struct usb_cdc_ncm_nth16 *nth16;
-	int len;
-
-	if (skb->len < sizeof(struct usb_cdc_ncm_nth16) +
-			sizeof(struct usb_cdc_ncm_ndp16)) {
-		netif_dbg(dev, rx_err, dev->ndev, "frame too short\n");
-		__mbim_length_errors_inc(dev);
-		return -EINVAL;
-	}
-
-	nth16 = (struct usb_cdc_ncm_nth16 *)skb->data;
-
-	if (nth16->dwSignature != cpu_to_le32(USB_CDC_NCM_NTH16_SIGN)) {
-		netif_dbg(dev, rx_err, dev->ndev,
-			  "invalid NTH16 signature <%#010x>\n",
-			  le32_to_cpu(nth16->dwSignature));
-		__mbim_errors_inc(dev);
-		return -EINVAL;
-	}
-
-	/* No limit on the block length, except the size of the data pkt */
-	len = le16_to_cpu(nth16->wBlockLength);
-	if (len > skb->len) {
-		netif_dbg(dev, rx_err, dev->ndev,
-			  "NTB does not fit into the skb %u/%u\n", len,
-			  skb->len);
-		__mbim_length_errors_inc(dev);
-		return -EINVAL;
-	}
-
-	if (ctx->rx_seq + 1 != le16_to_cpu(nth16->wSequence) &&
-	    (ctx->rx_seq || le16_to_cpu(nth16->wSequence)) &&
-	    !(ctx->rx_seq == 0xffff && !le16_to_cpu(nth16->wSequence))) {
-		netif_dbg(dev, rx_err, dev->ndev,
-			  "sequence number glitch prev=%d curr=%d\n",
-			  ctx->rx_seq, le16_to_cpu(nth16->wSequence));
-	}
-	ctx->rx_seq = le16_to_cpu(nth16->wSequence);
-
-	return le16_to_cpu(nth16->wNdpIndex);
-}
-
-static int mbim_rx_verify_ndp16(struct sk_buff *skb, struct usb_cdc_ncm_ndp16 *ndp16)
-{
-	struct mhi_net_dev *dev = wwan_netdev_drvpriv(skb->dev);
-	int ret;
-
-	if (le16_to_cpu(ndp16->wLength) < USB_CDC_NCM_NDP16_LENGTH_MIN) {
-		netif_dbg(dev, rx_err, dev->ndev, "invalid DPT16 length <%u>\n",
-			  le16_to_cpu(ndp16->wLength));
-		return -EINVAL;
-	}
-
-	ret = ((le16_to_cpu(ndp16->wLength) - sizeof(struct usb_cdc_ncm_ndp16))
-			/ sizeof(struct usb_cdc_ncm_dpe16));
-	ret--; /* Last entry is always a NULL terminator */
-
-	if (sizeof(struct usb_cdc_ncm_ndp16) +
-	     ret * sizeof(struct usb_cdc_ncm_dpe16) > skb->len) {
-		netif_dbg(dev, rx_err, dev->ndev,
-			  "Invalid nframes = %d\n", ret);
-		return -EINVAL;
-	}
-
-	return ret;
-}
-
-static void mbim_rx(struct mhi_net_dev *mhi_netdev, struct sk_buff *skb)
-{
-	struct net_device *ndev = mhi_netdev->ndev;
-	int ndpoffset;
-
-	/* Check NTB header and retrieve first NDP offset */
-	ndpoffset = mbim_rx_verify_nth16(skb);
-	if (ndpoffset < 0) {
-		net_err_ratelimited("%s: Incorrect NTB header\n", ndev->name);
-		goto error;
-	}
-
-	/* Process each NDP */
-	while (1) {
-		struct usb_cdc_ncm_ndp16 ndp16;
-		struct usb_cdc_ncm_dpe16 dpe16;
-		int nframes, n, dpeoffset;
-
-		if (skb_copy_bits(skb, ndpoffset, &ndp16, sizeof(ndp16))) {
-			net_err_ratelimited("%s: Incorrect NDP offset (%u)\n",
-					    ndev->name, ndpoffset);
-			__mbim_length_errors_inc(mhi_netdev);
-			goto error;
-		}
-
-		/* Check NDP header and retrieve number of datagrams */
-		nframes = mbim_rx_verify_ndp16(skb, &ndp16);
-		if (nframes < 0) {
-			net_err_ratelimited("%s: Incorrect NDP16\n", ndev->name);
-			__mbim_length_errors_inc(mhi_netdev);
-			goto error;
-		}
-
-		 /* Only IP data type supported, no DSS in MHI context */
-		if ((ndp16.dwSignature & cpu_to_le32(MBIM_NDP16_SIGN_MASK))
-				!= cpu_to_le32(USB_CDC_MBIM_NDP16_IPS_SIGN)) {
-			net_err_ratelimited("%s: Unsupported NDP type\n", ndev->name);
-			__mbim_errors_inc(mhi_netdev);
-			goto next_ndp;
-		}
-
-		/* Only primary IP session 0 (0x00) supported for now */
-		if (ndp16.dwSignature & ~cpu_to_le32(MBIM_NDP16_SIGN_MASK)) {
-			net_err_ratelimited("%s: bad packet session\n", ndev->name);
-			__mbim_errors_inc(mhi_netdev);
-			goto next_ndp;
-		}
-
-		/* de-aggregate and deliver IP packets */
-		dpeoffset = ndpoffset + sizeof(struct usb_cdc_ncm_ndp16);
-		for (n = 0; n < nframes; n++, dpeoffset += sizeof(dpe16)) {
-			u16 dgram_offset, dgram_len;
-			struct sk_buff *skbn;
-
-			if (skb_copy_bits(skb, dpeoffset, &dpe16, sizeof(dpe16)))
-				break;
-
-			dgram_offset = le16_to_cpu(dpe16.wDatagramIndex);
-			dgram_len = le16_to_cpu(dpe16.wDatagramLength);
-
-			if (!dgram_offset || !dgram_len)
-				break; /* null terminator */
-
-			skbn = netdev_alloc_skb(ndev, dgram_len);
-			if (!skbn)
-				continue;
-
-			skb_put(skbn, dgram_len);
-			skb_copy_bits(skb, dgram_offset, skbn->data, dgram_len);
-
-			switch (skbn->data[0] & 0xf0) {
-			case 0x40:
-				skbn->protocol = htons(ETH_P_IP);
-				break;
-			case 0x60:
-				skbn->protocol = htons(ETH_P_IPV6);
-				break;
-			default:
-				net_err_ratelimited("%s: unknown protocol\n",
-						    ndev->name);
-				__mbim_errors_inc(mhi_netdev);
-				dev_kfree_skb_any(skbn);
-				continue;
-			}
-
-			u64_stats_update_begin(&mhi_netdev->stats.rx_syncp);
-			u64_stats_inc(&mhi_netdev->stats.rx_packets);
-			u64_stats_add(&mhi_netdev->stats.rx_bytes, skbn->len);
-			u64_stats_update_end(&mhi_netdev->stats.rx_syncp);
-			netif_rx(skbn);
-		}
-next_ndp:
-		/* Other NDP to process? */
-		ndpoffset = (int)le16_to_cpu(ndp16.wNextNdpIndex);
-		if (!ndpoffset)
-			break;
-	}
-
-	/* free skb */
-	dev_consume_skb_any(skb);
-	return;
-error:
-	dev_kfree_skb_any(skb);
-}
-
-struct mbim_tx_hdr {
-	struct usb_cdc_ncm_nth16 nth16;
-	struct usb_cdc_ncm_ndp16 ndp16;
-	struct usb_cdc_ncm_dpe16 dpe16[2];
-} __packed;
-
-static struct sk_buff *mbim_tx_fixup(struct mhi_net_dev *mhi_netdev,
-				     struct sk_buff *skb)
-{
-	struct mbim_context *ctx = mhi_netdev->proto_data;
-	unsigned int dgram_size = skb->len;
-	struct usb_cdc_ncm_nth16 *nth16;
-	struct usb_cdc_ncm_ndp16 *ndp16;
-	struct mbim_tx_hdr *mbim_hdr;
-
-	/* For now, this is a partial implementation of CDC MBIM, only one NDP
-	 * is sent, containing the IP packet (no aggregation).
-	 */
-
-	/* Ensure we have enough headroom for crafting MBIM header */
-	if (skb_cow_head(skb, sizeof(struct mbim_tx_hdr))) {
-		dev_kfree_skb_any(skb);
-		return NULL;
-	}
-
-	mbim_hdr = skb_push(skb, sizeof(struct mbim_tx_hdr));
-
-	/* Fill NTB header */
-	nth16 = &mbim_hdr->nth16;
-	nth16->dwSignature = cpu_to_le32(USB_CDC_NCM_NTH16_SIGN);
-	nth16->wHeaderLength = cpu_to_le16(sizeof(struct usb_cdc_ncm_nth16));
-	nth16->wSequence = cpu_to_le16(ctx->tx_seq++);
-	nth16->wBlockLength = cpu_to_le16(skb->len);
-	nth16->wNdpIndex = cpu_to_le16(sizeof(struct usb_cdc_ncm_nth16));
-
-	/* Fill the unique NDP */
-	ndp16 = &mbim_hdr->ndp16;
-	ndp16->dwSignature = cpu_to_le32(USB_CDC_MBIM_NDP16_IPS_SIGN);
-	ndp16->wLength = cpu_to_le16(sizeof(struct usb_cdc_ncm_ndp16)
-					+ sizeof(struct usb_cdc_ncm_dpe16) * 2);
-	ndp16->wNextNdpIndex = 0;
-
-	/* Datagram follows the mbim header */
-	ndp16->dpe16[0].wDatagramIndex = cpu_to_le16(sizeof(struct mbim_tx_hdr));
-	ndp16->dpe16[0].wDatagramLength = cpu_to_le16(dgram_size);
-
-	/* null termination */
-	ndp16->dpe16[1].wDatagramIndex = 0;
-	ndp16->dpe16[1].wDatagramLength = 0;
-
-	return skb;
-}
-
-static int mbim_init(struct mhi_net_dev *mhi_netdev)
-{
-	struct net_device *ndev = mhi_netdev->ndev;
-
-	mhi_netdev->proto_data = devm_kzalloc(&ndev->dev,
-					      sizeof(struct mbim_context),
-					      GFP_KERNEL);
-	if (!mhi_netdev->proto_data)
-		return -ENOMEM;
-
-	ndev->needed_headroom = sizeof(struct mbim_tx_hdr);
-	ndev->mtu = MHI_MBIM_DEFAULT_MTU;
-
-	if (!mhi_netdev->mru)
-		mhi_netdev->mru = MHI_MBIM_DEFAULT_MRU;
-
-	return 0;
-}
-
-const struct mhi_net_proto proto_mbim = {
-	.init = mbim_init,
-	.rx = mbim_rx,
-	.tx_fixup = mbim_tx_fixup,
-};
diff --git a/drivers/net/mhi_net.c b/drivers/net/mhi_net.c
new file mode 100644
index 0000000..fb711b2
--- /dev/null
+++ b/drivers/net/mhi_net.c
@@ -0,0 +1,418 @@
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
+	struct delayed_work rx_refill;
+	struct mhi_net_stats stats;
+	u32 rx_queue_sz;
+	int msg_enable;
+	unsigned int mru;
+};
+
+struct mhi_device_info {
+	const char *netname;
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
+static netdev_tx_t mhi_ndo_xmit(struct sk_buff *skb, struct net_device *ndev)
+{
+	struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
+	struct mhi_device *mdev = mhi_netdev->mdev;
+	int err;
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
+		u64_stats_update_begin(&mhi_netdev->stats.rx_syncp);
+		u64_stats_inc(&mhi_netdev->stats.rx_packets);
+		u64_stats_add(&mhi_netdev->stats.rx_bytes, skb->len);
+		u64_stats_update_end(&mhi_netdev->stats.rx_syncp);
+		netif_rx(skb);
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
+	struct sk_buff *skb;
+	unsigned int size;
+	int err;
+
+	size = mhi_netdev->mru ? mhi_netdev->mru : READ_ONCE(ndev->mtu);
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
+static int mhi_net_newlink(struct mhi_device *mhi_dev, struct net_device *ndev)
+{
+	const struct mhi_device_info *info;
+	struct mhi_net_dev *mhi_netdev;
+	int err;
+
+	info = (struct mhi_device_info *)mhi_dev->id->driver_data;
+	mhi_netdev = netdev_priv(ndev);
+
+	dev_set_drvdata(&mhi_dev->dev, mhi_netdev);
+	mhi_netdev->ndev = ndev;
+	mhi_netdev->mdev = mhi_dev;
+	mhi_netdev->skbagg_head = NULL;
+	mhi_netdev->mru = mhi_dev->mhi_cntrl->mru;
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
+		return err;
+
+	return 0;
+
+out_err:
+	free_netdev(ndev);
+	return err;
+}
+
+static void mhi_net_dellink(struct mhi_device *mhi_dev, struct net_device *ndev)
+{
+	struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
+
+	unregister_netdev(ndev);
+
+	mhi_unprepare_from_transfer(mhi_dev);
+
+	kfree_skb(mhi_netdev->skbagg_head);
+
+	dev_set_drvdata(&mhi_dev->dev, NULL);
+}
+
+static int mhi_net_probe(struct mhi_device *mhi_dev,
+			 const struct mhi_device_id *id)
+{
+	const struct mhi_device_info *info = (struct mhi_device_info *)id->driver_data;
+	struct net_device *ndev;
+	int err;
+
+	ndev = alloc_netdev(sizeof(struct mhi_net_dev), info->netname,
+			    NET_NAME_PREDICTABLE, mhi_net_setup);
+	if (!ndev)
+		return -ENOMEM;
+
+	SET_NETDEV_DEV(ndev, &mhi_dev->dev);
+
+	err = mhi_net_newlink(mhi_dev, ndev);
+	if (err) {
+		free_netdev(ndev);
+		return err;
+	}
+
+	return 0;
+}
+
+static void mhi_net_remove(struct mhi_device *mhi_dev)
+{
+	struct mhi_net_dev *mhi_netdev = dev_get_drvdata(&mhi_dev->dev);
+
+	mhi_net_dellink(mhi_dev, mhi_netdev->ndev);
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
-- 
2.7.4

