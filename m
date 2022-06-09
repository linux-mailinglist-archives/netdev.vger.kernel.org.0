Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E44AF545829
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 01:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345946AbiFIXLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 19:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345952AbiFIXLp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 19:11:45 -0400
Received: from sonic316-27.consmr.mail.ne1.yahoo.com (sonic316-27.consmr.mail.ne1.yahoo.com [66.163.187.153])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FC612ADB
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 16:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1654816302; bh=V+vPgvaKFDTnMpIdljAHcVYg6xkRL77vK84TmLoWvrc=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=nk1Mq/e2Wjhgp0cWVrrnONe2h8+My6wB5g3exedY62j0l3iem6pd+wKfLhlhMpVOs3mTpFAaZg946cBOtnRWxIoMqUh83AZ+MVJh//M0hWRReLopz06Ry4p16jUPQKCZAeJSPtALFrU9pAxJuaGFh5TU06lhzRZiWUEcQ04+pHkER+KwpPrK/xIryB8oU6DwnN6khRKixhld6BN4zLwS8as60MZ7svo+rXlHvih0Tkhl9Q6AzNDqdTB7LXSpGejqKzXBRMyWFrPD7ww1Rs9MlSkbuyqwprZhAKj5oDo9QmZhHpep9Bhad9bCl9VYAhgbhxaG2zvY/fcuFFHewY/LVw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1654816302; bh=1hNYJYHmuIdzxwTv5xP+bHs35TcRhLcX109NwarGqvt=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=XC74rDwcc5ukkBTCDLlH/sMZGk6ZMk9a0+y6/jpvOSUWMQHOo0jSPRiI64exD29AuyEMd1ONW3NNlihbj/3ssyEE/1gNXe/cSVzU4qKpNbeLbPPV6heoreoyV87+qkBJSyU8W1jubGkIvVoPLZ8tuTjK46+HRi5TjVfIBpLtn/pBE6ap4DvN719c20Bc2S6fuoeXQ8Fwm0JcemPZawpX0YgA22B5pXINgnUoG98Eit09hHzReqqd0yxpopWwOQipr7FYHCofTqid6bQzIYuVpe40xztT03y24KCuy2elF0pmCPVpBoDaSYSyJoJNn2CGjf66ezJGoa5fGhtlpJVs7Q==
X-YMail-OSG: i0TmqMMVM1m_1bhIAMbbSH.TDDSyQJK9Oh82501AjkB9XWBHCvB0Bk227zPAQrc
 jarQB4laGFkl7FkYMPXEOlw1VucH.9GJZ2tokwR_CA3diIlBPVltkacEMJ.BPTfGrBwtGfARqVaU
 7BvDC50aLull1qckQ6pgvttj0po8HRVDyERsW4tF25gw7VMBYe7ehFQGQwSv1nBW76VP_R6RT8KZ
 MJwusE4Hcllx5Tmii_j0Fbf4yA304KPgBDoXwpJhtd_z21TKWhxPe9OeOQlPybQE.bJwqZyKsbTv
 nrWgJRupA9RfjZHCTBv_jAb4HFfCpgtmlG_wJvIv3Sg1X4e8MMKuvlAEMu7qXdbvZM6hYy2t9HOl
 HR8GDr4xqTRPn7vRw5bBo1Nt4P.erqxMBGflsdvXLB3_76wEAub20PZ1jFgvC9IDVI5ysvjGyukP
 DUm3nRLp.e_gzCosUnCWElvj19TkLDkF6Dr912HLGF2lBT.R0Hh2_TpWk5cPRmcrWVOtWiLICUDT
 JWbbzWzNWCwqx3p0f4YpwzbMBrGCFU0Kdca0pJRsRv55phufJ0st2VJ3zeVsYjQjJ2_YlM83mwu.
 5g0p8TmHemj6GGOuRYGkYFiOCbwpzTuO2GpWT_DI7NNhFmamKy3XfG1dUtyBRkuYDbxwfDtcPw5h
 CtXqnhMBfLObM_WLw9yE1Eye_RE.AU7Ue57SZZMRwFw8rcucrxHx_RUOmkBOWdX_7NywqiOK97x8
 3ltrXd5yjA5o7oR7Rulym_U.3Z0uwZ3CAfcxgZdRn7IuRv78NzXuwqsnM43ePucKB.TXmG5Wz7vZ
 _d4GC_wRHFuv7PgTGfhbkV.kOK568pnA.WL7ZES7vUpRizv8XB_bzZT9w2VGI4Y2sOfM5wCWEveU
 7bVgRjU73Dm82AOWc187c2uqCLhp1PmKHjltfW2vN_zzH1brTzwia.sBuU9wOdoaI9rguEmdtK_N
 sJDUNt0S_393U9KsO9r8uYTJVvNne_s1ENrOjq_oSZM1mY5LM6516Wzrfpz0ck83jJ.cz1r2348W
 89Y4DBClkfqys_7qZBYK4vNPfQidG9kmKcd.y9ZWk5YaAH2bMsuoC6BIJvFxDQA.4CM10ZMrdf.Z
 GThs93__U9n_fPjSewmj_M8tMNLZK0fYYFP6zZUAg07xkb1j_7zkxGJ52YGCXFTrXb9x4WmhPNSL
 ociKlPSbRaWvNz45m0vkBXDFwJG1lUaz59d0EfDivzd1BvmLejN5OL9MTsPeJp2f5EydW.sN3YHW
 gTQAhS7T.Vl4YFe_40LT73ut4CD6TfnwlkipHNqgRI5zDAve_05YrnAq2I0CY_HjS_bkhDD2e2Bo
 0LyCRODoHD9hS1n6AZ9gdysKPv1IddVIHVKQdZOpcMttcbkUZZTkRrFHiLbHKCCw0oIjfT32CRAs
 WW4Wn5H.udnc06FutES_TREt9ATzlmIoo7YtYmkklZ3aV814HWIb1LC_R4LXqS_uTru2ZGg.50TX
 CDoDZmMk1IODtNCyYJVyajn6mT7fPBRSWQatHqDJl.ch65wTq2HRLtyU1RZlflSl4Iy4oPtQNSvI
 bXYmdJMgU1zaqD4K1JI8OBknJwpwxveiMUCf83fSaO1GK46EcsJ43Awj88jPBqWD_KNf2SYpvjfI
 4Wz7bGcwHWsUlEgbc4WFZMtwhMNPd9X8u82_BuZE2XFJSfJIYvCRfdyoB1d03hIazMeGstGiPjC6
 cfSSdqHpnzWcXKCifPRwMXQCoIu.YMgDx3h7h_2.GjqH8BCRqJ4ob_dssZEafWWj9xuM9NpafVr5
 gAuNX1eX_4g44vTJK0hjzfQv0wqkhpLIxhdho1q.rhx58z7fYWFMVlczzemL5bG2FeytKLO3Fyna
 .38L0yFONAnHz00k366tj7qatc2dkGaKUxvQTZhWy4l2R1M1tLswW5JdPs4VoEMGYt1UXxEUvsE3
 zPkqQ_bfEL2VuF1Vq5y62L53eHVRL_nZECfogBYm_hf_tuWca51WzNwcGp0eAvwvwkIv2xHCbJ2y
 _oYUZr3kEZszPDw8rCweMtAvada4vyZIGNdf9sJ4iK7fNFSSQ8YxYZVkU8aanrbvGKtr9sCzz4Hp
 VE4jmLl_MBMPZwrSMDWFSKU1nQhnd3RfcXr9M4b1ygcdx03lgnkDMHEe9AYYftoj7oFdYFZgHWJu
 S426l6BpxnHD2hb3HkR0peLFjEbdi21MigZZaYrtuarbrYm.HrXBluXFzpcGoBnucHELnoaTOHXw
 _alvytQ2V.iwGqcE1vxRoD1cD1KAlMljfTEoJru3KVM5Ala5FSGT41Qp6QjR0vIOehrlGbqzoPuC
 wbQeQL1fUbWgk8jXe8hv7AX.PQdk_5qNEaqzFkXvoAqqY6HqYyudbd1ljSiBW_G31FBJMze4GZao
 41oAagsY-
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic316.consmr.mail.ne1.yahoo.com with HTTP; Thu, 9 Jun 2022 23:11:42 +0000
Received: by hermes--canary-production-gq1-54945cc758-dgl4g (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID df8474cdcb3bbd72743eb86b005fa96d;
          Thu, 09 Jun 2022 23:11:39 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        stephen.smalley.work@gmail.com, linux-kernel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH v36 19/33] LSM: security_secid_to_secctx in netlink netfilter
Date:   Thu,  9 Jun 2022 16:01:32 -0700
Message-Id: <20220609230146.319210-20-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220609230146.319210-1-casey@schaufler-ca.com>
References: <20220609230146.319210-1-casey@schaufler-ca.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index 35c3cde6bacd..f60a0b6240ff 100644
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
 	ktime_t tstamp;
 
 	size = nlmsg_total_size(sizeof(struct nfgenmsg))
@@ -473,9 +467,9 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
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
@@ -610,7 +604,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	    nfqnl_put_sk_uidgid(skb, entskb->sk) < 0)
 		goto nla_put_failure;
 
-	if (seclen && nla_put(skb, NFQA_SECCTX, seclen, secdata))
+	if (context.len &&
+	    nla_put(skb, NFQA_SECCTX, context.len, context.context))
 		goto nla_put_failure;
 
 	if (ct && nfnl_ct->build(skb, ct, ctinfo, NFQA_CT, NFQA_CT_INFO) < 0)
@@ -638,10 +633,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
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
@@ -649,10 +642,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
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
2.35.1

