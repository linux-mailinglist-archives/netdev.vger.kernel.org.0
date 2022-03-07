Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9553D4CEEFB
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 01:42:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233802AbiCGAm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 19:42:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231548AbiCGAmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 19:42:55 -0500
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D674C1EED7;
        Sun,  6 Mar 2022 16:42:00 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0V6O8xSI_1646613711;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0V6O8xSI_1646613711)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 07 Mar 2022 08:41:57 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     pablo@netfilter.org
Cc:     kadlec@netfilter.org, fw@strlen.de, roopa@nvidia.com,
        razor@blackwall.org, davem@davemloft.net, kuba@kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] netfilter: bridge: clean up some inconsistent indenting
Date:   Mon,  7 Mar 2022 08:41:49 +0800
Message-Id: <20220307004149.25171-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eliminate the follow smatch warning:

net/bridge/netfilter/nf_conntrack_bridge.c:385 nf_ct_bridge_confirm()
warn: inconsistent indenting.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 net/bridge/netfilter/nf_conntrack_bridge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index ebfb2a5c59e4..73242962be5d 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -381,7 +381,7 @@ static unsigned int nf_ct_bridge_confirm(struct sk_buff *skb)
 		protoff = skb_network_offset(skb) + ip_hdrlen(skb);
 		break;
 	case htons(ETH_P_IPV6): {
-		 unsigned char pnum = ipv6_hdr(skb)->nexthdr;
+		unsigned char pnum = ipv6_hdr(skb)->nexthdr;
 		__be16 frag_off;
 
 		protoff = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &pnum,
-- 
2.20.1.7.g153144c

