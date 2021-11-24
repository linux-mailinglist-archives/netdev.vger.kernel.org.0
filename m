Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A03C445B16A
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 02:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238275AbhKXBzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 20:55:41 -0500
Received: from sonic308-16.consmr.mail.ne1.yahoo.com ([66.163.187.39]:44322
        "EHLO sonic308-16.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238060AbhKXBzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 20:55:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1637718746; bh=FKZoy7Ae8g2fJFCJVup+YbOhxC6lR8pSGHi0aTX2obw=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=o+0wnoaLLoddnCCOifSoV9Nf7Gl7RVXd1s5Ib6AA9Hjr3X8G6RrSLo7hK+840PO2dep4P36ZmJj/pr42OknpB6ypHPPQ6xuHHiOvEp4beZbhV2vfkWG0E8g6fzlKA0NEpr0ZsQ7H6y6/AHV313Pc+Odw+lSUycljO21oAOm7ZUQePJGVl391MezfgGzSkhu2jHkBGLF1KrCztSeKQYBym+7yKmAuPCfJ4+1aLyz7mkf7bKIqIrSYMW4OEEPkeW50Kcv83zrvoIpheZnBVsMK+Su2q8F2SPNzqbgxIg/b036o0jSWOauQAbAd+O8UskJMZtxAtSUb5TyZZ6MhlHShYg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1637718746; bh=Fw3f7wMa7P1VShv4P45ZOnt7nbBNdy7u8bLYO3jHjEr=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=GVQTD5L7Hj3lKsbocR6W7X1n1rD23GlTGs18k2GbeB/Y8SQnGMFinqBp37LvAVvirAWfLyiW+XmSaQB59t22sIxmc0cuoXhXMWSKzmxNHQii0MLe+f+5oKkUqNJLIj0WDyHep8mK+b6BTQRL99IcHm4Y6WCJvocQ+TFol8K7ptn3kKkYvyi5/SgOBepusc/IxgW8sK4a+LK2HoKJiYW2O6Cpq9kRlT+J1uaGGgZJTUpvK2fhKveEt+0GpiwQHu+ysmZNOv+UFMXI9cg7bB/Kz3jMxz/MFqcJ8NgG0xctU5kaSN3WM93C0T0HMr2x3d0x07J8lZX/fZp3mGQhgF0fWA==
X-YMail-OSG: iV3YhFMVM1lqFYBw.s6ixUNEV_LMBo.FcpmQ5uhOPx7FmkLPMHkV9ewG2VRjP0i
 fXBpnoOto_ZlFmseGQ3MPVCxE1wWUWiE0EfEXccNni23nej1qaNPyT.z3g2qiO.uJWsZ3avIEMkl
 Ii_.7nmdlBlCKI1pYkKTfgM0KlW022rKeUl.AWNbdVKRJRNMqBC9bk0Mz8od1yxPv.GuOZls1Yfg
 HowEhn2wOzaMmBc9q_sYfjx_fHVcOtQSX0qTCWvtbCZpd0UfZ4QyuiEVfmY3sOXfPni2.v3Rib4P
 ibjeKTzRpFoLGW_J9pbxniw92MrdqUOzG2cWfTGIG_Cp6sFIFMZyN0Y96b7cAf8CllM1Rud_Zmku
 .XwEgaLKkm5rw7Fbs6WzqiLf8Hcj1U1Urrb6yjX1gffDLhG9Z7kacYxkqLcxSRkqHc4RhbDfSOAB
 6tK1FvSXTyd2BBBNheYGIVPoFhF2.571veXF.6groGvnQqMkhPqqIyBby5i6grAsXANL7kjrK5LS
 1i3g2yRDjT5wZKI2bdsBYux5Z0mc2XZg.Gj8wgZ_rdWWd_cWEKuH9QziTRGj6UP73bgw7jLTJ.qx
 PeXz_Hw.4R30e3VwLL3fNWw2Vdy_CdG3aBMfxSJoejVbWoUpD3BSKBJ.GK3x79epIMeQY4iifhdD
 OGIDCfsoh0.Fc_jtlG9THFe_UPZhOn.vD2jubxf9FMdz1xzRWkh2puYHv8ODimSjeXzl5JGkh1CR
 XSAXhejTb9uMsX__eF7PBeB_Nn4mPSzZipYxk.MecR1422eY5xUmzODF19jZQDZg6Cky19iMzP.o
 N2QAAz9QkoBIYtvhjvBlbPpid9_XWljhkIQx41KKaAC4R8S0bm91vklCoaFIxJn9zP.45zpUkEFE
 gfTrB._ZqnimBhfc7CHNyrEpVFEmRp4P2sn.lm8c7yJVfyEqRa6pVwlWytQZCkK3PTkF.vMtbFTG
 OQ9O.gbbxS9KJj9aJiitJ07aRxdGTeEECr8pYdqNF2Ji_6wUFiExmc0qktU0jIqEyX7RRgMZkxl5
 yMEWZhtmS7ZW9TijFFDcR0.mMJU4gfo6iQpZONMZqZ9WE93UBq5vTt8xFaFObqPGiWKdwTGe541_
 M9SX_yECQC9bRm6KYr3zibY0QNhOmwjicYsutFJY.T9rSUmEHR7P9aRtCnsehqHG2a7zXNLlBjA4
 P5Ei3CdogSeOIaBOIlcD54t7zV1cuEKbp6tlbgz2MTvYBK7E7a3CCrfYYbtCKllkkX2nJdLQTFCD
 RvBWSE5eaIPnjg9zXLJvff0JTSU37k3LxBD7ljNMie9D0gSP_cebFuo8RBbS9usVeXobqZubQt2F
 I_7.prSNDo8Vjn0Bci4MyzSUDY9mriSIw8p0KOYM.63KsSSRMx4pC0N.TKNo9ZMCu.ex6qiBpgaB
 XmLDzNn28rZQkmJLneIjqpkEkXWjV2ZyZqLPunWmzkjbd3.ZsREvVUCnU7DLoU5oaydcsW82Acdg
 ByFi28zNTHHfGxj0Zsgo9Z8udo80aaAJ.3WfkCQBEXrBgweTs0FZ2E9D1eF0qja0u.E5QYFN_vJs
 dRc5NXkSZnqL3woRfavu6pylWFqM8OjUymePviSxqSNNxUeulnJZPkldZCl1qdLr7gvuAABNgI9U
 uqpAFg2S07KJfoPa.7YV14875IZtFicMqOVpZ5d0h6p0Gnv6N2ixKjSXpelIb0.fpApP498ieGcm
 Mqfxjn9TTgDoVlXBcJiIvASVaFQrH_9YMKVs7vdr8gyToy_WxuVr1b8KvvZQKuO.SG8DwpXdSmUT
 BoV._geAmdieKwe5PQKhZUddIQtnfGl97ZvNl2A.BLJzh4I6KljT.chtbZg6HVBdMHRkaePQ2k5s
 0zuRN8l0B56eZbx_b7YwlMsEw4WKnmHG_UI9jabrVV._CkWHlecJYaY6dLMuyNGw_zhTd5HDoffq
 khPctibUOy9Ohh3PugVDh0dhDFozxsW3f6WUdpV5.2KRTXSMA9xKaU0eDP6WqFns_UJZRNqjRyQF
 OhpzAzHHz4hcuf0KWQm.ZUXWxlxyQF9zqYxANik0fTQbOeSCTjwc.1lwrE4Z770M3TxS7i807ZH6
 NNMUAWcJ030V1t2cnY.uRLrQff77XNeg6Ub9abKlWaYVFL_puycDr2JjAbJX0JEp6SrEvgxlE0Ua
 6G2nn6W.ZcUkvcrrQ3DvOa6MsV.7_1ArKoUC8BblL46_X6IBAmsdANNDF5FNpRrrnno_283m.vEq
 599i8DrukkMrjzb5QD7xo4fjz.MXsrZ9EpOO3ptPpg4hCAxY9YWI8ekAz
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.ne1.yahoo.com with HTTP; Wed, 24 Nov 2021 01:52:26 +0000
Received: by kubenode504.mail-prod1.omega.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID f73285a66f3fbf39f2e43e2b2e480b38;
          Wed, 24 Nov 2021 01:52:28 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH v30 08/28] LSM: Use lsmblob in security_secctx_to_secid
Date:   Tue, 23 Nov 2021 17:43:12 -0800
Message-Id: <20211124014332.36128-9-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211124014332.36128-1-casey@schaufler-ca.com>
References: <20211124014332.36128-1-casey@schaufler-ca.com>
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
index e6dd3463604e..65dc61067e7c 100644
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
index f3d30ef512d4..852aaa05edea 100644
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

