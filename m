Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D10A445B170
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 02:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238067AbhKXB4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 20:56:49 -0500
Received: from sonic302-26.consmr.mail.ne1.yahoo.com ([66.163.186.152]:35470
        "EHLO sonic302-26.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238317AbhKXB4r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 20:56:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1637718818; bh=I376tfCBPkXxTvDHbGlI/BnOlmvs91pFbxvhLdOiGlQ=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=AjXOCBWkXw6CUjCUTURYdVAil7RKM38bVxeitLnE9qmmtmOCZudjw0Wf10wPqFDVQJH/aA79hpGG5qUGaJlmTNhfNj2mu6zBgSkFZw+L9d2MDR7d8Jcy2/an0si4vdv5/LLtahYOWJpMRe7DRUMTRGMzQatlVMlN0ePkCrKwUBcnIV7Nzv5Cz0B3HKX3VcXY54N3Q/1TxlEQrZkyEFwj2H5gCSwtR5PnZBj66IkvXIU9JB6/qEK2UhSmoM1UZFtIPfMmJeKGqxxOa9pZvuxaT3AvP2AMOUJRvtMgH6xfVR+M/TjwOXPLdDK/W1YoQ6CYUakCnfP66l3+9X1cN3JjFA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1637718818; bh=8CAvlH9pIrN6tqkD9y7eT9tFVoz9BLn1XbiHj8eX2H3=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=mUrGlhEsDopGb+P4lqS65/Nz1GHd6DLBv4ta7WtVxtsO2cOAKUWV8Y5fgurk9aJujkU1WlQ+GsVzESMH+QJsCbVgfn/aTVy/sRfex2drrlcxQfNzw8xW+KbvoSAwJPhu2A+SzeEEiDgoheCRMmuCeMuGJqvmGEuvubRjLwq5C5CNC3rHyaONOWc8XldvcIgv6/48rp1bnzPN16Ios0mrKIl2wFxJsAz2wOiONHIfsnqahOirJdWJZ5zUcyfHZ5PhszmJ+QBdw2vJFZ1eINWj8UHgru8G9HlgK/a5VuLR6pAS16WsYPvLMUJ4hltn/9d4OuZxcSywA4cCvkz79txTmw==
X-YMail-OSG: NYPF2AkVM1k1W5ux.zWrfTFzj3P0lJanIwrEITwdBb4n0.pjk629gYDTGwNlLns
 xMs6rIqCcYIioN4le0pdacI.kqcd6dV2OXEeYsALhscubLp3X5dRVkZEnnaHtCSd_JMMgbCbP9S5
 CQEggojcVlmY37C50W87NDeK9vk9qEV5LZ_HgK5Da2rNCXDekG3cqJlWXxCnOGfr1AvLAta.O6At
 wvRaiN2edYmo3FMcG6d2tNKkkm6ZExQRY6ONL2yMjSXwLZHzog66tE9m2sL3boDgsk1sbxZ69.Pb
 _726wj8nEvh6Mq_1Qt.ZF3DjhTpDTylh6Hz6N.xWiwYMwpdDx6ljokhQybkknoDZ5T9MmXvqZx1M
 83WEYrvKzU.EXJzT15QGwCe1O3.1huK.CeW4Q6fNGid92iCRUZu.K403n24UWvRcxxEIup.vUWbS
 CxhdUGZ1uUCbQNQ2Bj8v2uTPYIcH69_VmYGvoLaa1PSe8mfUCn_ZWICn.NapkgZMXbjWKWoxMoCO
 zw_QI_1P81wQg0tBsZzr1TBu2Hdiz5cv1qwFGH5mhxkzcnUtp3ZUuQ8YhVG5ZhG7SbyNxRmgZbHh
 XVVEWTIRcCy9bgA_LUDDb9I0BVuoqOnF8FFxdbh2qx5NBmYmb9KhhzFjBWnOUYe5yAYrDoTjbUkl
 mOWJ0rqNheCQgE7MoYQFIbnt9Mo7_mPJue5p.8wCvjpT71bs3dWaATw1w944aNd5gOg60LeM7sFT
 JfWc9EzEzF9p1xuIdkRRD.WozkNQlUCuDKOowE5joKV8cmqi573yl7TpXY0Ij2blspGT7LexdfBe
 AcoHVxAhmiPZHZiMjhO0McuZ2pXk_UXyIUUXd0pFHmK6PzmqBu_jlz9C19U6MCH3tOtKU6YPR.vK
 8QsxOxL4V9Z5UnhpJLrJE7XBw3BxxcaQgWItSl99m3QsHZuhRGW55ggNAUt2FRdH1JeY2YYImLYq
 LW7TYksCVwiUzSeLPQKYxOwJHQ8lP7utpGukiQFzJN9GLCH7BRKYEi_5.pYB_XQdGEzCW8cFX4_v
 ._aJ.0Cvjzi_LlvwxVCOuxd65cxpplg.y9AYj_cWcBJU9naF_5craWZGBhBP_5OwX5jKlWgk7vR4
 S.Xfaa95N2RwLD62kE5cz5IMLP5mEMKM6srRw34qPPUWrKQo3c9dEW1w7wPcafrB0o9IEM0X2rhm
 .xxUslRRwGaA.pTNhD9vQw9teuXS3ihEyr34yYkxRZf5BCvFDZN.Hy_lZX5jHKq4nVAihGNxbjwl
 RkJ5Y4zoRVCI_0Z5OcStyPh02GYVF7LPUu4hyHqJmyqGrN08VTdZ78kpWgMV3oZSKo2BGO8XQIUl
 qApWSaErUW9DsRFrmlWKSH5WtGvuNxpoXYsljZSsQwADiitrKLaNRodqQ_EljX2M.Kw5QWhTC81l
 y9HCOcmvBENe4HD8XHvXz29DO_LnMyDKKhG.ibWDxbOj_cs8K4RTMIEi_GxOwxt___jdprImgqVO
 1sURB25rqiVv0Ae_agCFDU6iZScqQUY2fEdwvkQU5Uu3GltQQrS1yPIV2xj8ZntdUOaW6GTUDIAe
 i36ClUewa8MKs02CK_Af0bwHWjyvlTS7_DYsgho55IPpJ2qjZ6V.r2D98aIBlw8V0Kq0UM3PaG_B
 sFD0hVI5_n6LVcxq0lvmkFAUYTaZ5n75isxAjJd03874.n_I_rAHuA4arQMtHsxtbXhCEOR51XuU
 F6b.HH9AM_qUGmQNwjmA26XwbwTX4sacKxSKETY7_NTVKiNQ064hR284XD2np.b1cBIz5QJ5nokl
 CqkzYreupn3R8kNuPOyjREf9z2S5sUTj6BRuFzh7lwRMFJLNK.oTyv5nx3iZ8urcaQXaAZkz9Xxo
 lnbNWIE3tpIeza_e_P6gOKll1ExxKmdJAS1JPla98Nxe_0hPBKHhRsUJKCjiGWNcX3ljEHaDPCWw
 O256zp_Q2s2fMkC5meiQOJFOEKs.euFe5iPr75t2HYKm5BUxhyRNu2SIVrtkdH.JJU9DZ0q.6qeF
 S0UXOKm1k5ANE8MUfiA1NZhV2fDGt3garEpy4VJaye3.0Cjgo5EN.rfSGyPBHDzTaGl.5.ZiCmHR
 By.GKrIpIdzspYERXgL0jKOi_XoNnTf.HFzHpk2pUjDhzcN49O479U7RzALP1CboMoPA3k6mYmXa
 NuuXnHemphCTnhZfYvHS9qOFCwLOdjKiVjyKIb3AMBVpNdt4mi_JhrH76yS4CVvSc90jiWpWrkf9
 EtG3wMqOyHRtUcAzlgICD637MR_A4b9hTsNL0Q1OR_ohfuJg5XDf5fJJfLsVo4w--
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic302.consmr.mail.ne1.yahoo.com with HTTP; Wed, 24 Nov 2021 01:53:38 +0000
Received: by kubenode511.mail-prod1.omega.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 2f39561b52daa71f71500fd09f46c636;
          Wed, 24 Nov 2021 01:53:33 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH v30 09/28] LSM: Use lsmblob in security_secid_to_secctx
Date:   Tue, 23 Nov 2021 17:43:13 -0800
Message-Id: <20211124014332.36128-10-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211124014332.36128-1-casey@schaufler-ca.com>
References: <20211124014332.36128-1-casey@schaufler-ca.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change security_secid_to_secctx() to take a lsmblob as input
instead of a u32 secid. It will then call the LSM hooks
using the lsmblob element allocated for that module. The
callers have been updated as well. This allows for the
possibility that more than one module may be called upon
to translate a secid to a string, as can occur in the
audit code.

Acked-by: Paul Moore <paul@paul-moore.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Cc: netdev@vger.kernel.org
Cc: linux-audit@redhat.com
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
---
 drivers/android/binder.c                | 12 +++++++++-
 include/linux/security.h                |  5 +++--
 include/net/scm.h                       |  7 +++++-
 kernel/audit.c                          | 20 +++++++++++++++--
 kernel/auditsc.c                        | 27 ++++++++++++++++++----
 net/ipv4/ip_sockglue.c                  |  4 +++-
 net/netfilter/nf_conntrack_netlink.c    | 14 ++++++++++--
 net/netfilter/nf_conntrack_standalone.c |  4 +++-
 net/netfilter/nfnetlink_queue.c         | 11 +++++++--
 net/netlabel/netlabel_unlabeled.c       | 30 +++++++++++++++++++++----
 net/netlabel/netlabel_user.c            |  6 ++---
 security/security.c                     | 11 +++++----
 12 files changed, 122 insertions(+), 29 deletions(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 49fb74196d02..01cef18f942f 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2719,10 +2719,20 @@ static void binder_transaction(struct binder_proc *proc,
 
 	if (target_node && target_node->txn_security_ctx) {
 		u32 secid;
+		struct lsmblob blob;
 		size_t added_size;
 
 		security_cred_getsecid(proc->cred, &secid);
-		ret = security_secid_to_secctx(secid, &secctx, &secctx_sz);
+		/*
+		 * Later in this patch set security_task_getsecid() will
+		 * provide a lsmblob instead of a secid. lsmblob_init
+		 * is used to ensure that all the secids in the lsmblob
+		 * get the value returned from security_task_getsecid(),
+		 * which means that the one expected by
+		 * security_secid_to_secctx() will be set.
+		 */
+		lsmblob_init(&blob, secid);
+		ret = security_secid_to_secctx(&blob, &secctx, &secctx_sz);
 		if (ret) {
 			return_error = BR_FAILED_REPLY;
 			return_error_param = ret;
diff --git a/include/linux/security.h b/include/linux/security.h
index 65dc61067e7c..af712b61c949 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -550,7 +550,7 @@ int security_setprocattr(const char *lsm, const char *name, void *value,
 			 size_t size);
 int security_netlink_send(struct sock *sk, struct sk_buff *skb);
 int security_ismaclabel(const char *name);
-int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen);
+int security_secid_to_secctx(struct lsmblob *blob, char **secdata, u32 *seclen);
 int security_secctx_to_secid(const char *secdata, u32 seclen,
 			     struct lsmblob *blob);
 void security_release_secctx(char *secdata, u32 seclen);
@@ -1406,7 +1406,8 @@ static inline int security_ismaclabel(const char *name)
 	return 0;
 }
 
-static inline int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
+static inline int security_secid_to_secctx(struct lsmblob *blob,
+					   char **secdata, u32 *seclen)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/include/net/scm.h b/include/net/scm.h
index 1ce365f4c256..23a35ff1b3f2 100644
--- a/include/net/scm.h
+++ b/include/net/scm.h
@@ -92,12 +92,17 @@ static __inline__ int scm_send(struct socket *sock, struct msghdr *msg,
 #ifdef CONFIG_SECURITY_NETWORK
 static inline void scm_passec(struct socket *sock, struct msghdr *msg, struct scm_cookie *scm)
 {
+	struct lsmblob lb;
 	char *secdata;
 	u32 seclen;
 	int err;
 
 	if (test_bit(SOCK_PASSSEC, &sock->flags)) {
-		err = security_secid_to_secctx(scm->secid, &secdata, &seclen);
+		/* There can only be one security module using the secid,
+		 * and the infrastructure will know which it is.
+		 */
+		lsmblob_init(&lb, scm->secid);
+		err = security_secid_to_secctx(&lb, &secdata, &seclen);
 
 		if (!err) {
 			put_cmsg(msg, SOL_SOCKET, SCM_SECURITY, seclen, secdata);
diff --git a/kernel/audit.c b/kernel/audit.c
index 121d37e700a6..22286163e93e 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1442,7 +1442,16 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 	case AUDIT_SIGNAL_INFO:
 		len = 0;
 		if (audit_sig_sid) {
-			err = security_secid_to_secctx(audit_sig_sid, &ctx, &len);
+			struct lsmblob blob;
+
+			/*
+			 * lsmblob_init sets all values in the lsmblob
+			 * to audit_sig_sid. This is temporary until
+			 * audit_sig_sid is converted to a lsmblob, which
+			 * happens later in this patch set.
+			 */
+			lsmblob_init(&blob, audit_sig_sid);
+			err = security_secid_to_secctx(&blob, &ctx, &len);
 			if (err)
 				return err;
 		}
@@ -2131,12 +2140,19 @@ int audit_log_task_context(struct audit_buffer *ab)
 	unsigned len;
 	int error;
 	u32 sid;
+	struct lsmblob blob;
 
 	security_task_getsecid_subj(current, &sid);
 	if (!sid)
 		return 0;
 
-	error = security_secid_to_secctx(sid, &ctx, &len);
+	/*
+	 * lsmblob_init sets all values in the lsmblob to sid.
+	 * This is temporary until security_task_getsecid is converted
+	 * to use a lsmblob, which happens later in this patch set.
+	 */
+	lsmblob_init(&blob, sid);
+	error = security_secid_to_secctx(&blob, &ctx, &len);
 	if (error) {
 		if (error != -EINVAL)
 			goto error_path;
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index de22e852373a..fccd4571db5a 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -670,6 +670,13 @@ static int audit_filter_rules(struct task_struct *tsk,
 					security_task_getsecid_subj(tsk, &sid);
 					need_sid = 0;
 				}
+				/*
+				 * lsmblob_init sets all values in the lsmblob
+				 * to sid. This is temporary until
+				 * security_task_getsecid() is converted to
+				 * provide a lsmblob, which happens later in
+				 * this patch set.
+				 */
 				lsmblob_init(&blob, sid);
 				result = security_audit_rule_match(&blob,
 							f->type, f->op,
@@ -686,6 +693,13 @@ static int audit_filter_rules(struct task_struct *tsk,
 			if (f->lsm_isset) {
 				/* Find files that match */
 				if (name) {
+					/*
+					 * lsmblob_init sets all values in the
+					 * lsmblob to sid. This is temporary
+					 * until name->osid is converted to a
+					 * lsmblob, which happens later in
+					 * this patch set.
+					 */
 					lsmblob_init(&blob, name->osid);
 					result = security_audit_rule_match(
 								&blob,
@@ -1109,6 +1123,7 @@ static int audit_log_pid_context(struct audit_context *context, pid_t pid,
 	char *ctx = NULL;
 	u32 len;
 	int rc = 0;
+	struct lsmblob blob;
 
 	ab = audit_log_start(context, GFP_KERNEL, AUDIT_OBJ_PID);
 	if (!ab)
@@ -1118,7 +1133,8 @@ static int audit_log_pid_context(struct audit_context *context, pid_t pid,
 			 from_kuid(&init_user_ns, auid),
 			 from_kuid(&init_user_ns, uid), sessionid);
 	if (sid) {
-		if (security_secid_to_secctx(sid, &ctx, &len)) {
+		lsmblob_init(&blob, sid);
+		if (security_secid_to_secctx(&blob, &ctx, &len)) {
 			audit_log_format(ab, " obj=(none)");
 			rc = 1;
 		} else {
@@ -1362,8 +1378,10 @@ static void show_special(struct audit_context *context, int *call_panic)
 		if (osid) {
 			char *ctx = NULL;
 			u32 len;
+			struct lsmblob blob;
 
-			if (security_secid_to_secctx(osid, &ctx, &len)) {
+			lsmblob_init(&blob, osid);
+			if (security_secid_to_secctx(&blob, &ctx, &len)) {
 				audit_log_format(ab, " osid=%u", osid);
 				*call_panic = 1;
 			} else {
@@ -1524,9 +1542,10 @@ static void audit_log_name(struct audit_context *context, struct audit_names *n,
 	if (n->osid != 0) {
 		char *ctx = NULL;
 		u32 len;
+		struct lsmblob blob;
 
-		if (security_secid_to_secctx(
-			n->osid, &ctx, &len)) {
+		lsmblob_init(&blob, n->osid);
+		if (security_secid_to_secctx(&blob, &ctx, &len)) {
 			audit_log_format(ab, " osid=%u", n->osid);
 			if (call_panic)
 				*call_panic = 2;
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index 38d29b175ca6..be7073df19a5 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -130,6 +130,7 @@ static void ip_cmsg_recv_checksum(struct msghdr *msg, struct sk_buff *skb,
 
 static void ip_cmsg_recv_security(struct msghdr *msg, struct sk_buff *skb)
 {
+	struct lsmblob lb;
 	char *secdata;
 	u32 seclen, secid;
 	int err;
@@ -138,7 +139,8 @@ static void ip_cmsg_recv_security(struct msghdr *msg, struct sk_buff *skb)
 	if (err)
 		return;
 
-	err = security_secid_to_secctx(secid, &secdata, &seclen);
+	lsmblob_init(&lb, secid);
+	err = security_secid_to_secctx(&lb, &secdata, &seclen);
 	if (err)
 		return;
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index f1e5443fe7c7..daf554915e07 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -341,8 +341,13 @@ static int ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
 	struct nlattr *nest_secctx;
 	int len, ret;
 	char *secctx;
+	struct lsmblob blob;
 
-	ret = security_secid_to_secctx(ct->secmark, &secctx, &len);
+	/* lsmblob_init() puts ct->secmark into all of the secids in blob.
+	 * security_secid_to_secctx() will know which security module
+	 * to use to create the secctx.  */
+	lsmblob_init(&blob, ct->secmark);
+	ret = security_secid_to_secctx(&blob, &secctx, &len);
 	if (ret)
 		return 0;
 
@@ -650,8 +655,13 @@ static inline int ctnetlink_secctx_size(const struct nf_conn *ct)
 {
 #ifdef CONFIG_NF_CONNTRACK_SECMARK
 	int len, ret;
+	struct lsmblob blob;
 
-	ret = security_secid_to_secctx(ct->secmark, NULL, &len);
+	/* lsmblob_init() puts ct->secmark into all of the secids in blob.
+	 * security_secid_to_secctx() will know which security module
+	 * to use to create the secctx.  */
+	lsmblob_init(&blob, ct->secmark);
+	ret = security_secid_to_secctx(&blob, NULL, &len);
 	if (ret)
 		return 0;
 
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 80f675d884b2..79c280d1efce 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -178,8 +178,10 @@ static void ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
 	int ret;
 	u32 len;
 	char *secctx;
+	struct lsmblob blob;
 
-	ret = security_secid_to_secctx(ct->secmark, &secctx, &len);
+	lsmblob_init(&blob, ct->secmark);
+	ret = security_secid_to_secctx(&blob, &secctx, &len);
 	if (ret)
 		return;
 
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 4acc4b8e9fe5..62c0c5b847c6 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -305,13 +305,20 @@ static u32 nfqnl_get_sk_secctx(struct sk_buff *skb, char **secdata)
 {
 	u32 seclen = 0;
 #if IS_ENABLED(CONFIG_NETWORK_SECMARK)
+	struct lsmblob blob;
+
 	if (!skb || !sk_fullsock(skb->sk))
 		return 0;
 
 	read_lock_bh(&skb->sk->sk_callback_lock);
 
-	if (skb->secmark)
-		security_secid_to_secctx(skb->secmark, secdata, &seclen);
+	if (skb->secmark) {
+		/* lsmblob_init() puts ct->secmark into all of the secids in
+		 * blob. security_secid_to_secctx() will know which security
+		 * module to use to create the secctx.  */
+		lsmblob_init(&blob, skb->secmark);
+		security_secid_to_secctx(&blob, secdata, &seclen);
+	}
 
 	read_unlock_bh(&skb->sk->sk_callback_lock);
 #endif
diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index 762561318d78..51cb4fce5edf 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -376,6 +376,7 @@ int netlbl_unlhsh_add(struct net *net,
 	struct audit_buffer *audit_buf = NULL;
 	char *secctx = NULL;
 	u32 secctx_len;
+	struct lsmblob blob;
 
 	if (addr_len != sizeof(struct in_addr) &&
 	    addr_len != sizeof(struct in6_addr))
@@ -438,7 +439,11 @@ int netlbl_unlhsh_add(struct net *net,
 unlhsh_add_return:
 	rcu_read_unlock();
 	if (audit_buf != NULL) {
-		if (security_secid_to_secctx(secid,
+		/* lsmblob_init() puts secid into all of the secids in blob.
+		 * security_secid_to_secctx() will know which security module
+		 * to use to create the secctx.  */
+		lsmblob_init(&blob, secid);
+		if (security_secid_to_secctx(&blob,
 					     &secctx,
 					     &secctx_len) == 0) {
 			audit_log_format(audit_buf, " sec_obj=%s", secctx);
@@ -475,6 +480,7 @@ static int netlbl_unlhsh_remove_addr4(struct net *net,
 	struct net_device *dev;
 	char *secctx;
 	u32 secctx_len;
+	struct lsmblob blob;
 
 	spin_lock(&netlbl_unlhsh_lock);
 	list_entry = netlbl_af4list_remove(addr->s_addr, mask->s_addr,
@@ -493,8 +499,13 @@ static int netlbl_unlhsh_remove_addr4(struct net *net,
 					  (dev != NULL ? dev->name : NULL),
 					  addr->s_addr, mask->s_addr);
 		dev_put(dev);
+		/* lsmblob_init() puts entry->secid into all of the secids
+		 * in blob. security_secid_to_secctx() will know which
+		 * security module to use to create the secctx.  */
+		if (entry != NULL)
+			lsmblob_init(&blob, entry->secid);
 		if (entry != NULL &&
-		    security_secid_to_secctx(entry->secid,
+		    security_secid_to_secctx(&blob,
 					     &secctx, &secctx_len) == 0) {
 			audit_log_format(audit_buf, " sec_obj=%s", secctx);
 			security_release_secctx(secctx, secctx_len);
@@ -536,6 +547,7 @@ static int netlbl_unlhsh_remove_addr6(struct net *net,
 	struct net_device *dev;
 	char *secctx;
 	u32 secctx_len;
+	struct lsmblob blob;
 
 	spin_lock(&netlbl_unlhsh_lock);
 	list_entry = netlbl_af6list_remove(addr, mask, &iface->addr6_list);
@@ -553,8 +565,13 @@ static int netlbl_unlhsh_remove_addr6(struct net *net,
 					  (dev != NULL ? dev->name : NULL),
 					  addr, mask);
 		dev_put(dev);
+		/* lsmblob_init() puts entry->secid into all of the secids
+		 * in blob. security_secid_to_secctx() will know which
+		 * security module to use to create the secctx.  */
+		if (entry != NULL)
+			lsmblob_init(&blob, entry->secid);
 		if (entry != NULL &&
-		    security_secid_to_secctx(entry->secid,
+		    security_secid_to_secctx(&blob,
 					     &secctx, &secctx_len) == 0) {
 			audit_log_format(audit_buf, " sec_obj=%s", secctx);
 			security_release_secctx(secctx, secctx_len);
@@ -1080,6 +1097,7 @@ static int netlbl_unlabel_staticlist_gen(u32 cmd,
 	u32 secid;
 	char *secctx;
 	u32 secctx_len;
+	struct lsmblob blob;
 
 	data = genlmsg_put(cb_arg->skb, NETLINK_CB(cb_arg->nl_cb->skb).portid,
 			   cb_arg->seq, &netlbl_unlabel_gnl_family,
@@ -1134,7 +1152,11 @@ static int netlbl_unlabel_staticlist_gen(u32 cmd,
 		secid = addr6->secid;
 	}
 
-	ret_val = security_secid_to_secctx(secid, &secctx, &secctx_len);
+	/* lsmblob_init() secid into all of the secids in blob.
+	 * security_secid_to_secctx() will know which security module
+	 * to use to create the secctx.  */
+	lsmblob_init(&blob, secid);
+	ret_val = security_secid_to_secctx(&blob, &secctx, &secctx_len);
 	if (ret_val != 0)
 		goto list_cb_failure;
 	ret_val = nla_put(cb_arg->skb,
diff --git a/net/netlabel/netlabel_user.c b/net/netlabel/netlabel_user.c
index 3ed4fea2a2de..893301ae0131 100644
--- a/net/netlabel/netlabel_user.c
+++ b/net/netlabel/netlabel_user.c
@@ -86,6 +86,7 @@ struct audit_buffer *netlbl_audit_start_common(int type,
 	struct audit_buffer *audit_buf;
 	char *secctx;
 	u32 secctx_len;
+	struct lsmblob blob;
 
 	if (audit_enabled == AUDIT_OFF)
 		return NULL;
@@ -98,10 +99,9 @@ struct audit_buffer *netlbl_audit_start_common(int type,
 			 from_kuid(&init_user_ns, audit_info->loginuid),
 			 audit_info->sessionid);
 
+	lsmblob_init(&blob, audit_info->secid);
 	if (audit_info->secid != 0 &&
-	    security_secid_to_secctx(audit_info->secid,
-				     &secctx,
-				     &secctx_len) == 0) {
+	    security_secid_to_secctx(&blob, &secctx, &secctx_len) == 0) {
 		audit_log_format(audit_buf, " subj=%s", secctx);
 		security_release_secctx(secctx, secctx_len);
 	}
diff --git a/security/security.c b/security/security.c
index 852aaa05edea..cd3ac0a5673e 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2176,17 +2176,16 @@ int security_ismaclabel(const char *name)
 }
 EXPORT_SYMBOL(security_ismaclabel);
 
-int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
+int security_secid_to_secctx(struct lsmblob *blob, char **secdata, u32 *seclen)
 {
 	struct security_hook_list *hp;
 	int rc;
 
-	/*
-	 * Currently, only one LSM can implement secid_to_secctx (i.e this
-	 * LSM hook is not "stackable").
-	 */
 	hlist_for_each_entry(hp, &security_hook_heads.secid_to_secctx, list) {
-		rc = hp->hook.secid_to_secctx(secid, secdata, seclen);
+		if (WARN_ON(hp->lsmid->slot < 0 || hp->lsmid->slot >= lsm_slot))
+			continue;
+		rc = hp->hook.secid_to_secctx(blob->secid[hp->lsmid->slot],
+					      secdata, seclen);
 		if (rc != LSM_RET_DEFAULT(secid_to_secctx))
 			return rc;
 	}
-- 
2.31.1

