Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC15C37FEB8
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 22:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232013AbhEMURS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 16:17:18 -0400
Received: from sonic307-15.consmr.mail.ne1.yahoo.com ([66.163.190.38]:39052
        "EHLO sonic307-15.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232555AbhEMURP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 16:17:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1620936965; bh=6peqJfPdN/dXgL1H3NqXlYMZc3JP5XfQeCnyhfKc7RU=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=dt14UUH11tAWZzHS+TSilH3Q34L0U+5dKQcRst3667SomT/GwGqI4ZWVOM3xXpafx9O4wdAxHtgUclO6Kir5N1yMj0CwjI2SqIgN/Y8ebsO6Q+NeO2F6behOUcmFCyJArK932BhE2VjPCoXAK0XkVq1z6rinAezGfN8QlfEhWU2WynMPvFZRM/XaQMmDo1LcKCJlZgMXZuDwG5gk515nswUg+z7R7Pt1M8C9q9BB4qsYCMKerTGHLg9ggIEgjDxFecOoIYDnNxqApuuMKs5WMLa5LEwjsX72rfev48B1M5FySRS0bSoK7/hq9Hk3TsT5OahZU6espLy+s3s5RP1yaw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1620936965; bh=Gs+ITJ0evIlZvvcfYK7S0hKd0UVk7d8s4XSQRkiQYxW=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=Yrk3hysg8E2B2PcXtwwZDhakLrsjw6SS7R6lRpcAKeKVekEtyebpNtSEY4dyCsWyMb9yXme72QFu7Jfrwrb3IMlzIVXzK4K4IjN7odUI1YbBK7XCtXEIatlaiLNmJ/11kZR/Mr5W8PBZEd5e5GcraLC3Wr10LP9bx28BgLZJVR6VOl+uHW95F/snWuyNHybOkEE1QWaBHUfeZEvj6L8ve/udQPcVJJodt3qXzygzeS3MZCNLbkrXodraO4unhvqE5bW4kpInJvJu4Uvg1jGEphSfmJxvFJvyNb72M0rfePrfmLaCO2gIi7nfxGuKdfz0WgulolaPPrGng0hwXSZ7Sg==
X-YMail-OSG: 9WdD2P8VM1nJW7_H5Da1oJY8f9vHcSKGnco5UypsM3YnwuhqLAkjbcvM.4RYfvU
 FQutqzqRNerSsf4eJPh2rBkSCeOo5lFru.7eZG2UelJfc7g50oJGeYg58ZMBaRtGT1_EXbxfk9d.
 dtcQMUAbpdSqF6kBF7DBizVsdSQcal.YhuyMD0R7BVO4utLD33J4UIwHY6TeOtKJFhCI8PG0c87s
 A.R3YeeB09h0B8ljFy1fP_2zDnm2dvXmwDmW11heWfRjEGhoRPSo_3kJWNCymdfl3pAhpcMz63Io
 9mSxkCMlO3JligkiC6TZXgL6kZlfkRT8YO1Dhepc8Hi1S.mG5XI_ky4UNVKbcKqtPDyTIVqsRFa3
 OMtyaAm488jkgB3hWekGux7USP5QcQVH861kv9u8MDL9a6b9zCgt5LcgofkmQQowDIst0MGK4YOg
 XffQcZRGlNW8w1ft5sHwebSZbbvBt_FbGdoAh_NpjAQzzSWdHIQYGu0W48.3Z6j7hPpzKKzINzbQ
 tXFfg6TXNVnevKXuXRiHItFHiKAt7tJOGkLqm6giQhClMO2bdM5X5.1e0NLnsO4Hrrxk69LmlOoJ
 d5XgFkvEprsK3m3n8DhswP7QGrNO63SrOEDMJZ94BD7aKRXo7_5UoNkvPUOvuOeZs_22tALb5qCW
 DZjmfHJKVEjBKNWUquSe4DuTztWd5UQdOWQsBJ26DIpOlNKlo_T0JR0v7Y.IRCSqancoyhtNufrz
 NUKhq16AAkRy65wCTS.sMEvHIrrKi.ReRINxF6aM9e4faGGwoV0LzVvg_JaSurCJ4DV5oA51RCeN
 wVVnHQt_mrGUETkIn1Yf2u_JkJP8GSPwUfiUB7bPBJTFmeAfdSOVn6K6AXjMALU9_3KOxeOVfVUd
 g.ZdrGHBc9xPD6nRuWDBr6S.RIbEmeCTwge8TJx0vPVpxp4Cp9oRDaHq9xWbmslCxu22rPA6z1Wz
 keb_vHfiw4L3b6KSqhpZ7f5byMbq00C48kAsN2QQwFtYDjZDqB93xhFrNpGuv5izpIvb2qkzciT.
 rwPBFesBMzw2S5qivEpaVChgmaSnATRtMv4MOh7tmlsA9zGW4cZjBYfHEEN_mQf9B58mkOuz6mY9
 Nt5fuAk0CYbClbxVNH7MMV3VYKC8aP78tlPmuX97xjyI4OS1Bbvf1v4fI398ngEIgAr4689vHTKs
 ltDTbIATdu1RFzirBh2pzt4S.h1rWqXO79K5ofhob64oqCZgKVMSanBsSMnZGdB6ckePdBHNrsTW
 rzESDFHmBj.ThL5I42yqJFOGIfoGymexxyimkmetqhcRvmaGy5afU4A.WroOAdit0SZ459f4NYg4
 sVzQugS4tvRwfJ32WgUE2gtKcRdexAle1v.UEPclV3JrxKcqfIqOUsUYYUukGWT5JoRQCPKfmToF
 sMz_R1zCxVwxeuQGqVciPQDLXWbMXH7coH6gOIJrJ_3HEhyyac1L9WGMMSjYSopFd5DsUleuIRoG
 o7KCs3CTTqSpdhAmPOq5NYhm1G4.2gUv492Y.fuyfJeDYei_o7TKmYvIvbpHokPDOp0Rrj0wCePD
 bPosD2okldr5lLTfcrFbhIqSBQk7jq1fOZkp09_S4_4UPx2iTCVTXxHaXVDQNi1sipPZeuTI4xJW
 H_4zVZpXNlUHB8Tpguu7S7ivpp.IpKY48I3hcJB.wL_KZ.E3zYDKMExUeQrEyl8VmcK7THIbdi1X
 e_t0dmWov5A4rRD.xy6Zl0ixWdkPq02D3DzRPplKzvtZkpxibB2R30FI4UipGt3pCTjLTt.PC5H2
 ydC7I0GXLEZRAvoSN2IfUZT4heY22IDWuMVx2ZtuqXqgNWcMqpOQf8gU5HGeEsoMSvObeloY.jho
 FecLAKLoJF2gDj77x1wRY3RCu5j.e2SiXvEN3..mu959w6B_1h_MaK2y1zZSw1n39miYy.NixHjc
 cedOQvjrLzEeAi5NJTvHdthjL4GgZH8LXWQjsPpo8aZcNRmBl4701ktJs_FeaOiSndRJglMp8cZ1
 YysuKgVZ.8Jj2TQ2sYZP5gEioG_RV4_Kw3pF1AtSMMJmJSaHZosE10ojPTIyyZzljlsHaVBx82wV
 UoHJXz.DCP6dejqNwIaikQ4javtXZpuXpU9q8pSK_6.SjYVLtHTlXW.fPIGwRy25H__WLp3FkYhY
 kW3v9ItHaVU9gVQl9ogf5xmv9d6tPAXxKuvmMVoeVqPDb1h8M8Mbz.xQG2bsFuw75Z.yv_7mr3ey
 PvUIiKy9YCDSgwvnyslV3_t4znX3zU4Lv0tNm8BqLZ6EKFTwi6jMOOvYVuAjzGMyMlBVkLxEEi51
 NZK7ewyL3xhwFxHImbLLCXbTL0x7Y6Li8pjL9w0oFP2jlB6i1wxQgvpf7tZhzsX_kO.Pdom2pzCC
 JQfKgIhGdCUDcZncdiBWqM2gVZLJ2QnAJODiXEMWg0T_kmKK8odKq2bXm4DN3yBBXxS6MoyXvnNa
 MFtGoBCZvl3msIRtyU.ZRSG1qN7H7T5_lTAbSYypNMqp5O_3TXuw0QtMs1e66l.8KHAc2beg6dZU
 mzZ7YShoK_p1Hn6rdGPVq9XdeJzk0e1s2CgZDq71IHTlUYLCzIZKXbzItUkvw2kNRKJjVjsrm6MZ
 UALwAVIxIeBVv8AMhA6M8hYW3fW5Qn3Uj1vczNaae5fkC6.ueJUCwAJ4lnjNL3w_uP9D9Fz8Ya23
 TTemYThQNVTMWbKKuCSvh.ruY6W5JDb76if0jOUfXbhCQCAHylYTnqc3TY21eQbOwD3JTq1V3Kc0
 6VjMxdrSK4FFe_WP07wz9UdkZ756I1sM.Jg9UYKVntmpy8y94EGoixLaI4Me7mf_NisDVJDmat5I
 NSlzuXd5otVcn3.5ihiDI2SYOH3vMRrDlr3VURhuGYjtTx0pd2sWblad1apGBSZkw_MhcoyZHILk
 5OUkehQQonHeFl.jooRVPf79ESSj4PjbuJin_ZsWWbSJha4qPTpA_ObNFVKBv4YZ2ubO56WT6h.C
 ClAyYt4bP9u0_3.xCPJ7dUwCuh0xA2LLXWNRZSGYRLA2IsVZyPnvI7Zjh677mhZxdf5A36QXl3rN
 kyr0D._eRLOH4qqmT02KFFAWP9lHy_ws1zRk0B2uoBerwgqKSlrIbJaNJZFJixd_oRevfiZ7Q9vF
 QnBj_nHQ4tnSPPA2edDaXNxTLn.nVSWmulugvH1y6YppovqEBuLVxcG_PDRqpZhrGjM96tP0sZTZ
 hakti_E63WfHOdwuOjhQwtd6M8vDiAWpXQFhXXJbnXhvjHEr.4kqkraAbmdlFiWI._1o4vk41pP.
 05DeC6qThfBCnPeVZw3DaSts.vacVUnIjbp6557loKxDlLMnfJ0_UWQ62PQ--
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic307.consmr.mail.ne1.yahoo.com with HTTP; Thu, 13 May 2021 20:16:05 +0000
Received: by kubenode550.mail-prod1.omega.bf1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 45557b7ca7ac37bcf3f99977e8ab1c0f;
          Thu, 13 May 2021 20:16:01 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH v26 07/25] LSM: Use lsmblob in security_secctx_to_secid
Date:   Thu, 13 May 2021 13:07:49 -0700
Message-Id: <20210513200807.15910-8-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210513200807.15910-1-casey@schaufler-ca.com>
References: <20210513200807.15910-1-casey@schaufler-ca.com>
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
index 6a8233d746d3..cc61dd46f517 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2191,10 +2191,22 @@ int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
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
 
@@ -2345,10 +2357,26 @@ int security_socket_getpeersec_stream(struct socket *sock, char __user *optval,
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

