Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC24C398157
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 08:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbhFBGo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 02:44:56 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:3334 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbhFBGow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 02:44:52 -0400
Received: from dggeme760-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Fvzr20nCMz19S8D;
        Wed,  2 Jun 2021 14:38:26 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeme760-chm.china.huawei.com (10.3.19.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 2 Jun 2021 14:43:07 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <steffen.klassert@secunet.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] ipv6: Fix spelling mistakes
Date:   Wed, 2 Jun 2021 14:56:46 +0800
Message-ID: <20210602065646.106780-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix some spelling mistakes in comments:
wont  ==> won't
hight  ==> height
execeeds  ==> exceeds
accomodate  ==> accommodate
informations  ==> information
destionation  ==> destination

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 net/ipv6/ah6.c         | 2 +-
 net/ipv6/esp6.c        | 4 ++--
 net/ipv6/ip6_fib.c     | 2 +-
 net/ipv6/ip6_vti.c     | 2 +-
 net/ipv6/output_core.c | 2 +-
 net/ipv6/reassembly.c  | 2 +-
 net/ipv6/udp.c         | 2 +-
 7 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/ipv6/ah6.c b/net/ipv6/ah6.c
index 20d492da725a..05176c507fb1 100644
--- a/net/ipv6/ah6.c
+++ b/net/ipv6/ah6.c
@@ -144,7 +144,7 @@ static bool zero_out_mutable_opts(struct ipv6_opt_hdr *opthdr)
 /**
  *	ipv6_rearrange_destopt - rearrange IPv6 destination options header
  *	@iph: IPv6 header
- *	@destopt: destionation options header
+ *	@destopt: destination options header
  */
 static void ipv6_rearrange_destopt(struct ipv6hdr *iph, struct ipv6_opt_hdr *destopt)
 {
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index 393ae2b78e7d..e351022ffb24 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -344,7 +344,7 @@ static struct ip_esp_hdr *esp_output_set_esn(struct sk_buff *skb,
 					     struct esp_output_extra *extra)
 {
 	/* For ESN we move the header forward by 4 bytes to
-	 * accomodate the high bits.  We will move it back after
+	 * accommodate the high bits.  We will move it back after
 	 * encryption.
 	 */
 	if ((x->props.flags & XFRM_STATE_ESN)) {
@@ -894,7 +894,7 @@ static void esp_input_set_header(struct sk_buff *skb, __be32 *seqhi)
 	struct xfrm_state *x = xfrm_input_state(skb);
 
 	/* For ESN we move the header forward by 4 bytes to
-	 * accomodate the high bits.  We will move it back after
+	 * accommodate the high bits.  We will move it back after
 	 * decryption.
 	 */
 	if ((x->props.flags & XFRM_STATE_ESN)) {
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 679699e953f1..50b64fd7ec55 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -999,7 +999,7 @@ static int fib6_nh_drop_pcpu_from(struct fib6_nh *nh, void *_arg)
 static void fib6_drop_pcpu_from(struct fib6_info *f6i,
 				const struct fib6_table *table)
 {
-	/* Make sure rt6_make_pcpu_route() wont add other percpu routes
+	/* Make sure rt6_make_pcpu_route() won't add other percpu routes
 	 * while we are cleaning them here.
 	 */
 	f6i->fib6_destroying = 1;
diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
index 2d048e21abbb..0e727d38f03f 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -440,7 +440,7 @@ static bool vti6_state_check(const struct xfrm_state *x,
  * vti6_xmit - send a packet
  *   @skb: the outgoing socket buffer
  *   @dev: the outgoing tunnel device
- *   @fl: the flow informations for the xfrm_lookup
+ *   @fl: the flow information for the xfrm_lookup
  **/
 static int
 vti6_xmit(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
diff --git a/net/ipv6/output_core.c b/net/ipv6/output_core.c
index af36acc1a644..4a51e705c307 100644
--- a/net/ipv6/output_core.c
+++ b/net/ipv6/output_core.c
@@ -32,7 +32,7 @@ static u32 __ipv6_select_ident(struct net *net,
 	hash = siphash(&combined, sizeof(combined), &net->ipv4.ip_id_key);
 
 	/* Treat id of 0 as unset and if we get 0 back from ip_idents_reserve,
-	 * set the hight order instead thus minimizing possible future
+	 * set the height order instead thus minimizing possible future
 	 * collisions.
 	 */
 	id = ip_idents_reserve(hash, 1);
diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index 28e44782c94d..e6ef5b2622d6 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -182,7 +182,7 @@ static int ip6_frag_queue(struct frag_queue *fq, struct sk_buff *skb,
 
 	/* Note : skb->rbnode and skb->dev share the same location. */
 	dev = skb->dev;
-	/* Makes sure compiler wont do silly aliasing games */
+	/* Makes sure compiler won't do silly aliasing games */
 	barrier();
 
 	prev_tail = fq->q.fragments_tail;
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 199b080d418a..0638090214ff 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -304,7 +304,7 @@ struct sock *udp6_lib_lookup(struct net *net, const struct in6_addr *saddr, __be
 EXPORT_SYMBOL_GPL(udp6_lib_lookup);
 #endif
 
-/* do not use the scratch area len for jumbogram: their length execeeds the
+/* do not use the scratch area len for jumbogram: their length exceeds the
  * scratch area space; note that the IP6CB flags is still in the first
  * cacheline, so checking for jumbograms is cheap
  */
-- 
2.25.1

