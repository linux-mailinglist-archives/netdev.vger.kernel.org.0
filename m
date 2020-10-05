Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0512284168
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 22:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729903AbgJEUg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 16:36:56 -0400
Received: from mailrelay115.isp.belgacom.be ([195.238.20.142]:49513 "EHLO
        mailrelay115.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729273AbgJEUgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 16:36:44 -0400
IronPort-SDR: f7Q7fvpmyrrJVFvQljq0BqxY68CaasLHQmz7uRmNqj3UqszYMyuyz8xq2ZLMncDv97/J8eTC5k
 0jSxWhshSrG2Ckd3/WpfMrBb/fPaz/qPHhLgf6BCkhxAbu/TxJfVvPxmP4UdZGD5QXEIt8n0xQ
 Wt3/U0y5/HAS7elxM6xrGndXaf1XQY/tNyElKBcqKSIGNBesyri/xb1AMktuOu9mpBMbEQoZcj
 yRWYt4RftR8xYy+qN+PBUT1z8dBb0KAxhCNsK49Q1rjtzCJgiw+OqquQEPJiAEmgcWjZDlE2e7
 5bw=
X-Belgacom-Dynamic: yes
IronPort-PHdr: =?us-ascii?q?9a23=3ADUCfjhey+gtNpqUgnqmsULVhlGMj4u6mDksu8p?=
 =?us-ascii?q?Mizoh2WeGdxc26bRyN2/xhgRfzUJnB7Loc0qyK6v+mBTZLuM3Y+Fk5M7V0Hy?=
 =?us-ascii?q?cfjssXmwFySOWkMmbcaMDQUiohAc5ZX0Vk9XzoeWJcGcL5ekGA6ibqtW1aFR?=
 =?us-ascii?q?rwLxd6KfroEYDOkcu3y/qy+5rOaAlUmTaxe7x/IAi0oAnLucQan4RuJrs/xx?=
 =?us-ascii?q?fUv3BFZ/lYyWR0KFyJgh3y/N2w/Jlt8yRRv/Iu6ctNWrjkcqo7ULJVEi0oP3?=
 =?us-ascii?q?g668P3uxbDSxCP5mYHXWUNjhVIGQnF4wrkUZr3ryD3q/By2CiePc3xULA0RT?=
 =?us-ascii?q?Gv5LplRRP0lCsKMSMy/WfKgcJyka1bugqsqRxhzYDJbo+bN/1wcazSc94BWW?=
 =?us-ascii?q?ZMXdxcWzBbD4+gc4cCCfcKM+ZCr4n6olsDtRuwChO3C+Pu0DBIgGL9060g0+?=
 =?us-ascii?q?s/DA7JwhYgH9MSv3TXsd74M6kSXvquw6nG1jjDdPBW2Df76IfWbhAtu+qDUq?=
 =?us-ascii?q?xpfMfX1EIgGB/LgE+Kpoz5IzOayP4Ns26D4uRuVu+ij24ppgBxrzSxyMoiip?=
 =?us-ascii?q?TEip4IxlzY9Ch3z4k7KMC2RUNlfNOpEJlduj+VOYdqTM0sTGVltiY6xLEYvZ?=
 =?us-ascii?q?O2ejUBxpc/xxPHb/GLbpKE7g/gWeqPOzt0mXNodbKlixqv8EWtzPD3WNOu31?=
 =?us-ascii?q?ZQtCVFl8HBtnUK1xPO9MeKUuB9/kK92TaX0ADT9/1ELVg0laXFL54hxaY9lp?=
 =?us-ascii?q?4UsUvfBCD2nEX2jKiNdkU44OSo7+Pnban8qZ+YKoB0jQT+Pb4vmsy5Geg4Mw?=
 =?us-ascii?q?4OUHaH+emk0LDv4Ff1TKhJg/EoiKXVrZHXKMQBqqKkAgJZyoMj5Ay+Dzei3t?=
 =?us-ascii?q?QYh34HLFdddRKJlYfmIF/OLevjDfe8g1Wslilkx+zcMrL6HJrBNmLDn6v5fb?=
 =?us-ascii?q?Zh905czxI+ws1F6JJKFL4BJen+VVLru9zGEBA5Ngi0w+HpCNVhzI8eX3yAAr?=
 =?us-ascii?q?OBOqPIrVCI/v4vI/WLZIINuzb9NuMq6OT1gH86h1AdZ6+p0oUTaHyiGfRmOU?=
 =?us-ascii?q?qZa2L2gtgdCWcKohY+TOvyhV2ETzFTe2u9ULwi5jwgFoKmApnMRpq3jLyCwi?=
 =?us-ascii?q?i7BJtWaX5CClyWFnfobYqEUe8WaC2OOs9hjiAEVb+5Ro8iyBGvtQn6xKR7Lu?=
 =?us-ascii?q?fP/y0Yrozv2MJ05+3VjxE+7yZ7ANiH32GXUmF+hnkISCMu3KBjvUx9zU+O0K?=
 =?us-ascii?q?h/g/xDFdxT6e5JUgU7NZPHy+x6CtbyWh/Of9uQSVamWsumDDArQtI22d8ObF?=
 =?us-ascii?q?53G8++gRDbwyqqH7gVmqSFBJMu6a3c0WP8J91+y3fG0qkukUUmTtFUOmK41e?=
 =?us-ascii?q?ZD8F3fDpDElm2VnrincKAb0jKL8mqfiSKNoUtReA19S6PIWTYYfESS5dL0+k?=
 =?us-ascii?q?/PUZewBrk9dAhM08iPLu1NcNK6o09BQaLNMd7famT5tX29CRuSx7iPJN7kcm?=
 =?us-ascii?q?8T9D7eGU4Jj0YZ8CDVZkAFGi69rjeGX3RVHlX1bha0/A=3D=3D?=
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
  by relay.skynet.be with ESMTP; 05 Oct 2020 22:36:42 +0200
From:   Fabian Frederick <fabf@skynet.be>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 6/9 net-next] ipv6: use dev_sw_netstats_rx_add()
Date:   Mon,  5 Oct 2020 22:36:19 +0200
Message-Id: <20201005203619.55383-1-fabf@skynet.be>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

use new helper for netstats settings

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/ipv6/ip6_vti.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
index fac01b80a1040..5f9c4fdc120d6 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -347,7 +347,6 @@ static int vti6_rcv_cb(struct sk_buff *skb, int err)
 {
 	unsigned short family;
 	struct net_device *dev;
-	struct pcpu_sw_netstats *tstats;
 	struct xfrm_state *x;
 	const struct xfrm_mode *inner_mode;
 	struct ip6_tnl *t = XFRM_TUNNEL_SKB_CB(skb)->tunnel.ip6;
@@ -390,12 +389,7 @@ static int vti6_rcv_cb(struct sk_buff *skb, int err)
 
 	skb_scrub_packet(skb, !net_eq(t->net, dev_net(skb->dev)));
 	skb->dev = dev;
-
-	tstats = this_cpu_ptr(dev->tstats);
-	u64_stats_update_begin(&tstats->syncp);
-	tstats->rx_packets++;
-	tstats->rx_bytes += skb->len;
-	u64_stats_update_end(&tstats->syncp);
+	dev_sw_netstats_rx_add(dev, skb->len);
 
 	return 0;
 }
-- 
2.28.0

