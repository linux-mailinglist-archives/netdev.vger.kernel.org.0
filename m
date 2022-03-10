Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9C14D55D8
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 00:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344915AbiCJXvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 18:51:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344904AbiCJXvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 18:51:02 -0500
Received: from sonic308-16.consmr.mail.ne1.yahoo.com (sonic308-16.consmr.mail.ne1.yahoo.com [66.163.187.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F094E19E71A
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 15:49:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1646956197; bh=dD4riyUphI61MKz1/wBuwyC+7Ex6yvPbDhq41i61veY=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=QThjFjN80mEdYmisy4P7a7sgOfvIPUWTYFiM3ewpoMem2ECAkpap+S5FmmDterBVCU+HvH4RJZNaudZxH41fAcqz+f6I52OlsTDfKNyY/gb5P5rbVXXRcPDOuHhYIHOxSQhRGVc/C7OaBxaFSySagzjZ7GJXI5dFSLm2rhqaNlS+RZzMLime25uZ0saxbnT/CEQdigMWPmJCZzUP98BsQE6SJW1VCzjB4tNXTa0SPQD5NRGLx5EAMS+5NXclhDXm5o/tDkIgckl+G1gDL4SV/IRMhZ5fg4iOtoM9pJAHXu1xIOeyGJNJkrBGD6PfSCZp1NIVsOZis95n+xJlZhqIuA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1646956197; bh=k/MHUkF7nZzr/IX6mQB/CPPVrw+Hx5E7Aafr0bHaNSG=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=PFP+dABbkyNNJjycq56XGJoXPUzZHjGtWzKB3nfR3DB1Ul0hDzz48bswHpWwAcoTaaRswnuzy3AzMTpgJJJLKuKdaJv01hfgXopSpc9vijT6rAbS4N/bPR4JGdean2VMSQb4fr3XzsvEhAKSXKTAYDWwwN1nEv8DxHSeBwpwNN953bLqmImWMe/0BMwrmszIbxjmWa60bxikj2qTDohydvNJW3Rv95IMW/dJGkYuYj4iTJNBmoY2bMzhtM6o9pe/1bsm3NI3piPayxiCyNgtCCTtnuGdj6NLp+yztsB6bqVtwhpESx3gFjItDOz4Th7jIAEV7YusN44GNT2YumDliA==
X-YMail-OSG: aIh5iRUVM1kaa1xGkZfV2uqxqGFltVtPrLvpXymvY7Z0vf_EUGtRwGYiNanfAvR
 dblG2RK1OPl4dQ9VAbkGM3P0F3KwV957jB8PQgDg5ZjU3SNU2CD_8jKp7dVkXU6EaQfRdTSgsIW.
 Jul6.OY0Mhh58wSxLDhozBt0Ktu8jMOeTayrp_gtoYwvr4F5F77dVSW16oQBJk9GymkgPWvef0RA
 3HaZrk3ubMGGrEmgUTroPFt93KULsr2jkWVEXfGKv1qYlzLOYKBTt0J8Qm7gx3WpSvYhcB218cuK
 FixnHb.p2eMSpW0z4H_LtJIc64ftkTRTUoa9ZCBWO8bs8lsZvV1Eaqmpi1UbnL7p4SajxFI5hyGq
 DRXoVwJ9l2tMNSATSgUBx9Df6p.usQdYANo4fXOFBrRwfxNziDJ0e9fSyZXenSKaRSwfUhFg2FUa
 th521cWUcf8Yb9UFFFzKYdg.s0O9fq2J9PaiqVJXpVi1T0_txvUIFseRtCVTz13W35417DxvmDmn
 ghY1yEH_bq_bRNDDzDJb74RGi8yIVwaF7IeLFBW4LCgpLa6P8gH.C29CBTSW2OlCAz3oiQubEsd5
 KRRyxruW9RQ3g3La3ypgRMPx.m7_C_gZtpaoXHYZoHkTA6p3OVqovlWwErknP4Vd8TTV5veUFNy.
 IK4V7ouDdihDNC.1Udfu35feBAtwqWdJqv7V.33iT1idVE2blKHJlC80Vzd.1Q73z.l2C69djQdr
 lkcJed5cMWDGc2U5Day9PcaL5qfpGUWx6d_NxOW.bp1QnFAphd7dfr.g.Z00ZEG6wj.ZZbb.AAI4
 m_VUYp0M.GwOYP78pwd3W89lcH81hdIWryKw5Od3irbugdeXqBJsvR70zBMD1BSXbx4ytAl03UAh
 VZhYgQlzvKzCwAnj3hz.go96bYuN8eSz3xnkBM962epjHkMq.jkWejv92kGV1RkbsZU9D4ydLuYn
 jRdlyt7KbMHQMZR509WN1a4dtY8FKc643Hnnk3.pCVwe04hcSlX_8RsIJrrF5WCKX7Fva9oLo3p1
 bbzsy675vxV0BdSdcgbtQBat15QdHo_B5sBKhZzuU7NWiVIel4uLTIHSvdhokwTY7V6Qpw_gXBYp
 sCKurycQ0ZGOcYfBMHwxkF15yu6TYoqf5izJFz_a6t45fI.2qaArF5VfASGHmFMfwBiqMIkMj3BS
 kUr8jBAeDQZV.sGVAju82BZS_Lf04vAZVBMTvKy_XfF2S9GanIUZABOywwINGSa2cjN7xI3t_urw
 gxFjdlpY9VNBHujEeSOM62.wUezGosIQWtBr4N.K0D1MemXbyjOcmkrAELwQIE33aU_ujOw.fP2i
 6pb9.WDfPSA_iG9dsCPw8vVHhPLHpXwRPomXfVOC1XGnWdmUlQrfYSjbZodD4xnZK5k80ymf4g1e
 rkH2GCjgnXRcUEVP3q_6suj9pCN1CqV84tHhtVCGEmalwaBBR3WArZwOgezWAskYe0_23LnrEZvw
 VCdbSL0vZBTdzRJ7b.pqWEnrm9mHF9i1yGMehlJIVwlUi16mwVh25S10IJKZRlqM1VEaJilqRnjq
 U1P2ZZIx1ER.DU9mLGcd5JZK8t2bTi.tLj2Jdo.EOM7xrmbOwrHAU4CXH5LYJFz2cF2.RgrIbXOX
 EbZt1qWupTQFsqSzcAfhnlToMSWKiws1u.0TlyNYAZMGEM.0OyuzLycqa7BKsU5M4kuNeJsTH7XX
 xjNe2nRPxAcIOw2du4qcSOT_1tGoSG_l6OvVU7SM6ZtDw9RCvjxXd94YMiAUsv6lJfFWJN0JGvhw
 IBZsiLKeN1..phVqXLfb5ZnE7YrdNUdLiBOONKrp4Q7wSLcFWbLFrqDvmKtssiwB9MoZamKW1L8K
 1HSZ6rtMcIfiK4NhEjWwfYvsNtk4BZMPaozDNTiN_aGkIrhSewRnCKYa146C4.yjtrxowxryOntw
 s1wMgXShmjH3_RHMsU04dCgoE0NtqzyuNQUYmBgt8LMNur9wrRUb9IZDy2Hl1S.a9j35VRQqcqj7
 UfkohlHEU4HDWzJhtstdJuXmpYAcPjtB0OuYFa_mNj9_OaHNmVpo.QaI61KgHXJIMBxBk8k8Z7io
 oBT_JVyLnqBrUeRVMZDYeNWbO6GadL0xLZQFDFr42N9Kyyr5y3Ve2UMM5WsCYr5d_rUZzfBzsezH
 1svj2eaKZceD5vOb3_wCZ9H4Uf3sx5w885FvPD3mgqYliVBjSTINCXtc_Sn4mYI9XI0SRfHTmURS
 in7ZL1EWrf3mUfVZ7nYlxXovSznYoD4PuU_EqsHhr6SeKH2P1hnhU2BMuPc1U_LiQHRp54iSjj7G
 4UQ--
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.ne1.yahoo.com with HTTP; Thu, 10 Mar 2022 23:49:57 +0000
Received: by kubenode513.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 50d9cd6aba58fa399bba8dff0c177f96;
          Thu, 10 Mar 2022 23:49:53 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        stephen.smalley.work@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH v33 08/29] LSM: Use lsmblob in security_secctx_to_secid
Date:   Thu, 10 Mar 2022 15:46:11 -0800
Message-Id: <20220310234632.16194-9-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220310234632.16194-1-casey@schaufler-ca.com>
References: <20220310234632.16194-1-casey@schaufler-ca.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index 4ce8dbeb3dad..231b76d5567e 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -199,6 +199,27 @@ static inline bool lsmblob_equal(const struct lsmblob *bloba,
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
@@ -529,7 +550,8 @@ int security_setprocattr(const char *lsm, const char *name, void *value,
 int security_netlink_send(struct sock *sk, struct sk_buff *skb);
 int security_ismaclabel(const char *name);
 int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen);
-int security_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid);
+int security_secctx_to_secid(const char *secdata, u32 seclen,
+			     struct lsmblob *blob);
 void security_release_secctx(char *secdata, u32 seclen);
 void security_inode_invalidate_secctx(struct inode *inode);
 int security_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen);
@@ -1384,7 +1406,7 @@ static inline int security_secid_to_secctx(u32 secid, char **secdata, u32 *secle
 
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

