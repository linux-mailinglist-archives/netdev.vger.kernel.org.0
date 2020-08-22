Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2F424EA74
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 01:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbgHVXbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 19:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727812AbgHVXbs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 19:31:48 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60FB3C061573
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 16:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=xIomwkLOSm0neBRVYR0EZWauF6pa4jOS4tssdk8WcXs=; b=0F/BtLArO21HhQ4lqLIla/Xwqm
        ADktHLxjxv1ovbNLm62gIouWVRkdJJUhXrv/Qr733/h/Aht4lDW3Bqwweis5CugH5MTOXl1At8RCv
        PNAc5sRBwP+682rhJfCYPywMrMt9UoUJIMMIYv6tB2pgQh0YkchOb8ZiXncNzwtf+KnetkXDAnyJR
        cmpmxQvCFcihw0NnN3BMvcK3d86ML/dIXw8tmV1W2oQG84wBuscf0Xd1h1dqYBBQc7E2Z7FR1dXFq
        VbdMY2IC8+sBrjA3ov+G0lC0kiMXJuzeUBRYXxx8Fp/0y93cP68HzAHJlJMXL4k6PDpgfqA6klu0A
        b20Uomkw==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k9czB-00070k-Qn; Sat, 22 Aug 2020 23:31:46 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] net: ipv4: delete repeated words
Date:   Sat, 22 Aug 2020 16:31:41 -0700
Message-Id: <20200822233141.1671-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop duplicate words in comments in net/ipv4/.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 net/ipv4/fou.c          |    4 ++--
 net/ipv4/raw.c          |    2 +-
 net/ipv4/tcp_ipv4.c     |    2 +-
 net/ipv4/tcp_scalable.c |    2 +-
 net/ipv4/udp.c          |    2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

--- linux-next-20200821.orig/net/ipv4/fou.c
+++ linux-next-20200821/net/ipv4/fou.c
@@ -237,7 +237,7 @@ static struct sk_buff *fou_gro_receive(s
 
 	/* We can clear the encap_mark for FOU as we are essentially doing
 	 * one of two possible things.  We are either adding an L4 tunnel
-	 * header to the outer L3 tunnel header, or we are are simply
+	 * header to the outer L3 tunnel header, or we are simply
 	 * treating the GRE tunnel header as though it is a UDP protocol
 	 * specific header such as VXLAN or GENEVE.
 	 */
@@ -429,7 +429,7 @@ next_proto:
 
 	/* We can clear the encap_mark for GUE as we are essentially doing
 	 * one of two possible things.  We are either adding an L4 tunnel
-	 * header to the outer L3 tunnel header, or we are are simply
+	 * header to the outer L3 tunnel header, or we are simply
 	 * treating the GRE tunnel header as though it is a UDP protocol
 	 * specific header such as VXLAN or GENEVE.
 	 */
--- linux-next-20200821.orig/net/ipv4/raw.c
+++ linux-next-20200821/net/ipv4/raw.c
@@ -611,7 +611,7 @@ static int raw_sendmsg(struct sock *sk,
 		ipc.oif = inet->uc_index;
 	} else if (ipv4_is_lbcast(daddr) && inet->uc_index) {
 		/* oif is set, packet is to local broadcast and
-		 * and uc_index is set. oif is most likely set
+		 * uc_index is set. oif is most likely set
 		 * by sk_bound_dev_if. If uc_index != oif check if the
 		 * oif is an L3 master and uc_index is an L3 slave.
 		 * If so, we want to allow the send using the uc_index.
--- linux-next-20200821.orig/net/ipv4/tcp_ipv4.c
+++ linux-next-20200821/net/ipv4/tcp_ipv4.c
@@ -575,7 +575,7 @@ int tcp_v4_err(struct sk_buff *skb, u32
 	case TCP_SYN_SENT:
 	case TCP_SYN_RECV:
 		/* Only in fast or simultaneous open. If a fast open socket is
-		 * is already accepted it is treated as a connected one below.
+		 * already accepted it is treated as a connected one below.
 		 */
 		if (fastopen && !fastopen->sk)
 			break;
--- linux-next-20200821.orig/net/ipv4/tcp_scalable.c
+++ linux-next-20200821/net/ipv4/tcp_scalable.c
@@ -10,7 +10,7 @@
 #include <net/tcp.h>
 
 /* These factors derived from the recommended values in the aer:
- * .01 and and 7/8.
+ * .01 and 7/8.
  */
 #define TCP_SCALABLE_AI_CNT	100U
 #define TCP_SCALABLE_MD_SCALE	3
--- linux-next-20200821.orig/net/ipv4/udp.c
+++ linux-next-20200821/net/ipv4/udp.c
@@ -1170,7 +1170,7 @@ int udp_sendmsg(struct sock *sk, struct
 		ipc.oif = inet->uc_index;
 	} else if (ipv4_is_lbcast(daddr) && inet->uc_index) {
 		/* oif is set, packet is to local broadcast and
-		 * and uc_index is set. oif is most likely set
+		 * uc_index is set. oif is most likely set
 		 * by sk_bound_dev_if. If uc_index != oif check if the
 		 * oif is an L3 master and uc_index is an L3 slave.
 		 * If so, we want to allow the send using the uc_index.
