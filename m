Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCCC3417ABF
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 20:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348006AbhIXSQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 14:16:30 -0400
Received: from sonic317-38.consmr.mail.ne1.yahoo.com ([66.163.184.49]:33538
        "EHLO sonic317-38.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347987AbhIXSQ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 14:16:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1632507295; bh=sPePNFjY2Hg+Qwx1YxPQDr6XkSh5fD9D76yQuIRPlvY=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=WHmzgIlQO5DxwYjLvjxspydmi/6c4syIqcTRZsephHcd+axbdtLZgTzLH0Z3swcoea8mBfk5OuTKyfyA8TM71ImcDmz3OkRfusRpe9Y9bGbKwxqqAhnkL2pwuPeadM6O7YsSzYNE6vpvjdQVBOA5pBFO19xt8A85WkhG3Lf5Xbei9Hs3n9n3uA9tk85BIIGpU1wk3/SU74KofsFitNcJ4wjo8jV4P5ZIwlCUzEkXbYsOO84jZygP9d3dIYox8oqtnSaKg4JbQsVlTVQWYTDQ0D7+Xc8BWJMD/FJanTIevnwHC9ijpmO6lIJkOxkhbQWVy18BUAMLHD+3Ue7mX+74jA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1632507295; bh=bbVA5A5F3/m6qi9FShtU7Zd6OhjwtVlHBEB3dEGsvzq=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=XXaiaI9hSz9JLMPCG39ZQlUwLhE2tWNEUDoz2nRoycJ8J/n7GwYbNkDRB8QKMMqYDhEVpdjR2AS7KZqdCV8tNZx/Ik5MXMjSrdgFa95c/AMvc2CpksFsS5KXaxyCsCCv7ST1t8Kcj9LwquFb4UHsfwW8/oWN2IcQrlZsHtanBtx0ez4ikM/cZ+32zksMgR/Cnha8Wk2E8sDfCQFC+CUugVlF/c/sbWyEywWy/uTV/B0sPYOcHDtjz5cxPaWt9AzyhWqhonDvAf3rBP8zIVyQ1iO67VUmlZqpYF1Jv9NrssaptiR+Qczn3ikIBWsuVQyMvnOsMuAZN6ueQ7Wmtoetkg==
X-YMail-OSG: ST2zd64VM1lCIiulQcsej982B9Y72ukKRweqY1xOP_UduLwwFbAg.Y3j1KEn3oQ
 Ke8i6aQ_4mckqePYEbstJ.ytW3wBfUtEIhUWxZGik75KQv1H7fiFZeGYxZAj2ifeYB8vjp4QChaf
 VssHzrXo5PwoE.7QGSFqBv8f6GUK162ABQBtaQZ6UOvRes.qoSBB.DvTtCVYN7xeWwWNKIGnN1Np
 wy_0_aAoNuWxqjKacU_uej5MPlnltU28..aKLrefXIf.UQ3Y.LQ65cnOFKSX6DBfzEQBGwdrfGGi
 znnIZa_8JvvmGQY3urE_T278A6Dsz.uJtCsbZV0SpwxxfGFRiDfI6NvPE95EgX9sTeqj2wGPQCbr
 aUGChQN.boZ8oodzob7EzklXzk0te8U.3BMSPXlfM7iTACJXldiAbIaAY0ttv1I1DdWtE8kD4VmH
 Wm9yvxEJlgWkP5FN8JtMq3nMouYbfxbEXUibzWYXh_s8wNHu_a0f.oMah8_NrpvrxWizPlxhqjJe
 J.2bGv1ze9zu_Fo5bqMrF_NpTonBpggIM2LJj37nwL9n0JANm1cT_tiYFaodBvUNqeFxLzfEPoET
 pWTlExRaaV_k2.QL37_ASplzoxVOEvXFSoeV67sjH_5VkWiqKmLsQcbJltUxdSCD7ywnwyzD687_
 uY4prbAKR1rDvJ9QioLuJ1xta1.45kiWCUuwTntorVB9KoMR5Q6jgXe29R86E1XBuN42H4UT.7Sf
 u2KLmj11rSug5lsS1m.BJ5_WBs5ZTdC0e.oE.Udwp.NCqh54gabfCDXdJXr8gBkRVNA25UvyMZCH
 Pxxe7n78LrciF39ao8xHiGr.xDPiL1kB24AuJMFa_45G9FW00TZu3nsVpsLqFZzTgj8SoJ3woqrH
 g.pZZSP5CvSbGOQ67L9FcBf9xeQTjR82hBhe.kpJ9_GlnczSxgWVRwGsm7M9AkNmC4WcNL1h3G9l
 D6TxacNBr515UPfFOCb.OcUV9opCCwKv8sM.ZeA6e9L5UGWfAac.v48Jgj5GUybvTJYcq3L3RLwI
 FvJUmFF84wAgrW.RTNgRhBqeAr5ivPMO1y4oBBkYQFFOE3KYL0gkEFV8M1amIEmCUNYLV6YgnuFN
 Na6Y.mm1IVsdpB9zQEQjBRrk4flm1rmSz.d9wfKh3R0lxSxogh2.N2T8iy7EGdkM0bGAU.ycZDQ_
 03MYzzjRzyz3KpAV.Z9PjW7urYS_WAc3hPsA2ZhCEHrFDRPwMhAp53nsCIm_.IvZfkMMMptkK1q9
 VmqiH_E83JfeWLKbFpxGnNfFH.0I6AaTbCxdzcmFiS.rBabRtDr5JKB52JOpapp.KSfVt2wWmKos
 z5ckpDm8qu3hCacl9_7KC2OGX8LzzrwG7ebxN6rNVK8dd5wM9Su_t.tsS7YmexSrX3UHyuxWUDnA
 KJjKfPgXJGOIKRprC1vioN8ThMy..8T_BIYJXJ1VPEFW8Oq2UW23UU78Y9EiOB1Q2cGajRv8q5O4
 B2hhKFVE1vy2VMzQwbCF._BFJYCcagKfOTSbpjvDA0pyOMMWTh_IWqCPJx9nlGIwVIgJebMwXVuu
 ZKvHRd.cdZUIGSfUw9u6l_TPOTwlTzRauisu4m8eFJnd7G2W.WoPejsYEq8eYzwPoVrWsn6F.TDI
 ix2cuP3FrVYHplNcy3Lo6OUNBb9FcV6hTP0zZj_JWS91HBYw3LKizvlXx03ofFUJ1qhAdQ3HPz2l
 PyhGSHW1KDSZxvRpFuf3qwTOQEZIs8.nVOtbjUgwpPNKOGTusDf3tyqWI92YEh9DeW.aUDu0jrMl
 mJsWzINUJJ5vqoeCMRYYAA5Buz_RIZpQJ4AxrNSz4ebiCsNVSxOq29T80owAfnaJILliTwqnPxtF
 2qvsyp91HavFL1OKo8P5noUgSMCRFu84UaE1XyuoOMfhsGyIV2nu30CEkVq7Er3ZJqfaTdmZMfeg
 3az5fLfXv3DTgJTqkDPyMZFdQnwmtSXNTFKYlUFUQmLPBpDSGM2BmWKVzteNGscJX_LsJeR.yFyR
 N4T9jmHIMBzmN.Bx_jIZOQj_TUzqA5xQ6e2nhf9HsK4mgN2ce1tjJg3fIOwu2z2sE4R1JRN55JO7
 d5XAN.j4.ib90NyY1s3U8Dzs0SSJ1R76YLyaVHDmUeTcQmToCnxaFcDS9muHhPzTNgVQYAmHZPnz
 YSyZ7jCp.O3wNpfuau9SX0CCsP1DwwC_EzvnBwTprlBMbcCHPQez7bR5tMN_DZqPsdqzTsb4Zae3
 SvTIn4r7k6SZ8Y4.EfYOOekwms2FnodCfQSKPD5XtwAy3IGCAH1yQoDIUR5NasaRtfNDvadyP6GN
 8J8UcYi8bvhQSDlon8VG0JIhnlhAhCHi5AfqmFGY7Kg8ZJkLcd1BKnFMcj5hCV2CLcFzLpPtYtq0
 iD.lN_NYsXqG9PJAaAXhSepyW4EGGBFtLLS8p.g--
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic317.consmr.mail.ne1.yahoo.com with HTTP; Fri, 24 Sep 2021 18:14:55 +0000
Received: by kubenode520.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 7dd4eebf105076a5d757483ac2549105;
          Fri, 24 Sep 2021 18:14:50 +0000 (UTC)
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
Subject: [PATCH v29 18/28] LSM: security_secid_to_secctx in netlink netfilter
Date:   Fri, 24 Sep 2021 10:54:31 -0700
Message-Id: <20210924175441.7943-19-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210924175441.7943-1-casey@schaufler-ca.com>
References: <20210924175441.7943-1-casey@schaufler-ca.com>
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
index 4490bcb2a8b6..b6922af82911 100644
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

