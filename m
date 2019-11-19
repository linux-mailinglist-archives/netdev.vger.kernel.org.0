Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE120102F7D
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 23:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727389AbfKSWrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 17:47:40 -0500
Received: from sonic313-15.consmr.mail.ne1.yahoo.com ([66.163.185.38]:34061
        "EHLO sonic313-15.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727194AbfKSWrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 17:47:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1574203658; bh=co4jpZY+mhudboH3Pzmlm1GU8BGwBGVp+kygYlsjIuI=; h=From:To:Subject:Date:In-Reply-To:References:From:Subject; b=InQtvz+F1qHKBDznT9wiv/4nBuP+j3tZSoATD5CeFlUkUyGuA2ulGeXJdlGGKqQZ3opcJ7L0ZLap15NWz0K5w57QoCbGtWwDQAYpBCW6YrQyz30Uu4vR/ivPQSWtrRW++wtEjD+N3jlI5lUg7WgDjnjSYBPTYkNy0pkxHkY+7UZaRXzIVH+pSZhOt+9d8/iMQMobxSDNsWjVXOPq8xceC59vgIUKEVII2p6CaMTjCju2lt0ZGn3N8Dn6FRs0v0kIWtyt4uoQFH0XLdzg1n1jc4XXrtwRI35L/cevfCq66az8RQIW6XXqx3prk8PybCMgt4StJyAtBXkRYpTc7cDC/Q==
X-YMail-OSG: dVYXdN0VM1koanQeJ__DrPl9W9PrmILAmV5sIpGPeUaKhOqSKh_yvwaGqEHcOQ8
 jwvkODrqTqK_59.iZj07xVkSpEPK7WQka2T7JPPwWrnotI9hsmCByq7n_q0fwKBEREbBzrAUUC0T
 stLUgBdHBnoimWDvS9LJ_Jui8t3A_3b_YyRWoCTWrBbegII5HPTpvTQ.aTNTuG3IDHQD.CXX4X0d
 Bw881L9I2zIOrquj5wLnnehpi_ZTjl.poJCFnwR1oK80ubQVQS_YT3ykAmlS4nRZv8RPmkf_G2KQ
 iEXH4DBE8OXuzE1YKUylWcGkBbcvgs8masRJU_lfVk0vO9P8k6Bt9ZKPCDhE2hhRItDxqq_kSOhO
 iWe0OzykYym971jt2erZdncb27CIuKyFUsBLk6l7hL4.vJgEkoVkGQH0gpuyoMIzEs.HggYrIdap
 is4.80uJcMKLjXqPeYvTixnofhgsr_sZyA5keukfXlIvOiPAWfGI8NtITDPx8OCiin9EI.DFvbmg
 To1Uj7HniMs5J.1uSwLSmR3YwVaKz2Yai6.rnoxkLzyMfCFWd8JeMJfwfIzxQwX.hxVLaxHcgowf
 7L8keW3T4tjzTyTBqETYO8dZUWf5NaFdFUo3LLxQUhMhWKNkN9XEJMf.fNBIgDT63P50hADvdhSN
 ifq.aKGVSXJAbr1Sq6aUS_7nU7BemwOH5lrYi158VVI6lvJepAoVncWo6wt7ZpAvhM_zhopjcdgG
 tPb1qshrmpruo9kLx.6VYlteISkwstXNs.TqchMihjTIAkC0sySlYrCNmbXX_H.Dl_FIfxt7woGw
 X_qLcfdT1ZmeZc4kOARbpYVPqGRh_xPjUbHFQaxBPeZ4nVVTxK5QY1z_2wfXwy5UC8_GEmue_zcJ
 3.lFb8sYjM71Pf93SGxHVRBcyWkc4Dou.p3DBwHfDa9Cncy7R3wrUtKyYkDNQHbqB02XcEDFrfSq
 VLE1wHSGN3qAcPjjp.RnFu9aUlpf.9Sr0DOvl1SWfM0CZAANNCc4uIGak2IpPRz7HzKLQ_JNiZUD
 PYk8XDLGbW8oZ4emXIscROK2.5v4eohgE7zA7MEqdCMx8CwlyyPIoO_.SKePzuNpxEm_cg5YP2FQ
 ypEKsvBOQpNMZJQSZkVoqHZBHpbSw0JycTmiT3Z536fv1m7RkVRpIOFhDRHb7KkG6wzSpFojCvxK
 GAnPUckF2ClXcSkBJhbRAY.UkJ_uAuXWcFIbW.W9rqojs1hNYjhMAV8F0BVtfGjmqjTB5b2t94ho
 j1Dg1WbRakIE5_5eQanvEdDB472dedH0YrE0Dga_LVKZgnyrgOu6SrFFVd5XPizKrM1STBV76ihe
 QfH6plVQSxHRZhzO1JZYf_F2AqtAaEA8XpS1V_t4g5YpLISynrC8Ig9E.wKg1JIAzNJb4XIV9u0N
 CKGvvFkAzVTRI5ttvucnh.2gDnUt.p9Ov
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.ne1.yahoo.com with HTTP; Tue, 19 Nov 2019 22:47:38 +0000
Received: by smtp431.mail.ne1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID de87915666a9c7d973a1bff130532280;
          Tue, 19 Nov 2019 22:47:33 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     netdev@vger.kernel.org
Subject: [PATCH v11 06/25] LSM: Use lsmblob in security_secctx_to_secid
Date:   Tue, 19 Nov 2019 14:47:05 -0800
Message-Id: <20191119224714.13491-4-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191119224714.13491-1-casey@schaufler-ca.com>
References: <20191119224714.13491-1-casey@schaufler-ca.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change security_secctx_to_secid() to fill in a lsmblob instead
of a u32 secid. Multiple LSMs may be able to interpret the
string, and this allows for setting whichever secid is
appropriate. In some cases there is scaffolding where other
interfaces have yet to be converted.

Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
---
 include/linux/security.h          |  5 +++--
 kernel/cred.c                     |  4 +---
 net/netfilter/nft_meta.c          | 13 ++++++-------
 net/netfilter/xt_SECMARK.c        |  5 ++++-
 net/netlabel/netlabel_unlabeled.c | 14 ++++++++------
 security/security.c               | 18 +++++++++++++++---
 6 files changed, 37 insertions(+), 22 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index d57f400a307e..b69877a13efa 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -494,7 +494,8 @@ int security_setprocattr(const char *lsm, const char *name, void *value,
 int security_netlink_send(struct sock *sk, struct sk_buff *skb);
 int security_ismaclabel(const char *name);
 int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen);
-int security_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid);
+int security_secctx_to_secid(const char *secdata, u32 seclen,
+			     struct lsmblob *blob);
 void security_release_secctx(char *secdata, u32 seclen);
 void security_inode_invalidate_secctx(struct inode *inode);
 int security_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen);
@@ -1300,7 +1301,7 @@ static inline int security_secid_to_secctx(u32 secid, char **secdata, u32 *secle
 
 static inline int security_secctx_to_secid(const char *secdata,
 					   u32 seclen,
-					   u32 *secid)
+					   struct lsmblob *blob)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/kernel/cred.c b/kernel/cred.c
index 846ac4b23c16..7fef90f3f10b 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -756,14 +756,12 @@ EXPORT_SYMBOL(set_security_override);
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
index 317e3a9e8c5b..7c49397c33fd 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -617,21 +617,20 @@ static const struct nla_policy nft_secmark_policy[NFTA_SECMARK_MAX + 1] = {
 
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
-		return -ENOENT;
-
-	err = security_secmark_relabel_packet(tmp_secid);
+	/* Using le[0] is scaffolding */
+	err = security_secmark_relabel_packet(blob.secid[0]);
 	if (err)
 		return err;
 
-	priv->secid = tmp_secid;
+	/* Using le[0] is scaffolding */
+	priv->secid = blob.secid[0];
 	return 0;
 }
 
diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
index 2317721f3ecb..2d68416b4552 100644
--- a/net/netfilter/xt_SECMARK.c
+++ b/net/netfilter/xt_SECMARK.c
@@ -45,13 +45,14 @@ secmark_tg(struct sk_buff *skb, const struct xt_action_param *par)
 
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
@@ -59,6 +60,8 @@ static int checkentry_lsm(struct xt_secmark_target_info *info)
 		return err;
 	}
 
+	/* scaffolding during the transition */
+	info->secid = blob.secid[0];
 	if (!info->secid) {
 		pr_info_ratelimited("unable to map security context \'%s\'\n",
 				    info->secctx);
diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index d2e4ab8d1cb1..7a5a87f15736 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -881,7 +881,7 @@ static int netlbl_unlabel_staticadd(struct sk_buff *skb,
 	void *addr;
 	void *mask;
 	u32 addr_len;
-	u32 secid;
+	struct lsmblob blob;
 	struct netlbl_audit audit_info;
 
 	/* Don't allow users to add both IPv4 and IPv6 addresses for a
@@ -905,12 +905,13 @@ static int netlbl_unlabel_staticadd(struct sk_buff *skb,
 	ret_val = security_secctx_to_secid(
 		                  nla_data(info->attrs[NLBL_UNLABEL_A_SECCTX]),
 				  nla_len(info->attrs[NLBL_UNLABEL_A_SECCTX]),
-				  &secid);
+				  &blob);
 	if (ret_val != 0)
 		return ret_val;
 
+	/* scaffolding with the [0] */
 	return netlbl_unlhsh_add(&init_net,
-				 dev_name, addr, mask, addr_len, secid,
+				 dev_name, addr, mask, addr_len, blob.secid[0],
 				 &audit_info);
 }
 
@@ -932,7 +933,7 @@ static int netlbl_unlabel_staticadddef(struct sk_buff *skb,
 	void *addr;
 	void *mask;
 	u32 addr_len;
-	u32 secid;
+	struct lsmblob blob;
 	struct netlbl_audit audit_info;
 
 	/* Don't allow users to add both IPv4 and IPv6 addresses for a
@@ -954,12 +955,13 @@ static int netlbl_unlabel_staticadddef(struct sk_buff *skb,
 	ret_val = security_secctx_to_secid(
 		                  nla_data(info->attrs[NLBL_UNLABEL_A_SECCTX]),
 				  nla_len(info->attrs[NLBL_UNLABEL_A_SECCTX]),
-				  &secid);
+				  &blob);
 	if (ret_val != 0)
 		return ret_val;
 
+	/* scaffolding with the [0] */
 	return netlbl_unlhsh_add(&init_net,
-				 NULL, addr, mask, addr_len, secid,
+				 NULL, addr, mask, addr_len, blob.secid[0],
 				 &audit_info);
 }
 
diff --git a/security/security.c b/security/security.c
index 55837706e3ef..32bb5383de9b 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1970,10 +1970,22 @@ int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
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
 
-- 
2.20.1

