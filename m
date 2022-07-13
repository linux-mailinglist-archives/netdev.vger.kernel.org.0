Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 706D8573A6E
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 17:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236499AbiGMPrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 11:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbiGMPrr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 11:47:47 -0400
Received: from m12-14.163.com (m12-14.163.com [220.181.12.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DAF424D4D1;
        Wed, 13 Jul 2022 08:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=Gx0E9
        ifIIIgWuwgilNQ8flq2Wp0ukQiMoumtVl0GIIw=; b=NSFGOU386L0dkE4+kzaQt
        aIbEhRueA+U2fxNHx+/vVnB3w+z8Z5gbgX20wH17/6KNQ/W9JV5s13OTRU8dKveL
        r+gHPNVAcz20WCMA/x2LkXyHZoFtHBdlkDDPe9Z2TnO5CroPkAR2dDeZw4byFmDf
        f81SvfXX2mpSNwxP27pzn0=
Received: from localhost.localdomain (unknown [113.246.106.84])
        by smtp10 (Coremail) with SMTP id DsCowADXoaqb6M5iNJaxMw--.30784S2;
        Wed, 13 Jul 2022 23:45:33 +0800 (CST)
From:   iamwjia@163.com
To:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Wang Jia <iamwjia@163.com>, Hacash Robot <hacashRobot@santino.com>
Subject: [PATCH -next] xfrm: Fix couple of spellings
Date:   Wed, 13 Jul 2022 23:45:29 +0800
Message-Id: <20220713154529.53031-1-iamwjia@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DsCowADXoaqb6M5iNJaxMw--.30784S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxGr43Wr1fJF13Xry8Xw13Arb_yoW5WFW3pF
        sayayxJFWDWr15W3WkJFWkXr1aqa18GFW7u345Cw1Sk3s8WryktFyIk3yY93WFkrW3ZF45
        XFyUtw15GF1rArJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pNtCwXUUUUU=
X-Originating-IP: [113.246.106.84]
X-CM-SenderInfo: pldp4ylld6il2tof0z/1tbiMh094FWBz8X5GwAAsO
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

From: Wang Jia <iamwjia@163.com>

accomodate  ==> accommodate
destionation  ==> destination
execeeds  ==> exceeds
informations  ==> information

Reported-by: Hacash Robot <hacashRobot@santino.com>
Signed-off-by: Wang Jia <iamwjia@163.com>
---
 net/ipv6/ah6.c     | 2 +-
 net/ipv6/esp6.c    | 4 ++--
 net/ipv6/ip6_vti.c | 2 +-
 net/ipv6/udp.c     | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/ah6.c b/net/ipv6/ah6.c
index b5995c1f4d7a..04cf1db57c75 100644
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
index 36e1d0f8dd06..8220923a12f7 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -343,7 +343,7 @@ static struct ip_esp_hdr *esp_output_set_esn(struct sk_buff *skb,
 					     struct esp_output_extra *extra)
 {
 	/* For ESN we move the header forward by 4 bytes to
-	 * accomodate the high bits.  We will move it back after
+	 * accommodate the high bits.  We will move it back after
 	 * encryption.
 	 */
 	if ((x->props.flags & XFRM_STATE_ESN)) {
@@ -896,7 +896,7 @@ static void esp_input_set_header(struct sk_buff *skb, __be32 *seqhi)
 	struct xfrm_state *x = xfrm_input_state(skb);
 
 	/* For ESN we move the header forward by 4 bytes to
-	 * accomodate the high bits.  We will move it back after
+	 * accommodate the high bits.  We will move it back after
 	 * decryption.
 	 */
 	if ((x->props.flags & XFRM_STATE_ESN)) {
diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
index 3a434d75925c..5500f9aec8fb 100644
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
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 55afd7f39c04..758e348877cb 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -308,7 +308,7 @@ struct sock *udp6_lib_lookup(struct net *net, const struct in6_addr *saddr, __be
 EXPORT_SYMBOL_GPL(udp6_lib_lookup);
 #endif
 
-/* do not use the scratch area len for jumbogram: their length execeeds the
+/* do not use the scratch area len for jumbogram: their length exceeds the
  * scratch area space; note that the IP6CB flags is still in the first
  * cacheline, so checking for jumbograms is cheap
  */
-- 
2.25.1

