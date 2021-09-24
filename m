Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7FAC417A83
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 20:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347907AbhIXSHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 14:07:39 -0400
Received: from sonic309-27.consmr.mail.ne1.yahoo.com ([66.163.184.153]:37385
        "EHLO sonic309-27.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344425AbhIXSHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 14:07:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1632506759; bh=lF1ziX5gHsSe9ECLJ8VrrXequmqld4YMJ0fxEuwG6B8=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=P8rv/FJjbB4XL7jBlvrQPbu6yal6zIOPdlSi5TVlu560z/Hcq7UGacSzqsDkRaufl6oTfkKdvRLu9KZw6mVDpdYgAFWCjmarjGob7r4uc1Sr+8smLxT0FZ/jx4BWNcdmO2K8vwe71QdirF8HByQeHr2rpF58vOqooQ3yITy5Czfgp0ngsDkQJ+MCHzJiVsEEm65lcyI2vrmqjJ2uLQRdhSHF1vy5un2UENGFcIfQgLcOqAJMnv3hAqots91XNH1oQpP2eJK71AXD9g9cZ/NMD2CM5uIGUYU5gqA3/hPWSYLf2YxDie4DPlht4fGeLaLjWQb65AkSwAvqie2y2Z409g==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1632506759; bh=IidI1bz81wUanKA4KLf6bUe2F4WNKk7TxHk7pH04u7n=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=jSOMdyun9jL6e0jzJ3EYP/AqSoh1az++e/EyVBumxoZDs0q9eiXSmB4usQPzUicJjczAzIxRqUdMnZrUT6GdR+Sy2fHR289MA31K7pSEwzeFbFvvLLdOi/8Dj3AsksTXB8nXFblkiiK9dodh877a43hriqPgcfaXj64+m6XDhUeuLO4N3+yssGw/Wywk6bGUYzgXFblf+PtVwNptggjukxCQ4AE3sJJHs6Ok2zk9TmbcGrMpg5YC8rClqleJvRGNwxev+MmdW2Aqq66y/dJx+oFyo9ELIEwJMxAPV3ARp2PGUzhdUrJ7mvYEnXu9AlUNcbJYIoQJ9et0/GC5kJO4LQ==
X-YMail-OSG: xJ1D3QMVM1mHqVa0G1WVYdCRFBmw4xNAAM5l5cRwJsmgvCc3kd7gsP6nVJyiLXi
 hBX51jqXUXLd7c9zZoiDfk21jR3oD8DuBMRYdrArtik65A5ubIQmZfCO9B6Ala641uorB5O0wvx6
 7shq_0I.KhiQUuc.7.E9UQFGEL4yOp7hNq_oa2oYGFfc2t.fwHnDg_VaT9d1Ax6gaipVCz5yDdXr
 7qHaMi3f1ivOJ0lfYjg.zeIS2m6Sr2g7mixTQAZoKaCVe.TDnC_VJTtHw6SVH4Qg2SjSbRXcYiLp
 jrkLwY3lI_tOThW3iVbvahtNFN5L7kTLDMgHc3Dkk.ZcGFxc0f_SJPAu.Uxo_0fk0ZLDVCfSFh8h
 zyublWco_NgDCKfIRe7ao30TPiOAkxx73INEklE9bWdSu4lqgR3TjomBLqPx46sgAoUb6SYJPDgc
 Ywi4sMvvulePPwgMD7RQuMA_KtMvF95cB3gI_2RKMe9LPpUZkP4bVppP45CAvCKRq39ly3ivOjbs
 Cam6GfcbtX57x58KlRg8asvOxPaPQqpTG49.MHAbst4oMG7F3eljVvNzPFXUYsdlbUBSMPXeB9ry
 6T2ORlNStBSeB_XMkg9gX1ZKARsh4CTngqsXsWsYPy5FTtHKgiXfkPPksSD9IwcHgObFH2629nvY
 xfnqAoZ07MKEiMrUHREGZJO9jjHaZPQZ0VfLDsL8wHI7IVRJ2N90lKXzLudRbdhRY60d7tGMtKs2
 jP_kzOMfPiRwk0B7Hpu5UazS9CHQMAl6VxmS_hkrVZ37rELXR7htwlmLjcQc.3WgekiNo3T1qrQD
 Rmf50CsoLw34gH1c3Nso43UIxvKYyYm05qrlzrZYNu_h7tx5XAjMGfC2ovwxst14hMhOw7pWkxn7
 gRIp9aV7YlzC2e8uTbnTYeyrFOtTx02mvLKRG_meJ9G8NBplO1PWiZLqUx5SuXDTfRcy5VuwBDP8
 bcfAi3wTuqfRHMYmaWPAjGB3t4jjwVV1KuPsEALbXOtef0w2D2GbeDl8ws4eYEQcaZv.ZMos9umu
 bNqf5lTrtDTsSydNK_r25RICi4MVJT1rQ02ITmSyGQnfkTCpGDfbVItnXrHK2AWKSe3aKpfvI2FT
 9s_RzLba.5xuBXrDZFrB0GJhZC_rU3Szv36R8mncnpbtXFA4Dq33Tlv5yecFu4jol6U7XtH9I9p_
 isgUlsvD6uQ7wWpMb_l9wUNeANTkX12n4WCfVsStUw.lqd1a.B5OiJWPxkgkmX1CoPdOoFqCxizk
 hY9h9y9dFwYp1XJOQHiL9Dy2xKOVp1Ykbcaz28c7yBK09G597mZhYgO.ws9Ft8yUq4YlmPuNsmwE
 MScMLVIr49KIC7_Am7zfG3e4vSP.MowMn0uydAffegzoEgWqztiDmfZNDoUIkNcGldgfXECajOoS
 qadBbYu4Taa_PUZYS29kKZX11Ddsg1k9xMv1_grTNZK2wB0zmBVGG95w3ov62Ij6hRxgkwgsePHs
 r03emvWQdWf5gZLX9RfwgD2ncfU8KSMV3DD3Cwd6gZiIbPT6TyZkAQb1FsMqTWL6kUppuwF_mbzk
 yZmSSJZ_cm.d6oS5Fz3f3IwQ9a2CK_hW0Ubt127.DeyJrFRoh70ptd_FbCZAVoms0tVxln2.rzap
 Ag0tFM.GUX1qsRSSVJY0CzFavFZfotGVgkGu.D_aly3lqaE9eVUazFT6Fx1d23auLiW0u3CAyA40
 ia4kK1IuuP7qdYYYOudhFkhj4wQbA8ofAiP1ADhqCURX8UABJ0HmB2J_BH9V2pUEw0Sv4QJd1XST
 RD7akvGq0tLx5qo5NW7KDapp7xE2sME9hM8PEkIqxh4aemHXuJAdoBNnji3S2o0Wuy5s3ihKWRwn
 rNMpvDCQfBc1tnse74nFlV58I7WS6LWlxXpxKzPnSDQfgHpdPQLcRA0z9yuJaaW_euykam1PHy8h
 wmFQN_OtJimhkePQsh6aCr2OYfE.gGXlnFJftmXe0dru6o_I7QGWPbHhs_ubRwVmUAir7o34XZo5
 50O0B56_08cUEBzNApflVEL3wFZCKU29DZcx1AQuqkl3CTJmLdo61NCfI_2C2SuGMk9BjHcqJ3b0
 ytiFrpsz6DMYI.lZsaej3ZGv5eWw__CKLr9RCy7G7VY8DIq2.p2FaZuDbMbDlW968PBAtn8VB0Ma
 R_V_9r9Y26T0GHfD6B0qwaBiYA1NIKNWd7ZvjNGKh663axaYkygPZlets0t88OgHU92EcaxP0Yr0
 F2jBQf77KoKN6Znvym3oh6lpJ5Cfgg6wwZj9PwWB9k9UwNG0KzbLq9_9R4G9vCk3veArQYw4zit1
 8.mj4S9ggV4iyBCoDAW8hbJ9dn7KPNfDj.cNkHSZs.OJdfkJYiVksAx0wrLwRwc7ND_m20ZrKgKs
 6Bxh04gdytFtjiUUFIj6LSyE.CEz8cXceZw--
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.ne1.yahoo.com with HTTP; Fri, 24 Sep 2021 18:05:59 +0000
Received: by kubenode586.mail-prod1.omega.bf1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 8b07f85760cbc40cb575fb1fa28abcbd;
          Fri, 24 Sep 2021 18:05:55 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        linux-integrity@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v29 10/28] LSM: Use lsmblob in security_task_getsecid
Date:   Fri, 24 Sep 2021 10:54:23 -0700
Message-Id: <20210924175441.7943-11-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210924175441.7943-1-casey@schaufler-ca.com>
References: <20210924175441.7943-1-casey@schaufler-ca.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the security_task_getsecid_subj() and
security_task_getsecid_obj() interfaces to fill in
a lsmblob structure instead of a u32 secid in support of
LSM stacking. Audit interfaces will need to collect all
possible secids for possible reporting.

Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: John Johansen <john.johansen@canonical.com>
Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Acked-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-integrity@vger.kernel.org
Cc: linux-audit@redhat.com
Cc: netdev@vger.kernel.org
---
 drivers/android/binder.c              | 12 +-----
 include/linux/security.h              | 14 ++++---
 kernel/audit.c                        | 16 +++-----
 kernel/auditfilter.c                  |  4 +-
 kernel/auditsc.c                      | 25 ++++++------
 net/netlabel/netlabel_unlabeled.c     |  5 ++-
 net/netlabel/netlabel_user.h          |  6 ++-
 security/integrity/ima/ima_appraise.c | 12 +++---
 security/integrity/ima/ima_main.c     | 55 +++++++++++++++------------
 security/security.c                   | 25 +++++++++---
 10 files changed, 94 insertions(+), 80 deletions(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 42bcf22d1e50..d17a34445dcd 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2710,7 +2710,6 @@ static void binder_transaction(struct binder_proc *proc,
 	t->priority = task_nice(current);
 
 	if (target_node && target_node->txn_security_ctx) {
-		u32 secid;
 		struct lsmblob blob;
 		size_t added_size;
 
@@ -2723,16 +2722,7 @@ static void binder_transaction(struct binder_proc *proc,
 		 * here; however, it isn't clear that binder would handle that
 		 * case well anyway.
 		 */
-		security_task_getsecid_obj(proc->tsk, &secid);
-		/*
-		 * Later in this patch set security_task_getsecid() will
-		 * provide a lsmblob instead of a secid. lsmblob_init
-		 * is used to ensure that all the secids in the lsmblob
-		 * get the value returned from security_task_getsecid(),
-		 * which means that the one expected by
-		 * security_secid_to_secctx() will be set.
-		 */
-		lsmblob_init(&blob, secid);
+		security_task_getsecid_obj(proc->tsk, &blob);
 		ret = security_secid_to_secctx(&blob, &secctx, &secctx_sz);
 		if (ret) {
 			return_error = BR_FAILED_REPLY;
diff --git a/include/linux/security.h b/include/linux/security.h
index e674a6cdab46..de70742c30d6 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -501,8 +501,8 @@ int security_task_fix_setgid(struct cred *new, const struct cred *old,
 int security_task_setpgid(struct task_struct *p, pid_t pgid);
 int security_task_getpgid(struct task_struct *p);
 int security_task_getsid(struct task_struct *p);
-void security_task_getsecid_subj(struct task_struct *p, u32 *secid);
-void security_task_getsecid_obj(struct task_struct *p, u32 *secid);
+void security_task_getsecid_subj(struct task_struct *p, struct lsmblob *blob);
+void security_task_getsecid_obj(struct task_struct *p, struct lsmblob *blob);
 int security_task_setnice(struct task_struct *p, int nice);
 int security_task_setioprio(struct task_struct *p, int ioprio);
 int security_task_getioprio(struct task_struct *p);
@@ -1198,14 +1198,16 @@ static inline int security_task_getsid(struct task_struct *p)
 	return 0;
 }
 
-static inline void security_task_getsecid_subj(struct task_struct *p, u32 *secid)
+static inline void security_task_getsecid_subj(struct task_struct *p,
+					       struct lsmblob *blob)
 {
-	*secid = 0;
+	lsmblob_init(blob, 0);
 }
 
-static inline void security_task_getsecid_obj(struct task_struct *p, u32 *secid)
+static inline void security_task_getsecid_obj(struct task_struct *p,
+					      struct lsmblob *blob)
 {
-	*secid = 0;
+	lsmblob_init(blob, 0);
 }
 
 static inline int security_task_setnice(struct task_struct *p, int nice)
diff --git a/kernel/audit.c b/kernel/audit.c
index 22286163e93e..d92c7b894183 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -2139,19 +2139,12 @@ int audit_log_task_context(struct audit_buffer *ab)
 	char *ctx = NULL;
 	unsigned len;
 	int error;
-	u32 sid;
 	struct lsmblob blob;
 
-	security_task_getsecid_subj(current, &sid);
-	if (!sid)
+	security_task_getsecid_subj(current, &blob);
+	if (!lsmblob_is_set(&blob))
 		return 0;
 
-	/*
-	 * lsmblob_init sets all values in the lsmblob to sid.
-	 * This is temporary until security_task_getsecid is converted
-	 * to use a lsmblob, which happens later in this patch set.
-	 */
-	lsmblob_init(&blob, sid);
 	error = security_secid_to_secctx(&blob, &ctx, &len);
 	if (error) {
 		if (error != -EINVAL)
@@ -2359,6 +2352,7 @@ int audit_set_loginuid(kuid_t loginuid)
 int audit_signal_info(int sig, struct task_struct *t)
 {
 	kuid_t uid = current_uid(), auid;
+	struct lsmblob blob;
 
 	if (auditd_test_task(t) &&
 	    (sig == SIGTERM || sig == SIGHUP ||
@@ -2369,7 +2363,9 @@ int audit_signal_info(int sig, struct task_struct *t)
 			audit_sig_uid = auid;
 		else
 			audit_sig_uid = uid;
-		security_task_getsecid_subj(current, &audit_sig_sid);
+		security_task_getsecid_subj(current, &blob);
+		/* scaffolding until audit_sig_sid is converted */
+		audit_sig_sid = blob.secid[0];
 	}
 
 	return audit_signal_info_syscall(t);
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index 6a04d762d272..1ba14a7a38f7 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -1330,7 +1330,6 @@ int audit_filter(int msgtype, unsigned int listtype)
 		for (i = 0; i < e->rule.field_count; i++) {
 			struct audit_field *f = &e->rule.fields[i];
 			pid_t pid;
-			u32 sid;
 			struct lsmblob blob;
 
 			switch (f->type) {
@@ -1362,8 +1361,7 @@ int audit_filter(int msgtype, unsigned int listtype)
 			case AUDIT_SUBJ_CLR:
 				if (f->lsm_isset) {
 					security_task_getsecid_subj(current,
-								    &sid);
-					lsmblob_init(&blob, sid);
+								    &blob);
 					result = security_audit_rule_match(
 						   &blob, f->type, f->op,
 						   f->lsm_rules);
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index b4d214b21b97..50e3f2f4cb49 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -477,7 +477,6 @@ static int audit_filter_rules(struct task_struct *tsk,
 {
 	const struct cred *cred;
 	int i, need_sid = 1;
-	u32 sid;
 	struct lsmblob blob;
 	unsigned int sessionid;
 
@@ -674,17 +673,9 @@ static int audit_filter_rules(struct task_struct *tsk,
 			   logged upon error */
 			if (f->lsm_isset) {
 				if (need_sid) {
-					security_task_getsecid_subj(tsk, &sid);
+					security_task_getsecid_subj(tsk, &blob);
 					need_sid = 0;
 				}
-				/*
-				 * lsmblob_init sets all values in the lsmblob
-				 * to sid. This is temporary until
-				 * security_task_getsecid() is converted to
-				 * provide a lsmblob, which happens later in
-				 * this patch set.
-				 */
-				lsmblob_init(&blob, sid);
 				result = security_audit_rule_match(&blob,
 							f->type, f->op,
 							f->lsm_rules);
@@ -2439,12 +2430,15 @@ int __audit_sockaddr(int len, void *a)
 void __audit_ptrace(struct task_struct *t)
 {
 	struct audit_context *context = audit_context();
+	struct lsmblob blob;
 
 	context->target_pid = task_tgid_nr(t);
 	context->target_auid = audit_get_loginuid(t);
 	context->target_uid = task_uid(t);
 	context->target_sessionid = audit_get_sessionid(t);
-	security_task_getsecid_obj(t, &context->target_sid);
+	security_task_getsecid_obj(t, &blob);
+	/* scaffolding - until target_sid is converted */
+	context->target_sid = blob.secid[0];
 	memcpy(context->target_comm, t->comm, TASK_COMM_LEN);
 }
 
@@ -2460,6 +2454,7 @@ int audit_signal_info_syscall(struct task_struct *t)
 	struct audit_aux_data_pids *axp;
 	struct audit_context *ctx = audit_context();
 	kuid_t t_uid = task_uid(t);
+	struct lsmblob blob;
 
 	if (!audit_signals || audit_dummy_context())
 		return 0;
@@ -2471,7 +2466,9 @@ int audit_signal_info_syscall(struct task_struct *t)
 		ctx->target_auid = audit_get_loginuid(t);
 		ctx->target_uid = t_uid;
 		ctx->target_sessionid = audit_get_sessionid(t);
-		security_task_getsecid_obj(t, &ctx->target_sid);
+		security_task_getsecid_obj(t, &blob);
+		/* scaffolding until target_sid is converted */
+		ctx->target_sid = blob.secid[0];
 		memcpy(ctx->target_comm, t->comm, TASK_COMM_LEN);
 		return 0;
 	}
@@ -2492,7 +2489,9 @@ int audit_signal_info_syscall(struct task_struct *t)
 	axp->target_auid[axp->pid_count] = audit_get_loginuid(t);
 	axp->target_uid[axp->pid_count] = t_uid;
 	axp->target_sessionid[axp->pid_count] = audit_get_sessionid(t);
-	security_task_getsecid_obj(t, &axp->target_sid[axp->pid_count]);
+	security_task_getsecid_obj(t, &blob);
+	/* scaffolding until target_sid is converted */
+	axp->target_sid[axp->pid_count] = blob.secid[0];
 	memcpy(axp->target_comm[axp->pid_count], t->comm, TASK_COMM_LEN);
 	axp->pid_count++;
 
diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index 51cb4fce5edf..15b53fc4e83f 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -1562,11 +1562,14 @@ int __init netlbl_unlabel_defconf(void)
 	int ret_val;
 	struct netlbl_dom_map *entry;
 	struct netlbl_audit audit_info;
+	struct lsmblob blob;
 
 	/* Only the kernel is allowed to call this function and the only time
 	 * it is called is at bootup before the audit subsystem is reporting
 	 * messages so don't worry to much about these values. */
-	security_task_getsecid_subj(current, &audit_info.secid);
+	security_task_getsecid_subj(current, &blob);
+	/* scaffolding until audit_info.secid is converted */
+	audit_info.secid = blob.secid[0];
 	audit_info.loginuid = GLOBAL_ROOT_UID;
 	audit_info.sessionid = 0;
 
diff --git a/net/netlabel/netlabel_user.h b/net/netlabel/netlabel_user.h
index 6190cbf94bf0..aa31f7bf79ee 100644
--- a/net/netlabel/netlabel_user.h
+++ b/net/netlabel/netlabel_user.h
@@ -32,7 +32,11 @@
  */
 static inline void netlbl_netlink_auditinfo(struct netlbl_audit *audit_info)
 {
-	security_task_getsecid_subj(current, &audit_info->secid);
+	struct lsmblob blob;
+
+	security_task_getsecid_subj(current, &blob);
+	/* scaffolding until secid is converted */
+	audit_info->secid = blob.secid[0];
 	audit_info->loginuid = audit_get_loginuid(current);
 	audit_info->sessionid = audit_get_sessionid(current);
 }
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index dbba51583e7c..2fedda131a39 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -71,15 +71,17 @@ bool is_ima_appraise_enabled(void)
 int ima_must_appraise(struct user_namespace *mnt_userns, struct inode *inode,
 		      int mask, enum ima_hooks func)
 {
-	u32 secid;
+	struct lsmblob blob;
 
 	if (!ima_appraise)
 		return 0;
 
-	security_task_getsecid_subj(current, &secid);
-	return ima_match_policy(mnt_userns, inode, current_cred(), secid,
-				func, mask, IMA_APPRAISE | IMA_HASH, NULL,
-				NULL, NULL, NULL);
+	security_task_getsecid_subj(current, &blob);
+	/* scaffolding the .secid[0] */
+	return ima_match_policy(mnt_userns, inode, current_cred(),
+				blob.secid[0], func, mask,
+				IMA_APPRAISE | IMA_HASH, NULL, NULL, NULL,
+				NULL);
 }
 
 static int ima_fix_xattr(struct dentry *dentry,
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 465865412100..c327f93d3962 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -405,12 +405,13 @@ static int process_measurement(struct file *file, const struct cred *cred,
  */
 int ima_file_mmap(struct file *file, unsigned long prot)
 {
-	u32 secid;
+	struct lsmblob blob;
 
 	if (file && (prot & PROT_EXEC)) {
-		security_task_getsecid_subj(current, &secid);
-		return process_measurement(file, current_cred(), secid, NULL,
-					   0, MAY_EXEC, MMAP_CHECK);
+		security_task_getsecid_subj(current, &blob);
+		/* scaffolding - until process_measurement changes */
+		return process_measurement(file, current_cred(), blob.secid[0],
+					   NULL, 0, MAY_EXEC, MMAP_CHECK);
 	}
 
 	return 0;
@@ -436,9 +437,9 @@ int ima_file_mprotect(struct vm_area_struct *vma, unsigned long prot)
 	char *pathbuf = NULL;
 	const char *pathname = NULL;
 	struct inode *inode;
+	struct lsmblob blob;
 	int result = 0;
 	int action;
-	u32 secid;
 	int pcr;
 
 	/* Is mprotect making an mmap'ed file executable? */
@@ -446,11 +447,11 @@ int ima_file_mprotect(struct vm_area_struct *vma, unsigned long prot)
 	    !(prot & PROT_EXEC) || (vma->vm_flags & VM_EXEC))
 		return 0;
 
-	security_task_getsecid_subj(current, &secid);
+	security_task_getsecid_subj(current, &blob);
 	inode = file_inode(vma->vm_file);
 	action = ima_get_action(file_mnt_user_ns(vma->vm_file), inode,
-				current_cred(), secid, MAY_EXEC, MMAP_CHECK,
-				&pcr, &template, NULL, NULL);
+				current_cred(), blob.secid[0], MAY_EXEC,
+				MMAP_CHECK, &pcr, &template, NULL, NULL);
 
 	/* Is the mmap'ed file in policy? */
 	if (!(action & (IMA_MEASURE | IMA_APPRAISE_SUBMASK)))
@@ -486,10 +487,12 @@ int ima_bprm_check(struct linux_binprm *bprm)
 {
 	int ret;
 	u32 secid;
+	struct lsmblob blob;
 
-	security_task_getsecid_subj(current, &secid);
-	ret = process_measurement(bprm->file, current_cred(), secid, NULL, 0,
-				  MAY_EXEC, BPRM_CHECK);
+	security_task_getsecid_subj(current, &blob);
+	/* scaffolding until process_measurement changes */
+	ret = process_measurement(bprm->file, current_cred(), blob.secid[0],
+				  NULL, 0, MAY_EXEC, BPRM_CHECK);
 	if (ret)
 		return ret;
 
@@ -510,10 +513,11 @@ int ima_bprm_check(struct linux_binprm *bprm)
  */
 int ima_file_check(struct file *file, int mask)
 {
-	u32 secid;
+	struct lsmblob blob;
 
-	security_task_getsecid_subj(current, &secid);
-	return process_measurement(file, current_cred(), secid, NULL, 0,
+	security_task_getsecid_subj(current, &blob);
+	/* scaffolding until process_measurement changes */
+	return process_measurement(file, current_cred(), blob.secid[0], NULL, 0,
 				   mask & (MAY_READ | MAY_WRITE | MAY_EXEC |
 					   MAY_APPEND), FILE_CHECK);
 }
@@ -689,7 +693,7 @@ int ima_read_file(struct file *file, enum kernel_read_file_id read_id,
 		  bool contents)
 {
 	enum ima_hooks func;
-	u32 secid;
+	struct lsmblob blob;
 
 	/*
 	 * Do devices using pre-allocated memory run the risk of the
@@ -709,8 +713,9 @@ int ima_read_file(struct file *file, enum kernel_read_file_id read_id,
 
 	/* Read entire file for all partial reads. */
 	func = read_idmap[read_id] ?: FILE_CHECK;
-	security_task_getsecid_subj(current, &secid);
-	return process_measurement(file, current_cred(), secid, NULL,
+	security_task_getsecid_subj(current, &blob);
+	/* scaffolding - until process_measurement changes */
+	return process_measurement(file, current_cred(), blob.secid[0], NULL,
 				   0, MAY_READ, func);
 }
 
@@ -739,7 +744,7 @@ int ima_post_read_file(struct file *file, void *buf, loff_t size,
 		       enum kernel_read_file_id read_id)
 {
 	enum ima_hooks func;
-	u32 secid;
+	struct lsmblob blob;
 
 	/* permit signed certs */
 	if (!file && read_id == READING_X509_CERTIFICATE)
@@ -752,9 +757,10 @@ int ima_post_read_file(struct file *file, void *buf, loff_t size,
 	}
 
 	func = read_idmap[read_id] ?: FILE_CHECK;
-	security_task_getsecid_subj(current, &secid);
-	return process_measurement(file, current_cred(), secid, buf, size,
-				   MAY_READ, func);
+	security_task_getsecid_subj(current, &blob);
+	/* scaffolding until process_measurement changes */
+	return process_measurement(file, current_cred(), blob.secid[0], buf,
+				   size, MAY_READ, func);
 }
 
 /**
@@ -882,7 +888,7 @@ int process_buffer_measurement(struct user_namespace *mnt_userns,
 	int digest_hash_len = hash_digest_size[ima_hash_algo];
 	int violation = 0;
 	int action = 0;
-	u32 secid;
+	struct lsmblob blob;
 
 	if (digest && digest_len < digest_hash_len)
 		return -EINVAL;
@@ -905,9 +911,10 @@ int process_buffer_measurement(struct user_namespace *mnt_userns,
 	 * buffer measurements.
 	 */
 	if (func) {
-		security_task_getsecid_subj(current, &secid);
+		security_task_getsecid_subj(current, &blob);
+		/* scaffolding */
 		action = ima_get_action(mnt_userns, inode, current_cred(),
-					secid, 0, func, &pcr, &template,
+					blob.secid[0], 0, func, &pcr, &template,
 					func_data, NULL);
 		if (!(action & IMA_MEASURE) && !digest)
 			return -ENOENT;
diff --git a/security/security.c b/security/security.c
index f6760b25fed0..74a7fb981904 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1905,17 +1905,30 @@ int security_task_getsid(struct task_struct *p)
 	return call_int_hook(task_getsid, 0, p);
 }
 
-void security_task_getsecid_subj(struct task_struct *p, u32 *secid)
+void security_task_getsecid_subj(struct task_struct *p, struct lsmblob *blob)
 {
-	*secid = 0;
-	call_void_hook(task_getsecid_subj, p, secid);
+	struct security_hook_list *hp;
+
+	lsmblob_init(blob, 0);
+	hlist_for_each_entry(hp, &security_hook_heads.task_getsecid_subj,
+			     list) {
+		if (WARN_ON(hp->lsmid->slot < 0 || hp->lsmid->slot >= lsm_slot))
+			continue;
+		hp->hook.task_getsecid_subj(p, &blob->secid[hp->lsmid->slot]);
+	}
 }
 EXPORT_SYMBOL(security_task_getsecid_subj);
 
-void security_task_getsecid_obj(struct task_struct *p, u32 *secid)
+void security_task_getsecid_obj(struct task_struct *p, struct lsmblob *blob)
 {
-	*secid = 0;
-	call_void_hook(task_getsecid_obj, p, secid);
+	struct security_hook_list *hp;
+
+	lsmblob_init(blob, 0);
+	hlist_for_each_entry(hp, &security_hook_heads.task_getsecid_obj, list) {
+		if (WARN_ON(hp->lsmid->slot < 0 || hp->lsmid->slot >= lsm_slot))
+			continue;
+		hp->hook.task_getsecid_obj(p, &blob->secid[hp->lsmid->slot]);
+	}
 }
 EXPORT_SYMBOL(security_task_getsecid_obj);
 
-- 
2.31.1

