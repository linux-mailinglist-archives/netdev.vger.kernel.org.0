Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA89304D07
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 00:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731187AbhAZW7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 17:59:47 -0500
Received: from sonic302-28.consmr.mail.ne1.yahoo.com ([66.163.186.154]:36313
        "EHLO sonic302-28.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727723AbhAZRDL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 12:03:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1611680543; bh=dFxn+XstgtjQ2XuQtuYIDEUl9oT83QnnSfCL65X5xww=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=eh8vxoj9xUpXpVNGlhpo3g2oV4OHqXZFkxqI8J8Hml4Ul7qPDVypfwD4Rq8q9Oo6MwGvqFb4Sww3dQchEa7HEFkGwgu+Km+5iinY9HUCNiqRbTUxN9NW0OtupBnsTjxaf8XK+/mzVaBeDum14+9HqE6dwvvz6fxD1Z71MLJWuaYKbhEaGJBPwQsDKP9MfYeVsfkj0ZlmoFGwKlGPfc7FP5iNWLSPOWOZC/PLqXhRd39n2aaGkCzko/2Z0leh7ZgUGlAGjSPgzKH+cEU2a2inUjwzANBe6NQzxgcE96eD7hpez/j/Znf6e6vukXYqkJhl1lPZ+DbQ0sOdlE/GTBtSyA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1611680543; bh=rgioX4APgl+z4swDFpM+Lsb7j+bofddUMPDl3luMqZ9=; h=From:To:Subject:Date:From:Subject:Reply-To; b=ibvOQGjDRSzCpHvtgWSqDT6cguggAYF9jgtFnhxTfUJ9B1350ib7IuzzP3OaEgMjBFO4V4+xci/WEzG+ngwnxjTJjTUIhNb6lnCp46USxnrke7voB8NZUmIvZNL4+cgaantB1vgqISKGyRUJmQkjX0mNx7LWA8jmiaJNN4gQu1F9EsXI4cwqRQN4ho4nCSCkuOLnBi/NFmX2zgP/yecmrs1H1YW6WLPSgRFSxOuU5JpCY8JFWNsqjDx3r3MIB99pwna4P5rO+GjvcqFDrDLxSy3fMEJ9B57D6kCTlndmDSXVE2ieyEKtZ99483js6n4DgEMg1v0gmMT+erSdhH9yBA==
X-YMail-OSG: GdA.bgMVM1kOalMoQXcSuHW7qF.N0PpMzfV_qVFedodKgPWEl11dovAlTHyj6Xe
 H1hA0SU5ME3_LtPj3b_Z6SAgQaqMciNTwcMXHe1qqz9V0qXxLwntDiZsIhlJCOtw0Fl3LtDVPFGm
 E0nxc1Wh2SxovUgEPhmPPl39EwebPlI9Qt.ngd..k2GmSHoQIraeTV7dwli2USseTKFD8W3m6QtF
 dfdBawxlIH2xIEryhjKxT5bxN1MOWPPbhI4QS8bz_1PtypXCqMvDmtcJNpVXNeOoSVgKz2XPXHru
 rym6fhLtB79yLIl4GaHTr8KL1ikDGAAwuBF3eNNw0zlHuir4eqepZRvvBQWS_u6P_z5OzKpOu9mi
 xyDbDKynMi8SUMl9EQcMwEjbYAgS0r1h1eTrsAcDMa4ZGkPIrphBFY9W6ywXAO.fsYej6Fi2klzl
 eUnAfqxkJYckyJgIJ.iu2Y9KWRvSGdCBw7GnV3ohL1JnDB1qK32zRS_Eekwxry3yXf5rsW2AKoFP
 xRrm9Pr69IJZmue74iPotq.B4XnjvhYaDs6BrpRTJ_t7o9GAZaYLsXYGBHobKKi607k.nCfkRNka
 jXQe9AXCptxuFhlxSLCSvERuycfNPVel6XudBQRjWTrQnOJRa15SPJsiU63RMDmZubAmmCePU6vG
 xK97sB.ZMOcoP1cIrZbB5Z10zxiTTD5Dddd9LJYa2h6Z9tha9AnA1H8zkqKBPlm8p1zQfMewKaG6
 KWQFU_8cxHuLWocVpmz0XmwlljDp_swtPr2dgzDpUcEbrt.5wCi5Tz79EN_3ucZY5ZyoP2XJjTHV
 2DVr9TPzo7dnyPXJStbjAQRY4orFKZ6vHY6tr_sCF0i3K8JkIVQ8oNTtS11mmL6RVRJoR6TCoHjt
 v7lDy6cy9C0YDx8nVuVbBcVtI4RHihQG1gcm1J6Gcvss6.ICUZ7e34dLZsIo2fFCmuVtekO50Y3_
 lE38IKDTEAluEShD2lLOEMS7L1tS9ir8nfsZOmSSmnuf3VwMw1F5pIGkZCOTqTzi6xX6vEiz0l2p
 ZLR5UOCpW_fvv6JQYHiuDanQh4rzpEZt2SOT63RMDkpthcU9n8rOIZUV1_fLlF8s7gVrJ_miZkAE
 1TPRg4_5BTcPRqRvNwtUGYNG3otz10.w8Z1jWiLsIBbrkiN_FtXIVNh1qNLx3ql3BOBd9oIjzh2l
 u49oZtVK2YrKyleSOzdkdP709zQDIoK0c.rcf3mrE13gIi7h.4xQfic4UP7fpQpl_69MChq0IRXF
 wnUmI_1iU85IWvrGhK_XN4oNvCZOI_i3rPKCMV.BrBG0TgOpRZw8U2c96n5tEWlnuyq0rYfwdwJA
 dhvNvP0bS0BZUkjMgANt4sGG_pdPQ4tJoW6gw6pDcZEeK457sa8M3Peq7a6hYbEcfaP4e7IuXgO3
 SpW3u04jl_VmupWWGWW9nyfi75DrjFCzeb.uTqgyTX154QAMCJQGmD1OXtjgBdwPZMe7pC2EX1qe
 8duxr3REQgmrmFhszjhaYjV.fRv.pvWal7skC4lAIAumQRhBv0cI8mDIandUs9QOmr5K.8A9JL8x
 cur_lWV6EpVk9JXefReWl0j7h3m5BUo0UrGFRe.Uf4_6BvPGv7aW1Ie.47jDseiqHRFfFDgRyZhX
 K4rFpZjvIKURJViA1Z8dhqxmQ9fWOhnOVj5dCg2fRFxNlCLzA9gBMQAUghEDgIEhLBsqJY16ZvZn
 IJuQPY9ve7HbCqGUp_cr3DWnb.HhbLZXgznv3kUvCy1BCUpLxhy6wC..2tzHCj4sHEK6oPWkn0L7
 exp0SNbOttXh8twYVxK_n6c3cABHAXX1Ep24Gbqh8dTCDOL4PnHf_ahQ3iBqsysqb0lmN4xxLnHk
 .xUXZlVqS3pGqrm2qvCt9MoLoHO5UtcX3_Aki_nJYdkKF1bYnjCwyd3xn5GonEtLysEaIwA8eyiv
 ITXfCldZ.TjaUmcjQ1zijlHujXeOoC2hO8MSFZLFAuL0SQf_qNMESQaBSp8h5gHxF51tQUt6MY1B
 hxLaBWgemqNHoNu1QyzqNx863G7XOna2uHQtPrpNUVVtQGmcBHOfZTQX40KgS6jZKYarWwvYYwEs
 H3694GRKCOZfyW3zZCBJUeB4ttka2u6SN_Op0NpKzp9LFp.5fUiiPgavq5BVguRHKfOnGa9D4GFo
 9FUcC4ftiS7lWCBXwZpM.VWS5YpT8Z31MDuS_MePGdSoay018J.36U0VJj_Q5V7CE1EFTo_Zkbnh
 xWSORmLPtaBMkNURG_HArwa8KDINLguxiTEHaNuPVWkYqZs5JMQ0flabiPY38XfHM91jnBMQOUgk
 LyLEqyVmIIDTUl60eWIgUzg0FX0p2bMQYT5ctS2T7xJsnpfNFHk4sHZepPjCFIXQpCXPbm7ZTN4A
 1UG_O6QorP4PSgUuNamFkju02X1lC.YVo4jjWr88x3xf.QMLn9HYV5.mpT.pIZE8O_tHi_Zukngb
 QsnCM1D60wU6e1ef4CqgIt2gUBjFuLrR3fUEHtRTzXm0tv37XCZW23R6J.1ntI8HQs.OKqEad75A
 QY_4T659b.Z.SuyaCBZSS8_CKvMz5uKi_usnZzHSC078_G6b1iCVGgdsLIFwzxfOCjCxD6tXEksb
 37fmcmHnK8BxsicKZW5rVtc08mxCV4YMjca_COepJTYmxJ0IOuz0D88EuHMGimOZkrOS_5aYIe.g
 HmVgrD2qVJHhLnyxJoNCA.pImmnl7vfT7oRPTIT3edbwXFYOqnDyHBNXSh41WutnnoB0c_CanXia
 GxthjFqrz6AW0.7zJRislARX2JPt6bM6BgcRZljvGCVoO4Ru28Cb_VQ.zt2DcJT1LZqVFSn6q2R3
 J0wm85aXS8BNBQ.5Fpj8tZDNvBP0M5Qm51XDJ2kXrwtuSlSHTtz0uMDol8XO8NblQADvjodlxfA2
 dURf85B7M28Aa5LYdv98xGdgGGHUQWwCO5IcIAMG.zws7TY0_zCsxP3HKy2oPxP3ruCuP5wutuIL
 FDvIodE_aTUgUj5WfBn8zAW4ywXDw6VShWBZoLRpsKmhGuzNy1hbpxM0ubsUYJjdYB86ecDT50cv
 ugvQMV1qpQFAtzDf3qJA22ZnR7F6Ut3CNzzDRHTDxBfnfZ2xJ5u.IgHYzFL.NvfUxjp6kPQal8pq
 .xZimiRYrMf66iXz32eF2vvjV2DSfqCWQNtelWNd9m94DIN.trsf2kWR4dD7EriyijbPxBFjwm84
 G8KcA3VTmW1c9R3k4GvLTrtcb
Received: from sonic.gate.mail.ne1.yahoo.com by sonic302.consmr.mail.ne1.yahoo.com with HTTP; Tue, 26 Jan 2021 17:02:23 +0000
Received: by smtp409.mail.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 8a206ee65e60eda6fcd8c0233148fc12;
          Tue, 26 Jan 2021 16:52:17 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        linux-integrity@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v24 10/25] LSM: Use lsmblob in security_task_getsecid
Date:   Tue, 26 Jan 2021 08:40:53 -0800
Message-Id: <20210126164108.1958-11-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210126164108.1958-1-casey@schaufler-ca.com>
References: <20210126164108.1958-1-casey@schaufler-ca.com>
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
index 20a47bd3930b..9fc245c1f739 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -487,7 +487,7 @@ int security_task_fix_setgid(struct cred *new, const struct cred *old,
 int security_task_setpgid(struct task_struct *p, pid_t pgid);
 int security_task_getpgid(struct task_struct *p);
 int security_task_getsid(struct task_struct *p);
-void security_task_getsecid(struct task_struct *p, u32 *secid);
+void security_task_getsecid(struct task_struct *p, struct lsmblob *blob);
 int security_task_setnice(struct task_struct *p, int nice);
 int security_task_setioprio(struct task_struct *p, int ioprio);
 int security_task_getioprio(struct task_struct *p);
@@ -1160,9 +1160,10 @@ static inline int security_task_getsid(struct task_struct *p)
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
index 72f6672a445e..e70bbd6b91c4 100644
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
index b3ad40787740..62e2e6de5486 100644
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
index 8361941ee0a1..afcf715de585 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -70,14 +70,16 @@ bool is_ima_appraise_enabled(void)
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
index f87cb29329e9..175a79076569 100644
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
@@ -659,7 +664,7 @@ int ima_read_file(struct file *file, enum kernel_read_file_id read_id,
 		  bool contents)
 {
 	enum ima_hooks func;
-	u32 secid;
+	struct lsmblob blob;
 
 	/*
 	 * Do devices using pre-allocated memory run the risk of the
@@ -679,8 +684,9 @@ int ima_read_file(struct file *file, enum kernel_read_file_id read_id,
 
 	/* Read entire file for all partial reads. */
 	func = read_idmap[read_id] ?: FILE_CHECK;
-	security_task_getsecid(current, &secid);
-	return process_measurement(file, current_cred(), secid, NULL,
+	security_task_getsecid(current, &blob);
+	/* scaffolding - until process_measurement changes */
+	return process_measurement(file, current_cred(), blob.secid[0], NULL,
 				   0, MAY_READ, func);
 }
 
@@ -709,7 +715,7 @@ int ima_post_read_file(struct file *file, void *buf, loff_t size,
 		       enum kernel_read_file_id read_id)
 {
 	enum ima_hooks func;
-	u32 secid;
+	struct lsmblob blob;
 
 	/* permit signed certs */
 	if (!file && read_id == READING_X509_CERTIFICATE)
@@ -722,9 +728,10 @@ int ima_post_read_file(struct file *file, void *buf, loff_t size,
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
@@ -839,7 +846,7 @@ void process_buffer_measurement(struct inode *inode, const void *buf, int size,
 	} hash = {};
 	int violation = 0;
 	int action = 0;
-	u32 secid;
+	struct lsmblob blob;
 
 	if (!ima_policy_flag)
 		return;
@@ -859,9 +866,10 @@ void process_buffer_measurement(struct inode *inode, const void *buf, int size,
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
index 197f69780783..3f0a3aedad19 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1845,10 +1845,16 @@ int security_task_getsid(struct task_struct *p)
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
2.25.4

