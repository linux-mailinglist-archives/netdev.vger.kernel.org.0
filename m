Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BFE7253E1F
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 08:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbgH0GtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 02:49:17 -0400
Received: from mailrelay116.isp.belgacom.be ([195.238.20.143]:45455 "EHLO
        mailrelay116.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726123AbgH0GtR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 02:49:17 -0400
IronPort-SDR: M89Lnt8T9St0Qw5ATvBGJvPHEtvn+73Xd8vWOHksDqFFlqiso6Et0zX/vo2GsZTC9XvHrt9Tgq
 A0fz7swgYCaYqA+R3Nqf/goZMg3m02qaUOso7ujDNddUJEKeC87kaFzAYMcrwZcHQkD/oySd3W
 fDBM72plmCLGtN87alyyPxuBd7olpemXCznFZX+hxDcQmRFWv2bmpumzNkxjudgXQmvgeL8KwI
 cq1WdGCSQW17dm9TkzPIjyaQqPHfpHtmuKtBjaPVj65oBxE6QhPme8lbL3kzsS97VkqAiuL2ea
 L+4=
X-Belgacom-Dynamic: yes
IronPort-PHdr: =?us-ascii?q?9a23=3AQ/lVvR8FKQvLMv9uRHKM819IXTAuvvDOBiVQ1K?=
 =?us-ascii?q?B+0+kXIJqq85mqBkHD//Il1AaPAdyFrase0KGP6/yocFdDyK7JiGoFfp1IWk?=
 =?us-ascii?q?1NouQttCtkPvS4D1bmJuXhdS0wEZcKflZk+3amLRodQ56mNBXdrXKo8DEdBA?=
 =?us-ascii?q?j0OxZrKeTpAI7SiNm82/yv95HJbAhEmTuwbalvIBmoowjdudQajZdtJ60s1h?=
 =?us-ascii?q?bHv3xEdvhMy2h1P1yThRH85smx/J5n7Stdvu8q+tBDX6vnYak2VKRUAzs6PW?=
 =?us-ascii?q?874s3rrgTDQhCU5nQASGUWkwFHDBbD4RrnQ5r+qCr6tu562CmHIc37SK0/VD?=
 =?us-ascii?q?q+46t3ThLjlSEKPCM7/m7KkMx9lKJVrgy8qRJxwIDaZ46aOvVlc6/Bft4XX3?=
 =?us-ascii?q?ZNU9xNWyBdBI63cosBD/AGPeZdt4Tzp0EBogC/BQa2AuPk1z9GhmXo0qInze?=
 =?us-ascii?q?shCwDG0xAjH9kTt3nUos/6O7wcUe2u16nIzjXCb/VI1jfh8oTHaQ4urOiKUL?=
 =?us-ascii?q?ltfsXf1VMhGBnZjlWMt4PlJTWV2/wDvWWY6+duVeOihm45pwx/ojai29sghp?=
 =?us-ascii?q?TVio8UxV7K+jh0zYgrKNClSEN2Y8CpHpRMuy+UOIV7RsMsTWF2tCs+zLANpJ?=
 =?us-ascii?q?21fDASxZkj2hLTceGLfouW7h75SeqcIDd1iGh4dL++gRu57FKuxffmVsau1V?=
 =?us-ascii?q?ZHti9Fkt7RuX8TzxHT8c2HSudl/kemxDaPyxjf6uFaLkAwkqrWM5ohwrksmZ?=
 =?us-ascii?q?UJtUTDHij2mF7qjKOMckUk/fSn5P7jYrr7oZ+cMpV7igD4Mqg2m8y/B/o3Mh?=
 =?us-ascii?q?QWUmWf5OiwzqDv8E7nTLlQk/E7k6nUvIrHKckavqK5BhVa0ocn6xaxFTem19?=
 =?us-ascii?q?EYkGEJLF1fYx2HgZPkO0rNIPH4C/ewnUisnC1wyP/YJrHhGInCLmDfkLf9er?=
 =?us-ascii?q?Zw81NTxxAtzd9B4pJZEawOL+jtWkDvsdzYChg5MwKow+r9DtVyyJ8eU3qVAq?=
 =?us-ascii?q?CFKKPSrUOI5uU3LumPeY8aoyzyJuMm5/Hwl385n0ESfa2z0ZsQcnC4EexsI1?=
 =?us-ascii?q?+Fbnr0ntcBDWAKsxI4TOP0lF2NTCBcZ2ipUqIi6TE0FpimAZ3ARo+zmryB2j?=
 =?us-ascii?q?m0HplMamBBEFCMHm/id5+YVPcUdCKSPshhnyQAVbigTY8hyB6vuBb5y7V5NO?=
 =?us-ascii?q?rU/DMXtZb42dhr6O3ciwsy+SZ3D8uDyWGNSX97nmcSSz8xxqB/rlR3yk2f3q?=
 =?us-ascii?q?hgn/xYCdtT6utHUgggLpHcwfd3C8vxWgPBeNeGVkqmTs+9Dj4vHZoNxIoCal?=
 =?us-ascii?q?hwHv2uhw7O2i6tDaNTkbGXQNQ376jV93v8PcBwzzDBzqZyoUMhR55hPGenj6?=
 =?us-ascii?q?g32RLeC4PTkk6a3/KkfK4S9DXO5WGO0SyEsRcLA0ZLTazZUCVHNQPtptPj6x?=
 =?us-ascii?q?aaQg=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2CCBAD4Vkdf/xCltltfgRCBQ4EeglB?=
 =?us-ascii?q?fjTiSS5ICCwEBAQEBAQEBATQBAgQBAYRMgjslNwYOAgMBAQEDAgUBAQYBAQE?=
 =?us-ascii?q?BAQEFBAGGD0WCNyKDRwsBIyOBPxKDJoJYKbMaM4QQgUODRYFCgTiIJ4UZgUE?=
 =?us-ascii?q?/hF+KNAS2UoJtgwyEXJI2DyGgRJJLoVyBe00gGIMkUBkNnGhCMDcCBgoBAQM?=
 =?us-ascii?q?JVwE9AZATAQE?=
X-IPAS-Result: =?us-ascii?q?A2CCBAD4Vkdf/xCltltfgRCBQ4EeglBfjTiSS5ICCwEBA?=
 =?us-ascii?q?QEBAQEBATQBAgQBAYRMgjslNwYOAgMBAQEDAgUBAQYBAQEBAQEFBAGGD0WCN?=
 =?us-ascii?q?yKDRwsBIyOBPxKDJoJYKbMaM4QQgUODRYFCgTiIJ4UZgUE/hF+KNAS2UoJtg?=
 =?us-ascii?q?wyEXJI2DyGgRJJLoVyBe00gGIMkUBkNnGhCMDcCBgoBAQMJVwE9AZATAQE?=
Received: from 16.165-182-91.adsl-dyn.isp.belgacom.be (HELO localhost.localdomain) ([91.182.165.16])
  by relay.skynet.be with ESMTP; 27 Aug 2020 08:49:13 +0200
From:   Fabian Frederick <fabf@skynet.be>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 1/7 net-next] vxlan: don't collect metadata if remote checksum is wrong
Date:   Thu, 27 Aug 2020 08:48:56 +0200
Message-Id: <20200827064856.5580-1-fabf@skynet.be>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

call vxlan_remcsum() before md filling in vxlan_rcv()

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/vxlan.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index b9fefe27e3e89..47c762f7f5b11 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -1875,6 +1875,10 @@ static int vxlan_rcv(struct sock *sk, struct sk_buff *skb)
 				   !net_eq(vxlan->net, dev_net(vxlan->dev))))
 		goto drop;
 
+	if (vs->flags & VXLAN_F_REMCSUM_RX)
+		if (!vxlan_remcsum(&unparsed, skb, vs->flags))
+			goto drop;
+
 	if (vxlan_collect_metadata(vs)) {
 		struct metadata_dst *tun_dst;
 
@@ -1891,9 +1895,6 @@ static int vxlan_rcv(struct sock *sk, struct sk_buff *skb)
 		memset(md, 0, sizeof(*md));
 	}
 
-	if (vs->flags & VXLAN_F_REMCSUM_RX)
-		if (!vxlan_remcsum(&unparsed, skb, vs->flags))
-			goto drop;
 	if (vs->flags & VXLAN_F_GBP)
 		vxlan_parse_gbp_hdr(&unparsed, skb, vs->flags, md);
 	/* Note that GBP and GPE can never be active together. This is
-- 
2.27.0

