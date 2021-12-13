Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D864A4738DE
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 00:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244279AbhLMXtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 18:49:41 -0500
Received: from sonic306-28.consmr.mail.ne1.yahoo.com ([66.163.189.90]:37160
        "EHLO sonic306-28.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243921AbhLMXtj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 18:49:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1639439378; bh=jED1FKxellw4KtQDkWf6Z/5uafpV100mgrllKbb8X90=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=DEIbbkGO6YIqi7gr3KJm9RTXTpuAYmaPK4b2ckhYa9hDnniHq60fPqZHdPWpbIgibhGLXTyI2hnOpvmilltqIqsucKpjOshaGu2e2y9ynhTqOdhr71BeWgVR98KCrpFagjysirbdVY7PjKKvvcIZsjBCgqYjwyb3Bz7WxVxSZATD1KPr/vlPF2xVs5mnb6xuSgE5QnYVtNAqXQQjhlZmWd+PwnF+A+g4T9eCJE0XQ9XjaNn1AQLL8wDIuzKf5eL6iEYHffLuQYJXOzv7Kg0bCS02K8BUc0D4/cMW51vqccoauVVeHT7Hf7X09XlkF6m+GV5RQ+I22U9nj6POuTFKRw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1639439378; bh=V/ADtwObiPT035hBwB4n02igK7ErvLlMXO92/D5Wt8Z=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=kDB31NVsOWacd5kJumDs9pfT4GG+uPgCxeteU8YZLxLbpohVgT2O5vHy0NO3W7aA0zSPgUbJLDkyCpNlGZPO/q4BAvaCL8WcaK1dvL95aIl5gL+IXcxxz4htcNh8yX2Ap3CZDpY3Z4nnDKTw5F51EJUNAptxuspiJ9UHUgnw9tqWGmYb+cuOAKcTB5Hpsrppe63/9l9Hh4859itgwsBsCJEgrurwICW2W45O6X+2fRjQ3fIJJdrfwf0j5GZIWt1+JXSGe9D2+zUlBykZnv1WMJmmW1dF7M9urmKfpIQvHwNi1bw9CINQiIeHCxgMLTOwMbTH1GA2HGbwicRONGMuJA==
X-YMail-OSG: yxJ0gS4VM1mvuKEFInuzdpAPEHoEFSCzPrBQDCOuxRhSVefQ9ewJ5LrKxndhrSM
 oBKRpVUT2u8VpLCnsA4.hCyQMgXkqPQV5fiU.b_dmo4peXOevUU4j6zbJTdpwCT4giViHf49xtaJ
 D6x7Rr7ePN5s3cW.13az9qExpQ7m8iwmtwD2.wNteznkx586M..1GYcljFnyNf0e9OXsiJ.s3Rum
 xrZACBEft800Q0yCPk.WFN0SoEqo06dYfHChE1CIGGFvdPS8aDmLhfHrp7of2o65cJP.dDCfiOFH
 IdggmbJv0kpCNx6NIb7WYOIGgQ0vMkZ_4wWBi_euiM5alMg1hpC.fQ4YfjgWcQcRhMHpse5OQ1iH
 vsPPaFQsrixonA9U5fOKOfAuGLZBToLAb0T8UHzjyfzUpJEGnwdIl0axH9WZhObocA3InBAiw_GP
 .ZygM3Zu2AqwwivqnCLTYEONOgiq1jqY0iTjvnjojehtnOMr9Uufv9Rl0SO371xGPw_epsaB2wb2
 NnL.R6.yfV0CYo76IXny046riaPLW9pbgi1IkyO0l0q01uBZurRBd.46VZ8ISYB5tSOuIuc1Z8Cx
 6VSHtaRjepIE4BYHTS97O_DG5yTROKJhg_lnYxL37DcGvtw_.HBivAxzgVAh3f5CIhc_ts_XhVoG
 ndJMrOarleASemNaUjTs991aOYAyb72HuOvWILgIWnKzXz7Rbkcj38a7xmxaaxt0x45bp63Hbmsb
 60gz_cPyDH0THVEL3mZs0_anIlmsMRNKUk75Aw6JBpxnO3_2wexH60c_EejnITb2yWRwaT43WGkV
 cWLep3OGk5R4JyqK64LI4at_qDj3kWr1w9rmnLLNxfqXDxSTa4YpDBYej8Umr82CBnatovbR1GjR
 oFybsMT9SN5eqc12xGbbXIkbuy3qIOpSHNTG.m.H_s8ZIWBuOeFcRF4ONqexzafKzP8KKuI_5l2p
 fsDeqTTC_FsGMvudP9Yo9VM4t1Zv1ABp8YCBnra5UbeKQyJ3uiMExgiDTLJDT9ben53rh27jgVhL
 4aIF0t_vhltqEDQl4TO6U7WKZHjo80vQdOKCK1pgjS7gbQLSH0w8eoCACMjIQYAe9E448Ynrcfnu
 ALvznzjnbda4b2SkV.Rsw5X4NTIEAOPZNpLdUo_oajMqQ3AHVCKBQKvB9OImXWKZ8cY1g.nFm9Tx
 oTH19CM9YhOm2cPHHCOgj8mvpEOsKNwTkcKdSh2DmOjKDo1bkQdd9QsynNAq6SjLdudD09Cl47gW
 2c73FejA_PT7kBKmEc_pxjsE49alizY0cJ0QUci9gmlVtvsr9cziedUu4U71XnFWMdTwyvbb0CMP
 UVQAMWc_TnTTCsYk_BQjpbYR90I5w1Afb0eYXSqNJbT0RQ9Qiqs0gIZmFoibtWEJr0MOLRfY_Yy3
 gA9VkW98HkeupgCpaJJTmxLAuoXtI6wf9cVWafpxzDbKRNCYW64MFp7BUW0PGxn3psqxFppLZ7wW
 7NOPNjJ7IJE1QXLY1R9JmGlGY0s5dGsd.zxyud0BOdOZEMpA0uLhNaJQC1yyN_fodt0U_baqTjDP
 bknPzP6UgaP.Lu8wzvXgXi_Fz7s98vkl_otQq.dEiHGRG3ISqgUlE.4kTRtZXnaIAel7n.XFWKmC
 XGaYoQfWZ1i0KEdLqPtO3QYChwvO2n_K0ObRC0fz2oVXjLsnzmKzlvO6bHepDGjtj_Zjbydllk.s
 jGpx9fz_4l2o9leW.7FFo7z9NzyiXfxdpM54SPfehZvIgkHp5ajALDE9BYZg_18D0gidt1x0A8XZ
 uTo8uyjMtifsMtx9JOnbEcJCtJhCp3SSfUmPoiHvXtbM8eUscoyp2AuzNP3epL5xGTd7n97ZBa_k
 266rlx09mw0cR75zOQ2xedLJkM0t9RPKdqIGWyCVWGRv0y0qY2gRyT6oDQuVsZXvFzR0mf6TkYIg
 odpjd4Mm.5Qz7hh301YwiXLvAqfPX8F27XqCIlhsS7QC_5A_L.Zkt4TTuFcHANtW3L_It0acJEKd
 Vyanji.mORQCXlDgLyRrIto_HcbSxBT6TEVqFcWmeV1n5eaxKDCL7qHdUwh580jX5Cpfzld.d7fV
 j7EaG2JiuPTksEiVq5Hj5OOlZHKRxu_O8inY3OwVu4FNEroYDALWZLaH5xrugPxofCGg.NPt23b7
 dkwb_R02NjP3XdZZNAx2KC0Zdd2mjEu2NS_pdVsfYsHHi.GoYzBgIuVWdoepqoA0EEpQ5qrJLWTN
 SEeXqfDrUjqdLmenbGXFinvtSdIxKVZMng5iHHR4.oxrzJ7KT4Uqc1cDur1Onw_RCHfqFUSHt_Ae
 Vf8z14KGi4OL24U_4wUId6luhGjE0zcW37qdvV7sedew-
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.ne1.yahoo.com with HTTP; Mon, 13 Dec 2021 23:49:38 +0000
Received: by kubenode527.mail-prod1.omega.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 3c37c5f8f0988af181e864687125ff70;
          Mon, 13 Dec 2021 23:49:33 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH v31 08/28] LSM: Use lsmblob in security_secctx_to_secid
Date:   Mon, 13 Dec 2021 15:40:14 -0800
Message-Id: <20211213234034.111891-9-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211213234034.111891-1-casey@schaufler-ca.com>
References: <20211213234034.111891-1-casey@schaufler-ca.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the security_secctx_to_secid interface to use a lsmblob
structure in place of the single u32 secid in support of
module stacking. Change its callers to do the same.

The security module hook is unchanged, still passing back a secid.
The infrastructure passes the correct entry from the lsmblob.

Acked-by: Paul Moore <paul@paul-moore.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Cc: netdev@vger.kernel.org
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/security.h          | 26 ++++++++++++++++++--
 kernel/cred.c                     |  4 +---
 net/netfilter/nft_meta.c          | 10 ++++----
 net/netfilter/xt_SECMARK.c        |  7 +++++-
 net/netlabel/netlabel_unlabeled.c | 23 +++++++++++-------
 security/security.c               | 40 ++++++++++++++++++++++++++-----
 6 files changed, 85 insertions(+), 25 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index aaa63bf5026e..8a547fc4affa 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -198,6 +198,27 @@ static inline bool lsmblob_equal(struct lsmblob *bloba, struct lsmblob *blobb)
 extern int lsm_name_to_slot(char *name);
 extern const char *lsm_slot_to_name(int slot);
 
+/**
+ * lsmblob_value - find the first non-zero value in an lsmblob structure.
+ * @blob: Pointer to the data
+ *
+ * This needs to be used with extreme caution, as the cases where
+ * it is appropriate are rare.
+ *
+ * Return the first secid value set in the lsmblob.
+ * There should only be one.
+ */
+static inline u32 lsmblob_value(const struct lsmblob *blob)
+{
+	int i;
+
+	for (i = 0; i < LSMBLOB_ENTRIES; i++)
+		if (blob->secid[i])
+			return blob->secid[i];
+
+	return 0;
+}
+
 /* These functions are in security/commoncap.c */
 extern int cap_capable(const struct cred *cred, struct user_namespace *ns,
 		       int cap, unsigned int opts);
@@ -530,7 +551,8 @@ int security_setprocattr(const char *lsm, const char *name, void *value,
 int security_netlink_send(struct sock *sk, struct sk_buff *skb);
 int security_ismaclabel(const char *name);
 int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen);
-int security_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid);
+int security_secctx_to_secid(const char *secdata, u32 seclen,
+			     struct lsmblob *blob);
 void security_release_secctx(char *secdata, u32 seclen);
 void security_inode_invalidate_secctx(struct inode *inode);
 int security_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen);
@@ -1391,7 +1413,7 @@ static inline int security_secid_to_secctx(u32 secid, char **secdata, u32 *secle
 
 static inline int security_secctx_to_secid(const char *secdata,
 					   u32 seclen,
-					   u32 *secid)
+					   struct lsmblob *blob)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/kernel/cred.c b/kernel/cred.c
index e5e41bd4efc3..a112ea708b6e 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -796,14 +796,12 @@ EXPORT_SYMBOL(set_security_override);
 int set_security_override_from_ctx(struct cred *new, const char *secctx)
 {
 	struct lsmblob blob;
-	u32 secid;
 	int ret;
 
-	ret = security_secctx_to_secid(secctx, strlen(secctx), &secid);
+	ret = security_secctx_to_secid(secctx, strlen(secctx), &blob);
 	if (ret < 0)
 		return ret;
 
-	lsmblob_init(&blob, secid);
 	return set_security_override(new, &blob);
 }
 EXPORT_SYMBOL(set_security_override_from_ctx);
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index fe91ff5f8fbe..c171c9aadb01 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -813,21 +813,21 @@ static const struct nla_policy nft_secmark_policy[NFTA_SECMARK_MAX + 1] = {
 
 static int nft_secmark_compute_secid(struct nft_secmark *priv)
 {
-	u32 tmp_secid = 0;
+	struct lsmblob blob;
 	int err;
 
-	err = security_secctx_to_secid(priv->ctx, strlen(priv->ctx), &tmp_secid);
+	err = security_secctx_to_secid(priv->ctx, strlen(priv->ctx), &blob);
 	if (err)
 		return err;
 
-	if (!tmp_secid)
+	if (!lsmblob_is_set(&blob))
 		return -ENOENT;
 
-	err = security_secmark_relabel_packet(tmp_secid);
+	err = security_secmark_relabel_packet(lsmblob_value(&blob));
 	if (err)
 		return err;
 
-	priv->secid = tmp_secid;
+	priv->secid = lsmblob_value(&blob);
 	return 0;
 }
 
diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
index 498a0bf6f044..87ca3a537d1c 100644
--- a/net/netfilter/xt_SECMARK.c
+++ b/net/netfilter/xt_SECMARK.c
@@ -42,13 +42,14 @@ secmark_tg(struct sk_buff *skb, const struct xt_secmark_target_info_v1 *info)
 
 static int checkentry_lsm(struct xt_secmark_target_info_v1 *info)
 {
+	struct lsmblob blob;
 	int err;
 
 	info->secctx[SECMARK_SECCTX_MAX - 1] = '\0';
 	info->secid = 0;
 
 	err = security_secctx_to_secid(info->secctx, strlen(info->secctx),
-				       &info->secid);
+				       &blob);
 	if (err) {
 		if (err == -EINVAL)
 			pr_info_ratelimited("invalid security context \'%s\'\n",
@@ -56,6 +57,10 @@ static int checkentry_lsm(struct xt_secmark_target_info_v1 *info)
 		return err;
 	}
 
+	/* xt_secmark_target_info can't be changed to use lsmblobs because
+	 * it is exposed as an API. Use lsmblob_value() to get the one
+	 * value that got set by security_secctx_to_secid(). */
+	info->secid = lsmblob_value(&blob);
 	if (!info->secid) {
 		pr_info_ratelimited("unable to map security context \'%s\'\n",
 				    info->secctx);
diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index 566ba4397ee4..762561318d78 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -880,7 +880,7 @@ static int netlbl_unlabel_staticadd(struct sk_buff *skb,
 	void *addr;
 	void *mask;
 	u32 addr_len;
-	u32 secid;
+	struct lsmblob blob;
 	struct netlbl_audit audit_info;
 
 	/* Don't allow users to add both IPv4 and IPv6 addresses for a
@@ -904,13 +904,18 @@ static int netlbl_unlabel_staticadd(struct sk_buff *skb,
 	ret_val = security_secctx_to_secid(
 		                  nla_data(info->attrs[NLBL_UNLABEL_A_SECCTX]),
 				  nla_len(info->attrs[NLBL_UNLABEL_A_SECCTX]),
-				  &secid);
+				  &blob);
 	if (ret_val != 0)
 		return ret_val;
 
+	/* netlbl_unlhsh_add will be changed to pass a struct lsmblob *
+	 * instead of a u32 later in this patch set. security_secctx_to_secid()
+	 * will only be setting one entry in the lsmblob struct, so it is
+	 * safe to use lsmblob_value() to get that one value. */
+
 	return netlbl_unlhsh_add(&init_net,
-				 dev_name, addr, mask, addr_len, secid,
-				 &audit_info);
+				 dev_name, addr, mask, addr_len,
+				 lsmblob_value(&blob), &audit_info);
 }
 
 /**
@@ -931,7 +936,7 @@ static int netlbl_unlabel_staticadddef(struct sk_buff *skb,
 	void *addr;
 	void *mask;
 	u32 addr_len;
-	u32 secid;
+	struct lsmblob blob;
 	struct netlbl_audit audit_info;
 
 	/* Don't allow users to add both IPv4 and IPv6 addresses for a
@@ -953,13 +958,15 @@ static int netlbl_unlabel_staticadddef(struct sk_buff *skb,
 	ret_val = security_secctx_to_secid(
 		                  nla_data(info->attrs[NLBL_UNLABEL_A_SECCTX]),
 				  nla_len(info->attrs[NLBL_UNLABEL_A_SECCTX]),
-				  &secid);
+				  &blob);
 	if (ret_val != 0)
 		return ret_val;
 
+	/* security_secctx_to_secid() will only put one secid into the lsmblob
+	 * so it's safe to use lsmblob_value() to get the secid. */
 	return netlbl_unlhsh_add(&init_net,
-				 NULL, addr, mask, addr_len, secid,
-				 &audit_info);
+				 NULL, addr, mask, addr_len,
+				 lsmblob_value(&blob), &audit_info);
 }
 
 /**
diff --git a/security/security.c b/security/security.c
index 171e2fe66e5e..7ae68b6ffc7f 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2195,10 +2195,22 @@ int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
 }
 EXPORT_SYMBOL(security_secid_to_secctx);
 
-int security_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid)
+int security_secctx_to_secid(const char *secdata, u32 seclen,
+			     struct lsmblob *blob)
 {
-	*secid = 0;
-	return call_int_hook(secctx_to_secid, 0, secdata, seclen, secid);
+	struct security_hook_list *hp;
+	int rc;
+
+	lsmblob_init(blob, 0);
+	hlist_for_each_entry(hp, &security_hook_heads.secctx_to_secid, list) {
+		if (WARN_ON(hp->lsmid->slot < 0 || hp->lsmid->slot >= lsm_slot))
+			continue;
+		rc = hp->hook.secctx_to_secid(secdata, seclen,
+					      &blob->secid[hp->lsmid->slot]);
+		if (rc != 0)
+			return rc;
+	}
+	return 0;
 }
 EXPORT_SYMBOL(security_secctx_to_secid);
 
@@ -2349,10 +2361,26 @@ int security_socket_getpeersec_stream(struct socket *sock, char __user *optval,
 				optval, optlen, len);
 }
 
-int security_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *skb, u32 *secid)
+int security_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *skb,
+				     u32 *secid)
 {
-	return call_int_hook(socket_getpeersec_dgram, -ENOPROTOOPT, sock,
-			     skb, secid);
+	struct security_hook_list *hp;
+	int rc = -ENOPROTOOPT;
+
+	/*
+	 * Only one security module should provide a real hook for
+	 * this. A stub or bypass like is used in BPF should either
+	 * (somehow) leave rc unaltered or return -ENOPROTOOPT.
+	 */
+	hlist_for_each_entry(hp, &security_hook_heads.socket_getpeersec_dgram,
+			     list) {
+		if (WARN_ON(hp->lsmid->slot < 0 || hp->lsmid->slot >= lsm_slot))
+			continue;
+		rc = hp->hook.socket_getpeersec_dgram(sock, skb, secid);
+		if (rc != -ENOPROTOOPT)
+			break;
+	}
+	return rc;
 }
 EXPORT_SYMBOL(security_socket_getpeersec_dgram);
 
-- 
2.31.1

