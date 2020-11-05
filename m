Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B87D2A742F
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 01:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387994AbgKEA6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 19:58:55 -0500
Received: from sonic301-36.consmr.mail.ne1.yahoo.com ([66.163.184.205]:33864
        "EHLO sonic301-36.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387957AbgKEA6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 19:58:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1604537932; bh=eZeO09DJlcX2wY8AdT21fgnfDkYz/4ihUnMP/xr6IW4=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject; b=ZxI4ZwVjQY4n1pGC1v99I7NObkXT6Voi9ZlqfGnpgWQrj9raNndSjbhvx89OAO2g852gdtb1pcQ2nrQe1Y9ZW0OZGII+qUPudujm8n2hQ4ycTosQNiSQ3T1RjKIozzfPY5QaXc3WFtdZG3ayJQiSi5n7fRCX2n1iI/H9UomKNrmpaI2BjNxbSwh3ADeUyCk04zwg1iJ4GDFwSdTviiAU7/tvOqyS/1gs6jfg5zpnom51m7V9H/ia2Uj4u5VGV2KZsIenggXEvQaNv2OzEKZ9jMJNO4JdJ8TtKWSStaV3vTpx1OxLq4YraPLGgmGCSs3iXNs0j/eq8qH3IMsWj7D0EQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1604537932; bh=U92zcroqCccal2Vy2U5Og48M2/YnohAQu2wwg724827=; h=From:To:Subject:Date; b=ZPkpeXPII78NfFIDGO5xIl92NbpJtORCZU7cXo+hH7UjwMlIcoYKbQNcijSt+WNQVg/4cQN14onpygg9NUWTsCeo8WJozETWXRVqx69qGQZMvMiH2CE7PQvglKC9uksylBjknqykM9MgbxLjHv0aSpdljiFXv40UGT7uasht7y0Qwl9y3TjpCZtF6lEE9NRB3XQ38o3rE7lm7GGbGoxs5Dpb4pitq2WR3Dc7mF5ig6y0VDOQm/rWp+Cm2qGXEavoQMv4rFAd2T87h2uV5KEoXdaZU2LyIXNWTLOXkxVV4F+0g2z/er989CZ6QQcMJkBT1/c9WcTlP4/V8Dq00v1sZA==
X-YMail-OSG: 9urMCVQVM1kLeM.GHp429ckZ0OIGDuO6NjibPIrFWcZsHMxFDTFhYhV1JvGS5iC
 jBy8qaf18_ZLgbCnDHsfoV2Ej6irCRmwclX4fnOyXaWFvnHsJJOHJcgVNs85sDfRBy2xhJLRipZb
 1fa8SqJCYoLYzGcer2G8MFRZy_qGYBEUnazmyNJmUWclaSzgPyorkRJCUxNgLEhO0qneu8qV5WAr
 NsU5tFq.kVqK6wnlhBX6fq79PDsZD86RC.eVSK12wnr.2BsmvKTAD9ju3PA20Q1mK4RTIdkOy6aD
 B_vylP0EP3duB.zvP7ahD_WvfMAXe33e1yyyeBxF1usk8d9l3A2LqUWU45ttfHAB6XC.CadGpFzl
 aZ7M4xjH5ZjKCuQmOPMtm_VrAjIVU_dYB2yfL6LpcEROgI9Hw7REduCeN9Ufn.PidCD451eDTH3D
 x.QMgD31nVCRrGM.18dHiuexh2Qa5ZffZ7G573rtI0LcAnsHngaXBA.NvgFyQEKey1tgWwjbANpD
 VdOB3qnaltee7ySGuyr4Gf6L1OoG4L10E0wj1PZymuCyiAQfQwTEobVylwZQgXE3e5M5kcIpWM3.
 CHwKC0oggCyVVLSvBe8fLYKNB3CyDmewNf.aw9opjN6RsENdJCzZZjZt60kW9MK.TxF_42JtQo4.
 kVeDjJ57.E4m_bU20YRWTIMl2brhn.SZYV8_bJBYucupIlG2rJc802bG_m2_kKQGmTcxEw311FzK
 ZcKr2bt9omSmSFS0fgizqieOz75gA2oykkQsOGniIUL.YCJL2Nzs4J7npo4VWHbyY18u1VYJjqo8
 lOSHkV65FjtTBHODVZyd9B.nd0Av70FTP8BIK.DOstCDge6aUHMI5eB85rVQ9Zlwrb0H8S59us5g
 CxLWrZIk1vKAj9PHchq.pZ7cJH7GE5p.EIx2Dm4W.fXiWuxoNcFDceu76wOaIRdOUVDpeEiHEQQ.
 dnbeUWOdI_e2C3Nyw5.JEd7OD56twEWxIAYn3dnBzOVasWzqa3EP1lMeM85LPM0Iv4tFPMnImn9y
 mprr5wnblMuwbuhrYkr4PnaHJUQvD9NMhZOHjeEXshyUxqg5vQ46MoqdMgymRYlGMQlcFEhWJG3T
 kFpZy5huVYJEuzrX4G9XNaXG78KdjLqEEfM3aAGSNoNOjlL1tVAN9mjZU.MJWXOGM8KBuH1B3z7M
 vNd_80A_vIOUZ0yB9U.ptFkszMRuV.luhfIsbIyizoTgY9bniThtIHzFFhkE3BTRaFSCXNi00DJu
 0TYgHjgdVg5EwXgtZbs2UiKAZpw46apTjEJDTzRNYB7dIMJ834WCk2QpRMN3kyotzJSSvi2J3plZ
 BzFycmM.ox7xZY9widT1cL0Nug9IJbqysU6Cgl77DWAcuJ6U5ZhHQC1Oni3INE8PDzxzON5Ofed6
 RTrX._R_Sgq03Ghib4CySmO54t9BP449lPCUjNzIntuZaJOppsjgBkm4YzYM0M_gJ02lyEqkPLfu
 kttwBpyCHFqvme0z4.t28dgG5MScgQj.C.GItcLhoQ.BPLosXdCe9Npn5DaDYRcaHdTDn66ng27c
 szSsjdzQvCKQjrtNTIp5v62S1ixHr0KlPEjN1gnC8Sfq1.TjfXp8CMnflOQT0BUrBxPy4okLGN1n
 KAItNq3w5zeD0rSy8bDWKwUEMye3ggIthkRncfUXxUa0qwD4zhZrz1foBsXbKVtN0I7Z6xi1.Um0
 Y_tDlt3PerIhdiBMFpWVxavGHH.f5XKl_pkapf_tlBrtYtJrvubd2SVmtxfbOkgm2moasYecboR.
 tIldQXYje8C3Jxjco9UZEv2270gBtJ1GwaGa4_WYVO.AMjJFyxIR.N92xmrT7b8T8xZS0QxEw0Ek
 PXdKBwOUHaXuRWrqQqM99tP2cLKa2LYnPxcpOdJiSAfeoZyxySoIzrTtxos4K8dfH.mQhKxZZTuy
 lnyWjeT1yf4RyB9Vg.w_POz7oZJd5pPydAAbyWPTkLiWP6rsF.1K.GF5UbfTpf74KGFW3sysOmrm
 q6JAe_ePOViYuuOzlEt0PKkGFTCi5xYEGnRMufg0jnvvVGUa.ZM8YAqlWcpv1oBwCKTuC9ytCNml
 O.NGSr1mLWZsFInujSW8Me74rMyGQe_VcVc5nXddaAPLQgxvsb5WmdXYcyirBROJyOoodueVBmeX
 PjV5zrCBLdYBj1UPENUO7m5yagHApvYmRLXEUviH_2vKwOe0JZ1u7A0eg3tczyzz5O7z361LLQEz
 T9mAlxKs4jnEb1bwkoji.Hy2PdulxLqgvYagUR9dXZVihXxJhUdpKrnxv4pF.SBKsni6dhF_1CXi
 NJyy_x2PBIQo_BADPg67G4._gJNmHmqrzwWd9CaRX1OUyGVYnn__v2p0gpLCeR5GUroCT9qGBX_g
 tNsCQq0eSENmWQB6hXqed9VLWYiG6xfwFPPfj0w5gKPISWbVBuaZsy5EWv69lZWL_MJBDP.7Kujd
 vZ8i39K13K9TcBVCkI4FMXacxHLG9B7aGhur2mlMqf1z_D4b4sFVfl7gkHZWFw80mHkMOp5irCKv
 nIgtSo73y_dyuyvwpXPbSfoE_QQYh.9nM0ooLjW16i4mZ70dftiCSH4ypkdEuYh4a5CCwdjnTnVB
 0ppUKFXOZG0dwbXuHc0XyFU2TFbe_RHsq3iT04ycSr0bu3yg7CPrncSegSYcuHvuxck3IRLZiPsv
 J73LVvvhgJ4mjhgHyUHJBArsSnCSR.NBd0lUR45H3Mm.fmGuj0THFyELJcrpC1aI_GWm.tf1DFbK
 Bjc_IFUIDprv15Jg9IkouacqW27e0RkC7rVLvPdnmx2qs1bjNCOTmMj9UPzt35DeeC27VCYaCbCF
 irUQbaDw_AdKSjauOiAd9ecdw629mE.h.zCWjQ4NKAGB7eIFOMNvkqm74iP95uKvZy33TiDdPOr9
 q_rVV1ilAHDvZdNX25ZFRQhWUQFF3imvcDK5SaHS_MIp9EwAPnoEqEHZvH9WF2ot9W0K31rm191A
 fZ0ROzeXXFRtJ5LdgABLbghpthG97n.f0.AF3eGEfdGWTWq2xGK3ea_nb0D_dvLOdgZs5xRMbQAM
 nHyyFdCdjFkvSI6kNZNFLI_ewx0VzF6SdvEmdh_CRXls9paqERwLke06V.x8RHwhNBaMRtKwYuOU
 SiYCGMRSwTU_2KWb0QTe9qX0cMHGgx35rKSvouvK1N1SG4vB8jUGgqLc226fXANT53yYJ3kEJGWz
 IxaAswdIb8KXU.ij.9OxEqKgZcrjBvnT4VixMOMhjrLVzpCsIZ_3lU34Od3yfeexoxVc4kXB7B8H
 CSrs0pgYrgyZGCxvvOPQno5bwe5lp86n8XzncLYy0W43sLUPLfPSB65NC5iktyEp83ZW6ea8pVOd
 F1PBK4yiyn8o2tk00xaBQE_OM.kUwH22jlzcr3YUVNe2Vei_LMNCBENBh9VcYWDLEU3KoHUUECva
 lED4G74DwaSbJJYlrqvE28cLG3PNDgq8V0iTH2i4jf14BjBLjUj8jZfq5KhTr.bjQvL8R3Vkg4tb
 t
Received: from sonic.gate.mail.ne1.yahoo.com by sonic301.consmr.mail.ne1.yahoo.com with HTTP; Thu, 5 Nov 2020 00:58:52 +0000
Received: by smtp407.mail.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 7f534deb0e26511a545991947c953a34;
          Thu, 05 Nov 2020 00:58:49 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        linux-integrity@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v22 08/23] LSM: Use lsmblob in security_task_getsecid
Date:   Wed,  4 Nov 2020 16:49:09 -0800
Message-Id: <20201105004924.11651-9-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201105004924.11651-1-casey@schaufler-ca.com>
References: <20201105004924.11651-1-casey@schaufler-ca.com>
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

