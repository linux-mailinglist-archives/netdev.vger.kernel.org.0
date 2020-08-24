Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6A11250282
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 18:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbgHXQcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 12:32:36 -0400
Received: from simonwunderlich.de ([79.140.42.25]:47696 "EHLO
        simonwunderlich.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727901AbgHXQ15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 12:27:57 -0400
Received: from kero.packetmixer.de (p200300c5970d68d0e0160e8a82c5fd76.dip0.t-ipconnect.de [IPv6:2003:c5:970d:68d0:e016:e8a:82c5:fd76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id 717C162074;
        Mon, 24 Aug 2020 18:27:47 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4/5] batman-adv: Drop repeated words in comments
Date:   Mon, 24 Aug 2020 18:27:40 +0200
Message-Id: <20200824162741.880-5-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200824162741.880-1-sw@simonwunderlich.de>
References: <20200824162741.880-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

checkpatch found various instances of "Possible repeated word" in various
comments.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/bridge_loop_avoidance.c | 2 +-
 net/batman-adv/fragmentation.c         | 2 +-
 net/batman-adv/hard-interface.c        | 2 +-
 net/batman-adv/multicast.c             | 2 +-
 net/batman-adv/network-coding.c        | 2 +-
 net/batman-adv/send.c                  | 2 +-
 net/batman-adv/soft-interface.c        | 4 ++--
 7 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/batman-adv/bridge_loop_avoidance.c b/net/batman-adv/bridge_loop_avoidance.c
index 91a04ca373dc..5c41cc52bc53 100644
--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -1795,7 +1795,7 @@ batadv_bla_loopdetect_check(struct batadv_priv *bat_priv, struct sk_buff *skb,
 
 	ret = queue_work(batadv_event_workqueue, &backbone_gw->report_work);
 
-	/* backbone_gw is unreferenced in the report work function function
+	/* backbone_gw is unreferenced in the report work function
 	 * if queue_work() call was successful
 	 */
 	if (!ret)
diff --git a/net/batman-adv/fragmentation.c b/net/batman-adv/fragmentation.c
index 9fdbe3068153..9a47ef8b95c4 100644
--- a/net/batman-adv/fragmentation.c
+++ b/net/batman-adv/fragmentation.c
@@ -306,7 +306,7 @@ batadv_frag_merge_packets(struct hlist_head *chain)
  * set *skb to merged packet; 2) Packet is buffered: Return true and set *skb
  * to NULL; 3) Error: Return false and free skb.
  *
- * Return: true when the packet is merged or buffered, false when skb is not not
+ * Return: true when the packet is merged or buffered, false when skb is not
  * used.
  */
 bool batadv_frag_skb_buffer(struct sk_buff **skb,
diff --git a/net/batman-adv/hard-interface.c b/net/batman-adv/hard-interface.c
index f95be90adaab..dad99641df2a 100644
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -599,7 +599,7 @@ int batadv_hardif_min_mtu(struct net_device *soft_iface)
 	/* report to the other components the maximum amount of bytes that
 	 * batman-adv can send over the wire (without considering the payload
 	 * overhead). For example, this value is used by TT to compute the
-	 * maximum local table table size
+	 * maximum local table size
 	 */
 	atomic_set(&bat_priv->packet_size_max, min_mtu);
 
diff --git a/net/batman-adv/multicast.c b/net/batman-adv/multicast.c
index bdc4a1fba1c6..1622c3f5898f 100644
--- a/net/batman-adv/multicast.c
+++ b/net/batman-adv/multicast.c
@@ -207,7 +207,7 @@ static u8 batadv_mcast_mla_rtr_flags_bridge_get(struct batadv_priv *bat_priv,
 		return BATADV_MCAST_WANT_NO_RTR4 | BATADV_MCAST_WANT_NO_RTR6;
 
 	/* TODO: ask the bridge if a multicast router is present (the bridge
-	 * is capable of performing proper RFC4286 multicast multicast router
+	 * is capable of performing proper RFC4286 multicast router
 	 * discovery) instead of searching for a ff02::2 listener here
 	 */
 	ret = br_multicast_list_adjacent(dev, &bridge_mcast_list);
diff --git a/net/batman-adv/network-coding.c b/net/batman-adv/network-coding.c
index 48d707850f3e..64619b7a3a77 100644
--- a/net/batman-adv/network-coding.c
+++ b/net/batman-adv/network-coding.c
@@ -250,7 +250,7 @@ static void batadv_nc_path_put(struct batadv_nc_path *nc_path)
 /**
  * batadv_nc_packet_free() - frees nc packet
  * @nc_packet: the nc packet to free
- * @dropped: whether the packet is freed because is is dropped
+ * @dropped: whether the packet is freed because is dropped
  */
 static void batadv_nc_packet_free(struct batadv_nc_packet *nc_packet,
 				  bool dropped)
diff --git a/net/batman-adv/send.c b/net/batman-adv/send.c
index d267b94800d6..87017332b567 100644
--- a/net/batman-adv/send.c
+++ b/net/batman-adv/send.c
@@ -461,7 +461,7 @@ int batadv_send_skb_via_gw(struct batadv_priv *bat_priv, struct sk_buff *skb,
 /**
  * batadv_forw_packet_free() - free a forwarding packet
  * @forw_packet: The packet to free
- * @dropped: whether the packet is freed because is is dropped
+ * @dropped: whether the packet is freed because is dropped
  *
  * This frees a forwarding packet and releases any resources it might
  * have claimed.
diff --git a/net/batman-adv/soft-interface.c b/net/batman-adv/soft-interface.c
index 23833a0ba5e6..9d3974ba11ed 100644
--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -649,7 +649,7 @@ static void batadv_softif_destroy_vlan(struct batadv_priv *bat_priv,
 /**
  * batadv_interface_add_vid() - ndo_add_vid API implementation
  * @dev: the netdev of the mesh interface
- * @proto: protocol of the the vlan id
+ * @proto: protocol of the vlan id
  * @vid: identifier of the new vlan
  *
  * Set up all the internal structures for handling the new vlan on top of the
@@ -707,7 +707,7 @@ static int batadv_interface_add_vid(struct net_device *dev, __be16 proto,
 /**
  * batadv_interface_kill_vid() - ndo_kill_vid API implementation
  * @dev: the netdev of the mesh interface
- * @proto: protocol of the the vlan id
+ * @proto: protocol of the vlan id
  * @vid: identifier of the deleted vlan
  *
  * Destroy all the internal structures used to handle the vlan identified by vid
-- 
2.20.1

