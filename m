Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9281CF674
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 11:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730160AbfJHJwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 05:52:33 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34627 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729375AbfJHJwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 05:52:33 -0400
Received: by mail-pf1-f194.google.com with SMTP id b128so10511203pfa.1
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 02:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=uFqBtOK08O/e/2Lcz3wZXFcTYqBP6C1aembvxRM0Bdc=;
        b=lrVi6ehi19Igl2sMvg+tCqJeSs0ubM8EG1j8AfTzc13Jt8Q3afkxRDYEv8atqx1KZf
         Jpt9s/A52Tl0LFNyJgT3hHThZ9/H8YTqSIesJnolv/Wzhs48dvN0rAgAw/1Ovetl8G3u
         tiMaWDE0vU/tb5vFqFmJJTRKWvJf2vkoJayDfP4Qr1L4zJ98ORX8Q+I38Zuv3QFoSleK
         bqFCCBjeHVoatw68pWD6b/B2UNH2DJLa8byU9ni/lL64zESTw3Ls0xrWHk6wiyL4bVd1
         f6a6DFhEbI1zMYmy1g3I+BByi2zrPFl9EIzQTScvvJw81jWPZs22S8G87JExwXDq01Ma
         CUMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=uFqBtOK08O/e/2Lcz3wZXFcTYqBP6C1aembvxRM0Bdc=;
        b=M7hNiZNMeNKGEpKBKb95vs02X7iNhNxv12odfi8FBH76LXGuU2RQpa4k2HcQj5LvE5
         kqcE1najajNkc4m+KbnJKOdG7TMhP35lZopkrHtSJeiEFHoGt85cT3NDi0ApMvLqhH+L
         nfIoMoMENPl47PC/iEdVmt6oGn5mLRRfdU+0ZkJniRx2SLof6qhoCC5hp50ZxMuTzycn
         aLxP8djGq9yJxnDoPsRsj5H1N6Cj4qe4mk3MXZJtHn+jwmVZ0YkrUtkUfjQkZLDF64Ep
         /sc6JKQWarSfCRYxZBPMw7pD/1kHn4IQItnVJanPk12vWAgJws8A1OhRGRvu57ZTWNtj
         ieAw==
X-Gm-Message-State: APjAAAU852ZBgO72iBJ+jyL2Xp+pesqrWl/bch3RbqAJBG4z+BiVnFoC
        1u0VvUECUlYL+LdEtTye2QooE+gq
X-Google-Smtp-Source: APXvYqzhcbRweW3H+wr/XGQVXIlvx/h2hz11Bako+41q1tuceMKwikhkZOEsb/4Eoo1JElJ8zS5lOQ==
X-Received: by 2002:aa7:9358:: with SMTP id 24mr37363934pfn.241.1570528352093;
        Tue, 08 Oct 2019 02:52:32 -0700 (PDT)
Received: from martin-VirtualBox.dlink.router ([122.178.241.240])
        by smtp.gmail.com with ESMTPSA id z21sm15777104pfa.119.2019.10.08.02.52.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 08 Oct 2019 02:52:31 -0700 (PDT)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, corbet@lwn.net,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Cc:     Martin Varghese <martinvarghesenokia@gmail.com>
Subject: [PATCH net-next 2/2] Special handling for IP & MPLS.
Date:   Tue,  8 Oct 2019 15:19:40 +0530
Message-Id: <1da8fb9d3af8dcee1948903ae816438578365e51.1570455278.git.martinvarghesenokia@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1570455278.git.martinvarghesenokia@gmail.com>
References: <cover.1570455278.git.martinvarghesenokia@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin <martin.varghese@nokia.com>

Signed-off-by: Martin Varghese <martinvarghesenokia@gmail.com>

Signed-off-by: Martin Varghese <martinvarghesenokia@gmail.com>
---
 Documentation/networking/bareudp.txt | 18 ++++++++
 drivers/net/bareudp.c                | 82 +++++++++++++++++++++++++++++++++---
 include/net/bareudp.h                |  1 +
 include/uapi/linux/if_link.h         |  1 +
 4 files changed, 95 insertions(+), 7 deletions(-)

diff --git a/Documentation/networking/bareudp.txt b/Documentation/networking/bareudp.txt
index d2530e2..4de1022 100644
--- a/Documentation/networking/bareudp.txt
+++ b/Documentation/networking/bareudp.txt
@@ -9,6 +9,15 @@ The Bareudp tunnel module provides a generic L3 encapsulation tunnelling
 support for tunnelling different L3 protocols like MPLS, IP, NSH etc. inside
 a UDP tunnel.
 
+Special Handling
+----------------
+The bareudp device supports special handling for MPLS & IP as they can have
+multiple ethertypes.
+MPLS procotcol can have ethertypes 0x8847 (unicast) & 0x8847 (multicast).
+IP proctocol can have ethertypes 0x0800 (v4) & 0x866 (v6).
+This special handling can be enabled only for ethertype 0x0800 & 0x88847 with a
+flag called extended mode.
+
 Usage
 ------
 
@@ -21,3 +30,12 @@ This creates a bareudp tunnel device which tunnels L3 traffic with ethertype
 The device will listen on UDP port 6635 to receive traffic.
 
 b. ip link delete bareudp0
+
+2. Device creation with extended mode enabled
+
+There are two ways to create a bareudp device for MPLS & IP with extended mode
+enabled
+
+a. ip link add dev  bareudp0 type bareudp dstport 6635 ethertype 0x8847 extmode 1
+
+b. ip link add dev  bareudp0 type bareudp dstport 6635 ethertype mpls
diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index 7e6813a..2a688da 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -48,6 +48,7 @@ struct bareudp_dev {
 	struct net_device  *dev;        /* netdev for bareudp tunnel */
 	__be16		   ethertype;
 	u16	           sport_min;
+	bool               ext_mode;
 	struct bareudp_conf conf;
 	struct bareudp_sock __rcu *sock4; /* IPv4 socket for bareudp tunnel */
 #if IS_ENABLED(CONFIG_IPV6)
@@ -82,15 +83,64 @@ static int bareudp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 		goto drop;
 
 	bareudp = bs->bareudp;
-	proto = bareudp->ethertype;
+	if (!bareudp)
+		goto drop;
+
+	if (bareudp->ethertype == htons(ETH_P_IP)) {
+		struct iphdr *iphdr;
+
+		iphdr = (struct iphdr *)(skb->data + BAREUDP_BASE_HLEN);
+		if (iphdr->version == 4) {
+			proto = bareudp->ethertype;
+		} else if (bareudp->ext_mode && (iphdr->version == 6)) {
+			proto = htons(ETH_P_IPV6);
+		} else {
+			bareudp->dev->stats.rx_dropped++;
+			goto drop;
+		}
+	} else if (bareudp->ethertype == htons(ETH_P_MPLS_UC)) {
+		struct iphdr *tunnel_hdr;
+
+		tunnel_hdr = (struct iphdr *)skb_network_header(skb);
+		if (tunnel_hdr->version == 4) {
+			if (!ipv4_is_multicast(tunnel_hdr->daddr)) {
+				proto = bareudp->ethertype;
+			} else if (bareudp->ext_mode &&
+				   ipv4_is_multicast(tunnel_hdr->daddr)) {
+				proto = htons(ETH_P_MPLS_MC);
+			} else {
+				bareudp->dev->stats.rx_dropped++;
+				goto drop;
+			}
+		} else {
+			int addr_type;
+			struct ipv6hdr *tunnel_hdr_v6;
+
+			tunnel_hdr_v6 = (struct ipv6hdr *)skb_network_header(skb);
+			addr_type =
+			ipv6_addr_type((struct in6_addr *)&tunnel_hdr_v6->daddr);
+			if (!(addr_type & IPV6_ADDR_MULTICAST)) {
+				proto = bareudp->ethertype;
+			} else if (bareudp->ext_mode &&
+				   (addr_type & IPV6_ADDR_MULTICAST)) {
+				proto = htons(ETH_P_MPLS_MC);
+			} else {
+				bareudp->dev->stats.rx_dropped++;
+				goto drop;
+			}
+		}
+	} else {
+		proto = bareudp->ethertype;
+	}
 
 	if (iptunnel_pull_header(skb, BAREUDP_BASE_HLEN,
-				 proto,
-				 !net_eq(bareudp->net,
-					 dev_net(bareudp->dev)))) {
+				proto,
+				!net_eq(bareudp->net,
+					dev_net(bareudp->dev)))) {
 		bareudp->dev->stats.rx_dropped++;
 		goto drop;
 	}
+
 	tun_dst = udp_tun_rx_dst(skb, bareudp_get_sk_family(bs), TUNNEL_KEY,
 				 0, 0);
 	if (!tun_dst) {
@@ -522,10 +572,13 @@ static netdev_tx_t bareudp_xmit(struct sk_buff *skb, struct net_device *dev)
 	int err;
 
 	if (skb->protocol != bareudp->ethertype) {
-		err = -EINVAL;
-		goto tx_error;
+		if (!bareudp->ext_mode ||
+		    (skb->protocol !=  htons(ETH_P_MPLS_MC) &&
+		     skb->protocol !=  htons(ETH_P_IPV6))) {
+			err = -EINVAL;
+			goto tx_error;
+		}
 	}
-
 	info = skb_tunnel_info(skb);
 	if (unlikely(!info || !(info->mode & IP_TUNNEL_INFO_TX))) {
 		err = -EINVAL;
@@ -630,6 +683,7 @@ static int bareudp_change_mtu(struct net_device *dev, int new_mtu)
 	[IFLA_BAREUDP_PORT]                = { .type = NLA_U16 },
 	[IFLA_BAREUDP_ETHERTYPE]	   = { .type = NLA_U16 },
 	[IFLA_BAREUDP_SRCPORT_MIN]         = { .type = NLA_U16 },
+	[IFLA_BAREUDP_EXTMODE]             = { .type = NLA_FLAG },
 };
 
 static int bareudp_validate(struct nlattr *tb[], struct nlattr *data[],
@@ -712,9 +766,15 @@ static int bareudp_configure(struct net *net, struct net_device *dev,
 	if (t)
 		return -EBUSY;
 
+	if (conf->ext_mode &&
+	    (conf->ethertype != htons(ETH_P_MPLS_UC) &&
+	     conf->ethertype != htons(ETH_P_IP)))
+		return -EINVAL;
+
 	bareudp->conf = *conf;
 	bareudp->ethertype = conf->ethertype;
 	bareudp->sport_min = conf->sport_min;
+	bareudp->ext_mode = conf->ext_mode;
 	err = register_netdevice(dev);
 	if (err)
 		return err;
@@ -737,6 +797,11 @@ static int bareudp2info(struct nlattr *data[], struct bareudp_conf *conf)
 	if (data[IFLA_BAREUDP_SRCPORT_MIN])
 		conf->sport_min =  nla_get_u16(data[IFLA_BAREUDP_SRCPORT_MIN]);
 
+	if (data[IFLA_BAREUDP_EXTMODE])
+		conf->ext_mode = true;
+	else
+		conf->ext_mode = false;
+
 	return 0;
 }
 
@@ -779,6 +844,7 @@ static size_t bareudp_get_size(const struct net_device *dev)
 	return  nla_total_size(sizeof(__be16)) +  /* IFLA_BAREUDP_PORT */
 		nla_total_size(sizeof(__be16)) +  /* IFLA_BAREUDP_ETHERTYPE */
 		nla_total_size(sizeof(__u16))  +  /* IFLA_BAREUDP_SRCPORT_MIN */
+		nla_total_size(0)              +  /* IFLA_BAREUDP_EXTMODE */
 		0;
 }
 
@@ -792,6 +858,8 @@ static int bareudp_fill_info(struct sk_buff *skb, const struct net_device *dev)
 		goto nla_put_failure;
 	if (nla_put_u16(skb, IFLA_BAREUDP_SRCPORT_MIN, bareudp->conf.sport_min))
 		goto nla_put_failure;
+	if (bareudp->ext_mode && nla_put_flag(skb, IFLA_BAREUDP_EXTMODE))
+		goto nla_put_failure;
 
 	return 0;
 
diff --git a/include/net/bareudp.h b/include/net/bareudp.h
index 513fae6..2c121d8 100644
--- a/include/net/bareudp.h
+++ b/include/net/bareudp.h
@@ -10,6 +10,7 @@ struct bareudp_conf {
 	__be16 ethertype;
 	__be16 port;
 	u16 sport_min;
+	bool ext_mode;
 };
 
 struct net_device *bareudp_dev_create(struct net *net, const char *name,
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 012f7e8..2b91c872 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -586,6 +586,7 @@ enum {
 	IFLA_BAREUDP_PORT,
 	IFLA_BAREUDP_ETHERTYPE,
 	IFLA_BAREUDP_SRCPORT_MIN,
+	IFLA_BAREUDP_EXTMODE,
 	__IFLA_BAREUDP_MAX
 };
 
-- 
1.8.3.1

