Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94B9D2BB696
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 21:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730240AbgKTUU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 15:20:57 -0500
Received: from sonic302-28.consmr.mail.ne1.yahoo.com ([66.163.186.154]:38157
        "EHLO sonic302-28.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729468AbgKTUUy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 15:20:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1605903652; bh=hdPFlMt1N6KYJ82qhjneXwVGFiiOSNjYsJurXTcc6o0=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject; b=qrxjVgWAuUZGo/WztqbzkzRhawd/CvTtvfRolzPkT/CizI2eqjyhXRAnIjYdvyuG/hBIC0p7j0B8MT5bLIKdT9gz0iChs56+RMFnj2jES/j8nRyEcPe6Jf5dvg3sMXEwPsaU4WBwlbkmyAFdSHUWTRBIWAnO4XCcdtLJgt/vI0rZrwJ21IGOuGdFS9suHjPqoTmKFVKmyEWbB73LqD+Mf3mhQ90hJFWxs4T0DIj/Z4HdP7e/sHBYSVI67cHGRyJOMx7QII+7zyQUH8KQv5jygXMPYnFmmMGlotSee66QHXyKwxFJjqyHOXqBm7qBHtXrP79FwGFMwwD+k0z/MY+78g==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1605903652; bh=8jstPlIFnSza0RcoZk+GnjlrXJFwae2QHoJX0Q81QQq=; h=From:To:Subject:Date:From:Subject; b=sAZ4ZyM4SVrN+ASxuFQChzHMweto8uzoS8mxy2J1oPkibA9sQfCiCfMsHGm3y8YMeOYuQZhMH/HbPI5ro94bf2iTGxmIa+hEMCD+2J/chtbUUMWvlItZ+P+bHvklZNTy/i66GORKV7F8JKzidnBKquhc6/uNrJrHnoUSMsnpdDOHkkAeIE0MMZRfnQFll8fqY/dBZnXT5NEFBUznd0vQ32SIkE84kF02rvFLSFssjF0B0tqzYZt2fPKBtOALRH9gbah/alVQg0dSbsU7oN5rkuUi0hrCwaGRhjFJr2zOzxdyZXRmYqzFyoM0hOhX+zyjGE2AtxyucxRrgCAqR1hSCw==
X-YMail-OSG: FlhGOYwVM1mkPTuuqhJE1zZ9cdU13t3f.5STFVuVYBUL6tu0zsFmJlpBoU2oN7q
 wY6ND2AknL.MkG5CIkoOQlbmNL07K5xLHApQc9cbIeMMWEheIu09AEFF3iWOohzRzDhaPmq7vkip
 iIW831QVi3tJ4R6ZKJXy99GjdQ73H2_RtjnFVUmI0BiyyH8zCGqCt9vM_AT72kkLhXE75Jbo07VB
 MuxrzHYT8HUhp2qDoPN69QajGXLUoL8Ge8EENcq6h0GENUxk9_XAqd130Et7Fm_zKXGDPaFRUJuO
 vbLHOZfFLDFnzSo9DoUp2a9W9qgWy8c5gRO3K3uQ4kh87aBuARIJGrtGdXHWiZYn_uIAn4StbtBB
 ANxV2LyZEfx_rc9PD400ETsQ8rEsFNoH3Gju5BCFIEidcKz8zKMntShm9jezgLzMtK1CYHdXliSD
 SHDudQEDxEFqes5z84bv0I4.OLljHMcYc5iwUqFlJt5Dfa3YnTIlGEIcnhitfx1WjdrNtto3jcxf
 QR4M0fx3gbu3LESQ0uA2XSYdJhyQB75AV_eYW05RsvKAXTDcL0QZeAtWy.Ubjqy_czJp87YMkQUD
 nFiGGNK2742o2fEKt5RISVjuEZcbrFVncoko2ACr3UrZhYykgiczVi4ahezf0V3ziw_9yhYL_hnF
 z1y2buy6QCn8Ic8BvwXYOlU8KXmgBNqN4CPxz3.tp4DAlLADAUWYGfDtvgdm8uJNE4v_w2RWAWI4
 PNy8Nf4TFZZ6THHetddCfpQgLIv9hNiHGgQylydzvAtSZiAJJWFhK0bfxTaBWoopUiTIOkGx8yDF
 i3u7oR.wCsMVdl0g6iGdbjFg2uFJBF5BbtjKwrF_vI1IGSrrDDLKIj6iR81W7hFOVtZN_yQH3oWI
 s.ah0cIyPhjAtWTWBl0g80Ao8VO8pmSyK2xbrI_CHEi3qVoaT.iNYty7bgHgIRzYTQqx_0CGrOMy
 t0Gg.h0HP9vh0zUmuVCEl3O7jAzl.20iMJjrg7LtpZv3GRJqjwwOtQLHgEUhkdHdGfbo67MeVV8l
 DxV1fOGi65UzXMMRyeEwQmSVB_kDj.idC1TNDa5nnw34FEVyMErl7nQQbUtHXyr92q1go6eUOH5t
 Rz5bRg.Sz7fxWsI4ku0bbtaXaNcG8_LP6Q90nQVLwaH5hx0qYc8QejVDwTle7fF9wF_m.sSojVaC
 6X1B.uDu4kTuxMYHAAWaV.iN57wc9Me9La6oGl3yMLyW1dLFzDPdKSJg5qmE3Oahq1fFCfbeANFy
 msUjt59401VWdC5FhThpcv62RyYIwZU0opDc641g4a_PElka0bjq3vFL_kFAGXTdAfLs9PS6qTYY
 Ommbb2BH4fVlDte29RVUJftZomM8VTEJ4vl5y0Aj54DX2hG6bYqiSloFCcZWbU0PAhFlraeWM6Cu
 hF210BjIZB1lp4.wyEVIDRA0ql8gdKdLelmDxp.OM6urzWeAbZdEg7ty4unLjV.vRYIb1kGdd9wa
 glm1HW4VpYcUukqzU7a34B4g2ZyLWHd6dwf3ERNilWnoGlnxq9SklG3ctQOypsxOvp6SkLdoiomA
 ecw6kkx2rOFC.bz8RMJ6UuiE.jw5serjyTbaEAxdO88Yzku4z1nFfWivtRs.L7d0YlowKa3ijSCT
 xaN8mSlBRWdfgtm6OmUu7OG5yxF81Y1qc_Dv2GXptfEi5X_T8zTZrQ9AjRxTF_.RYgq524gh4og7
 2fp2NCof.EA1y..qkBNxYRF1t11QXe4_8Kjo2vZKYLblp6izQA9eBeS_3lHibAB.dPPIfFB4GNhK
 GDOj1O30SsxowDq9rOrSRcVWT8lAOCMPSHQ6eWMYUV.vi0buKFS4kHPf21_ZRWV31jDH9ke11ZaZ
 V.IdplsNDDN8ehEm2VA0uG5BxanHlXw1Jblz27.hQNl0KzxXnHXf0CgrMauuxNf4HPfHuR_TNvxL
 pWGBveXmcirn5GoO0aHgLuJ4i2FzMngOQg585sVt61K5DbYSnwPf1sH0AfccQH.ylUCIDRJv7fRI
 MHYISMidl1_0dU9r03CT_WnWqFQLbGbyVfhoOiiCJexF8IYF_JbYjIvZHs8tFppXw7ibLwvtwtat
 doWMcy.9xzDePtiUHEBhRQpmZsLgcXm1IcjPAuKKzazWm2XIW2VOLSZffdi.4RJF4ZkhaJ2Q6c_L
 GEfbyar_u7vHWAOk0AhxZxqxcePbid7Xo6uHLZS_hm6KYlJMD8RtsZQ5W_F2hU89ozkOsZuBZ0Q6
 u77tiIlcmlfCXR34MiLl9qgll8TS6.sUMSvCSGd2pn8DQokptXLrSwR9AofMr97M5PjVjF7nAy24
 mfqRGDU2uMI1d5dvoNMLVWb_0h1MkLne.wl0npqdalBmwBvKew4wz5crm0R6pLCQUwpedzwQJe1Z
 JNm1hp5qdVLlAldIIR7hl.OfNj8qnMMtRyaFbwxmI7sM.BSZYRWGtY6RFTXURRq0KaPUCjOU9ylL
 JQLyBFcab3_mdnED6rVuD4y.eOLp4IckX6q1WqFoWZPmX7.rOM4pbaMa03MXxzQYhkl8rDb96OP6
 qOUM8zzNKX8.zAGlvdvo6KXzy63XOPIZTJcT2Izn4yMv5L76elYcFazQLPV4kxctPE8xX4Mj5D_r
 wtw9Y4nUb9dsMeNCOIt0JrKXCFmtaCIIYW7.8kdZTMx43Nh6CwsSQ0I2tHu5zIdXgvMpzfxd5TYM
 AxzTkhqmOIZeyQh9cUgGCxM8HqEPKt7PM8mwnrUdy8h1DwsDX_mCqeI.TikAYTtEGaH5q1jMsbfR
 OrzxhNvmZABWK6tBDfwo1.TREQa3DHG7.A0Nazsm_EoXLhhllHZ48SSl87BNxvs7o0dkfFNNxPb5
 4pHP2nRP6.kOcJUa2KF3ovE1HhvlDZUthYgLgyuQKmUygqgB_tDVZIC_IomG6mr7hmElCXgkpsgz
 NzbXmbGTtkzgvKLR.cqa1RIp7V8noz90PYCWaME1qU8aUAHWhfMnfUfuEoqaQ5oqvIIywKtf.rQK
 68S.NN0_77ef63xqmqj6KyiaF67q2OYCu4fvBg_8_APrTDtl5iIOE6w.uhV_SPNX48.LLRBgSENC
 ZZPrRECwr3Lv3fO45cuSTNQ9R19a7sYM_U.9HOL08eedUA06I_XK7KF67A3TsKH.nm6B75_HRShV
 xiqcWayJ.IYjrEc297UX3wAswWm0vouprCcZsBKt5iiKbLug9MxKHi5_QIQjd254xGBG.uAsrS1L
 eilTkAvvHVAazBiBJcjIaiCuqOgmrfSDDdLyZ7nScPt.wGLyLW8AP4SQ1RZNPL4Dk3Xxymts.T5m
 CxeD4N_1xPiCL4G6pfUDO8GUGEXedWk1vZ1ZSV5zjaoNi4AbAMLgLR5tQunw8Lr_quXRuxN8g9AG
 496DKRjfNp7eq24hxmrBDoLc2kudnEsFA8ghz3DzHrOOlbVfu3BmXW5lo1AxOD8KtBa6b64sjfZT
 Eq2I69dknpCrsoQEud72SuU6IwBOwHBhjm_BbItR_XgnbZGdSWBmiWn1FJVKuVoFuV5uHjJ3A.4N
 9gQ8Jz_fr4hVU82.SdSji
Received: from sonic.gate.mail.ne1.yahoo.com by sonic302.consmr.mail.ne1.yahoo.com with HTTP; Fri, 20 Nov 2020 20:20:52 +0000
Received: by smtp417.mail.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 3fea8d9feb3cc20fa2b4afa5206cbedf;
          Fri, 20 Nov 2020 20:20:46 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH v23 05/23] LSM: Use lsmblob in security_secctx_to_secid
Date:   Fri, 20 Nov 2020 12:14:49 -0800
Message-Id: <20201120201507.11993-6-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201120201507.11993-1-casey@schaufler-ca.com>
References: <20201120201507.11993-1-casey@schaufler-ca.com>
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
index 948d12a5eb25..0766725a6b21 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -191,6 +191,27 @@ static inline bool lsmblob_equal(struct lsmblob *bloba, struct lsmblob *blobb)
 	return !memcmp(bloba, blobb, sizeof(*bloba));
 }
 
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
@@ -508,7 +529,8 @@ int security_setprocattr(const char *lsm, const char *name, void *value,
 int security_netlink_send(struct sock *sk, struct sk_buff *skb);
 int security_ismaclabel(const char *name);
 int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen);
-int security_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid);
+int security_secctx_to_secid(const char *secdata, u32 seclen,
+			     struct lsmblob *blob);
 void security_release_secctx(char *secdata, u32 seclen);
 void security_inode_invalidate_secctx(struct inode *inode);
 int security_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen);
@@ -1335,7 +1357,7 @@ static inline int security_secid_to_secctx(u32 secid, char **secdata, u32 *secle
 
 static inline int security_secctx_to_secid(const char *secdata,
 					   u32 seclen,
-					   u32 *secid)
+					   struct lsmblob *blob)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/kernel/cred.c b/kernel/cred.c
index 22e0e7cbefde..848306c7d823 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -757,14 +757,12 @@ EXPORT_SYMBOL(set_security_override);
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
index b37bd02448d8..f1b9b0021414 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -811,21 +811,21 @@ static const struct nla_policy nft_secmark_policy[NFTA_SECMARK_MAX + 1] = {
 
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
index 75625d13e976..9845d98e6b77 100644
--- a/net/netfilter/xt_SECMARK.c
+++ b/net/netfilter/xt_SECMARK.c
@@ -43,13 +43,14 @@ secmark_tg(struct sk_buff *skb, const struct xt_action_param *par)
 
 static int checkentry_lsm(struct xt_secmark_target_info *info)
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
@@ -57,6 +58,10 @@ static int checkentry_lsm(struct xt_secmark_target_info *info)
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
index fc55c9116da0..3b7a3e0ae8af 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -882,7 +882,7 @@ static int netlbl_unlabel_staticadd(struct sk_buff *skb,
 	void *addr;
 	void *mask;
 	u32 addr_len;
-	u32 secid;
+	struct lsmblob blob;
 	struct netlbl_audit audit_info;
 
 	/* Don't allow users to add both IPv4 and IPv6 addresses for a
@@ -906,13 +906,18 @@ static int netlbl_unlabel_staticadd(struct sk_buff *skb,
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
@@ -933,7 +938,7 @@ static int netlbl_unlabel_staticadddef(struct sk_buff *skb,
 	void *addr;
 	void *mask;
 	u32 addr_len;
-	u32 secid;
+	struct lsmblob blob;
 	struct netlbl_audit audit_info;
 
 	/* Don't allow users to add both IPv4 and IPv6 addresses for a
@@ -955,13 +960,15 @@ static int netlbl_unlabel_staticadddef(struct sk_buff *skb,
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
index 3a88a90ddba6..eac7c10b8cfa 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2081,10 +2081,22 @@ int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
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
 
@@ -2235,10 +2247,26 @@ int security_socket_getpeersec_stream(struct socket *sock, char __user *optval,
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
2.24.1

