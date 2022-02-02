Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 545EC4A7C36
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 01:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233771AbiBCADM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 19:03:12 -0500
Received: from sonic311-31.consmr.mail.ne1.yahoo.com ([66.163.188.212]:44987
        "EHLO sonic311-31.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232944AbiBCADL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 19:03:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1643846591; bh=dO+uGR09uRVBZct0wGFemFXV8/PJpFqP6Hvb4gSqVwk=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=ewUB4WR6U2hAQ3eQV1Dg57fFcrUDKZz2Dbn9umPSEjJMZAjfElZtjJHVDMstX64830aEuqoFRu6pQEOdXd6s1p8dJDrOkQFOofPoxYnvJIP66N+sTq2GAMzL7JcbKqVogPYk+apUIKT8vWAhddWRodYLYhuLfH/Ggs80StU3EkLiTJ/YefF3Z0ygMKbjCfQdRPKpq4zQ9uZjRWBEAyIs9twtGRXOuzC2Nw9Kc+Sc96Y9xV0bzSCxHmQ3kE1Kze3gD3Ax2/aCCvARHQjA7002r+XX0AM5+RodeZOPPY0XYPuhIGuQl+TLSv29M3XdkyF62aTgPP967zcRz0M9IWhn3Q==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1643846591; bh=341sz0TDnhbFtGoWwVXxgmrFzqB3h9qyOVml8UhOKrK=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=BRsagEzWq7o+v2Fj8BGH+XvnD1Va4zVnWMvjRhPy82uIeFSeJVFclePVR/WDSm8UB/Mu7qMQTjLCYLj4ScgOUVx64P+VnHycIG+I/eM9wyEe0BOuufTxSqBRsF0RVfBgx5KofeXsp3GEsBdwl+qNcftGXaUE5oVdUhPAdtbILn4HvcCPIKw8XyS653CSMWzXO68BjyZCoKgZTbWW1+leXZS1BrzHebbKe4s3NtGlWjrufT973ITpsnakOXTmBnR3GOjX4BXFnVq8L2M8NBBP2mvmBt4OCXHqKHScGtR+QeyjQcZ5mblzgE59qFrtst/VkCOY6cqZ4ZtN0tJTYSlLKg==
X-YMail-OSG: oc4bBWQVM1k8AFO.4xZNrYXv.G9N8Rrn3zDmmafnBnTTsvBGAMPBAs1KIF49gXx
 VanoH3e3ZX4nUfmLG6D5Go8gy14vogcebw9C_NdHKZrvogBbXyrwoxSwBFiPkzC2N2SGBo8XzeHy
 J6fT__EdS9MLk4JE0F5zy8.QyBOqtbunY0JRTZbIe9QthQwoVeVXlhCgg.GfMNw5qPEl8XYasab0
 uN3gwrq8q_gTg.ShmYQwZq6EvfvPA8X6I3ETFs4ny2hWgBEcP.ot2ZfGAr7DBbmQlnjH1oujRHzQ
 eJnd_.2QyP5C54Czobygx78tQn438lVvnuBtUBkGWZ3RO8kCxm2JpH.oVWCozOGhEclFzmQLqC8x
 mVRNCzlbURgqGgF0xcqMhIxRSTLhljVGDqHNMKjl9AgOZbGlZT2B5YqyFwUB4a1uoVrOQmZdsKyb
 _YUXITvZuklY_1WsikPZFOGAfDK_..El8Og9EXcfS1SZmAE2kW.ysP_Lnjor6ONoNoRYHxgR7qLV
 65_AxfcOxMaWKaUksfu_2U4PTDN3L.pGScYTsZ5Nb6So0gXWvokMyYcNcGM_pjy76GZaJSQd1IYK
 djQ8YAN6.dC0xfwT47QHtdaRf7UaltP4sMTVrDlW0Sy7MWHyvF3Hk4fIVEn3feUXqhrXrMEqOLKl
 z5Kh4UmwLSlZYJMzaxJxfcpAG1cncZb.FY9DqVb.F10X7aZGkxw2jRjC11BHE3VD9YA8YxnxKb_0
 s6dMdTGxlKy2b1_tOFPbaNP7HqqDE7hYwc.kpnYZrQdKrqqbdK_jUfRcrz6g.4oFDlxI3LDFJUMc
 D3YnEITDas4_Rg8utGtX4GuEqkz1M3zZvP590rE19vZCPmTcT.sitpVq.9w5ezAvdhdoZWzE41zr
 n58wg61QYin7IQyJ1X9j9YPe91SabXrHCdDPzY43p2MBGQxdwcKjN3pTWQopNupinYd8EvSTVbbP
 80WuYgyN0W7bhfIttiHTTvemjs5Wg0xSkZKDG_jkzqkKsR3Vv5ai.bl9fAs59CCjiUfH.66eQXvc
 HZSf6bXPuSifI8pnk_MWiBMu86LGGJtJaW7ThzDQykQ5_yXVKE0iAnKUQvDYsV_jX6WukTr6H.xi
 SNLjd9gqfkPfI5.rQ1BNUIDwjMen4FZUeAdzZAycm1DIBByRSzo_GNuchD2S6IZxXBK7dn73ZSn5
 9sV1FlVDQCQpB3wdqEjts7K2QyB3g_RNPJD4Kcsu_E7l5z_Yn4JbtamDYuGDaCL4BM1NwFOkzXYl
 NGfWRyAkMNRLpZxKSGAWqafj8UIukd9s9g3TmzUEAF.GPPToVGDby.ooyHr1rOvLVkIw9FbCMjBG
 f304uR2ykXow.znw27IV8HgN_Jr2LeUhYbpCXWpmPrwguHTMRZPjdp.aBDfP0SFVpWAB8IAomMrE
 zrOYBLjBvuAZdiIqauLtud1O73eUtXNhOEj8cMZZq5Na1GqpM8UY_QX8ciXM84TTSTI_4h05UxxC
 MaakJkStOLkO4eRswOnJyu8vzZuBtew4VeGY2tmrZrjnOJloij0R0Ew._CJz.7uEyFwUg1RVwsZr
 J1cssYvortx9kcU20vcWiyZ9f_.piLNZoI5S7TloRyEs_9fccM3OPFW4NYu2AkeEvHQKMUF2_RXO
 JXNBUBb1JnwIpTfDZYpmOJQS9PLkfszhVSZySm.ETr_Ffa1qsL_cqlf90CxJIYGiK_CR.v6nXhKw
 q121ULilAvDhX9OUAQzcDbtu9JmrJfaAVIx8CzVYIcq0sH8wlI0WGbnT8iWDhWukUClQHjZFeuKX
 ApvQhjRjWAsDSbMBjwHm9OongVkb0r6bBEppD9drl2vsE03Yq9_Z4dH5RWa5R1L.Nnl9LINHKTnM
 qCypwmh7dS9epBqwAxNLVZkLg4N30u0u02iRWHLzrF1ZnVW7TZAs.iytlKXp4H7Wud.aU5LuShO3
 LRVVtWdIJNnvR9Ra7fkYnr0UCgauszRhW7ks2VPP1re3ijsYEDknEEuzIFfHq9kQ6wgyDljt3fr_
 ZB6gNDReOfbu6PQlvWCnlQjviojUvOlV0snjo_lw8lcgPT4v6KFcHjTpfimKaUGpX00LtXTLtNUr
 uLKLLuIKa4Iyfp8xuc.krj4S.fWHyUnJAT1K0XbTHzA6JhghHZMeMvEUAZ4vRBLAOKWpwcWfGaMg
 4ee7n0LY0EXD.q6EV5Z2yWHPGKDghFgOCJQ4JYg704DTnl2KVMsiPvjrqnMBvhlY79njkof0ub4Y
 bqsrzeN0Zwhozua2DZc7TkkGTjokGyNs4n1bE_cGDK7ZABxRTrW.mJioMSLPJgfdsKwcdAFrfng-
 -
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic311.consmr.mail.ne1.yahoo.com with HTTP; Thu, 3 Feb 2022 00:03:11 +0000
Received: by kubenode518.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 92c78fe2d759d98c8b61fd921c126114;
          Thu, 03 Feb 2022 00:03:06 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH v32 08/28] LSM: Use lsmblob in security_secctx_to_secid
Date:   Wed,  2 Feb 2022 15:53:03 -0800
Message-Id: <20220202235323.23929-9-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220202235323.23929-1-casey@schaufler-ca.com>
References: <20220202235323.23929-1-casey@schaufler-ca.com>
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
index 4a256d302d97..085565914515 100644
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
@@ -528,7 +549,8 @@ int security_setprocattr(const char *lsm, const char *name, void *value,
 int security_netlink_send(struct sock *sk, struct sk_buff *skb);
 int security_ismaclabel(const char *name);
 int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen);
-int security_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid);
+int security_secctx_to_secid(const char *secdata, u32 seclen,
+			     struct lsmblob *blob);
 void security_release_secctx(char *secdata, u32 seclen);
 void security_inode_invalidate_secctx(struct inode *inode);
 int security_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen);
@@ -1383,7 +1405,7 @@ static inline int security_secid_to_secctx(u32 secid, char **secdata, u32 *secle
 
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
index 5ab4df56c945..6763188169a3 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -861,21 +861,21 @@ static const struct nla_policy nft_secmark_policy[NFTA_SECMARK_MAX + 1] = {
 
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
index 8490e46359ae..f3e2cde76919 100644
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
index 2178235529eb..0fc75d355e9d 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2198,10 +2198,22 @@ int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
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
 
@@ -2352,10 +2364,26 @@ int security_socket_getpeersec_stream(struct socket *sock, char __user *optval,
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

