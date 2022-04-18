Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29DF4505B48
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 17:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244471AbiDRPkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 11:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345471AbiDRPj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 11:39:27 -0400
Received: from sonic311-30.consmr.mail.ne1.yahoo.com (sonic311-30.consmr.mail.ne1.yahoo.com [66.163.188.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF68DBF43
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 08:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1650294195; bh=Gc9y9q3ea2iik19bt9Xi/CkGjNG4yOsYbl4gU0CBB+U=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=E4a8C+9+TeHbNmvqXIxpcFJfWq7v0/M1NIsFWwLuFwA5PA/QBMHP0BYIDcLOJdqd6fZjFJZYJlHmYQXL8KPFCTK43bqWHxsvCX/SiBiRUiAuUHRUjL256aIugAQ5+dBgut4zWO8Tk7vAI/8pqT7BCOMI0URwP2GIm+1RbpM5KpyKuzIFpErSQNqYsTdT/je29DVq9S3ckY3i98NZvzteGpIpHBg440CHN1IhsPMtfVeBdCYRCjLpZyFVCce5xY0UqbgtKYI8k+lBh4uSL/elBCaIotw4HcpI2wZ6jhqY4LtCeVDzZY/iKqeTtVlJdDVykf++vUlGoE+b+HtZ9Fz07A==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1650294195; bh=OOYZDUjDYoi17BsUbFnJv6YALcd5oYgzumE6KYEoyIT=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=kfakZZrKm6x+V6FpJuwE90aBIvjqXDqsLL9I1xu4BT4GrvYEaTYCPw/q7NtYu7vrZ2cHUxSx67fqdeSV5Lc2MWK1yJdVGPcnQKmqmfG+P3Yx0FhtzuQUgJx4EbLQ7uNo6UmgAWdvVkQont4JwNCSDhecDP7Mv89h0F5QslSE/of8McRgknPOILt/F6VxkXqmTgr+dyJPHAmdvXJ0naikJaQUlSeiVKM+40WJglY6RUnD5pULYvHY5Tn8indAglNYVnLM2l/rwL0s/h3iRFCZ903BrNxZ8c6f7HLHqO18/SV0LezPr+Sipgbh57lcKUSJpmLdpC/whMHXMNH/xFtE0w==
X-YMail-OSG: TGWlxgIVM1kOA67Ugs.oOJrv9mwi2.VdHVzrB_Fj3_v.Rsb0bcU6B2_Sylkch8I
 4bZAkV2gUg7J23FdcWQ94CBByMr1tlHzUmsAPghKfFtRWwnLtsIviEWjhErnplSSuZtA5o6N3kD9
 Loqo1cjV_HkB4BA0Rh2z.S2R58wa7AdykJqj_agJQhfVzBCzyL88l4syUbSVZ1v9f_Yy113ThWhU
 Aya.keQYdVOauyWVG_vdEUtX9lyev1_EDTt7o1eJV_gGoIACgV.6xfxO9voxtqMCai7cKjJnnSuk
 xPw9UuOnsvjK7m2V9J4L9I5H4jEFWKdEHT_RXbs38VMuiZ_oUz1LJ1UtAAkFFohzmp._lNPzH359
 4nO4dLvfvfTpo8sxlqIgwlh4uctHu6Bo1VhRU7q58mtDFn93agY5leouBsJfono_h1npWhYNyodD
 B.p.kmrfSMcTbHI4b_CAK7Yj2PCBcdY4bpY8rXrmnRDgtt.Ac94OwsdaA58FyOQRMl3ZtX.FlWIC
 3mY4qF6_wAOnG.DIWPfvwOYoDOYRCyyV4J1ICQ44q8FYpIjL2Vdz3DHnpKbmpHykA.5363.QqpKb
 Jex1uZKdR2vg8ZeWWTAuWmU2KBP1OlSM82i.Fo6XNICnHKK86F65GeE8dBssgplQd9sU7RJgUSbU
 qPreaZEJxfmk6n1XkJmsW2f1CtYU.1hCNGyWc_VZ70OjSf4ZWnYtFdmqAKOhSnpcZo4R708Sid1e
 O87N9LSgacbdi9xrnUg91NoSRe70V7wbQckPzuevJPKMcMIqshfK2aqn9YnXT..CX835JHv8_c.X
 gTHfM5NngTiBLvYPBUnDHgVA.BQtiGL81UNBvWWy1pBi54dDJgHwemE3cQdiArTyxgBKjulJmGbK
 G36RbPncZYFLY6Nro2UxLmzHzXjEXEmn_8JSaP7obXgQUqaXsYK1Y0pDTUfe5tSJo684XhXjxD9b
 DTq.bCXm2Xzc58yBrPmeQobGflB.WEoIqraOObfU_S_OOpyLCua.Mz95Oz_arz9dETlkBceQT4EO
 k.zeNggoQrY5NTrQOkP1ATJJVap5GLpmpNnRsTNmjB9PqmQUdRa4K_8zXqwSwVTTAgbM67g3k12Z
 sRXeAd7gOToxd3J55ktB213nyavj38iZKDwrmWMilysLUxP1TTDIltmR7zmkURI9zYSw0WgCjOVw
 UgWlfulDAta4x1bD47UdZs5k0GqhfrpctlEHqDdhd5A1ZxBUx1ZAUsFprG_QSlfpL9tuma.bJEiR
 pisJRfzHcgdkXFdBYgPZ0QI957.1R6.KUR4y.c_jHFC6VFyJwPkYmCSaT1NH7MISOU5pitz0a8ZF
 lwB.WyFFyaHSi70H8y8PbmKedLYJMRc.wMSDcTRn2Lnfyul8FMTPzLAl5TIu5gwueVJOpEbmRLRh
 .Kc55v67qwepu7kwzkeN7Aiw4b0e1n85eRXdx5Ghuej845LwD8YtO0aNuZjeHUx97GvgzFURH.bc
 04qWFCYPvqI.oLBgjDrTAKn8.jHVabo.XY_.fw5xtA8UyzkD3EUvNWG9WYJC6Dc4uS8pUHh1XrTJ
 IcOjvYXNnen7H.BNKj3s6m7nlaJjmIBJVZK92ADPhYWL9rLYKlSY0QlTHD5BZ_SJai6F.6aUVub2
 gEoPKeBdBfQAQA107iDrQVw0BdSz175_0qvtbUpezJx.i0aIN_CF8abTt04rpTyeg0TYrqewaDTR
 GiwwE6pAOhvJ.HVESe6_11lD1sVA.6X9sSnk_SqZlrKWXhNq0ZS9KaRMIF6B9idtGoBuOT3JECuo
 yrDHB6fdPNA5Ine7y.MKG5Wd24_R_NloU.8UhJpSVmlyp5A.yMdOLledTkL9dAGimHXG_hTD_EFk
 MN_8eJ9I4l6gtAfo4otX9Ie1BGwThdcFyevoWeuV2SKXaZ2eZ2R3PqJJotz1njuDEPBtsRfA8k.v
 7xJC8sUXcMMuKxQMIrTNmdL9JoeGUEjfTloIoJ.6mBskLH55CT9YWO6aqx_mB3j5ZRU_tmWFIrBO
 Nb9T26ZLymPFWOYA2MTTbwKpGfhDrmsEtIOeD9UI8mWcQWObs575rbI.Wz_4capJ.ulg0OFD8iyY
 ECCLnWmm5Dw9P.Ckm_qBctsQJY.EjgTHHZbtKc7Zwgmkg3lBPIMFDGPi3GFg.DpD_2tDLchysthm
 u_JJ9HWGDRBcwcfSqcENFewp74KvaNiehfmTef9bfKQs0zYGIRf4FvvtOWrWLMypa4N2SFkLavGq
 ..crPBYjN2Np6zyzZfQPHLxl9GFPfmW6SDqFYkP2IJ.EbB_2Erm6pbsPVUYGfsIzucGCDfeRBMfc
 5Bk3F3zgokD9WV8mI59..dVg-
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic311.consmr.mail.ne1.yahoo.com with HTTP; Mon, 18 Apr 2022 15:03:15 +0000
Received: by hermes--canary-production-bf1-5f49dbcd6-b5q4c (VZM Hermes SMTP Server) with ESMTPA ID e12cdaa14792a510c07372742bad7207;
          Mon, 18 Apr 2022 15:03:09 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        stephen.smalley.work@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH v35 08/29] LSM: Use lsmblob in security_secctx_to_secid
Date:   Mon, 18 Apr 2022 07:59:24 -0700
Message-Id: <20220418145945.38797-9-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220418145945.38797-1-casey@schaufler-ca.com>
References: <20220418145945.38797-1-casey@schaufler-ca.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
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
index 68ab0add23d3..57879f0b9f89 100644
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
index 3925d38f49f4..adea727744f4 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -791,14 +791,12 @@ EXPORT_SYMBOL(set_security_override);
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
index ac4859241e17..fc0028c9e33d 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -860,21 +860,21 @@ static const struct nla_policy nft_secmark_policy[NFTA_SECMARK_MAX + 1] = {
 
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
index e9f1487af0e5..f814a41c5d9f 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2211,10 +2211,22 @@ int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
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
 
@@ -2365,10 +2377,26 @@ int security_socket_getpeersec_stream(struct socket *sock, char __user *optval,
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
2.35.1

