Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61F2D1D4106
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 00:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728637AbgENWac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 18:30:32 -0400
Received: from sonic316-27.consmr.mail.ne1.yahoo.com ([66.163.187.153]:39247
        "EHLO sonic316-27.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728629AbgENWac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 18:30:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1589495431; bh=uWNP/f0MZF916y2Cwsdhr7gT91hrx+SqsNnUvBkdwps=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject; b=k0NnDkvjq9v3Yx1MBRS0CCuxreQkHcRYdnqdhwHcU9zydMzNk5T7BJvwNUTnz2Lj/P9oVy+Ds9Oeb3ii9lS4uNdgBGJaM6NNlQPCGJOaAO6iXFRC5DkHO/raAHFNBDlfU64MwuDq8d/7ckUQV8aaArjNKvxcg/YFDV17Jq5qnJbn7Kf0lWZ+6EzdSvaYAeUJCgDKTpzeNg5OFbkR8W6kRc/B4ClW6wF4JVY1U/hrUJjAwk+2DV8IfDxfHOMYTaXmtleYOSxEeqvvsMCoG02y/V355sXlMmEsP/NYwrw/J/KO4Bv8YbuYxjrQnEjy9UwqpQbnDhijldd9jJkequv6sw==
X-YMail-OSG: P0ArnsYVM1l6P3YuvGQ46Izp12WumIkJRv_Q.qb8si1MbAPiZEz.fIeQBmC1.7Z
 Vt1_McvMr6oCFbztMJc4q3cqRhp2fNxpBrTlF5zhoRo.spNxh8pftiUFrOqaLi0WW5qAW.jULdxD
 ZZdmGgEb_JHWZ1emW7JTSRXbUbmHOdY_bua4lx4.cm8RpK5NT6QOziOVN06zbgZFEcBAln_ym4qg
 ZLBHLvM8MXg2HYf48YTlb72uM5BIWkWplCAS4jwBEcR6d.N2C8VTFEfLypPU9tteZ9cKvX4WZy4B
 7dEJpSaPADXN643qcALcn4FUQLoHjGC1EVRneyqX66lmx5OCv19pflQ0dN.nYtdqPwD_KVFV8wik
 BXHxQM8B7Mwq99bdnthzVBWazj67XXoDw3jH5tQAlDrExxjxrWKlzrW29ZM9kO9VBY0nlI0N11FK
 eshg8VXew9I2pkXDEUJTuihzwLRQUp_mJhu6l6Ch2RmQS4s.INMkqYgUaBdHNV7Nz8tVcT5j_pOd
 y8JdEdbYSKl_Qz_oXclif6qREtU5ClLhXwKcFgrhydBcM5Dan6h_51slVzwWEpgJ7h14tUt5ThnX
 RLEtxHssR.StLFsMB99cFYgbtlc8sc7cKiDOmAT2.ZnVjqnRE3379pIwRuQu_1UdB9UcPir9OOKW
 dKa4tmsat2kSgax5OagsfpGn8G3o0aE24asIPDwOQJ2y1UObgO1W5RqQM9MqZBWhDxiDYaYwROco
 x7h9pNflaKwwjuPGdW4s0cKQyWbri19FZUVoPwjA8Pr3h7tHfrHpPJeh7VJvb3l8zXFjA8TgEbnG
 O2G.jQZd039a5Ry5EsWFZXdOsWHrU2TIzJTyEyeD5zucc81FTRSOSI0QZc0IeG_vFIvFBVFOicS8
 IAle20mAsTzACkS0y2OBHReGNdsGZU2SoPrCwNIOf7xCF0ihXX0A3m3bRQsD.lH_2Mw52mpq6Zvn
 4ZRgJeS_lSMJJtr.i0S1OYaG457wNZxauqavEJavBAdo1meXfbqciL.PoEGOOBI6o8YZsfcLwBbj
 FfLm4qe.uVS7vdBzJ6iR_hnyuKHPdjYbmwZh0cOny1UFZqkf9WElQFrkhhiflwR1WFaG_1sZBFqX
 RwOwcuEtjrNMEzZrLYGFc7B3PqQ_r2_RfqzJDTp5gf_AkvT64vzclxIR3eF7Lcyqmgm6XRU9k5Dq
 bOS394rTrW24PZEeyDHeaifh_wEwEV8qRccEceME8mUvY2pQrfpTfmuzEhAaQzRZ1TBmrD33wihO
 5Kz6W4CTlfnOUsfnLCrb0z9Cnr_ICIWBMSbVInAwQXiI.UjEzwHWn1atYwmRp1osuM7IPYWwcGdZ
 YXNSDu.Exz04MM7tu2mEZXAjtID7SrpkjhjObDRwunEUp0ympwSrj7Yjusl5LCvzo5.8WhKziKpc
 v28v22AOpgJ.C6umJClqxNzuajwc2QaC5cFtK3kbOCthtzWoO0s5c5q64sTC_4I0bNe2p
Received: from sonic.gate.mail.ne1.yahoo.com by sonic316.consmr.mail.ne1.yahoo.com with HTTP; Thu, 14 May 2020 22:30:31 +0000
Received: by smtp414.mail.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID d4602fb5d17e767b22601702ddf62cb3;
          Thu, 14 May 2020 22:30:26 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, keescook@chromium.org,
        john.johansen@canonical.com, penguin-kernel@i-love.sakura.ne.jp,
        paul@paul-moore.com, sds@tycho.nsa.gov, linux-audit@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH v17 17/23] LSM: security_secid_to_secctx in netlink netfilter
Date:   Thu, 14 May 2020 15:11:36 -0700
Message-Id: <20200514221142.11857-18-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200514221142.11857-1-casey@schaufler-ca.com>
References: <20200514221142.11857-1-casey@schaufler-ca.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change netlink netfilter interfaces to use lsmcontext
pointers, and remove scaffolding.

Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: John Johansen <john.johansen@canonical.com>
Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
cc: netdev@vger.kernel.org
---
 net/netfilter/nfnetlink_queue.c | 31 ++++++++++++-------------------
 1 file changed, 12 insertions(+), 19 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index fe19ae7216db..a4d4602ab9b7 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -301,12 +301,10 @@ static int nfqnl_put_sk_uidgid(struct sk_buff *skb, struct sock *sk)
 	return -1;
 }
 
-static u32 nfqnl_get_sk_secctx(struct sk_buff *skb, char **secdata)
+static u32 nfqnl_get_sk_secctx(struct sk_buff *skb, struct lsmcontext *context)
 {
-	u32 seclen = 0;
 #if IS_ENABLED(CONFIG_NETWORK_SECMARK)
 	struct lsmblob blob;
-	struct lsmcontext context = { };
 
 	if (!skb || !sk_fullsock(skb->sk))
 		return 0;
@@ -318,14 +316,14 @@ static u32 nfqnl_get_sk_secctx(struct sk_buff *skb, char **secdata)
 		 * blob. security_secid_to_secctx() will know which security
 		 * module to use to create the secctx.  */
 		lsmblob_init(&blob, skb->secmark);
-		security_secid_to_secctx(&blob, &context);
-		*secdata = context.context;
+		security_secid_to_secctx(&blob, context);
 	}
 
 	read_unlock_bh(&skb->sk->sk_callback_lock);
-	seclen = context.len;
+	return context->len;
+#else
+	return 0;
 #endif
-	return seclen;
 }
 
 static u32 nfqnl_get_bridge_size(struct nf_queue_entry *entry)
@@ -401,8 +399,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	enum ip_conntrack_info uninitialized_var(ctinfo);
 	struct nfnl_ct_hook *nfnl_ct;
 	bool csum_verify;
-	struct lsmcontext scaff; /* scaffolding */
-	char *secdata = NULL;
+	struct lsmcontext context = { };
 	u32 seclen = 0;
 
 	size = nlmsg_total_size(sizeof(struct nfgenmsg))
@@ -469,7 +466,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	}
 
 	if ((queue->flags & NFQA_CFG_F_SECCTX) && entskb->sk) {
-		seclen = nfqnl_get_sk_secctx(entskb, &secdata);
+		seclen = nfqnl_get_sk_secctx(entskb, &context);
 		if (seclen)
 			size += nla_total_size(seclen);
 	}
@@ -604,7 +601,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	    nfqnl_put_sk_uidgid(skb, entskb->sk) < 0)
 		goto nla_put_failure;
 
-	if (seclen && nla_put(skb, NFQA_SECCTX, seclen, secdata))
+	if (seclen && nla_put(skb, NFQA_SECCTX, context.len, context.context))
 		goto nla_put_failure;
 
 	if (ct && nfnl_ct->build(skb, ct, ctinfo, NFQA_CT, NFQA_CT_INFO) < 0)
@@ -632,10 +629,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	}
 
 	nlh->nlmsg_len = skb->len;
-	if (seclen) {
-		lsmcontext_init(&scaff, secdata, seclen, 0);
-		security_release_secctx(&scaff);
-	}
+	if (seclen)
+		security_release_secctx(&context);
 	return skb;
 
 nla_put_failure:
@@ -643,10 +638,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	kfree_skb(skb);
 	net_err_ratelimited("nf_queue: error creating packet message\n");
 nlmsg_failure:
-	if (seclen) {
-		lsmcontext_init(&scaff, secdata, seclen, 0);
-		security_release_secctx(&scaff);
-	}
+	if (seclen)
+		security_release_secctx(&context);
 	return NULL;
 }
 
-- 
2.24.1

