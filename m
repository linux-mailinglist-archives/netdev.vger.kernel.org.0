Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93A814F89D0
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 00:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231573AbiDGVek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 17:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231560AbiDGVei (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 17:34:38 -0400
Received: from sonic311-30.consmr.mail.ne1.yahoo.com (sonic311-30.consmr.mail.ne1.yahoo.com [66.163.188.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9FF5C55AF
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 14:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1649367154; bh=V+vPgvaKFDTnMpIdljAHcVYg6xkRL77vK84TmLoWvrc=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=AygrJMe94ON0a2fPsjkXbF+cTMAD1wBOW4wg7IybNATJ1ldbE8ThV8UM3ACdYU/ImlaXUZ5OaK40gxn4uJp4Khq+Lj8/gr0CB9hJItAfcDRZgFeZL5lWmPdLQ6Gw6yQXpiHsAemYmvR9sJ1AP2pfQT5wvN2XQLkSJA+aLSpZuL2OkJ95UuAehjSzgUzH65LqxgzsTObEUJTrXIrDTkxgwEKZ91Dq9o+RBZOOkLf3dWIBrEdKiKTJEPUW0Dm14tFZlqE3Y+fa8TruM6EF+eCBjbqz/5yTrhi63DQH3LTgT/z3jAGVszLXWAhSZWxNeN9TImzH5mB9LSFWMpPhvTzj/Q==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1649367154; bh=IthVljW/O3+ym3xan+CiQyL/TxseU3zfVxmutmdIVLy=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=adqtxX4UPGAyejJcAMV039mCZOx0vhGJtg85h0gz+bwLrQTaZRyIwVwviNqE3pv8visGk/uJiejaqkhSV1LFYW75+V+khqETBS5b1Fm/gcKtIovcJfUh9q9pPRCsf/tf1oYRifOGBE2DaspzGFg09zcCe4vrTIIHoVbYaOA5Tt1nsamQCG6aq1RF7K5PtVdcxaNgkk3CzSL7bt+7Mg4UYB9wEvnpbUIq5pg6P4HnC2bBcdLAa/72vyZrKzKWhlwr/TePj++yENZ7OuSqBSZTZawuRBYOp0ok6InFgkTVqCFP4EzWesxYHe9LLj98iw7SolYxfBue6kAYpH4KhgVuJA==
X-YMail-OSG: yax_31YVM1mm5qahMKHiRaExyFbkPZnxhLs1FuvaueA7bZQ1VLQi4VstymHrB4a
 eMnH4oYl0l9Ae6uHY0__fMeD8oztv5kmBQLYUy7AgUBoCEMuIhdEjQZPOCMAs9so.E15jQzn3Q20
 qtLU0ylQgdpyocFGJ.UUBQsvxuDDN33Gvum3qYV.6Jm6qP5d01FcjQLmsyL2Cox.4XpVpcblOTRs
 TPiHBR42APa6jk3o6QxKf4EN760kJZLTISfPkUgziTPFhGyASx0PS.1Iqu61nTbprItEC91jMrjp
 Mzu.wSMMIfkiFm23.OMg4hwWEKk4QtjbmSQZnsft5ahPnTgcPnRkIEEt9wR4I70MMqJighIB_NXy
 7aLOylnCO4GDXnwT1PUTCIbMgx8EPinR7ytUXM.9JBOjflyTHP3KTozXFtXiUO9QliF_wGjphlg5
 WyvOJyB_hMeHAMYZHGkDluPPBRaO2TPQDyXwoSYr0bxF9EtAsndN9KCnpvqLGjMSJTXZrEIJ5NU9
 nLwENg_R2q29DrchuJBs4rT6eiJCdyLxjegdyC8vlp4hlP_9nuJq.nyAXhxvrMuKXUs_G7HcYKN2
 5iDUy.lmwqZxXeTtdDW.UJzKndSeL10bUtBQuv7pwlMs2U5zeAB8UitHF71g7EBg9JQ._NUWMRJY
 zKjrmnTeBeMz_RplPKn9BAvZRnKo4Zkp8DHD_VUjDCNFicxZWhGZPsNyZgPhM_EfKTyCKrpxZBGf
 _6Ccvz4.VTnLswmBmL1V..FshiM7nbFYMm_fQcL6pWO_TrTrMyF7OS5V1e4joUQjdc_78P6I8b3r
 6G60eHYuAXEamwEuFTrBVQPuygdeqFdo.rKO0SjUGJauiP6RMKj6BHzoGUaFrZ7KzW2VIaywDQHF
 zOm5rXBYJ1GNEzJdUKfgmFa9kAt_B1KmGUsx7i2nrtQFEbTUgBJV_QZZf3dRMdvupZeNs2rJrZwT
 vGmgFiubl5BMonz6nwkwUJUvepaGr1uUVqh3MwWwz_lFaU5l1cDOg0UnN3uj97tsd_JJEMxeQCaW
 6jJ68Sd47pCQHu_.ziF8KdAnA5bQLnmqTTNJPGWYlfjaTgW3n7T5QA1vLjVUKihxZxaPrNwjZJ8A
 iJRwZaW5DCUIXbvmzpuwxW5S1w3CUacvZ8mmF7w1_gjqwltVVP2LbVG8b69eg5.bUMZ7aYm0d3y1
 5cWfS83GSpmAGPPqxhUxUx8IGg78jDUpJo3fztSR9CH_6.VaHhCqJEnvXvtsaM7f8BCOSvKlzfV0
 ULh2rD85dRY4PQn0ahGGooYu1jc6MD19RBpNvyigGCQ.H897pfgi2wjz2VsyRy.v3hoHNp5O0.cY
 wNzjbQPaBm27erCMTt4Posk1NcekQudqw6esy4FqvHMRPws1vX66CWHXHmTLnCG.qIN4Xu.rpOQ9
 svioUZucJc15RvtNKW7BRRgE77J_7bRlf6rHZdb_RenlLjZljhZ4CD3VWhGkzqHxKr9cWAeM94cv
 huzMbWEPtS38luavPXpFfDaLSJZZxn._bXO3vn_kNo2VPxuy0ymaAVO8EHLWs5XXTRYQVqmHGiRr
 CWvo04DWOrfMRfc2I4niyxt0g5MG4OgOrccMgtlUql9vduBdLb6J5KEsve0mXrx5GQ05hzDaOQqQ
 uzj4R6aQzBzEN9Z94JhC1mRMNeYb6uPUcQ2jOD7Dphi.Dbu_PBr..udDkCvG2r764d_RKlZFvz4C
 TgAgbINzUS2KAtKX6ma5_F6wtFthvbZddeWuBJAIo4V_Cheri2SK5yCOqtWGvz18uhoRwrBhy2AU
 wAmDa5LhpQ99VLm2w7OMIdLd3MwPdIoaFPYmtJwHzdIEKfZ7oMRy8gmPNEkdZFquN_YHLNuFje5p
 dMAlbLMi9O08649Sd91J4tbHqICLyUapg3bfPOPGyUYjFMItONU2IcRvxQ3RN_PXwBRvDtoydVd.
 6JZAtpIBKhkahJX8rDCnvsupoFQUX6HdrIHW6c1oB8g5E2gATI.mp.8RvGQhgIT2Qx3Qmdk2HzIM
 GdyMNRkmm20HVEOgkb6ebsPFxGKGNWWqJHTgzjSfif2UgWjZ3m0_6cjBrzhZyrJa.sR3SLvfVZkb
 dHz9zppWqNu3vjcAiuBoWvp83HL30EmHbwW5ZT5IztSzjd5T6F8QRszLJYQHhyApjQP3rRMfvlTB
 ajfzkotMozkk8wnlGko17xBhz_1HdMAJPoZJNMV2s8U7HM3snKIQ_kzj8pGcKz7k5ZcEfoBDkNTe
 QGsDViaTJA1kw3auPR5JnxO4LRloHwhtfIuuEujHDQ7Xs0ebD6XjikRkovSWo.YANPT_vvKa5zye
 MeQ--
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic311.consmr.mail.ne1.yahoo.com with HTTP; Thu, 7 Apr 2022 21:32:34 +0000
Received: by kubenode527.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 1c3e27710c5567bf7ba0bbb257134c66;
          Thu, 07 Apr 2022 21:32:29 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        stephen.smalley.work@gmail.com, linux-kernel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH v34 18/29] LSM: security_secid_to_secctx in netlink netfilter
Date:   Thu,  7 Apr 2022 14:22:19 -0700
Message-Id: <20220407212230.12893-19-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220407212230.12893-1-casey@schaufler-ca.com>
References: <20220407212230.12893-1-casey@schaufler-ca.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
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

