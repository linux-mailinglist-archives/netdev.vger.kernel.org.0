Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC7A5457EE
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 01:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345866AbiFIXG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 19:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241049AbiFIXGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 19:06:55 -0400
Received: from sonic308-16.consmr.mail.ne1.yahoo.com (sonic308-16.consmr.mail.ne1.yahoo.com [66.163.187.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BFA73AE819
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 16:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1654816010; bh=qiW1yV5f9ANJJqC5KoOG/KftqckkY8ixFX0Qx5G3hEY=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=OltRWRwPyeEAJAVHx6JshOHFECancEVfDuBjWl+5ERxnmMpSHvDIhvsECRALbw88DZKB0cKQED/v2Cvw/f0UvbzF7txO71hUbqPsC9/PDZ20nUryT/BosP9xZnXXVZzksex/BTy/Y/cdtE4cnyOiDT4z0EGY2+WpSk0YI3MA2HeHufW0c/pVFMH1SsWWVZcNsK/Rb1hc9zSbR1OPKfYvLVIE36uMBZKUctf+oQi5q2714XrB8zTzcNy58JCBFmahUm0cQgiE4Nm201NUmldsWqbqxsGwlZibUnY3pUpoxsPj0lW/WlBnMo79R7bABf1bfxVHsOL+eHJsxNCoTJzcbQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1654816010; bh=7Ofc497974l5RuZBFERq7xVI0b4WVtaIGA2et/OERb7=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=XnRIBSg0AWh2b1yw8f+Ulvgw7+RY8vxIvqCQ1GIMBjJ9FpzpYWzvlSU/HQ4COYLoZTMfUVlUWOQVa8EhISJvWH66idyJji//SJFwBlfKGZAHwl8B03xU76q8ZVak3wFFjiZJ4SH1wePZhsa22NZNQ09ScZ9G4G+h977Jyckk19LQyeHWI0KgqfGuyjfciWBTK4SYf1OQ2tOmj7W8FXknl7vo3bxzb+YOFdbYg7j0bB3AJT/2x+e140P/atWjul9PKq5DVb5euVEFdz3dk9GY6xkEwmIncSRhtCpn7h/HSowOZC3si37uLzhI1SBLgV5Ke7C6BYNyCWLLNCxpe8z7Eg==
X-YMail-OSG: L.dzM1cVM1lXyC6oMeacXhsClYVMEfXAsFbL.AlfjQa5DapRi2gO7XILeS9Y_On
 Wcu5PAfAHeIR25.Ko7QWrMnZ2EmarrPGT1jB8UKuKi1Uv3Z80MWzoW70Q2SGsyF2vz6h1OpAZRcH
 AhfIHN5yHfh4UxAr5ZFoGr5O.ijsHacToO0IHjcAeWLLoPuntbYEwOYs5dh2KUw1MnRlhhK_sUKP
 yWY_wibUyaMqZI2_ru.szkEPHe6qhhEnecddnG6gqN78xMCYYRbzBK9B304r0lkvEMf7MAV_1Gm2
 PRQBxu6Thoe2bhQB0hwJpVO2TPBLbznY8kz6unqRGZPi_SmcchRT_XnwPBS8OVc8n7sQALr0x4Ee
 v_dTnTAk4DRbF_O0Xzp3yh5hLJtXdvkWGT.YE5Qb1orMs_jGD.JRiYw1.w7lTihSy2zk51QUn1wN
 GgK9piWrSwvlQAE.VY0ZwcRV.1n5p0yYNjYIADLPVT0Ws4kHsdnjxb_wubvtvX_9G7faz_oGjW2l
 oF6aQHmnGe1FWfB8vpM5LPhA6KTnrs.xoz5QxTk.lbImh5w9Gw6QU4R_wvjnyB1Oy6bByH_FuQz4
 oecoVmgZaGPnOag5hTxlsCisFv.iRZimu_R7Enujt5ITDoFE.2nmBiwRHVYQCzpFaEZC7DPE0AmC
 eNpcTbsR5HyGJkisMt8e081X_P1anWVCcdLRYfOivNN45Vica7qDGogUcU1znSpMnzsSXl7VAglc
 RrYgtnJ6ju.7G9fZQB4n_OWEC_Ldz60BOUb1L0T2jJ9IsiN49fnMltPNm_YeXrXUSP7WJYyktbpp
 bxd2RXpVr1ipM_oVpikLSJXjpnZRmqIZngPAMXC9bhbKW6IaqLDPHrkqRqPydQHMJ7M0I_aaUrK7
 _V.H1m8xHWIlx5h__Yt6PTJeVQD59Ha7H6fu9FsTSG8yUSZqR78ScbEbQ0egfvVXl9BRABtUeGrL
 zoW9cv5fda_2kZcnmkYpkAHdwbAZiMhy5tWvH9gPRWhbRkezNEZDQHdBNVMv6SXy1_4qCcrNnBM8
 O9Xk2HQYAYL_p3n1z1crT6zowuweOVY.QtJ8ZqPCHcfe9agU4elgdMJ9iSZhSe8oEjcaNmWxNCYH
 gCKzIgrMx7sdJ0ZQLYKgDaUCVfozw0Bz1XTZr2xiUSvWVgbZMTlbUb.QUMcsP6SNlswN3XCexnb1
 cLfNntSu12X20tYwGiviL7lwu7Hz5AgNIVVxzPA2V6Cppzy7e2CW4g7r_WwooHnfznr3keFoh8Zm
 .JxuLUEj6xIvdfrFIVNhOD.5nkijQZuyc_oPE49EFn2U3YHNeCH6qAKEJ_Gi4lIjOTPatNyJeo3g
 0RPJhJV8Xvo3PQn0Gk7YpgPoGa7bzTXlOLTNrl1TX3EzG7OpguxqlGGKL.WX4X_H7jwCk37VRBJK
 Q62_7w8Vqc8tQ7mpQcEFikZkGW1Ja31dUlojRwVGMspuvwwKfjpN5cIee23qvz9RsmNRslcu8kUG
 gs1HUCChoN5_toVXjUTfeT0AkFTotOuIoEydSOXAkhaRek3XAnMGDhj8PCsXEj7i1wtbIuxwHHQ6
 3nRC0tXnc7U2nE6yxpoqJ.hmN4k4nidq8MoIN30IRDb.F7z7wvgkfHazghjZt0Vdd0UV3whfTjzA
 kkUDmJ6MJI_.5_JYWnHuHrdqfUnhn2E87LsSFEWwfrtxp1.Fs5feZjkpAILordMpQ0mOMNfKI_F5
 u5_7u5E2xTV_DXXBAB.alVgUrM_ZAz6Zi59bwuiihwj4PylG.1axwCvwd6FoP..SXjYZn0qOcVf6
 E7DXuLeBN8nOqoolqtPPi.DatDeLVSIPT5mD3rnA44GJxvGKdolPB7xZek5AgqbBRIGWJYPyqKMI
 r8bmXerEsXlg8C9G6UZY6WfjZb4qmUNSVFFCNd1gVOAeVuZj3OovHCSvZKBtXaXFWMjwauiAQ.CS
 js9NnGi_7co0GKfKR9dBYukwea4d9NDoqik6WVF0BaCiNeNm4dCTrrffLPHm1w0JboNuVAEz2cNc
 Pz.Ms_a9Y9gBFN1G2SABMDfoeOPyWAuoQJAVN9zPhLwt0ta3zMyma9nLltZJxHAVnVqzCUzcFd7W
 fg6eRr_4uHCMOcm81eoC6NqMB_4PaQSbkUnQo.yOKN80VNRIsr9gnyFuRRdiINlp4tig7WwFhT.B
 bmcHX_fl546luR37zX6q_lcIOSpSwdcb0k.Lj_nnt1AqNKJuyuO2iP5jWyuZ9C4Rzfiz_rlD_C02
 ccSKR6KqDF4VjYsCHxFVwppPN8eclJDEzylo1mmDApJBlc3qKpWWRvbTRqarohx2UiLK2WMK3Sml
 1fItyKeSNiJ7HKv_5DD8GhN.MqnPQE.A-
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.ne1.yahoo.com with HTTP; Thu, 9 Jun 2022 23:06:50 +0000
Received: by hermes--canary-production-ne1-799d7bd497-2pzdr (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID b20ca8b25547b2b344a65fa8c4e3e611;
          Thu, 09 Jun 2022 23:06:49 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        stephen.smalley.work@gmail.com, linux-kernel@vger.kernel.org,
        linux-integrity@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v36 11/33] LSM: Use lsmblob in security_current_getsecid
Date:   Thu,  9 Jun 2022 16:01:24 -0700
Message-Id: <20220609230146.319210-12-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220609230146.319210-1-casey@schaufler-ca.com>
References: <20220609230146.319210-1-casey@schaufler-ca.com>
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
 include/linux/security.h              | 31 ++++++++++++---
 kernel/audit.c                        | 16 +++-----
 kernel/auditfilter.c                  |  4 +-
 kernel/auditsc.c                      | 25 ++++++------
 net/netlabel/netlabel_unlabeled.c     |  4 +-
 net/netlabel/netlabel_user.h          |  6 ++-
 security/integrity/ima/ima.h          |  6 +--
 security/integrity/ima/ima_api.c      |  6 +--
 security/integrity/ima/ima_appraise.c | 11 +++---
 security/integrity/ima/ima_main.c     | 57 ++++++++++++++-------------
 security/integrity/ima/ima_policy.c   | 15 +++----
 security/security.c                   | 25 +++++++++---
 13 files changed, 124 insertions(+), 88 deletions(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 4ead3360a1c0..f25a867063e5 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -3054,16 +3054,16 @@ static void binder_transaction(struct binder_proc *proc,
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
index 029c23719a5c..ce4a4af362f3 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -222,6 +222,24 @@ static inline u32 lsmblob_value(const struct lsmblob *blob)
 	return 0;
 }
 
+/**
+ * lsmblob_first - secid value for the first LSM slot
+ * @blob: Pointer to the data
+ *
+ * Return the secid value from the first LSM slot.
+ * There may not be any LSM slots.
+ *
+ * Return the value in secid[0] if there are any slots, 0 otherwise.
+ */
+static inline u32 lsmblob_first(const struct lsmblob *blob)
+{
+#if LSMBLOB_ENTRIES > 0
+	return blob->secid[0];
+#else
+	return 0;
+#endif
+}
+
 /* These functions are in security/commoncap.c */
 extern int cap_capable(const struct cred *cred, struct user_namespace *ns,
 		       int cap, unsigned int opts);
@@ -504,8 +522,8 @@ int security_task_fix_setgid(struct cred *new, const struct cred *old,
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
@@ -1201,14 +1219,15 @@ static inline int security_task_getsid(struct task_struct *p)
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
index 2acf95cf9895..2834e55844db 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -2178,19 +2178,12 @@ int audit_log_task_context(struct audit_buffer *ab)
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
@@ -2399,6 +2392,7 @@ int audit_set_loginuid(kuid_t loginuid)
 int audit_signal_info(int sig, struct task_struct *t)
 {
 	kuid_t uid = current_uid(), auid;
+	struct lsmblob blob;
 
 	if (auditd_test_task(t) &&
 	    (sig == SIGTERM || sig == SIGHUP ||
@@ -2409,7 +2403,9 @@ int audit_signal_info(int sig, struct task_struct *t)
 			audit_sig_uid = auid;
 		else
 			audit_sig_uid = uid;
-		security_current_getsecid_subj(&audit_sig_sid);
+		security_current_getsecid_subj(&blob);
+		/* scaffolding until audit_sig_sid is converted */
+		audit_sig_sid = lsmblob_first(&blob);
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
index 0986ded8e798..e56637b5d518 100644
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
@@ -2770,12 +2761,15 @@ int __audit_sockaddr(int len, void *a)
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
+	context->target_sid = lsmblob_first(&blob);
 	memcpy(context->target_comm, t->comm, TASK_COMM_LEN);
 }
 
@@ -2791,6 +2785,7 @@ int audit_signal_info_syscall(struct task_struct *t)
 	struct audit_aux_data_pids *axp;
 	struct audit_context *ctx = audit_context();
 	kuid_t t_uid = task_uid(t);
+	struct lsmblob blob;
 
 	if (!audit_signals || audit_dummy_context())
 		return 0;
@@ -2802,7 +2797,9 @@ int audit_signal_info_syscall(struct task_struct *t)
 		ctx->target_auid = audit_get_loginuid(t);
 		ctx->target_uid = t_uid;
 		ctx->target_sessionid = audit_get_sessionid(t);
-		security_task_getsecid_obj(t, &ctx->target_sid);
+		security_task_getsecid_obj(t, &blob);
+		/* scaffolding until target_sid is converted */
+		ctx->target_sid = lsmblob_first(&blob);
 		memcpy(ctx->target_comm, t->comm, TASK_COMM_LEN);
 		return 0;
 	}
@@ -2823,7 +2820,9 @@ int audit_signal_info_syscall(struct task_struct *t)
 	axp->target_auid[axp->pid_count] = audit_get_loginuid(t);
 	axp->target_uid[axp->pid_count] = t_uid;
 	axp->target_sessionid[axp->pid_count] = audit_get_sessionid(t);
-	security_task_getsecid_obj(t, &axp->target_sid[axp->pid_count]);
+	security_task_getsecid_obj(t, &blob);
+	/* scaffolding until target_sid is converted */
+	axp->target_sid[axp->pid_count] = lsmblob_first(&blob);
 	memcpy(axp->target_comm[axp->pid_count], t->comm, TASK_COMM_LEN);
 	axp->pid_count++;
 
diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index 0a99663e6edb..bbb3b6a4f0d7 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -1562,11 +1562,13 @@ int __init netlbl_unlabel_defconf(void)
 	int ret_val;
 	struct netlbl_dom_map *entry;
 	struct netlbl_audit audit_info;
+	struct lsmblob blob;
 
 	/* Only the kernel is allowed to call this function and the only time
 	 * it is called is at bootup before the audit subsystem is reporting
 	 * messages so don't worry to much about these values. */
-	security_current_getsecid_subj(&audit_info.secid);
+	security_current_getsecid_subj(&blob);
+	audit_info.secid = lsmblob_first(&blob);
 	audit_info.loginuid = GLOBAL_ROOT_UID;
 	audit_info.sessionid = 0;
 
diff --git a/net/netlabel/netlabel_user.h b/net/netlabel/netlabel_user.h
index d6c5b31eb4eb..34bb6572f33b 100644
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
+	audit_info->secid = lsmblob_first(&blob);
 	audit_info->loginuid = audit_get_loginuid(current);
 	audit_info->sessionid = audit_get_sessionid(current);
 }
diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 1b5d70ac2dc9..f347d63b61e7 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -255,7 +255,7 @@ static inline void ima_process_queued_keys(void) {}
 
 /* LIM API function definitions */
 int ima_get_action(struct user_namespace *mnt_userns, struct inode *inode,
-		   const struct cred *cred, u32 secid, int mask,
+		   const struct cred *cred, struct lsmblob *blob, int mask,
 		   enum ima_hooks func, int *pcr,
 		   struct ima_template_desc **template_desc,
 		   const char *func_data, unsigned int *allowed_algos);
@@ -286,8 +286,8 @@ const char *ima_d_path(const struct path *path, char **pathbuf, char *filename);
 
 /* IMA policy related functions */
 int ima_match_policy(struct user_namespace *mnt_userns, struct inode *inode,
-		     const struct cred *cred, u32 secid, enum ima_hooks func,
-		     int mask, int flags, int *pcr,
+		     const struct cred *cred, struct lsmblob *blob,
+		     enum ima_hooks func, int mask, int flags, int *pcr,
 		     struct ima_template_desc **template_desc,
 		     const char *func_data, unsigned int *allowed_algos);
 void ima_init_policy(void);
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index c1e76282b5ee..8c48da6a6583 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -166,7 +166,7 @@ void ima_add_violation(struct file *file, const unsigned char *filename,
  * @mnt_userns:	user namespace of the mount the inode was found from
  * @inode: pointer to the inode associated with the object being validated
  * @cred: pointer to credentials structure to validate
- * @secid: secid of the task being validated
+ * @blob: secid(s) of the task being validated
  * @mask: contains the permission mask (MAY_READ, MAY_WRITE, MAY_EXEC,
  *        MAY_APPEND)
  * @func: caller identifier
@@ -187,7 +187,7 @@ void ima_add_violation(struct file *file, const unsigned char *filename,
  *
  */
 int ima_get_action(struct user_namespace *mnt_userns, struct inode *inode,
-		   const struct cred *cred, u32 secid, int mask,
+		   const struct cred *cred, struct lsmblob *blob, int mask,
 		   enum ima_hooks func, int *pcr,
 		   struct ima_template_desc **template_desc,
 		   const char *func_data, unsigned int *allowed_algos)
@@ -196,7 +196,7 @@ int ima_get_action(struct user_namespace *mnt_userns, struct inode *inode,
 
 	flags &= ima_policy_flag;
 
-	return ima_match_policy(mnt_userns, inode, cred, secid, func, mask,
+	return ima_match_policy(mnt_userns, inode, cred, blob, func, mask,
 				flags, pcr, template_desc, func_data,
 				allowed_algos);
 }
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index cdb84dccd24e..9ef8210e901f 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -73,15 +73,16 @@ bool is_ima_appraise_enabled(void)
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
+	return ima_match_policy(mnt_userns, inode, current_cred(),
+				&blob, func, mask,
+				IMA_APPRAISE | IMA_HASH, NULL, NULL, NULL,
+				NULL);
 }
 
 static int ima_fix_xattr(struct dentry *dentry,
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 040b03ddc1c7..5d6029ac52f0 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -199,8 +199,8 @@ void ima_file_free(struct file *file)
 }
 
 static int process_measurement(struct file *file, const struct cred *cred,
-			       u32 secid, char *buf, loff_t size, int mask,
-			       enum ima_hooks func)
+			       struct lsmblob *blob, char *buf, loff_t size,
+			       int mask, enum ima_hooks func)
 {
 	struct inode *inode = file_inode(file);
 	struct integrity_iint_cache *iint = NULL;
@@ -224,7 +224,7 @@ static int process_measurement(struct file *file, const struct cred *cred,
 	 * bitmask based on the appraise/audit/measurement policy.
 	 * Included is the appraise submask.
 	 */
-	action = ima_get_action(file_mnt_user_ns(file), inode, cred, secid,
+	action = ima_get_action(file_mnt_user_ns(file), inode, cred, blob,
 				mask, func, &pcr, &template_desc, NULL,
 				&allowed_algos);
 	violation_check = ((func == FILE_CHECK || func == MMAP_CHECK) &&
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
+		return process_measurement(file, current_cred(),
+					   &blob, NULL, 0,
+					   MAY_EXEC, MMAP_CHECK);
 	}
 
 	return 0;
@@ -437,9 +438,9 @@ int ima_file_mprotect(struct vm_area_struct *vma, unsigned long prot)
 	char *pathbuf = NULL;
 	const char *pathname = NULL;
 	struct inode *inode;
+	struct lsmblob blob;
 	int result = 0;
 	int action;
-	u32 secid;
 	int pcr;
 
 	/* Is mprotect making an mmap'ed file executable? */
@@ -447,11 +448,12 @@ int ima_file_mprotect(struct vm_area_struct *vma, unsigned long prot)
 	    !(prot & PROT_EXEC) || (vma->vm_flags & VM_EXEC))
 		return 0;
 
-	security_current_getsecid_subj(&secid);
+	security_current_getsecid_subj(&blob);
 	inode = file_inode(vma->vm_file);
 	action = ima_get_action(file_mnt_user_ns(vma->vm_file), inode,
-				current_cred(), secid, MAY_EXEC, MMAP_CHECK,
-				&pcr, &template, NULL, NULL);
+				current_cred(), &blob,
+				MAY_EXEC, MMAP_CHECK, &pcr, &template, NULL,
+				NULL);
 
 	/* Is the mmap'ed file in policy? */
 	if (!(action & (IMA_MEASURE | IMA_APPRAISE_SUBMASK)))
@@ -487,10 +489,11 @@ int ima_bprm_check(struct linux_binprm *bprm)
 {
 	int ret;
 	u32 secid;
+	struct lsmblob blob;
 
-	security_current_getsecid_subj(&secid);
-	ret = process_measurement(bprm->file, current_cred(), secid, NULL, 0,
-				  MAY_EXEC, BPRM_CHECK);
+	security_current_getsecid_subj(&blob);
+	ret = process_measurement(bprm->file, current_cred(),
+				  &blob, NULL, 0, MAY_EXEC, BPRM_CHECK);
 	if (ret)
 		return ret;
 
@@ -511,10 +514,10 @@ int ima_bprm_check(struct linux_binprm *bprm)
  */
 int ima_file_check(struct file *file, int mask)
 {
-	u32 secid;
+	struct lsmblob blob;
 
-	security_current_getsecid_subj(&secid);
-	return process_measurement(file, current_cred(), secid, NULL, 0,
+	security_current_getsecid_subj(&blob);
+	return process_measurement(file, current_cred(), &blob, NULL, 0,
 				   mask & (MAY_READ | MAY_WRITE | MAY_EXEC |
 					   MAY_APPEND), FILE_CHECK);
 }
@@ -710,7 +713,7 @@ int ima_read_file(struct file *file, enum kernel_read_file_id read_id,
 		  bool contents)
 {
 	enum ima_hooks func;
-	u32 secid;
+	struct lsmblob blob;
 
 	/*
 	 * Do devices using pre-allocated memory run the risk of the
@@ -730,9 +733,9 @@ int ima_read_file(struct file *file, enum kernel_read_file_id read_id,
 
 	/* Read entire file for all partial reads. */
 	func = read_idmap[read_id] ?: FILE_CHECK;
-	security_current_getsecid_subj(&secid);
-	return process_measurement(file, current_cred(), secid, NULL,
-				   0, MAY_READ, func);
+	security_current_getsecid_subj(&blob);
+	return process_measurement(file, current_cred(), &blob, NULL, 0,
+				   MAY_READ, func);
 }
 
 const int read_idmap[READING_MAX_ID] = {
@@ -760,7 +763,7 @@ int ima_post_read_file(struct file *file, void *buf, loff_t size,
 		       enum kernel_read_file_id read_id)
 {
 	enum ima_hooks func;
-	u32 secid;
+	struct lsmblob blob;
 
 	/* permit signed certs */
 	if (!file && read_id == READING_X509_CERTIFICATE)
@@ -773,8 +776,8 @@ int ima_post_read_file(struct file *file, void *buf, loff_t size,
 	}
 
 	func = read_idmap[read_id] ?: FILE_CHECK;
-	security_current_getsecid_subj(&secid);
-	return process_measurement(file, current_cred(), secid, buf, size,
+	security_current_getsecid_subj(&blob);
+	return process_measurement(file, current_cred(), &blob, buf, size,
 				   MAY_READ, func);
 }
 
@@ -900,7 +903,7 @@ int process_buffer_measurement(struct user_namespace *mnt_userns,
 	int digest_hash_len = hash_digest_size[ima_hash_algo];
 	int violation = 0;
 	int action = 0;
-	u32 secid;
+	struct lsmblob blob;
 
 	if (digest && digest_len < digest_hash_len)
 		return -EINVAL;
@@ -923,9 +926,9 @@ int process_buffer_measurement(struct user_namespace *mnt_userns,
 	 * buffer measurements.
 	 */
 	if (func) {
-		security_current_getsecid_subj(&secid);
+		security_current_getsecid_subj(&blob);
 		action = ima_get_action(mnt_userns, inode, current_cred(),
-					secid, 0, func, &pcr, &template,
+					&blob, 0, func, &pcr, &template,
 					func_data, NULL);
 		if (!(action & IMA_MEASURE) && !digest)
 			return -ENOENT;
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index b04733a5d066..5c2bc6782e17 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -563,7 +563,7 @@ static bool ima_match_rule_data(struct ima_rule_entry *rule,
  * @mnt_userns:	user namespace of the mount the inode was found from
  * @inode: a pointer to an inode
  * @cred: a pointer to a credentials structure for user validation
- * @secid: the secid of the task to be validated
+ * @blob: the secid(s) of the task to be validated
  * @func: LIM hook identifier
  * @mask: requested action (MAY_READ | MAY_WRITE | MAY_APPEND | MAY_EXEC)
  * @func_data: func specific data, may be NULL
@@ -573,7 +573,7 @@ static bool ima_match_rule_data(struct ima_rule_entry *rule,
 static bool ima_match_rules(struct ima_rule_entry *rule,
 			    struct user_namespace *mnt_userns,
 			    struct inode *inode, const struct cred *cred,
-			    u32 secid, enum ima_hooks func, int mask,
+			    struct lsmblob *blob, enum ima_hooks func, int mask,
 			    const char *func_data)
 {
 	int i;
@@ -657,7 +657,8 @@ static bool ima_match_rules(struct ima_rule_entry *rule,
 		case LSM_SUBJ_USER:
 		case LSM_SUBJ_ROLE:
 		case LSM_SUBJ_TYPE:
-			rc = ima_filter_rule_match(secid, rule->lsm[i].type,
+			rc = ima_filter_rule_match(lsmblob_first(blob),
+						   rule->lsm[i].type,
 						   Audit_equal,
 						   rule->lsm[i].rule,
 						   rule->lsm[i].rules_lsm);
@@ -702,7 +703,7 @@ static int get_subaction(struct ima_rule_entry *rule, enum ima_hooks func)
  * @inode: pointer to an inode for which the policy decision is being made
  * @cred: pointer to a credentials structure for which the policy decision is
  *        being made
- * @secid: LSM secid of the task to be validated
+ * @blob: LSM secid(s) of the task to be validated
  * @func: IMA hook identifier
  * @mask: requested action (MAY_READ | MAY_WRITE | MAY_APPEND | MAY_EXEC)
  * @pcr: set the pcr to extend
@@ -718,8 +719,8 @@ static int get_subaction(struct ima_rule_entry *rule, enum ima_hooks func)
  * than writes so ima_match_policy() is classical RCU candidate.
  */
 int ima_match_policy(struct user_namespace *mnt_userns, struct inode *inode,
-		     const struct cred *cred, u32 secid, enum ima_hooks func,
-		     int mask, int flags, int *pcr,
+		     const struct cred *cred, struct lsmblob *blob,
+		     enum ima_hooks func, int mask, int flags, int *pcr,
 		     struct ima_template_desc **template_desc,
 		     const char *func_data, unsigned int *allowed_algos)
 {
@@ -737,7 +738,7 @@ int ima_match_policy(struct user_namespace *mnt_userns, struct inode *inode,
 		if (!(entry->action & actmask))
 			continue;
 
-		if (!ima_match_rules(entry, mnt_userns, inode, cred, secid,
+		if (!ima_match_rules(entry, mnt_userns, inode, cred, blob,
 				     func, mask, func_data))
 			continue;
 
diff --git a/security/security.c b/security/security.c
index 1e9c06607c39..1a4741178944 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1916,17 +1916,30 @@ int security_task_getsid(struct task_struct *p)
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
2.35.1

