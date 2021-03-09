Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 070BF33293D
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 15:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbhCIOyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 09:54:13 -0500
Received: from sonic317-38.consmr.mail.ne1.yahoo.com ([66.163.184.49]:46143
        "EHLO sonic317-38.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231735AbhCIOx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 09:53:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1615301639; bh=+/f1NX6henPEUSZ7JJxy8VF0fRA6aHAaCBwP+9Agv1g=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=HJlLqE4SZoIwPB9BNXICyu03p3txTvYmE6yfCkeoS8Og2Sgx8GIS2o5IKLmFSc0UDdCXyrkwGKh7T0NOcaFkgJR/5IYrGAza8jtxH67GaLJd6V7P1/EB242jYeHJzuHO/aiqagBs5kndBlRFO6ncWUnhuSMhLwYaO3W/V5DHLl/8298Oj/qszcygvA1tgWGew3xpokZtEpE/Tu7D/CxuSAnWx7g2VTJQiPiLBIC71eaV/nE7UMAybffaP8+s1viR6ahOdkNtN7F1bZaVUiXXbfdnvenTRQnLejHEHBWeos9AGAfr6APtSs0R26VkdF34sgPmc+/erZHzng9wS/9X4Q==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1615301639; bh=fW5gG65FzTn5sjQuqPQpNBdUOtWzhyV/yQpYM2jBwZf=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=Fzl7wC4EGn33BjBI8XlCvSwe8FbQcVd/2n2ppzBBNj7KNDLyL6ilqI32ey587o2IMZfcAqCXjnGnarffwQLPR8lEQSd8Y0gh7pm6WNSjyldjWBvXrBpCy8cJFEch7ARkURj+rckX0Wx7LNGyfSJ/6TicjPJ0OYHMHNR6apbAr86BtJYzAs9pEfHdTeOdcqCifiDy0aIv3OCffsGsPyP5Q3wtGYRX7lBzqgOJAW+0hB4qnunMnT05hw9FeTWL9HErtJpw6qwlNZVktYsE6RNAmn0kPj2TWv2DfHox2fx+dIB1chnaNqZYAmfuC0KcvygTMdedGcyj9miS95tMrqf8NA==
X-YMail-OSG: 4PH9pqEVM1mry_Bjk.QhzHTC01uQbMuRZaz9Nx4PTqg6M0nIDQ11zuUV20eBYz7
 6toMEfnI8CzPfNijYkyfipw4rB2b61uBcN6ffu_FKKEFxinTYAnTjECxkAQHGSd_0UGm_i2YAhoT
 GvxV7p4ONk9rN__fw3rBoHkDJj8PdO7L7Zw1CApgVgT5gsc2_J11MOoRVqWIPVeoPQrmoQfGff20
 CJCE7DO0uc8Xwc1RMth.MUMQRRVU_JNEwhUFOcLXD78ZKjn7u7PAofeaQ.VCd4noXwqlY2xtqc5F
 5t69xHTfwtfE0CZQfJfhimuSrjZPhGVNj8uvuX6OQmnr8ioX05jA4yPgDFVU6fi_UmVIGHz7TvD_
 TvTmXdC.c3OZWCOeNJAzk49wt5d1ycFq38Pp50n7DIAa5UsqjSpKqqbAmF99Bj9dty8esZUAqoXn
 sw8boG.m5n89NIKpeC524Ey03tP._.c_.cnau5acPoqYvqUlWgeK0USQ4ZFKxejOTVdmpgpXxLD9
 bPUVLK2uxSF6g5bCYSlNR0VBbX82Th4ximCYlCLwec.QXRUBowcLDh7d4I2O79NUwPr2vY0YAfjC
 WpoY0KTOxTDbeg.A2ztYL8yuczuvh2isUwHjXqs0n3xLRR85DavRIlobs1CD8ZNw1zHM7LlM_yMO
 _kjWjEpMSWjywIOaQ3l7kZqs8FDtgfz.qx0DiYZ5IQzrKN60heyQuypLW_LlkREsGc7HtGAebjO3
 37TCmG94.ZWtgj75YoBH9PsKGt94IAmyX9N4R88MSnomJ26rihXWXK29e7FILcEpOJNuFsLde.Px
 GIKtqb_b2T3aKXAOQtjyaI1H82ylS7FdoEWSq7BRj5fgGk948A_hqCFvsiuY3Zk7VoJZvGVcLZ.u
 QBP0ajvmE1t3Wd7w18ipSZJF7DnlOyjeRStURi1CUftzgML8rWb4FEnmK9zKBknUSH0DGHzChx.i
 Pv7t4ZFv7j5iyHo_hnALMTsvXvckNhzUW8n7lNSU24uT4ZDjib56RE4LoejamS5NgLWSUeycASO4
 KD344DrK55hA8vROTreAWNjLxdT0E2MeZS1D6Ch4omQYS84GrxKSe8aa8R0VnqZty4UwzFb2CTCU
 u0vCEi_bD5wzAe88IWy_Z8B_TuQVAr5L0AinRyilIiZBHep7Ssv2yfJx2iFozzGr6iJ.kWRHGxjB
 AbMlXjBjRp5HiD929_ejePrl85Lr2_ywi6jbYzezLQKhEDrMNKHr88fZ2PuGGZ2FxlAiuOMEZeDd
 G4JAfkrsnv8mz1AQDy4d9UcuLXeFiSXwTwOis6zza3_rQLVu1_JrGbNiJZ9Ywv8RbWh0pPgK9Uwh
 Jcld2ZN_jcel_KwAcmmYSpKFWKDPeP8DvFKcP1qyH_5tcgLntglgxQOkEhGk3P0gEw_x_7XpaySe
 m8E.ZIysNvT_3uBgzyX4S56NnoQgW2qlGcFFO_9cTzkreskOe1HZz8Nq7YCB0H1XTpr7BRNv1OR_
 6Se0ez1y4jSoXjVtIGUXbxtJ3vsq9RAwMKl6UJdEAAX8HudG1C05kXDjU4XXjxLrYBFrvjfQL3_x
 oIsvvaBNAnmIBO5kmA2eGMjd02FphNrdbbaP7NeKlEKc4EiQCjyHgBFxZOI56l1m6_Ddl.FmxTnQ
 Fg2cQz4c8KyJ4i4soSNKBFd5WRBWWH4Mm3yAkzlT0e6o6D3c4deqzNMh.Tf2JX9_Xd1lbCtFjhIB
 V3gmsXs5gA.dxDaNz09Lxn5oG3LsZ6bW68F77R5MRFBb3VTFDjXxfCf9VB88Hz5c1OOGaaMvPiRd
 jfe2GbrOXzEQfgw85.bMfXSy_.pxXHAryXJoI97K3LCgVhXrF0gzYJqRsUS0HySZXKCLqm1OOEDB
 FtdO6cC4ROVBfh8nrSWgSkdORlYky8gkoivlI03WkdjGVOYBDCShkj8.ZQUd7bzPS6UKiRo0ATfi
 AspU7xkN1RUU2YxLTGrzLHHCi3nG4Nf_QHJJURouuyWLzPAMVl4T0qXKN1LEaXwPcgkN1.8t2LVU
 1fBCrtrt_AHYdbK9Q2DgsGS1fh8vYLy0l4iI6OO264CMZGgFQXB04Dksl8faWXe0erb7k7zYFY6N
 BKG0XZQdm.olnVCp8KAVOusvbfZv7gk_S3.086DiDQSmKeOVUJSPbpvrteP_BjRbTAF4W_ZVIH.s
 h3cFc6RTBMKaliRMRSDYRqJi0292N7KZ7og3UCMv4X79lcPaE6i9KeGNcuHVdcjJA2OscKI5yH3L
 scFtEVAqfxXa7Gb1xYxqCMT2tbdPNXBo6CNsD82N_pc_SMyEOpq1o1gMjWnpdaGflo323D7OD3i1
 1p6jgBEefJeZTLVm6ufwaB5V3548GM9rXtxcHfzZuSaSBarAnkTbCuFaBoMOlH3aG50GsXDXUr.8
 Ddh7bI7R9Ff26f0hUFd89OaGw0qx3DEW19CP1AjUGmYFLYTMwsasVkyf69xcP0wt4NML2vv84bKb
 XHWsOkywiouyA5GHrYC7oOEGvczR3bJltWjTpSxE2T1Bdyv2vdWndNhlR1.Tb0ClwUQ4gWwiRHCm
 Zx10AbCjWPKhBsOoWpwkvEbnuKbWbUhRba_uxlEhPOeVLYCvqfuX7HLn.qfieSIGHVfCHNfyP8Tr
 1mBhaWFw.nZq36Wtxaej25.60xsfwA.hzRCf8_OSg40_tBl2jQ80fmp6O58HXrIxRl7fmDThNL7l
 kkLI6UMotNGpqokVq_1XXblQBXtS6TcWuu_rr0aQdlsK6NiT8YtxxshVxDF6txyAOnvkJguEM4zE
 AKtYxiq1QaflALbn5jtEI9wVhhUQF0PAG9isnqcGN1Hd2_Dt25l5NM6gomxLGqbe0AxtT9yCmE.y
 rfflgc0KOxSzPcF55DGrMIfRIEsk0RFY.1ACZi8ShnodJyP7uFJkhh3.Zjzu7AjKhKZbnYEhjmH5
 U4ALTqNJPMbLvvudQ0evdyDQsfBJMqjfLNGc3DYEcgN1pwj5gMmxq02k7xtl.WYQmTVZjwjB50vB
 bdlitD.3aT3bAymZ_aOx8AgJP1OJZ7eSBn.jtpaDjs5HR.dElvXBsqEHUvrf6vQ3lbvnBAhXBNhZ
 cqptdhjASC0SDUE3cnFRkOJyuJJf77Wj7166xHlqoKLMmS3IOmdBBe8K593rGUWLLplQ3gENtl2F
 Xs0BypZyKhBG_IKxF1xGLJ68dHLfZa5EHlcU30toljTKROhdHWS6MbDYPcruOmd7W0axfStZYqDD
 IU3fV8rTG0ARLUTjPwqYPakU4LwcHvW0oKV_l6PQF1Vbh72xDcujsYo8ujA7SjCmkaEbW9Q4GjOY
 FzA--
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic317.consmr.mail.ne1.yahoo.com with HTTP; Tue, 9 Mar 2021 14:53:59 +0000
Received: by kubenode506.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID a17609254ce66e9acb2bd35eb39b0617;
          Tue, 09 Mar 2021 14:53:54 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        linux-integrity@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v25 10/25] LSM: Use lsmblob in security_task_getsecid
Date:   Tue,  9 Mar 2021 06:42:28 -0800
Message-Id: <20210309144243.12519-11-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210309144243.12519-1-casey@schaufler-ca.com>
References: <20210309144243.12519-1-casey@schaufler-ca.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the security_task_getsecid() interface to fill in
a lsmblob structure instead of a u32 secid in support of
LSM stacking. Audit interfaces will need to collect all
possible secids for possible reporting.

Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: John Johansen <john.johansen@canonical.com>
Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
Acked-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-integrity@vger.kernel.org
Cc: linux-audit@redhat.com
Cc: netdev@vger.kernel.org
---
 drivers/android/binder.c              | 12 +-----
 include/linux/security.h              |  7 ++--
 kernel/audit.c                        | 16 +++-----
 kernel/auditfilter.c                  |  4 +-
 kernel/auditsc.c                      | 25 ++++++------
 net/netlabel/netlabel_unlabeled.c     |  5 ++-
 net/netlabel/netlabel_user.h          |  6 ++-
 security/integrity/ima/ima_appraise.c | 10 +++--
 security/integrity/ima/ima_main.c     | 56 +++++++++++++++------------
 security/security.c                   | 12 ++++--
 10 files changed, 80 insertions(+), 73 deletions(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 5fb8555ce166..1a15e9e19e22 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2697,20 +2697,10 @@ static void binder_transaction(struct binder_proc *proc,
 	t->priority = task_nice(current);
 
 	if (target_node && target_node->txn_security_ctx) {
-		u32 secid;
 		struct lsmblob blob;
 		size_t added_size;
 
-		security_task_getsecid(proc->tsk, &secid);
-		/*
-		 * Later in this patch set security_task_getsecid() will
-		 * provide a lsmblob instead of a secid. lsmblob_init
-		 * is used to ensure that all the secids in the lsmblob
-		 * get the value returned from security_task_getsecid(),
-		 * which means that the one expected by
-		 * security_secid_to_secctx() will be set.
-		 */
-		lsmblob_init(&blob, secid);
+		security_task_getsecid(proc->tsk, &blob);
 		ret = security_secid_to_secctx(&blob, &secctx, &secctx_sz);
 		if (ret) {
 			return_error = BR_FAILED_REPLY;
diff --git a/include/linux/security.h b/include/linux/security.h
index 4f5bc3b424e4..852a4764a609 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -498,7 +498,7 @@ int security_task_fix_setgid(struct cred *new, const struct cred *old,
 int security_task_setpgid(struct task_struct *p, pid_t pgid);
 int security_task_getpgid(struct task_struct *p);
 int security_task_getsid(struct task_struct *p);
-void security_task_getsecid(struct task_struct *p, u32 *secid);
+void security_task_getsecid(struct task_struct *p, struct lsmblob *blob);
 int security_task_setnice(struct task_struct *p, int nice);
 int security_task_setioprio(struct task_struct *p, int ioprio);
 int security_task_getioprio(struct task_struct *p);
@@ -1184,9 +1184,10 @@ static inline int security_task_getsid(struct task_struct *p)
 	return 0;
 }
 
-static inline void security_task_getsecid(struct task_struct *p, u32 *secid)
+static inline void security_task_getsecid(struct task_struct *p,
+					  struct lsmblob *blob)
 {
-	*secid = 0;
+	lsmblob_init(blob, 0);
 }
 
 static inline int security_task_setnice(struct task_struct *p, int nice)
diff --git a/kernel/audit.c b/kernel/audit.c
index fcbdce83a9d8..70df7ac1b357 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -2139,19 +2139,12 @@ int audit_log_task_context(struct audit_buffer *ab)
 	char *ctx = NULL;
 	unsigned len;
 	int error;
-	u32 sid;
 	struct lsmblob blob;
 
-	security_task_getsecid(current, &sid);
-	if (!sid)
+	security_task_getsecid(current, &blob);
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
-		security_task_getsecid(current, &audit_sig_sid);
+		security_task_getsecid(current, &blob);
+		/* scaffolding until audit_sig_sid is converted */
+		audit_sig_sid = blob.secid[0];
 	}
 
 	return audit_signal_info_syscall(t);
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index e27424216159..9e73a7961665 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -1330,7 +1330,6 @@ int audit_filter(int msgtype, unsigned int listtype)
 		for (i = 0; i < e->rule.field_count; i++) {
 			struct audit_field *f = &e->rule.fields[i];
 			pid_t pid;
-			u32 sid;
 			struct lsmblob blob;
 
 			switch (f->type) {
@@ -1361,8 +1360,7 @@ int audit_filter(int msgtype, unsigned int listtype)
 			case AUDIT_SUBJ_SEN:
 			case AUDIT_SUBJ_CLR:
 				if (f->lsm_isset) {
-					security_task_getsecid(current, &sid);
-					lsmblob_init(&blob, sid);
+					security_task_getsecid(current, &blob);
 					result = security_audit_rule_match(
 						   &blob, f->type, f->op,
 						   f->lsm_rules);
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 818e4389941a..c2fe8d6f0238 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -471,7 +471,6 @@ static int audit_filter_rules(struct task_struct *tsk,
 {
 	const struct cred *cred;
 	int i, need_sid = 1;
-	u32 sid;
 	struct lsmblob blob;
 	unsigned int sessionid;
 
@@ -668,17 +667,9 @@ static int audit_filter_rules(struct task_struct *tsk,
 			   logged upon error */
 			if (f->lsm_isset) {
 				if (need_sid) {
-					security_task_getsecid(tsk, &sid);
+					security_task_getsecid(tsk, &blob);
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
 								   f->type,
 								   f->op,
@@ -2426,12 +2417,15 @@ int __audit_sockaddr(int len, void *a)
 void __audit_ptrace(struct task_struct *t)
 {
 	struct audit_context *context = audit_context();
+	struct lsmblob blob;
 
 	context->target_pid = task_tgid_nr(t);
 	context->target_auid = audit_get_loginuid(t);
 	context->target_uid = task_uid(t);
 	context->target_sessionid = audit_get_sessionid(t);
-	security_task_getsecid(t, &context->target_sid);
+	security_task_getsecid(t, &blob);
+	/* scaffolding - until target_sid is converted */
+	context->target_sid = blob.secid[0];
 	memcpy(context->target_comm, t->comm, TASK_COMM_LEN);
 }
 
@@ -2447,6 +2441,7 @@ int audit_signal_info_syscall(struct task_struct *t)
 	struct audit_aux_data_pids *axp;
 	struct audit_context *ctx = audit_context();
 	kuid_t t_uid = task_uid(t);
+	struct lsmblob blob;
 
 	if (!audit_signals || audit_dummy_context())
 		return 0;
@@ -2458,7 +2453,9 @@ int audit_signal_info_syscall(struct task_struct *t)
 		ctx->target_auid = audit_get_loginuid(t);
 		ctx->target_uid = t_uid;
 		ctx->target_sessionid = audit_get_sessionid(t);
-		security_task_getsecid(t, &ctx->target_sid);
+		security_task_getsecid(t, &blob);
+		/* scaffolding until target_sid is converted */
+		ctx->target_sid = blob.secid[0];
 		memcpy(ctx->target_comm, t->comm, TASK_COMM_LEN);
 		return 0;
 	}
@@ -2479,7 +2476,9 @@ int audit_signal_info_syscall(struct task_struct *t)
 	axp->target_auid[axp->pid_count] = audit_get_loginuid(t);
 	axp->target_uid[axp->pid_count] = t_uid;
 	axp->target_sessionid[axp->pid_count] = audit_get_sessionid(t);
-	security_task_getsecid(t, &axp->target_sid[axp->pid_count]);
+	security_task_getsecid(t, &blob);
+	/* scaffolding until target_sid is converted */
+	axp->target_sid[axp->pid_count] = blob.secid[0];
 	memcpy(axp->target_comm[axp->pid_count], t->comm, TASK_COMM_LEN);
 	axp->pid_count++;
 
diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index 0e5d03c228e7..93240432427f 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -1564,11 +1564,14 @@ int __init netlbl_unlabel_defconf(void)
 	int ret_val;
 	struct netlbl_dom_map *entry;
 	struct netlbl_audit audit_info;
+	struct lsmblob blob;
 
 	/* Only the kernel is allowed to call this function and the only time
 	 * it is called is at bootup before the audit subsystem is reporting
 	 * messages so don't worry to much about these values. */
-	security_task_getsecid(current, &audit_info.secid);
+	security_task_getsecid(current, &blob);
+	/* scaffolding until audit_info.secid is converted */
+	audit_info.secid = blob.secid[0];
 	audit_info.loginuid = GLOBAL_ROOT_UID;
 	audit_info.sessionid = 0;
 
diff --git a/net/netlabel/netlabel_user.h b/net/netlabel/netlabel_user.h
index 3c67afce64f1..438b5db6c714 100644
--- a/net/netlabel/netlabel_user.h
+++ b/net/netlabel/netlabel_user.h
@@ -34,7 +34,11 @@
 static inline void netlbl_netlink_auditinfo(struct sk_buff *skb,
 					    struct netlbl_audit *audit_info)
 {
-	security_task_getsecid(current, &audit_info->secid);
+	struct lsmblob blob;
+
+	security_task_getsecid(current, &blob);
+	/* scaffolding until secid is converted */
+	audit_info->secid = blob.secid[0];
 	audit_info->loginuid = audit_get_loginuid(current);
 	audit_info->sessionid = audit_get_sessionid(current);
 }
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 565e33ff19d0..ab0557628336 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -71,14 +71,16 @@ bool is_ima_appraise_enabled(void)
 int ima_must_appraise(struct user_namespace *mnt_userns, struct inode *inode,
 		      int mask, enum ima_hooks func)
 {
-	u32 secid;
+	struct lsmblob blob;
 
 	if (!ima_appraise)
 		return 0;
 
-	security_task_getsecid(current, &secid);
-	return ima_match_policy(mnt_userns, inode, current_cred(), secid, func,
-				mask, IMA_APPRAISE | IMA_HASH, NULL, NULL, NULL);
+	security_task_getsecid(current, &blob);
+	/* scaffolding the .secid[0] */
+	return ima_match_policy(mnt_userns, inode, current_cred(),
+				blob.secid[0], func, mask,
+				IMA_APPRAISE | IMA_HASH, NULL, NULL, NULL);
 }
 
 static int ima_fix_xattr(struct dentry *dentry,
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 9ef748ea829f..360c5e3760cc 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -388,12 +388,13 @@ static int process_measurement(struct file *file, const struct cred *cred,
  */
 int ima_file_mmap(struct file *file, unsigned long prot)
 {
-	u32 secid;
+	struct lsmblob blob;
 
 	if (file && (prot & PROT_EXEC)) {
-		security_task_getsecid(current, &secid);
-		return process_measurement(file, current_cred(), secid, NULL,
-					   0, MAY_EXEC, MMAP_CHECK);
+		security_task_getsecid(current, &blob);
+		/* scaffolding - until process_measurement changes */
+		return process_measurement(file, current_cred(), blob.secid[0],
+					   NULL, 0, MAY_EXEC, MMAP_CHECK);
 	}
 
 	return 0;
@@ -419,9 +420,9 @@ int ima_file_mprotect(struct vm_area_struct *vma, unsigned long prot)
 	char *pathbuf = NULL;
 	const char *pathname = NULL;
 	struct inode *inode;
+	struct lsmblob blob;
 	int result = 0;
 	int action;
-	u32 secid;
 	int pcr;
 
 	/* Is mprotect making an mmap'ed file executable? */
@@ -429,11 +430,12 @@ int ima_file_mprotect(struct vm_area_struct *vma, unsigned long prot)
 	    !(prot & PROT_EXEC) || (vma->vm_flags & VM_EXEC))
 		return 0;
 
-	security_task_getsecid(current, &secid);
+	security_task_getsecid(current, &blob);
 	inode = file_inode(vma->vm_file);
+	/* scaffolding */
 	action = ima_get_action(file_mnt_user_ns(vma->vm_file), inode,
-				current_cred(), secid, MAY_EXEC, MMAP_CHECK,
-				&pcr, &template, 0);
+				current_cred(), blob.secid[0], MAY_EXEC,
+				MMAP_CHECK, &pcr, &template, 0);
 
 	/* Is the mmap'ed file in policy? */
 	if (!(action & (IMA_MEASURE | IMA_APPRAISE_SUBMASK)))
@@ -469,10 +471,12 @@ int ima_bprm_check(struct linux_binprm *bprm)
 {
 	int ret;
 	u32 secid;
+	struct lsmblob blob;
 
-	security_task_getsecid(current, &secid);
-	ret = process_measurement(bprm->file, current_cred(), secid, NULL, 0,
-				  MAY_EXEC, BPRM_CHECK);
+	security_task_getsecid(current, &blob);
+	/* scaffolding until process_measurement changes */
+	ret = process_measurement(bprm->file, current_cred(), blob.secid[0],
+				  NULL, 0, MAY_EXEC, BPRM_CHECK);
 	if (ret)
 		return ret;
 
@@ -493,10 +497,11 @@ int ima_bprm_check(struct linux_binprm *bprm)
  */
 int ima_file_check(struct file *file, int mask)
 {
-	u32 secid;
+	struct lsmblob blob;
 
-	security_task_getsecid(current, &secid);
-	return process_measurement(file, current_cred(), secid, NULL, 0,
+	security_task_getsecid(current, &blob);
+	/* scaffolding until process_measurement changes */
+	return process_measurement(file, current_cred(), blob.secid[0], NULL, 0,
 				   mask & (MAY_READ | MAY_WRITE | MAY_EXEC |
 					   MAY_APPEND), FILE_CHECK);
 }
@@ -666,7 +671,7 @@ int ima_read_file(struct file *file, enum kernel_read_file_id read_id,
 		  bool contents)
 {
 	enum ima_hooks func;
-	u32 secid;
+	struct lsmblob blob;
 
 	/*
 	 * Do devices using pre-allocated memory run the risk of the
@@ -686,8 +691,9 @@ int ima_read_file(struct file *file, enum kernel_read_file_id read_id,
 
 	/* Read entire file for all partial reads. */
 	func = read_idmap[read_id] ?: FILE_CHECK;
-	security_task_getsecid(current, &secid);
-	return process_measurement(file, current_cred(), secid, NULL,
+	security_task_getsecid(current, &blob);
+	/* scaffolding - until process_measurement changes */
+	return process_measurement(file, current_cred(), blob.secid[0], NULL,
 				   0, MAY_READ, func);
 }
 
@@ -716,7 +722,7 @@ int ima_post_read_file(struct file *file, void *buf, loff_t size,
 		       enum kernel_read_file_id read_id)
 {
 	enum ima_hooks func;
-	u32 secid;
+	struct lsmblob blob;
 
 	/* permit signed certs */
 	if (!file && read_id == READING_X509_CERTIFICATE)
@@ -729,9 +735,10 @@ int ima_post_read_file(struct file *file, void *buf, loff_t size,
 	}
 
 	func = read_idmap[read_id] ?: FILE_CHECK;
-	security_task_getsecid(current, &secid);
-	return process_measurement(file, current_cred(), secid, buf, size,
-				   MAY_READ, func);
+	security_task_getsecid(current, &blob);
+	/* scaffolding until process_measurement changes */
+	return process_measurement(file, current_cred(), blob.secid[0], buf,
+				   size, MAY_READ, func);
 }
 
 /**
@@ -852,7 +859,7 @@ void process_buffer_measurement(struct user_namespace *mnt_userns,
 	int digest_hash_len = hash_digest_size[ima_hash_algo];
 	int violation = 0;
 	int action = 0;
-	u32 secid;
+	struct lsmblob blob;
 
 	if (!ima_policy_flag)
 		return;
@@ -872,9 +879,10 @@ void process_buffer_measurement(struct user_namespace *mnt_userns,
 	 * buffer measurements.
 	 */
 	if (func) {
-		security_task_getsecid(current, &secid);
+		security_task_getsecid(current, &blob);
+		/* scaffolding */
 		action = ima_get_action(mnt_userns, inode, current_cred(),
-					secid, 0, func, &pcr, &template,
+					blob.secid[0], 0, func, &pcr, &template,
 					func_data);
 		if (!(action & IMA_MEASURE))
 			return;
diff --git a/security/security.c b/security/security.c
index 23540664cdb9..67127b6f1710 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1858,10 +1858,16 @@ int security_task_getsid(struct task_struct *p)
 	return call_int_hook(task_getsid, 0, p);
 }
 
-void security_task_getsecid(struct task_struct *p, u32 *secid)
+void security_task_getsecid(struct task_struct *p, struct lsmblob *blob)
 {
-	*secid = 0;
-	call_void_hook(task_getsecid, p, secid);
+	struct security_hook_list *hp;
+
+	lsmblob_init(blob, 0);
+	hlist_for_each_entry(hp, &security_hook_heads.task_getsecid, list) {
+		if (WARN_ON(hp->lsmid->slot < 0 || hp->lsmid->slot >= lsm_slot))
+			continue;
+		hp->hook.task_getsecid(p, &blob->secid[hp->lsmid->slot]);
+	}
 }
 EXPORT_SYMBOL(security_task_getsecid);
 
-- 
2.29.2

