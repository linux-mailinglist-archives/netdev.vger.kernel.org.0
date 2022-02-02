Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4C634A7C83
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 01:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348375AbiBCAOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 19:14:15 -0500
Received: from sonic317-39.consmr.mail.ne1.yahoo.com ([66.163.184.50]:45974
        "EHLO sonic317-39.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233665AbiBCAOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 19:14:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1643847254; bh=OPmcc6RxdekExVViioUe9rMhP6xIsP6mDCh0RBi/+Qs=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=h8ffBTPMoJFah9n8Qm3CDl+XbQlVrT8q5syZItmtyN9hlRKqoT+Ft3pWI7Ip3Tvw29hnjwoe4lnrA3SG3iL7NHNfnFPPhDtzlv4HdA1NilUmRfpyHMkebIFdSS+aTq3dANiyPsWKBHxG5atXI6qpi4w5ofBoLUs45oHfNguS+ttLHzbN8dg4/MMzd5zmvye23HFGf1XuivJdREpa/UMYqzRRp13IXFWoOva6ckrW0847SI6LGR1cG+oFbcPi+GfsL3U7xWEOTgYhj2TChFAbtceTgzfjldpOt2gOevqf3o1lQL2P5nPbDplORDaHRJrY0iZiXaRN3iW9zMftB2ULvw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1643847254; bh=JWLmen0v1iaGlr+fMYDNSNw6J81iTVeWtMd+lDm0dp1=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=TCC7t3uvlVUcJOtc4rr3X2vGyYaihwytEuMAHvyoqj/gboDkj+yPKA1mBYyPhPJ5/VYEV+L6AUu/s4D6nAm93L/guduUYY/Y8KIb+jxznKFsTbSdsb7i3IDnD2LHVeG+8Mtz3+O5sYTXaUBegXW90y7dcdBa/enHCw1y8NFjYVzZJeevwlqS25abvMqJi0IIL7BykJeXLhdlyNzpkKor42wdR7jD4RLBx7yWKQlBNO94cfUaxdAF+gxBulin/ZA/PXarTxwboUVWNqL+PRRNtPjzFH6bQA8dAC2tbVZ3e4fO0fYVn/PyLnSff69vLRwVKMJcU4doA8fZ3zO8rRoZIg==
X-YMail-OSG: qosHQDwVM1nikMe.7SO6m5ncuiKLq9iyb4U_sxQnVywwIUTg9s9QO9r3LUQnwH7
 aDGbdAHz4USz5O3roJ_uy.70DLhLLasHmaUz1C9bxDRhKVaFFzvV4Bw0.X3EbmPoRrrSQ.r1vAW6
 aj3c9sejtoK0KfvByyqMomQOwAe23XzYZ74UuCfAEKXKgmwiQIdcNRNQACblPX7x5CwNMqsJBA73
 idy4M9MMLHdPoWcxgvAqGZ2pDjonrN9WR7rOsqXyzO_HNI4xCZJ72sk7MoslCwAk3.D6b52MzTEs
 jnmnhBT.gxBVeEd.GsZu2fHzNUlIQUGxKUDKlzO29wbsvvDht.TMW9qf9qPnalWcMIyOQo1CDTdN
 P9M4qcJ8fR7XTk1kGYAYF2GrYZ3MMrxp7NLuse44J1tJLJTSYQLnFtrsi4V_IVqnabbqcXWIQCaM
 JtU_K8xxALIfnhZrWutIX7TSzBVtxkchRq98MlLj_N0GCxHbFLtVWfOBGqxnUCxU4UQ0o0rcTHmg
 Mhgy501Vc5QaigA68jNaeZBGgqpz9QXPWSeniiuGAm62bmD2RCvDKp78Wn8PRCxxNqz9HJWFk.Zs
 5wBMxubGu4nOJ6AQCFIXaEbxZ_wk3MQ2ewW6uJdd3uv_OxHPiyJNtkbkX4MxhVqQeZ8SBea94yIs
 THXQfS.9zWNF4l4KUME2SYQm.8h9boHyZpZj5tZlRCVV8Ya3MQbRLHC.Jg9p593WgvekFTw0BTx0
 rj4SPrXqvdyWHaUC3u.Lrm.kV0pU7wPnPuIzIKhV03wEaFfn59Evxe0DgD98eQcoFPssBpChP.M5
 Ne9uQzSN31l5gNEWO4LNF8D73gDst_31l0QbMf.gwOI89Qjv1Y4Gf2SWfvul7sMD8dsWfMWH53R9
 3pm50utRysavJ6S8ZWFRXOVGW9aTeWjrv_X5xEEfR_F4X_NXKOfHoPsAtgJWPapNqwFViAJdf_rw
 WEF09weCRWjDj3OTYx87Q3a6tXYMtd8VEdQTDnZCs4CXGQh6cVTtj9VOGzLsLxZD.gRmYfQAf1qO
 KvTdvDeV3QEDKW7cL3pfKrrHSXh4xb8oWg2wOWDvEjlD3UdrRxH7elcXL8REq9_N8mCFKZOjd8nv
 8MGsA4ghmnbnSCHRhyZRHi8mYw14jF_Eir9BgOVgcRE1wBKuQuveXIuT0dgH_GmnP3cO5uOuztIT
 HCS9fpzVtnqmtTvt1wn5e8zS3XnPdzULFujL2nzR0CQsNgHPNaABtXdXgJfcOLy3ni4.Cf21TbQJ
 xPrVCbwwtzVJUTD1rQQiH6nWrGGasRSgIa5tYAVyVbTfQqoh_2QsLTlo9YkWaA3HoRNKvU5MXiSO
 ADkH24wZGcOX7viG03JDrTis7pDdEgu9FzvjeN28JhVI8pPDUioZvJaskPYHldO9hKXiDulyl_xO
 akvApLx4UHSKdMNItUZ0eb6AuQdy1_P51Vhi4NrbVxVDpPOB8tPYj8QlVVYj_UuvAL0.GvYmVXEl
 xg86A2nGc65alT04BURVI_2GOAsP_paM1eseUXDJ_031GA2WvhGNQrouCkokXDcXDharTG2RAD6n
 C_LrCmW.Z68HmrReEh0VXi6t0kaBZ66TlMIie2IPjFwD0rTnXG5brd0MzTKuScGWj63sKoPQr8Gm
 y2mByFfB7LbIaBL2P5unH1g_OsjGqRavwaOqZzyGszPZ7YpqWH9QGsZjuHR8NbysW6KmPiW6iqi1
 0i0Xu4VbXj2RH4yPZMWpKyNZFaFgFjDHnIQ.41bx4SLIfIzZiTsi.BQ_zpjN5foA6d_6dPhUgRhZ
 Wew1p0VxwfFya9iEIe.WRkAo47_6Znv16DP4M8hzPn.8ZD9C4e0akt1GMfBN2jeuQmzNymeYMNqd
 4Io_BFeMWO7WOrOeJpBSradF95J1mJSLcc2n6H69BLZSF3JISMrp5yVGvABje03JqAiAJU5nKUYN
 b_Zl5bWQbiD5x6MCYpchmMWw8_MWxuxkci57hCAp0NpcOCUHZeTNJNJfdGRTwdikrk87ighHz.cq
 CSvkIiJpZpjbd4DBqXBlXuB7UnYEHC_x37MivQeybXPyPHaHAJnN2g8eYJn8VVH0pbWScSH5.hGd
 50bmm5C3xfHVIc0imJnIp.CWnbCSVoLQKvnl6X_za3X.vIpnZy8xNX8Vr4jh2goZJpbzwQi7piW_
 SXnWWYhJijl4F3_pMZcic4ryk9br8S3aTFqJIczvrs2IdAQE_4BAJcXdqAOdJ6lbMSnST3a7.yaw
 fDu2NUvV4wpcInIPCuC.3zdp7bOmJRSMdbU3Ur.NOT_ygqsWZH2RwobwBSLj3aw1bWXPYZVQhPrK
 d
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic317.consmr.mail.ne1.yahoo.com with HTTP; Thu, 3 Feb 2022 00:14:14 +0000
Received: by kubenode514.mail-prod1.omega.bf1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID a29bd64dc2f4fffffe40b3652cb32a1f;
          Thu, 03 Feb 2022 00:14:11 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH v32 18/28] LSM: security_secid_to_secctx in netlink netfilter
Date:   Wed,  2 Feb 2022 15:53:13 -0800
Message-Id: <20220202235323.23929-19-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220202235323.23929-1-casey@schaufler-ca.com>
References: <20220202235323.23929-1-casey@schaufler-ca.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change netlink netfilter interfaces to use lsmcontext
pointers, and remove scaffolding.

Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: John Johansen <john.johansen@canonical.com>
Acked-by: Paul Moore <paul@paul-moore.com>
Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Cc: netdev@vger.kernel.org
Cc: netfilter-devel@vger.kernel.org
---
 net/netfilter/nfnetlink_queue.c | 37 +++++++++++++--------------------
 1 file changed, 14 insertions(+), 23 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 625cd787ffc1..2aff40578045 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -301,15 +301,13 @@ static int nfqnl_put_sk_uidgid(struct sk_buff *skb, struct sock *sk)
 	return -1;
 }
 
-static u32 nfqnl_get_sk_secctx(struct sk_buff *skb, char **secdata)
+static void nfqnl_get_sk_secctx(struct sk_buff *skb, struct lsmcontext *context)
 {
-	u32 seclen = 0;
 #if IS_ENABLED(CONFIG_NETWORK_SECMARK)
 	struct lsmblob blob;
-	struct lsmcontext context = { };
 
 	if (!skb || !sk_fullsock(skb->sk))
-		return 0;
+		return;
 
 	read_lock_bh(&skb->sk->sk_callback_lock);
 
@@ -318,14 +316,12 @@ static u32 nfqnl_get_sk_secctx(struct sk_buff *skb, char **secdata)
 		 * blob. security_secid_to_secctx() will know which security
 		 * module to use to create the secctx.  */
 		lsmblob_init(&blob, skb->secmark);
-		security_secid_to_secctx(&blob, &context);
-		*secdata = context.context;
+		security_secid_to_secctx(&blob, context);
 	}
 
 	read_unlock_bh(&skb->sk->sk_callback_lock);
-	seclen = context.len;
 #endif
-	return seclen;
+	return;
 }
 
 static u32 nfqnl_get_bridge_size(struct nf_queue_entry *entry)
@@ -397,12 +393,10 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	struct net_device *indev;
 	struct net_device *outdev;
 	struct nf_conn *ct = NULL;
+	struct lsmcontext context = { };
 	enum ip_conntrack_info ctinfo = 0;
 	const struct nfnl_ct_hook *nfnl_ct;
 	bool csum_verify;
-	struct lsmcontext scaff; /* scaffolding */
-	char *secdata = NULL;
-	u32 seclen = 0;
 
 	size = nlmsg_total_size(sizeof(struct nfgenmsg))
 		+ nla_total_size(sizeof(struct nfqnl_msg_packet_hdr))
@@ -470,9 +464,9 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	}
 
 	if ((queue->flags & NFQA_CFG_F_SECCTX) && entskb->sk) {
-		seclen = nfqnl_get_sk_secctx(entskb, &secdata);
-		if (seclen)
-			size += nla_total_size(seclen);
+		nfqnl_get_sk_secctx(entskb, &context);
+		if (context.len)
+			size += nla_total_size(context.len);
 	}
 
 	skb = alloc_skb(size, GFP_ATOMIC);
@@ -603,7 +597,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	    nfqnl_put_sk_uidgid(skb, entskb->sk) < 0)
 		goto nla_put_failure;
 
-	if (seclen && nla_put(skb, NFQA_SECCTX, seclen, secdata))
+	if (context.len &&
+	    nla_put(skb, NFQA_SECCTX, context.len, context.context))
 		goto nla_put_failure;
 
 	if (ct && nfnl_ct->build(skb, ct, ctinfo, NFQA_CT, NFQA_CT_INFO) < 0)
@@ -631,10 +626,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	}
 
 	nlh->nlmsg_len = skb->len;
-	if (seclen) {
-		lsmcontext_init(&scaff, secdata, seclen, 0);
-		security_release_secctx(&scaff);
-	}
+	if (context.len)
+		security_release_secctx(&context);
 	return skb;
 
 nla_put_failure:
@@ -642,10 +635,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	kfree_skb(skb);
 	net_err_ratelimited("nf_queue: error creating packet message\n");
 nlmsg_failure:
-	if (seclen) {
-		lsmcontext_init(&scaff, secdata, seclen, 0);
-		security_release_secctx(&scaff);
-	}
+	if (context.len)
+		security_release_secctx(&context);
 	return NULL;
 }
 
-- 
2.31.1

