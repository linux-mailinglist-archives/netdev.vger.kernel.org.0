Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3A88C0D1
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 20:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbfHMSiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 14:38:24 -0400
Received: from correo.us.es ([193.147.175.20]:59028 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726094AbfHMSiV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 14:38:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1FEDEB632C
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 20:38:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 10E0AADE9
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 20:38:18 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 06769DA72F; Tue, 13 Aug 2019 20:38:18 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E247DDA7B9;
        Tue, 13 Aug 2019 20:38:15 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 13 Aug 2019 20:38:15 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.218.116])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 9DDED4265A2F;
        Tue, 13 Aug 2019 20:38:15 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 13/17] netfilter: remove "#ifdef __KERNEL__" guards from some headers.
Date:   Tue, 13 Aug 2019 20:38:05 +0200
Message-Id: <20190813183809.4081-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190813183809.4081-1-pablo@netfilter.org>
References: <20190813183809.4081-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

A number of non-UAPI Netfilter header-files contained superfluous
"#ifdef __KERNEL__" guards.  Removed them.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_conntrack_dccp.h      | 3 ---
 include/linux/netfilter/nf_conntrack_h323.h      | 4 ----
 include/linux/netfilter/nf_conntrack_irc.h       | 3 ---
 include/linux/netfilter/nf_conntrack_pptp.h      | 3 ---
 include/linux/netfilter/nf_conntrack_proto_gre.h | 2 --
 include/linux/netfilter/nf_conntrack_sane.h      | 4 ----
 include/linux/netfilter/nf_conntrack_sip.h       | 2 --
 7 files changed, 21 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_dccp.h b/include/linux/netfilter/nf_conntrack_dccp.h
index ace0f952d50f..c509ed76e714 100644
--- a/include/linux/netfilter/nf_conntrack_dccp.h
+++ b/include/linux/netfilter/nf_conntrack_dccp.h
@@ -25,7 +25,6 @@ enum ct_dccp_roles {
 };
 #define CT_DCCP_ROLE_MAX	(__CT_DCCP_ROLE_MAX - 1)
 
-#ifdef __KERNEL__
 #include <linux/netfilter/nf_conntrack_tuple_common.h>
 
 struct nf_ct_dccp {
@@ -36,6 +35,4 @@ struct nf_ct_dccp {
 	u_int64_t	handshake_seq;
 };
 
-#endif /* __KERNEL__ */
-
 #endif /* _NF_CONNTRACK_DCCP_H */
diff --git a/include/linux/netfilter/nf_conntrack_h323.h b/include/linux/netfilter/nf_conntrack_h323.h
index 96dfa886f8c0..4561ec0fcea4 100644
--- a/include/linux/netfilter/nf_conntrack_h323.h
+++ b/include/linux/netfilter/nf_conntrack_h323.h
@@ -2,8 +2,6 @@
 #ifndef _NF_CONNTRACK_H323_H
 #define _NF_CONNTRACK_H323_H
 
-#ifdef __KERNEL__
-
 #include <linux/netfilter.h>
 #include <linux/skbuff.h>
 #include <linux/types.h>
@@ -97,5 +95,3 @@ extern int (*nat_q931_hook) (struct sk_buff *skb, struct nf_conn *ct,
 			     struct nf_conntrack_expect *exp);
 
 #endif
-
-#endif
diff --git a/include/linux/netfilter/nf_conntrack_irc.h b/include/linux/netfilter/nf_conntrack_irc.h
index f75e005db969..d02255f721e1 100644
--- a/include/linux/netfilter/nf_conntrack_irc.h
+++ b/include/linux/netfilter/nf_conntrack_irc.h
@@ -2,8 +2,6 @@
 #ifndef _NF_CONNTRACK_IRC_H
 #define _NF_CONNTRACK_IRC_H
 
-#ifdef __KERNEL__
-
 #include <linux/netfilter.h>
 #include <linux/skbuff.h>
 #include <net/netfilter/nf_conntrack_expect.h>
@@ -17,5 +15,4 @@ extern unsigned int (*nf_nat_irc_hook)(struct sk_buff *skb,
 				       unsigned int matchlen,
 				       struct nf_conntrack_expect *exp);
 
-#endif /* __KERNEL__ */
 #endif /* _NF_CONNTRACK_IRC_H */
diff --git a/include/linux/netfilter/nf_conntrack_pptp.h b/include/linux/netfilter/nf_conntrack_pptp.h
index 3f10e806f0dc..fcc409de31a4 100644
--- a/include/linux/netfilter/nf_conntrack_pptp.h
+++ b/include/linux/netfilter/nf_conntrack_pptp.h
@@ -50,8 +50,6 @@ struct nf_nat_pptp {
 	__be16 pac_call_id;			/* NAT'ed PAC call id */
 };
 
-#ifdef __KERNEL__
-
 #define PPTP_CONTROL_PORT	1723
 
 #define PPTP_PACKET_CONTROL	1
@@ -324,5 +322,4 @@ extern void
 (*nf_nat_pptp_hook_expectfn)(struct nf_conn *ct,
 			     struct nf_conntrack_expect *exp);
 
-#endif /* __KERNEL__ */
 #endif /* _NF_CONNTRACK_PPTP_H */
diff --git a/include/linux/netfilter/nf_conntrack_proto_gre.h b/include/linux/netfilter/nf_conntrack_proto_gre.h
index 25f9a770fb84..f33aa6021364 100644
--- a/include/linux/netfilter/nf_conntrack_proto_gre.h
+++ b/include/linux/netfilter/nf_conntrack_proto_gre.h
@@ -10,7 +10,6 @@ struct nf_ct_gre {
 	unsigned int timeout;
 };
 
-#ifdef __KERNEL__
 #include <net/netfilter/nf_conntrack_tuple.h>
 
 struct nf_conn;
@@ -32,5 +31,4 @@ void nf_ct_gre_keymap_destroy(struct nf_conn *ct);
 
 bool gre_pkt_to_tuple(const struct sk_buff *skb, unsigned int dataoff,
 		      struct net *net, struct nf_conntrack_tuple *tuple);
-#endif /* __KERNEL__ */
 #endif /* _CONNTRACK_PROTO_GRE_H */
diff --git a/include/linux/netfilter/nf_conntrack_sane.h b/include/linux/netfilter/nf_conntrack_sane.h
index 7d2de44edce3..46c7acd1b4a7 100644
--- a/include/linux/netfilter/nf_conntrack_sane.h
+++ b/include/linux/netfilter/nf_conntrack_sane.h
@@ -3,8 +3,6 @@
 #define _NF_CONNTRACK_SANE_H
 /* SANE tracking. */
 
-#ifdef __KERNEL__
-
 #define SANE_PORT	6566
 
 enum sane_state {
@@ -17,6 +15,4 @@ struct nf_ct_sane_master {
 	enum sane_state state;
 };
 
-#endif /* __KERNEL__ */
-
 #endif /* _NF_CONNTRACK_SANE_H */
diff --git a/include/linux/netfilter/nf_conntrack_sip.h b/include/linux/netfilter/nf_conntrack_sip.h
index f6437f7841af..c620521c42bc 100644
--- a/include/linux/netfilter/nf_conntrack_sip.h
+++ b/include/linux/netfilter/nf_conntrack_sip.h
@@ -1,7 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef __NF_CONNTRACK_SIP_H__
 #define __NF_CONNTRACK_SIP_H__
-#ifdef __KERNEL__
 
 #include <linux/skbuff.h>
 #include <linux/types.h>
@@ -196,5 +195,4 @@ int ct_sip_get_sdp_header(const struct nf_conn *ct, const char *dptr,
 			  enum sdp_header_types term,
 			  unsigned int *matchoff, unsigned int *matchlen);
 
-#endif /* __KERNEL__ */
 #endif /* __NF_CONNTRACK_SIP_H__ */
-- 
2.11.0


