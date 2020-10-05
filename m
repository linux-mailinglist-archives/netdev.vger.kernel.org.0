Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 386D528417D
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 22:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729301AbgJEUh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 16:37:28 -0400
Received: from mailrelay115.isp.belgacom.be ([195.238.20.142]:49578 "EHLO
        mailrelay115.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725901AbgJEUh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 16:37:27 -0400
IronPort-SDR: pwmTBCu8aSaf+0kSqpblu/lBRbNuKrIXyMglNFuzICA16yGKyDQhInT7S49cFe+SRAgc+AP3IK
 zYokAUdUGiRL3xJs6vaTnsCh33ABRUGwd5754OwB9Gmd9vF6S2GS/kWyKbi9XOX4R01KdmV6pe
 PUUqbCMXY2g/IcFRHnnu0M9bccJH2QLjEojWbbXPBHRVWE9OCLtRKhN/7eSeWZ9AQiaNihUshh
 WSjndpAXkBr+fEtitS/qnL4vFbbswR9sYSccXgfxU1gICmjY8VCJHk6/L1zoWK2Wx6OXa2SZx1
 YWY=
X-Belgacom-Dynamic: yes
IronPort-PHdr: =?us-ascii?q?9a23=3AGMhliB2wYg8yoBGYsmDT+DRfVm0co7zxezQtwd?=
 =?us-ascii?q?8ZsesWIvzxwZ3uMQTl6Ol3ixeRBMOHsq0C17Cd6vu5EUU7or+5+EgYd5JNUx?=
 =?us-ascii?q?JXwe43pCcHRPC/NEvgMfTxZDY7FskRHHVs/nW8LFQHUJ2mPw6arXK99yMdFQ?=
 =?us-ascii?q?viPgRpOOv1BpTSj8Oq3Oyu5pHfeQpFiCe/bL9oIxi6swrdutQYjId/N6081g?=
 =?us-ascii?q?bHrnxUdupM2GhmP0iTnxHy5sex+J5s7SFdsO8/+sBDTKv3Yb02QaRXAzo6PW?=
 =?us-ascii?q?814tbrtQTYQguU+nQcSGQWnQFWDAXD8Rr3Q43+sir+tup6xSmaIcj7Rq06VD?=
 =?us-ascii?q?i+86tmTgLjhSEaPDA77W7XkNR9gqJFrhy8qRJxwInab46aOvdlYq/QfskXSX?=
 =?us-ascii?q?ZbU8pNSyBMBJ63YYsVD+oGOOZVt4nzqEEVohu/HwasAv7kxD9ShnDowKI1zf?=
 =?us-ascii?q?4hEQDa0wwjAtkDt3rUo8/uO6ccSu2116rIzDXFb/xIxTfx8pPHfQ44rPyKQL?=
 =?us-ascii?q?l/ftbfx1M1GAPZklWft5blPzWN2+oDsGWW6+puWOOvhmI5pQx/oiWiytsxho?=
 =?us-ascii?q?XVh48bxV/K+Dh3zYsrONC1SEx2bMCrHpdMuS+UOI97TMMiTW12vCs3zKANt5?=
 =?us-ascii?q?2jfCUSzJkr2gTTZ+GEfoSW+B7vSeecLDdiiH54eb+ygQu5/1K6xe3mTMa01U?=
 =?us-ascii?q?5Hri9CktbRqH8AzwfT6s2bSvtl+UehxCqP2xjT6u5aJUA0krLWK5omwrEsjJ?=
 =?us-ascii?q?UTtUTDHijtmEXqlqOWckIk9fSy5OTjf7rmoZqcOJV1igH4Kqgum8q/DvokMg?=
 =?us-ascii?q?UWW2WX5P6w2KDg8EHnWrlGk/w7n6nDvJzHJMkXvqu5DBVU0oYn5Ra/FTCm0N?=
 =?us-ascii?q?EAkHkJNl1KYxyHgpPyO1HNIPH4C+mwg0i2nDhw2f/KJqfhDYnVLnjfjLfheq?=
 =?us-ascii?q?5w5FNGxwot099f4olZBawbL/LtREDxsdjYDhg3Mwyo2ernDsty1p8GU2KVHq?=
 =?us-ascii?q?CZKL/SsUOP5u83IOmMeZQatyzmJvgm+fHul3k5lkEZfaWz2psXcn+4FOx8I0?=
 =?us-ascii?q?qFeXrsnssBEWASswo4UuPqlECNXiBNZ3upQaI86S80CJi8AYfAWI+tmrqB0z?=
 =?us-ascii?q?m/HpFMYWBGEF+MG2/yd4qYQ/cMdD6SIsh5nzwcTrihS5Eu1RW0uw/g0LdnKf?=
 =?us-ascii?q?TU+isCuZLkzth16PXZlQsu+jxsE8Sdz2aNQnlpkWwWWT87x6d/oVRjxVeFz6?=
 =?us-ascii?q?h4mPJZFd1P5/xVUgc2L5ncz/Z1C9rqQALOYs+JSEq6QtWhGTwxQMg+zMQAY0?=
 =?us-ascii?q?tmANWijRDC3yy0DL8JjbCEH4I7oerg2C39Lthwzl7K3bcsil0hTNcJM2C6wu?=
 =?us-ascii?q?Z86gLaL43EiUOUk+Ctb6tYlCjA6GuO00KQs0xCFg19S6PIWTYYfESFg87+4x?=
 =?us-ascii?q?bsRrWvALJvHBFMxcOYK6BJIonnhF9IbOzgKdLTfyS7ljHjVl6z2rqQYd+yKC?=
 =?us-ascii?q?0m1yLHBR1cng=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2DgAgDggntf/xCltltgHAEBAQEBAQc?=
 =?us-ascii?q?BARIBAQQEAQFHgUiBHoJRX40/klaKWYctCwEBAQEBAQEBATUBAgQBAYRKgjs?=
 =?us-ascii?q?mOBMCAwEBAQMCBQEBBgEBAQEBAQUEAYYPRYI3IoNHCwEjI4E/EoMmglgpqhc?=
 =?us-ascii?q?zhBCBRINHgUKBOIgyhRqBQT+EX4o0BLdNgnGDE4RrklQPIqEfLZJnoimBek0?=
 =?us-ascii?q?gGIMkUBkNjisXjiZCMDcCBgoBAQMJVwE9AY0yAQE?=
X-IPAS-Result: =?us-ascii?q?A2DgAgDggntf/xCltltgHAEBAQEBAQcBARIBAQQEAQFHg?=
 =?us-ascii?q?UiBHoJRX40/klaKWYctCwEBAQEBAQEBATUBAgQBAYRKgjsmOBMCAwEBAQMCB?=
 =?us-ascii?q?QEBBgEBAQEBAQUEAYYPRYI3IoNHCwEjI4E/EoMmglgpqhczhBCBRINHgUKBO?=
 =?us-ascii?q?IgyhRqBQT+EX4o0BLdNgnGDE4RrklQPIqEfLZJnoimBek0gGIMkUBkNjisXj?=
 =?us-ascii?q?iZCMDcCBgoBAQMJVwE9AY0yAQE?=
Received: from 16.165-182-91.adsl-dyn.isp.belgacom.be (HELO localhost.localdomain) ([91.182.165.16])
  by relay.skynet.be with ESMTP; 05 Oct 2020 22:37:25 +0200
From:   Fabian Frederick <fabf@skynet.be>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     pshelar@ovn.org, dev@openvswitch.org,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 8/9 net-next] net: openvswitch: use dev_sw_netstats_rx_add()
Date:   Mon,  5 Oct 2020 22:37:03 +0200
Message-Id: <20201005203703.55486-1-fabf@skynet.be>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

use new helper for netstats settings

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/openvswitch/vport-internal_dev.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/net/openvswitch/vport-internal_dev.c b/net/openvswitch/vport-internal_dev.c
index 58a7b8312c289..d8fe66eea206b 100644
--- a/net/openvswitch/vport-internal_dev.c
+++ b/net/openvswitch/vport-internal_dev.c
@@ -225,7 +225,6 @@ static void internal_dev_destroy(struct vport *vport)
 static netdev_tx_t internal_dev_recv(struct sk_buff *skb)
 {
 	struct net_device *netdev = skb->dev;
-	struct pcpu_sw_netstats *stats;
 
 	if (unlikely(!(netdev->flags & IFF_UP))) {
 		kfree_skb(skb);
@@ -240,12 +239,7 @@ static netdev_tx_t internal_dev_recv(struct sk_buff *skb)
 	skb->pkt_type = PACKET_HOST;
 	skb->protocol = eth_type_trans(skb, netdev);
 	skb_postpull_rcsum(skb, eth_hdr(skb), ETH_HLEN);
-
-	stats = this_cpu_ptr(netdev->tstats);
-	u64_stats_update_begin(&stats->syncp);
-	stats->rx_packets++;
-	stats->rx_bytes += skb->len;
-	u64_stats_update_end(&stats->syncp);
+	dev_sw_netstats_rx_add(netdev, skb->len);
 
 	netif_rx(skb);
 	return NETDEV_TX_OK;
-- 
2.28.0

