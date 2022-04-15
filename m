Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB875503192
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 01:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355127AbiDOVa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 17:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354873AbiDOVan (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 17:30:43 -0400
Received: from sonic313-15.consmr.mail.ne1.yahoo.com (sonic313-15.consmr.mail.ne1.yahoo.com [66.163.185.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 245DBDE0B3
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 14:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1650058084; bh=V+vPgvaKFDTnMpIdljAHcVYg6xkRL77vK84TmLoWvrc=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=iGQZ+LRFBHHEB/oXHoRwo5VH9Mr/sw9h5KyxGotR1w30JnJVhwYM6afjVmgaTE05gU1p7jedJ/l0Vpkh1Ar6wxnA23vJ/Cg61C0bkrizGvXSNiZMIXoVmwse5UAyIu/zOm4z2De4+JQDGksyS0nKErcDwFAPStubMnMVp10VIBHx3HO4bEFAa+Llu9fGMDQspVf4Gnw4H+wWhiRh+GuWH7qY6tvfmsT30BsZdu/eVRMfktg3nDpT74BkgWYTmoU8VdBaUjV737g4F88Bz5LnAp5ziQa+vPQH569a4Xoh6pB1hW+/7vKpDLK5SY4qk5hn3+1FkRnNpqLqIDOxf47nhw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1650058084; bh=ygwtMJU8RS8evRSjtj7K0vGIt2yDry4XIasABzRg0L9=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=fiGcZi5tUXEGwDxNWJ2doDEVJo4UHpIfmBXpBuE8vKFEjQtNxObLnlGNaudt2ph4SfMqdwbfcbrTABgv7hPNMUVcKitq3A9sjG8bFHZVhljM0Ugub5MGH2t/+jIB7tzdblCP5pgh7NJsrwD0PAl0D8Y2ITZPyLmv50Gl6GSaTYIJTxh9FITjzVss56pvVEj8KEoLL497KolDaEYH8JxEOwB7QwNF9ZAlsQEhCB8al0P43wWhJyoC98+Enzi7VGtDSZkZM8TTvbNFSeciQOsN7dc3QzARbuvLx2IqMJZDDdJDRt/yR8g555mzsmTPMCQd3QZh/K5/m7rNPI1OIvGODA==
X-YMail-OSG: sWC8LOMVM1lc7FtZ9z7mLtmTRQ5G4ud1yiYC9865FXzg1uaCtF_PkbAqA399YPm
 AEg9VmFLB7UiJMXJnVQ9izsO.nGo8gSVfMTTGgXuRmUYQkegvmjpXWY8hFESn_w2rRHKEy3FDG4c
 ufIsFZdhW9Zvwla1talhbOaqLH8qJ8ajP.A74SGeJl3z6QBBW3.9Ph7BmJWUoM1PueinKef092Ng
 mCbKJjK04atP2mQpZB_x9gGybAzr6QYC1_lnvQucLzvvdiY9HeF7NIvmbLkTrSkgFr.LZy98L2yw
 j_POslKFhAoXOEyvgsNpVIbGU6TMz4ZJIdaCg.Ub_vD1hMxbBeL1UPBnwqQkaElX1QLkewyJy_Ft
 FyPXyNycQbKS8hV6LWjA_auqD.UwnBVSZHDpyJsdRXANS6yBQ8HrutukgEnIX5hnVjeFXLwiTSkA
 lbwUBwwxP5Cgz5W6AJq6GZH1JUY3nlpNkaPGMo45c7OXlEYY3ms9fijNa_GaYTESDV79H9cAMjSC
 dfsh8Q5iDhUXVsxeHJuTvvXikyObDMORhAJ0IIrwqkIfeKuzWcy8ER00m..gZpG8F85zuHVU8266
 VbFnOpVrnPsHu1Rze8AoywJO2ao_i.p_aeU_Oby_5CF.ozyTsY2uWvsIxuGbuOR7M0mrB6h26Rc9
 QMYGZejl64tvvwUsVuT2hvssCm.F8rkgH7Lidze1i3c9ZUOia.LVYOhmMjFPbXJRvfowNYGgzobB
 ..qAtaWhywJHK3u4OyRChFO8TRlOa7_PybfrJxkIRjP59HF.jXnXbBYOuhWN4L2PQjtDKhH3RYF6
 SSKh0VlwjGiAD2hx3wbzZen4jjgCafQhqdGcSYM_Z9MWenyQ.mlqlQP9hP3omYS7uyYGR8sUzAts
 XKSsCeNOSIXA0rdXv6_CX3WBvP1qWsWKrv490FVavOW4WrucRQG9EqEPbKh6U1ly74oxJMMlovbF
 t19QkxeibZ.tds3hdeeuvOg9NyaJRMqK_Bw8HvtBZq8I5HSIJfdjDnOT2T.bjO.FLk7TiOe5foNN
 Cx6PApptIA0L4tIBHw3.Bq.McQ7DyuBP4RH72VY0yTtk8Zd8G6DjSLxjTjd5HJA98hMtI3MkoP41
 IWq48_bFULQaM3DhMsum8WwDp7GOsJRSz3JfgswiHYCmzBSnjvt5IVidgtqes9mJOv52a6grILNz
 8Y7KWSh2uO4.inNZCs6mJ4o2Xn1Q7_oVK1yRlYY7usdJm5TS77Hnp8ZgxOgPFA4gu4IWmOKxDOKI
 8mSFRCSc5faFYb9lE3YTdZx.N6WG92yGwlUU5be8NdlGdE9K74uIMmmTYK30rwTgAlvTLj4C3rTl
 skEw_BLixcN6n3xQNXA_FgvBjMx6EcI9_XnpVX8otgKA1a_KLR55V4k1qWbi1Wp0W1odu0G.F7KC
 kOCcO0OrjkPfug6hxpHIHGqipaG0JTCUbUFpdOaPiMdSWTdcBF4aR7QoA6626SyAkEpigNvamW_Q
 nZHDolKctXxqRcY9ZHnQaR0XKtGGjRvQB2n0q7CmhAjeR6lFJ66J2gigT5bcr5t6yVFWX4gfpJSu
 8uuY1P4l727HyD.rW8b.Falgu_N2GdS9Frh9R5lM6hu7CiGf2n.bDv7YHzxNguhzOPLIn42k0Sfx
 UEA3BI2XTf7GyJ4zn3oMwZK.PYoayuGSNca584Jmz5wPKtya6M8PI4rlfT1VgtmzH77R9UVaH7Xl
 eExVY07mz0Got_obeKcF.2zj03v_OgVwJwrlE4cvSxikn6cTRk4pIudC0SEEknWhA4AnK5PZPQPk
 1rbS48X6E9bwII0Js2xG5I3AfuNCsbma6MpVbt2T.yInnTl_dI.B0QPgblTJC0mDWUQVjlMJ_IKB
 xFIS5qv2ySFMnUB3NHLlyNEHaN8JFEYsWt5BeHrjGeUnAaG2h8Lcy2gzDiQcbvlt_RjiqW75S.jG
 QghHWZkBWrxkTd4kFItYnDRrE5tQfqnSFq8t2b8StJytLsKjCRgYqs2mM6dRTszPUWGS7erTH0cw
 t0JdABUgfZ16yyuw9_i3Ho3RXpMAm7XDYniUREdUB0mjcPlpDVdGhO8e5U3r3cR9D8VM80CCVob.
 .J1F.Qfaesiwx49brQnRlltSD4VKv7E7xM2VpEbRyN1S0SYpCA.K29NPjPtVTuZpf1akawjZ_yVw
 RwJ4eUwXaOYI6F988D7CdoLchQ1GGJSMO9n6raMDC6JmHets51gT85jC9p0h241QPtX233JuDfkW
 1M1s_1m6MI_iqAlNIQhoLOhh16IsRJ8P9eFoWIFvqnjHCKq_NE59OkHeBoB8eI5NJz1dXb.WCjZO
 PC5q5MhFdMEt9KmNNKulYUx0WKjzWTA--
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.ne1.yahoo.com with HTTP; Fri, 15 Apr 2022 21:28:04 +0000
Received: by hermes--canary-production-ne1-c7c4f6977-vjx2m (VZM Hermes SMTP Server) with ESMTPA ID 515394db5ae32f289f837259dd1f1b93;
          Fri, 15 Apr 2022 21:28:02 +0000 (UTC)
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
Date:   Fri, 15 Apr 2022 14:17:50 -0700
Message-Id: <20220415211801.12667-19-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220415211801.12667-1-casey@schaufler-ca.com>
References: <20220415211801.12667-1-casey@schaufler-ca.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

