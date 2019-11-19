Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC2B102F82
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 23:48:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727481AbfKSWsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 17:48:13 -0500
Received: from sonic315-27.consmr.mail.ne1.yahoo.com ([66.163.190.153]:45327
        "EHLO sonic315-27.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727407AbfKSWsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 17:48:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1574203691; bh=jx6SBqD3iFh7Ov9qmHnd1D9nd07iILpEnAa1txjocoA=; h=From:To:Subject:Date:In-Reply-To:References:From:Subject; b=BH+wWzPfkrEU2VgEa2+AOsHM0dXzOdjxB3OkzAYcykVC3BZF0Mhu56klwypNBw7RPqe03aDJUh37+APQnjq9GxbnXfh0a+80qm3qa/yZM004FckJ9R7Vc/IsY7hRT6+ZJcK15L4rtxkp5ll6aIpN5bNNMDrjcRMG8mGlxG1FTXdTjT3gHFfM5J600zoFFQogeRMty91vX/kgU6iBjbDZT4q/K72GdhMvRRWKBqLPeud/XEng0eaYNfjBgq1IkG7i4BVZVPfZjuiMSMzQu/N2R81by7eCRX26Tp71eFOalazLDEpVUI95iJk4qTa2VM3AGpdGmAqCWGvy4G7Xq2njBA==
X-YMail-OSG: XxupmGwVM1lYyy7LNY0.O.WdPVJDCjSDavpDzFvXHrEh09HXPI2p1X_3iRuIXQa
 KZPFjPD9VNua.tSzSd0jrZSxn3EZ3NrKgGZmjzzdE6a74b1eI_G.ZviRzABP2frvZLt5KUoAemmI
 6FuKYbDtC4vFIaojGeyKzhT4Le_oV1vM.78JrhZTcI8h2dBwh7.nOt3l7GXH1.IUL0_rODsjgN8r
 145sbSdzFsfsADTT3DEPG9yr2_rfPlV8S4KzVEZLrV7lMhvwyMUZrfoXuFiG_A8yEz24XwHJR_OL
 _JyaKwOyhv2d1xt2WnH5QgUJRE88kIFxsiftHhbyMo8ZSR16naXIT7iR4qJBJ.OGxMKh5HDa6mRO
 fPR76c7V6qOSqWth2H75tIrzTsN45rg8B7CmKxZ1gZp7wlZhZzWNIj7zOeMDfCL.QksZ2rgcs0Gh
 s.yEp5Mw_54D_NarjSS0P0hZFXRe6bSATKkH2KntD01YWIViIi25Lnma.Ocp3YXv0U_vH7Xa5QjB
 YfPmJ2WQ9zaOJITr2wVvFQPOEjK9PnKB.6zlTq4SGiEsGaF5XWrAstzaHN_8eLnycfbB8GeiznP.
 6kGrno2Y7i_dUuXdg2kIVodAVjAimiocm82FiOz7Oh5i2d4LyiR9gXBvOJb.JvitosiYcufF0gbW
 1hZ8X8wU6cAbrgqBD6pLQAPqELchiXqA12pB4F.YMr4f1516cUFoca3ZrQ0JFaexBV2910ipvyOc
 7vTZWyeKwzkLtXyx__p8kh0P5MpUJ.CgLQr0awglHd3cj6BhKcH9NMBjBg7QcnIrIIeJfi_MIZ7Y
 Ywys_7fpA9MS_y61LB1zKQ2QTiZckUXDZaQb_SyiTOgVGkqqdZ.CwxtIIKVS7yEtgn2CxGGXworh
 y9fXC.tpNGJDbqzg_AgMgjEDbqtPZUZ09dJfLj_Zd6dOIzWoZS4OLN6NBQvLwM7R6e8Y4A2NMycN
 tYWya6wubx1d6QWhLIyurBLnMsw3r9sJWZQdU0Z0Jjt9F9ER5Lt_MlcOsy39tN7MW8158afl4LaL
 LX5a9tPl_n0bU9TTy631qWN1bvVlaSzjUX0kmWApQT7M.wZc7j3XNWpN1MlToskcCwiJ47hMm.zV
 UTzoKD2YFqMU.0qYwKZNwzoPENli0DqMsjZE_HobVvxkMX5MEsGjYyExuUZ7tvYaRCss0vu85jAt
 ZLvCFNEztlBdk8fPfMJFttm1wcvTmrNNRYsc0wkDQt3jlmNDorQFtOSomjSnrZ7Jzrolf0qae_zk
 n.EfIVsWAt4Gv_j96JurT.hOSAv2Bn.e6bIRh_iz7mWF9Dbe7pKniolkAtO_WfYznFkXxWZ2CMXL
 LDhXkmxoviZ2ribVe42VFdik0EY9q6zaNtJtY7WcyBlQZ9pShrXMIbSVkjfTgkGTYqidY.lnWa4l
 181LF3EQDlkPrFEpCvzAtYOerdt9UI2c-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic315.consmr.mail.ne1.yahoo.com with HTTP; Tue, 19 Nov 2019 22:48:11 +0000
Received: by smtp427.mail.bf1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID 49371b2d790a055e23321be3bddd1058;
          Tue, 19 Nov 2019 22:48:05 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     netdev@vger.kernel.org
Subject: [PATCH v11 18/25] LSM: security_secid_to_secctx in netlink netfilter
Date:   Tue, 19 Nov 2019 14:47:11 -0800
Message-Id: <20191119224714.13491-10-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191119224714.13491-1-casey@schaufler-ca.com>
References: <20191119224714.13491-1-casey@schaufler-ca.com>
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
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
cc: netdev@vger.kernel.org
---
 net/netfilter/nfnetlink_queue.c | 32 +++++++++++++-------------------
 1 file changed, 13 insertions(+), 19 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 2d6668fd026c..a1296453d8f2 100644
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
@@ -314,15 +312,16 @@ static u32 nfqnl_get_sk_secctx(struct sk_buff *skb, char **secdata)
 	read_lock_bh(&skb->sk->sk_callback_lock);
 
 	if (skb->secmark) {
+		/* Any LSM might be looking for the secmark */
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
@@ -398,8 +397,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	enum ip_conntrack_info uninitialized_var(ctinfo);
 	struct nfnl_ct_hook *nfnl_ct;
 	bool csum_verify;
-	struct lsmcontext scaff; /* scaffolding */
-	char *secdata = NULL;
+	struct lsmcontext context = { };
 	u32 seclen = 0;
 
 	size = nlmsg_total_size(sizeof(struct nfgenmsg))
@@ -466,7 +464,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	}
 
 	if ((queue->flags & NFQA_CFG_F_SECCTX) && entskb->sk) {
-		seclen = nfqnl_get_sk_secctx(entskb, &secdata);
+		seclen = nfqnl_get_sk_secctx(entskb, &context);
 		if (seclen)
 			size += nla_total_size(seclen);
 	}
@@ -601,7 +599,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	    nfqnl_put_sk_uidgid(skb, entskb->sk) < 0)
 		goto nla_put_failure;
 
-	if (seclen && nla_put(skb, NFQA_SECCTX, seclen, secdata))
+	if (seclen && nla_put(skb, NFQA_SECCTX, context.len, context.context))
 		goto nla_put_failure;
 
 	if (ct && nfnl_ct->build(skb, ct, ctinfo, NFQA_CT, NFQA_CT_INFO) < 0)
@@ -629,10 +627,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
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
@@ -640,10 +636,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
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
2.20.1

