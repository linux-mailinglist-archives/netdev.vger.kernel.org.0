Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EBAB84E79
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 16:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388227AbfHGORZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 10:17:25 -0400
Received: from kadath.azazel.net ([81.187.231.250]:46012 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730016AbfHGORK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 10:17:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=oOpFcWNpt0i4CaFfXIdVnJrCBk46Rzj4f/lsRX4vkeo=; b=MFIaKggYh9FqTMc1gJReqWXXIy
        C9aVUS0CrGA3i9SWbm6qGMMa/dDClEWM+JVang5dke1cbQxdQkiUeYOzuL1+uB7kpgrDV8TeEmzuq
        8BCpL8nwJM9An/FNidRMxA1+A1P3NSezTBsiRC4w8o4CvirS3+v+YmRGfTSO+Y+Wkheyf0EVIC9Hh
        3hTmxoaGfHVZNPxPySVKaLiP4zo6x3oTTyv+zfXdYzBBtXxSNTIXM7FIW3N5eQrkkI9/jRV8KO5NP
        sCfrhQJyNtE37MxR6MdqdkDM3vRZgVihdgmQVOrrTYRNp+MCmq5IaWCVjDj3WE9qCXa7vQcktAHKF
        JaNUbN+g==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1hvMkV-0001Wc-8T; Wed, 07 Aug 2019 15:17:07 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Net Dev <netdev@vger.kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH net-next v1 7/8] netfilter: removed "#ifdef __KERNEL__" guards from some headers.
Date:   Wed,  7 Aug 2019 15:17:04 +0100
Message-Id: <20190807141705.4864-8-jeremy@azazel.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190807141705.4864-1-jeremy@azazel.net>
References: <20190722201615.GE23346@azazel.net>
 <20190807141705.4864-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A number of non-UAPI Netfilter header-files contained superfluous
"#ifdef __KERNEL__" guards.  Removed them.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
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
2.20.1

