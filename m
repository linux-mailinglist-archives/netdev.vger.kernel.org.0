Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F313A4D560A
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 00:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345041AbiCJX52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 18:57:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244680AbiCJX50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 18:57:26 -0500
Received: from sonic308-16.consmr.mail.ne1.yahoo.com (sonic308-16.consmr.mail.ne1.yahoo.com [66.163.187.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB1119E020
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 15:56:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1646956582; bh=OPmcc6RxdekExVViioUe9rMhP6xIsP6mDCh0RBi/+Qs=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=ZTnoooEHvtGmaJR7s/T+fN33dVCzNFRinpgZQm/9pcbRNcnuHadKYzueRV/i34vLqYracBfmq0STVDuu7NbMnp1qtxCQjGsAXHbgl1eGNHAZtc6Q+xvjBzEKbYoEC4IyMae/3IuamsTyuV6Wuv0BU1dMjU6kAocXTw4x17iG8JCrPdxHI5hcf3TO5//W7ugb0vI8Oszmx9hM1e4jNmq1aboTLaQ2f2aR4hvqcoNwQos46TAHlArob9Xu+DgLXGFhcxP4edY6ms6h7oye0wjD4N4TtVmH72nnpd8XlOSZphiUM75l3zxZg5Wotri+EgzAZcpGBvGLFfviZ25FwAwMVg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1646956582; bh=zx/ZlmAdyeukqeKIc6uLlAB8jfa4F95BXi3gni6qPlE=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=tM9mBldcIsd8uiEKWgEJwjbeCzCqahOAFu1B9n078pf2zHkBXVwdCVtSO0mMzjauhsDv7296KMSTMcKNT/vHAJcxcfIfRX57c+5x8s2+jHlG/xKuEEVIY89LWahawoi2CySziXy+PN1A+7v1PwHgvSx5Eym4zFFt9YQGGRXZFgftx2cqELKXLgFoAzfZdZTT70V2zBzkddZUa8G2+UqKJnuilp7iMhHzivzY7u/pIfcm9knWV4mcHofuMV0Jp/4YRo0PAJo18lLThhVl9PX9WNu7aHmlY6l21YwqWK3OLLvmfHgc+ySXMCgakx4xea4HIPqCrO5n2sb4k2r9RPLwEw==
X-YMail-OSG: 4Pso2ZwVM1n058ndWUGBbvG5hshml4p6ImW0hUEPPCXOgjXGkQAeoUL7a3LjEvy
 3l9ouau01XTLocS3f5mGXpY5ewEeWD4.3oXm8QHmMq.PCOFlBl6v2VamBez0mpS7KhnnX0mNystM
 DRkEmJ5DHKJm2pCN3O_dRkC4bwZWRFSmKzFNb7g7gcWIuOhHx9EGtjfTULeydh2RFju46yKJXq_9
 1z22sptcePMem.8O8U5Kzj5XHox8mbs1_FIgV8PvbXaJrWmPkSmTMGmMxTBdMdbA0CA0Uxp8AGcJ
 HOogIWwWS2MRO93FqqCc5dquRHoLoMbAhFPKT9X.y_ympk78pOmkai7wPui7gjwyGvOmrLe024KJ
 3._gjEEoks9ORysMmoPm.Z1rYHQlKOPBl5WLv0Z79bX74rF0xUUDGGQ.9RNEQBRLaiV8dxkG6KLO
 feZPh.G6u9Wle33cfNXTspa_M8iKMwVp79M5HIgmWqcOlgsouQf6lC1xqWYu3ybk91psWHD2AzY7
 nsmssZjk7.mIDnQW3AnJ7eqA.GY.v7D.XDXCkbedJRnDTkoLE6AiTNWHLAkYjMd5gi1rtYcqlc9x
 VdanH.8oqj4k9fT6Z4RixDg5_HVuVR56ZKCSazCN5FamElKsq456FUEyL2deB41321Pan4wspciC
 JqNLrOENre6m44CDM.w2BodA_eoCP6bqOe_5ST6ynd4I0bsoWPc8.9nJxNXAuDjVyy49cR4wObJc
 RmVWGd2ooZXmpsZBvuK9IqVN6.t3m7QR7kZZbpfJvWkGfk8byUWRCVuX2CbuID_Fyhm9sp6x3bMG
 1WNSZUm88dD0hU7wMWTcz6nG_D8o.RBiTsGM2Jlgi8hartfAIRRxvWQPpFgKdc7nT2wgMiSFvPKt
 _tzuTYazV9yhmCfEqnCpYeBuVJ0dU76OVKw4O3cND2TMSxqCcvGLHqhV2MMYEW5FeTv3D.zxWjkz
 Nyrcp1y5JYYdBO746DAkqNjEma2b.TTfKOcXMoGgNlpEMUbkoeaDLeH4aS1OM.k3awtmk0d.4ihA
 b28i0289Xf8xSZknjnp6H2DvzvH6_4_oe2BBC4WNk6DOqQ4jXi07X35PLSqy4ZFCbLgrYi3DZmcG
 jc9NWMOuKJrkc9wKJwrhhHQbPhWZVY_XesX4oG4uL3EdLct_MGSKcR7T8tnkloreb9Md6DIdism_
 a3XD.xeOkroc03MzVK_g1ItYVdtv7Cg33VmkaRfO8LW9Hgxqm5vbZmPZqne9iaEoDpxcj0IB1zTm
 OXwa0Jxi3wrzMJEvBtwGjdOAwhoAf3ZVSgp8io3S61vaGuGh.Y.a2TBbsEJfvwgChxME_YXXGl7H
 nAFw6t96T0q4bBCmM6ChyuANs91erBz5uvFTMQRXUda5oPp9.W7kEhs8mmf.cQixO2iVjFwEDjxM
 ff8Pi7n8Y27luMM46exVjWoAr4c.Ohh9y30jmsxd.qXgOQHkGinIkJIcSNrh9EOkUG37EnJX4.Xe
 1KBxAXrx_V5i7n67hxj5FoGoOD_Jjj34AnHVlFBh9GcE5n413gl8a2YrRQU.kwfEAVrz562XOMX7
 vQlRzJppywD4TmUK9DI.C_b43pczRGtrYQYOAIZ8Wd1OZvmrrr5k7GfGZ8HNiPKUjW7RWJUsqkkA
 5ZEqa1FvNONGSMBzEkyWROM3N4pLW7oiNFzDHywTV7O0XzOKMz8AgPkjrifDw4hS9TQQAyOYVey6
 jUAeCuvnhQ9H2brgLkFvL1tV4NzVegz_gFEGT.c9q0.kUEBO9uj6BpqQR03KMbVqQzdHMH8x0mKa
 T2nUFgezyXlhCk1aDs7u8A7Pq5p7m.9FENu7ZiHqdaelfw2PWrHnd6MWQToWhJfYgAlXgcK1qWdq
 1VFxw.RUPAeyERhRqSQ.6eSULo.otfRZqO.iN3q90WuRo5M92SBkaRN8jj7RikYnCZN0IEZFH5ki
 zhwbAw1728EgVagmz8N4qT5_kYrlBtQ9a50hkNWn8tKvmly50..ShIcyuCFtb6xJUBFUEM78CIP2
 xtUuI3n12Cteu07uz0y8zRyg8ghsf_NE2tBh5LVxB7wmyv7hFMoyqaRlZwXqH2m3iJtDSQo6W8kG
 A4KTmnL_Gu8BhYNHmDgCuFU9aZNMmBGw9KuO5HTcJ3DlMVNSYL.mUy9RGCZY14i5.0Q7_Pj50YMZ
 BIP4yuTozlfMPKgopb525jWqIvszq95h4gTtrk3jcdLwl8u2tkDzJEbzbUSOc._Ewen8HK9a0kKc
 dsEVfPMPByUOvWF9g5lYvJn7m653wU2LEARFe8t3M0.3qkWRsr9vvs2E6A4U3NvG9nrrzYDSEY3l
 QqRu3lW9CypkR2WOflLOuOzJDh.5gEB4C4jq3WiFLURmurBn.z0eB3iJ5
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.ne1.yahoo.com with HTTP; Thu, 10 Mar 2022 23:56:22 +0000
Received: by kubenode537.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 85c60a74110af086a1e93bbc48c45823;
          Thu, 10 Mar 2022 23:56:20 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        stephen.smalley.work@gmail.com, linux-kernel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH v33 18/29] LSM: security_secid_to_secctx in netlink netfilter
Date:   Thu, 10 Mar 2022 15:46:21 -0800
Message-Id: <20220310234632.16194-19-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220310234632.16194-1-casey@schaufler-ca.com>
References: <20220310234632.16194-1-casey@schaufler-ca.com>
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

