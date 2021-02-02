Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4DF30C885
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 18:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237989AbhBBRwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 12:52:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237872AbhBBRu5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 12:50:57 -0500
Received: from simonwunderlich.de (packetmixer.de [IPv6:2001:4d88:2000:24::c0de])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0375CC0613ED
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 09:50:09 -0800 (PST)
Received: from kero.packetmixer.de (p4fd575e2.dip0.t-ipconnect.de [79.213.117.226])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id 7F9D3174027;
        Tue,  2 Feb 2021 18:40:40 +0100 (CET)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4/4] batman-adv: Fix names for kernel-doc blocks
Date:   Tue,  2 Feb 2021 18:40:36 +0100
Message-Id: <20210202174037.7081-5-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210202174037.7081-1-sw@simonwunderlich.de>
References: <20210202174037.7081-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

kernel-doc can only correctly identify the documented function or struct
when the name in the first kernel-doc line references it. But some of the
kernel-doc blocks referenced a different function/struct then it actually
documented.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/distributed-arp-table.c | 2 +-
 net/batman-adv/multicast.c             | 2 +-
 net/batman-adv/netlink.c               | 4 ++--
 net/batman-adv/tp_meter.c              | 2 +-
 net/batman-adv/types.h                 | 3 ++-
 5 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/batman-adv/distributed-arp-table.c b/net/batman-adv/distributed-arp-table.c
index 61a6cfef2742..fcabd6b1e77f 100644
--- a/net/batman-adv/distributed-arp-table.c
+++ b/net/batman-adv/distributed-arp-table.c
@@ -1564,7 +1564,7 @@ static int batadv_dat_get_dhcp_message_type(struct sk_buff *skb)
 }
 
 /**
- * batadv_dat_get_dhcp_yiaddr() - get yiaddr from a DHCP packet
+ * batadv_dat_dhcp_get_yiaddr() - get yiaddr from a DHCP packet
  * @skb: the DHCP packet to parse
  * @buf: a buffer to store the yiaddr in
  *
diff --git a/net/batman-adv/multicast.c b/net/batman-adv/multicast.c
index 8db5d285c433..ad216c42406f 100644
--- a/net/batman-adv/multicast.c
+++ b/net/batman-adv/multicast.c
@@ -828,7 +828,7 @@ batadv_mcast_bridge_log(struct batadv_priv *bat_priv,
 }
 
 /**
- * batadv_mcast_flags_logs() - output debug information about mcast flag changes
+ * batadv_mcast_flags_log() - output debug information about mcast flag changes
  * @bat_priv: the bat priv with all the soft interface information
  * @flags: TVLV flags indicating the new multicast state
  *
diff --git a/net/batman-adv/netlink.c b/net/batman-adv/netlink.c
index 8eef71a62a5a..c80527b879a7 100644
--- a/net/batman-adv/netlink.c
+++ b/net/batman-adv/netlink.c
@@ -193,7 +193,7 @@ static int batadv_netlink_mesh_fill_ap_isolation(struct sk_buff *msg,
 }
 
 /**
- * batadv_option_set_ap_isolation() - Set ap_isolation from genl msg
+ * batadv_netlink_set_mesh_ap_isolation() - Set ap_isolation from genl msg
  * @attr: parsed BATADV_ATTR_AP_ISOLATION_ENABLED attribute
  * @bat_priv: the bat priv with all the soft interface information
  *
@@ -757,7 +757,7 @@ batadv_netlink_tp_meter_start(struct sk_buff *skb, struct genl_info *info)
 }
 
 /**
- * batadv_netlink_tp_meter_start() - Cancel a running tp_meter session
+ * batadv_netlink_tp_meter_cancel() - Cancel a running tp_meter session
  * @skb: received netlink message
  * @info: receiver information
  *
diff --git a/net/batman-adv/tp_meter.c b/net/batman-adv/tp_meter.c
index e61925f19f66..72ec4aab4813 100644
--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -131,7 +131,7 @@ static u32 batadv_tp_cwnd(u32 base, u32 increment, u32 min)
 }
 
 /**
- * batadv_tp_updated_cwnd() - update the Congestion Windows
+ * batadv_tp_update_cwnd() - update the Congestion Windows
  * @tp_vars: the private data of the current TP meter session
  * @mss: maximum segment size of transmission
  *
diff --git a/net/batman-adv/types.h b/net/batman-adv/types.h
index 65985e262cde..aae7366bb679 100644
--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -228,7 +228,8 @@ struct batadv_hard_iface {
 };
 
 /**
- * struct batadv_orig_ifinfo - B.A.T.M.A.N. IV private orig_ifinfo members
+ * struct batadv_orig_ifinfo_bat_iv - B.A.T.M.A.N. IV private orig_ifinfo
+ *  members
  */
 struct batadv_orig_ifinfo_bat_iv {
 	/**
-- 
2.20.1

