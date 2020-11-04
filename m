Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA7792A7340
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 00:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387815AbgKDXxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 18:53:10 -0500
Received: from sonic301-38.consmr.mail.ne1.yahoo.com ([66.163.184.207]:44122
        "EHLO sonic301-38.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387619AbgKDXv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 18:51:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1604533887; bh=eZeO09DJlcX2wY8AdT21fgnfDkYz/4ihUnMP/xr6IW4=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject; b=i551Wzt33ltZfd8lOj0K7F8tISSsfwFLA+MV6ZW3oRBErZn+RKI5gFwGYBOCHMq1y8GPqjOMpqwPS7/XgNpnd9SNzHYFxHlH6U/PcLY7TUD2JczJFJkQiY+dG/9naLRFZ+p3BFbwLDQamE8f5JFSAeZ6X51cHG8ycg7OaGN02FBDqD3uo9XPQLR5mHF+XeorCD/Mw4O0T317cbf1paPCNeq9Vv3Il5BO970kKyQaVIFL1ZWIQzeKdkcXBn41eR/XDpbohqDIEyq2zNkowD85eDARV5qhbwYLFzRlLsgUpR5kIRLXWbILg+v030Ph0BEeGpNaCqihXnCyf4dTbTaQrQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1604533887; bh=Pz5ZBcP0XdSBWBdSYxf4t3NLqu3W/7Yxa+xzAYcjUq9=; h=From:To:Subject:Date; b=SuMvk9WXeNGevQd447PnvN2YqWxjEzUpZMa/9Z+ajHGhhmbnyGB8MM51RGrPu3Z3MNzY3PmqGHrQAC8/wW2z4xNOxQlpLh2jN+ZzuMOaQNZ0C/1mW0U08qkitk21AT4AJa2FZsBYHVZYETlbkZ+Wl+AoZxSNwBuPLS9my4V+SL77u5Ha4kanHBGIJELlbgegzk2wvba/LG+RkLQHYGSLLyUaszcJFfLGx+8GvMFb18/4LZmNUYBwxYq08iQ2O9+R5ekBnLDs4aGXTNWGfiVCjCycz0L5pht0q9Mz17kfT1DOnIIC1fcZsJXe28cNmibO62fr8g8wh2bm59rIit/TCQ==
X-YMail-OSG: JWufGrMVM1nvQtbpG73LNP6MlH08ll8BtZg7sbfpx85QxKbObE0ypmzwwyppB49
 g07GIL3aSsv.E.rQzCmv6CisKz7CfzzjmhMceD35jJ8Gu0Mt9zzT0hPz4tSVXMvwvB5u5ldXwUQ6
 LV7rxBcg0oQpzdRCzxhJAKHfuqDdaeoVffDJRqRJAbhWUS_3auzSjQOzaQadC6dqOvTWaJjZieoG
 ZGlxM97smw51PNGFRrqekfwGSOexvEuPkTMtuV0DSYQ64dxNt.AUW6oXi1BsfF6wA0OSbH8wqKoY
 5ycrD1tL798OSGaIGuZr70aewIs4QkH9KY3CuP0lyKtPIeU8NDHAcZI6EEJ9ZaZuzSD1jeVlek72
 b3HTCShFwNv_oK9SO5_DpyTS27nOqjIXg.ABrXHl2SKQ_czL7QEsv_dAwZSHa46X2f5I4JdiTHlb
 7Pr77lr4tLqKYlD_sp8n.LcPMI_C39rFcnkPTHlNxKubaEpYa.REvDfWV7vQ6UHpMP2rZxmjiTRo
 tnZoyAsQUbKwn_xlGrrzcV8DTuVmzPeOT0VbqLgOCQf0Bwad_XVmCZENBWa6SONtgZX6JJ39mTFd
 UCil8Pz2hpxYhX6YVbsOe.SrCwQfkHIcUQtc3eYjC4YKs.kxq_tCvSbmTDrgXHNyfYoEspcZcSL5
 xOQViMywIBc7QMACoPWwGNmkOF_4M2Nl98BOH61kjpXlD5jKHX8j1XsAR.WUicGEk0I3PY0Okf77
 AcoMRnOZV.ALEXfMoLLYyesRpyg94n95gvxmqeIGP3Zh7Erxu0V3dbU3Jw0oA1OL6fsq.kRU5r8s
 O90LFaQg5lEsLZiZBrqxytP6QexjUjSf.mAxV9KGUHxiGym6e_Tkn3vHOeIrIiKh5WkS6K2n5IcW
 9c6CNT3QEJzKXQIgx6N1MRbUafA4co6k3nAiT2mJDLRs4_slUsITGKCgMMsicQBD7CpsHBWJbWVe
 kc3SeKxtN1S5QNEOfuqyzusNJmzLcV5UmEyYpyJp47wDY9rdn5lmX_FykO8nb6XVQuxVqExX4KZZ
 ajJs4p6biVO51XqKKY9hhRSM_hWIq6lyvIF9C8foa0Ar8U356yupv8DblMvdZJ7eWOt3mBjyr3A4
 dKLbtJLtGiDQ1OiAdpGSx3lB3BzjL5hlREVjAfpO1JdvscGKrgynyWfkuCzlAc_bnVnCc3sX9Evr
 Ko3MOE.9TXTmE1Tsxr.syMACCV9ITHRGJFMpFLiH8.eR.nmwG3NLuyfoohiTGVC5N610Stu19E1i
 p4hlN4bKKTldpxVzgeQpWs8gTEWcTZKXm4XOsjy74dU7IhCpmJeg2vY.xBKZD4ah.zYgwIvPeZPB
 RhjETfoJA_u7MUIrKDwrLst4zch6zTOSz0.LlX3TEpKmkb7eFWmhW48.VNlbn1wb.kzxuoK11OmB
 aVZ_sVJVe5D_H3hyTJBkvnbYHn71GmsPoq5aU4Js3wjBVlnmSBc2b_3pdZYpxCRpW90TgXG0dL9z
 bfRukSnGGzQikJZZaxyPy7hWq5xIbvN32.OUskcaPRqZlZTr9py1UmYjhWg9Zc3Ez4dJ3e5q8A80
 bnT6stCrdYpF.kT9WWE2zvMq1E42xualJ7LlkVY.lExZlfkb_FvSLhDruPLNka71zf5_TUWo0dFf
 JaSO1eUm3cj.xDGRFb38pff6Cn_wDutpwjC4zSa0U9Q2LEetY6H4shsWFkk4o8Z1Tc6tb8vD4ly6
 ZutEq7ZHbcLeQ2BIky1kmJRz1ch4fQc9vtAoexctP1F9ejdjxZnGVR8NbLYylmizlViwaX8LyOT_
 3mR7rb_NoFskC.hNzsIqbMry_5jeGCj7E7Y_lAYA_X1GfF81ij0tX.mIJK93OJHQSaZhpMPzOPMP
 0GOZz0MExNTr.YS8hojxWPvoSdLhYfjmtnRL_fr0Kfw.fXdYmbMuMxQ0oKFTf40p.xa1dj8F_PrM
 AzoiT464k_SzSnN1iwBbU3BIgr1ERudLraKplKOhO85eQuMOwgEhS6wSZTy.WNqe0YRgHH6YMcvW
 A8lZ7Hr73irEFjvgSKBNdNyQrsIP3AnaBIjcYgKnlG_vC5UxfP_bwLc2nVBPfBnj7rfXZpvHk09e
 2kalcOpPvMEaIL4ZQEP4UisX8V5BbL2XR08z9ytzlzqELGnUQm6H0vpRfWpdUmNeFO1S5.ZQUpPk
 cDAAiPTsBjh_X60CsQZXOx57KiZQGD0QSk5BUQg0S.1ynfR.RvYRPP8aV7_Dh4CgrsTK8p7g_w9l
 kixEE8Zu5_1IKtFVMQh46.W1GUhkNrTuJnHdXlUpl5JCNhlLQz_bMzoOzUxTolaMRYZr5sHaRWRc
 G2OZkAXl7sZ7YzrUyLpf1spJqtG6bP4kmOqrc4bWNy2foRQYydobFJoIE7OS8RfTySeXXEGKKEEm
 3DjxjuZ55PF_qcEW2K.IfDPJiKOHx__rREtZouqQRQG34NreiitJWZnTgHMFeLNEqQyLlY_MbVbz
 TjvLX1ygIPGAhXAGqQQrGbJwCnrque2ICAQzL.GGqXZSA9cjr55.lzgPNoYm4nT6qEqXfPzGOuUz
 S8ELXU505OAu6HHIF1YB2Ax2vDIUgF53FGCxFvAIyuP8iuHqEoPH4C.fDtJoQz_amwfpqRA65cHw
 wUuuDp8i4BAXuhr3LPT9em2YzKtyOLfR3C0N9YOM6D89sYS8oF_2Zq5jnno7Lc3KULne333_pakF
 srcd2Lhu.Ivvqfv_LG9qx_h2xcPRZo1m3woEGObyBtRxaqUzjhgPh4M2m2GWu9Zg5Yc8BHa5Vc3P
 5MMVnEZT7QjF9qLou_VfvyzoFtJiizTWkKqpjuzt1G0L1xX_SJiGadD_JthBgsXsz3Wlse_R1wR.
 GOxY4xaSGzBjCxN7Q_lEpfFMSGHFYgOfmpjEnDOyHlnUG7zAzmx7s3bDQ_S_rHEZIKgy8df2z9Uk
 ldxvjtcDZ0guSZLRKVi2cb0t1fPml5vNSy8qTj6c4FFWq4FZY9MiAWlRYt0DIr.OC0vnN2ONZDzV
 wz8HsGXPI4PDCYRKdS0FmOMoyKTCjOdWkYzfXH4J0EtA1txhwGRnImEotASzNNW77odP2gqtGigC
 P40NRJT8gpuUF0heBFY91cAAjZE9wXZw2tx2HwutHv2Kd2.gJqsS6jhWMyKCT8us5xRnKNtqTa1m
 R18LuA05b1zjCjTWpzpANj.3s6QoVnmVblvOdvAD4xS6VDwVCGaKfOcPOx5dxq7XEklI7SaJjSaf
 kkIptLVEfDBkxtZj9zuNyY3pVtZiybzMbfru1L4CXww.gJQuIToWfWxH7_QGAnqSxCeHv1V4W60t
 d5t0uzAcaMeyApLJRlJTreuIJORgQnMzutgXt6_4HgrTCpce3NDx12bPhfDYRAiUef11EkjWFa2o
 omEyNuwQ.Pm0NvoV5P16cObJz0orrPsE4eyjEqrEyDERtKqun5gXg3Ke2Xi0ZRndNvaj27CGByBc
 3FfCDIkyoaYLhPozPxDDreQNAJcbPAF3YMdt7xQmPH5SAxtEHxQ--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic301.consmr.mail.ne1.yahoo.com with HTTP; Wed, 4 Nov 2020 23:51:27 +0000
Received: by smtp414.mail.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID aaf521eb30ad00320d4ff2ee1d353ff2;
          Wed, 04 Nov 2020 23:51:22 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        linux-integrity@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v22 08/23] LSM: Use lsmblob in security_task_getsecid
Date:   Wed,  4 Nov 2020 15:40:59 -0800
Message-Id: <20201104234114.11346-9-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201104234114.11346-1-casey@schaufler-ca.com>
References: <20201104234114.11346-1-casey@schaufler-ca.com>
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
index ba74901b89a8..94071f67e461 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -1557,11 +1557,14 @@ int __init netlbl_unlabel_defconf(void)
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

