Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A89402B40EC
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 11:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728852AbgKPKSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 05:18:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:52850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728779AbgKPKS3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 05:18:29 -0500
Received: from mail.kernel.org (ip5f5ad5de.dynamic.kabel-deutschland.de [95.90.213.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 448F92227F;
        Mon, 16 Nov 2020 10:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605521908;
        bh=zCGfu1AGx+VOpyCVhh06qPgakpKDoNY09BAtIJsgi0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z/CeBuMnmXiZ40zfpKdUb/ngilfDoZGIxwggNa8YLFBmKmYspM04cPIKVy4vSkBmp
         e2XeWpfxL2QCJ7mz6+3CYaLYa4roWPh6LZC1I3Y3JkJrMxfWUiipoP2zfQvy7zRGCp
         s/PPcd8rdaWoI1Qsep17nroKZeL8VnKWD8UOSSwc=
Received: from mchehab by mail.kernel.org with local (Exim 4.94)
        (envelope-from <mchehab@kernel.org>)
        id 1kebab-00FwDu-Tj; Mon, 16 Nov 2020 11:18:25 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        "Jonathan Corbet" <corbet@lwn.net>,
        "Linux Doc Mailing List" <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v4 03/27] net: core: fix some kernel-doc markups
Date:   Mon, 16 Nov 2020 11:17:59 +0100
Message-Id: <0661a2db87c640f66c6e040a2de11638da674194.1605521731.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1605521731.git.mchehab+huawei@kernel.org>
References: <cover.1605521731.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some identifiers have different names between their prototypes
and the kernel-doc markup.

In the specific case of netif_subqueue_stopped(), keep the
current markup for __netif_subqueue_stopped(), adding a
new one for netif_subqueue_stopped().

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 include/linux/netdevice.h | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 7ce648a564f7..03433a4c929e 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1473,41 +1473,41 @@ struct net_device_ops {
 	int			(*ndo_change_proto_down)(struct net_device *dev,
 							 bool proto_down);
 	int			(*ndo_fill_metadata_dst)(struct net_device *dev,
 						       struct sk_buff *skb);
 	void			(*ndo_set_rx_headroom)(struct net_device *dev,
 						       int needed_headroom);
 	int			(*ndo_bpf)(struct net_device *dev,
 					   struct netdev_bpf *bpf);
 	int			(*ndo_xdp_xmit)(struct net_device *dev, int n,
 						struct xdp_frame **xdp,
 						u32 flags);
 	int			(*ndo_xsk_wakeup)(struct net_device *dev,
 						  u32 queue_id, u32 flags);
 	struct devlink_port *	(*ndo_get_devlink_port)(struct net_device *dev);
 	int			(*ndo_tunnel_ctl)(struct net_device *dev,
 						  struct ip_tunnel_parm *p, int cmd);
 	struct net_device *	(*ndo_get_peer_dev)(struct net_device *dev);
 };
 
 /**
- * enum net_device_priv_flags - &struct net_device priv_flags
+ * enum netdev_priv_flags - &struct net_device priv_flags
  *
  * These are the &struct net_device, they are only set internally
  * by drivers and used in the kernel. These flags are invisible to
  * userspace; this means that the order of these flags can change
  * during any kernel release.
  *
  * You should have a pretty good reason to be extending these flags.
  *
  * @IFF_802_1Q_VLAN: 802.1Q VLAN device
  * @IFF_EBRIDGE: Ethernet bridging device
  * @IFF_BONDING: bonding master or slave
  * @IFF_ISATAP: ISATAP interface (RFC4214)
  * @IFF_WAN_HDLC: WAN HDLC device
  * @IFF_XMIT_DST_RELEASE: dev_hard_start_xmit() is allowed to
  *	release skb->dst
  * @IFF_DONT_BRIDGE: disallow bridging this ether dev
  * @IFF_DISABLE_NETPOLL: disable netpoll at run-time
  * @IFF_MACVLAN_PORT: device used as macvlan port
  * @IFF_BRIDGE_PORT: device used as bridge port
  * @IFF_OVS_DATAPATH: device used as Open vSwitch datapath port
@@ -3585,54 +3585,61 @@ static inline void netif_start_subqueue(struct net_device *dev, u16 queue_index)
 {
 	struct netdev_queue *txq = netdev_get_tx_queue(dev, queue_index);
 
 	netif_tx_start_queue(txq);
 }
 
 /**
  *	netif_stop_subqueue - stop sending packets on subqueue
  *	@dev: network device
  *	@queue_index: sub queue index
  *
  * Stop individual transmit queue of a device with multiple transmit queues.
  */
 static inline void netif_stop_subqueue(struct net_device *dev, u16 queue_index)
 {
 	struct netdev_queue *txq = netdev_get_tx_queue(dev, queue_index);
 	netif_tx_stop_queue(txq);
 }
 
 /**
- *	netif_subqueue_stopped - test status of subqueue
+ *	__netif_subqueue_stopped - test status of subqueue
  *	@dev: network device
  *	@queue_index: sub queue index
  *
  * Check individual transmit queue of a device with multiple transmit queues.
  */
 static inline bool __netif_subqueue_stopped(const struct net_device *dev,
 					    u16 queue_index)
 {
 	struct netdev_queue *txq = netdev_get_tx_queue(dev, queue_index);
 
 	return netif_tx_queue_stopped(txq);
 }
 
+/**
+ *	netif_subqueue_stopped - test status of subqueue
+ *	@dev: network device
+ *	@skb: sub queue buffer pointer
+ *
+ * Check individual transmit queue of a device with multiple transmit queues.
+ */
 static inline bool netif_subqueue_stopped(const struct net_device *dev,
 					  struct sk_buff *skb)
 {
 	return __netif_subqueue_stopped(dev, skb_get_queue_mapping(skb));
 }
 
 /**
  *	netif_wake_subqueue - allow sending packets on subqueue
  *	@dev: network device
  *	@queue_index: sub queue index
  *
  * Resume individual transmit queue of a device with multiple transmit queues.
  */
 static inline void netif_wake_subqueue(struct net_device *dev, u16 queue_index)
 {
 	struct netdev_queue *txq = netdev_get_tx_queue(dev, queue_index);
 
 	netif_tx_wake_queue(txq);
 }
 
-- 
2.28.0

