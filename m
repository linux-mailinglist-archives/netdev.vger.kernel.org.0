Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D53855C5DE
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242961AbiF1BJF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 21:09:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241842AbiF1BJB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 21:09:01 -0400
Received: from sonic304-28.consmr.mail.ne1.yahoo.com (sonic304-28.consmr.mail.ne1.yahoo.com [66.163.191.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 382A222511
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 18:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1656378539; bh=WZac+aRC2uz0l+4S4NGEdN/ZurgpD1tHTTaIIPo8luY=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=MEg/maQSHSDdAcI9zGAkeKXDVjKIGt61Qd1Vic8eeD5uhfV33dNpkr1P/HByTB0zpeKi79f+rujd5kzVZDp40AebzMlOAFGaq0Fdm6aDIQ7fLUF65jjW80M6UXwl4PSYqyPIcs52P4NHWqo+vgLUJTHDPwOGAZfKxfpwcz/0y+4X7Qg+mKaxWlRNor9oemYXwx8ko0AXR3QZjPXyeLeQXAVAuVNkQZqwXz9wcbjZxam5s52WOM6KILcqcRIE1Q5zbpLf7RxA093twl+tFylgqFXekS8UekxJlndI746ZaCsw+Y3trfyzX+2COVP7XrjmYMvRPNaCHCA60bdCzAJxCA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1656378539; bh=tG6rYld6ccFoLx1nGWc2NfgcUdU9kaJjHLKNE4hYq58=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=h0rD2pl2xUd2jYdkli744YAHvjsUnppTWBQM7ymC6ZTtntz4v2EAobJBnF0VbIGm0IGOFSFpwdmRm0zDM114tigxM/Phe80nS07Nol1vzUL4K+IklR5WDjuBGPSq6VAMSQ+a0CssyrqqyK8aY2BNwY7dSne/wlT6FOpQb1mmRK4jAezs1pBpokpZXjRwlNoPOHjy82E3pf46xLs8Xoc7MrQsxkbtC5VscfqisY7gji7aBmeuCmuheTu49nARQgWvQ2+4+vnXi0vrfRpXV6VsPXEwwk0InUM8AYpXVDR0GQAuuVJXBuOc+lk2G86EuYkIEipjOGoMsKliNCUMGoyVHg==
X-YMail-OSG: QRWirEgVM1l5I0DmvR10bTKnmlIF60OqpETy7C7c9cuK0C3bzInsf5agnbzChnI
 KkMPQGQltsdYQRbBU3hXqFKSI2dIG3aIKGM1y0M.Gvlajg5b0erGVqhrzz_.srypzCmoQ3F2ee7G
 WIZfF7feymV1Zn48kW0KedF1l1YBsn9pPJznY3UGLtpbAz6S0n9l9kUom2JzItAwAlWjVgawij4U
 K6LEQDW_YIcM4ECfvt6ZAhsPQGkBZmGwfbseKlfHuGPB_n8ygmmBGtAuA3qPH3wAUDXNDexCXl2l
 ck99dtg3gbFq1tmAMaTF7.ZGW9av3qacOtF.5dUY1n8Le7bBNtrn5ROE27vNxs7UnD7jNieQSgVw
 6uY3B.M.huz6Vd._5_5FfqLljEOYtfCIuddiIJc0ueIlX9D81j8lmiXAFJCZPrc_mmkxBX.4sYoj
 Hd9VPRqLx8zzTZai_eJ5rZdV629KNRnZvNTD3OvIg9YzmiSdsSjdiXALTII2fR4a_47p.RtdFtva
 ho8DBZ3Sw8xmzyc7AUYvJma5lgz_BhuID.PPa4Lgy_2AC6jREXNoIJgTyWCxvYDGXSC3NqNKBCaq
 CFOTtUV3T4x3TtvQ537_IiW9VlPhQ81YX6m_vuch5rsThSxBKLNZ.lUP_uJhcCtQhbSa.Qj8qCVx
 .LsJjxqkmRwtWVwZXZLSy3AVHVbsmnoV3xbJArbcMWQqmvzeQX31NY0oUF3EWtz_xMhQqezxG1JB
 8XWWUe5__rBT9R.oB9qbuPDnw6IoSwzEcRqHzElH_hPZ7JvyDOeatqtLwLI9pUDMk_C6l5wcsbT_
 iAhNcx4szGeKmLSjRoPaHg0_RRLDQ1hYu9AaF8OmTaTU0SA5Pl11_mXufLO3Lf6Za3hTYw5LzdnG
 GREmM6azOJSg3xkYnVdXYe.5ZPbepuPzye8Ao8vYDPQkfaryOke2h7DK.IBlElHvoKXRwMWt.pJF
 oBxKLhK0HvyldAGGxbssQuSUnDi0F3ZHtNX_PkciCQOT8YWkbZMdZI77vw9J0DND_r_J_jLosWAW
 ZDeg.vK2pwMmbdWHtCiivFWAWOPAY.8BSXtPqsk.gXoTQIC4tgX6kBoioFDD5Ar9ZMYXn7kC4ETK
 n8UuqxW7OAgyCw1UNC.V_Ny3DYufDzEYl9BNMC0GrCbo6SnMGU_rS_SE6F5_NdF2Xt8pJ0KUKoWl
 XCXazn.rvXpBNoLakvGBqNcwySLNQ9mW8ad9r0f7BS5B3ErMdEhiLrsIj0ep4r4OnA3nuNdkrvKR
 AP0mUvfK6Hny01jvsWMhgfmDjAzxtpHxAk2js7uVq6saEyPEYTdCKnvIBEtE3IK16uSeLBeZLca5
 y0BI_1joODZnAJGb5g.QYMRF3SiSsQ_uxXOO8ZvG22vh5B354VJC.ycyb3KUoYdyA67sQrw80Ym.
 8QI2zHOGP87TaZUkOi8hXlQ2cfvV1m1NImxTs4silEnM9uH8eIavQZU8AV_Dh.6GjOVSV2CTJ3fE
 PElpQsjp4KhOZyfNcI7ywW1f_LPjSIx4KcJiBxrglIyxQBkdxvEA34HLi5ls2ftVtM0LMBmfgV.K
 5Qi79FeE5Yjs.rEeS.kOSyGMVz1CXBzOsE8gh5Kv9LdSPqna90DgP4u2tqtJVoi8mJ6UBACLH0X4
 e8ARht0w9i3Xo9JtAQnvkpkpZ7faRM4gkS714uYXhOcph8I7gNe2Tw2P1zl12aPlL42pTE1iSUEX
 m15COFGqV7JTaBk9kh_3nIgj5MErrvSmaPzRGyw3dsnurlJ9r21O_yG1C3qXZbOoeMciZd4H4foe
 6JUrHZJ5tk6Udz9ieHI0SLmL4VK0R2Zps6Q8AOoFEmOK.rXShrO9T.zVp5Wf4pZHrvJiN4kNvqL5
 gYz53lGLwgl3j14XHSV0d3WmtpV8P9Jw4cyIDqyZKicFqEV_AD0B.eVpjsi.kVWqMqBEq864GGvC
 Fj73ptuoBx2JwLmK2rmKINtGSsg107YZwpvg_yI10VzqwNzfsw1e2GSiRQp6RqZB1RoaDLLCPQR_
 5YhZkS4y.bE73VMlgQVH3yLUvpKfFXt6Mrr4ZEiym_L3dmoM2INwFTyo.tPN0ddw41xWs0COXip0
 PF7wHhjFu3r3j9oR3X_Ox9DE7sAySPZ7GAA6zE3U8WBypjCcsnLOUUcgy3ezBlxHFVl1T12xgspQ
 iE60tQNBwAQCSZqi9Cyi_xvnrMSceufBXzU_tQzFuVgWtdRFw3yEugE_hOFPfSf2.DM6Z1N5ZIgp
 NB1uAawWQEhbnSTQWuBqvYyberh49yJh_8Yo7sqzQ2rMGybjfS5RYPconlI.1.ndi6cenMSkNFY3
 mono-
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic304.consmr.mail.ne1.yahoo.com with HTTP; Tue, 28 Jun 2022 01:08:59 +0000
Received: by hermes--production-bf1-7f5f59bd5b-fj9wt (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 05fbaa230dcbeea0318fe174d0a2d20b;
          Tue, 28 Jun 2022 01:08:54 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        stephen.smalley.work@gmail.com, linux-kernel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH v37 19/33] LSM: security_secid_to_secctx in netlink netfilter
Date:   Mon, 27 Jun 2022 17:55:57 -0700
Message-Id: <20220628005611.13106-20-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628005611.13106-1-casey@schaufler-ca.com>
References: <20220628005611.13106-1-casey@schaufler-ca.com>
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
2.36.1

