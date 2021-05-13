Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2944137FECE
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 22:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbhEMUUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 16:20:36 -0400
Received: from sonic307-15.consmr.mail.ne1.yahoo.com ([66.163.190.38]:45803
        "EHLO sonic307-15.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232582AbhEMUUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 16:20:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1620937162; bh=a7uyTu+wm+XMgRetIvea2zAb2tPOrXH0NpJuMVK9SFg=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=dbtNDofc2UjZL1n2GyMLwbu7hydzP+Cntzwuy5cd+yANMBa3CYlfCfnPoDXxoTEuA85GoGH7wgKmZRJvqwfIlQJJkci5BWIQ/58TB5Ct8f08XQJ3cOnyO8HPtAofDn5nOzEknmcfpfhfNK0+VyIsAY9g7K+AiEvXOyenfpasLD6tFasDgE9pq+1ZtCBtF5V+Dxagg09zVK8gtvKGL0VEnkQ/bzbO6yaUuc/SN0ZerZLuVKMofiYmxG8L9aXEzLusfp7C+q2rt0bfpRiOuduVYsqOWff2D4ExRybvqQP2toATV5kzDHjfki1LyigLRU/aKEAGrbT4q+AoAnQRfGiSaw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1620937162; bh=gUHj7wZjLwTZXUr8mDspBbn1xhRGGxI/meyJWdeql+N=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=nooVRB5hsi3zmw+AK73pNEP8vwpel40zzLcUxy1EzH9QZRAKw5KoEjrEfns6882j6iNCaPcv+/bMtLOQw73Q9QWf6kPklLD+Jr2Qz9hXhbitviur0Az7a/ItzY0Qb7YdXS69OsO9L2cd84eUUEw4qX4fah1yrZPiUbvOoR/f3Ag+6QkeuTvKAOLt1k5YVykGY7oXZ0e3Q2fyht6iebwayTLEKKXzUEiS3uf6K+RwQDu/unibLVsObtjVb5VT6RtugE59ljvxTEUtubQYZNP2dlwFLjkSPgP+NCc9dYEliQOaBIL2ZPCRimVDeOOTc0JrBI6m9vCE7PyWz3oGP5Sqvg==
X-YMail-OSG: L97p_SUVM1lmBc0WAHV8fvYKBplreNkdtardHJdOde0z_iZCdAxkTjKb65rCCBH
 GfYOhzwNh8bHozQLWo.s.jZiNnZwuPCbXEsKsf4OfJXoEmKjXdnzJrC6pcBmh.JwcELy6wxic2LJ
 GzvmUtfKo2J_jCb2LRKE5ikgkL6X8H5TtbqtQxeZ.2KGTbYoo.QwJQIqcSXu8URgEkDSXDPtalY5
 pQmBU1G5VCjtxD39sFOShLJy_EFjpBLeSvz4CGgG.msD6JSiy6LM9934Jhv_bllOuSdXHqP1Zudl
 zw3F4wJJBV5JbFGUCGBx1tozd0ktoARe5n2YhyDaNc5boNvrt4OzVK9JPl._mP0DrrB3t5q.ACC3
 1qQZOmjNS7MuXN6g5ruIbss_1hjXFTGvP79maZiYzWukmiWO7PF2CJiqI3bgOqpJ_j5eiQJT66so
 E3trA4zxLbnI3rb6dLd5s.hrtlEC9PhwS1MrwNpKWr5ilUgiCezcnUoA.kSOGT0iEN4HnQMEssOF
 SBdjH7hEI7GD7kPCTzTXgcLX0I9YwDcGDsM.n9Rhc8HyGRLPOVBEFvz1lpSnXOSOM0AaqUwxNIss
 VN5WoKDxFVGRfUoWHJ3N.tg.c1qtlbV3DYnSF_qT7R4OE0YBvt8ZorClyfxbW7d_nqmXXRQkD81E
 JreRYI_iekQ1hUTP5XzDWa8afHZfvrBTT7ulPRkJIegdTeglWetGPiriaG5bkYq7FwsLW9IWCjjX
 XzY9Vikz7AxQHv6_CLL0KddHEB.uIEPQQM2cqRTck1HhQ9H.AIOFKwu.o_nOt6buI.x06dQ51RLS
 TqMx7wG85Tqm6BhQH9FCiEhaEz0lTM8xE33d8UWNzelzAcpkFkDYNMiWBoRAnLfJ4suzng7PniVB
 hOx97OjCLLzZlYEm4bav4Qm0gBkpS0kxJkEbaSs.yaS3xwkeQ.7d32LJ04vmG3GhEgK3ynQ4vMET
 v08i5.chz5YmuoEKmPmEZ9zBvMXM88rSJTshizaWXS5IeahrleMDSd7TZyis_TnbdbFIicajK7xH
 sXcDUPljpYvi4VSVwCrravn3mwpMykShtBNPFzvyEATHb0WVsxkV6ncrh4TXpMpiXkLjCLxzmm0O
 TvS1KgflFGOLP2V1Wt0l1YsjkE9Ay4A.Vr0F6qwYAP2wtoC4PmkhHO4NbQzAaxh0tNo9BfVLdfcj
 2e8Gck3pbQ7tT1ez7fGGZXgY9kfLDklwxZyhRsBmGOVFjp5muPH3pxnKtqfAuhzTSEWAJu1jUp05
 G2kZq1C3B6lytPMM.TQkqaok_RUKDUIEs2wMJUFkDpnTxefjDxrkaUJ05YM8fanM86uJ.tJr9r4B
 kUKZbKdpq3tNdd34k5H0ZVnXC8XvslFDk8DznefCI3lDbcVIvFXnUKKDEbH5TIdh65cPvEVZTtBA
 Nyfs_TvMwXxmCPVLlHE37TNjSmTpDryTg4csl6n08CXheT27EzN_TBQxOVgY9mighcKAchUndkOw
 5IZHRt9T4zJbMjPDtNH97FwO73894Jk66XH7glEWDHAAk1b4AgPG_evJhwJRg08wjf83HrOEu2e4
 R6c2rVY42wWzrHXdapOXZLTiEAEmMbDd2uFk1K0VPlyBSfywjZXbl6.BWd9phc8SesXgV1pqg_P4
 OxfMKme3Y1icTHLz6uINSLzK1ToTBD1UF1ztTfLH.ZRa0bbDz2zwctpDpgq8cs387MjXj1GVbglt
 5vPc2GmSuCCCurVtr.d2uRmGSm4W7I.wqYNmXNfx9DEaOmugvI_YhU.j0NMzbRsk2nGqAsWTmv02
 sMFsbPdkDLJg8jJPjByqroBX1JenX1PRBtm6hmF.dheGAJmzwauEiUkm6zDMXDyp9XI01ekBWKbl
 ZWox7HLjJ_4Ais3i7TUhVFQfsUFuZrvHlueeYsO0jmYzX84ZB0_HtUm6cBGn.PxejW.haLMRLOt.
 QVzE9rSNu3I0U6Z5CrMKE8qlKTejE8uxPkZ6mLhT.xTqDDpoVnsiq3rkUONwZlMW4XHxrHBk3x6l
 1peSiK_DrbLOMyIleOTNHX2IQPyHBYeo2wI2NOHcldYEScW4wL0kyAzg0geVziBgLpAUhbiaiX.h
 RQDdTfDRbWTie7L7sZHidjFrSs9KAIZ8XZiIch0K3gm8A4F9ILBYZLAagHR3qqG8nBIfOLQmkGBY
 K0DswmV4owZhsaCqi54ApkPDRzXxU9Tp346V8GgrocDcW21Iuff6BPAmsbmrRlrHD2LeIaYIiofg
 F2SiH54jSuJ28D9mdVPceIpxL8cL1s3NJni90gMZXZyBXyWSfrM0fZDJiZYxDnlgjFRWcxrTfNC7
 DZVuCk9OVz9eNIMM1Rsm8mYLvaOfb2JPlf0QM83jp5bm3.R.02Z50otJ3bahRXp.3gm_JQ3o9ZSt
 r8qXJomIyqY_RbbsyONN7a9wZkQOX1pgEHj_8vUzdBXfNDyao1YEOcv8WbtJQ2bXOoIdSyTkRq4j
 wZLiu.oikKn4VOEMejMPBZ2Tgl.bJUz6AdvxIqmRuhWfHaaCB4GQWys149cauYb3KxvPOtJDqMdJ
 SbsTANgwgxH23EaWsR11jvJ9FQUg.CvP9kv8GyRqkMtb7F6oE3wnV1zzbdrdd.sWEEo2XduzKPEm
 kZK8RKvvIfOPMDDETSpuuAWzZEvDGZ3ab2gCvUu9OJV4ZYmYm.pXegKsyvwK4Sr1OLGmyMCMrPOO
 OeS1qGrcBueyiSwbp3FA_.viK8kGOZ2A2EM6iwuBc5ss7.km1R2M4bHb4syknAD4NCwdDBk3HRH0
 Ta1T.aeRdZ2Rm4E_8dnIytnkSEmZTSCtHCmo1ejm68kYFY5B7ZkR6hF5Nu8TaamAvg23.2b3MntX
 9CoKB26ZDWYJwFGRXmijSWAnFK3HbTYovHgaLnwp_Wy_VY48imvyOXhbmMCKP882ZxvMpKtQTrnI
 IIWP45DSJrU0z5rIrA5.VjZEgZ00xz8BA1FLlE6kpQ8CAuey3ZSHzzja8aaAZUTHXan_I6GrThe1
 Wve3N1g3HH2MxKKxnnnuviW4xHUNGOP9OJ3RDGqknntrJomAAvGivAosJck1eEOUglxVJGQyXk5Y
 dLlYHFcld6OzsyUJotKnowzt3AD3S5vNNYBVMxv.jxDQVzDdoWQJ1YtmzSv41t8If_4smVJazE21
 bRyABwRHzdMlZkmarrry2hozZjVOFgq.dcqdrcIfrljDH6yOQeWOETzM8YiXhf8hdgJmolod2q9E
 .4nKGSip_CIUGnlb389Ho.TkFdgFdUJO4pQH_rLSqNPSCZqm5lawGK5lG0Q--
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic307.consmr.mail.ne1.yahoo.com with HTTP; Thu, 13 May 2021 20:19:22 +0000
Received: by kubenode540.mail-prod1.omega.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 2b7f8645fde6207f4cb0830c1cd3b2e9;
          Thu, 13 May 2021 20:19:20 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        linux-integrity@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v26 10/25] LSM: Use lsmblob in security_task_getsecid
Date:   Thu, 13 May 2021 13:07:52 -0700
Message-Id: <20210513200807.15910-11-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210513200807.15910-1-casey@schaufler-ca.com>
References: <20210513200807.15910-1-casey@schaufler-ca.com>
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
index 193397a1fece..ab55358f868b 100644
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
index bdac0a124052..60f4515b9181 100644
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
index 9aeddf881e67..dd902b68433e 100644
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
@@ -2422,12 +2413,15 @@ int __audit_sockaddr(int len, void *a)
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
 
@@ -2443,6 +2437,7 @@ int audit_signal_info_syscall(struct task_struct *t)
 	struct audit_aux_data_pids *axp;
 	struct audit_context *ctx = audit_context();
 	kuid_t t_uid = task_uid(t);
+	struct lsmblob blob;
 
 	if (!audit_signals || audit_dummy_context())
 		return 0;
@@ -2454,7 +2449,9 @@ int audit_signal_info_syscall(struct task_struct *t)
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
@@ -2475,7 +2472,9 @@ int audit_signal_info_syscall(struct task_struct *t)
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
index 534dee9c7b6f..b08442582874 100644
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
index b9ba8112b3c5..11f6da93f31b 100644
--- a/net/netlabel/netlabel_user.h
+++ b/net/netlabel/netlabel_user.h
@@ -34,7 +34,11 @@
 static inline void netlbl_netlink_auditinfo(struct sk_buff *skb,
 					    struct netlbl_audit *audit_info)
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
index 4e5eb0236278..f8c7b593175f 100644
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
index 906c1d8e0b71..9d1ed00eb349 100644
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
index 0364531d92cf..f3b985f76dab 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1902,17 +1902,30 @@ int security_task_getsid(struct task_struct *p)
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
2.29.2

