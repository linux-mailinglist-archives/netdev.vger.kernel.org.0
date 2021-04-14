Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF1F35F156
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 12:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233624AbhDNKOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 06:14:25 -0400
Received: from host.78.145.23.62.rev.coltfrance.com ([62.23.145.78]:34746 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S233551AbhDNKOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 06:14:22 -0400
Received: from bretzel (unknown [10.16.0.57])
        by proxy.6wind.com (Postfix) with ESMTPS id F1FCD9223F9;
        Wed, 14 Apr 2021 12:03:32 +0200 (CEST)
Received: from dichtel by bretzel with local (Exim 4.92)
        (envelope-from <dichtel@6wind.com>)
        id 1lWcMu-0003qZ-Ur; Wed, 14 Apr 2021 12:03:32 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com
Cc:     netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH net] vrf: fix a comment about loopback device
Date:   Wed, 14 Apr 2021 12:03:25 +0200
Message-Id: <20210414100325.14705-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a leftover of the below commit.

Fixes: 4f04256c983a ("net: vrf: Drop local rtable and rt6_info")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 drivers/net/vrf.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index cde8ffd182b0..7a02e0b6ff7c 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -471,9 +471,8 @@ static netdev_tx_t vrf_process_v6_outbound(struct sk_buff *skb,
 
 	skb_dst_drop(skb);
 
-	/* if dst.dev is loopback or the VRF device again this is locally
-	 * originated traffic destined to a local address. Short circuit
-	 * to Rx path
+	/* if dst.dev is the VRF device again this is locally originated traffic
+	 * destined to a local address. Short circuit to Rx path.
 	 */
 	if (dst->dev == dev)
 		return vrf_local_xmit(skb, dev, dst);
@@ -547,9 +546,8 @@ static netdev_tx_t vrf_process_v4_outbound(struct sk_buff *skb,
 
 	skb_dst_drop(skb);
 
-	/* if dst.dev is loopback or the VRF device again this is locally
-	 * originated traffic destined to a local address. Short circuit
-	 * to Rx path
+	/* if dst.dev is the VRF device again this is locally originated traffic
+	 * destined to a local address. Short circuit to Rx path.
 	 */
 	if (rt->dst.dev == vrf_dev)
 		return vrf_local_xmit(skb, vrf_dev, &rt->dst);
-- 
2.30.0

