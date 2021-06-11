Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFE433A3857
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 02:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbhFKAOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 20:14:32 -0400
Received: from sonic312-31.consmr.mail.ne1.yahoo.com ([66.163.191.212]:33625
        "EHLO sonic312-31.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230470AbhFKAOa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 20:14:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1623370353; bh=TK5gm+lMVKaYDHWLfXCtvkpbJfCY2THcZog91SRiGdg=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=QT3xZffauioehlMjZ0VJgPx9znESnpIcK1TKrNzXWKqnz6ItNib1uVgKddwVCdZjI8qrcoBQVK/7FUATgYN1AAuBNPT83zZgo+S22/N29vsuzslA+9VM8jCDuLqAj4nJO2JJ4bJFZ7Sdsrtb9Qe97Wm4DARCMKdJsCwx2ntIUvFF+BQZ996jc1rCLz0FUEGsBerB5h5MuxaTt4DoIKAJLAm66RJsw0juLiacExa+d+c7SDBhqxVLc49B4pvmxxVxXkF4zpcS1uJ/pS9MCnm9ZDywjGi/NXX/75It/hXhpdFG7i1xsaKb6B1SC/bwnFhXgQs5YuzTDKB1cHuTL0PDrA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1623370353; bh=ul8OfPCs8gc2XvLhKyoTevw8I6l+9/Q7mVxJGNvZAGQ=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=TEeczlaVr9yZzJRZzz2hk4XDohEQ9Qvit1q5/vrzTKqegQ8De7p2ttGq8HIGn2bqPnsHtv/n4YCUfMhULFco9hNECdgSJZl8bilh74oSaLbCDnHBX4evFzLVsjMJUHMf36z40qgGIskkOTO2bVQUx06TSKHZvR4sHAAoHLPI+X5iP1Bcyjh/MqzVTubeIeGCRXyKtMv7Ek8/+i4paRGxZS9ew7jllfZgMpMaRv+ZBhot3Z6Hpv8KbP6SsASUF+3LTRAbYDqjznDT0GweckrGbWalMMC0n6KTWTyfiVFt+iC9Gge9e2Jkknwe7x8HkY75Cp5cuOlKTYgooOkOaRngmA==
X-YMail-OSG: qgayksUVM1l39_XrPohduIczOvt_0LmTXK2LOIxufRs8w0GZZB5RPaL3iOuHrnp
 dL18ImoWkfHdyT.enjm839ZIs4aZejjPXrb.nH.gW.o_7SGHgStmFx3o1Iws3exLPwWK8CwSRcDp
 SqvII1pHOm4xIUVdWWu8e8Av_GhFTHEfikTQmCmxocol35nwJhz18O.W.1C7Pz6mu.0s3BJ5wjKa
 6V62WhdMPjPP5BEIjndMB1LTZrk86hUPsIaTiemB.87esiLbKREOaZTavEZq408fnRHxWnwWii2p
 nmFy1Umulyi6KaMp03W_4LGDgI4yTybW8ifdASD.FojFg5y5F3GaS0GALj6pGFqGdxMYgM1OkukI
 HhTixDdwvLDi.S.unzRHxvNqw1P7lAYU8zZjsMXnUsWKAAE1UhSJ8whuwvyygCI7eCaPfZfiS87E
 sysBNvnnlEKrWoQpnqvxkyuBgNqv9yEqR9ZUZgiKadTyejdZI161b7OA31ANqdvF1ImSiPKxZer8
 ps5IKqMirbvGcxMVXjGomFb03XipdQGnkGHXac0uURZvVAxLEIy3BNiCt7wDtoydJ5qEnOzuxjcg
 oiCAZG81JsQiVk19iAdffJgRjHfDJ4_57RlCuiH_ombcTKNAlHMs0JVo_DFwMnWhcNvyIDF3sjZq
 oATabOtbkwUX8fh9UX088FbJs3gHJJo4tsXPhnwCnN3H9.Ctwm8MoYzPgfR2pz.OQZHsET9IAQ5S
 1B3UHcAqOwCvoDrzx.Gq37Sazn4cV9JjfBjv.XXIyUR19q6hfDjclE9YY4zuEKbnTN0S6hBT5yQy
 5LN1NFFLI3gKKhT3W87oENvQ3UBUDS2CTfABzzbNSazxZZddLCYbcKfb6TIOwvM9Gggvz6p5yFSL
 UEZp0yZ6U0rAexOm8_KFmgRatQ6o_2O_iTklKBl5AyEt9EnN7GaPqLZyORxGrwd0AzR492CesiHG
 zpj.3hlEoDqe685bgbPK_gKjDqlyIkOq6gu3iLk_SlR_XNH9yg5vLxXdFcMwK4Ua4rjAu.GKopNb
 EcXz7bIAIzbksAH6TpcfpnkE4D9uT4HMrAlBLcao.LXGxwJ7lbNUFdbLq31lV_HRoQedoapnDj2V
 U_Sv6527I.HhHyzJInNPDINI_bS4ULxrj80qP9cwgRzp62i_RA7gTe6Ew1HWEBw5MEMsT7Uehh6i
 ri52vE_4XOkw5ra84fAGKFnBplEbXKjlmME9lEvNWTbUT3xxd1J2FCNe8USOCn9vtndSIHaOrPNw
 zm8CR7emBA2cHJkZ3SRkHl_eqABV2W1QanaWYTQt7eqJfpYlxmEd9hQYLj7H7GUxeOMdcilZpUYC
 ygPfCla2se4kZh6jC5nLV0h_t5Wnd_hbTMsb7cxFvsILlSHH1jD.2g0lx70qIE5alCbVIwMHnwW_
 Ubze9ktACRkqHN6_CWimTjOlJKBMV3HKMuQAOQ0m25jIFnGivYDqwJRwt.Fr1LwKQmLYOFm7IYhV
 uoNLxJz5qLMtYbZ7mEw2l21GHLQTxLC5lqEhu0kzFoyo9P7cVpDFj34X0ovQzLbL6EwWfpx7hOE_
 nScWjsdn.EKj4hFHOVQDk.BsKOs01mQqZYHj8LFzxu1xPxLLqJ3JVfG__3Yn4tRFBzDRZkGYh1dR
 q7jHS4nitW0iJr4BqCd9HfiymLrmrYeaphdjWBAdETfTT0PiVsM1Rf.FziOXcvTRlPCLsslsybWI
 O52h6dejvlBLCtm0ToytiDXvQfq1Bo7pErTIJJmhEYnZWjmDgLJV3ZITMXpV7S3vZhjrqOBkNyww
 isoLQE7NFr.GJ2HuKsVN9Xe2HTqvmNRWi4YJt0xatdh5Rx7dQkaKZBB4mr.K2nGAXjfv2Wn0tG5k
 9tSPQzSWvKzK4luiNkGPAUM4lZe631ujdsjy.63dMPLMabWqVdO6eC0MMNI3CqmBfzu7FFDdv9n.
 U9a35YzhtnN72XJKiLfhgLACSNRmFzUnxzF0NfXtv493zFje2Qna4YaX9OUzTzSJ1KeoFB2Wmjzj
 7AYDdPGxKxqEGGWAcDIwHhQnl0ZVqVZFdQ.Tl2ul.N.i5FhqriyQ2vzVftXF4DgVlqSocjmw4bOe
 wpGTmh7Yd_MYlsoL3MBcWhKyaMCIovjeQ.iXt5qgfNTNXivrb4nOGBAeNx2qWx_rFNE8.6mHAYi9
 rHJWAvNXn.zJOkqlF.AzcttIvae7eID1yy1cfxa5TgKUJ2fdoD5H.50ROuuTaWZoDlBIiecpZmjf
 KUICY3gL9CrSt2ZnZ06qlYuly57JsmnBXOiV1ZIX1ubHSQlAnr.ctBBaHQT.PDBsYH3s.s_fZfRw
 dD75Ox2WK.kyXq2kK6DhS0ykMrnS38YQGNgUcLJ7Bh4ntqh3u.9NnGwCXd3MFBvzbRGOwE3x6pOP
 AWEAw.aTfZQp6A.fvuNjnDlNOLX8NjT3oaE8W1UpeWCoVrpVbmly_AerBRhvjt6aztXzqg_0Bwln
 gW8yEqRGFJYEg4TggamqCUXnsqFlmRy7rtmHPphip4Zasp3s9HnmcKmp8dbora6sdqXjuOHhfjwG
 7rzD7Cd4sGlRDcMCZEictvKF5Uzs0gNc1PCF_eapiTvvzsuF17RmWhjsilB_ZP0FZ_NkOLMWMN_8
 1j77.H0i5OtvzP_guI9stW2Cw4oweh2TFSeIykz5qyTF9LZ9GN2okqJcR13AqcollRnWhtLavY0d
 B4ONyvt9nb49hH1BIRO8cZ5XA2IDczRQ6KUaTmjCGT9EDQHbU8DUCVbkuEOwVGitVDJxsaU2xUcG
 PLObo33R6HxYWaN5X8LLZJn44Figf7PwVYofKVMjMpcRatZmkz9r5LOUdkREyhTvAvYQEr5jq.i6
 HUkOk0_L_p4SFeyVJgZZWfQKCVbdbRURyEsQaaO5FMf7I1f6k8qE_W33Aaxk0cquLxwX.vwE_sLy
 N0JPCt3BOwfOmHsGYPmaC35pwlY_Nnw2Licb5YSZyAHHvSD6bwkFmUU_ZoQI4Qf_mGOreDOB.6KY
 uVo.bMy0qarw2KBSsGvuCQkKvIGYAktGnpuOIfsJ0fAn6bVo9agOWRKpo10.tcDIOYWCnY_fUuqw
 scBCjpp6u8M2h8sZZhoNguAElKVv7hrpGOcqeVu6Jx1prtkLaa7neoToh.ROnTvNPSHMMGzLrvvK
 k_p4eNX0h4uMmp8yRSUzAXGVlEe__HK_Jr9IVYq9Lp9ocH033GUjNVZIrqQqyVrXyQHwY_NWzz0O
 EdOSJ1dTZXwHhslWbq.zUM_Yh4RJFKObjmubNloBkYD7DSE0Wyp5Ma5kWmrDmoId4KJM_dOWm
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic312.consmr.mail.ne1.yahoo.com with HTTP; Fri, 11 Jun 2021 00:12:33 +0000
Received: by kubenode517.mail-prod1.omega.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 7247a68cf5c5940710f416ee26210309;
          Fri, 11 Jun 2021 00:12:30 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH v27 07/25] LSM: Use lsmblob in security_secctx_to_secid
Date:   Thu, 10 Jun 2021 17:04:17 -0700
Message-Id: <20210611000435.36398-8-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210611000435.36398-1-casey@schaufler-ca.com>
References: <20210611000435.36398-1-casey@schaufler-ca.com>
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
index 5c664ba0fbc3..dbb1e5f5b591 100644
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
@@ -527,7 +548,8 @@ int security_setprocattr(const char *lsm, const char *name, void *value,
 int security_netlink_send(struct sock *sk, struct sk_buff *skb);
 int security_ismaclabel(const char *name);
 int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen);
-int security_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid);
+int security_secctx_to_secid(const char *secdata, u32 seclen,
+			     struct lsmblob *blob);
 void security_release_secctx(char *secdata, u32 seclen);
 void security_inode_invalidate_secctx(struct inode *inode);
 int security_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen);
@@ -1382,7 +1404,7 @@ static inline int security_secid_to_secctx(u32 secid, char **secdata, u32 *secle
 
 static inline int security_secctx_to_secid(const char *secdata,
 					   u32 seclen,
-					   u32 *secid)
+					   struct lsmblob *blob)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/kernel/cred.c b/kernel/cred.c
index ad845c99e2d1..b8e15dd371de 100644
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
index 3e6ac9b790b1..dd18b259272f 100644
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
index 5ec929f97963..578c3c6604f0 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2193,10 +2193,22 @@ int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
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
 
@@ -2347,10 +2359,26 @@ int security_socket_getpeersec_stream(struct socket *sock, char __user *optval,
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

