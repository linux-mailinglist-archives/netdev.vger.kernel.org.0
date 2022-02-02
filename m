Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF7634A7C4C
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 01:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbiBCAGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 19:06:30 -0500
Received: from sonic312-31.consmr.mail.ne1.yahoo.com ([66.163.191.212]:42663
        "EHLO sonic312-31.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231561AbiBCAG3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 19:06:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1643846789; bh=EqNFDQMugZeGYTvYoJQnN0P9iZgp/6AR/4bWKU98LdQ=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=bXmTrmbedLLJ2Ut1FtaOw3ZOFk6d0E+1MFi944Sr25P0uQZhBsAI9tmCqg4e+BlE7l12ul6N5PfLAKYOiFikeVHD7eW4Z01OBqpb0mGw3Of2uXHhdfzBAZ1oxyv1JcZ42JRqNgdwAPQS6JbnrpHfjWDUzP2zGZsmansICQPZwNX49FvnOeIljsIkJyr+Ejkx8pyPAbGZNhHMTERlDMRjw1jkBXSEjli2F7EHps8sqsxNxuU+gM6NgZLrrV5pahJOEH67j1Ay6aU9YpS2x8DuG0C1Zo+fE5yDgzRN+PzRUKO1O1azB1L5HC5+yWqDq5m2Fi3NLuC2eZ84fYALOasfmA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1643846789; bh=gCTTO8q6tJuTejmmTs4I26sZpe886BpjN8Cmdfr9NqS=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=U1lc08X1JrjeVyqPS8PFInm8cdz+lwZ/gzVeinbXlHgOMf/2l3MUoZ5O4YN6FiVqKdJBg4ssVRNckkayYBDEsvTKhX4n32LnA+VN2pRrsQJbZ4ZnDawZ2uWXumPCilcJAfEGJELl70mE8X/2TwmstsveecNsnbo+kBDfz87XvkWSTzBFe7VZgRKNddMKtbrlZZ+vl1Yy5yBEgtdH0lnWABv0odg98AkIfDFWQMRGQYSHT2/AyX44zpLiMRenciu9nt1JrsSpvliDQDVZZ4Pde7gxmh0qS3sCIEzG3b1WG0nV4NPsc1V8Q4izU4Tx6+Km3418sgXSTHoIS5fqmT4sNg==
X-YMail-OSG: DtT5mAcVM1mKx30D2vmR_TtRmwlhNHlZBskSVZW2bEhNHBUDMR_Zb8HXt7ArkV2
 OPIsKGqFFgobglSKNMmStyXp0ELbFS0Wpe_hCPmCKifXUxQ8604sM9u6UU.M91eJcyQNX6eJwRMO
 _BjhmtPMxi6GZ3XFqHdaX8oJbiAMzX0LoKaiB0T1mSAbW2_QnobbNdKYl3isBqD075n8nyIZOoX2
 Xk2d86hCLeh5iTG72P5a._0B69nyumfpHwGftI4H91QfD9XmciBo856EDbEhMZsIjiHiZc5ZGeFh
 1y0QPTMGGsPzy.ZHj4TnfDqXE4i.hcOFkTnjZSlig540KXQI_FSUZKaQc1Ci0qqXwUP1DB8gFq.B
 NeaT2GTYt0vuDB7LNUvCicOQUOkma5lRjbK67GEQRQ2C63VT1GmIwC8o9nT57e4fZVR90P45fGj6
 Zye5jEKAIOmTAxjbsVeqnV7fKfou9FESDZqi_4H3Nr9.gGCe1iKSU2WiP4gTr1Q2M7gXB.4U8By_
 pGLxrTlsjvafzs5xoM.RbkqK87ktc4wjY9dNKzWS3UjKR24aQBJIofuZy3EXUMdlpHJHEONLvrRC
 HdsF50.7cAZT6Jbpfqcv7Z3TJrk_58jYsnbPA0fcykMWXz6Q0tV9ptLVdI.nWZa6jf4EpYcXMDvI
 I9L9qp4Dlv5M3N6U1RFYe4PG5mWALqfrByHfc_4adqDDxCpkSH6OtN3GMSRptPJlpbMfn7QB.6On
 oNPknGvobsbbILcOhmQT7Wl9mepZF0ZbQIySYuyo85klzBcPz.pjkP80sTvng0eCF.0J8DGS_RRx
 HVb2Cn35vrfXBPfqVd237CHB66.DdPDRfGL434qAZkxlg86yLzdlF5wjS0PnZ4.GE.ronQbPA7Uq
 .MZhu.r.Xe4I4PjbhgkZb2GTrDoY4pCz7fRDZANi_6OzGI86IJSkt6AGPrAKD3V68iVDROyKqoQ_
 UqokZCMbqjKEziYX.y95zMzWA_r9lpv4EcRlHSOqE.hkgYT6nv6Dvnr1gmqCsZ7dgtRIs1Ldv4sV
 n9zbR48cx6eB1k1Mcu7BKd7RkRf8CWarrml7f1oWOTBXFjEk.3mhqsLwVWWanUFtkRi6Q8dCf034
 sXcl5t7Aui8DvON2910ZjJBvIizuw17QtFFGtyBzf4XackaIMjtzOwx25Ltr57mvdv1udFpKRRct
 KWG3Sm8LyEPHyqaIxYXch3o8bPz9TkBUB6xM8m9.j_HJrtCGjqrBWGKBp.WyFW66uoyzkDHVLCXo
 vHE3KyRYqkBa8981ciO90mBSUfqul128vaW2V8utH3b4SZjsUOLWpnSqnxstPSVM68MMkbzbfzOJ
 z3DsbGy4zW.SdsWvkO7L5cz4LZ6kXG0.ok7MSaAAeZLzKOpdN3h4LKw4dEzHeLeb6..ndWnJljLD
 iFgeBM91lKxXnzgN4Q0D1musB7Tztz1vIrukvaImcqW3MqhZvEAZdMqd2Tv953tvOe_9Cy4CDrJq
 oqyfGZM8_ynUkSSMtVPBUZhE2v9_itP9OwxkrfE4Du4IG1itteOHS3oWP2TYb64l2tKqB2LUzYfO
 Fej20.Am5Fdpf4ddFdGesmROe2KFgfWxL7P5kSNrzV1prXjH4z2.IaLDXASeRWN0Gf.vwS1ssWiz
 _syz3jNfutbYzBSd0Q5VjHUFeIg1.Bx_iP5G1VYTEviRMK3zN8o5kBLw_kCtpFQYaUAcLrub_YqQ
 uef.t38pXmzvP1vsPsQu1F3C.YvM_DNK4e1vnDRgaoxYdzDLevhKvGlv_mrT7HXEdqntGRY86q5K
 oBQyJTzlnWBkZumCnvLH_LeePXbKlafNBdVeFkb3ihjzmgaAXFHBRbjACx72ny1zX854mcvu26bu
 33QJfVZsO48cBOVzoAE3jlOoeoqjGPBhqi6sASIPWfKbLf.LVaN.Oi37HQxxXFGRhI2nH_HYhJHd
 ClgNEGVCfMrstun.pKacG7ql2xSckcvdk40QzJQYNqe9EHheUxmiKFVZYaWBIYzOjn3Ui8cq.Cl9
 fvzF.MuycZ1hKEvwLLJX_IS_dfY3DuwWvY2JFJfI7pr4eGTfuhX8ZvHcOsznr3clsoclcsGhamYG
 IkNl9pQt.twmdS_413ZXPApcdHAD2O1aAAeJ2HtXf_NAahG8eDWEYsKTFW70mIx.L3DkPtIjFmoq
 piHb2q7GO3eNDtuAvSd8oVgKZZgcmf4t129fLRALZ50RqRmvaFBgMwu3cADnVgod75oEYnmai2M8
 EjGaqqcTynFSFfudp08_bK78R9Py2XYw0nbK61c7Cnlxnm6IaEP7o10RrilIKxPdrLFPMp5J7JOD
 9t70D_Q3becMfxavIJXREisICXOmFZBDTFyCAod9QwdGNecAnsshXf6Jufg--
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic312.consmr.mail.ne1.yahoo.com with HTTP; Thu, 3 Feb 2022 00:06:29 +0000
Received: by kubenode531.mail-prod1.omega.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID eb829be640f0d55663e1620f1812a18c;
          Thu, 03 Feb 2022 00:06:26 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        linux-integrity@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v32 11/28] LSM: Use lsmblob in security_current_getsecid
Date:   Wed,  2 Feb 2022 15:53:06 -0800
Message-Id: <20220202235323.23929-12-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220202235323.23929-1-casey@schaufler-ca.com>
References: <20220202235323.23929-1-casey@schaufler-ca.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the security_current_getsecid_subj() and
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
 drivers/android/binder.c              |  6 +--
 include/linux/security.h              | 13 ++++---
 kernel/audit.c                        | 16 +++-----
 kernel/auditfilter.c                  |  4 +-
 kernel/auditsc.c                      | 25 ++++++------
 net/netlabel/netlabel_unlabeled.c     |  5 ++-
 net/netlabel/netlabel_user.h          |  6 ++-
 security/integrity/ima/ima_appraise.c | 12 +++---
 security/integrity/ima/ima_main.c     | 55 +++++++++++++++------------
 security/security.c                   | 25 +++++++++---
 10 files changed, 95 insertions(+), 72 deletions(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 381a4fddd4a5..bae8440ffc73 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2980,16 +2980,16 @@ static void binder_transaction(struct binder_proc *proc,
 	t->priority = task_nice(current);
 
 	if (target_node && target_node->txn_security_ctx) {
-		u32 secid;
 		struct lsmblob blob;
 		size_t added_size;
+		u32 secid;
 
 		security_cred_getsecid(proc->cred, &secid);
 		/*
-		 * Later in this patch set security_task_getsecid() will
+		 * Later in this patch set security_cred_getsecid() will
 		 * provide a lsmblob instead of a secid. lsmblob_init
 		 * is used to ensure that all the secids in the lsmblob
-		 * get the value returned from security_task_getsecid(),
+		 * get the value returned from security_cred_getsecid(),
 		 * which means that the one expected by
 		 * security_secid_to_secctx() will be set.
 		 */
diff --git a/include/linux/security.h b/include/linux/security.h
index 62178dd4ec08..d7781bda147f 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -501,8 +501,8 @@ int security_task_fix_setgid(struct cred *new, const struct cred *old,
 int security_task_setpgid(struct task_struct *p, pid_t pgid);
 int security_task_getpgid(struct task_struct *p);
 int security_task_getsid(struct task_struct *p);
-void security_current_getsecid_subj(u32 *secid);
-void security_task_getsecid_obj(struct task_struct *p, u32 *secid);
+void security_current_getsecid_subj(struct lsmblob *blob);
+void security_task_getsecid_obj(struct task_struct *p, struct lsmblob *blob);
 int security_task_setnice(struct task_struct *p, int nice);
 int security_task_setioprio(struct task_struct *p, int ioprio);
 int security_task_getioprio(struct task_struct *p);
@@ -1198,14 +1198,15 @@ static inline int security_task_getsid(struct task_struct *p)
 	return 0;
 }
 
-static inline void security_current_getsecid_subj(u32 *secid)
+static inline void security_current_getsecid_subj(struct lsmblob *blob)
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
index 40d8cb824eae..17ac6e74b5bd 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -2154,19 +2154,12 @@ int audit_log_task_context(struct audit_buffer *ab)
 	char *ctx = NULL;
 	unsigned len;
 	int error;
-	u32 sid;
 	struct lsmblob blob;
 
-	security_current_getsecid_subj(&sid);
-	if (!sid)
+	security_current_getsecid_subj(&blob);
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
@@ -2375,6 +2368,7 @@ int audit_set_loginuid(kuid_t loginuid)
 int audit_signal_info(int sig, struct task_struct *t)
 {
 	kuid_t uid = current_uid(), auid;
+	struct lsmblob blob;
 
 	if (auditd_test_task(t) &&
 	    (sig == SIGTERM || sig == SIGHUP ||
@@ -2385,7 +2379,9 @@ int audit_signal_info(int sig, struct task_struct *t)
 			audit_sig_uid = auid;
 		else
 			audit_sig_uid = uid;
-		security_current_getsecid_subj(&audit_sig_sid);
+		security_current_getsecid_subj(&blob);
+		/* scaffolding until audit_sig_sid is converted */
+		audit_sig_sid = blob.secid[0];
 	}
 
 	return audit_signal_info_syscall(t);
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index 15cd4fe35e9c..39ded5cb2429 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -1339,7 +1339,6 @@ int audit_filter(int msgtype, unsigned int listtype)
 			struct audit_field *f = &e->rule.fields[i];
 			struct lsmblob blob;
 			pid_t pid;
-			u32 sid;
 
 			switch (f->type) {
 			case AUDIT_PID:
@@ -1369,8 +1368,7 @@ int audit_filter(int msgtype, unsigned int listtype)
 			case AUDIT_SUBJ_SEN:
 			case AUDIT_SUBJ_CLR:
 				if (f->lsm_str) {
-					security_current_getsecid_subj(&sid);
-					lsmblob_init(&blob, sid);
+					security_current_getsecid_subj(&blob);
 					result = security_audit_rule_match(
 						   &blob, f->type, f->op,
 						   &f->lsm_rules);
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 598e0de45b04..2570bf5979e0 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -467,7 +467,6 @@ static int audit_filter_rules(struct task_struct *tsk,
 {
 	const struct cred *cred;
 	int i, need_sid = 1;
-	u32 sid;
 	struct lsmblob blob;
 	unsigned int sessionid;
 
@@ -676,17 +675,9 @@ static int audit_filter_rules(struct task_struct *tsk,
 					 * here even though it always refs
 					 * @current's creds
 					 */
-					security_current_getsecid_subj(&sid);
+					security_current_getsecid_subj(&blob);
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
 							&f->lsm_rules);
@@ -2712,12 +2703,15 @@ int __audit_sockaddr(int len, void *a)
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
 
@@ -2733,6 +2727,7 @@ int audit_signal_info_syscall(struct task_struct *t)
 	struct audit_aux_data_pids *axp;
 	struct audit_context *ctx = audit_context();
 	kuid_t t_uid = task_uid(t);
+	struct lsmblob blob;
 
 	if (!audit_signals || audit_dummy_context())
 		return 0;
@@ -2744,7 +2739,9 @@ int audit_signal_info_syscall(struct task_struct *t)
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
@@ -2765,7 +2762,9 @@ int audit_signal_info_syscall(struct task_struct *t)
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
index 0a99663e6edb..c86df6ead742 100644
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
-	security_current_getsecid_subj(&audit_info.secid);
+	security_current_getsecid_subj(&blob);
+	/* scaffolding until audit_info.secid is converted */
+	audit_info.secid = blob.secid[0];
 	audit_info.loginuid = GLOBAL_ROOT_UID;
 	audit_info.sessionid = 0;
 
diff --git a/net/netlabel/netlabel_user.h b/net/netlabel/netlabel_user.h
index d6c5b31eb4eb..3d5610ed5f0e 100644
--- a/net/netlabel/netlabel_user.h
+++ b/net/netlabel/netlabel_user.h
@@ -32,7 +32,11 @@
  */
 static inline void netlbl_netlink_auditinfo(struct netlbl_audit *audit_info)
 {
-	security_current_getsecid_subj(&audit_info->secid);
+	struct lsmblob blob;
+
+	security_current_getsecid_subj(&blob);
+	/* scaffolding until secid is converted */
+	audit_info->secid = blob.secid[0];
 	audit_info->loginuid = audit_get_loginuid(current);
 	audit_info->sessionid = audit_get_sessionid(current);
 }
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 17232bbfb9f9..217d20c60e1d 100644
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
 
-	security_current_getsecid_subj(&secid);
-	return ima_match_policy(mnt_userns, inode, current_cred(), secid,
-				func, mask, IMA_APPRAISE | IMA_HASH, NULL,
-				NULL, NULL, NULL);
+	security_current_getsecid_subj(&blob);
+	/* scaffolding the .secid[0] */
+	return ima_match_policy(mnt_userns, inode, current_cred(),
+				blob.secid[0], func, mask,
+				IMA_APPRAISE | IMA_HASH, NULL, NULL, NULL,
+				NULL);
 }
 
 static int ima_fix_xattr(struct dentry *dentry,
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 8c6e4514d494..6abbaa97bbeb 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -405,12 +405,13 @@ static int process_measurement(struct file *file, const struct cred *cred,
  */
 int ima_file_mmap(struct file *file, unsigned long prot)
 {
-	u32 secid;
+	struct lsmblob blob;
 
 	if (file && (prot & PROT_EXEC)) {
-		security_current_getsecid_subj(&secid);
-		return process_measurement(file, current_cred(), secid, NULL,
-					   0, MAY_EXEC, MMAP_CHECK);
+		security_current_getsecid_subj(&blob);
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
 
-	security_current_getsecid_subj(&secid);
+	security_current_getsecid_subj(&blob);
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
 
-	security_current_getsecid_subj(&secid);
-	ret = process_measurement(bprm->file, current_cred(), secid, NULL, 0,
-				  MAY_EXEC, BPRM_CHECK);
+	security_current_getsecid_subj(&blob);
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
 
-	security_current_getsecid_subj(&secid);
-	return process_measurement(file, current_cred(), secid, NULL, 0,
+	security_current_getsecid_subj(&blob);
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
-	security_current_getsecid_subj(&secid);
-	return process_measurement(file, current_cred(), secid, NULL,
+	security_current_getsecid_subj(&blob);
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
-	security_current_getsecid_subj(&secid);
-	return process_measurement(file, current_cred(), secid, buf, size,
-				   MAY_READ, func);
+	security_current_getsecid_subj(&blob);
+	/* scaffolding - until process_measurement changes */
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
-		security_current_getsecid_subj(&secid);
+		security_current_getsecid_subj(&blob);
+		/* scaffolding */
 		action = ima_get_action(mnt_userns, inode, current_cred(),
-					secid, 0, func, &pcr, &template,
+					blob.secid[0], 0, func, &pcr, &template,
 					func_data, NULL);
 		if (!(action & IMA_MEASURE) && !digest)
 			return -ENOENT;
diff --git a/security/security.c b/security/security.c
index 815200684bcf..e33fa677181d 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1909,17 +1909,30 @@ int security_task_getsid(struct task_struct *p)
 	return call_int_hook(task_getsid, 0, p);
 }
 
-void security_current_getsecid_subj(u32 *secid)
+void security_current_getsecid_subj(struct lsmblob *blob)
 {
-	*secid = 0;
-	call_void_hook(current_getsecid_subj, secid);
+	struct security_hook_list *hp;
+
+	lsmblob_init(blob, 0);
+	hlist_for_each_entry(hp, &security_hook_heads.current_getsecid_subj,
+			     list) {
+		if (WARN_ON(hp->lsmid->slot < 0 || hp->lsmid->slot >= lsm_slot))
+			continue;
+		hp->hook.current_getsecid_subj(&blob->secid[hp->lsmid->slot]);
+	}
 }
 EXPORT_SYMBOL(security_current_getsecid_subj);
 
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

