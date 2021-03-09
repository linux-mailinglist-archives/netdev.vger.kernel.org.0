Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A89C133291C
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 15:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbhCIOvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 09:51:00 -0500
Received: from sonic317-38.consmr.mail.ne1.yahoo.com ([66.163.184.49]:36657
        "EHLO sonic317-38.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231623AbhCIOul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 09:50:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1615301441; bh=nM6mpVBVYP+uadP1C/5xe4lzYrhCQhV6WhH/8lEST4o=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=l0ZX3IRD6Kqtvh2ZerTI74tCkoJFPcz8gKIYyidjliOWDjvYMP0AYQFX/GcfTucsaiAew8nraPofOux9HaxOrubi06q8PxWKfR6RiF0DKX0hzYK+URouqPPp1kVQ2KA/GVLUZWglNKmJb7RHWUyHQ56lD+gV5PdgVI6OxFhOxzYb68TURZ0LK5UA+K9WQ5gpfZwBjWUji4kiAJRhsmncaLxVXqg3G6mPyu7KC/czfk0x2ERNf9OCVxZPzx1beJlBWE+eNhIQ6Ejj1CF6R7ylrS7Ya9vwRlAzoU1lJvOsJRAjU0lxRTf4CVVeFUV5PFtRuOtuQSQBTgMkWKzHuCxjjw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1615301441; bh=QTFQkTEl3Zolgz4whwJA7+gdZCapUaj+OrC5LS4+AK0=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=YPHBumOXWQs/W5L+nYOUgamQEYzyhilHnTZEiN72zIHBCdMnk/3gus3ZWx1btQGznWMPPdXEZoy23WbFOTo7PpbkZfrk67YuUE4WqinHlJaII2cVMrGg7mK0GAbOEkHjvtzasnOYyIBmzaY+sowMjqUfC2p7grtEwbDGRVZUba7Pkp9jYbXfZWKlcQl5+Kl2eG+1mpSN8OzR905MOHPrGw0lAqHFf2ukZwz3tdWEGIETq+y3O8RcRrcWLb9zC0ZtZ0j+oVDfBxDvzfzIGY/IJrFpne0j0BKcYRYdfV+0YlOWvrTkKTaWaOJB/pOe82Bi+GceQF7HXIpE/me6kI+obg==
X-YMail-OSG: AjXgu8AVM1mAcEiqdRcdDsHty9Vo69bfZ16QRXWHR7lgYn5Ni1zHhv8k6BxSexw
 hx3c5kkzHla2QuBtWDM1oL6d21TnjTK_yBWl35e9Sg8HQIdM538VboTaPSvAw_Y_rbotGtbi9hH0
 6zA8wSX0VN2x0cBZNut54cJz22pXxi39i3Kk8Zeucb1cShEoFbs_GwM57T3YhhqqNUTOAoTdBW2D
 TkP5Eom6CmmbDcrC4gsfxWGxCpyipbRFSSNNoG4En3du_BVIX0.KU0YRB2LKBpogq_fEG.i4VHyC
 8GDiUYvVKBoLy1Vr1VMpjFUJih7k.xxMhur85HloCq7aBawr6GTyaAzsS0H4BA5P_cwFk.wQCka9
 ue9Yx14K04zd7.maRjVbuT0PNx45jxFyKtBVnZmv_wnp1UpR4wDDmyUoRsUH3mXmPMjQk9mW8J_z
 mU8cC9SZltdqF7KoGLNlXOfwFbyW3qRXs4ic.mSHZUTO5lS_M64BNHuEwTed_vRnKOnCzouhSOdi
 v_Zd6QBEngafXp_yjIyUE39ud4RMqAuSSHkIEY8jyrwuSkIrZR4dZjuJwHxMz7P39PqubfXNhOeW
 8XhquI7Mn576xx10wtAjIYGdeR1KLygtGsPxKuM5Xq7fN_pQ1xPMnbTUE9l0SjbccJJ.7iaYlfaw
 DdVFLbk0cKF1r.O90_.VL0DHuuUCA5Kam8TMnw9sSkjS1puedgq5Euc1L5rpaloD1jIEztWGyR.z
 vldb9gDAeiJ07MF8pIZqbw_sBQtlOuQkVebPtTvdIUPDiB322z2ihLhq5aHBpWWChRaQ7BHCvuhb
 meGelHZe08sFrH3rULFc3sYj1gFTeuLIVshCj6ax0sIHMw8e2RkJrqqnmlCs2jy.zfO3E2t7EqBq
 bbw_fCOYlZhwDjCouApevLn92Iijqs6kZKOTKl1qrv.RG6fPpiTKS5RfZ0v6z8wtR7wiz9EU9kx5
 agiZ0iEpQjo.Y1ZiaG5XC.l83vJ_pJnkc_O.fS.Zl5YM2wQ.fO7DLLHRToEAbsH47COZ3epybWuw
 R_hYpHDYCbMIfdx71YqbkekSE0DUeftRjv2o0O3kYiK_rGD79wvKL0S945MWETbiF9pdsg1WDMNr
 ArfHvarDlRrQDlBTthn7zvd9oklw0pIKvmV64UF1LGqjTuGCqDGbPaZ6TAmUb2iAJhKv7fuDXzH0
 FmZrdHRM0.flf7CbOCWgiII2Y8tRYNnRq1R.ZeUxP6z_BoC7aWi6Lg8hNCzloPBQ_aCoyp9hBgk9
 fgZjiSIH.vch6QFtne3T1y6z2OI_xQr3_NVyj9uIYHhd479HXM65xZmvuvg75aDwCMxFpm8PkgCw
 TPZF0s0.YpY_H1zJn8CFk.8WkB.lzemY.jK.P_Pfo2FCSDHs1g9yGhUgeMAZtgvNf8m2SdX6P_sx
 FpwXqGCMmn1SFVkAjkoJXdIBEf8kfJ9pA2_Xkyp7qdp6WYZZ5Ld3FoRvJs.FWoJSEQCRge34MrBT
 oBQmbJriIBGQbaFMuz3ejcdCnykI3lC4j_PQ2KDH9gxsD7oFXb2rLnff9LGTWo6aXZtYrKR_on5u
 PlyjK4XJW0E2Qv9Vw6S9QZHGJ.x1c4g02tGVWAhtNhfleiPh5csxWZr1HhjzK66G5udX1IoATYvd
 9rpWTaGFvsQEX.xK8JRrhtbgKGy1rxLicNsQRR0.G939mPRBqm8lBWri_v9beAYi2WquFX5uNLvD
 0NMkbnZg0VlFJ_VTVhg0EcBI38yMWTIsGRG8.FQc.rXHWg2cjsSO3mT3DEEdAxpyEUCWmZB6dMNL
 fD8VgK7uObGf1.GNbwA4zrwyOA0WdZGGKAjDpu9A_GiZEYgzVI3aCn8Z4e4w8QJiB91rYco.U02P
 xdVEWb6v0MnOGZKHOWHImndvoN5Vr_K6URBeRTz_HPWsJy5yq70uj0dzHMKBUkr2NDqlujxhs2hj
 yVGVpEH8.nyQ2V2xvbjSrk3RTi08nfjzh6PuOq2MSSfBqxtJhKps54dUZj.N48fTMejvRiOJmwfO
 iRCZYTjlAzff9S6jI6_8u4ndL0e8vlR3qYbEv515eZpChewWp9DtoOmk.r1vZaoA8ZZsFEMoAq92
 9zZyJ0FIqzTb9SiGpwKI6nLPQ1Q1TeeiH4zLJW_cXGUJBoNjtcEjczSH1R3feIfG56QDSuekju_G
 E4W4_htxx3hXGVi5tkVpAlxU3zypE3IHdcOENuZpGmfIOi1riFqsTbnwPEx_U5tKNGQtcmOOF6nx
 D8ROo1QkhaowgJk2IU.s9p9RCahOwA2.ZXBZpPGdKeyV_P5KJuSyeR7_Zg4X8tnBYA1.QGrUN8.L
 KcGLjnwzhLdrxmRsVW5kqp0jo1f.lzlp2dPFWskht06PSmf_suweP1q_xxLAPnU3ow8Q1mFKKhPS
 H_5uIN3J6AECS5KKnahKx3kEQv5q9e77bq9T5RDgV8DsQDjn9ydmrTvzscv_ZVJnwBIE3CM2qfdM
 cw9yypyNEZWK.KlfMI9TrlTtcui5k4WkSGdSOIhcTHLxXgvMQCtpG1V1_VEKmQe7eOmozj81UB3z
 XiFgZ_hGr_9GskvpHWPbhzDoxIB7VC3L4BYbA_8hsOZGv1TJAKsgtqtY9GiPptp2RmIwJCN7kyoT
 Ulx54iV1Aw87jqmeT1ykNlHSC_TunvCsa3f1irYm8LzZ6cLiwd04wC04tl3JnS0SCt96dGxb20nY
 W_vA7p12Wt.YqJ77AdjIxvIq6M_3Twh19qM5awoaoD5FIxt18wMbzHqmINZ1QnOWzu7hUjVlVvj_
 fHTdZ1_HAGzSfeMC0TMeM8P83wYvjQfvQhvVhrZuxQvgYwU13wzJYGEWl03l8BDF7AKDf9iJdP8X
 v8.JS7H9FBveBq3Wm9BAu.o47XoqbIteh8T4g3r1EjcvW9su7SANpkGyHk9HkEg0c8vp5CS9haBo
 VKQl7TTSyiopr28rF6L7H2H3VVtM12oludwtIWfyQy5uNkDyCESB2DZT0xZ5dCdNsHKbGVgVuDsP
 iXjEyMDMhP9jFjanEEF8TkzaI2E92GDixJPh_Qz2xFPqc4CdCkmQPukqDQ0oQFnrybGslU8Sx4FV
 N0mAtgx_d_lEOQld2STF1UgJkHT1b.ywvBqPfsDpxGAmq74Ao72vnpMTmJ0K2tCncY6ofy_9pYKh
 OHCVZfdYZ3yMz45KohvmEl_Dd9lnxWenjU2CzYv2Z4IINiaJV0VoiTp82GOlaL.f8bWYKUCI1mLm
 e4Er2iFe_vicDg6J30mPhnON9wvvdno_d3T8_pnUo4nCfpb1I4NXjMNUSzg--
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic317.consmr.mail.ne1.yahoo.com with HTTP; Tue, 9 Mar 2021 14:50:41 +0000
Received: by smtp414.mail.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 148dd386eb95e3d462559e0022539361;
          Tue, 09 Mar 2021 14:50:38 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH v25 07/25] LSM: Use lsmblob in security_secctx_to_secid
Date:   Tue,  9 Mar 2021 06:42:25 -0800
Message-Id: <20210309144243.12519-8-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210309144243.12519-1-casey@schaufler-ca.com>
References: <20210309144243.12519-1-casey@schaufler-ca.com>
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
index b63a14866464..1a1fbe0746a0 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -196,6 +196,27 @@ static inline bool lsmblob_equal(struct lsmblob *bloba, struct lsmblob *blobb)
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
@@ -524,7 +545,8 @@ int security_setprocattr(const char *lsm, const char *name, void *value,
 int security_netlink_send(struct sock *sk, struct sk_buff *skb);
 int security_ismaclabel(const char *name);
 int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen);
-int security_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid);
+int security_secctx_to_secid(const char *secdata, u32 seclen,
+			     struct lsmblob *blob);
 void security_release_secctx(char *secdata, u32 seclen);
 void security_inode_invalidate_secctx(struct inode *inode);
 int security_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen);
@@ -1364,7 +1386,7 @@ static inline int security_secid_to_secctx(u32 secid, char **secdata, u32 *secle
 
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
index ccb491642811..df9448af23dd 100644
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
index aa81f2d629af..4fcffbf1ff8d 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2140,10 +2140,22 @@ int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
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
 
@@ -2294,10 +2306,26 @@ int security_socket_getpeersec_stream(struct socket *sock, char __user *optval,
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
2.29.2

