Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC9CD284185
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 22:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729173AbgJEUhk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 16:37:40 -0400
Received: from mailrelay115.isp.belgacom.be ([195.238.20.142]:49596 "EHLO
        mailrelay115.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729196AbgJEUhg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 16:37:36 -0400
IronPort-SDR: DQn/VuBLWbmY4Yd6AWf+uzwcqiqOtycB78dLm4NmlWG+I7FXD+WqIdqsv7ZyPShlGsYaQpZMLN
 WJkBpMv6OicPgqCpT+jS+z/gZkZZYf6QLY8KbLVzIw4nWqekZgS3xsw5/hw6hShuu4qLkft/Li
 KvRhuUsFY06+eyTGRbRLx5weCuH+aClqcO0IAL5ITloKFnvg2Q6vCWAV+UHrX3oY8x2Bc6WM+8
 YYzZCAqjJ9nfX84ipM40EVJTgSOwS1S073K5kUgTZz2gv8umaOJzWCYsLylU6swQa2kaLS5nQc
 Bcc=
X-Belgacom-Dynamic: yes
IronPort-PHdr: =?us-ascii?q?9a23=3AUaa8Xx9VWQEocf9uRHKM819IXTAuvvDOBiVQ1K?=
 =?us-ascii?q?B+0+MeIJqq85mqBkHD//Il1AaPAdyEra4ewLON6ujJYi8p2d65qncMcZhBBV?=
 =?us-ascii?q?cuqP49uEgeOvODElDxN/XwbiY3T4xoXV5h+GynYwAOQJ6tL1LdrWev4jEMBx?=
 =?us-ascii?q?7xKRR6JvjvGo7Vks+7y/2+94fcbglVhjexe7x/IAu5oQnMuMQanJZpJ7osxB?=
 =?us-ascii?q?fOvnZGYfldy3lyJVKUkRb858Ow84Bm/i9Npf8v9NNOXLvjcaggQrNWEDopM2?=
 =?us-ascii?q?Yu5M32rhbDVheA5mEdUmoNjBVFBRXO4QzgUZfwtiv6sfd92DWfMMbrQ704RS?=
 =?us-ascii?q?iu4qF2QxLulSwJNSM28HvPh8JwkqxVvRyvqR94zYHbb4+YL+Zyc6DHcN8GX2?=
 =?us-ascii?q?dNQtpdWipcCY28dYsPCO8BMP5YoYbnvFQOrAGxBQ+xD+3v0D9HmGL50rMg0+?=
 =?us-ascii?q?QgDQ7G3xErEtUAsHvOt9r1OrwfUfu2zKjIyzXMce9W1S3m54fWax0sp+yHUr?=
 =?us-ascii?q?1sf8TL00YvCx/FgUuKqYzjJz6b2OcAvmyb4edhVe+jlWAqpQFsrzSz28sglo?=
 =?us-ascii?q?jEiI0axF3Z+yh03ps4KN26RUNlbtCoDJVeuS6eOoV2Qs0uXWVltSAnwbMFoZ?=
 =?us-ascii?q?62ZCwHxIk9yxLCaPGLbZKE7g/iWeuROzt0mXNodbSijBio60eg0PfzVsys3V?=
 =?us-ascii?q?ZPqSpKj8fDu2gW1xzW9siHUvx9/lq92TqX1wDc9OVEIUcsmKrfLJ4u3qQ/lp?=
 =?us-ascii?q?4TsUTEBS/2hF/6jKuRdko44Oeo7/noYrLjppCGNo90jBnyMqUomsOhHeQ1Kg?=
 =?us-ascii?q?wDU3WB9eih17Dv41f1TKhLg/A2iKXVrZHXKdwepqGjAg9V1ogj6wy4DzejyN?=
 =?us-ascii?q?kYk2MII0lLeB+clIjpOFHPIPbmAvejmVijiylky+jcPrL9GpXNMmTDkLD5cL?=
 =?us-ascii?q?lg8UFc1hQ8zdVE6p1JEL4BPuz8Wkr1tNzfAB85Lxa4w+D5B9VhzokeQ36AAr?=
 =?us-ascii?q?eFMKPOtl+F/uEvI/SXa4APozv9KOYq5+TojXAnnV8RZ66p3YEYaHqgBPRpP1?=
 =?us-ascii?q?2ZYWbwgtcGCWoKuBQxTPD3h1KcTz5efGiyX60i6TEhEo6mDpnMRpqrgLOf2C?=
 =?us-ascii?q?e3BJpWZnpJClqUC3fna52EW+sQaCKVOsJgkjsEVaOhS48vyBGutg76xqFjLu?=
 =?us-ascii?q?rV/C0YqJ3i2MF05+3LixE/9CZ4D8OH02GCV2t0hH8HRycq3KBjpkxw0lSD0b?=
 =?us-ascii?q?V5gvxeC9NT++hEUgIhNZLC1eB6CtbyWhjbctiTVFmqWM+mASwpRNIr39AOe1?=
 =?us-ascii?q?p9G8mljh3b0SqlGaQal7KQCZwv8aLd337xKNhhy3rcz6YukQpufswaOWS4i6?=
 =?us-ascii?q?tX+wHNCovNlEuF0aCnaeBU3zPH/U+AwHCIsUUeVxR/Fe3DUGwTa1X+s9v0/A?=
 =?us-ascii?q?XBQqWoBLBhNRFOmuCYLa4fRNTjjFxADNn5NdjTeWO6mC/kCx+CyJuXb5vsdn?=
 =?us-ascii?q?lb1iiLWxtMqBwa4XvTbVt2PSymuW+LVDE=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2DgAgDggntf/xCltltgHAEBAQEBAQc?=
 =?us-ascii?q?BARIBAQQEAQFHgUiBHoJRX40/klaKWYctCwEBAQEBAQEBATUBAgQBAYRKgjs?=
 =?us-ascii?q?mOBMCAwEBAQMCBQEBBgEBAQEBAQUEAYYPRYI3IoNHCwEjI4E/EoMmglgpqhc?=
 =?us-ascii?q?zhBCBRINHgUKBOIgyhRqBQT+EX4o0BLdNgnGDE4RrklQPIqEfLZJnm2KGR4F?=
 =?us-ascii?q?6TSAYgyRQGQ2caEIwNwIGCgEBAwlXAT0BjTIBAQ?=
X-IPAS-Result: =?us-ascii?q?A2DgAgDggntf/xCltltgHAEBAQEBAQcBARIBAQQEAQFHg?=
 =?us-ascii?q?UiBHoJRX40/klaKWYctCwEBAQEBAQEBATUBAgQBAYRKgjsmOBMCAwEBAQMCB?=
 =?us-ascii?q?QEBBgEBAQEBAQUEAYYPRYI3IoNHCwEjI4E/EoMmglgpqhczhBCBRINHgUKBO?=
 =?us-ascii?q?IgyhRqBQT+EX4o0BLdNgnGDE4RrklQPIqEfLZJnm2KGR4F6TSAYgyRQGQ2ca?=
 =?us-ascii?q?EIwNwIGCgEBAwlXAT0BjTIBAQ?=
Received: from 16.165-182-91.adsl-dyn.isp.belgacom.be (HELO localhost.localdomain) ([91.182.165.16])
  by relay.skynet.be with ESMTP; 05 Oct 2020 22:37:34 +0200
From:   Fabian Frederick <fabf@skynet.be>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     yoshfuji@linux-ipv6.org, kuznet@ms2.inr.ac.ru,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 9/9 net-next] ipv4: use dev_sw_netstats_rx_add()
Date:   Mon,  5 Oct 2020 22:37:12 +0200
Message-Id: <20201005203712.55537-1-fabf@skynet.be>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

use new helper for netstats settings

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/ipv4/ip_tunnel.c | 8 +-------
 net/ipv4/ip_vti.c    | 9 +--------
 2 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index 0c1f364044715..8b04d1dcfec4e 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -360,7 +360,6 @@ int ip_tunnel_rcv(struct ip_tunnel *tunnel, struct sk_buff *skb,
 		  const struct tnl_ptk_info *tpi, struct metadata_dst *tun_dst,
 		  bool log_ecn_error)
 {
-	struct pcpu_sw_netstats *tstats;
 	const struct iphdr *iph = ip_hdr(skb);
 	int err;
 
@@ -402,12 +401,7 @@ int ip_tunnel_rcv(struct ip_tunnel *tunnel, struct sk_buff *skb,
 		}
 	}
 
-	tstats = this_cpu_ptr(tunnel->dev->tstats);
-	u64_stats_update_begin(&tstats->syncp);
-	tstats->rx_packets++;
-	tstats->rx_bytes += skb->len;
-	u64_stats_update_end(&tstats->syncp);
-
+	dev_sw_netstats_rx_add(tunnel->dev, skb->len);
 	skb_scrub_packet(skb, !net_eq(tunnel->net, dev_net(tunnel->dev)));
 
 	if (tunnel->dev->type == ARPHRD_ETHER) {
diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
index 49daaed897649..6500e8bce8bd4 100644
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -95,7 +95,6 @@ static int vti_rcv_cb(struct sk_buff *skb, int err)
 {
 	unsigned short family;
 	struct net_device *dev;
-	struct pcpu_sw_netstats *tstats;
 	struct xfrm_state *x;
 	const struct xfrm_mode *inner_mode;
 	struct ip_tunnel *tunnel = XFRM_TUNNEL_SKB_CB(skb)->tunnel.ip4;
@@ -138,13 +137,7 @@ static int vti_rcv_cb(struct sk_buff *skb, int err)
 
 	skb_scrub_packet(skb, !net_eq(tunnel->net, dev_net(skb->dev)));
 	skb->dev = dev;
-
-	tstats = this_cpu_ptr(dev->tstats);
-
-	u64_stats_update_begin(&tstats->syncp);
-	tstats->rx_packets++;
-	tstats->rx_bytes += skb->len;
-	u64_stats_update_end(&tstats->syncp);
+	dev_sw_netstats_rx_add(dev, skb->len);
 
 	return 0;
 }
-- 
2.28.0

