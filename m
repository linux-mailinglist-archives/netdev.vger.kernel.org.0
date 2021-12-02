Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7CB465F7A
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 09:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356217AbhLBIeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 03:34:18 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:33167 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1356173AbhLBIeR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 03:34:17 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R351e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0Uz9YROV_1638433849;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0Uz9YROV_1638433849)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 02 Dec 2021 16:30:53 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] gro: Fix inconsistent indenting
Date:   Thu,  2 Dec 2021 16:30:42 +0800
Message-Id: <1638433842-41235-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eliminate the follow smatch warning:

net/ipv6/ip6_offload.c:249 ipv6_gro_receive() warn: inconsistent
indenting.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 net/ipv6/ip6_offload.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
index 4867488..b29e9ba 100644
--- a/net/ipv6/ip6_offload.c
+++ b/net/ipv6/ip6_offload.c
@@ -247,9 +247,9 @@ INDIRECT_CALLABLE_SCOPE struct sk_buff *ipv6_gro_receive(struct list_head *head,
 		 * memcmp() alone below is sufficient, right?
 		 */
 		 if ((first_word & htonl(0xF00FFFFF)) ||
-		    !ipv6_addr_equal(&iph->saddr, &iph2->saddr) ||
-		    !ipv6_addr_equal(&iph->daddr, &iph2->daddr) ||
-		    *(u16 *)&iph->nexthdr != *(u16 *)&iph2->nexthdr) {
+		     !ipv6_addr_equal(&iph->saddr, &iph2->saddr) ||
+		     !ipv6_addr_equal(&iph->daddr, &iph2->daddr) ||
+		     *(u16 *)&iph->nexthdr != *(u16 *)&iph2->nexthdr) {
 not_same_flow:
 			NAPI_GRO_CB(p)->same_flow = 0;
 			continue;
-- 
1.8.3.1

