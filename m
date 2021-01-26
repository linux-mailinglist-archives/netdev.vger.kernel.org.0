Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 129A6305997
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 12:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S313325AbhAZW5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 17:57:05 -0500
Received: from sonic302-27.consmr.mail.ne1.yahoo.com ([66.163.186.153]:45343
        "EHLO sonic302-27.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731421AbhAZRAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 12:00:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1611680361; bh=Lzjaij8NdsHuYdkpeUzszfcOi0xA6IMY+POeXrHp2Uc=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=FIP+wBo3Qld2lq3ByEiDJ0eioTm+HK8Cp/MDJTZjrD+T38RCO0T9hLslEZh/yFmLUe9XhSAVkOi1ZJPghleUOWQ7OyLtxJL8kuCLbTBMteZdqAAmSHacoG7ThEcJtn6Eo0zWkhmgEV87FdBLcW4xfwWSb3m4b+gGY0BMJ3+V4TAa7GsJrTS8Ve1klipgmejmMXg7vV3u/CA/Up9tF0D3Eaikuz7+08cDmL9srn+z8R2I3du706AL3ME7oG3miet9RnLFh56XxUI7JBkrxV3/F7XyUsNQEJyJmJ+FkgBnOLf6VBwdEfekorXWDADjKTQneHl1vAlxeJyHq4UlvTVw1A==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1611680361; bh=+QusOqr/5P/x1/1Gtn/bcgpceHesDZjtUyXPdN2sM2R=; h=From:To:Subject:Date:From:Subject:Reply-To; b=MJRMaQZ3xAbH1BPzzg04slvl/Ki6c+IJGAzybT8RFL5LT80IP5aOZ8EjUJSy9CLXdyCxd9hZOQnan77hkQfxmG0Uk23xjVaIhIbDv9jlXT+6BUJkvfjTQYAaRYJM3oguMcQ4Xy6TNSvjNQMvGnM6AbELfXmPNNgyw3CFu3M4lkfyzL8m88xtyTBBgd271GzWO/t6EdP0RbQpTbXszTWWi06ZkZgEvn027mrfEQpS/ongTEgKSbwoDsmsCNskTQn1BwQiTuIDe02Jn43992vqe96OJ59nkhTPShJR2ZheyTr7joslM3Vd3ZfQOhkj9u7vH8ytGZeHwgVvuKWFS3B5eg==
X-YMail-OSG: fo4cTyEVM1nQ.Qsg_dniimdiFtWEG9fCIirVE9t3NZiSYNX9xLnKyopW91Mhs2Y
 Jh.bho9c7_AgW9OL8uVSFsCcdp8xY.3Ki3fnaLqW1CVx6TGsk_dJ3pH2UAkjhkD4iH8KiLOklIm3
 QRSIp05TI6.av6oOJdLVIWlzGRuIG_Yje0j8PkHz9vMzonzkdmGkYYE8RxX3fuaMktciek8kVeUz
 tOAQJMwIIOEQjxXaxtWWmP9Hz3nVqb.hi44KliEIABXGeu9dwjxTpaDncSsrLwpn4hl.VN3SWTEE
 Ohl0FfU4ARJJ5PP4XxYyp8OhLmqQQ7nCjFzi.XIJZvzOrNgjV94_yW1sVamsTvsIEmRXoX0CJyoI
 NJlTWI_8ng0q1OlE0qRS2pehmnMDXy9Zxw.qu_QeV6lbRNetJA0E.c12xy8J8Bm.eZ6drh_b06GT
 NnwAwRk4oVdLqCvIowDdK7S7f2llqbOwE_0JxfFUxlO9wL4qyjq_OgpSo9GyBJfr7QcG8GrMjPFA
 d5_5J2oyjLIWfGBlqL6pdk_XTOctqOgNqKO0l4PVdUru0ygQzR5iGZVx3H3o0jNtip12QjcsiLIw
 jKHsVmyXWeQxy2FaBF37O4znm.gyohWNybZc17mVEr8SM01m_K.MerzUveq5tpssf5gA_ukzAxzS
 6Zf0W9X4dgBC97dDWI2reqsCCCiVmBaXGVe7AXZ6sgOFAJRCBzi1y6W6Y5o5X7P7ucfKO5FPaujV
 feREEPOT.SdNTobFKVI16NY0DPeFR_wV3iwVwzjh2e0yinlBBVCOX0odcLtN_g3y.uBqTKsATZhU
 G0bJBDq.dtxIMnCvJmPbH6ktkPUtEWoHSieB3crcbqHg8tY55OvRX57qf3XeE3Cy14uRjPtqQZ23
 DzvvNiKKyEzKsH1yxY.NEZ74Cc5j6hCv.56lBmpkKKTIKZjV1.U_Xk43SCkkJdINj_PXab8Qr_0W
 zk7XxkBKwpTl3OqeZmExZh58NWQtj4Sbm4mXxELf4EHXwggmcyu4JuiFov.wTAspvJeOs.pJ7qAG
 PocIhXs7Oyvfys.R8SvdF5RNMRUsS3MW7DIz3ydxraJ98o7vm8zRysatLOeT6s2i2TPIFt2KMvR5
 dGE.IpRa_WaPm8y6oPaCG1NUS9338JinIOYyCULpJ3yvciUGRVml0PuNskc6FQ_PA52LCz96M36e
 bsYnY9FD_ikgZvRoohEOlwv1tekkmK9w2Ds9.ax4bKqZDHbCh5SDMWGtoyWl9lQjXb4cb_jdX9l6
 ED2i5SzfkArKPwl71VZQgBYeOqMPqAs3w3f2gCTxGS.Y8a3bJjBhGvCXf.kwaml4Mbzee4W31ChG
 dBTkjLGSbNkShtXgICLCjMhuHCelt16x0qSewzReoLgR7pwbi5jJb4ZIYaMRpqsPOyGXebaSC5b8
 w6Syjelwq9nILFkIYxczLhv3H1yLOPuEP7Fv3JX31dYFefRufa5VLnUZeJmbCoogeX6KUPN2y8xL
 EMMCuffE4U_CpTNAXR5pDHTjq7IMTeySiGOeW.pFjAh.cka1zsCwEDNbqqgaKG.GZVMKwNfmI5jy
 X6K0kQQvDSE871mqE3Dh96KPlc88AkxnOXq.HV1PQo52uErNrfyt0NPHcGxCeZynSGQgyQpWFxla
 sXts0zqMFuRdXxvfqfxLWx6YkOX9AIEfPezbMrJYB5euAF.K938ej_I5bSHzC3QdqWQHeLfdJQ8P
 zAvzCe_eEYPpwwUto1BKti1T.PHOSQoWCtBlhZVd1H.pE2heG2ERxIiKTTqkJHp8R6ZtSHEvhxqz
 HVZpTkt5pLpIYkkcvd_ExgNkFNJv5cyG1Bj0sTtIOwRNcaAbg_RENn.d.VGsMRICaGnUMDPm16yQ
 B98vcr6eJXxs0YWUg80CpGy3VfIt8f7ZPASF_wSyulQcC4YXanzEZ7zWosu4k70QJID90Asq_KKD
 sUmsqW.z0lsHGT7Oetawmwyo0.mGZViTpXmw02DAI7KS_Zrrw5B6KC2u7VjEMy.Zf3QRy_BDxiQy
 hG8gHujRTyexoUmW8PZSBBff9KpvA8ictmtwWrKDDjiWmuh32hU56.5TLcqmwnGU.931uy6X_5h3
 sT8NkuI75d.G6iSRanppYFNEVoZwRRgFHwUmEmTwM3gwoGQffnyMJsQ.Xn9sNII39pxc58XivXO.
 9PjaXP8erSm2B_fbNz9Z5IvY9A_3o4JZnAKfxuqn1j1gIyqVHXdriCpcVMVPR.L6dqqsWJNtQXPV
 yDmxHOFqWsgz56KOv2VBbMixknyMbr._G2Gq_WBD0BZOWuEpj35AcAo5JZgAKrxyyZqK_ci6gkR1
 YraEHuc_5hyk9maZGiImabW_0YvGCknlMz_8yzFtMFd63LVUh0.qwUw1X5sAK69EG6XbfgCRMxDf
 BISJRphxcmWF2HeJvGIrYp2R8SlXRjLNNv8VPqjDTzMEqRUsDGreZqoI95R.QkinRwky__Tx9MX3
 mO4k_lZICx4tM5wasL8br62123eKHbQD5HH7vhhNoZ8wJAzIJqJtIjd7DlDdTteb5PRWBMljiyji
 53Om9c7vrUU5w7ldho4kqLzx6QrIS3EX3BiI6cWlaAIcwbKh4NxuurPN1gYkjp2e744My6OtphUp
 DJDuYQXIG1I_bcCtiOPk.7Qp_edkSiEDkhGJ5rpeSTnMeJ8aky..OR42S3LuWPYSIsKKRSlwqAZ.
 Gh9JWArb4w8JuEtiVVslkc7ClQg.9NX4hBi4D9R0g_z1Q4.TZeajK5xkNtIDRrBFAoR6xuDxrBD_
 2wNEdVkjcpLq3uynjJmc_9vBZ7xNvglhreBYm4TcW9z8h417hEDQaDmCMUH35TcIl80lOaWmgeBQ
 XH8mONWk6HHRe.iJq.jIOfXPTPBAuwihjR2jNyXAWWq5iEA3GcRHyq.nULKrYqaH7t7SpnLX1unq
 PM5us4Mw0EKg8uvVUC.RwnA8706T5vkUuZPRITEDiON153eUK4MT9D5X_ZcIWRn93G.29Fdl_4pp
 _nNPggk_6oQysartdxaEovYKc.2Bq34cij3AlaYguQ7IV.dJhHQO11hs2ascR4dbnY2_1oSKDwJp
 ppuF6UZOqTHp5mss9.C9EwVqBgY3IJ.ERcedT.6pth4MTLwfgrfXwj67iTcq6ol7_vPodU1mBLp4
 .3UQOF9lFWqsj16Tt84WftyfPglX_LdQvMQjkFjYwpveV5k6oDk97vtuWiy0Z_eBvg1R_rPJNful
 qFpfzgimxdVKSFcfXjIJY
Received: from sonic.gate.mail.ne1.yahoo.com by sonic302.consmr.mail.ne1.yahoo.com with HTTP; Tue, 26 Jan 2021 16:59:21 +0000
Received: by smtp409.mail.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID ed6776a7f79f77301f8cce1a4603f7ea;
          Tue, 26 Jan 2021 16:49:00 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH v24 07/25] LSM: Use lsmblob in security_secctx_to_secid
Date:   Tue, 26 Jan 2021 08:40:50 -0800
Message-Id: <20210126164108.1958-8-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210126164108.1958-1-casey@schaufler-ca.com>
References: <20210126164108.1958-1-casey@schaufler-ca.com>
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
index 5d8dbfb1dabb..af1d69b41f1c 100644
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
@@ -513,7 +534,8 @@ int security_setprocattr(const char *lsm, const char *name, void *value,
 int security_netlink_send(struct sock *sk, struct sk_buff *skb);
 int security_ismaclabel(const char *name);
 int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen);
-int security_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid);
+int security_secctx_to_secid(const char *secdata, u32 seclen,
+			     struct lsmblob *blob);
 void security_release_secctx(char *secdata, u32 seclen);
 void security_inode_invalidate_secctx(struct inode *inode);
 int security_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen);
@@ -1340,7 +1362,7 @@ static inline int security_secid_to_secctx(u32 secid, char **secdata, u32 *secle
 
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
index bf4b3ad5314c..58a994db0069 100644
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
index a3e162c4c0d3..1039f8a8ed09 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2127,10 +2127,22 @@ int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
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
 
@@ -2281,10 +2293,26 @@ int security_socket_getpeersec_stream(struct socket *sock, char __user *optval,
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
2.25.4

