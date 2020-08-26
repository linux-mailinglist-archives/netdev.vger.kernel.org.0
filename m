Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 280C32532EC
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 17:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727948AbgHZPIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 11:08:13 -0400
Received: from sonic312-29.consmr.mail.ne1.yahoo.com ([66.163.191.210]:33048
        "EHLO sonic312-29.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726873AbgHZPIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 11:08:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1598454490; bh=yN3eueyIIik0iaafcLvxBpGYDxG1nxKL+aiZV3Os2k8=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject; b=MXv1WAMtgC12GVGPOJTmm7ZwSTDbgUNhT6hNFQTL8bFu+Lt3qZGbL21L+1cMMS7tlLy0Y6OSIvVeXtp0ho7opDi7cbQI3KH6+7GrcXWOpnSScBqmSB580nXdaOBpF5d7O3m2qDnOU4nQatyXY2SnFZyP5+8TjvfQhnWSVq5FJEwjeUZpUnhRlD1H1euVCUSBtNfIXErvhMN6PJSVJVz5peHakwXHgQWNRijBRNcItfSekfFZ7UcMDCzzbXE9KkaqxI/WI9dX147ORi0BiPWgQbHAe36L09Ws+S3C6J0voAW/hE0ppYfYTEHKMB3QVolw+U3OeRYKftgagztqArU4hg==
X-YMail-OSG: TKMavaQVM1nrJYT5wR7tkBgyllUfSEcOH1E6nv7ytoakxLpS.TkRWJWXZ7d.RbH
 Qt8cGNGAjkbOCTgBw.7QnIhKbUjRE2ynAj3X4oCuEB88dlMFQ4hZe7mNyIlUljKfwMJGesbZTvU7
 nP.NucR0SGxbcA3AbvdDfjwIqgupwoMMgEPW544h4ze0wMIPjdrUaUGc7AqlXjRMTRbokB.9ihvY
 5PQ8lNf3whmMo0.uBqglKypkuZTLdCj0avjRpDnPVn5VfXZmXzGLCO3UdcydQ1OAAA_946nyfVfM
 Gb_KwCOnGBOvHb7tV2XtL08flBR_1BiD6fOTuJ9Ndphwan31P8pQBXQbWxO68Vx4JVOiPgkmYU86
 QmCi0pYYnpR.ieJJYkx4rTUSoK4xdvewX8.CNXTf0e_2jgyXAiGkfqPHC.WPE4KV.iAip9P3aHvn
 Hr54IlkbyKxZPnyRjAog.ocUtyuAWPC5Aw8slmDN9Vb4sgva8q0LKUD1CpP7IbzggN.64fRzSxIG
 gUql1TIECGnluNbEiXAvY_4doFG7HmYyAP.aSVi6lzfwDpLlBcSp8j04vk0F2u1tbk7it_g_fd8S
 iidZ6L6.AVfg1KVdUfONSDDpCTBL5XAhaqL7d0Cnr.dGRSJfz2kppzWc6OLdUtSKD0DdHoGIjO2A
 6gdtPBJV0RwM8t0HuPopyLRAz4lhO58ji7I7htTn0EVSGdgviWAE8MVI7ngoguKGkt11I0.LSoFu
 U2WbEe0O2GC2kktnRcf06IW3oDNORHNpqgcSAqR99WV56FG0y44h0XSblGFaTlTB6sKOfTs.m9QP
 AUZXC18cTeV9mENyxsknN_Ke4Qa_0ZS0VDUouxBVlm3mUazM9lNTDv6iSdUNF.pP_m4Ze1ilm.KW
 uCwIVX_kNY1lpRrUgk.isJQ7Mxz.byCWKRGLccLi7Gbi0eL3Ghg0O3nmOBnT.7HDCQzpmhswskc7
 dXFQl9nYmG2EtgmfCz4POGhZ4dpDOiMeo5gf8KwVvXIZLhHT2tMnzF.dhE9ZCLjdAVvQgEwJVzCM
 rYjrFxXLWbPJHYZ0VaxnAcwRGYh_okmHuNVWJvgEVqHEjCT9Aod9oGjC_P1bkD7vzrML7caXwPXQ
 btVe4II0HvbCHjgVxTtTPivqb3VYs684NT2bzn9TZ4DulrwAlIP.EU5K1NVn_9TZrymyOjzC1P60
 5TuMqGtQENJS7q40DgkYEDfzn9KhtpYdtyAztIVhqWlEiHybOHpE1byzsaZ4nvOokvFlOuzGZtLU
 _ORLL9p02gT0Cc6IrOfvaIVUqnVFiKkoOtvmOht5MAGqysRW3FXgYKUEx2Q9DR6qwQ..P6hNOQkK
 5t8zv3JG6GQAqWnbGRdI.eD8smQGE0izAoc59puALHYEoMKovjUwXLqEsHa10H6Ox5QA1HPwtsk2
 W3DzOLJJLCSQUDc8y2k6s.15G97snXYMBIJ7uqY07t3uJT13ue_tRYRwLcZRARerJ2aAngea58g0
 y3uFFtSYXpviqXsOTyIauBTlgx3DPJQHLrSqFGy8Vfkw2YysDIWnyYdRBO_.wkE23gOAYYZCtAMQ
 iX05B1vUGzK3Enow-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic312.consmr.mail.ne1.yahoo.com with HTTP; Wed, 26 Aug 2020 15:08:10 +0000
Received: by smtp416.mail.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 3ff895580a9dbc79776f995de0655309;
          Wed, 26 Aug 2020 15:08:06 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, netdev@vger.kernel.org
Subject: [PATCH v20 06/23] LSM: Use lsmblob in security_secctx_to_secid
Date:   Wed, 26 Aug 2020 07:52:30 -0700
Message-Id: <20200826145247.10029-7-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200826145247.10029-1-casey@schaufler-ca.com>
References: <20200826145247.10029-1-casey@schaufler-ca.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change security_secctx_to_secid() to fill in a lsmblob instead
of a u32 secid. Multiple LSMs may be able to interpret the
string, and this allows for setting whichever secid is
appropriate. Change security_secmark_relabel_packet() to use a
lsmblob instead of a u32 secid. In some other cases there is
scaffolding where interfaces have yet to be converted.

Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Cc: netdev@vger.kernel.org
---
 include/linux/security.h          | 30 +++++++++++++++++++++++----
 include/net/scm.h                 |  7 +++++--
 kernel/cred.c                     |  4 +---
 net/ipv4/ip_sockglue.c            |  6 ++++--
 net/netfilter/nft_meta.c          | 18 +++++++++-------
 net/netfilter/xt_SECMARK.c        |  9 ++++++--
 net/netlabel/netlabel_unlabeled.c | 23 +++++++++++++--------
 security/security.c               | 34 ++++++++++++++++++++++++++-----
 8 files changed, 98 insertions(+), 33 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index ae623b89cdf4..f8770c228356 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -190,6 +190,27 @@ static inline bool lsmblob_equal(struct lsmblob *bloba, struct lsmblob *blobb)
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
@@ -503,7 +524,8 @@ int security_setprocattr(const char *lsm, const char *name, void *value,
 int security_netlink_send(struct sock *sk, struct sk_buff *skb);
 int security_ismaclabel(const char *name);
 int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen);
-int security_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid);
+int security_secctx_to_secid(const char *secdata, u32 seclen,
+			     struct lsmblob *blob);
 void security_release_secctx(char *secdata, u32 seclen);
 void security_inode_invalidate_secctx(struct inode *inode);
 int security_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen);
@@ -1322,7 +1344,7 @@ static inline int security_secid_to_secctx(u32 secid, char **secdata, u32 *secle
 
 static inline int security_secctx_to_secid(const char *secdata,
 					   u32 seclen,
-					   u32 *secid)
+					   struct lsmblob *blob)
 {
 	return -EOPNOTSUPP;
 }
@@ -1412,7 +1434,7 @@ void security_inet_csk_clone(struct sock *newsk,
 			const struct request_sock *req);
 void security_inet_conn_established(struct sock *sk,
 			struct sk_buff *skb);
-int security_secmark_relabel_packet(u32 secid);
+int security_secmark_relabel_packet(struct lsmblob *blob);
 void security_secmark_refcount_inc(void);
 void security_secmark_refcount_dec(void);
 int security_tun_dev_alloc_security(void **security);
@@ -1585,7 +1607,7 @@ static inline void security_inet_conn_established(struct sock *sk,
 {
 }
 
-static inline int security_secmark_relabel_packet(u32 secid)
+static inline int security_secmark_relabel_packet(struct lsmblob *blob)
 {
 	return 0;
 }
diff --git a/include/net/scm.h b/include/net/scm.h
index e2e71c4bf9d0..c09f2dfeec88 100644
--- a/include/net/scm.h
+++ b/include/net/scm.h
@@ -97,8 +97,11 @@ static inline void scm_passec(struct socket *sock, struct msghdr *msg, struct sc
 	int err;
 
 	if (test_bit(SOCK_PASSSEC, &sock->flags)) {
-		/* Scaffolding - it has to be element 0 for now */
-		err = security_secid_to_secctx(scm->lsmblob.secid[0],
+		/* There can currently be only one value in the lsmblob,
+		 * so getting it from lsmblob_value is appropriate until
+		 * security_secid_to_secctx() is converted to taking a
+		 * lsmblob directly. */
+		err = security_secid_to_secctx(lsmblob_value(&scm->lsmblob),
 					       &secdata, &seclen);
 
 		if (!err) {
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
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index 551dfbc717e9..c568574abfae 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -139,8 +139,10 @@ static void ip_cmsg_recv_security(struct msghdr *msg, struct sk_buff *skb)
 	if (err)
 		return;
 
-	/* Scaffolding - it has to be element 0 */
-	err = security_secid_to_secctx(lb.secid[0], &secdata, &seclen);
+	/* There can only be one secid in the lsmblob at this point,
+	 * so getting it using lsmblob_value() is sufficient until
+	 * security_secid_to_secctx() is changed to use a lsmblob */
+	err = security_secid_to_secctx(lsmblob_value(&lb), &secdata, &seclen);
 	if (err)
 		return;
 
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 7bc6537f3ccb..7db487d93618 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -801,7 +801,7 @@ struct nft_expr_type nft_meta_type __read_mostly = {
 
 #ifdef CONFIG_NETWORK_SECMARK
 struct nft_secmark {
-	u32 secid;
+	struct lsmblob lsmdata;
 	char *ctx;
 };
 
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
+	err = security_secmark_relabel_packet(&blob);
 	if (err)
 		return err;
 
-	priv->secid = tmp_secid;
+	priv->lsmdata = blob;
 	return 0;
 }
 
@@ -835,7 +835,11 @@ static void nft_secmark_obj_eval(struct nft_object *obj, struct nft_regs *regs,
 	const struct nft_secmark *priv = nft_obj_data(obj);
 	struct sk_buff *skb = pkt->skb;
 
-	skb->secmark = priv->secid;
+	/* It is not possible for more than one secid to be set in
+	 * the lsmblob structure because it is set using
+	 * security_secctx_to_secid(). Any secid that is set must therefore
+	 * be the one that should go in the secmark. */
+	skb->secmark = lsmblob_value(&priv->lsmdata);
 }
 
 static int nft_secmark_obj_init(const struct nft_ctx *ctx,
diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
index 75625d13e976..5a268707eeda 100644
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
@@ -57,13 +58,17 @@ static int checkentry_lsm(struct xt_secmark_target_info *info)
 		return err;
 	}
 
+	/* xt_secmark_target_info can't be changed to use lsmblobs because
+	 * it is exposed as an API. Use lsmblob_value() to get the one
+	 * value that got set by security_secctx_to_secid(). */
+	info->secid = lsmblob_value(&blob);
 	if (!info->secid) {
 		pr_info_ratelimited("unable to map security context \'%s\'\n",
 				    info->secctx);
 		return -ENOENT;
 	}
 
-	err = security_secmark_relabel_packet(info->secid);
+	err = security_secmark_relabel_packet(&blob);
 	if (err) {
 		pr_info_ratelimited("unable to obtain relabeling permission\n");
 		return err;
diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index 77bb1bb22c3b..8948557eaebb 100644
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
index c42873876954..5c2ed1db0658 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2065,10 +2065,22 @@ int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
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
 
@@ -2301,9 +2313,21 @@ void security_inet_conn_established(struct sock *sk,
 }
 EXPORT_SYMBOL(security_inet_conn_established);
 
-int security_secmark_relabel_packet(u32 secid)
+int security_secmark_relabel_packet(struct lsmblob *blob)
 {
-	return call_int_hook(secmark_relabel_packet, 0, secid);
+	struct security_hook_list *hp;
+	int rc = 0;
+
+	hlist_for_each_entry(hp, &security_hook_heads.secmark_relabel_packet,
+			     list) {
+		if (WARN_ON(hp->lsmid->slot < 0 || hp->lsmid->slot >= lsm_slot))
+			continue;
+		rc = hp->hook.secmark_relabel_packet(
+						blob->secid[hp->lsmid->slot]);
+		if (rc != 0)
+			break;
+	}
+	return rc;
 }
 EXPORT_SYMBOL(security_secmark_relabel_packet);
 
-- 
2.24.1

