Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0DD33D1AFB
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 02:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbhGVAPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 20:15:20 -0400
Received: from sonic314-27.consmr.mail.ne1.yahoo.com ([66.163.189.153]:33887
        "EHLO sonic314-27.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229962AbhGVAPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 20:15:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1626915354; bh=B0E2mJi50VrupNDUfbc6O7BsZvL9dT3zvHnoCNS9qz8=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=Hha/LrVo5WrtANYQiSZs7NsNjkZ3rfXgz0OQFzsi5PWYXLd8Ex53dnmzW6gmKLIzqu353ibLz68a4SJCyD4xnMZq6leG0vxR+yffxLk7zy+WHkc2dzhQZhoJpc0xl51NBQaTFhyx/dFMr3L2Yt/VnriHDEbzrZh8Hf3lGCwMFY2m/rV6Sm6vm6I2uG2WWCoIkOiW3nSQ6ny6G9DZnR9GzyBdHvqWwhUN4lHKQYDmfD1CBsJFyfbdskjPAOy552N6CyaxHGUrGui0yK4a3kdTvgavk3kFXo4jMc/lVVK5NV6ReVm90kxtqIl3EtLqWXxZaveIFcU3w4pesbhBu1RHFw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1626915354; bh=Lr8GxeVHv9fT+/A/P/OuUDvVRuowfjIYU6akGrFlPng=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=FjGECPLqlgy4lG0T+cCtxPExRU3EeyFLo9Q5AKLVFTLbBZ16G2LklwNDm6ItDJ0HJP2krr328yNDSmRArL+1L1yPxDZ9CVs2Q2p3mLNDcgmhBw3CDlHJ2kZbcYtckTeOtd75aoYCHfCX5PdN13Zk1qe/nsmM4I/I5oFkOLS+kVnV0O7bh6tPSIAVQsE9XMqYkbrDnuwgL13fgioVn22gfSXlJ2RMdxL/sXxdbhmshYKx3vI5+NBscbUxP9HOp6Pek0jdnjqPLjIdbmMFV3k0DHpsMYcSk+hz7hOGi0wGtAB1jmzE0ZRn83LovKTXL6vkl1uKoUnRV7ifA0mL+7vhQg==
X-YMail-OSG: bXQnCT0VM1m41SDQ_psBSVOGibKMrEwP4whtOCxoZ_reQtMTN2KBTeOgH.ZVaRk
 hBDtu.ON1eyF8O2juOoTYQ8LhGU5I2fn8cbaY.2xHVZLASL22mja6N5mYffsN.PuaUpe8TfMQS0_
 Ind6OAp69rvR_t.LGk2ZGN235XC5DJ7bDyNvy8Mg7fIaKbsAdcG57p.GMg9unOqQpF70NHNro_Nx
 jwMd61Z.ecVVshZSjXmvCbcC_xh5NznnhF.N8Z6TXTbkCcLmZeeBdEXyrbALYD_q9x0hj5JnbuKv
 Krrvzzk3VmwhQfi0bkNNlqYMYhs8yuKhDvwvDBlqUOAVigJsRoiWvoN.EEzKIP3qWd6yVYrs1bML
 plJ8RrCdEOfcOYBSKC_g.kuY4iIJsskAs6ewpXnDxBuoMEfCc70Pb6EFnFO0VDTK13hX8tHmnlrQ
 u05s.JCK096PRr8R.b5y7nB5e.NJwdzLlFuO9Xw__DlZlcMFaUvNeFdGVnFOksYeyKd2N2dnHqSK
 6GOgHVe1ESwLKTXBRboVFQ16Co9kkZGFJZbD1uhxc7dBe9ifN9lfCJSLYkIfBO9TRmoJoeJnYTpS
 1FP_OemwbeHiLXMcdFIybs2DUZ6h8DJpPSiDEFRPrFEYcTTTiD0.nKONawb8b4tS96SGdKFCt5K5
 EF5F_uX6YDljDv0GS6LBY60BGseakKHVdrp5pGepDLzg9aM9p0eHE3RFuMMJOkG8g173yz8pc0no
 ilksz9QRxl6MPjE78c5I4fbTCWURrA28857ZlX3ydt7o6lM6zxF8rWgrzJw5B06TwPNoH9sXyB.Z
 04ZqKPR1j_JR.GOPo1eDvFesX6Wm1tXTZ05GRyRO89qZ8IVcsbeOzB3iiCw8PfAo.be66W8vxiIv
 5.DOIeD9e2YJ_Ud1KXPvMdBQIOYl3hwleEdAg3kuWwVhLIQeJLcFSxRQai1l0CZAEeWjdCsdy8oM
 FoyFZT6hi3Bo0rPyoeKK8kYWE.N42jccn7isIuCF524JPim6xHM8mC.AlyiDld3d87NN4J.rtvbl
 COZlQEyRXc79YQOx2OwbxNj3P.Z550A7AezOvvOz5LeKRlpR_tLQ0ocyti0a1nkksEEMq6eNVbPT
 sptuSexzmCoOvS.FLg7CGuRS2kh54FqIqy2DZKPlBMOuVzFNChuoyJStkuh98GFX_5vaC3CiTU4G
 u26I2cf_Qdr1OcEHviGRa4PcSKuAtss8xASYb984Kftn5D839jHCK9Rwkq1B1tiNmsO61drLOMj1
 pftK23GJ0.hkJ3_Oa19DQ7O.J1cAo9hkGIar3HXLzsfXhkxAgeGwf2H23z7O06wNpVYXU7kG3JB5
 Uv_kpqbnVytdcW2dKPFZsmA8H9El1ySjB.jq9HCO1I5LyTNxsBzMpEJ71eWBdiBuo0VH0xUCI_1l
 k.oDQC_Obp1KKMxplVmanrZtvMASY.bHQU0icPs0a7OLaIqlRfVtTKH655xS5wk3hQSK4VunGyYN
 SmdPoX7v09ba1rDV6x3m0.L5EGdeVeiOMlEnjvaX8ngrMdF9bClvZNX6AKIL6kST0YGUGQzryBg_
 a_F1xIcM2.HOjkSsG09Sudid3Z7dfqBY6GFy9HBx.u2wQW1fXEN6eD84QfHtuelBWry9nUBm.oUX
 SCAQbuJSM5QB3C.UeQ.yUAZJK9JjuDiQa5MsCVltRRsWr2BJveSC3hT4KvHyynw.LA1T8Mh0Khwe
 JGHdaiWH.lHIFOhKu5UZZsABA.MPH27BYCvYw5ZXXX8ho._h7_dcy26nbwAjsP1ro.4oEtufh8DB
 23R.ucIrpB4HLcw4OXPTtCNxitNXylQyxpaNqOiowpwgvKvWgqDd5CwUQHmhNAwpmFr1gWcPRg9i
 aon8FxYPO.GGU2DuZQ_NC8Fcj2BpqxJeYZYFgS_kXb3ShOYevtpFa1YIdxV4v655QaIhSMpIKwhd
 5ufgI0ceFsqlIoUZtO2IWIu6oiF1F7YpBSe9TIIdxTsSsUNLfwF.VAVdqPdm8hepteUPg7kqirba
 IKEbxdGfKNshAzYalKiM710VDBfy.MHOH3C5LvkybWGWJB.n6fmh5VwcMZpwxyWvsXZ_7Yx1i1z9
 iJwgfLBxn8XfeimpZBDgHOdFWVuMAgJ0YKBMCFOY5RiO6104dMbV._OnDZKTx3q431s2qIdFLOg.
 OJECLoEqfgeVBg8fnqpOP8f7QQl_1hwYrFNIkktRme.6bZskU_l7adR7HzlneOuh48CZGb3QaAnw
 h3eVNJGf6oS2TSI6ir4kaxqKaAIBfYm0grYUogPzjPqontKZ0QhotJxuq67WzjwoZUZfetHRZ.M1
 wbUL.Qim4YjfgduRvZcjEhig91_227WlAxGI_5GUzUihm5BOgD0t7W_28BA4nol4lEE4YPulbAly
 hDynO5OUhK8zwag.4et4az9WSucMjczCHt9YdyFunPfkVlUUeVPWSq8BO8m0lOLFl_mdJctx9MUQ
 D1qAD_XIc0ruIVutnilWxFKAUlv6ddSCuKXCSt3fLp6ASBDZfQatKKCB2t51eVAZSil6qfhdzC54
 GPb6hJmOTqIZlnmA_nSRbAG5OcqE_DarnpxubINif5fHrDI11C6RoT0tGTfp1x0vxaO4FcnFcyiV
 M8K_AmXMeC1RpnV4vanLQ1bSgILT7ZkC13WyqUQjoiMh6rSb.jLVvoLhc_wtRLsKX60dD6LgDnig
 A0O8g5nXl1Xynw7hjIceVXZ5XekhHz3s2SPrDHX0mZRYm4DwvnO3nQoT2vFLZ2mex503boWyV541
 o4ycEoDhJvOoF0etvXfmit8a27BQhU.nriXcYwWp2gs2ELOHItNWQevOLbr8Wo0x4wNUFUkSrqTH
 LPPO98f73cPo7RI9HklHVdWZYv1h5sndVPR3uDHvU758VmnAsRMangMLNj.8_NamJBXHcQG7hyJF
 2wx5n6RGRfgENfC5.g34N1VoyvKAzuSMDlzbGN8l34PIeCv2WKvwUOSQ1iBM9gcw9z.YAHU3HGT.
 CN9lmTuTn66s9f8OUTuSkkW916kv4tcUhxrh.rm7RtLyBqXBhu0jkawJxRVmRCeIX7QyY9Rs_p9y
 hfTjDQ_9Vlqy5lZ.DQ5BvVbP6C3xMA3r9E86VKARdJOW4U_EEkYPReR5.qJTEMDzsBj3apBl2zZo
 8YafSh_4dnJr1nvdYkTDIxMG8q6O0QleR8FNUs28FMCqiSpHibWyupRrVRi3HMcjTsTLk7ICJk8P
 4A3R2Z5KD9tF5yMModqm.EcQ2xHemfe4CBHuXAlIxvJXrfd2FSf7Ym9NWC28dx8rnpFEfTA--
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic314.consmr.mail.ne1.yahoo.com with HTTP; Thu, 22 Jul 2021 00:55:54 +0000
Received: by kubenode505.mail-prod1.omega.bf1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 7f76660ca894cc8d842d2e9b1dc58c45;
          Thu, 22 Jul 2021 00:55:49 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH v28 07/25] LSM: Use lsmblob in security_secctx_to_secid
Date:   Wed, 21 Jul 2021 17:47:40 -0700
Message-Id: <20210722004758.12371-8-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210722004758.12371-1-casey@schaufler-ca.com>
References: <20210722004758.12371-1-casey@schaufler-ca.com>
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
index 332df8a1cd4d..986a8f4bcd54 100644
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
index ea36ec6e1ad8..38b00a1390f4 100644
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
index 2483df0bbd7c..c29a8d7a7070 100644
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
index 69474918be8b..1621a28bf9c4 100644
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
2.31.1

