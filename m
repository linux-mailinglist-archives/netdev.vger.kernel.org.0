Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D4A284131
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 22:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728734AbgJEUgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 16:36:12 -0400
Received: from mailrelay115.isp.belgacom.be ([195.238.20.142]:49467 "EHLO
        mailrelay115.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725864AbgJEUgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 16:36:12 -0400
IronPort-SDR: iyoHWhF0CvKnOQjjHNp6VQqthifw0gpxVK6tEJ5Iwp4D0TcgwJmU4yOkhhiVkKVEejjG0FfAjF
 pYEflkJdiyF0k7bUBJJXQxBZtGCH7vSG4G1T263Wrppuu+tscmDhF9k1qRmPIHBQSgPcwKOTh2
 zBy7uht0P9k88k4Yk3dvNmgEO4yDmHMZw6xT7FX9l9A2Y8ysBhxX424gNe/a1uwO3OrRMtsPlp
 +Z0lYDEC1val80y85LD8VNrlLokE1QlfEUdovlIry5WTxTvlPfcTQYNOY+8FvmteqRQOe4VTiO
 kaQ=
X-Belgacom-Dynamic: yes
IronPort-PHdr: =?us-ascii?q?9a23=3AnonfNxYE0pGCq3+84mZhjub/LSx+4OfEezUN45?=
 =?us-ascii?q?9isYplN5qZpsyzZB7h7PlgxGXEQZ/co6odzbaP7Oa8AydZus/JmUtBWaQEbw?=
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
 =?us-ascii?q?ehGJ1ZeGRGBkqLEXfyeIWOQ+0MZz6KIs99jjwEUqCsS5c72h61sA/6zKFqLu?=
 =?us-ascii?q?zK9S0Eu5Lj1dx15/HNmhEo7zB0CN6d026VRWFugmwIXyM23Lx4oUFlzleMy6?=
 =?us-ascii?q?Z4g/tCFdxc+fxESQg6NZjBz+x/DNDyXAHBfsyTRFahWNWmDik7TsgtzN8Wf0?=
 =?us-ascii?q?Z9B9KigwjN3yWwGLAVmaeGBIc38qPc2Xj+Odp9x2zd26Y/3BEaRZ5DPHOrg4?=
 =?us-ascii?q?Zz/hbeAorOnVnfkau2MewfwSTE3GSO12yDuAdfSgE0GaPIQXwSeGPIotnjoE?=
 =?us-ascii?q?DPVbmjDfIgKAQS59SFL/5kY9fohFMOau3uNNnEYmmy0zO+DByG7qiPfYznZy?=
 =?us-ascii?q?MX0XOOWwA/jwkP8CPeZkAFDSC7rjeGAQ=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2DgAgDggntf/xCltltgHAEBAQEBAQc?=
 =?us-ascii?q?BARIBAQQEAQFHgUiBHoJRX40/klaKWYctCwEBAQEBAQEBATUBAgQBAYRKgjs?=
 =?us-ascii?q?mOBMCAwEBAQMCBQEBBgEBAQEBAQUEAYYPRYI3IoNHCwEjI4E/EoMmglgpqhc?=
 =?us-ascii?q?zhBCBRINHgUKBOIgyhRqBQT+EX4o0BLdNgnGDE4RrklQPIqEfLZJnoimBek0?=
 =?us-ascii?q?gGIMkUBkNnGhCMDcCBgoBAQMJVwE9AY0yAQE?=
X-IPAS-Result: =?us-ascii?q?A2DgAgDggntf/xCltltgHAEBAQEBAQcBARIBAQQEAQFHg?=
 =?us-ascii?q?UiBHoJRX40/klaKWYctCwEBAQEBAQEBATUBAgQBAYRKgjsmOBMCAwEBAQMCB?=
 =?us-ascii?q?QEBBgEBAQEBAQUEAYYPRYI3IoNHCwEjI4E/EoMmglgpqhczhBCBRINHgUKBO?=
 =?us-ascii?q?IgyhRqBQT+EX4o0BLdNgnGDE4RrklQPIqEfLZJnoimBek0gGIMkUBkNnGhCM?=
 =?us-ascii?q?DcCBgoBAQMJVwE9AY0yAQE?=
Received: from 16.165-182-91.adsl-dyn.isp.belgacom.be (HELO localhost.localdomain) ([91.182.165.16])
  by relay.skynet.be with ESMTP; 05 Oct 2020 22:36:10 +0200
From:   Fabian Frederick <fabf@skynet.be>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     pablo@netfilter.org, laforge@gnumonks.org,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 5/9 net-next] gtp: use dev_sw_netstats_rx_add()
Date:   Mon,  5 Oct 2020 22:35:46 +0200
Message-Id: <20201005203546.55332-1-fabf@skynet.be>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

use new helper for netstats settings

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/gtp.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index c09fe18c6c52d..030a1a5afe05a 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -182,8 +182,6 @@ static bool gtp_check_ms(struct sk_buff *skb, struct pdp_ctx *pctx,
 static int gtp_rx(struct pdp_ctx *pctx, struct sk_buff *skb,
 			unsigned int hdrlen, unsigned int role)
 {
-	struct pcpu_sw_netstats *stats;
-
 	if (!gtp_check_ms(skb, pctx, hdrlen, role)) {
 		netdev_dbg(pctx->dev, "No PDP ctx for this MS\n");
 		return 1;
@@ -204,11 +202,7 @@ static int gtp_rx(struct pdp_ctx *pctx, struct sk_buff *skb,
 
 	skb->dev = pctx->dev;
 
-	stats = this_cpu_ptr(pctx->dev->tstats);
-	u64_stats_update_begin(&stats->syncp);
-	stats->rx_packets++;
-	stats->rx_bytes += skb->len;
-	u64_stats_update_end(&stats->syncp);
+	dev_sw_netstats_rx_add(pctx->dev, skb->len);
 
 	netif_rx(skb);
 	return 0;
-- 
2.28.0

