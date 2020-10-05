Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D17428410A
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 22:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729206AbgJEUfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 16:35:41 -0400
Received: from mailrelay115.isp.belgacom.be ([195.238.20.142]:49414 "EHLO
        mailrelay115.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725901AbgJEUfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 16:35:40 -0400
IronPort-SDR: iV/6qVTijZF9FGv5C+vBkRl/DzMIj/Mob6Aa5MbG27kimPkBv35oaW9GiP/jpLlTcc/1qi1TDC
 MlwviKtVJLhC/0Oy43UtaKnv0Ig0s8c2r+7q0mCISBpGhoqPx9OgwuYMjL3WJpKqtTrjgmrkux
 ahEZHkNpDk730fpIYq2GtO0ALAMsFjReLU3Omxm5KzTRMUNGS2thhWKaqZ52YJOF+3U2KQLaWc
 HmG1AKwinT65xxrnOLNenkyL/fE6feQGK4c+oiat+VEW9QuTlxtnm2LYLwUxUj6VuHZx+lgfT2
 ukM=
X-Belgacom-Dynamic: yes
IronPort-PHdr: =?us-ascii?q?9a23=3AwndjwBfRQq2ncymabO8FBPn7lGMj4u6mDksu8p?=
 =?us-ascii?q?Mizoh2WeGdxcWyZB7h7PlgxGXEQZ/co6odzbaP7Oa8AydZus/JmUtBWaQEbw?=
 =?us-ascii?q?UCh8QSkl5oK+++Imq/EsTXaTcnFt9JTl5v8iLzG0FUHMHjew+a+SXqvnYdFR?=
 =?us-ascii?q?rlKAV6OPn+FJLMgMSrzeCy/IDYbxlViDanbr5+MRe7oR/eu8UIjoduN6g8xg?=
 =?us-ascii?q?bUqXZUZupawn9lK0iOlBjm/Mew+5Bj8yVUu/0/8sNLTLv3caclQ7FGFToqK2?=
 =?us-ascii?q?866tHluhnFVguP+2ATUn4KnRpSAgjK9w/1U5HsuSbnrOV92S2aPcrrTbAoXD?=
 =?us-ascii?q?mp8qlmRAP0hCoBKjU09nzchM5tg6JBuB+vpwJxzZPabo+WM/RxcazTcMgGSW?=
 =?us-ascii?q?dCRMtdSzZMDp+gY4YJEuEPPfxYr474p1YWrRWxHxKjBOL1xT9Om3T43bc63P?=
 =?us-ascii?q?o8Hg7YxgwgHs4BsHfJp9jyOqcdS/u6zKfTwDXYbPNX2TH955bUchw7uv6DQ6?=
 =?us-ascii?q?t9fMzMwkYgCw3LlE+fqZD5PzyLzOQNtXCW4eRjWO+ri2AqqgF8riahy8ksl4?=
 =?us-ascii?q?TFmp8ZxkzF+Ct2z4g4ONO1RVBmbNOkEpZdqS6UO5d4TM0tR2xmuCY0xqMCtJ?=
 =?us-ascii?q?O9YSMEy4wnygbbZvCaaYSE/xHuWPiLLTtlhX9oeKiziwuz/EWm1+byTNO70E?=
 =?us-ascii?q?xQoSpAitTMs3cN2AHN5cWfUft9+1uh2S6I1wDO9uFIOUA0mrTfK54m2rMwkp?=
 =?us-ascii?q?0TvljZES/ymEX2i7SWdlk+9uis7OTofq/pppuBOI9zjwHxKKUumsqnDeQ5NA?=
 =?us-ascii?q?gBQXSb9Py42bH+50H1XbZHguMsnqXEsZ3XJd4XqrO4DgNN14Ys8Re/DzOo0N?=
 =?us-ascii?q?QCmnkHKUpIeBydgIfyNVHDO+v4DfS/glSqjjhr2+rKMab/DZnVNHjMjK/hfa?=
 =?us-ascii?q?ph605b0Ac80MpQ54xKBbEEO//8R1X+tMLGAR88Nwy0xOjnCMln2oMYR22PHr?=
 =?us-ascii?q?eTMLnOvl+Q+uIvP+6MaZcWuDbgMPcq/eXjjXwnll8He6mmw58XZGq/HvR8LE?=
 =?us-ascii?q?WTeWDsjcsZEWcWogo+S/TniFucXj5Penm9Qbw86yolCIKpE4jDXJqhgL+f0y?=
 =?us-ascii?q?ehGJ1ZeGRGBkqLEXfyeIWOQ+0MZz6KIs99jjwEUqCsS4E72h61ug/30KFnLu?=
 =?us-ascii?q?nU+y0eq53jyMJ56PbNmkJ6yTshA82D3mSlQ2hqk2YMQDEqmqZyvQg1yUqJ2I?=
 =?us-ascii?q?B7juZeGNgV4OlGFk88OILQwvJSFd//QETCc82PRVLgRc+pUh8rSddk7dYEYk?=
 =?us-ascii?q?97U/u4gxzOxSuhAPdBmbWBCrQv8bPa0mS3LcsrmCWO77Uok1RzGpgHDmahnK?=
 =?us-ascii?q?MqrwU=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2C8CADggntf/xCltltgHAEBAQEBAQc?=
 =?us-ascii?q?BARIBAQQEAQFHgUgCgRyCUV+NP5JWilmFMYF8CwEBAQEBAQEBATUBAgQBAYR?=
 =?us-ascii?q?KgjsmOgQNAgMBAQEDAgUBAQYBAQEBAQEFBAGGD0WCNyKDRwsBIyOBPxKDJoJ?=
 =?us-ascii?q?YKaoXM4QQgUSDR4FCgTiIMoUagUE/gRGDToo0BLdNgnGDE4RrklQPIqEfLZJ?=
 =?us-ascii?q?nm2KGSgyBa00gGIMkUBkNnGhCMDcCBgoBAQMJVwE9AY0yAQE?=
X-IPAS-Result: =?us-ascii?q?A2C8CADggntf/xCltltgHAEBAQEBAQcBARIBAQQEAQFHg?=
 =?us-ascii?q?UgCgRyCUV+NP5JWilmFMYF8CwEBAQEBAQEBATUBAgQBAYRKgjsmOgQNAgMBA?=
 =?us-ascii?q?QEDAgUBAQYBAQEBAQEFBAGGD0WCNyKDRwsBIyOBPxKDJoJYKaoXM4QQgUSDR?=
 =?us-ascii?q?4FCgTiIMoUagUE/gRGDToo0BLdNgnGDE4RrklQPIqEfLZJnm2KGSgyBa00gG?=
 =?us-ascii?q?IMkUBkNnGhCMDcCBgoBAQMJVwE9AY0yAQE?=
Received: from 16.165-182-91.adsl-dyn.isp.belgacom.be (HELO localhost.localdomain) ([91.182.165.16])
  by relay.skynet.be with ESMTP; 05 Oct 2020 22:35:38 +0200
From:   Fabian Frederick <fabf@skynet.be>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 4/9 net-next] bareudp: use dev_sw_netstats_rx_add()
Date:   Mon,  5 Oct 2020 22:35:15 +0200
Message-Id: <20201005203515.55280-1-fabf@skynet.be>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

use new helper for netstats settings

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/bareudp.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index 841910f1db655..ff0bea1554f9b 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -54,7 +54,6 @@ struct bareudp_dev {
 static int bareudp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 {
 	struct metadata_dst *tun_dst = NULL;
-	struct pcpu_sw_netstats *stats;
 	struct bareudp_dev *bareudp;
 	unsigned short family;
 	unsigned int len;
@@ -160,13 +159,9 @@ static int bareudp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 
 	len = skb->len;
 	err = gro_cells_receive(&bareudp->gro_cells, skb);
-	if (likely(err == NET_RX_SUCCESS)) {
-		stats = this_cpu_ptr(bareudp->dev->tstats);
-		u64_stats_update_begin(&stats->syncp);
-		stats->rx_packets++;
-		stats->rx_bytes += len;
-		u64_stats_update_end(&stats->syncp);
-	}
+	if (likely(err == NET_RX_SUCCESS))
+		dev_sw_netstats_rx_add(bareudp->dev, len);
+
 	return 0;
 drop:
 	/* Consume bad packet */
-- 
2.28.0

