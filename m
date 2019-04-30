Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3D9FF090
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 08:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbfD3Ghp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 02:37:45 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:48830 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726399AbfD3Ghk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 02:37:40 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id D82EC201E6;
        Tue, 30 Apr 2019 08:37:38 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ugswqMBwI333; Tue, 30 Apr 2019 08:37:38 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 75EA020281;
        Tue, 30 Apr 2019 08:37:32 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 30 Apr 2019
 08:37:32 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 5052031806A4;
 Tue, 30 Apr 2019 08:37:31 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 18/18] xfrm: remove unneeded export_symbols
Date:   Tue, 30 Apr 2019 08:37:27 +0200
Message-ID: <20190430063727.10908-19-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190430063727.10908-1-steffen.klassert@secunet.com>
References: <20190430063727.10908-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-G-Data-MailSecurity-for-Exchange-State: 0
X-G-Data-MailSecurity-for-Exchange-Error: 0
X-G-Data-MailSecurity-for-Exchange-Sender: 23
X-G-Data-MailSecurity-for-Exchange-Server: d65e63f7-5c15-413f-8f63-c0d707471c93
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-G-Data-MailSecurity-for-Exchange-Guid: 40F54B93-5D7C-42D8-87E8-D76B11C07DF1
X-G-Data-MailSecurity-for-Exchange-ProcessedOnRouted: True
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

None of them have any external callers, make them static.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h        | 2 --
 net/ipv4/xfrm4_protocol.c | 3 +--
 net/ipv6/xfrm6_protocol.c | 3 +--
 net/xfrm/xfrm_state.c     | 5 ++---
 4 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 18d6b33501b9..eb5018b1cf9c 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1568,7 +1568,6 @@ static inline int xfrm4_rcv_spi(struct sk_buff *skb, int nexthdr, __be32 spi)
 int xfrm4_extract_output(struct xfrm_state *x, struct sk_buff *skb);
 int xfrm4_output(struct net *net, struct sock *sk, struct sk_buff *skb);
 int xfrm4_output_finish(struct sock *sk, struct sk_buff *skb);
-int xfrm4_rcv_cb(struct sk_buff *skb, u8 protocol, int err);
 int xfrm4_protocol_register(struct xfrm4_protocol *handler, unsigned char protocol);
 int xfrm4_protocol_deregister(struct xfrm4_protocol *handler, unsigned char protocol);
 int xfrm4_tunnel_register(struct xfrm_tunnel *handler, unsigned short family);
@@ -1584,7 +1583,6 @@ int xfrm6_rcv(struct sk_buff *skb);
 int xfrm6_input_addr(struct sk_buff *skb, xfrm_address_t *daddr,
 		     xfrm_address_t *saddr, u8 proto);
 void xfrm6_local_error(struct sk_buff *skb, u32 mtu);
-int xfrm6_rcv_cb(struct sk_buff *skb, u8 protocol, int err);
 int xfrm6_protocol_register(struct xfrm6_protocol *handler, unsigned char protocol);
 int xfrm6_protocol_deregister(struct xfrm6_protocol *handler, unsigned char protocol);
 int xfrm6_tunnel_register(struct xfrm6_tunnel *handler, unsigned short family);
diff --git a/net/ipv4/xfrm4_protocol.c b/net/ipv4/xfrm4_protocol.c
index 35c54865dc42..bcab48944c15 100644
--- a/net/ipv4/xfrm4_protocol.c
+++ b/net/ipv4/xfrm4_protocol.c
@@ -46,7 +46,7 @@ static inline struct xfrm4_protocol __rcu **proto_handlers(u8 protocol)
 	     handler != NULL;				\
 	     handler = rcu_dereference(handler->next))	\
 
-int xfrm4_rcv_cb(struct sk_buff *skb, u8 protocol, int err)
+static int xfrm4_rcv_cb(struct sk_buff *skb, u8 protocol, int err)
 {
 	int ret;
 	struct xfrm4_protocol *handler;
@@ -61,7 +61,6 @@ int xfrm4_rcv_cb(struct sk_buff *skb, u8 protocol, int err)
 
 	return 0;
 }
-EXPORT_SYMBOL(xfrm4_rcv_cb);
 
 int xfrm4_rcv_encap(struct sk_buff *skb, int nexthdr, __be32 spi,
 		    int encap_type)
diff --git a/net/ipv6/xfrm6_protocol.c b/net/ipv6/xfrm6_protocol.c
index cc979b702c89..aaacac7fdbce 100644
--- a/net/ipv6/xfrm6_protocol.c
+++ b/net/ipv6/xfrm6_protocol.c
@@ -46,7 +46,7 @@ static inline struct xfrm6_protocol __rcu **proto_handlers(u8 protocol)
 	     handler != NULL;				\
 	     handler = rcu_dereference(handler->next))	\
 
-int xfrm6_rcv_cb(struct sk_buff *skb, u8 protocol, int err)
+static int xfrm6_rcv_cb(struct sk_buff *skb, u8 protocol, int err)
 {
 	int ret;
 	struct xfrm6_protocol *handler;
@@ -61,7 +61,6 @@ int xfrm6_rcv_cb(struct sk_buff *skb, u8 protocol, int err)
 
 	return 0;
 }
-EXPORT_SYMBOL(xfrm6_rcv_cb);
 
 static int xfrm6_esp_rcv(struct sk_buff *skb)
 {
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index d3d87c409f44..ed25eb81aabe 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -173,7 +173,7 @@ static DEFINE_SPINLOCK(xfrm_state_gc_lock);
 int __xfrm_state_delete(struct xfrm_state *x);
 
 int km_query(struct xfrm_state *x, struct xfrm_tmpl *t, struct xfrm_policy *pol);
-bool km_is_alive(const struct km_event *c);
+static bool km_is_alive(const struct km_event *c);
 void km_state_expired(struct xfrm_state *x, int hard, u32 portid);
 
 static DEFINE_SPINLOCK(xfrm_type_lock);
@@ -2025,7 +2025,7 @@ int km_report(struct net *net, u8 proto, struct xfrm_selector *sel, xfrm_address
 }
 EXPORT_SYMBOL(km_report);
 
-bool km_is_alive(const struct km_event *c)
+static bool km_is_alive(const struct km_event *c)
 {
 	struct xfrm_mgr *km;
 	bool is_alive = false;
@@ -2041,7 +2041,6 @@ bool km_is_alive(const struct km_event *c)
 
 	return is_alive;
 }
-EXPORT_SYMBOL(km_is_alive);
 
 int xfrm_user_policy(struct sock *sk, int optname, u8 __user *optval, int optlen)
 {
-- 
2.17.1

