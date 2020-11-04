Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDC852A72BE
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 00:50:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732865AbgKDXsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 18:48:52 -0500
Received: from sonic313-15.consmr.mail.ne1.yahoo.com ([66.163.185.38]:45375
        "EHLO sonic313-15.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387551AbgKDXsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 18:48:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1604533689; bh=erYMDd+BdGzaMY+IvBFczstUTN3hSKUThjOkBNjJt+c=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject; b=qSjCSL2S2gBTEuXRhfCDrlb8RKq1lUu7x2yOcsZId5zsjEJ1kQ9HKLrh/behyMpEEZK19JD64/PCgLiy1L2vRjMMJ3HFhO7fR6pnFC+TzTmvyjJgrrmGF0HS5g/BItFaPoGfEwr+eX+9TgqccCz7zDNeQkxU2X/DJGbiLgBr3BnfgTIp6WyqS95DNacX+5bLSVYylO+PFqY0R2BI2dZCMq+DaDLlW9ixV6GrCXpdYyBFgKh3q/RkWhh/GAgEh0tFVWQdC17VmkYl5+jTRBxbgrNLp3Qdx2QYrVFAl+SFgkCpNFn9O4pXknpUWGm/biTt+j0UMlhjAxM741+zeNFNhA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1604533689; bh=4lh4PWuyVUUM3xU9NJmf3tXgWtHj3/WbGvOmkowUM2E=; h=From:To:Subject:Date; b=NMG+ICDf3kO+TC8jjtjhtnXz6wlJjRoEkJEexO1YkT1EIW27StyVN6WChmms26tzdFtP7kD1S9eHhNs+XXrZjs74wafvPBtW1blet1vkJUASXa3ycat1KzcYcrdPmror7WnbU0zc+OnCz2pTh+1kpxzOAnRhgWeROzy/tum5cxMwBko727JrIqjo2AJrPzmPmNDeYsSxKGjwTgbzP1GYYoASJBTdnOYfXSKIKFY3LvO+YiyzHXfbzy1GLiR+cc+PBs9ahmvPHAv3emRUhBDjY5eEFvxFlS+s8TYrhZHidJftoLTC+Ax9zufBTeHhNk7sdHefFnDUO5U48+zXF8V10g==
X-YMail-OSG: sr93T28VM1n6TGxeFIa62emefs8J6r4XSXUwAUnAyj1PNJ3H6lNuTVA1_U2E7Mg
 ZSmmEwSymITOoXHHVaYK4x1J9qz9nz83aD_TGzlIs7_PhEgtv.9JuQxTk3ot6bzxp1Xp2uJN3xOK
 pnu9lz7nhkkKt5c_5TwkPw_qjVZeqfVZ6Ra2jBY_2oR8SAV0KIjcUbhzdUMLHhQ8Hu6zCHjUDk4k
 Cw653g.CNkl4Z17j58v9adxh3cXFvc9HvxVkpKkXEp2NYfoqnRNu0VNnmPrVn76MGkEGItm.qqkV
 AQIMvMthHtJcrsK70fvFeH8V8WZ8Pq50UnFekarLI8Acw0OVOJf99gRmD2APZGFG_Y56ptOkiuiG
 NhkKTO1XAEKmTZeFCwMIcjWn386FpExsBJ.BqP2pmvgoQCyUTAfsMyGOThfMiu7L1No65Rhep6f6
 PMvmM5tk0Xd0yFJ7RhmTDEslcoqcSQIrxpiv_h4MAfeQyAH1M_Ox0NnY0zRr4DR1nKNhlvbldwns
 q9fdASJy6APn.2omVejmsSTwSkdf7Vu7.5wR3dqIZ96wNZumeYSWZ3oFf1nHgwxk0dbK1JU8tnQt
 5Wutxnw2dWUrwTCznH432GAp_bpHvYiIT_FF1Bk7Orf13SUbzV.zph39PR_s5tpqhnSKczL.NBBh
 KljkhkVpkrf0JDijbWCLEtPMIW9F6X_i9lrRBg9hy9JMwprQAcuz.EzccSWh.A9be0IpCuDHD2IR
 TMduVV3.KkX81HzDnN_m0Hbzc1mWZxOUGSu_x.nJ9aDaQ7qbsWYg59Q1BChLDw2rHGp4kx0ljma6
 qKsLoNTtZD0ZMbHhbiEHzBwRbXhtKBGbzNeGm8I6t.SMKFgukIhQ98.pstw24Skm425sMwLNa6_P
 TKPGiI7SVCcVaDtuMbZUNS.YdAIAiE9gFzsf48I8P2SRPtqW79v3v8eutsnu2hNno6BQiL4Bn3Wn
 fR93FSXbNTcfYWSPsUvWoYZrpj6HI3PGWgmaE9kr.KenwNEuCSlFM2RHWAFL48bVEaC9oE9C7_dR
 IWSe4KcZjB_Zrv_7WyyzSyt7_HqAMB8Q8wv_l7YMWab9VDVqFME6nE4WOzMzWzLFzVJtsHGsKbBy
 UCGydTbxCHHyYACZA60tilGh3lwnDQg8pqXzAFAhb1Z_wAhq.jcv5xihZdKASpPE4y81Py.uC8Wc
 .QsyLoznKLA1hp2XD.OrYYqI99WNrYzSIqNoH.NkMz9D97DS7DI5VL2HQldxiYP3ZTI6CnUe2eog
 j4Nro6ER9pvQM9VUo4cjT2rVxEbT3rHMl_pkedFuJK_X.LCpYMqNHRyd.IfKzq05ejZWhzCSxObI
 CbsRNRkA_uT_c9TmTVXURZ15jXJiviJ7TPj46J1t4_lZ1qQgcVrM7srZrqG1emZPZYJCu8X.uDC0
 9NC2oNL3v1iHN7_wVhhRt4pxW68Q55HmTQGaBrcZx9Xb4WVxJdaHHWVtjY_nLEcr8tOl6kPVYgVU
 A451baUuNtXetTRura0IiZRcmffOm4jpNo3XpjfPpCmnpSe798CTg4U0CywTsRI8LhLhnPKjyvta
 vK.7GAzR1nH1iSv.Z25CcnNF.KNwcb39MF3xcXmKqRuVXErZPXulOSoUq17JXYMbpF2pyicGPbUM
 QvPHIYhd0csOjTx2ovhKggaZszXY9SPXXgv_E7qV_N0fnO5xjMk0qHU7jbrtgyQ9hTiQkFBUOKSD
 ayDdq1u3Q8vpmzoNVloTBlD3kO5FUKDVrwi_fdLysCZ6x0SmwjXbcOQnRYCRmyWw2AeRFcmXIRYv
 t8IGr5AMl_rpfquSkfHelUkmgi16hp_R_KtzHRbLy4mVlPHOJdJ4vcT8o4SjTa3BYwh4hc5jY1Vw
 bEB6LlUejv9gI4jjZ3mlC7.hom7zyQKWB0uOLzQJsP8dI8k_ZWRsRuEZRjqES8sBItbrWRltzwR0
 3hE.gW7QUjMKDxNXyHV5mXL4rhIifRINBqEWDeDgjSp45gPpPWUgvYc8k_BFuNQl.AXBkNr5h7BN
 mNhpy_LrTyWyqAPFyFT6r5dBd4Z8wcpABxrFw4317b4aRAh8zulFWbuZKao49bbBSXFRrUs6SYYq
 4q95fcJum4oDu5zvVI2bwVZKXtEytzoyVcncqQzbK0WVUdZJ52EzMEIdDUQXhc5KKLE8rluS44PG
 yEE4DxWY.N2hDpIcioxgNm81xnZdAde68oeoJnyoRad5VIyPpVA4jXaI5k3O1DUDn4QccaEjJHo1
 IOwGOZU_Eqe1ejKtq7sWWe0WajzqntOc3aVa.lS24wrDWWBd9rIdQoTvRN3crEI9fKIlmI4SF8f3
 _XOVu5PmlO1uU5iAvu4zz_Ug25n2Q5g_HGKXqwbT4BpRpFibyNyRdV81i_rlblYzpToC0duMo_UM
 GjHg3jeQo_4ivjqX53hKMmUMEw4opYwoH1xZITw6jWAUj04_lsza1aSvzU32UnnoPtdDPJbhiSMN
 qPIC_FClg_ducXblqeXPVzkBY6QEUV.e0zNQNBdhJS1qf4vTfcNnhHQ_RKvcewdyuBrLO2bFOg5v
 sxXRdAmSQLAKaixmFX3tTR0UnhMWa4LXHHP51g4Vvp7vt2uOqwylV48x7xorCyuzTRE1nrA9KQLA
 gA5AuqU2yZwMJ2sxwOukmDLPiZ3yqBaCfUxHtPQ9s0LpVWJbBIqNWtFDaVk555yjder6FaQFBeeS
 GxJ6A.XHEGKmH4733IJPIITv80LeaLO1ytcH5WVljBxsf7uquFKNrV6ftg6rbiHqoQ3fjkSFrIo5
 oEuNeLSydCCmdBi6PYPs3j.gqK.IgnDuQkgrTNfmlpkIm6.lkU5AG9x3tl2VNoKFlokONhK5leJx
 wr0mQITLkmj49fG.2J47SjPWr.2pIE.potr9K6AQhoGJBVxscO3IxoyMnEF68yeGAJxIrJeWrFSH
 FQavIdssvVF_TPb.Pmm6GlmPaoOCaF9_ojW4wI1ffNTnrtMUaX4P_LMOTKnCoyLWVFVwgwZsTXTg
 mhl6aOxW1DNr5QJUwarpxMUmlqvvPQ6ks42wtdR2QwHuO.d4Crwr3IQH3pbBqhjMGq2gmXxzEac_
 zYnrhYWfoEijgTTjerCZd01rC4eDke44U339AzUr1rEBuIuY5W.kTYJx8unD_UBqWd1vg3Tldtxu
 1RWCwDvwvs3JwNgnF2XasdeiEooozlUuNCQZ9Rghr1WfCTz_ZOJ.fYIvdLNT9qfUZZb97eYY06bq
 HaJdO6yXbEtXpWIl_3SRiM6LsiftyfRS7UtR5DB5GAqUhu0y7jAxfc7x1vk8W4Pt86avaJ5EhWJz
 3.k.3hsP32XFaqQ57cdrCilO8nmIRvy7_SptjajVSYGgwOZy2iOBDeRvujwPEbZkyBpiOsdwsmCd
 XEUJQ5i0GdoqnI9lJW1Cd00iSjPzAoqZII2Ps0PjHmA--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.ne1.yahoo.com with HTTP; Wed, 4 Nov 2020 23:48:09 +0000
Received: by smtp425.mail.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID d53b5fa43e99ee2806ceeb620b264b91;
          Wed, 04 Nov 2020 23:48:06 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v22 05/23] LSM: Use lsmblob in security_secctx_to_secid
Date:   Wed,  4 Nov 2020 15:40:56 -0800
Message-Id: <20201104234114.11346-6-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201104234114.11346-1-casey@schaufler-ca.com>
References: <20201104234114.11346-1-casey@schaufler-ca.com>
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
index 2e8e3f7b2111..8c064342169f 100644
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

