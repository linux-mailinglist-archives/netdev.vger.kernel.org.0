Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E972F2A7416
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 01:55:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387893AbgKEAz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 19:55:29 -0500
Received: from sonic301-36.consmr.mail.ne1.yahoo.com ([66.163.184.205]:39754
        "EHLO sonic301-36.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728717AbgKEAz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 19:55:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1604537725; bh=erYMDd+BdGzaMY+IvBFczstUTN3hSKUThjOkBNjJt+c=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject; b=gNGISfOiWk2fzdoGhFWVLIhmwT+iNm+tJPML+ZZ54DkpBFYrCgeZjzIZUSwcvpC5iHLIL/faHFc+hZiEcqvHFD8GDHt1OINQD+U+YK8s2N3CnoWtpgkDUEsm58xPiqXK37bbT34UEmttvEUwehxV0Di1sLEIN0ncIb6tGJAs7PklELRQZQ8ft/m1BqqCnr8pkVD3VVqCbmErrA2HZLCtLtovWZkCRvX3Lk4ZtLtlI/aIGqjXgPNzVmGv9dLxQG+MCp6dbgMsc+lQMISfJhBcKS1B2v0lykZNWjABfjooia9H5rIyJj2VFxxFF7tuqzCOk/ZabQv4Z9QJGoPIBmDoew==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1604537725; bh=M74AcuWFeus+Mgnv07Qu66TeASjwSlTPMczAoosiv4G=; h=From:To:Subject:Date; b=m0raMlkaGVYTivsXzdvKc62/iNbcieRzhfEXojIjpBL5VwZP1/jK6yB+HLclyIYD51cP9Q4RshH5p5+Be/jEW5xGUHEgs2tGtnmx6foh2ez5pBkEzudXk45uWUPW/Nu+uEr2nImBvHG91lA5qVmHatnQPiyEgtBQrsSoriyfnoP5tvHEq+/PVww6i4QzDZQzvWoPfGPDwZ988Q8M8TQF5Xr/52FdsGS0DvaZ4paO59cIkfcpuJOgYOqb8wQCuHm4OQacw8K9Z7dLoFXlzhWGS3PxWe4o8L1omkjmpizfmmquBw33wR0NvI0WK4uJQWh+A5Fyv+SNTZ1kDzBeKpID1A==
X-YMail-OSG: T2clA8kVM1mqdO5v2Lsx86rbSI1KF9KQLIjjjIx95r41OW.GN5J8VMYc1XV536f
 iIGutFCvqaeyAvMQSC9vMgBi.YcRrxPyb3063I2xwFl7LxhpfXqjUTMSBY6taNXkj9n4o0_hpjyk
 B.YnF_3HWWg3x3e7Kd6v5dFybkTeE5grz0X_thRDZ86k5skRduOvohIe1D57Vl4rYM8Mb5LcuN1H
 EzQyv32Bp3mERkSVtTXC1ED2SGMJIZ5ZEsLoAXOL8iH8atMjRFfk9MsI0NfdWvtXZjI6SIEyUxME
 ph9JpveGeMErjSbF3aA20b8c_DN76UK1tBbuQvLPaOo.4hSdBsxU2HvtJO__oK52vk0LHiSyhSNT
 IVfY944Jb8run_X7HtXdlBrXsY4ewzWfJq4yMw7kARwc8Xd_G_hSnd_Wn7vneFjKCUVzk.kkOuK_
 Pwm1bn_49wUjc8aKMEhxpnCPuCuIaceyOWl.0wEsi9zQI1EiZO8AKMtGibMWLNwakdy6kZyoBalB
 EFM_PE37ztHXAtq_8PFWVY0CDI2Ju3FZT3hSgJWYqCFCa1L6J4AT_yRMoTNp2j3NMuko80U5dCmv
 5Co.sbrqhH5T0gFxWxPCZtsacM5P0Symo4t6qlFoUpCuFpqvKTel49rqFm7SO6xsaxzeGJ0W72J7
 GG4GTYblBLBgKVyDJmI27ryml.tCUf4N_fgzEXsG05JRkygD5cPZqnkBFF5wHyY6II65HZIDDpCq
 IPCZCIVL2TNtYaA46DV344cISeyzValYL9ed2aduy1AKmoe2ZzBtqXOFHOyKdoF33COkVzJ2GWFc
 XJQeVOH8jY2dZYoLsqXuDdfUWiaAuZikyBnXgZleHMGqDCEjZbofd2iZX_jyStgLfG1PgAZS3oDq
 iyvUKWVkn89agzZyqKGFKAjoo5AraE9Y_zI2xD9.3C.MZl6XaeDUHI1jH7Ws7rspxPkoLIqq0S0b
 DNarY0uHXui0ZEAMl2Nn7D.1OZfiW28wMQIZDuLjSYBQRpN2pntkSaXdZvMoNCLYBOyk_gXOGNMb
 UxTJmYX37Hg012_UrAxuF.AzwDM5PR_7EiJ_n05nkSxgnHd0xTxdRozXUu1881Gz3B86S4ZmT7lw
 mDFT.MPnZxAoWE.HIBA0wL9DiFZ63BqZUZmn.QCgQQXd__fQOWYdxjUXWlCzVal4pjOuSt5HqTli
 oKjNYqzS2FILVvieezxq18d9b8ESA8MOIp5zdDZaErxjqwEtqUAMb9o7Pg3GjUW6cL4f5aT_1.ue
 3Ylw6HTy_VZMNtOc3aqfHGbymRKPYCj6yGDFn__.yxZmFUxhQzBjOhYLgSpO.8qzc.kHTQCCpne1
 GSKD_NLU19wZyGPk2CXWdPXiXD_Ng3sf7is8tQ5Kpe0qh2GpJPXsl4tK6j.LKOwBcI_zbpc2OPzg
 8IPSjpnP8Y843E2fX1gbqZvbWfuvmqzA4d7YRQQmozVdBwEavl7iekv9ktSpYB.oyioMEIw_QB2u
 L424P.myMjD7hQZ9nfpxBNZE5bZInp3BGxMXUK51hCFgKQyqYVSwJbnFTFiMMemIwJ1gHGjA7wEW
 x0jzjsfI6iab3oZJhJvFm4ne5ncq_H9HqSh_CdMnMsnlZZFM.R6ekgsT43VczqOzK4oP42M4rGUl
 HGYtVhs1dzpyvZgYEKsBFpbhzkz7wkhYTf7vMSAPv.vA4chZxg9eiKHsx7_fDnSFYu5PfSqBIf8x
 Fht96WkCZgqOnQmCKdU92o3UB2z9Srnjk.GC7LwscB1zrntB6zt.oIjmituKF5gLaNZaHko4cvTA
 HncjpeWzXps3FNwTOs3Y8qvk9Ty2kAhJXA1BEsB0NzDXGxiOGJy6ZlYXdFxH91jaW3cQFdVuKfST
 3vMBqd9NW..aiBNkh6zBPZ8KNWMjYnwqsS3kTyilluOlC_gOnMFTZ6is5qf9pj9wxECxf1GySxki
 vDFAFwRDZ25oyczoOM310F1k7cBtuNHHLHHRE7vUW2k4nOUJ9QVtQEMqkYxjSBIy3SwaaydxGvHT
 lwPXhaOfX4Oxu2uIxxaiMQx47gyOn3Rtj3ny8Hq00SciFWtIY.b3ip5DhhxifAsgXGOb4k138a2K
 1J5ahZLbl4gOHU4zejPSelmJ4w0ed9BXEOYBuMEsSea2e8DS6rsw3r8R32mrYRyoXduoFRvrF6ud
 jwscQPa.w9guRv1XvxUx13Wc4nI43bGY5pC5dbaQQVCTNBoBMEawR4s1NveJjxwy8sokmtfdNu46
 wd9hy0c_m_6iJHZ_oj21wwoF8pUNDIiYLOdYF4qilv691Ojto2IsPDhZk5VSLeuz6fQuXgWIMZ2U
 nhb.N1Pwgs2eZ0KpYEx0Larm9_nCT01WwJV0kAoBaI5ovD6lKSsH.tysYEYESM.nZlKLzafe8UuH
 IPiQQo9ePSYa4lgKx0_DvpO.HCKUBasAqTVDvDTt.uo2sbQ6yRi3o8TzerkYWn1_Yx8owd_iJ8sJ
 OSH7MbixPVg7TNQK5Q_nX8bBuWyrQQzC4WhMsVduZzDzE34UUFgpm8NtHvuIMJMs0A.aRg9XjgAl
 IU3Qkmgtbqp0qt.9V.pDh0kWFikC8m1__z26LFFPKaTr.xvN3AgplHakQ7JkZ5S7HxM_JG0P5xeC
 fbJOWKPjf.UkOKGHLswBAZFHBBEkDAZtqlzTf6pAp6sUHwdbetcQ2zE6mu.T1osJZF8TEA0Wdyk5
 9EEZzmrUeE1LW9WQ3X_Ot3DUc5VgOv7SzMvZZCMgk.07p4ktz8bVgsMhp_JuxcYnjXi2.bKleDXv
 E.WcTF.JMHXwgwxIezknjEev7mNicauJPyqPH13ZsDgVXLpdJrt7c2WxyBWcIq6t0vKh3cSMcXEC
 aSkdg4GPsdgfK5hEDgfTr2uonm.z.rYiT2DRd_YngSCyVyG4jSe0H.tgJ9lJldm6mzUY9Z_W1ex0
 MYRC_x911tkw22gGPOiDFaxI7WunhQIlmiA_fUWiFlfrvbYgPw7zAd1.ShMrDfEOZQsh5QypMRSe
 uVLZhOrdKSC0bjw8LfWaQdBPKVosGxL8f9XWfaEIDJw38LQbDHX6J0sdqfDCaaRDtWEwP.k92avW
 HCXWWXoQ2gCUDA9SKyj6_T5zJM3S4au.jdZnqCO8i4P.oo_h.g9v1qKgO6L0za477l48e1kYEdlo
 n0Q8nb6VmK3saoPimp5g29riInr0D_QJuiRYcAF5tsMnxpXvXd02B0rOiEg9l_abBCT8TYkA7qh9
 nQPPtVCeizRYqSPDLDKQNu1mZ1dAD_5kbKw5DxePXWxvZ4ClETnPpE2CdwwMEpFgqgsrUaOKjz0x
 yGJUg8By.srI53rncnWQWTZkmoqWfS0stmOLsC6ZVjyTWdE0r2S_mRKE0sRQnmkg28jV1A9Tiitr
 c2ou_8u5hHD92uwJC773jFA0WiUY.FjNrx1rRpRYdzMB9
Received: from sonic.gate.mail.ne1.yahoo.com by sonic301.consmr.mail.ne1.yahoo.com with HTTP; Thu, 5 Nov 2020 00:55:25 +0000
Received: by smtp415.mail.bf1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 136375bc1c3fcc41c1f752a5ffaccee4;
          Thu, 05 Nov 2020 00:55:22 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v22 05/23] LSM: Use lsmblob in security_secctx_to_secid
Date:   Wed,  4 Nov 2020 16:49:06 -0800
Message-Id: <20201105004924.11651-6-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201105004924.11651-1-casey@schaufler-ca.com>
References: <20201105004924.11651-1-casey@schaufler-ca.com>
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

