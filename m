Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58F5945B1AB
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 03:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhKXCGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 21:06:41 -0500
Received: from sonic306-28.consmr.mail.ne1.yahoo.com ([66.163.189.90]:44749
        "EHLO sonic306-28.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229580AbhKXCGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 21:06:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1637719411; bh=IIKa//ZfOf9ldI+2RZhwihcRPJzmFh5O4/PZDXiqrxo=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=PmEsScGDT56QiN+Jy0pLLGWnyKN/gxJNzyhhd6aK3mRYlCg73q0c9rwol/PA/5QNmZZrs8OwZfgaO37mdxg0V4fjz15kfxwtcKEJDh+75IDWTyrTBO3u6hs9kxW5Z0vRtPMUcWMQKBiYTU5IyFpBkiT/58d4bWNAxWwPYnST3qR1gN5OP2IN77JU9xK1JxhBF7LHzY1G2Y9e0HuyLBd1RZwklhIWJOGv4hRald+W0e5RrWL81YGjPUbxSLNUoCPqxS9ERupUW2f65ctbSz30DYdtloPxOi2dvPO9//HihtPZ2Z2l6sNx48LQGfh3ebYCgjDKsJZDPI9M91ojIjpkXA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1637719411; bh=Kk3ubQbKAXNodGGFZb4TOQ/XxT7hCHClgdl+jbCiNKf=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=hraTilyCEzf3Xz1/kMyToHIaVcszJP3eHqQjv2dQJ6YIKwHp7DffGV2AMA4yQSYZ7QN5ETsT8VowS4tdEbkh3++cYGFS9LFR4YMKWydNPlURkN8JUvzQ+jT94yHJB6oVSIvoxE/flx1ElvjiAihZ50VXZBUGU8hQt2kYzyPsNSHvYIrck1Jzdy2Y/GuPcBbGU1d5WOoA/FbeN6c8rFumUQ9dOJcCsJBEy50sOCS1ka1SVvYPbn81UZRMm3wz96MFXTbF22EqqDqpjFVCkcB7iyO+Hez6fYOVc7wOIdrDnL1+xkKuwt/mhOnCXhX7PjojQk2L3iJrGLgtAY384u/ktA==
X-YMail-OSG: xgUVGOkVM1nXHxEhPw3sY.j_OYRqsPJ_Huiuktw0vgRcbjLDak49Y_LL6lx24O0
 TSqN1kqHycB3BvTPaG7wX3RoKQy3FMuo82MJNTaitTth_VmKUIYsXOEfWQnLy0YJCPUh8I35jHfd
 J4ZVfuNqjumX_KtVFVb6NMpG7e7nLkdJtE0bkbKG2xvCKGgMNI9OfVjCtlGx_7mA1KshGe7x9vUE
 K.5.8ozChTGi._V87HIYJBr6vD8njc5eX1z6w15rFSTgETPuC8wpzLZZK0DPIwsBSVd_GC4xjZNj
 W1T.Y2kYFr6BLkPf0H31S_cpiUE88HlzAv.5jmm.cmbye.z95.HPsV17ANiBMxD1CnlJEM_R.z1u
 9csz7U54Fkqy9.7bdojv0i4hc8.EHOCvujS9.nnHngPkN7qdER1HoFMKCPjC_nAIKBYL3rWtpJyL
 zaEQEng0RQDUu0ViFd_EnqFDIHTHb8k_Wl.xvt4g.MrSbvLCVouSNkD9eeWA1szXUUlYuYs4Mj5z
 VpEOjsIn8PzkYEs6fM6X9MDeUUU_6gtKWn7P6rZfF975aK5EYOVXoxHXG56jGKZYGReRFK76C0h6
 Y0A2QqWJwOqHfn_naJe3HYTCWlx7qpT.7F.zB1zQfMZ4_vNGdTiuMyG2Osu5xpzoxXo6gmBYtZCY
 R35Y0pUwhKp4IWxAimSx3Da7ol_yiQT6WNwitJz5gX8kv_DwtWLJnSBeYe0pSiccJJeD5HxjOEM4
 1GdOYdV2BhRN1C1GgTBBx1JaFC7uHdgprTAbq7ndUWhugaF2ngRIISPP5zDFn_yB7DpoYvawXuuS
 .6IXhgOk.ANumooQJm3RQYwy9nrJb.lqWbNZ5BdsdTqUqO4o6I_0K6ko7wn39vQcJjN7HMJAZOBa
 QO5VtuIjSgmp2CkMpN2YJfP4KjOsjPqx2tehPWt3nAOEe0pTpDtqoW.UEZ5O0QS4XMx.oHmgkyxN
 PuC.UJbv6lC_8do6t5rCL.ZJJKyRfNtIJOVbo3PywFyQ98yHoCqEiaUnvw2zULc91TWJWrlMOhes
 CMWoEyc2tph.PfkOk54h215zmGpMdgvsWFbSM65cLtlv0yAhN8ze7_1ZTSlboKEYzGOGqBQ2PALM
 QqlO2WdmkocVV5eUd.e66rykwn_fggIuzayEN1zx8Np0V9ZXeVCqa8dFPO4TOKqqz6PavqCLmWyW
 M1fYpBAq4B1AOVUv1fex3xiRE798h_8PTSv2YpCLts3Q8WDLaiVnMqQ5cG3jj5PNUTXiaWyf8TW9
 51POf8kr7xElrzvntsRoUTX31lU0C4r6GvPqKeGV5BWUw__FBSPtDf_j7K_pdPE9.BBgigfr45s1
 bvOtgyGc46a.0AZxpeRBTSkwnbBkegjYTkqOzp0gsAYwuYcbgvDLVFEFKltqYBPw3Jk_2_RYfgkX
 ShIHrKXaj4TJr_hyHNfVwWNWCnX.2sH6ELK_Pmx4txwtq.bqofX_6SgzcSALI9_9w0NkgPP6WyMz
 cVfGlEF5M2s8qFu9g28jA_AT8pXN3ymunfJ45uAFS_tDg..0pfz46mv11CwtXFVH8RO3HfjrefeC
 gGKimdYrpfZ1FJaGVouF7VP_ZhOMMfixYrSZ.o.MLjae_0iAT3likas0bYQ5ucAfv8pqTgUE.YqP
 jYYzIKCGuT6FY0AZLhRRNEr1bg9mHbbj7dMNncrssaMCSrch7uaa1PefuGE9A2EnqI_sKGUx6tK4
 or7plbTstSE90mr08RwTRe1p26WRHpzwHUvQXGm34vNKNEX6ratDTSNLkKUs1Mg9yzFhf9qAoiAF
 nSLbW5KotBRfBcz85mXrU0vA6xD7ZN_gxn9XTjfQWa.umOmAvR9u2ap8Qb0snHSNtMED.eV.YvyH
 UPERgDFVmMELHa5MNQAY4IxXBHj6.rw34KC9J8XPK_s1ZPt7xdqAh1LERUk3ZNURtf0XpsTmHRUm
 0iMrqW6vI3ltV.EO4Xf1IVGVrLx6GV7d2KN8FYb.zPeqB7sBfknMNOS1xubHMgL2yASuqHf1zD_m
 Tk6dzvl_1uODOP2HIlavmCNclsLBn2QLsQ7TNE2USUWVzZxjZlrEpg3Uw_enI2kjkYfREXuG0QoH
 rkX3hhy5GqZyfsbx7nvh89jqVnEeC1sG.BD3Npdiuu5gliRGBQWH5nWmovj.cXaOmZKyxjP2hQlA
 2K5sB8oeIZLyDvEp4iYRq8mPvWWkA1URTR9AM1E0GYsoewADPKf3Bnj1IW1HugA0PxSwYaznr_Yd
 TQuh8jPbULIdvMCz4KduFd4Q0gEIgDszYxtGt9afKFtsiIXZ.p7TDvwDQNG72D74O5A--
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.ne1.yahoo.com with HTTP; Wed, 24 Nov 2021 02:03:31 +0000
Received: by kubenode514.mail-prod1.omega.bf1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 6a5ec7ba15e43f08e83dd45ef02c9b3f;
          Wed, 24 Nov 2021 02:03:25 +0000 (UTC)
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
Subject: [PATCH v30 18/28] LSM: security_secid_to_secctx in netlink netfilter
Date:   Tue, 23 Nov 2021 17:43:22 -0800
Message-Id: <20211124014332.36128-19-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211124014332.36128-1-casey@schaufler-ca.com>
References: <20211124014332.36128-1-casey@schaufler-ca.com>
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
index f19897b3cf39..69343275c54b 100644
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
 	enum ip_conntrack_info ctinfo;
 	struct nfnl_ct_hook *nfnl_ct;
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
@@ -602,7 +596,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	    nfqnl_put_sk_uidgid(skb, entskb->sk) < 0)
 		goto nla_put_failure;
 
-	if (seclen && nla_put(skb, NFQA_SECCTX, seclen, secdata))
+	if (context.len &&
+	    nla_put(skb, NFQA_SECCTX, context.len, context.context))
 		goto nla_put_failure;
 
 	if (ct && nfnl_ct->build(skb, ct, ctinfo, NFQA_CT, NFQA_CT_INFO) < 0)
@@ -630,10 +625,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
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
@@ -641,10 +634,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
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

