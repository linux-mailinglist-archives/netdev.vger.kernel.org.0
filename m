Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BABF2BB6A8
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 21:25:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730690AbgKTUYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 15:24:07 -0500
Received: from sonic302-28.consmr.mail.ne1.yahoo.com ([66.163.186.154]:44149
        "EHLO sonic302-28.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730505AbgKTUYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 15:24:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1605903845; bh=OTCSU/TFUOOnhF4YxVd7UlRaclXtcORtUX6Ijvo1JP4=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject; b=q3POIyBx8t1ypaQrXh2FUuyUqGaqw+NsVmNUOVnLZbbo2BdyMPT0WgEBv0OY3xoDiOgCfdiIkpxb3eGFWLM285KCfL+SrZ2Trg+h5hRHM9r0QsZ9yyZelEZ/rukvlU0xMTBfU386sGeDyxV1FZPOJlKW0pk21ChILLBc9QNY0H5v2A8M97OkuC2sd+QE7S4I3zD9kpExgjX7SZsvjg45wRCJrN5RPS6PLTpwFt3Tl7a8aVmcDfH+p7EEYSLSIhMV2kQ8OVZr7HEbTQeoMAkbtXh2+PUaxTfKCN06p6NgQ3UpvZfm0JkP9J+XwaIML5JlCTqIucqls+73CeSVyIiaHA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1605903845; bh=HF5r2semHTXIu9Qh5U6FCsYVno1vxysDEYQmUXUekRe=; h=From:To:Subject:Date:From:Subject; b=QP7mS43k+GjWJyUy9ellFmzcOKz3z678DpaOSDgoC7o8mMsGYghMEIqUAp+a+zP7dctUd7pwiWu2LkRCr4SSb6PKULIUIp5OM68hkLLCFMYBI1wyP0gySRJQtT3sk+b60eTqSzvHOww2JcXwLCM4zXb442IwamOWhyP+9+uCZqxMoF3nAEz6TCCw8PBmE5bdZgtrblQKm1NGWntEw4f3QHelhLDi6HrWaIla0WJWhTNSsDEqmLi55yrxsAGv9DJoyc4eU56LPV5WqgUiElaBZV0TmGa7s7/tOAt0aBxZpsI8tHmwFBx2SgMye9a+Zr7ZXmVj15ZdzGwfX8z14/F1MQ==
X-YMail-OSG: If7R7yoVM1lWlUdez.Ci59Qa2rG81MdDt48q0JYljFUkb0R9cTUV1IF6yUxGIv7
 HLpv.YCkDhy2SG_uhNJTPuGfOL.N7MKoHx7yLS5pm.YhSA.ORFdcitRWHk22yEUNTh6kwL3eksy.
 ulyQ3DJxznO.xhYFvIOVP6QInHUN63RKyN6O6Qy8ygonkH5xD_bqEV354GZAF0OlUssnfn1julsa
 m07L539woI3MYCclqwxN3uygWTkLxhhcT59DpifjKnj1P50uEpWKSzJt1aZ1yJ4OI.VGPv9uA41i
 ClHqCNbXK0lVT8XksuDiV4srGH.mpCrB0Lvu.BFk_FFqC6UicITW_bKxpmNLprjYL2jJi4nHsJZi
 fnJO67_eINZOX8pqyMe514ViDAUaRGPAMq3jN8wtnB_LmRA3_dTd3zHOOa3QXKNeaPc1D0Jb4prK
 KAIlQc9ZC5JE9rxrhu7bLrhzLofzgxBiTxMkbi1d_5kWpDge9y5S7x8recd.5Bqfad19Bix10Dgv
 ZItf7AWPBzhvf85PlPBno_OQrq9M89KjjzyznBmZbXJA6xdhGY_5BMtZxO8yQw5lB6Gq2f.RzV55
 7Knh.GkPrhqUUWDtxEbAPQLioRtC.SFJjrd4sIPHDOCP2Fo6_6cI8VxuQZG0HMCEstQhnrYfslvf
 bn8ZdLvxiC73DIWogswdpsZfDsJv6uQNFWde1hX.0XAfCCo1oYUBMXLns4FJD9hHCaqncNHdUeso
 71CmEJQaZKrPl6GyqpeAhcPzzEUnS_sYHzrfB40Y8lZFR._5kH_.A366dNnmC6Sq8dLjiTvkUM3p
 V_PU6poDmPTKreG2alOaVbh63o82BGIdzZGWuVhsAJoYj2yYSYtn.o6NTamMYl8Q6XdZKGZshHVD
 L2OF6Gwqjj43p0BSrKc6KqqBQisd5jmxNefanFpulA.Fb9qVdASXna0LXWWYm8oTyf1TMuOkjaOe
 XwqiSZuQjM7fg1c_xd9rJ6BiEbpIqC4HHPyfppzQLtvJ9b7j0fafjHzazwxOjbE2YGzFM8ejaXcT
 NTKLKRqBu7OV9QHJve8V3VPQcRiuBhSoZlPLNhLAj8w9bVw4RFyPFUVV5wRLxdSoOULJvOSzf3RW
 k64DGJ4Dne18Y1kXGPzXyMskAW9mbj6H4TCWrSPZpl5E5lCkyLtxFQZGlRtlczUiWPEAwqw4qLHg
 BSng5AFS33eSTcFGD3rvfKizbYa9sQuMudwBNzh8YpXwJMMJWej7zrC8a4QJwInr4hN9y7oD58VV
 EOex3Yb_ifFBERNJFhR_RtPL0vsH6EPhXnIxJE59VOmawg1NMDh3fGKQgW2BNfFSFqOkfYsU.hTw
 8TfocLAgjxpuoDXNSIX6N6tQcojoIntR87wmOtIvhP5B4LwWFnrosJm1Ze3yIf5UNo9Pc9b5bBCw
 M1ulHu1rQlUQGjy78sn234hgnq.Xz.atk90MTbKXOzlkUhZamEQRJpDhmRkJ3vFJYqMYHM8ICjd_
 otG.fJX8b8PcSTOK7PTnu9HvMyUDHkMyUKWL3LKdbh2JpyQKKjWb6xxYEWkD8lp_LuEwcI4dYW0h
 ccFej72nCmQXgFbrkwEkJDuMdK3_Z6dj4SkhkpR02GJkrqLrRaFSuTK5QFUIMnqBudy0uv6HfrVh
 TMxxZ.cis29hc9_F9PZc.fZ41WoLLa_S93PFH8EHa323fDpvbAv7DzTMHrwKLdc.uM9DTOx0tuaE
 wjwZ1PiV_5veTMWYOD_f9Iip2.aIM8n7zyRgfAATfXAZVe4E0yIvIvWhm7TIo050N1BDtrxKpwBH
 nf_opzTkL1w9sd17jF_Nuv6WpmjzIoj53tGg7AEKKD3mW3d222aFjzo8tKEh_e3v7cuDQ1avVmoK
 ioMcbTzVqpTy7ClIe9q9pyFWQgLXv7iYBr.tEkdj6q5cXiWrznoPLeWP.3FrklVdOaxwTSS2rf9G
 rVWCc.quiQsavaVuynTkwXxVCYqxsC.pGpTUA8wyGqyDL2jXoijcP0SYQ2PUXJUdWJIZgscX2Ij.
 ptPmrLh2CdFEF3J1OKtiqctlbSnl4hK5wVz3OBjZk6WMsXe.OP3zhr_MfPwlWHTaFuYsgk.9dILy
 Eg2jKHjwLSmgyZQcYi01bdBibyiqVsjlPxXhWZzVhoJ7wrDljjCGwhQ7b.R57AmJNdRZkNbYTT1y
 BlJAsVu0Iwi_L8yHcOKSxjPa3n1KHEJeGAzvflXORUCi6TjYkTMXW6Mp3IH5vD_FbPSNOze3UEVH
 VvQ0FckRRlXJ1DEQWhjo01qHjvNxzTQcAB1rOJi0sxIyqQQqZ7tIuHY3we1BSRE.6sVAowBB.TfG
 3PKDNbDhNWIJQc_DGIy.SR.C8N3SWEwPX5VGhgumslFVpjoPU4iqwTd2c5wsq3a8QMzhKSUX1yg3
 8iBTVfcqxZaXti3kA3TwhPrtoVc9VpdbDCLdrE5oIWxva3sBR.5S7POJqmkNbW4_EzuMj3_rKORh
 zDBkUNUl06A21ejgKouZs5JXmXCKvKTzr92byqOk0NYFErzxEucNDhfNwooFb5XMDrGS9FBz5D8n
 K__XEBKQ4xWt5QiaUvvN3y0xlT.C_iK5q1BBFopLma4iIU0vv7clDh00c1XxrbLyBWFz_A5aTQ8k
 fbAwCgWZlFmG2Caq04OcU06L2fpMoT_QP35JnT0au8lb2yJleESm0psUUDgicuxVXvlnO1SgTsJa
 ENjie3ZQp85Yv5BXzNexJtcgNduNpsQSJTK81cYW_r0_nWvOkOE5Gv94K5veAQvs8BlDMdNXs76K
 xRXj5YSlitAzFQO1Eje6r6DTwm7EA6TYjdruEoIY4S6YbjUaVjp211uIgXYrlVop26mYXXfXHkgQ
 _8bPZTQWH2w0oyOHJYWiJv.rXY_za6i11f3hFhl4YAEEiRkQkvC3vCB70ihfcrRUvtJk6rHrApeM
 0p5rkx8chWEBFAOw65f3aI_xFbfo.KJIKb3clFiT9xmpM0lJUq19_6R6EpSk2vNoCXpBiUxcNLWY
 vaK73gLZYz2XcBR0RAG2G1ZqTPojXj8CgWorulS.HZjA8eqA5Vfsxiz2gLYlF3BQb8PdmqcXIqCT
 MwQ3aZtoWuHeabBRDThPZo5hA8yN9iuMYE0aGmoCOxFcQ8gTjjj4OVyS5Gi_PtgEe3NYneDACMV4
 cTwjKZNl9DiEBQAE8MNb9x_OJnI.xfVUDabTN5zEw8bmbyuY_.EH5Bqr_WNfRF3Yt4LaDtbI77AX
 m7WgmG1.mOsPK49YXXua1Pc.1l.JBvzbmHHeAjjiTRWcHIo31N1H7aPan.ZuNJCm1hRysIyA.QbU
 bTCoX3TKwgZCjytoLJCXfmAmawGCNhCBdKPdr0kT1NJQDhUzZHvYLxN2IIpwlVBoMWDIeq3grPLk
 a9S.NEGhm34SGWlvn7YlpDSGwaUWn2wlwsEjrt7Ac0jQk8BlvERgDaF.BBjeXJiJXyC8kuV5EpkN
 0Ey_sROuEwogQl0SXYnDaNNRVTRb.3jyUgTruZBJUg3bNVKHu3IqB4Yb6QdzZdLV3VI_WtcpX8IV
 hlA--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic302.consmr.mail.ne1.yahoo.com with HTTP; Fri, 20 Nov 2020 20:24:05 +0000
Received: by smtp403.mail.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 13df31277140d5491dd9fbfc5f79afe2;
          Fri, 20 Nov 2020 20:24:03 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        linux-integrity@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v23 08/23] LSM: Use lsmblob in security_task_getsecid
Date:   Fri, 20 Nov 2020 12:14:52 -0800
Message-Id: <20201120201507.11993-9-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201120201507.11993-1-casey@schaufler-ca.com>
References: <20201120201507.11993-1-casey@schaufler-ca.com>
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
index 55f3fa073c7b..08737a07f997 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -3087,20 +3087,10 @@ static void binder_transaction(struct binder_proc *proc,
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
index be8db737da74..6b9e3571960d 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -482,7 +482,7 @@ int security_task_fix_setgid(struct cred *new, const struct cred *old,
 int security_task_setpgid(struct task_struct *p, pid_t pgid);
 int security_task_getpgid(struct task_struct *p);
 int security_task_getsid(struct task_struct *p);
-void security_task_getsecid(struct task_struct *p, u32 *secid);
+void security_task_getsecid(struct task_struct *p, struct lsmblob *blob);
 int security_task_setnice(struct task_struct *p, int nice);
 int security_task_setioprio(struct task_struct *p, int ioprio);
 int security_task_getioprio(struct task_struct *p);
@@ -1155,9 +1155,10 @@ static inline int security_task_getsid(struct task_struct *p)
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
index 4cd6339e513d..9e3eec0a9c29 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -2136,19 +2136,12 @@ int audit_log_task_context(struct audit_buffer *ab)
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
@@ -2356,6 +2349,7 @@ int audit_set_loginuid(kuid_t loginuid)
 int audit_signal_info(int sig, struct task_struct *t)
 {
 	kuid_t uid = current_uid(), auid;
+	struct lsmblob blob;
 
 	if (auditd_test_task(t) &&
 	    (sig == SIGTERM || sig == SIGHUP ||
@@ -2366,7 +2360,9 @@ int audit_signal_info(int sig, struct task_struct *t)
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
index 35d6bd0526a2..8916a13406c3 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -473,7 +473,6 @@ static int audit_filter_rules(struct task_struct *tsk,
 {
 	const struct cred *cred;
 	int i, need_sid = 1;
-	u32 sid;
 	struct lsmblob blob;
 	unsigned int sessionid;
 
@@ -670,17 +669,9 @@ static int audit_filter_rules(struct task_struct *tsk,
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
@@ -2440,12 +2431,15 @@ int __audit_sockaddr(int len, void *a)
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
 
@@ -2461,6 +2455,7 @@ int audit_signal_info_syscall(struct task_struct *t)
 	struct audit_aux_data_pids *axp;
 	struct audit_context *ctx = audit_context();
 	kuid_t t_uid = task_uid(t);
+	struct lsmblob blob;
 
 	if (!audit_signals || audit_dummy_context())
 		return 0;
@@ -2472,7 +2467,9 @@ int audit_signal_info_syscall(struct task_struct *t)
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
@@ -2493,7 +2490,9 @@ int audit_signal_info_syscall(struct task_struct *t)
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
index 18749705a862..cabec85136e1 100644
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
index 3dd8c2e4314e..2a18124af429 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -65,14 +65,16 @@ bool is_ima_appraise_enabled(void)
  */
 int ima_must_appraise(struct inode *inode, int mask, enum ima_hooks func)
 {
-	u32 secid;
+	struct lsmblob blob;
 
 	if (!ima_appraise)
 		return 0;
 
-	security_task_getsecid(current, &secid);
-	return ima_match_policy(inode, current_cred(), secid, func, mask,
-				IMA_APPRAISE | IMA_HASH, NULL, NULL, NULL);
+	security_task_getsecid(current, &blob);
+	/* scaffolding the .secid[0] */
+	return ima_match_policy(inode, current_cred(), blob.secid[0], func,
+				mask, IMA_APPRAISE | IMA_HASH, NULL, NULL,
+				NULL);
 }
 
 static int ima_fix_xattr(struct dentry *dentry,
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 2d1af8899cab..c9f1f6bddab5 100644
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
@@ -429,9 +430,10 @@ int ima_file_mprotect(struct vm_area_struct *vma, unsigned long prot)
 	    !(prot & PROT_EXEC) || (vma->vm_flags & VM_EXEC))
 		return 0;
 
-	security_task_getsecid(current, &secid);
+	security_task_getsecid(current, &blob);
 	inode = file_inode(vma->vm_file);
-	action = ima_get_action(inode, current_cred(), secid, MAY_EXEC,
+	/* scaffolding */
+	action = ima_get_action(NULL, current_cred(), blob.secid[0], 0,
 				MMAP_CHECK, &pcr, &template, 0);
 
 	/* Is the mmap'ed file in policy? */
@@ -468,10 +470,12 @@ int ima_bprm_check(struct linux_binprm *bprm)
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
 
@@ -492,10 +496,11 @@ int ima_bprm_check(struct linux_binprm *bprm)
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
@@ -629,7 +634,7 @@ int ima_read_file(struct file *file, enum kernel_read_file_id read_id,
 		  bool contents)
 {
 	enum ima_hooks func;
-	u32 secid;
+	struct lsmblob blob;
 
 	/*
 	 * Do devices using pre-allocated memory run the risk of the
@@ -649,8 +654,9 @@ int ima_read_file(struct file *file, enum kernel_read_file_id read_id,
 
 	/* Read entire file for all partial reads. */
 	func = read_idmap[read_id] ?: FILE_CHECK;
-	security_task_getsecid(current, &secid);
-	return process_measurement(file, current_cred(), secid, NULL,
+	security_task_getsecid(current, &blob);
+	/* scaffolding - until process_measurement changes */
+	return process_measurement(file, current_cred(), blob.secid[0], NULL,
 				   0, MAY_READ, func);
 }
 
@@ -679,7 +685,7 @@ int ima_post_read_file(struct file *file, void *buf, loff_t size,
 		       enum kernel_read_file_id read_id)
 {
 	enum ima_hooks func;
-	u32 secid;
+	struct lsmblob blob;
 
 	/* permit signed certs */
 	if (!file && read_id == READING_X509_CERTIFICATE)
@@ -692,9 +698,10 @@ int ima_post_read_file(struct file *file, void *buf, loff_t size,
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
@@ -809,7 +816,7 @@ void process_buffer_measurement(struct inode *inode, const void *buf, int size,
 	} hash = {};
 	int violation = 0;
 	int action = 0;
-	u32 secid;
+	struct lsmblob blob;
 
 	if (!ima_policy_flag)
 		return;
@@ -822,9 +829,10 @@ void process_buffer_measurement(struct inode *inode, const void *buf, int size,
 	 * buffer measurements.
 	 */
 	if (func) {
-		security_task_getsecid(current, &secid);
-		action = ima_get_action(inode, current_cred(), secid, 0, func,
-					&pcr, &template, keyring);
+		security_task_getsecid(current, &blob);
+		/* scaffolding */
+		action = ima_get_action(inode, current_cred(), blob.secid[0],
+					0, func, &pcr, &template, keyring);
 		if (!(action & IMA_MEASURE))
 			return;
 	}
diff --git a/security/security.c b/security/security.c
index 9c1098ecea03..421ff85015da 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1799,10 +1799,16 @@ int security_task_getsid(struct task_struct *p)
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
2.24.1

