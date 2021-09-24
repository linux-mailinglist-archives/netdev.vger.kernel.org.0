Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5F1417A69
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 20:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345819AbhIXSEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 14:04:10 -0400
Received: from sonic308-15.consmr.mail.ne1.yahoo.com ([66.163.187.38]:33769
        "EHLO sonic308-15.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344901AbhIXSEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 14:04:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1632506556; bh=05vdcWHZL4PkRaRnUTngQZEvbM7FJn/OZ3TNy3QRHg8=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=tbOdvGyhBLC6MHANNxhW8/jvzrBae5+bFD6Fr8Pnp91BPSKXGqlSj91rSwC1TYLlUqkQpT8UqHqArFYdRHlgkkywWRuRKGTtdrn986nn8cXpp4slwddtMdWvr3fcyvDP3zPTdpj6KQA9evtTWBhOH50VqOLu4v0tvegrIZZDY3ZPqOXwstWsh+B9FGK08YwZla++Fc76U0HngSt7flv05q7mLA39Uj3gn7sWIHWmqv9F1nTdGubMHTN2HPj/qc27qJ/XSO+aEac1QMmUz0RdvW3W7Oem72PfGIH0Ev0f8p0p1+YLYl8XaxOhIVt2oWWqlOr+mvaDwp9hLhcENrd7oA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1632506556; bh=9k63uR3ERKxbEPkcntgv7N+g7Hm8OqDyMGuwOA6rfHe=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=YT4rBlxg0osAkCUb7E+/Ie1wpcMZbzdhINv1eZ3U9gJuiESsK/ANXsdGTNz4E2jVKmtMvKN6cF5q/gZus1imDeGBX4ShA8NiYC2A2zlxHZBj2WxAQ9BNIql3kGZMDYX3zEHBjs2s1jmcoNAP0nOuMxxVpOZ0ZCSif+uEn+aVTc72m6uHDrTLSUOLXvsOh/RhjjAbLSQKYtNaT+PULy5j5yTHCEMrG6+aUznZLHoSxXF/kN5QLTpcLooBCF+Ll0FUR1A+FYwcgOriZiJ1TMynQZ1Ca/e3Dgr0Osv1e0CGHQjV5gHgwScA2DmFnJUs/wliCnrfvJ3459FUi17zglnIgA==
X-YMail-OSG: gaV0jtQVM1mwNQ24SP6xB.tET9GDitMB.5A8f98RYsKVrLg7KkeFbB.qkJPYl2c
 _xXbhoFWDVvFROwIARXRu_g6UyUrnrGdw_Oak_YN9jsLHNuOC2QJnIpe1dsx3YqX01zCAExfu1Gn
 6frgzbJEifwwaOq6itbmPLUtIRgXjFgc07vGO0PYzhbMXdaBkkx3Acz4A.Iru.3E3NgR3ZE7tneK
 HHo8P2czQw9D0ZpioMczPLcdWTVdJtbJu_p_fs3AO0HaznLBEljdVaQ80KAN9YH3DW_zZuejkyzZ
 jROYQkqg81_9m7Hh8kMzP8xkfqo8AKsUWhDoffHTlptJvjdXafl8J5B7581NTZobMl6qK3ADIhW7
 lnEVZRNE6E85uKqEHiLltRa8oNkNDhH7.x2oVX0dQb9LCq6aBhmqoeqdHlX9TzCKdpIeGQ77nn3G
 .74BAc9SAvDhI__OFTESVhPeQdjX3kLNdDxNpCULKWBgo_B4IQp5raS.A8F8_gbWVc0WErN7y6aM
 uwGq14IvwLF8bdNfMtocUSMZTIF4tBfHZXZRhgVBv9iQ052u1zHLXxxVOp4U3Q2SL4D8Q5OdehhK
 dP8U6LG05xkhNvyB9hsBYYgIOqVBDVTpbYU2naZG9udUyGS2ZiBlfUt8r355ZbPi17pFVaW6lIhy
 SF_BSAIzYg5urLjST2EuPImB9RDjLr3m1mskqADrm4XYW46BFBgzZSzr..yLFjTn1zfh__vsUz6z
 Q5ZMjCYquYH9j.5S9a_dZtr8LV9n2wyZt.5xueMwUXqEI9l5gdWYqUxDuZelfMcUm9Le7P3.Fk5e
 Wwb5i1h4cZQDdJAkcmGlHK0Gz73P84CId_7PbsHfIwUIroDZWwBBzrk.clLJHHgVxx7kw4lQyW_3
 ta2ZgcZB3OBSHWWsP5DdtCGrBatROWkBKYprsO8S0rauSKIFXjYL2cXjdxhqjgGGEA5Mzpngqysi
 4nCRfR9ZCwZhj0EBcbFCo.Yte0KQpEO0AHMHF8rhGJ.mHu2BYgcAG.qshHNBemwdrdjRgqeGzwc1
 Gq7oZrw9KfBDMD5Xa7YqxNVcs9FkloT9FKUJOJ8gB.FVRFoDP1w0af2FhR6xErY5OKQgXPbxCyJG
 i_HYyXGxLhcMQzT2oMjhQgrdW8BgvobN.umlyKyIy70n6g9GM93UBCcu5PEsmJO6sMgTMsEDH_Ab
 IK6SvKzryzE4E6oHyCGY60L0od2jc30uI0gXHR8xcsvdS24HJM2UtxnhnWRUJxvVfCaLztjyP4rG
 nCq1KG1wID._5C1Ss5w5PBNE20bz5Z9bQb4c8GZVWe80rsY08nROKnz0m3MJw00497zEE4mz13gB
 vj_T2neCJu1pguJPMKnXFZwSEP6lkmtYk8tFb6Mdm4pSB8km9V7YL9mWhYt0cIxPz7fpquEwvYtX
 4j6gOZU90AfUfVZFD6dPKmDEFwTiXHJf5PTtrsK8MfHFHz2ZOOt3f_pmC3ZJkCPUWnLyt86wWrL.
 b7Wfte21tEuWL8aYNisTfwPdpQ4.h20foSbBQSjVoieFMStm8fAmgU_qrdcJ4Rj2sWUgQ2CDds.H
 TNo7zgWcC_ZnO3hW9ZZroc7UN9BclyGniXv41M76LkUQRktpdp5SBChINZQBkRTzdKfEziqvxR_z
 iLbAETN30OnD1g39x7GkFra1wE6ZDQPgzOw2KTxyfl8Hv6V7hs3C1.PUBIftJx3CulXHdzr7DXuT
 RMVPEBj_PM24NV.heiq52QyDKyCV1d.vier0Hqphn3Aaq6g93m5.Wts3E_mpFgDYbBwMjVY0sJdr
 6MtAKfUIN1aG0GXFCTNF6wrEcoDYOwfkUtvx6fnRaZBw8u1qA9fj3Ft4zbXD42y.hg8s6SUblnai
 fzPhOH.iXBJrHC456CfPrJj_izBL9HacJcCY03WLJlJkqVFmdB_xIcNLidjyaAJb36EWu7zA8txp
 YAVIR.fRxEPqgIIpvs6naWo9IIVE7JSOrwolLGUpSmTH.5Lcobkc5Qp8VpWvpAdvasdkyg7QAPNt
 pH922nDf4UwcDnRZ27K9zX23CYCjC_IKhYKn7wTjae6q9PRYW3WUE_2vKBSw8u9EhVwyiZfujlHT
 uvTclsBvbFWrcYYOpGTmD9HX5woMmHr5i_WrjT74dwDAxgzlcRQlsGx70znZyFQJbRj.JEHk3YML
 FTRPaXBFWy5sjORASltlrAihbDmYSfKL4STZLrgLsdVZZ2PwkCAhQgm9dTkwBP2CtmrHtsag5MzC
 E61Jpgwi0I3a7dhWqSkCTRDtlwjRNZlV3Pbs9vd4AXRYBUpYafCVRfHmVaoVh8PbELjumyD8RIkX
 xsqTmdLnWXHuKczSIrs.tbv4W6tJU4Y_LDFElWlIFy1SVpqDmnULuLTYHB3G4F_fWMwF4aw5FrGY
 Dqik8nOZfCmKXeCQ1hHPYXDfuVN4GlY8V
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.ne1.yahoo.com with HTTP; Fri, 24 Sep 2021 18:02:36 +0000
Received: by kubenode558.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID dbe4b2bbb40ee4c99862de801b32817b;
          Fri, 24 Sep 2021 18:02:32 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH v29 07/28] LSM: Use lsmblob in security_secctx_to_secid
Date:   Fri, 24 Sep 2021 10:54:20 -0700
Message-Id: <20210924175441.7943-8-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210924175441.7943-1-casey@schaufler-ca.com>
References: <20210924175441.7943-1-casey@schaufler-ca.com>
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
index 399b83ad1a43..e2ca097b58db 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -197,6 +197,27 @@ static inline bool lsmblob_equal(struct lsmblob *bloba, struct lsmblob *blobb)
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
index d82fd1236537..2f9ade2ffb20 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -798,14 +798,12 @@ EXPORT_SYMBOL(set_security_override);
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
index a7e01e9952f1..f9448e81798e 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -809,21 +809,21 @@ static const struct nla_policy nft_secmark_policy[NFTA_SECMARK_MAX + 1] = {
 
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
index a049b82d58e1..520fa287c90c 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2194,10 +2194,22 @@ int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
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
 
@@ -2348,10 +2360,26 @@ int security_socket_getpeersec_stream(struct socket *sock, char __user *optval,
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

