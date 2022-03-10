Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D43F24D55EA
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 00:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245226AbiCJXxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 18:53:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344945AbiCJXwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 18:52:36 -0500
Received: from sonic308-16.consmr.mail.ne1.yahoo.com (sonic308-16.consmr.mail.ne1.yahoo.com [66.163.187.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E279819E73C
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 15:51:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1646956292; bh=E8MURJmz0LV4/J9e8+2M786mlXNzUX9F2mLnAQJ7BbM=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=msgsWTQsSdxFNaktQQTCdwp+uf/F371m7uemjslbpuGP+qkGmaMtW1hrG+XVEu2W0BOuAJvL5AQBwBfUGnHsNwdMNZgCzumXyr9vi/ifS1YHNiHm1LolyPLb7qkrlx1kB/2/bGLw5RO28X4z0bDLd4cGuHvXzPwtAs1gA1Uxm/Zn5hdEDqspJyzhFVvXLUpfkvcMpLS/DKCg3ZURblXz/npKYJRnkuzHLryI7Tw29vjIAO/JBQLYWGFyTef1RGdnrUxArVL20pWN7mm5sJC7OdqJSbYo4c8TNuaPZu05S2RLZJRXQCBPjoRc3eP1IuyGpDGYigdiE3LGLSAjZNcksA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1646956292; bh=j1fCpAd3ABVIvrM9/w3UlkRKHS/XbWxp7tu7hcGc5Yq=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=WxeB+vSWYBYwvU7O+QDVkAU0N9bhmuGQwK5mNTm43IfEZpK2mEyfkmSD9ATistBLOPP7hkzLpa5CNsHSY+fbwZEk7MTrFweJe7QWJ2JvdUBm2T8bIv38b2c+nGtzDLe/VBFFTdcfH6QZbyjrLmQrmtZxMUJPxcU/XMymN4AiNBo2lxkUgANTjAw4J0xu5fBy8lZZzJjLxNk90n5iKMZz+NX9gtkx/UW5nrpB8IKOiOkFrTj2LenTfJ0aW051XvSkDpmIE/DGqamdD9iAuw3I1965RfF6z9WS+AoMKNs0D639sryu84SQUJj1If/915q2MstGnsPIUU+CaixvqDeHug==
X-YMail-OSG: k53x5rUVM1l1nmiHkw0PZdOjgvtPHtQegZUfc12DF.MKrSwsq4DI6S6gpm6fzHn
 R5ADIKngK355XmdsiSv2qHJNKkdvsfWVW.1ID2PD1kPHRDFyEXYm1pfdB9NMD4PD0kkeT2KKDCHi
 LMaohXwNmrg3Eae8bFOLmZ42IGEG21PBdj14NgxSQy9WAzJRMDv8VixAYKTPh8RXf.Pj.riFXYdf
 5KuJ6hblKrO_3A5SlQWjLzwXfZ4dv.ubYg4QA0vbfvpISuCQP0wazyGQY0Hza.CJakQWRYz7y.D7
 L1bA78yTvUMw9JbLegZRJMGZ.tCqSl0KBIDfp8XuluxMAkT01uS3eb8ZHQqe9GXPXeKqRn4H0g7r
 3vIh4bkg7woE0ySDKqEuG9df6NEseLC2Jdxomp6myektCiwsGdwkBOlnywem9KliVI8ADjQo3IgU
 qCdFJvk7.YaeoeysBgz0P0NUUpSVsstAwoVWOy8XlIoqlgNPw63z1Rq_3b7w9nLQL_pLvYC32Kfk
 UQNmSxWmg4n9jDMqrG.XsfgeN1siC6Fk6NdKNnzi5IwDjz4WcNNm52pyTC5Y7aNxTHnot0sIITp9
 7cn2xWrkvNRFUU1WjATXpWNPA6_0TwHvdJPoOfRFvcWe4NH00u3l62b3e8rT20.8HbSG0oObYjwW
 lTb08dTkg8kOtK.q_UV_8iZlDTifOvx6wGv6MY7UuClhqFCsRgEC95R5VpfrH2fd.9N0UiF6sX4K
 qpqu8ziKmOHEZ1iaJ2YuCkeX9D2v9_gHE8dBG6ZRq7FynB_Ts6jKxPMMVF70f.Erq.e06jhy0ZrI
 6SgcNLEZxwgW2vkR4tl6p.q4kIKZAqQg9pcA6Y.bLHoLDXOzd4atyNLmxkLDG7N33ziLv8Jydxq.
 N2b_tIxSMZMbXdCUBqE.fhyeDJPhEEaQpDaFiEOo9kQiNv3FwA_a75KbvsFrvPusyJwcB0NxfMLs
 6LBAEjehHKLYpwBt0y0PszzcXmUx91tYa1_9MsFtUuu4StwaJkzVTilxGixQ4uuOsxGAYScDA_.K
 s4OxcvTKyjEn2L2ZtfD_ZjlTn_8_0aGRBzo2R9gEEt8BZEBdl9S4iVG5Hb3JJA6sC1BnDVVEtWPF
 Fvd0CguToiIQJw7.Xci2gso9G3KcEDgdidtJGc.ytUXs2MhiuAwYs.nXQaL6Dc4YAE5wLwbUqYZu
 JWeXJPn87VipAk.Nc2qi6y9WotUbVx16B0GQWAiJjg1wZHeFPFKugxgAHi_kf.olrLfY5mxLR93g
 IBJsTAqtEu5nrBKNpWNIuhDKBxynzDhT1RDfDxcupxLJJkIhtaqYacib4.SW_LoaPFI29DqzSUZB
 eMyFws8gYLueIzJ87kHWr7jtXEM6bi_B7YYiCo9Y1OTviJXWfn6.do9a2E4z1en9FWd1QTXAq16U
 g.rxA961PtdB7RWf.6aMAJYmzAzW6CCbNzuBfcM14nzyoNydln3eTyYlGN90_DetTC1_k7dzGmhI
 gTz0Ut8koX9Zv0XO3t16eUtw3paQ_cKYMGH99_YhA4dMnMgmLuWxTdh7d1gFub7fH9dC6bvVEPeP
 a1ddJB4xDUInFFN5jS28.NCQ3tKYABoUpBOqwbWsudQSbfaxaaaDIQ13eE_gRjx11LOD39pgMZPV
 KlwVKpXP8OuvvcESMrxgjhzGJclcab6nyOSCrvTh8IQKsaQEEHTMFO19orxJaah35cmvB3PAWSY.
 27UurYIQDKTahUucuzI_QGfuUYNp32chBMn4tiDECXwMbwfXDV9z.VRAH3AoHqxy5ImvgtYUSxm1
 MP1nGflAFyb4lsqWgH.noHB6DvqXvstMiD1rXHHvq5k4RD2EQ1mzbqO43qdL7rS0PsgihsDhiXBv
 0qK.6aEcpzO4RP7r.Acq3UfixQyGRmAUaMF4BevdUKSiC3ZxVHVEVZvXgf.0mWfkBwWMfNYZ2.hG
 bEgvioJgZraZFSxzfhcVHgeK4VroDHdmfuuV7aALFkJLwhbEf9R3pdmNm0F2MHLlZV1JLJUnxrjj
 iduYWnzDR4reYjgxei56y9j_NhGTkUggUAbFHD7HzEWj06TbEO0D_chmdIVh1R6JYhuW8zu439hQ
 nMCUqYN_7QoOgVkZPEaJ2YAgsuCQpgWipRShdZRaP6nhBq_BZGkE3nz_M9kSNwOH6TyxMjk91tnX
 tBxFqiq9zKwPOfBpRXnoF6jHQvdalDD2EcMvzzRgdYSTsMwcm0NV459seoY1sKv.159qhK8ZLJpB
 .Yq22Q0.lMrmRCAtOwzaXHy3vpGtS6Gp69Ul_fyRKeMeMHL76yVXo7VwMeiQn4ZSmnQ1nI56dXJk
 gCj9z4YSEte8Ulz65p95Kwg6o0GFcwcDSUWiteOjC2K6gZDb4lTvszqtH
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.ne1.yahoo.com with HTTP; Thu, 10 Mar 2022 23:51:32 +0000
Received: by kubenode514.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 02d0d7342d647b4cf843030be84eedee;
          Thu, 10 Mar 2022 23:51:29 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        stephen.smalley.work@gmail.com, linux-kernel@vger.kernel.org,
        linux-integrity@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v33 11/29] LSM: Use lsmblob in security_current_getsecid
Date:   Thu, 10 Mar 2022 15:46:14 -0800
Message-Id: <20220310234632.16194-12-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220310234632.16194-1-casey@schaufler-ca.com>
References: <20220310234632.16194-1-casey@schaufler-ca.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
index 1814516509ec..5f20c0c68f67 100644
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
index 40d8cb824eae..17ac6e74b5bd 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -2154,19 +2154,12 @@ int audit_log_task_context(struct audit_buffer *ab)
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
@@ -2375,6 +2368,7 @@ int audit_set_loginuid(kuid_t loginuid)
 int audit_signal_info(int sig, struct task_struct *t)
 {
 	kuid_t uid = current_uid(), auid;
+	struct lsmblob blob;
 
 	if (auditd_test_task(t) &&
 	    (sig == SIGTERM || sig == SIGHUP ||
@@ -2385,7 +2379,9 @@ int audit_signal_info(int sig, struct task_struct *t)
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
index 598e0de45b04..2570bf5979e0 100644
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
@@ -2712,12 +2703,15 @@ int __audit_sockaddr(int len, void *a)
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
 
@@ -2733,6 +2727,7 @@ int audit_signal_info_syscall(struct task_struct *t)
 	struct audit_aux_data_pids *axp;
 	struct audit_context *ctx = audit_context();
 	kuid_t t_uid = task_uid(t);
+	struct lsmblob blob;
 
 	if (!audit_signals || audit_dummy_context())
 		return 0;
@@ -2744,7 +2739,9 @@ int audit_signal_info_syscall(struct task_struct *t)
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
@@ -2765,7 +2762,9 @@ int audit_signal_info_syscall(struct task_struct *t)
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
index 8c6e4514d494..6abbaa97bbeb 100644
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
@@ -486,10 +487,12 @@ int ima_bprm_check(struct linux_binprm *bprm)
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
 
@@ -510,10 +513,11 @@ int ima_bprm_check(struct linux_binprm *bprm)
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
-	security_current_getsecid_subj(&secid);
-	return process_measurement(file, current_cred(), secid, NULL,
+	security_current_getsecid_subj(&blob);
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
-	security_current_getsecid_subj(&secid);
-	return process_measurement(file, current_cred(), secid, buf, size,
-				   MAY_READ, func);
+	security_current_getsecid_subj(&blob);
+	/* scaffolding - until process_measurement changes */
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
index 815200684bcf..e33fa677181d 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1909,17 +1909,30 @@ int security_task_getsid(struct task_struct *p)
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
2.31.1

