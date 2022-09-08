Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC35D5B126A
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 04:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbiIHCW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 22:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiIHCW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 22:22:56 -0400
Received: from m12-12.163.com (m12-12.163.com [220.181.12.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 04D8AB56E2;
        Wed,  7 Sep 2022 19:22:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=AZWIX
        NnkX3ErlisVUb2M5Rru5jbGkoNRar4HCqxI8lU=; b=VrbwZmERR+z41tduuvjcJ
        Z1EPrUkqBeBQFRMmegMJcPLFULq8gFUC2LI9EqbPYdkx9elu4DVzqqdjgMX6BLiC
        mAaASt1YjsiJjm29bmDHGj8wQeKU7pTwpfFCSbgteUrTYE3x3FRJCv/xKuJ5X1S/
        yHBCZ+Ew5HSwaFQU+TlnPU=
Received: from f00160-VMware-Virtual-Platform.localdomain (unknown [1.203.67.201])
        by smtp8 (Coremail) with SMTP id DMCowAAXzTGhURljKjUEZw--.19744S4;
        Thu, 08 Sep 2022 10:21:33 +0800 (CST)
From:   Jingyu Wang <jingyuwang_vip@163.com>
To:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jingyu Wang <jingyuwang_vip@163.com>
Subject: [PATCH] net: ipv4: Fix some coding style in ah4.c file
Date:   Thu,  8 Sep 2022 10:21:18 +0800
Message-Id: <20220908022118.57973-1-jingyuwang_vip@163.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DMCowAAXzTGhURljKjUEZw--.19744S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7KFWxXryxWr48Ar1rGw45Wrg_yoW8GF43pF
        4Dua4UtFW8Jw4xtF1UAF1ku34Yk3s7KFW7W34Dtw1ft3Z8uFy5WF1FyrWSyF4rWFWrGayx
        XFyYyrWUJw1rJrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pEID7sUUUUU=
X-Originating-IP: [1.203.67.201]
X-CM-SenderInfo: 5mlqw5xxzd0whbyl1qqrwthudrp/1tbiyQ12F2I66z5yrQAAs3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix some checkpatch.pl complained about in ah4.c

Signed-off-by: Jingyu Wang <jingyuwang_vip@163.com>
---
 net/ipv4/ah4.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/ah4.c b/net/ipv4/ah4.c
index f8ad04470d3a..fe4715e7c80e 100644
--- a/net/ipv4/ah4.c
+++ b/net/ipv4/ah4.c
@@ -93,7 +93,7 @@ static int ip_clear_mutable_options(const struct iphdr *iph, __be32 *daddr)
 			continue;
 		}
 		optlen = optptr[1];
-		if (optlen<2 || optlen>l)
+		if (optlen < 2 || optlen > l)
 			return -EINVAL;
 		switch (*optptr) {
 		case IPOPT_SEC:
@@ -165,7 +165,8 @@ static int ah_output(struct xfrm_state *x, struct sk_buff *skb)
 	ahp = x->data;
 	ahash = ahp->ahash;
 
-	if ((err = skb_cow_data(skb, 0, &trailer)) < 0)
+	err = skb_cow_data(skb, 0, &trailer));
+	if (err < 0)
 		goto out;
 	nfrags = err;
 
@@ -352,7 +353,8 @@ static int ah_input(struct xfrm_state *x, struct sk_buff *skb)
 	skb->ip_summed = CHECKSUM_NONE;
 
 
-	if ((err = skb_cow_data(skb, 0, &trailer)) < 0)
+	err = skb_cow_data(skb, 0, &trailer);
+	if (err < 0)
 		goto out;
 	nfrags = err;
 
@@ -553,8 +555,7 @@ static int ah4_rcv_cb(struct sk_buff *skb, int err)
 	return 0;
 }
 
-static const struct xfrm_type ah_type =
-{
+static const struct xfrm_type ah_type = {
 	.owner		= THIS_MODULE,
 	.proto	     	= IPPROTO_AH,
 	.flags		= XFRM_TYPE_REPLAY_PROT,

base-commit: 5957ac6635a1a12d4aa2661bbf04d3085a73372a
-- 
2.34.1

