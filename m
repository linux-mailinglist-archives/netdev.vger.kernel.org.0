Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A29915ECDEB
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 22:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232660AbiI0UJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 16:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232936AbiI0UIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 16:08:38 -0400
Received: from sonic302-28.consmr.mail.ne1.yahoo.com (sonic302-28.consmr.mail.ne1.yahoo.com [66.163.186.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A885C1E768B
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 13:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1664309256; bh=o4oVFCboZkMzjMN/Ordi3YRBDO22EzTXnNOZCFcA8EQ=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=PsHaHrRbES+qU2uKRyVMmbfTRYkaYnSdC0WVDbPrK4f/uid7f9GjIVyt1W1StZu/AN0Q0ixDIRsnUW41dxRDVwEg/yZqvtYwBNeySu+SX+9bWorV2yZeOtAJsQfKMRBI9gqhWVMc5tCOTIrONgZZgWSKrlAuaL5hDSHaMhkNKCd4PpxoS57ouCcz+51tgRzWhisWy+yek0g1P8fDsN2aBh2soNPCmkOa4ouNX6XthfyxQ7WciuwFjBDkyrgmaGYOvosi6qR88mzZT3Ub28cnrNyh4yzmP6jfN5ZCZBS+dlNrMY2l/qabb52vw2n3Jx7krwxbcCnupZ6kkFIYOCL8hg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1664309256; bh=BNTUEcWg4aCj5tjF3FxT1PS/ColI80EIA5vTdWKPBmc=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=ssqqfHRfGomrM3IXfp97WJUUvLN/Xu+KcA+wL+ik023Ze8yh7WDE3AlM0hHg9bSvmok6/4UH01/wGpgm9jJoxnI6mnW89ufjdyE018S3fZNPaHawyko9AoQMGjaqWBooyzBTiaJz2o35DAwrehUusdJYm+f5in8nbzI0nnsswaOeE2U4Q+1xnPmmsXPZYtyrHfJeQGlhmvLoL5XFb7OTyiE3ePmVLB2+6UlRDsqqkZspRPXir9uvjOcIPhVYcou3hGzRdAJxfc0oEe5xQdzEU2ArEi0BbPqiQiq87YAZMFgmdB8ZXlguB6hkdQ+SaHsjPb7Hvxxv28CxMIyST4xtuw==
X-YMail-OSG: loejHKkVM1lq6BmsoMQUN_Geugpq8O7nnYJxgqGKyeyqRJd0FTQ7t8TU7t98Ei_
 pHAcZ.Rd0OxmvAlI.8PoYLwXAyvT5jjH00GNHi1y4d16Qm0tKbwP8blVbOzYXlhtww0A5.cmSDa0
 moW_IV7kDFgvcnWJZDdskGsmAajVg73F83rUWlscOuj4OuzaqE1uijozq7TaiesanBZcQOCAs_hB
 uV6mdFyRljOzReUjNerdIwpa0Wt2p3O8naHu.f.PdfsZgfzB.k4XtINt3j29xL9TjmGeHsz9KbyM
 RMFhoE3Z_EroDCtFixpY_lcVlNd6Z44lA1rpPcoDYGyvz845.NpAOYyYEzrCN.7V41TEaaQwCPyX
 KHp_kM5iKH5.bskyhhFGq3OZbOGawp81T1LQ3bvjHnrLfT5tA1mP81HE.ZOGFzagackuBo2KseTH
 po.IHG9RnQjzkM0uPCa_0EMwJ04_pLZLkJUvKuWVpCVIsJxrc75zhd_o0KTBpWMm_aCamNG8trzt
 Rzy0FBjsVq5F_q9Mj2EYLaWgdsZsZozz_lpgYz0ChaGvm83XpPy1OvaIB42JaTSGDC8YYv_FcHyx
 kVoN59s7amBH4iI.MgqLcTpjVRwVrhIyD03DquhwAJZKZio9yaSbWeAIFL3j3dCOSN0hdU6PX_0y
 iGT9J_hfsf4LQfUcmn9ECwx7CLgU.TvorfyhJzIsr8QebnOiS4ArabC_Bya.8ZhuXGSch.7CJNi7
 kjgZxzUMpdl6QWedXyRrzhNoc2j8MGgFTMNWZN50_11Q_Fwr2cQqvJy7CHG7MChf4qBsQ3fKGkP7
 U5tbWD2WFLD8pG.mzerFQIi9Y55J4rwBBEVSmQ5AdYurpEAUles1pdMp7CMgJlu5egTLWLzXqcIt
 7_nv8xStVw1.E5pSTG_y0hZOGszS_g1IyDazNq86WLXn2XVVVnXbzzaf3KUvC0HTJgrbuZxfnybS
 2ncfaU3.lFVZ7nXQU0kp58Jy7pTU6k3MHRnoxhw5soRBLVMN4Tjkg8Ytj1jCe.du3UECaa0DF9d3
 wi0uqA8SvnUj1JfQAm.OK8UwUP0uvf7RR_aZjP2VdRGESGoBSHeia0d4m0dLqoBRP1Z_iNotml0_
 tiIBpd_QvnPcZjMT_MmQIpQ5Hl4L0Lzd_6WqRM4LDQcXaw9AsFvx5o4UJoB_xMQA.1stk1IF1uqH
 LZ4pzYCwUrAX36annizoQrkWmDZ7JZoLrj8qnCuJ17nLYVLiakm3M1grkXlJf9Arq56Er68J.kJD
 qLD8pXBC109L73mnhr_7NGhUUztT2KXCsOXrBRxsNFdkwgPwIE2AANreGtwCgwkjHV0WKAzfigAp
 AEYxKSiy4auvTrtPz4Lu_GviU_K3S8L5.4BWycbT95Ofk8jVZzLjeuENr8ByCrpfYMnrGrWK6IJk
 wp_ZY4FMYwAmgIrtey0GwjrxH4oTqaH01WXJz4AZvP4trJ2h83ybx6UiHOJiOhkPNUjFK.r4U.Ei
 WDIn39TjZpZeMJ6moAtGZIT9EwHsgdk_nH9PV1N7TVFW20A7uR8AJnPAmWhltFzm94bzygJ8K9hk
 S9AJi4J5ymlVSGIi0Cdg.LGWyzd3_CQCiBlxMfe22ElOMvDHmdPQ.y.878tBdx8cILw79BwQ5Rp5
 IFCwiBuG3k8w57l52CdlMhMlGHm8wrkV5ylnKASw1nxYKu2ZFznwLuFLNBa6twMwo6.cuRZcj.FJ
 zwYvhpNCCmdLJRXY18oGmwyuwAfn8anrEc9P4e0c80AKiFvdg_MG6lPv71RT9Hzf7mlWxehB0xhI
 77q61cnnzI8GSGnVqy7HsIRL7DoQt6Up.ZB9LxQJwUkeZ2t4rjisgYgVgF9CMp.B699C81TG8.Ke
 8OYvYTsx4JG.pIFuOCMo8b9VTkUxDtpyLyonP_rhCoOPfK355jTbsLZxE9J4lh6QBknccH178s0l
 X27fz5dLg_53uSS31s5W.qjWCe_Uuev9ZBpqd50LU3yRluJ.6PMwsE_SJHBgVT3ffvZUdlaPF3pL
 0_DQikPSS6jHGFMkMybu_5AySVL6TAdegmvCx2Nil174UI1F5stnqziQ6w65YAUtwFHA5OUa6Br8
 kdeprrRheWbKj0C0gkmxzk0Bfhzs.MyXBAxsxcUu7FveQ0GalQafE3LKw96.XD14SPfquL3V.bNL
 K46DOULYmsDmDiTMN0bdAuWpYcFe89aMsfTSkV_Ahj6hfdtOnMf7AXK22D7alsVCMh8sSF8.FIRm
 zUGtXVvKFDlZudBcrRUrcKegkiZQvnJpVilx4AJ12mvknmnfi_wcne7fdTMEfy18FtWHI1zCxqLQ
 itz.EFAZC8yM-
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic302.consmr.mail.ne1.yahoo.com with HTTP; Tue, 27 Sep 2022 20:07:36 +0000
Received: by hermes--production-gq1-7dfd88c84d-mgq76 (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 3a50061892aa4d3f76ff4b42bdd2ab9e;
          Tue, 27 Sep 2022 20:07:33 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, paul@paul-moore.com,
        linux-security-module@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com, jmorris@namei.org,
        selinux@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, penguin-kernel@i-love.sakura.ne.jp,
        stephen.smalley.work@gmail.com, linux-kernel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH v38 25/39] LSM: security_secid_to_secctx in netlink netfilter
Date:   Tue, 27 Sep 2022 12:54:07 -0700
Message-Id: <20220927195421.14713-26-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220927195421.14713-1-casey@schaufler-ca.com>
References: <20220927195421.14713-1-casey@schaufler-ca.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
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
index 46f49cd2543d..3a7d1a693c5e 100644
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
2.37.3

