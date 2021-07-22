Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35A6A3D1B0C
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 02:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhGVASn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 20:18:43 -0400
Received: from sonic309-28.consmr.mail.ne1.yahoo.com ([66.163.184.154]:43752
        "EHLO sonic309-28.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229886AbhGVASn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 20:18:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1626915556; bh=x/G2+bynwaZNbQiuFoGGKAMFr1MM69h3zsoWrVOqtwg=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=hekTGw5xpp346HKtAQQhdggdvzH033Cd35BsyGOGSJd3M/stzZDvsb2LtR+vbi7sy5H/qH0mQnU3iHJa6WjpN8kqIRwXVlNDH94/dBUF2gUAnBqW82XFBRRGtVWvgYCNEo4/PjY8HPmeQiRHcXtp6J5uiJmYVzS7f5XatU19NSbHvyFeLondt9nJTqlsOYGNF310jAKxYz1cdZXXGl5HsiUWvkJgmI9egRJ0c7XEpTJl9ja0yvf4vA7S0eShkhcDZPnXfxLq+qpdFPXL7sgoIjBbfsQOPmlvRhd9tG4KX0TzBQtp6m4y0cqFwSvPQCYJUA5Unck8BELvtd6VWYdFSw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1626915556; bh=gB+jCEF73i/QBH09UYV2mz7K4WNSOcfQv6YegsdefZ3=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=oYgFhfj+zV7Ym5CtuSBhcyGlInKXvnJinAyyProhTvCiFWC4KN+6Q82ja/zCu9WybrY9ym3yNjQfofF12xOj3xWQLeA861ZeSgIpJP4vKtCbCzI9ayxPUHse/w7JzlxzZWVqt2TTQYa0JU7PKv0MR05V7ECwO5pRque5Ro8Al6lKRlk2Gb4ZvOajDM6ZdOQQko18LU1nYMe2soblWLsEpByUAy3N0FM+ILJYC6SiBWHzAEwO69HRS2mf7ucL2sxkV++GFUCIoZ1E2C9rS0S2OHZc8xtZHE8FKdvNaGRuBZpYLkGyeTXKGlMfzCqIrSY5Hcite3gBz7dwoLfBq27O8g==
X-YMail-OSG: nrGxb5AVM1ng3i.Q0J2OotrpuuotXfeeOthIL0L8fWYEPZcJ0extZRkRgSFArJv
 7dmV4qezzOiTK.dxwLQXhhl_9eaVG9oavcDNSuPxj2TFxFbcCjVOW6W2US2TSAZ90swQbRSBvZOA
 hE97RSnP1cLUd9XFoeDiL8mXGCXvu16rqwS.LD46Yn.jzA6xOBlwm2o1_4_MBvniOpoCeiQc.NRQ
 bKPJRqMsNa_WsKH5yc2eb4irRm4GF4uR557lyc1E5gzfvx68lP9Gx3kg6FTj_hebGTyjzJO2PedH
 ciioKsfX.9Y9bhnbpDOpYQ__YVIMizxV6NfqS1NKur8QtJNoncbmPmepnIni6snWSBwdrhT5Ca9k
 oGl23aKZYvlw8gtQyfY4g_LvZe5CEoo8z6UABfIGRGOGM3g57fm0V0uwFCmiNHhoy8npBrXkTdVH
 2Mz.C0FJX4dDHq6kSVPsj9WfS.qkjTVimEuJauk9qfOISgN7DyeX7C.6EmtZ.xuaOzJQj3lKQvvl
 XoCh6ULAi7cRztHbu8Ol4bAXBmN30aUWotSSsUMsEqoohy3VuU0ixQGn6.CKfmsumWqrNgeBySlw
 xFAdQOOxkTgnrToMKZf8PYrLRzK9JS6FWgYYHdGyaYt3U4XpFrGQCK3k.FhQPlRd_gopf5UWhnfE
 PNc1LITJcj.CVoQWtfvo5AJaSmRLX8ocFiY1LiPKz7h8PcC9GTkF4sB3U2WWoYUpWdY3Z5Y9ep.F
 5DOe_cbrixGaeH9YAbf50euVBIjvTjOmwt1ugkbiNz6R6SOjN_IKms.GMaIz0hLb60o2bTWmqG0u
 sdIaOd37nHvpFRlMgxxxIHtQMzEWGalR_nRDgJYPZybxA6rN1B2tst3mvQwkH2DpuJaprdlIOF8b
 LxUSuOmsp13VBWT5k4wPAZ7J5k2cVYt2ZDsXS9NCCH0MVDQu1RKsJbhOkQW0.5gGm__dnIZcmqiE
 Dr.XbQ33KTvy_Uryog9bAzohcLtlVvW_1xnUtbvFj3ny9kM9ZB0.s84zpokbgQeXnObHY_AfC_Bq
 nXNcnVJkN5lPUZM95oJ2dSViIgrlO8DrM4MHg.T3oBJrzgy0dYDs0iOMP82B0zc3oMcSfH1wbuUm
 IznDAL7CxKyVGmTgYfIIUgoj28dsTmzpvUs6orl315HAuCSwagueeToWeILAw1AeC_vwKhu0TBAh
 YjjjSf5S115D9IIoO29f1BNVrrP19atn5xFmab6zXSLnw4XOE.gw2Hpt4YvTAcMbwdL_idQ5uyhD
 VKd_chOFW3lOy4NRFc1GoJVIwiVE9abeFBk8xQOjIofghuk6KvhKehu0s068lglpfAuhXDhpYqCH
 1k_yus.enAz.3FREse2lgKUwjIt6qphGPuQOMrzb6wKSwgN0EqVLdTI.uW.zTUoP3mYBRwS7U6EY
 R3fye1IlYUV5JKnHG6V4Q08tcmpK2.eELrlY7gbM_5wcih0.MvmFpsFQptWvNvvoUzycuBlWBxDd
 dSTPozR5JxtqphvoxSP3NizLINDVxN.yejytyI.HUdhsMuAshonXyDQvEXV6rKp_xDwrDDYWx7v0
 .cxUma7WYDkjweJYoXpOlRRc8EuyNCFpTgULVCW5uz6KUkC.4YYxqzZMYd4tqSBzQq2TQuEy_WQ5
 VQk6xFyQdJRHBknCbyGo9XgXdAumvHck6v9nfhKMvDQ38BAsu0wD4dyvGEp94MjgOFI24RH2bYV6
 gG8N1dPMRJYMBLM.rzwjfBRCCk3K3hyXXiykTpgwyuLEg006MTPPsgnTAHVcQ_xnXyLDFm.zZKBB
 uDz0ivc4sE2UfAhAFvi6lHalN._tSNhcpJNLpfP1._btfEwjH_GbM_qZrhg_7yeap4GjTOs1Gky1
 uRpGKyQR7psryHrTv_WPD_y5POHSWsdW7o75cbdFg0riORYZ8DveucbcvRtDnfJSmuHUsEZOu5C8
 PRrRvBjgsbMvYWUqjP_D1q0chjsjqsLuy5lXuNzpZAuD38.cZAXMhNekzC2baXErbZBHvkbNafAh
 gZlnKr.LJZNaXPMmVdaGYvgo.UOYvab19.ew9OHkrn3AdQ0eAYSKoLGqQdoBPZRcho8bYchMuG4j
 L50_KaZ3Dl4H7_LzvgSPTqvVuSJm9PQkT0zQvS9uT7BEmkAq_EzhFrxhDXh._8YN3xlnoteSoFIF
 g5s7wgu5NT7SskvfZexWkPimaXQX5mZlxJLq7aO5DKy9fH4ROq7w0BA.jIc7.6yze7fT5UnupDbm
 S7Jr5XCPIal_42ucm6vTFXc5Ik6_hs5skN4.Q16VpuYV4l4ALGMRcnsUVedNmexQJjixt162sjsB
 giL8mC.oR8og1dC8U4xi6GXJ_D8TjAbqo2R8jsF0_sGhDkYGrtctcZCd1ATyIKjP77xRK6HO1tAy
 catNwyjHgAlPEloyzQWofUXPnWTdWgdO7f6AJJJXDhZzpoXA2kjNwPAXqRLOWAvSZganJw3HopnO
 nrvJGPgzo85CrCd7TdWdZ039J3YXN7chqeWE64FSM774jxdcVED6Xoi2XmyN5rEWHDq_VZiyAa6N
 SdeAhYfUXGVdXxk493ENWcIC2FojrPvIA99oUfdzik.4ls25jUKVQtD1emMd26MS85bcQhXBPfPU
 N47XnswFEzDnY7siqe4mqKM43KpstwGoq9F6b3w0NOmTZ2CcidtefaUR294QO5_N9v7s7fRfi5Xi
 PswjCXBrlytN8iVmI9hURmkYtWWDARNEelg3OeTI9N.rc8HVw.wO53I_WMNMHHNwCUYyYrkXHYzd
 oHB.JXt0CvF1DM3LJtWO4z4dBKX2lx9Ug7f9k_1AlTDHIb5OX1IS.FurvLW61GQpvEArKgSfxQRr
 y4.jQNcfZ9DyFqMs1QGY5FlHkqvkdfLHqL9CyHRbucgsa7zyhLWIYD4f3AvQjX9DE0W7Y.Gxg1MU
 9erbFQvMHfWC0jrVIWFFnznM4FnEPqMHzuNCG.5xLr69McQ33O9gRM0iykp4UzLmxzB2Oa9CANPN
 vD1tbGsFu6Ksy5II5PW_6THk.32KoZRXtrsb58fPWq8NrqGjOsXs6S_z6L6eLFozouovN9_cHuTi
 9xLDsLMUU1DRqYPGaVcwQG6xDR8yMfkevqt0WHfoa6OJzXbCkMjmch1cZfqeEMJLG001OrUibhwO
 qV52cEkJWfF05Bkk5s5LMCo9I71Xf2hBPbjnIvfishQhDQbwAOMD6eiggaG0lccrkqsGBRVLdqKW
 uNxrMyTEwOxMUz.G5GXxeOUZjeyuRXsOLO.pYPA3XZq8iJks8IOwaO9LH8G7VX7OPlxgi1QDwk.t
 cxcnFDiQiYEF3UXwEnfxVT6a8Zo4-
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.ne1.yahoo.com with HTTP; Thu, 22 Jul 2021 00:59:16 +0000
Received: by kubenode550.mail-prod1.omega.bf1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 46534b0f2c1d69a6991f77e198249904;
          Thu, 22 Jul 2021 00:59:10 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        linux-integrity@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v28 10/25] LSM: Use lsmblob in security_task_getsecid
Date:   Wed, 21 Jul 2021 17:47:43 -0700
Message-Id: <20210722004758.12371-11-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210722004758.12371-1-casey@schaufler-ca.com>
References: <20210722004758.12371-1-casey@schaufler-ca.com>
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
Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
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
 security/integrity/ima/ima_appraise.c | 10 +++--
 security/integrity/ima/ima_main.c     | 56 +++++++++++++++------------
 security/security.c                   | 25 +++++++++---
 10 files changed, 94 insertions(+), 79 deletions(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 3e97a6de5e80..96dd728809ef 100644
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
index 886128899d5f..4070cef152f7 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -500,8 +500,8 @@ int security_task_fix_setgid(struct cred *new, const struct cred *old,
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
@@ -1197,14 +1197,16 @@ static inline int security_task_getsid(struct task_struct *p)
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
index 5cbbc469ac7c..098d0a1a3330 100644
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
index ef9dcfce45d4..e3d903d6e5e7 100644
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
 
-	security_task_getsecid_subj(current, &secid);
-	return ima_match_policy(mnt_userns, inode, current_cred(), secid, func,
-				mask, IMA_APPRAISE | IMA_HASH, NULL, NULL, NULL);
+	security_task_getsecid_subj(current, &blob);
+	/* scaffolding the .secid[0] */
+	return ima_match_policy(mnt_userns, inode, current_cred(),
+				blob.secid[0], func, mask,
+				IMA_APPRAISE | IMA_HASH, NULL, NULL, NULL);
 }
 
 static int ima_fix_xattr(struct dentry *dentry,
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 287b90509006..29befd24b945 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -388,12 +388,13 @@ static int process_measurement(struct file *file, const struct cred *cred,
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
 
-	security_task_getsecid_subj(current, &secid);
+	security_task_getsecid_subj(current, &blob);
 	inode = file_inode(vma->vm_file);
+	/* scaffolding */
 	action = ima_get_action(file_mnt_user_ns(vma->vm_file), inode,
-				current_cred(), secid, MAY_EXEC, MMAP_CHECK,
-				&pcr, &template, NULL);
+				current_cred(), blob.secid[0], MAY_EXEC,
+				MMAP_CHECK, &pcr, &template, NULL);
 
 	/* Is the mmap'ed file in policy? */
 	if (!(action & (IMA_MEASURE | IMA_APPRAISE_SUBMASK)))
@@ -469,10 +471,12 @@ int ima_bprm_check(struct linux_binprm *bprm)
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
 
@@ -493,10 +497,11 @@ int ima_bprm_check(struct linux_binprm *bprm)
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
@@ -672,7 +677,7 @@ int ima_read_file(struct file *file, enum kernel_read_file_id read_id,
 		  bool contents)
 {
 	enum ima_hooks func;
-	u32 secid;
+	struct lsmblob blob;
 
 	/*
 	 * Do devices using pre-allocated memory run the risk of the
@@ -692,8 +697,9 @@ int ima_read_file(struct file *file, enum kernel_read_file_id read_id,
 
 	/* Read entire file for all partial reads. */
 	func = read_idmap[read_id] ?: FILE_CHECK;
-	security_task_getsecid_subj(current, &secid);
-	return process_measurement(file, current_cred(), secid, NULL,
+	security_task_getsecid_subj(current, &blob);
+	/* scaffolding - until process_measurement changes */
+	return process_measurement(file, current_cred(), blob.secid[0], NULL,
 				   0, MAY_READ, func);
 }
 
@@ -722,7 +728,7 @@ int ima_post_read_file(struct file *file, void *buf, loff_t size,
 		       enum kernel_read_file_id read_id)
 {
 	enum ima_hooks func;
-	u32 secid;
+	struct lsmblob blob;
 
 	/* permit signed certs */
 	if (!file && read_id == READING_X509_CERTIFICATE)
@@ -735,9 +741,10 @@ int ima_post_read_file(struct file *file, void *buf, loff_t size,
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
@@ -859,7 +866,7 @@ void process_buffer_measurement(struct user_namespace *mnt_userns,
 	int digest_hash_len = hash_digest_size[ima_hash_algo];
 	int violation = 0;
 	int action = 0;
-	u32 secid;
+	struct lsmblob blob;
 
 	if (!ima_policy_flag)
 		return;
@@ -879,9 +886,10 @@ void process_buffer_measurement(struct user_namespace *mnt_userns,
 	 * buffer measurements.
 	 */
 	if (func) {
-		security_task_getsecid_subj(current, &secid);
+		security_task_getsecid_subj(current, &blob);
+		/* scaffolding */
 		action = ima_get_action(mnt_userns, inode, current_cred(),
-					secid, 0, func, &pcr, &template,
+					blob.secid[0], 0, func, &pcr, &template,
 					func_data);
 		if (!(action & IMA_MEASURE))
 			return;
diff --git a/security/security.c b/security/security.c
index c38816ef9778..458fded340ab 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1904,17 +1904,30 @@ int security_task_getsid(struct task_struct *p)
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

