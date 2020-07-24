Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD60122CFFD
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 22:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbgGXUvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 16:51:33 -0400
Received: from sonic317-32.consmr.mail.bf2.yahoo.com ([74.6.129.87]:35345 "EHLO
        sonic317-32.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726562AbgGXUvc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 16:51:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1595623890; bh=uWNP/f0MZF916y2Cwsdhr7gT91hrx+SqsNnUvBkdwps=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject; b=RN3Ey1qXdsuDBYIU0Z1xIsFaW58OqaH7RWeY5lizVentp3siezShyQC0c1g74kwCoVHc8b0pESEz+WBIlbURLtUgJrFKOxa0UvLSjNoofQm8XNJaymqK2RO5nOTV6UYOpO5p3kTp3MdYqyof33pfMWm1af6Xw1AWs9kLe1GSzcTFLCzQ0qSDlLGWChxDs+Fln8ILvkTu4LMq6VY20zbfJU9rlCkDiuHPICeA971NHarHGXYyP5MliBECgNw8Kyrew6DtLt50aEx07jhiw2gVgaOO+igcbKcmyTbJxorhBQgnm9rgJyYOcO/oVjxPkdThx7Y31142jbhXKqok/SLGmQ==
X-YMail-OSG: 60hSpgMVM1k5SqOQDeVFnRBkvShqHBYgDb8yo9goNG1f0JpgcLBrKtXCJs_xPwE
 18QYPUr19UpDoNGp3n_rp9WmDgo60xLumoCT9IFWRCld1Y_CRNcetAWa0y2ufy6c1uL4JEW7qlBQ
 NxL.xgtXDQ0dAfsAJIZzdiPOYXZfl0QaDYncnGkPfRTMC62Wzg.Zrqpoo2ybVz.t6LLywqXNtCdk
 jV4fe1B_DKNi1f6alZrSv.x8q2eL1jmoBndzmm5iskpzmUTF0OFaUYUHXzfT2.HV5Sl5GV4Wz0Eb
 GrdK2f9zDhkERA8Fblq55P.OYHVrOxLAnVwoZwgWQbiTDMZsmMw3SYlQI3.8sQnELTljS2pKi7jd
 o0qzXQicZsfkGOIGCZYV6YD0EA2cjjWVTvEkP.vEYEkM.l2uYAtEaep922.Ql7LNQbhgKRKDhf.X
 x2dyUJRur.yNsTLfadxUXB6pfmeGIBa1ZGcKY0X9bLO7nq3XCdazQ70YQBWiH7zbWyPntcp_mQFa
 f9EeBITNrZiktZq1ldo_qX.YAnTkTtPGbV.dNv9.C0w7xayezOexf02.spqjoAE9W.kG19ocqwrF
 lvQ1xU_1JPRCPr3PgPkEINrq2m9wxrUgOi8_OK5nWYGQdPnPXFqS5sBv3BLYJew5o3hbpp1GrtbI
 b7f4zxJ53WOjJVoMb5_gdrFjtacDoWXsth.DloiuFo6M9iSMGO.XG3yB2eT.5Vwy624OPbAAarqw
 5g_2k6VMnmQka9KYfxfnaYhi8xsaPTcrKeNdci3CSHE9zGgoDDFWf7HUFf.aWN_CaG5Q8D2IXoOy
 Sch9gx3b6_yALjxTRyQyUU2KLQUlJCo0MyP7djvK3LayWWGGmaqmSQfHD0ai_.o4vABRhTFT8T4H
 EWKMz6m4RjC_swnN1vbnTL7nEJjyaUuj2hvEEbYa5rURPZrfwQtrNgqABp6.8VArPZdYlMRLLMZE
 fnirULDNhwmvRxNQCvF85tW7_ucWEhTP7HvJBH9qszp3PRSx3GLXM0M3Nz08BwWiDyh1.VMKOjLe
 ppw2wWc.URsh6gb1QhMu_n2GXkxWWFRGqdnh7BA0ttrzvd1xcC1fARXvXxGv19K1YxkphaCnSt2F
 8otCYMplRQ275PB2gCcMt6aPNUBCK5vXLGH6UM0pcvca1VOWnLjOuilh8VRcdQBci31NHM_R7.bb
 uJ.kONA9k5SH5rqw96MlE2OTFZEAotY67glJHI0Jtv4yRtmsdZjY9a5CtOzGJqetPRhF2SuAgFNe
 6Vrzxdj1jf7VW7zszJ5vRH40OOKLVYLr8NsfoOquwirDA.T0B9eOlWh242T.zJgqVB.CKzcxVtGn
 kpFJOupcK90LUTVxBP0TJHw9ION3FmEnWT4oCQNLyJ8zTN7Wts_l2G5YBbPWUimGINDOPGTJlhHP
 e9yf.14rS_62xEwU_uYQCLGAtFNdO25M_VuBBuY18
Received: from sonic.gate.mail.ne1.yahoo.com by sonic317.consmr.mail.bf2.yahoo.com with HTTP; Fri, 24 Jul 2020 20:51:30 +0000
Received: by smtp423.mail.bf1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID b2481097b4d838262c5392d963c16744;
          Fri, 24 Jul 2020 20:51:27 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, netdev@vger.kernel.org
Subject: [PATCH v19 17/23] LSM: security_secid_to_secctx in netlink netfilter
Date:   Fri, 24 Jul 2020 13:32:20 -0700
Message-Id: <20200724203226.16374-18-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200724203226.16374-1-casey@schaufler-ca.com>
References: <20200724203226.16374-1-casey@schaufler-ca.com>
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

