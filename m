Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17A503A3869
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 02:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbhFKARs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 20:17:48 -0400
Received: from sonic312-31.consmr.mail.ne1.yahoo.com ([66.163.191.212]:44834
        "EHLO sonic312-31.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230417AbhFKARq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 20:17:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1623370549; bh=OlF33fqb8tWOkrdqEYXm4D3xeEZaVbk1tN/L/KHioSg=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=AHjxJXYesLB/eqt+2oghZQvxJjdFVdEUHu3ddzx9HkxnF625W4//1Lc0xK8/RgM4uBTlPO5jWLU2H1UMbJSd/ZZCbhAvI0/g1HapWjbpdETL9FXFSSQFpnPS0GN3iLlfvxFQCKpkKJM6s19onZEZ7UBN8DqH1MCl+bbkWAzTompUM6Aj4ULq6uibnF4fja6UCPwlSMwcIbRoaMHCMEdH9bKMaSKBmCNTIyRGlq/FbevPtFm9NRGZYGVbMC7CM1snJ+39TIKdVp5RddepVwquGUWvQUnR84y4vXMfnGejvmRJ252akwkwPIrZ+wVZNE6JhMaJWcB1bBLjaLmMEEV8zQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1623370549; bh=rehM2rihCIFrsmcxyXH20xNTaNKRhbGfU/oem+hEQHJ=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=JvhbXEnHgvgfctLLfYix3mHYsH2H1YNn2pJqArC7xQLrRJiHM9DJdnBlWfWEN3r4U7ITkejEL7ueYlZ9OWy6iuBdgfZVLYofj9KTs0pkpvZzTszYu4UN4Fu4ewTbvcFf9YfHhY/IPYez46aBlSeCpqTW7FCkrvmMCtH1H+bSh30QiJk2oZZJN+POW5glyrqLydpbqKtQX64lcD19yfslizRr3mgdevyFZzKZIvoBGOyi60U5K9cNs6GH8OZrUkADblXnvwECt88RLSdE0YV2uUzLPdF8CmqfKBF7pu7CkXzwdUsqECTMFxYWZvIC8FH2dttMyQfELnQXAO1d3bJ8Eg==
X-YMail-OSG: .lCHzwcVM1mJYvtP1wfVqQggwoHi6cnwMsj1Jj5Fgs7.5.JG9tBJRDNMQzoWRyM
 ayt1UmWKeBHO47K3Ro5H45.MEDZnbTvAfZfwG2GVqEnl4YENLBDhksRhr9H_HBrVw3fKVefDhGVo
 x9GdtvoJ2O97rlYTxz2_THRWLOFy9N50W_cue987cBhMD04BAvTIzsT5QGn0.I0REXbc1P7FZppB
 Dkhf9FR2Ay.5.w.c8T_0MIuvYANm8gl6grAJynne6Xi1ZvUD.kROgfsJNbmxxDlNceeRTcfgH2u9
 vsMJ8HmYs6Cf96PWwaNkbDxj1rZs2s.7c24ctN52Unc8NMZ5b_dg3irLy20tokH.Jfqh8mT5kNeE
 nB0k7LI_yRcboKDgO63R6fxroxjYsP5Gmqar3f3.0F02oZuW9bV61Qnht8XgbovKrlZjqQ_CI4vt
 6j5oLOjSd_EPQrdBuVanEWLoGs9V1_JabA5h4QdPLOip176Z.nalf4XBDDxLcALXsh32qcA39JOu
 SrS6W0AXlSVDMSZBc6cNCoTz08dMVD4YbSYoKNPH8Kg8NI5oQZy4ehMw7sR3DYQORC9.A0jNJJ2b
 mx7NOWOoPQBxBHp9lxco063TKTL3.OkvHvC0irquDluwe6kpX7j7V1NDxkuLlzSE87CPp9U17GxQ
 JPqbu7NPUYDjyvYFZfpN8ptv2ExSeEGTjjKrkvP6bmJybLCDXy483FhDzO9Ckom3KAcPfKEmCbIm
 gM1pF_Rs9l.GHKxLWibi3csm.32dEH6ffLEvmlvueYzG3WQMHOGOFM9y6GYJcnibfwM84tD8tfRR
 vpUBn8GaU71GuzHW0Vt0IrL8ZwlhJzTzqa.h_JD5uOXONvYCBDEd8C1S3mDP_gCdOEINz6xdEZn6
 kWxJTfuFL9OJZ92gWGU96_mFTsEDzTuXkYeRpMb7KLaAGC8IaTjuWFS9OxlmpfcxhqjA.U7IEKTW
 Et0mR1IqEsKVOYZpstvfNzMXcGWSvc.WxdcNsARwczM4rk_Vl3.kbhJwHvTZ0ROtIjni84JbwNHx
 RPb9Or93e.3rCalKmrFIyiMQvjkfK_m9ag2NAQIT.ylMXT1nPJpYU5v5vgS01Hdk6CS8JNrckUmV
 fVu3A23T6pPcAnBqWQdZCCys81ympLESxFw0DycOW24NmbE2jS3k1zNBOr5a5Kr7V.rb7nzEJqc4
 y424Gtjm2Ziu6vUalcIvTBhnTsi7wlinT8JARoKR.Dv.arXeK0vHkO7jxDBdjWfi7EwkVxt3dAx9
 .GLCdMeLWMBsqr.z6Hn5RmDYOmyxCyiccKHVmDpC4RXzT6WXQR0pHA3CjMnsu2yf1eG8V_Fjxy31
 HBHI0jYOwYiGZzLNYyxb7j78meDkta0dhR0DIzQ0nzbPZ3vwvxwhZOsAyZ3v_agqywOteCwFlVfk
 1HEoYsjsuXbLog6FM0bOR0IpPvfGuMjziUgSsA16Zh9ch5YtHkn2S_3jphBZN3WtDc1IzbjzGCHo
 YFJaz75CSUkBEBJm_e2ULisl2yqYBo79aUWJKDBl.IrQRT7V9pLicgGM6ghk3kOv3NlwFfYDMq2U
 GO9oZY8AA57xYMhypcWAvKCRiw2SSQe_CDKsVGeoSC4EvY4bBlFUkq3Tfyd6Y824pPPX9kPgDjgj
 eyjWzD2Moto8bhbnQ1nmlm3JY5UgmbfqKc3e_zOEEVRb.mM2JXhglF8FEAisEb3th3ves8sDljSu
 7n8HzUWoJyMG3Iib1Pf37BMQ_Vprrt76gFFBxKSEfmt8.JnplEHgyc.lObxeLSxxKPyr5Nk60bhJ
 wlO1PNZ3aipiqcemyBvqu8wVqt57T6fByZV0VAktkGfFqKamIqT5HUbqnFrLMz6C65cnJ1grP3bP
 xJGg_YF5sG5L52p9GiEpyZm9iRhDzdQlN4dOGrm3SQofgVsd2weYZf2kE.CSUO_VWuouBrkc3bwM
 mysfNFwsIZXyYjbQZ4SWbRmdKYJ9BvrxTMCIEw_TarlyNlX3.U5M1HOk4PR30QlNrz1aWEzwZVOu
 AnFqCniwGJvh7FibB97jsrJNX5e2Fae4oDnngM2gGYp1k6y65xgjo5qHVUm.CRO9QaEpLjhE9udd
 LnGhCbrUzqNsMBItlbWAAild201NlAO1T1Jk5.iFWTbw46clOHO9Q01MiVfGbZ2yYxkUkmWuPtNO
 TjQo5sXZzhpyXRF2D517Hsa_cEloJ3g.WU8mvTuLtLiHjPTONdIjwcrXObiykuJCQW90i46s14X9
 HTI4pbKQIirHeNLC.aeaVkhKmKDplN03X2skuysbY7a5AZQaw05.Yf_mBPyiCwd1L5Vsz1MmWGcS
 _4.ClYNPlgzfcbOXxNyoMGzyNwtTDp2UGxhtkWHMcW7tymzbCC5DqGMjZVvzzAqwtr6QPNW4r8a4
 spTnc.rfvG8sCQnRU63N_vfxxGOWDgBf4LjvsYo2LXg5odJ7QZjgSc6axy1XwUsN.5yBl7XvBZ55
 rxKAp_l1spXis95IKuIi.WT.InLxN6E20Kwo04VUede8pIHBQwv.jp1M0yJnQIOR2i7wHhdigNLb
 RCo0.djQqLugqCPpm8tojpe.MNyXixv2l.kmn87lQPRaYIcmPon2t4fuantFkvzEmvMFR.dv8TqQ
 XrtByzPISVGs2QI8.FVExGlPV8sZ.R4v7TH543_UYg5Rq0TmZTadLwuwO9nykbu6y5g2U1I4IKcE
 O8UX8CKMc86re6un27sV_OG4TQCFAAo7tnmFKThZDviFhcMlnihj3O7Mmg369ML4UWXsV0SCVvdV
 OeWR6S1KJqrZyX9HKuENoDtWQnqOPU_bPXJlzCL41cptOTuoDvXdI5AwIk13WE_BqfwEVF3vx_oC
 J5dXaPIw2nA60C8YXT7.4FvvO8CO.mNBYh_cNoSqVBDiE4cxxIWGfuR_1RH3xdfYGfJuYJv922Jj
 OXXxdPUBlkbA9XWckKa77M15_A862pOoz6FT5qCwZKTV73w26GfRwld_3o5JV1BAmK1IQlxFqswY
 nrWT39bycYWAXUn5VU6jBsHJ7ZmtE_LUQ0O2ej_s6xQPiNMwCqZPJ5JneoQUFdGDY.7lHiqVP00W
 7nAkWceuHKIZNgE616Xf71Rswf84FwaoSwlUokMdH6FtlJCjBdZXbJGm1RtjsFwo_HHTsa_brUf8
 VFLmDX5ad_coj2YROeprQtd_Ih3K3e196TTMN6oPzXmaB5zxTzk62RBKVh9ha7pQbA9fufEvYow.
 AgJUMcmLoPI6SeZFL.J1JEPakp1LRmygwCPOvW6dXYagvgfRQADmsJn7z7b0S8Xmp8cBZIj.6TdL
 bOw8iz9hjYm1bympXXqU8_T8g7hvS4XQ_VA8-
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic312.consmr.mail.ne1.yahoo.com with HTTP; Fri, 11 Jun 2021 00:15:49 +0000
Received: by kubenode557.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 264b86f3300bf3b01d750e08400c1764;
          Fri, 11 Jun 2021 00:15:47 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        linux-integrity@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v27 10/25] LSM: Use lsmblob in security_task_getsecid
Date:   Thu, 10 Jun 2021 17:04:20 -0700
Message-Id: <20210611000435.36398-11-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210611000435.36398-1-casey@schaufler-ca.com>
References: <20210611000435.36398-1-casey@schaufler-ca.com>
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
index 7f722ac04d99..ce22903ccce2 100644
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
2.29.2

