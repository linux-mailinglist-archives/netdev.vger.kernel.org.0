Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B89044F89AA
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 00:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231519AbiDGVaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 17:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231479AbiDGV36 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 17:29:58 -0400
Received: from sonic313-15.consmr.mail.ne1.yahoo.com (sonic313-15.consmr.mail.ne1.yahoo.com [66.163.185.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C874F1A3AC3
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 14:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1649366864; bh=tqvz12saZEJBvLj3JqZS/kWuQOAhpDE8Slwx2TBUp2U=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=SOvLO4T3OISVSBqMCrcDBVA8Q5Zp/V4FBfwSidAbolsbkDk8hfv+3I/1xHh3Q/ySEB2BQdekdEMel/WiErooVj5jzwQ28Y7tQGiph6C2UmOVKevB6+bfYofysfYT7ecNobCwssPMSzFPXhkMAX3GPHCFxwyfYOG8zBbHlWzVp5MqJSsC+PgH2y5VwqCwHa/JkiWvGUwjXveMjecpxufsk+WFa3nuvltpZe5qSUY7Y6+pVf/ZkaFscdMf312tKmhMbwGEqs3uURHVvt4jCmLR2pjVzJmKYY3Yp8X2W2N1hPygULhw2J7HRWzr7vUaud663LPZMJ0nvj6s6YBVRpCmRA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1649366864; bh=AAWOlDwGs5LPBd0XpVRpUN17fXHim6VffyuVxTHOQFd=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=Wd+tED0N4TpuIau0NBdt0+0d1geztDXG+mxxmeG7oPuGDdwAn9oaZFSrDAr2sMVKcukasmFEBVCPrNTnv/mJsa3+EU4Zm+F42VeBuryjTURKYVxH3DUJ55TvHwRysrun1wVEm1ZZX69SXOxFAa7jfrF5tH8JUpOhkjZhvoNQ2HrjkxhRT9QH7kOloKOUhMSZOccICBHk8Xsdhh+aLqDIdmPxmsUcH49eI3VmraaBj8lEZ0aGnxpLYBu6F33ONeY0VyhDlUjPHQS9WbtXyYUuLUEQSKafVaNmiajP27ZfHH2SjDuCyGpRpzu1nBhM9pLpW7oEZqfQLsfyv0PrXflJPQ==
X-YMail-OSG: kXj8Lj4VM1k2a7qv_Ga7KkLxG.PfhibZu4gSfcBtZnDDHFOh1.M0P4j_E5nGnvK
 Rk2wn8N6DMuB55zS8ddfYooFq_8fU4iSfHWg3usQq534fiEzAFm7s_1RF17cRj_StVd7IP52U2J5
 HEZiqJMTEhyxJs2dcm5Ja_cdylAv4gaEd6i6xErtjx1dtXS.WkmkO7OpC7EG93ebVlv8yiUKaHvr
 eFPXXIonHAibECS6bzYhjGZ5Z9gd_7P5nP11_.OBODH3Ki0YBz.9Tj78GuEtHKKQ65jSC0U3bsAY
 FRGL92vJCoBnUNG1iEL5kfyALuHuZXbEpbJ0rkvwVm6Z4NSCTBPnR1viSBuBgPRzgFt77_lkZr36
 mtWvyFlCV0bhRvPhIBgYC2W_7HmL_q7Y8EuAtQ4V6y3fqx6VHrjscbgtP1JmcORlGunaySqVlAI2
 3_xQm5ZbJE1Vf_oRIxOOLMqA2FRiD8kXvMD5p7s8w0LDyYFdZ.7B9Kq0R_Kd0hqi_gtcQfZGIwK0
 oNnaz7xYgoekUC_WPh0.HJqPLSp1RXZIFgYIVvoFFm3NH5WnjdYRoNQYbqwdLL3qZo9.thGrlasQ
 4UV9M86oJrgQDR.sSdETbQf01G4YghAICvmYHp14RxfpaUqnlhL8uWU3ZNaYzDqFMsTCxtCFFuxM
 PUCJMyRPkpwgV.hN5744pvD9aWbZe3N0dSjFVtF_iYY2vtN_1DxcH47WhlzJ6R6XkopiRC24F01q
 SVxziBFYnjXFLcjW.Tc.QsNC3fLGTMo6pD6qJqhR93XEqUQ4AIzYEZ401Ld9pTwNgRzDrWpHxt3s
 NgWmEB1M_PLgEu_21LAGlIB0S7by0I4pp6LVkZnXuoc8MmC96hI6wzkf12N3.yjGrHuxyKiV7faU
 LAoKgJcRMfvsYg2PG.Wg67WnjG6NtyU1.4FJF8CCL33ZWZELJYyPM6_U4ziwIHMZvr9h6HCeo6Eh
 pQTn9tpC0i5D9xNpODxq0daYoHMQVTo7fUuR73fbfrtSWm1nrvkD5TIlnz9Ip5.QXDs8GhAa6uQB
 hT9.5rhMapdQdzwD2PzsOC3euLAKvM.2MeT8CzPMplMty3UVmQvMFvMIC.fZ41eub9cXng_enYmJ
 t4iyk0y0X3uJLVBxBoUxZqWqIrxXDmrx.cV1kADKNGHsFnzujB7AuXXJ7jHArUQ7uInbvZygy0Ve
 hz7FO3TXWfgnX2vZSVE3ClbPEk273HDGCj8zTwJTP3DipkQYtJz5Cfl34rNXl9HXzajd.O1CYWM8
 orDrNypK0m5JasSYM3kMWUKyE24t..hpSfL9sx7Hh.175_TpLkOIwj9RyY39EcKex6._ozrExgBB
 hAGTLP9.rsJv4WEaQDDv0pb20U8KYtFsHPNZigrtl9et9DqawJNVdcRd9fJ487IqJIqu2s3aRCti
 oUTnUH.cgUbmSbVjg.Y.jwgWYbvtxozQImOvAqSk5liYt8B5Y.x93HFzyO35z11SeGLfs_qLnONi
 fPBEdwvJZFTymun3TGOONO2N7kdom2MBOiCQLGojeuyvfr8UIxWc1JK_6JZugYqC6.FYu5_83qFv
 I6VbZhDf8tiZKRaUPSPZe17KyPjnA1B6o_SQpPNqONdT6VZnp.Npjt25OQ74nrhmtZEpCQ6H.3ZW
 a_XBa0sDlV5qykkIc8snhZBHusqvQsWBqobOej1FnQTSXA4yqHJ3KISNPjiX9iH2mE.owBhVDmmU
 yRE0nkhslCRdH3Lr8vzU3EQhuPS17YZ9qf5iqg.9C1UAJblm5WK7v9Umg5Jp_.hQfFT3dmS50O6z
 d6twxrtfecjaD0scjojxwh5PbifHQZboGrZTG5mQmFI.48nU4ePOyk0UgzTwZOWfmLPSXDulkeK8
 2EoezDosTHMH5zR3_o_pvO9FWB.26ZdCqQJDpyjg9vRYTFO2zF7FZdFF1foUh0DoNqxdDL.xRgD7
 v5d.mHFIDroIrZb0XXm.lUyu0oUZWqG10ZnQ9_hHBm37_BQFX.fo_Lv9Qxm1_d_aGspUV0ciGCuT
 hBqVBaFVWzDsR0ZM9j_N_8UOhtdwj3v2phnwv9T.eYJNfv4k6HfgkK23pM8.ksxHVL22TGHtOPp4
 GP5i47J3Y4UKkllGmbLgzZbRwzcuMxhq.9yZgws8xZ5b.mo3h033ksnaR.B0ktY8wJN8.BiZ2WQG
 R0SURPvjMCx0wICq.kHlm1jB.0mKpRE8Nnm09EYR2xawTSejFwLolOF1nn3rCcaY7UYiFzW5A2eU
 aTqKNp18i23LkXazYlpVVktovujD8XcpzJ1byKmyhJanyK9XDgWxHjaeSf49q4haqMA9Eunogji0
 5P6pDdyamVgcAdjCC5Xw3Ic93mivIoMh1tjDBsyl_vmXNScvxlBNauaOM4Q--
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.ne1.yahoo.com with HTTP; Thu, 7 Apr 2022 21:27:44 +0000
Received: by kubenode522.mail-prod1.omega.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID cdeff4c1363a36af98b9100857bab95c;
          Thu, 07 Apr 2022 21:27:42 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        stephen.smalley.work@gmail.com, linux-kernel@vger.kernel.org,
        linux-integrity@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v34 11/29] LSM: Use lsmblob in security_current_getsecid
Date:   Thu,  7 Apr 2022 14:22:12 -0700
Message-Id: <20220407212230.12893-12-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220407212230.12893-1-casey@schaufler-ca.com>
References: <20220407212230.12893-1-casey@schaufler-ca.com>
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
index 4646ca90f457..10ff7db2232e 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -502,8 +502,8 @@ int security_task_fix_setgid(struct cred *new, const struct cred *old,
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
@@ -1199,14 +1199,15 @@ static inline int security_task_getsid(struct task_struct *p)
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
index 2acf95cf9895..0a7869c9c9ad 100644
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
index d125dba69a76..5ad606cc4814 100644
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
@@ -2764,12 +2755,15 @@ int __audit_sockaddr(int len, void *a)
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
 
@@ -2785,6 +2779,7 @@ int audit_signal_info_syscall(struct task_struct *t)
 	struct audit_aux_data_pids *axp;
 	struct audit_context *ctx = audit_context();
 	kuid_t t_uid = task_uid(t);
+	struct lsmblob blob;
 
 	if (!audit_signals || audit_dummy_context())
 		return 0;
@@ -2796,7 +2791,9 @@ int audit_signal_info_syscall(struct task_struct *t)
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
@@ -2817,7 +2814,9 @@ int audit_signal_info_syscall(struct task_struct *t)
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
index 3d3f8c5c502b..2d99cb996d5f 100644
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
@@ -447,11 +448,11 @@ int ima_file_mprotect(struct vm_area_struct *vma, unsigned long prot)
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
@@ -487,10 +488,12 @@ int ima_bprm_check(struct linux_binprm *bprm)
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
 
@@ -511,10 +514,11 @@ int ima_bprm_check(struct linux_binprm *bprm)
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
@@ -710,7 +714,7 @@ int ima_read_file(struct file *file, enum kernel_read_file_id read_id,
 		  bool contents)
 {
 	enum ima_hooks func;
-	u32 secid;
+	struct lsmblob blob;
 
 	/*
 	 * Do devices using pre-allocated memory run the risk of the
@@ -730,8 +734,9 @@ int ima_read_file(struct file *file, enum kernel_read_file_id read_id,
 
 	/* Read entire file for all partial reads. */
 	func = read_idmap[read_id] ?: FILE_CHECK;
-	security_current_getsecid_subj(&secid);
-	return process_measurement(file, current_cred(), secid, NULL,
+	security_current_getsecid_subj(&blob);
+	/* scaffolding - until process_measurement changes */
+	return process_measurement(file, current_cred(), blob.secid[0], NULL,
 				   0, MAY_READ, func);
 }
 
@@ -760,7 +765,7 @@ int ima_post_read_file(struct file *file, void *buf, loff_t size,
 		       enum kernel_read_file_id read_id)
 {
 	enum ima_hooks func;
-	u32 secid;
+	struct lsmblob blob;
 
 	/* permit signed certs */
 	if (!file && read_id == READING_X509_CERTIFICATE)
@@ -773,9 +778,10 @@ int ima_post_read_file(struct file *file, void *buf, loff_t size,
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
@@ -900,7 +906,7 @@ int process_buffer_measurement(struct user_namespace *mnt_userns,
 	int digest_hash_len = hash_digest_size[ima_hash_algo];
 	int violation = 0;
 	int action = 0;
-	u32 secid;
+	struct lsmblob blob;
 
 	if (digest && digest_len < digest_hash_len)
 		return -EINVAL;
@@ -923,9 +929,10 @@ int process_buffer_measurement(struct user_namespace *mnt_userns,
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
index 131c851dd681..eae5b7f3a0db 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1922,17 +1922,30 @@ int security_task_getsid(struct task_struct *p)
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

