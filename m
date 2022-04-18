Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1F86505B4C
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 17:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345163AbiDRPkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 11:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345237AbiDRPkl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 11:40:41 -0400
Received: from sonic317-38.consmr.mail.ne1.yahoo.com (sonic317-38.consmr.mail.ne1.yahoo.com [66.163.184.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD441B6C
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 08:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1650294291; bh=Dh2hcBFef4zC8mct1EoGkvlyiCusynlUt+FK0YzVoww=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=T+DAH57Lnjq0aLc5+M3w5azbKqgoKXLmBXHEYQR0UjYIhaafQRxUN/6uZFQ4HYRUTL63ur3l4ClCw/GBy0X7zJRzfmXP1R2Ef1RAM+SM4FT1vnve4VXK5GCAfPOyOV3UVJNzZ/wID9EErp7IIBjDbleIYQa6hz2CBtPVUY8fm0XbM7+M6etzMDrCX/lJn8T3xVDuGIdJHtSEbI/pF+yDk6T4AvXQglS1VE134rCgxB9faNFFRCOb4x/qBZF1V1NWMVJPHNpcxdGia7qp7FCUkEIbObiRZchQiqML6VbfDuFYRuGnBKQVpti4y0zKA/m9rzJ56M35oHlJyaQpfNUblg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1650294291; bh=u2xUolzfugATPY2AVCc9fSUA04euOGWv2y/ahxsYQu4=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=daiIK5KwsYxU4V2FaWdGV1AUCKFY7Oo3sWSV1ONJIbE1Mat6U8kEuVhIZpAJ0ayiJ/JesEWAtItusRxjvsVTi24YHWBdW0vNj+syDR9EdOPw+9qAh4egR8hodywbQ1FfjlBP4Kdro33lHGlsaBjqzi2RreiTuahdHnWKFXW/njInm68ZywIjTyGm+huT9auJv05nUYD3khA7FB+Fka7/eY0Kw6kN4BKnjNPCmT4Lo0knJwitovR9yx2Am+nG8lhsKwyfFBl7byHqPVcaGOiIiMPLggD5l/+t6NzfC+LZGRqRFBuwHPKRd6gMm43kPq6wfIVIqhnNg3watGcpMo+8XA==
X-YMail-OSG: ODHBYVoVM1loiSdTPmwtl9ORPFeBFKi7weRjQ8DDqidklUfDnBQJ_kxXnzH2wao
 x6q4DXJx2sshgW1rQ80mTwfpbJP9Tf_E56.D1eUkqpikgv8Oa_5CxS1iYpo0v25cuWR9NAj4lmIR
 9x1a3QEYBpnt2NYEh4Y2FvO0tQdxJOY.ub3bBXI_0ytnjwzRs8DbF46.rJk4SEL8w_Vd6zmdvIzV
 hXKlceQ27p6cjBnflm.j.BJy7v8Q1By2SC2kpTLGyoav_DH4pAsaY2ZQRpDK.Y4EoVnHuOrWScUp
 3KLQBJx.e.1T4ln8bh0dViXLaxPsYU91.LlpGndUSzZhTvkyYmBqatMjeQVeYyV0fH1_580TEODN
 JhoWExUTdVuqI_Ide08pENYF3710O5IScEQje7uaAYoWDYEKDEpPpxa1sFdEu.oec2JuQflu6N3y
 yhMGCE3fvZzhOYmy5iw0au8gnyyXEVOQSLeIlz1Qt7_cRiL_dNMigk0FgNNw8WYGiyXccr7wFUmA
 2D99M0aCjWrU1au29vbicvwfbVXgzWpBPZFBLL3uABQ9Wb2W5C8swx8smr2efLqimKcVHF_DR6IF
 6obB_84.1.to7IyX2N81.D1zrZEFkBvIxUu.HbSRQevi6dJI0o9N2Hx9YFTaVU6i3odTnDXw8P8x
 NbYcWSNkJ2fSHl443glD28Zgwnj3ZNFqm8Wfs63Al.OFYD9sNeYZoSpFYzuDmJF46qfDs9nvUND.
 KrF.dbBNPz1Q158mbL4IVvDKTbKiwWjZ.MoLyGXluGCPKyv0InfeROc.f4tOKTH4GviYuzxI3FAf
 dl4v4xcnd6feWv3jbrp_M7CquUDXcjV84vGvvMwegIUGl2M8CBE3RXdCRy4f73W5TP4YkWzUPujG
 E0ZKdUSJWchiAfKOIyututVA.pyY0rJnTaKLRfEILaQfBgIUH.hda.xUotoXdOi11pROQ7sLiZ7V
 QDwUT6y_ROcV75O6GQKwhJgcu2760Lp1xgSxjnrgB2PNUm3mCxCagSW6BEPtDgM30wZVtKQvKh.G
 CmfDDWD3xOjc4i3tXAnKobw5qLwjEQ6WMeMfLzGcUpOo0QOeKVenq3xgz.W6BhQFl15nNDK3udx0
 4KZYBdpXq65Zuc2dFFkSJ45Gxhao0Ac5jpBEMHsNGWhZxWKihBefHwvXdLdz3HnSetiN_tyZDCUr
 juaRxXXPS7onKxQ8sJYQjYiFJ8W0_ECOTRdBC5MQUGF1jZl.0DYaFGuhQjwdwkZAqSz5QFkevjcf
 SvEDz.3cf_hBVO8WWGtRTWgodv1jubpWLkbVpyYgRiPHLlToQL5rUPS4xNKXR0OsF52Y2XAC3LFl
 hLcE1zQsjZjK9qetTM.mb7WWmEZnzTRIFQF7_VZWbpdKY11EVOyoQrU91zHzfDebXGetyTd3kL8f
 V6KDaCoH.fwYZ42JtvOgpLiLgOEyh3KuRLy4VCT93npxvR.upJagJ9dWxshpSfQJO28t1XFHsOo_
 epcwxrcQGExxHnZBe1rWYF51xm.o8yLN3AxNsFJK3B_mVL6EgTx_yZRR_CYUksNE5.Af3lQfiwbX
 mbl6dO4QqzCYJUmrNGKYZLT9KYBB5T.71fekUqfP6IUD_5F9vO4cmrTAdmUdQAqS7pxkCKcjRdNw
 KmM7Y.FRp7dnjIpwRBGi80R_zPRSLugU62QhpxvkeUTGc66dhn.ODZ6QG6dnPpUmvnXSE_dZ28IT
 _J5gmMPrVbF5vfG6r5pjqfyqz0HuiqeJdkVa5Vaa7aCUJwomZG2KJflfyEVv49UIxstDu32sKUBc
 Bofgqp_WepG7HAPFNsl3dHcgGdaKEDq4z.ZYexUHwqSINrhiuOevz3DneGngmf9jvD4438y2Ml37
 XyQMRHL4TzT25bnqG4axec3wYZbuBMoe3YbUcD9YW1Qtl1E47LDd5Gr3yg3airvJSkKenbpd6DSk
 _oPz_aNR2D2hPNPaUsh1NCSZnpo.x49gAK.1LD1PoBWgZGt05WXGtq4b3Q5B7Oq8Skd3PKFLKDyE
 D8jChoxslH2VDZpMqEW00AZSwVF9b2YatPKPMc5SaZhpBqROCz_MmdQy3N8j020NVFevJITLLFcy
 Qq9ysqFpODP5NgDa5G_ga5BPOpqEuS4FkCHohSvv60u4del0rTyWFbKud8xKjKxAxv_gueSfr3On
 2vAW_sAB1ablZmDVzWSalz2hkEZbvU_fG6ya7Cg2sboSAXODrplX3rKnT1HiraHTRjFIizuTpWI1
 NSFbcL1qnB9P7FtZbioYrDDZpA27h_Br.VUjTV7yKV_TRcbTdnlggu9PmJwJQtihH.0Qe7j8y_iF
 XgRuRo76wzlgthUyfDky3Lid_4L74o3dftnpc48EzUwCVTUELX7ukMWJstlcWEboILOfRgr0rB3k
 utFDidHPQaqc-
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic317.consmr.mail.ne1.yahoo.com with HTTP; Mon, 18 Apr 2022 15:04:51 +0000
Received: by hermes--canary-production-gq1-665697845d-ftzwk (VZM Hermes SMTP Server) with ESMTPA ID e42a5033a868ecfd55a4e02ebf801990;
          Mon, 18 Apr 2022 15:04:46 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        stephen.smalley.work@gmail.com, linux-kernel@vger.kernel.org,
        linux-integrity@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v35 11/29] LSM: Use lsmblob in security_current_getsecid
Date:   Mon, 18 Apr 2022 07:59:27 -0700
Message-Id: <20220418145945.38797-12-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220418145945.38797-1-casey@schaufler-ca.com>
References: <20220418145945.38797-1-casey@schaufler-ca.com>
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
 include/linux/security.h              | 31 ++++++++++---
 kernel/audit.c                        | 16 +++----
 kernel/auditfilter.c                  |  4 +-
 kernel/auditsc.c                      | 25 +++++------
 net/netlabel/netlabel_unlabeled.c     |  4 +-
 net/netlabel/netlabel_user.h          |  6 ++-
 security/integrity/ima/ima_appraise.c | 11 ++---
 security/integrity/ima/ima_main.c     | 63 ++++++++++++++++-----------
 security/security.c                   | 25 ++++++++---
 10 files changed, 117 insertions(+), 74 deletions(-)

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
index 4cfeb5eb29fc..d11dfa33c1c7 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -220,6 +220,24 @@ static inline u32 lsmblob_value(const struct lsmblob *blob)
 	return 0;
 }
 
+/**
+ * lsmblob_first - secid value for the first LSM slot
+ * @blob: Pointer to the data
+ *
+ * Return the secid value from the first LSM slot.
+ * There may not be any LSM slots.
+ *
+ * Return the value in secid[0] if there are any slots, 0 otherwise.
+ */
+static inline u32 lsmblob_first(const struct lsmblob *blob)
+{
+#if LSMBLOB_ENTRIES > 0
+	return blob->secid[0];
+#else
+	return 0;
+#endif
+}
+
 /* These functions are in security/commoncap.c */
 extern int cap_capable(const struct cred *cred, struct user_namespace *ns,
 		       int cap, unsigned int opts);
@@ -502,8 +520,8 @@ int security_task_fix_setgid(struct cred *new, const struct cred *old,
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
@@ -1199,14 +1217,15 @@ static inline int security_task_getsid(struct task_struct *p)
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
index 2acf95cf9895..2834e55844db 100644
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
+		audit_sig_sid = lsmblob_first(&blob);
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
index d125dba69a76..b7bfc934436d 100644
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
+	context->target_sid = lsmblob_first(&blob);
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
+		ctx->target_sid = lsmblob_first(&blob);
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
+	axp->target_sid[axp->pid_count] = lsmblob_first(&blob);
 	memcpy(axp->target_comm[axp->pid_count], t->comm, TASK_COMM_LEN);
 	axp->pid_count++;
 
diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index 0a99663e6edb..bbb3b6a4f0d7 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -1562,11 +1562,13 @@ int __init netlbl_unlabel_defconf(void)
 	int ret_val;
 	struct netlbl_dom_map *entry;
 	struct netlbl_audit audit_info;
+	struct lsmblob blob;
 
 	/* Only the kernel is allowed to call this function and the only time
 	 * it is called is at bootup before the audit subsystem is reporting
 	 * messages so don't worry to much about these values. */
-	security_current_getsecid_subj(&audit_info.secid);
+	security_current_getsecid_subj(&blob);
+	audit_info.secid = lsmblob_first(&blob);
 	audit_info.loginuid = GLOBAL_ROOT_UID;
 	audit_info.sessionid = 0;
 
diff --git a/net/netlabel/netlabel_user.h b/net/netlabel/netlabel_user.h
index d6c5b31eb4eb..34bb6572f33b 100644
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
+	audit_info->secid = lsmblob_first(&blob);
 	audit_info->loginuid = audit_get_loginuid(current);
 	audit_info->sessionid = audit_get_sessionid(current);
 }
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 17232bbfb9f9..f9eadbf53cb6 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -71,15 +71,16 @@ bool is_ima_appraise_enabled(void)
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
+	return ima_match_policy(mnt_userns, inode, current_cred(),
+				lsmblob_first(&blob), func, mask,
+				IMA_APPRAISE | IMA_HASH, NULL, NULL, NULL,
+				NULL);
 }
 
 static int ima_fix_xattr(struct dentry *dentry,
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 3d3f8c5c502b..3d8d9162a5e3 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -405,12 +405,14 @@ static int process_measurement(struct file *file, const struct cred *cred,
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
+		return process_measurement(file, current_cred(),
+					   lsmblob_first(&blob), NULL, 0,
+					   MAY_EXEC, MMAP_CHECK);
 	}
 
 	return 0;
@@ -437,9 +439,9 @@ int ima_file_mprotect(struct vm_area_struct *vma, unsigned long prot)
 	char *pathbuf = NULL;
 	const char *pathname = NULL;
 	struct inode *inode;
+	struct lsmblob blob;
 	int result = 0;
 	int action;
-	u32 secid;
 	int pcr;
 
 	/* Is mprotect making an mmap'ed file executable? */
@@ -447,11 +449,12 @@ int ima_file_mprotect(struct vm_area_struct *vma, unsigned long prot)
 	    !(prot & PROT_EXEC) || (vma->vm_flags & VM_EXEC))
 		return 0;
 
-	security_current_getsecid_subj(&secid);
+	security_current_getsecid_subj(&blob);
 	inode = file_inode(vma->vm_file);
 	action = ima_get_action(file_mnt_user_ns(vma->vm_file), inode,
-				current_cred(), secid, MAY_EXEC, MMAP_CHECK,
-				&pcr, &template, NULL, NULL);
+				current_cred(), lsmblob_first(&blob),
+				MAY_EXEC, MMAP_CHECK, &pcr, &template, NULL,
+				NULL);
 
 	/* Is the mmap'ed file in policy? */
 	if (!(action & (IMA_MEASURE | IMA_APPRAISE_SUBMASK)))
@@ -487,10 +490,13 @@ int ima_bprm_check(struct linux_binprm *bprm)
 {
 	int ret;
 	u32 secid;
+	struct lsmblob blob;
 
-	security_current_getsecid_subj(&secid);
-	ret = process_measurement(bprm->file, current_cred(), secid, NULL, 0,
-				  MAY_EXEC, BPRM_CHECK);
+	security_current_getsecid_subj(&blob);
+	/* scaffolding until process_measurement changes */
+	ret = process_measurement(bprm->file, current_cred(),
+				  lsmblob_first(&blob), NULL, 0, MAY_EXEC,
+				  BPRM_CHECK);
 	if (ret)
 		return ret;
 
@@ -511,10 +517,12 @@ int ima_bprm_check(struct linux_binprm *bprm)
  */
 int ima_file_check(struct file *file, int mask)
 {
-	u32 secid;
+	struct lsmblob blob;
 
-	security_current_getsecid_subj(&secid);
-	return process_measurement(file, current_cred(), secid, NULL, 0,
+	security_current_getsecid_subj(&blob);
+	/* scaffolding until process_measurement changes */
+	return process_measurement(file, current_cred(), lsmblob_first(&blob),
+				   NULL, 0,
 				   mask & (MAY_READ | MAY_WRITE | MAY_EXEC |
 					   MAY_APPEND), FILE_CHECK);
 }
@@ -710,7 +718,7 @@ int ima_read_file(struct file *file, enum kernel_read_file_id read_id,
 		  bool contents)
 {
 	enum ima_hooks func;
-	u32 secid;
+	struct lsmblob blob;
 
 	/*
 	 * Do devices using pre-allocated memory run the risk of the
@@ -730,9 +738,10 @@ int ima_read_file(struct file *file, enum kernel_read_file_id read_id,
 
 	/* Read entire file for all partial reads. */
 	func = read_idmap[read_id] ?: FILE_CHECK;
-	security_current_getsecid_subj(&secid);
-	return process_measurement(file, current_cred(), secid, NULL,
-				   0, MAY_READ, func);
+	security_current_getsecid_subj(&blob);
+	/* scaffolding - until process_measurement changes */
+	return process_measurement(file, current_cred(), lsmblob_first(&blob),
+				   NULL, 0, MAY_READ, func);
 }
 
 const int read_idmap[READING_MAX_ID] = {
@@ -760,7 +769,7 @@ int ima_post_read_file(struct file *file, void *buf, loff_t size,
 		       enum kernel_read_file_id read_id)
 {
 	enum ima_hooks func;
-	u32 secid;
+	struct lsmblob blob;
 
 	/* permit signed certs */
 	if (!file && read_id == READING_X509_CERTIFICATE)
@@ -773,9 +782,10 @@ int ima_post_read_file(struct file *file, void *buf, loff_t size,
 	}
 
 	func = read_idmap[read_id] ?: FILE_CHECK;
-	security_current_getsecid_subj(&secid);
-	return process_measurement(file, current_cred(), secid, buf, size,
-				   MAY_READ, func);
+	security_current_getsecid_subj(&blob);
+	/* scaffolding - until process_measurement changes */
+	return process_measurement(file, current_cred(), lsmblob_first(&blob),
+				   buf, size, MAY_READ, func);
 }
 
 /**
@@ -900,7 +910,7 @@ int process_buffer_measurement(struct user_namespace *mnt_userns,
 	int digest_hash_len = hash_digest_size[ima_hash_algo];
 	int violation = 0;
 	int action = 0;
-	u32 secid;
+	struct lsmblob blob;
 
 	if (digest && digest_len < digest_hash_len)
 		return -EINVAL;
@@ -923,10 +933,11 @@ int process_buffer_measurement(struct user_namespace *mnt_userns,
 	 * buffer measurements.
 	 */
 	if (func) {
-		security_current_getsecid_subj(&secid);
+		security_current_getsecid_subj(&blob);
+		/* scaffolding */
 		action = ima_get_action(mnt_userns, inode, current_cred(),
-					secid, 0, func, &pcr, &template,
-					func_data, NULL);
+					lsmblob_first(&blob), 0, func, &pcr,
+					&template, func_data, NULL);
 		if (!(action & IMA_MEASURE) && !digest)
 			return -ENOENT;
 	}
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

