Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0983F4891
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 12:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236226AbhHWKWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 06:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236235AbhHWKWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 06:22:05 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D0AC061760;
        Mon, 23 Aug 2021 03:21:23 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id fz10so237787pjb.0;
        Mon, 23 Aug 2021 03:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cGasR7WzNEMTvDVDQ6lbvU3xnDLeP0u7zfxmVNjFYPU=;
        b=rFrVSrosHqfZBwG558QWzesJXzhHHz6kIPy1y1yvII6nQxtXq2zIlgEFwMmUdxkyhV
         Ce4aMoaHb+JD8zd6P/UjiPwoSLTHa97AvKpDZWLPYQKlDx5bpeJmKOYbsckI0wxxJeqp
         X27v/M/mbMUINnSV+SuzMIHxzuAAirbvrgY8nE54+hyuYcir/MuExNmUQ+LE8haUj8Nr
         6ySrml1EVn+stlsAEGirJMvxtE3szd9KnMOoGMt3WDW+I3Wp2xgtun7ZR6GIMAby+TVg
         CMBl0vuZN0VmkwG2yjKRcecP/tKATYD7Oec62jBp4IdSP8B2im9HHsGG2EICQeLgEhfi
         wE6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cGasR7WzNEMTvDVDQ6lbvU3xnDLeP0u7zfxmVNjFYPU=;
        b=bUsiVWjMj0+D2HzrROh9vDnJrFYboigvTMxGX0hs5paE7kHUwH7Pdgn0tMFnM7F1LN
         EeDy8V/jh6br4PrZLAkuuYBpytVToQEnNwUJlo3liHyl008fZ1dctRr/XCyJQN7zFJI0
         6PwdABfJdTCBkdED05LbWC6j2QZKXpXNJ+bma3n0gfcThFGiluZsnk4vV75IyfM7QnI4
         5ycvisZZI7t6kdDThR4NyLwoxFVqnysieuRKgPu43BwzRX+hNNS2O83dtQ2yAX5Bs3Ko
         VvGRFLCQk6k5WVOttTcUR/WjBAL68sWvdeZ7ODr45zA4CAUK85UGUY0EhU3OmYtmqq7z
         x1qQ==
X-Gm-Message-State: AOAM532uZP8zbCAlJIZzGM4CjUSycVn5qfu228hmrnedokotXwqQ4Ik9
        Y+duoFA+0CQ+wQnysH+s7YU=
X-Google-Smtp-Source: ABdhPJyaGnWL030a8L8Yo6zKwRM2qOHZs3bcb7JkTJga61C1szPRk/I8txRYHUZqRRZZlVWVCBr9uQ==
X-Received: by 2002:a17:90b:1c8c:: with SMTP id oo12mr19175597pjb.170.1629714083221;
        Mon, 23 Aug 2021 03:21:23 -0700 (PDT)
Received: from localhost.localdomain ([1.240.193.107])
        by smtp.googlemail.com with ESMTPSA id o14sm18084788pgl.85.2021.08.23.03.21.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 03:21:22 -0700 (PDT)
From:   Kangmin Park <l4stpr0gr4m@gmail.com>
To:     Roopa Prabhu <roopa@nvidia.com>
Cc:     Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 net-next] net: bridge: change return type of br_handle_ingress_vlan_tunnel
Date:   Mon, 23 Aug 2021 19:21:18 +0900
Message-Id: <20210823102118.17966-1-l4stpr0gr4m@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

br_handle_ingress_vlan_tunnel() is only referenced in
br_handle_frame(). If br_handle_ingress_vlan_tunnel() is called and
return non-zero value, goto drop in br_handle_frame().

But, br_handle_ingress_vlan_tunnel() always return 0. So, the
routines that check the return value and goto drop has no meaning.

Therefore, change return type of br_handle_ingress_vlan_tunnel() to
void and remove if statement of br_handle_frame().

Signed-off-by: Kangmin Park <l4stpr0gr4m@gmail.com>
---
v3:
 - remove unnecessary return statement

v2:
 - cleanup instead of modifying ingress function
 - change prototype of ingress function
 - cleanup br_handle_frame function
 - change commit message accordingly

 net/bridge/br_input.c          |  7 ++-----
 net/bridge/br_private_tunnel.h |  6 +++---
 net/bridge/br_vlan_tunnel.c    | 14 ++++++--------
 3 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 8a0c0cc55cb4..b50382f957c1 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -294,11 +294,8 @@ static rx_handler_result_t br_handle_frame(struct sk_buff **pskb)
 	memset(skb->cb, 0, sizeof(struct br_input_skb_cb));
 
 	p = br_port_get_rcu(skb->dev);
-	if (p->flags & BR_VLAN_TUNNEL) {
-		if (br_handle_ingress_vlan_tunnel(skb, p,
-						  nbp_vlan_group_rcu(p)))
-			goto drop;
-	}
+	if (p->flags & BR_VLAN_TUNNEL)
+		br_handle_ingress_vlan_tunnel(skb, p, nbp_vlan_group_rcu(p));
 
 	if (unlikely(is_link_local_ether_addr(dest))) {
 		u16 fwd_mask = p->br->group_fwd_mask_required;
diff --git a/net/bridge/br_private_tunnel.h b/net/bridge/br_private_tunnel.h
index c54cc26211d7..2b053289f016 100644
--- a/net/bridge/br_private_tunnel.h
+++ b/net/bridge/br_private_tunnel.h
@@ -38,9 +38,9 @@ int nbp_vlan_tunnel_info_add(const struct net_bridge_port *port, u16 vid,
 void nbp_vlan_tunnel_info_flush(struct net_bridge_port *port);
 void vlan_tunnel_info_del(struct net_bridge_vlan_group *vg,
 			  struct net_bridge_vlan *vlan);
-int br_handle_ingress_vlan_tunnel(struct sk_buff *skb,
-				  struct net_bridge_port *p,
-				  struct net_bridge_vlan_group *vg);
+void br_handle_ingress_vlan_tunnel(struct sk_buff *skb,
+				   struct net_bridge_port *p,
+				   struct net_bridge_vlan_group *vg);
 int br_handle_egress_vlan_tunnel(struct sk_buff *skb,
 				 struct net_bridge_vlan *vlan);
 bool vlan_tunid_inrange(const struct net_bridge_vlan *v_curr,
diff --git a/net/bridge/br_vlan_tunnel.c b/net/bridge/br_vlan_tunnel.c
index 01017448ebde..6399a8a69d07 100644
--- a/net/bridge/br_vlan_tunnel.c
+++ b/net/bridge/br_vlan_tunnel.c
@@ -158,30 +158,28 @@ void vlan_tunnel_deinit(struct net_bridge_vlan_group *vg)
 	rhashtable_destroy(&vg->tunnel_hash);
 }
 
-int br_handle_ingress_vlan_tunnel(struct sk_buff *skb,
-				  struct net_bridge_port *p,
-				  struct net_bridge_vlan_group *vg)
+void br_handle_ingress_vlan_tunnel(struct sk_buff *skb,
+				   struct net_bridge_port *p,
+				   struct net_bridge_vlan_group *vg)
 {
 	struct ip_tunnel_info *tinfo = skb_tunnel_info(skb);
 	struct net_bridge_vlan *vlan;
 
 	if (!vg || !tinfo)
-		return 0;
+		return;
 
 	/* if already tagged, ignore */
 	if (skb_vlan_tagged(skb))
-		return 0;
+		return;
 
 	/* lookup vid, given tunnel id */
 	vlan = br_vlan_tunnel_lookup(&vg->tunnel_hash, tinfo->key.tun_id);
 	if (!vlan)
-		return 0;
+		return;
 
 	skb_dst_drop(skb);
 
 	__vlan_hwaccel_put_tag(skb, p->br->vlan_proto, vlan->vid);
-
-	return 0;
 }
 
 int br_handle_egress_vlan_tunnel(struct sk_buff *skb,
-- 
2.26.2

