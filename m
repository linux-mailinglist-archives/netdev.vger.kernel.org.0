Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48E5028417B
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 22:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729581AbgJEUhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 16:37:14 -0400
Received: from mailrelay115.isp.belgacom.be ([195.238.20.142]:49542 "EHLO
        mailrelay115.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729231AbgJEUhI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 16:37:08 -0400
IronPort-SDR: xfM8e/s1NvphrdxcbvW6sCe8mwA2VxAVB2FptAZCmpWkWCXmm9cEOK64z/Fqccf/7JTBwzxAfp
 +CAkOZ2wflT2+WExnAGHPkLK2LZ5KDc95IUQRvPoSh1zzcoEeTUKY+/b7pSeVEfQXEVwkj1NFx
 B8AS0xNzsCnzSqa4k43iafdxfOsda1AG2lYRtmUsuNwm/FQkEdnA1ctvPJSFGPbvD9RwauvAuY
 UNdwH2YgL0dsdSICRhUP8eNsUo2EbbS+hLJiikRPMiun68jM484x6+yPVIoV646Dhz4VLFmQ/h
 HKk=
X-Belgacom-Dynamic: yes
IronPort-PHdr: =?us-ascii?q?9a23=3ARtwPrBHqZQfNcwxVw1VFkJ1GYnF86YWxBRYc79?=
 =?us-ascii?q?8ds5kLTJ76ps64bnLW6fgltlLVR4KTs6sC17OJ9fy6EjVbuN6oizMrSNR0TR?=
 =?us-ascii?q?gLiMEbzUQLIfWuLgnFFsPsdDEwB89YVVVorDmROElRH9viNRWJ+iXhpTEdFQ?=
 =?us-ascii?q?/iOgVrO+/7BpDdj9it1+C15pbffxhEiCCybL9vLhi6twrcutcZjYd/JKs91w?=
 =?us-ascii?q?bCr2dVdehR2W5mP0+YkQzm5se38p5j8iBQtOwk+sVdT6j0fLk2QKJBAjg+PG?=
 =?us-ascii?q?87+MPktR/YTQuS/XQcSXkZkgBJAwfe8h73WIr6vzbguep83CmaOtD2TawxVD?=
 =?us-ascii?q?+/4apnVAPkhSEaPDM/7WrZiNF/jLhDrRyhuRJx3oDaboKSOvVxca3QZs8WSG?=
 =?us-ascii?q?lbU8pNTSFNHp+wYo0SBOQBJ+ZYqIz9qkMOoxSkHgasBfngyjlVjXH2x601zf?=
 =?us-ascii?q?kuHh/c3AwhA90Os2nfodL7NKgISu+1wrLFzS7Ab/JW3zfy9pTIfgo6rv6SRL?=
 =?us-ascii?q?99d9faxkYzGQ3flFqQtZDlMC2P1uQLq2WV4eltWOavhWMmqwx9vDaiyMcxh4?=
 =?us-ascii?q?XVm44Z1lHJ+yp2zosoK9C1VlN2bN6mHZZOuC+WK4V4TMwmTm9ouCg21LkLtJ?=
 =?us-ascii?q?imdyYJ0JQq3xrSZ+Gdf4SV4R/vSvydLSp5iX9lYr6zmhe//E69wePmTMa0yk?=
 =?us-ascii?q?xFri9dn9nJsXACygLc59CcSvt44kehwTGP1x3P6u1cIUA7i67bK5k5z740kZ?=
 =?us-ascii?q?ocrV7MHiv2mEXxl6+Wal8o+uyv6+v7eLrmooKTN4hxig7kM6QunNSzAeU+Mg?=
 =?us-ascii?q?cQQ2iW4eCx2KD58UHkQ7hGkOc6nrTYvZ3aP8gXu6+0DxdQ0ok56ha/Czmm0M?=
 =?us-ascii?q?4fnXkCNF9FdgiIgJPnO1zVO/D4Dve+g1Kynzd33fzJJaPuDo3XLnffiLfhYa?=
 =?us-ascii?q?p960lExQUu199f+YxbCrQaLf3uQEDxqsLXDho9MwyzzebnFM9x1oUAVmKTGq?=
 =?us-ascii?q?WZKr/dsUeU5uIzJOmBfIwVuCvmJPc//PPujmE2mUUbfaa32Zsbcne4Hu5pI0?=
 =?us-ascii?q?+Be3rjns8BEXsWvgo5VOHqjkONUSJOaHmsQaIx/S87CI24AofZXIytg6KO3D?=
 =?us-ascii?q?29HpJIYmBKEFeMEW3nd4+cQfcDdDqSItN9kjwDTbWhUJMh2g+gtA/01bVnKP?=
 =?us-ascii?q?DY+i4ctZ35z9h1/PPclQsu9TFvFMSSzX2CT3xynmwWWz86xrxwoUt4yl2by6?=
 =?us-ascii?q?h3n+RYFcBP5/NOSgo6NYDTz/ZhBN/sQALBYsyESFmhQtWgHD4xScgxz8UUbE?=
 =?us-ascii?q?ZlAdqiiArM0zCtA78PmLyHHoY78r/E1XjrO8l902rG1LUmj1Q+TMtAL3aphq?=
 =?us-ascii?q?Bk+gjIBI7Ik0OZmLi2dagGxyHC6jTL8W3bsEhGXQtYXazbUHUbYUXK69L0+g?=
 =?us-ascii?q?eKTKKkAJwkPxFHxMrELbFFLpXvgElKSenLJtvTeSSyln22CBLOwamDP6TwfG?=
 =?us-ascii?q?BI8izXCUEC2y4J8HqLLwk1BW/1rWvUAhR1FkPpbl+q++Qo+yDzdVM90wzfNx?=
 =?us-ascii?q?4p7LGy4BNA3fE=3D?=
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
  by relay.skynet.be with ESMTP; 05 Oct 2020 22:37:06 +0200
From:   Fabian Frederick <fabf@skynet.be>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 7/9 net-next] xfrm: use dev_sw_netstats_rx_add()
Date:   Mon,  5 Oct 2020 22:36:34 +0200
Message-Id: <20201005203634.55435-1-fabf@skynet.be>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

use new helper for netstats settings

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/xfrm/xfrm_interface.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index eb8181987620d..8f8631eafe784 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -210,7 +210,6 @@ static void xfrmi_scrub_packet(struct sk_buff *skb, bool xnet)
 static int xfrmi_rcv_cb(struct sk_buff *skb, int err)
 {
 	const struct xfrm_mode *inner_mode;
-	struct pcpu_sw_netstats *tstats;
 	struct net_device *dev;
 	struct xfrm_state *x;
 	struct xfrm_if *xi;
@@ -255,13 +254,7 @@ static int xfrmi_rcv_cb(struct sk_buff *skb, int err)
 	}
 
 	xfrmi_scrub_packet(skb, xnet);
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

