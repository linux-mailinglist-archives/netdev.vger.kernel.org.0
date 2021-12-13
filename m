Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3C1A473927
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 01:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244388AbhLNAAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 19:00:36 -0500
Received: from sonic315-27.consmr.mail.ne1.yahoo.com ([66.163.190.153]:42477
        "EHLO sonic315-27.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244382AbhLNAAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 19:00:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1639440035; bh=IIKa//ZfOf9ldI+2RZhwihcRPJzmFh5O4/PZDXiqrxo=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=At4f0v9ZRIeAl1TmpXlWbNAtmLwMyclenQ84AtCqi+1JgsAv+dFNs+KkLTH7qB2RFVc/TlMRNd2wuPXVDdZqKn0pmWbuU/mKSjoLEhn5WosF6zjJd7w1h95NCtc2ns63wFxsXEYdNs0/GdER9gytuhUbeQc9rDTKA0D3JYDOvltiPXallT3OPOS0Mtc73e/yALQu8vGguN7b3aGwdqLU2pIXZa9Kjlj07CuRrOUSOwngrFeSQvrPqmgA4CVoqpPTOA5RNPlP9Tty7o9mi4/gVaG009pwePTIzOI7aDk4mBYZd3VZilzTxel2w7n034d9nwbcy01ov65Q3phIdcdyjQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1639440035; bh=CwPoWL/GQUcdxFWZsBGI8L44rlH3jTfPje7Kl4NSJE3=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=rU6SnYCpMTBsfLk7PNtn1y7yEK8+xbithXL1qp4ja/SWW/3H2Q836OVdwiD/bLQz4/Bfrrn193jtI5u+kEZJCMADCYdLnHl7e1OdmfAJNfS4PzkK2KK8GK+37dFiHrMcEr9RnLhTAT93KzY8xklYlg/+U9SnpD5iCD7yuoZyi0YxjpOAhoIUPCM3CovSCLtJNkOcLikcav4F9gElyzq/WFtAgLLS/rgGGdrBo+fY447l9rWKgllqtiTnBA+JAZ5AI8N8AYRIf+cXq+Jj28rF+k1pJfGFSXV5jadcal06HIsK8E2/Do+MgjrmW85JsLeI+Hs4kW2tP5OqQ0rwyxULCQ==
X-YMail-OSG: rPKqrxgVM1n1y6qm4CPuvvnOVf0sfan3XVDMFwN.kTgvOzpa9FWkCNIVLgeYCEG
 FtwLQMWh8g3bXOiaXXiwPB5Y5fDUAycL0zi6wSChz2rLMumeZnpQcI.S99zEqtfgjoo8VGHkHDKS
 fDFz3yvgmhwxilA7bIPpAEoooo1iT34NZmS88hByExLZkuT1qTOZQQEfH5rwZtz2mQE80zbFHAo9
 JCZcMo5pSTVE4.lHuVK75r7Uqh2o.zeTr49hZLuV96A8rEux0WWcxHEvGkLdVeiwpDC3SPwXt3sX
 B3X_PtcywSxTSWiqgJbsCVS4pUqF2p3WxLMfdYmBQSf_cgLRL0uHP5O2LVGbK92tDXOa35bTgn_N
 bfAKE.72Li12I4EPPMr16x_NxcXVAdA6c7udIeoa9zSiLzr0rBHzQzHpY0.otklcHyK3w7jPDo4R
 pFggCihPx_DybzA9ywLAXf.ZZJ_mzTQ6NkqtvIdSmRmtH.oTtrmEHKeo6xEe4.CjO.Cdi65DKqoh
 qt3WYpzLX7qPJNwPOba4WR1U3jEYK3Nexfjf8fmaktI_BFtx5gbw9de8XCPMaLril4KiZUooCW.n
 wcVTKTVlWSE47NrNIp4BMca6PP_0dbYBqe7iyypRjWfZ9LpL0Ok5sGYMmi3btJNJi029oM73ssa0
 _tbK5nQxrpyPSGzN92kQFzQcYnKqyJA8M7YnD3.WyEwv0izfGbozD0R_xmo0yuoKLrMs6sgKt._B
 E5P_GoyPj1SarNgF268uT1SxalLQoeKL3xEyEDzv5yNyQZeurVGj4tx8Zo0yQCakpfigSfoOj.za
 P5D5xw49SYDGNDg9aFyRLvgWxQyWmOCjAiJ.yzgAzPg3m_Qg3SZmGdcQv58LoBjYrFQ8GXeowc2l
 uLryjYaUrQw.TARsYK6mpVRF.lKYUVwqvsb1Ig6DPGWaLSt9a4zHwI9bsj4eG7oYXiWLi9ZvJLRE
 BGr6LzCnrBph8Y2x5BMWNxOepov4I04eOvshf_ssPAWJY9GFQXqiSGaUiPD1kv_SXd8SpcabPtAr
 ON5UNHRETqoRb1i9jWdLrKGhFc7KKLyk0dv5noNqtWfGR4kXHICDNfChFVVvPW0YZi5yLQY90DzB
 l725TIhxBDnNQNF69mbJsiRFrBohmqsrUFfUO4uUYIhbHbth_m1VSLD2_1zHpSje58DtjZQPvEkb
 O2Tz045REDfWYoggILcqaOGfMEBDtLko0SRvAjDX3f4YcAg7hhhdFhY225q_EAtPR4nn3B6SSWqz
 7RXesQuGL3v6A76QMrY7x.id90b5LVF99YWytqI1yZ6VkOgoEUQaUNNBiZMWUjFGXPDPqYe_exse
 b7aO0L_ECXJNhRhX7I_TWWisnD.Hd0XkkS1jJO8PZgDtFpWIuFeFXCpQj.5G7lJ0oJzl3bq6hMHq
 Ik6ANLQbg92yoAvX1S.p2uHzwmUbjskZLql.PUy8O60tqCz8bmZaSTeYIhKpfPbZ7vGudtimqScN
 8UrPSQT2_1trBFfJlQL0LSQI0KIQUz4AWJLOd0lfXzkzDVJt6fC_1PUx8kFz_vzCqZAhpiXikOU0
 g0_8PEhMXyoVUly5bY8ukLVNcLXyxt8GDTAV_Qny_G1RHtlkp7Nb0C69Y6.trm1bHBqtcjQ6AVfI
 AQfnkSmOaJuvLeDfsM4idMOMp.Td3oiVWDqhfghguGO8aBLv._Kt0gVgKRTsi7mSgFNZqAajMvM6
 m4BN0UwrPtluMTeuLUNDXCl3JS1eAZXcGrPUDH5qg0vlLLe8JTLobnVnq86OaHKhoXSs5slZMh.I
 hKg2WjHwqh1TMQd_VYQk75cIQi4QI4h2mUHCDU0Wj1mM5jDtfpFCDp5SwPc9WOkVYtTfd5nuk2BJ
 nR7O3fefbTr35SrD3sqFqr0URG2Y.knWgEAWoIJ12LCeXuYUdFw7o8qULYzYtKgPs3CUO3I9RDfr
 1gMEyodS_xjU0SJvoJO6wiAqn4yGalNWraMG7mNg3C0t705b4nNz2bfCuaSxfjUPwGPKhPnNDm4J
 p_5ZT.mSc.iCqiDNz7DVdBetBnL9TDXKoD6tLWKKZgM3N0AxHDouB.urlhXyNyLtiAICZ_.sJaDK
 SdEHX1D28vmJCyx4jou_E3aDk77TCaL9V.aeNPii6As5m_YDNtZLqhYVpr8W3FbJhASUHsMVVSGs
 L3DTKqIqgyrZSkP.a1SMqrq2y6omzEU86kXkqdHXYnCr.GCBqO44BnRnRpNdxiVvZkaid8IYR_Cu
 mkNh56jOIeA3LLoLASPGxVC4V6hfWf1eLXv_3SIGqPlj3fXSPmmkMElZk9KTdLA5QFUu0cMpRZH1
 bIUNCrX7bVNmDYrSw3G55Oc.ZNVmpxyxEUlAZLIwDXiackaI-
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic315.consmr.mail.ne1.yahoo.com with HTTP; Tue, 14 Dec 2021 00:00:35 +0000
Received: by kubenode516.mail-prod1.omega.bf1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID d9da30bbc942afdefef6ca173bbb7167;
          Tue, 14 Dec 2021 00:00:30 +0000 (UTC)
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
Subject: [PATCH v31 18/28] LSM: security_secid_to_secctx in netlink netfilter
Date:   Mon, 13 Dec 2021 15:40:24 -0800
Message-Id: <20211213234034.111891-19-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211213234034.111891-1-casey@schaufler-ca.com>
References: <20211213234034.111891-1-casey@schaufler-ca.com>
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

