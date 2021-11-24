Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 199EA45B17C
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 02:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238713AbhKXB7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 20:59:02 -0500
Received: from sonic306-28.consmr.mail.ne1.yahoo.com ([66.163.189.90]:35158
        "EHLO sonic306-28.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238955AbhKXB67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 20:58:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1637718950; bh=7MiUFyCmfkC//4vnaYq/YKc6j4ocqCWB/2RMJPU3nwo=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=hsq3iHIWoxu3jFteNF1W4lpWvr9tmc1iU2bntRgRLcJSJaDWA8+fLt0tHUzvht37ZlPjHBlJUCo6nHjiPHl1gxpRLmK3ANasBQ0tBUM7xBakuZytoDNlmrvzY76Cr/S+EKvkGRyAvegC+E+MIec1YUFk/soYaP9TDmmVSppCy7vThBjiduZMfwrcqVfzp8jXiybHyr9ruGEuDMxfX+kGfBCHkHMtOgxPhasy4bc+TddvDPfoNb4c+4kMAD8T1axBo/kYqCTwu3JJ+ZoyPvlCrTHcgCYcYmpoMwf2M0Dj/yE1d4IUAyxkYu9COZTNtTnWUJi+PZhJyA82SsWwNHkPuA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1637718950; bh=xbeUysdvsbQ7KdjsehGv4BIwjhXQtvkgXbFDYAs9GnJ=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=S/gDAKqftZ+iR+HnqFPnYSj2E7lOruCEMKInEGGxIexX2zHaRNJ7ddIwbJGH9ZvoaBwhJoZlPR/+cYx31QVBj6RbzFaEOAhqzP010cSAnakRCEk6MF7F0g2zy3wwGYJFqBCl7QkfNSjFnNTVYeGfAKKt2jAZqdjqn4vAhs4gifes86DPXZUkw5uRG/QkSgcJEPNqTowVI+eUsl4Z9U4jM8AZJDG5oIaCxirYX8oumnH97N22ZtL+zrA69/x8pRqSG8fyrgKOVSlse+oz1sMLF7SZgOfex7GhsVvRyY0w6sgOz00Q5HfDiwf21q3zoZ3nYH60Ybgbe6cOYnbC5iRDKw==
X-YMail-OSG: .NGEq8kVM1m5ea_5_RdkZfniA4gsr5x8kx74xZIAgxiCDKsjrfkfMErTj4fjY9F
 kE99kkOe1los1G1bHmubDnVXdBVolkcHmXmc3SYTtO1W11ZPSIEbE8uUBAOilmRGvh10DEYEk4Zr
 62OHDb6wbze3ouU5cBQ6dwxeEcNSsh.Cv.CsZ_PFxvykto0L3tUO9MILZQRN_wJurEoRfeqm7Xr0
 7M3ilEeUt1dzNGmJv7qsTaK.fbsR7q58QK5xLBLuTmcfTnr6ahiWauUK0h7vJJFPjVVOiQLiANA1
 Ge..WshoaKw5Q3u1ucjJZ_xkWoEdQcbZBRZkj5_xN38GIM70iuQYgEHVyNBhLIqoI.cihQF8n7Px
 RTq.lWDGg5MP7MTTQqieDlkrvh7MOI6U14rOzC9L3.HJgLCRNgK8velXPwlxV8ZPMB7pKnXFeI6D
 l5tcXC7_IYGlQg_zhuhRuYDD3bdJYTJ.M77UXPx2bIIRxYnieallVmlybuEuEklxiR8kev92K8EP
 WggSuSyKYQyUD9sAcfWx4vvATaHOV6.zb4.yZHeT6OcWY55F55G_4EfBB0S_QgzduRuem6GPR9KE
 tkFF_NIX1FrazIG0YJPNec2J1UoAdn_49N5WyhPKAkuFxBkHbN.SYeJf7DXCxyowPcId7ZJFmpX3
 wa0DMxmr8AbY0VlJIYtR3J7mRqt.QUgwAIxM_TkhWub42ulruJl55u838Rng6_trNvvByFKdu.0r
 XotuFQVeHQus.N_z26Epz8jEzXbshrfduXQd__.ysr_CjuX.m0HLskdt_2uzxB6PrYNA2PnZMOAT
 4GN9oDqLtr42d20Wk_eBwhDLcXI03BEWHajw.M4.8i70bUeYPRVyl.h3iiSgzlqRKNIjUPSuuEHZ
 8V.aEGl5YvPVVGATaLNpIFXNbOEWfOrskt.isbm0mFdS2y5Hn5BA2ys6ekF.xQ0O0Hju_Q5v8jkU
 xyhtvoN_XvUxnEH5AvByRq0eb2IcEhfVaV__elDKY4Okl41eFBRbHcPsoQuUyFK6YLIbPq_HJaZU
 T9Qk9Acrj_vpKNOVAo9XcDKaTUcszVFHs9vsGH77vXy32ebzduPsxn4Ltv2FN7qgXOT4fRW9DVsm
 6IAkIA0XD.saWSddrql59gPGnADHdjNsCW7DHf4z.izhM_ZTbkN0V_tobgZmJRnstHs0XGggKNro
 ciakCKS0GXcJ27drxX3lA99aAED_vARVJbVY_mvqhoI2Az5stgtJoM4.1dTqikAZWXrYF3E6ta7.
 C8C4f6l5KRoseT8cUT.aaU3ZzSVkHim3lMmdWv3udzaOKeyccsT2MXg4WOk7HBuTn9Qt_PMnKqA2
 UzvHSqZ.h7oQnQli0yhhpZ2ob0sdkZPnKzRMdL8_7bAv5GRhIH0m59b6wm5JC89Oict0nhYhosXM
 OHmJwngQ3JWM2pQPELZ.LQwM5.5IS82m9oO1AmNfvaFs.i6qozFnGpTDKGUAFgmKBjss3GfwmChx
 ACDx5NTjA2IsrqAYZbH1CohCTeig05oFuz4T65ee1hvw0nnVJUDqGYfPE1WyX_.QDcAh1byYLw.7
 QkxKY94HsO4F2.skmVarntSfZcaL5h6GCPOFEnS_FV.ygqDWLPWa4TSnOb3SRjdrQCjj2pB95X0D
 oSXdBWcFhXgFBoyj.WjaXGKhGBAuYwiACgx2pEl_XZnI_Li_WlX02zm2sxDdggkusXssaoOtOP_a
 Y8DdqyFBYVDKSnqnheojHWVkCww4C3fSXL3RKEUJ2Kg5bob3EH9wu21PYpOB0Y5SjuHkFDtv.EpK
 P6WWrSVxcAdT0DVFuv96cIvxudRrWnxDcA7pWUHWpaFGElDgdpwzilKloWGx09wIkapkCUFDa.Mk
 25moOhK1.Jp4TsRUEU.cu8KnE9sQOeMmGa4mWlOMV3fDf2kbjmXqOQnkAw6klF3S9ZNr87aG7ypv
 vXDebwH5kvl94vuMz_eNZXl5U5KUKkT4.D3158E.zm9GRx_CVG91xnep0Ymxe8pR163njWjr_igE
 ie.xYTOyq4yHAbSYETDumuUybuV_nqnx3ZD8s78Wc43EB4TfZ63SbNTw.6rb9puWp5EjPUhFTkeO
 _040hgJRzYsswmtt_C75kZN00JFvriCLAA8Xwrm25CUnJU0G8YKYgebA.piVjA0vnTRJTxsGurwv
 UY5HWkk_uQANd380sRMBoDqad71Q6QSnrZ2q.5_H37.FEmU2_hrMNLz1g4ew26Q4YMyVMcyV_AT.
 94JpEcBDB48bNSOvhlr7OkW4HzaJrTj6eigiBLAxhhq31Q5bCbdA_Z1LFficGBXmrhstjmhrt2zu
 NQtGDXZedzds4156_lDVVYMba868quF8hREw0k3_ams5j
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.ne1.yahoo.com with HTTP; Wed, 24 Nov 2021 01:55:50 +0000
Received: by kubenode511.mail-prod1.omega.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 642dde53d69d58293143a094a618e31b;
          Wed, 24 Nov 2021 01:55:45 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        linux-integrity@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v30 11/28] LSM: Use lsmblob in security_task_getsecid
Date:   Tue, 23 Nov 2021 17:43:15 -0800
Message-Id: <20211124014332.36128-12-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211124014332.36128-1-casey@schaufler-ca.com>
References: <20211124014332.36128-1-casey@schaufler-ca.com>
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
 drivers/android/binder.c              |  6 +--
 include/linux/security.h              | 14 ++++---
 kernel/audit.c                        | 16 +++-----
 kernel/auditfilter.c                  |  4 +-
 kernel/auditsc.c                      | 25 ++++++------
 net/netlabel/netlabel_unlabeled.c     |  5 ++-
 net/netlabel/netlabel_user.h          |  6 ++-
 security/integrity/ima/ima_appraise.c | 12 +++---
 security/integrity/ima/ima_main.c     | 55 +++++++++++++++------------
 security/security.c                   | 25 +++++++++---
 10 files changed, 96 insertions(+), 72 deletions(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 01cef18f942f..780c7e265f3a 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2718,16 +2718,16 @@ static void binder_transaction(struct binder_proc *proc,
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
index 42c99237786b..efd6e88d57b1 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -503,8 +503,8 @@ int security_task_fix_setgid(struct cred *new, const struct cred *old,
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
@@ -1206,14 +1206,16 @@ static inline int security_task_getsid(struct task_struct *p)
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
index ffbd8396bdc9..de165c2cd55f 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -1340,7 +1340,6 @@ int audit_filter(int msgtype, unsigned int listtype)
 			struct audit_field *f = &e->rule.fields[i];
 			struct lsmblob blob;
 			pid_t pid;
-			u32 sid;
 
 			switch (f->type) {
 			case AUDIT_PID:
@@ -1371,8 +1370,7 @@ int audit_filter(int msgtype, unsigned int listtype)
 			case AUDIT_SUBJ_CLR:
 				if (f->lsm_isset) {
 					security_task_getsecid_subj(current,
-								    &sid);
-					lsmblob_init(&blob, sid);
+								    &blob);
 					result = security_audit_rule_match(
 						   &blob, f->type, f->op,
 						   &f->lsm_rules);
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index bba31349ae3e..7cd70a43408f 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -467,7 +467,6 @@ static int audit_filter_rules(struct task_struct *tsk,
 {
 	const struct cred *cred;
 	int i, need_sid = 1;
-	u32 sid;
 	struct lsmblob blob;
 	unsigned int sessionid;
 
@@ -667,17 +666,9 @@ static int audit_filter_rules(struct task_struct *tsk,
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
 							&f->lsm_rules);
@@ -2703,12 +2694,15 @@ int __audit_sockaddr(int len, void *a)
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
 
@@ -2724,6 +2718,7 @@ int audit_signal_info_syscall(struct task_struct *t)
 	struct audit_aux_data_pids *axp;
 	struct audit_context *ctx = audit_context();
 	kuid_t t_uid = task_uid(t);
+	struct lsmblob blob;
 
 	if (!audit_signals || audit_dummy_context())
 		return 0;
@@ -2735,7 +2730,9 @@ int audit_signal_info_syscall(struct task_struct *t)
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
@@ -2756,7 +2753,9 @@ int audit_signal_info_syscall(struct task_struct *t)
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
index 2e74e5e88d64..1b9f33097216 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1906,17 +1906,30 @@ int security_task_getsid(struct task_struct *p)
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

