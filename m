Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 039E22A74B8
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 02:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388220AbgKEBMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 20:12:53 -0500
Received: from sonic313-16.consmr.mail.ne1.yahoo.com ([66.163.185.39]:42295
        "EHLO sonic313-16.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732114AbgKEBMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 20:12:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1604538766; bh=bVGH0BStUAAFmhVu8AKOg45afRJpVBV+saUzjNPSgwM=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject; b=YhgTw8fzqpEF4dHLFic3ED4zMWaR2DAC3AhzktVAoSWeMmOGL73lcTmNEg0QPoF8ZwAEl1bvpp8dd9RHLXPmqa3RBeFXQ4asUkblDSo8YIdFzS7wUPj22AvNrQWd4JyHrVa0eJ/zQdwl6rOKq9aBvMrIv/6Pj4VlErnT0IYbmxaNYGgdn4cSFYDEk4k/VPKC1C7LxODVxQ5nIPNJfC0pB+celS3j3LWUMbbhE6aBvU29He4xdmoAyUQnoIY+WCx73qOC4LVPU1PVWCIfX2uPBaHD+4YzZF/62xjPZKeja0iTPcZxfFfhp9Pr2zjuIt26eUIDgp4Yg2s2vINAcn2BCw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1604538766; bh=DIbbIcrj9pUgd3r1j9nsSnd9xBQfJczr1U2b3Gp6jC8=; h=From:To:Subject:Date; b=L8xvM+gXY7smqpW7mrmFZ6TTUzAiiMZr5S6xz/pNRc7KduFrxWPZB0JBnY+fsAhJVRBg5Br281PExmyBpYAwGAdoKFdjf/oa0hCANbnzoD5+CXyzqW4o11kblkYiWfSw3XjDhRMzl1PDjDVp8q9/RsPC7wZ9z4irYOG2NxVXNKJznqf3GJ2WPBNmtxE+hHW5fN81kRHoYjbzsJFej4HszHxiaUG7cSN0DTzd+oXoX/JYWie+cq9B/pGRJUf9JGCDKT6sxXHmPlaYtn6LMF5ZA7IKylwhMDU80zj3iw8hn2ys85rNBlApYYiOIXrpLkXRfuDlFnErcGqg0Dap9eL+HA==
X-YMail-OSG: q4Q6JiEVM1nwUg2l25LnQqt_cOyZFkay9_6ZMsJ.YICsD7ZbvmecZoYmr8hd6jr
 Jv1v8FY1GHoUYo_CRQ_p12zespBOoTOCIvTzjbvf0s7hFAoX0em_HunnQP2A2bISXfyhV17JTWd6
 34wa9AYbBxL7eSWgjY4TfeFQ.SVCVDyCDzPe_H5tG9GRqxs5c.ygKiDa6V6k34ogGzeoFzy7qY4M
 bz26GurK5LB_zE1_ThrntBm3rlati8GWAD0D.XxywK0chsJsedVqfFWC_MMIsXz9uHNNuKSrEBmY
 LGJHjeq9LBqiG4kxx1K43hXnuxeEIGoGM2GSwsEt1AOFMnBe6ANrz.xgWxxs4PIC3.qBMIP8Uufv
 h8r4ok8fV_BkOgjq0xuYhguJllfuLADFaqYmO6CBunvW3eIMfuR9aCb4e8uiHVlqoqrdlHt1Su4d
 vamLpBmf1y.JcWGg9uMOiO2ovBiWVz7A3rGpe_rbMUGURD..epyxzKE7jLcdOwDz3sn8l3B_qUKG
 DDrWrWO_Z1yJ8tuL7La16FTWkQJAAVuJzCmhuocFTwlkk4On1Q2ZWdM0AIoZyvr4ZD0hLDRb6K6k
 uqSOq78haq3hGJ0D5yvk3tBQnuDKa2r5m7lxCPfn4orzVvRUSfCpayGEco9gOL7lfxtgzHqShp1N
 V9CSLWpT_bIldacqAI4fsg.yddR9AlasmnMMi2zKJf765S0B5Zyvgxi75_SQUypnfv1.fHo9qfyc
 jatjyDryWL2Ekm1jpaHfNUXm8gvyleNtmjCb7q67AH8MxacMAYtKIed5BZKAF91U0jVA6P94KiNf
 FsnxckUSizwLlbgdC8G9Akecd_nh9aQI3fxFHHI5yTSy4IyE5CCt04VQR6ieSSEhOTnVHKY8.zwn
 Fiwrq58XCT70DqAyKLymPwapb.3CLrCVe7sTheQCedIvhuelsWwj.LiB.OZbmz4znBILlXjf4ZDM
 jfENVK0bVSYXrcElFQBIg1VVN2qZ3pMWx8wIpyXN0iBWenycSVAlG4P2AixsDjitJCJTs6DNMZaz
 eywZQfe82z3PzgLjvNzn_RMgUtymPZT196KVUv_us5h_M4Im6ILgqVco3sYzlebhEfC4VCxLvIDp
 7Tv.kAkbOcNpRZ6SzWv7cejnVM9Hzix2v8N7wnQ0gt1Jc7x04niI0pkXnsKt.bzvsZS2OUunIchK
 .HGFLLmlNUG9X0ChdNO6vIxqF.W5h_IsU5b5OY2mDeaQCkg.f6gnhz4nqWOjIuV4xo06ehJl7wXf
 TEc95Mb6Xy7oRKaHLGHSxnQhLyXgl.80srLUQmzuOwORGLgUEMzONEfmB7bxkTthqlgJ_AQcS3wZ
 uSY1hQxD1YezrsOoUorCgnNR.WOfoO_wQavLaSoUd1b7dAvv_YFwy9YFYlExEyy4B.noFi9KrOL4
 yD3wPzp7fmfwOKADBKiJ9raDUWO2rDvCdK0y0vqR7fUu_SwHBdlTztP8u.lLeXnSTsB6g.ka2mqu
 bfRgUAlu0hN1GsoBalAkMHaa.bjoH_.w0jADcXMG3PaKZMyV6XxAIAUxOePeUwXK19Bjj6ekqnKl
 0m9BlL5cvmuKBe4Sm5qwHEPj_42kIN8lgT2.iFEkKCurmpJjP7onY1wx248p9q5diVgW5gVmuFVM
 1e.p4xgcIvIouRT3_uik6lmaBc3eW0fLe_dQdgLowou4aL3eB3kvrrEVpuJI24c2IbMueZG8Btbw
 I4w0.5iGvRmWNRqB.Z2E7Fb9DkPD.pivfbLIjSPmVVGjEdDHenaoYnCW.JsGG2msSISHQSWPCXpL
 BVTqsc0B90DGz4b5P8wf.AOCVbd1yCUliUhBAGCcSC1sXEWDgW6DuO8PUnMocSUY7FlxJEUsZHpn
 bIUway57rpS089jqnnScGkCHCpw0tRP4.k6NhLFgWq01igcGk1VE4JEXPM_e9mDbr9n_mS3oljK3
 usAHcRi.4rMPhePG9zGNZPsr8rx04DtZJ8g7.9xnRS92onc6hzaSt3jkCVuXhaBp47j6ti5bORdD
 REYOxTSpxLqBoXr6iP9MaP7Fiky3hhqJ_Zo2PmUqvLa5A8399D0hCH02TyckrDx_EJmMO_ZLtC1W
 Y2ZU7sO97Eucgc0L.8DW6lA9TmP0aT94CXzSyIzzQX5QOv2KZ1.N9f7HqvcI8wAGk0EjS.xbTord
 a4cAlnjpjuRdyNAWtOJ0Q5S552SzQMPEkCpCqpbC4y_pG4LJkl45dqaAab3Wp2SgHKhwsvMYfC3S
 94ogPpkx95U5Jn5HzX62OCSAwHACQgExVlq7FXuyhUh6UZNrn7uX3lFNSseR_L4.sgETJ8IwyocJ
 Xm0Gt..uX0acVCiKcemi1AGPC05l_33yIGsOhaLK5K3oasEM8z2Tpa0jXxJC9ye6HUim41chlJvp
 d99aOs42RyocNe4Odp8B523buGKoqkKfi.3l71_GyNL3EhapIEbh5G8HI8u.d.oc5Mnq6S3F3PKO
 MEVl6u.bOaAIyerp7Fr.0pKrFOkEdN_vAQKZ0qfD1Z96ORv2NN3VBPbtUT2U9tA_j6P5OcNAIWP2
 ZoMycY1ANXm_ukdHDN1vrX6yyYDDK0g7OBDtvAiQcWizX9k7tSzx6aUuQcnkl2kBZO87VPUOXWm1
 Pp8p6dch90olBm2isx6JaTjElVaFoNoYwlA5SV1sH3XkypNyrZcb.fnP69Q60FD9o5_qXGuObfq5
 08atMUMKyW4FtqLoVz3ul0uarDJ6Q4UBCfyBecNNCW1eVfZhCNlCdPnzRjN2V0l.jy3hTz7uTXPC
 CUnxxNs_VemME0aeBp5ob8gN5LZpPgScSSzN7VoKh1clUFcbko.ONsEyyDwtQwYpGiFkMR0JIEdS
 gXwLbob5w..PGhzAQ0oAkfrVxQb3P1psZXxF54Unb0oJhScUZdrwzRVcIOVclsxFH1mMcfJlr0cC
 2jxGlL1yn7RY6BlbhvU8FjBJxNcQzS65Zvo.T1VS_xaDv2z1NJmvyi00Yg1Q0YKMrtF.4oNQT8JO
 Ocl3plzWAQB22VOy0mLNq4IoU5Ev6luK0IaZyrMamu63mkCHhcQKT4oU1JlHkMr6cKrYhm_uhf5Q
 AQ_Gk5KJnF5smnBCirrfblF56_kRZhNxNULJcgXxFFvbTXRKEn8YvKRj95OHQXI.fbOMNTt1XRVm
 3KvjPatl1qUcty9lkQFOCDsqIwpb8KG723fV2ZCMenEDEdZ2nfaLBnWnSVx9jPV5NxzFdk8NRFXy
 0_DsKDLXYdAaOLLvbpys12vOx0Dxur5cKScOsirIJ7KYDCyrmMjw6fpdHUCi8XFgkNq7rXHjgvqf
 o.E4ePdN8KJJKiM.WhwQYi7.HFkKOBpOeK8peirb6udIr4oywU5Rk0KA5ZAzryM0yjiYdo2lxgHh
 u74xbIZo.nFYGE.rjQk96Jc8Oh91ZNyvT4Hb2f7klyuwtpXbsr37TtfBCmcBUs.YBPLMaaiikaM.
 6PnOCRnMmTBx1ih1f2pn3yY_aDId40p.xnK3oEpaY_jkq
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.ne1.yahoo.com with HTTP; Thu, 5 Nov 2020 01:12:46 +0000
Received: by smtp425.mail.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 0681413164917f5811eb5c547cbd5fa4;
          Thu, 05 Nov 2020 01:12:42 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org, rgb@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH v22 20/23] Audit: Add new record for multiple process LSM  attributes
Date:   Wed,  4 Nov 2020 16:49:21 -0800
Message-Id: <20201105004924.11651-21-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201105004924.11651-1-casey@schaufler-ca.com>
References: <20201105004924.11651-1-casey@schaufler-ca.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a new audit record type to contain the subject information
when there are multiple security modules that require such data.
This record is linked with the same timestamp and serial number
using the audit_alloc_local() mechanism.
The record is produced only in cases where there is more than one
security module with a process "context".
In cases where this record is produced the subj= fields of
other records in the audit event will be set to "subj=?".

An example of the MAC_TASK_CONTEXTS (1420) record is:

        type=UNKNOWN[1420]
        msg=audit(1600880931.832:113)
        subj_apparmor==unconfined
        subj_smack=_

There will be a subj_$LSM= entry for each security module
LSM that supports the secid_to_secctx and secctx_to_secid
hooks. The BPF security module implements secid/secctx
translation hooks, so it has to be considered to provide a
secctx even though it may not actually do so.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-audit@redhat.com
Cc: paul@paul-moore.com
Cc: rgb@redhat.com
Cc: netdev@vger.kernel.org
---
 drivers/android/binder.c                |  2 +-
 include/linux/audit.h                   | 24 ++++++++
 include/linux/security.h                | 18 +++++-
 include/net/netlabel.h                  |  3 +-
 include/net/scm.h                       |  2 +-
 include/net/xfrm.h                      | 13 ++++-
 include/uapi/linux/audit.h              |  1 +
 kernel/audit.c                          | 61 +++++++++++++++------
 kernel/audit.h                          |  2 +
 kernel/auditfilter.c                    |  6 +-
 kernel/auditsc.c                        | 70 +++++++++++++++++++++---
 net/ipv4/ip_sockglue.c                  |  2 +-
 net/netfilter/nf_conntrack_netlink.c    |  4 +-
 net/netfilter/nf_conntrack_standalone.c |  2 +-
 net/netfilter/nfnetlink_queue.c         |  2 +-
 net/netlabel/netlabel_domainhash.c      |  4 +-
 net/netlabel/netlabel_unlabeled.c       | 24 ++++----
 net/netlabel/netlabel_user.c            | 16 ++++--
 net/netlabel/netlabel_user.h            |  6 +-
 net/xfrm/xfrm_policy.c                  | 10 ++--
 net/xfrm/xfrm_state.c                   | 20 ++++---
 security/integrity/ima/ima_api.c        |  7 ++-
 security/integrity/integrity_audit.c    |  6 +-
 security/security.c                     | 73 +++++++++++++++++++------
 security/smack/smackfs.c                |  3 +-
 25 files changed, 281 insertions(+), 100 deletions(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index a75ffcd0270a..a4f0cd140612 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -3090,7 +3090,7 @@ static void binder_transaction(struct binder_proc *proc,
 		size_t added_size;
 
 		security_task_getsecid(proc->tsk, &blob);
-		ret = security_secid_to_secctx(&blob, &lsmctx);
+		ret = security_secid_to_secctx(&blob, &lsmctx, LSMBLOB_DISPLAY);
 		if (ret) {
 			return_error = BR_FAILED_REPLY;
 			return_error_param = ret;
diff --git a/include/linux/audit.h b/include/linux/audit.h
index 786d065a64ef..ad1eda37166f 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -164,6 +164,8 @@ extern struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp
 extern __printf(2, 3)
 void audit_log_format(struct audit_buffer *ab, const char *fmt, ...);
 extern void		    audit_log_end(struct audit_buffer *ab);
+extern void		    audit_log_end_local(struct audit_buffer *ab,
+						struct audit_context *context);
 extern bool		    audit_string_contains_control(const char *string,
 							  size_t len);
 extern void		    audit_log_n_hex(struct audit_buffer *ab,
@@ -188,6 +190,7 @@ extern void		    audit_log_lost(const char *message);
 
 extern int audit_log_task_context(struct audit_buffer *ab);
 extern void audit_log_task_info(struct audit_buffer *ab);
+extern void audit_log_lsm(struct audit_context *context);
 
 extern int		    audit_update_lsm_rules(void);
 
@@ -226,6 +229,9 @@ void audit_log_format(struct audit_buffer *ab, const char *fmt, ...)
 { }
 static inline void audit_log_end(struct audit_buffer *ab)
 { }
+static inline void audit_log_end_local(struct audit_buffer *ab,
+				       struct audit_context *context)
+{ }
 static inline void audit_log_n_hex(struct audit_buffer *ab,
 				   const unsigned char *buf, size_t len)
 { }
@@ -252,6 +258,8 @@ static inline int audit_log_task_context(struct audit_buffer *ab)
 }
 static inline void audit_log_task_info(struct audit_buffer *ab)
 { }
+static void audit_log_lsm(struct audit_context *context)
+{ }
 
 static inline kuid_t audit_get_loginuid(struct task_struct *tsk)
 {
@@ -291,6 +299,7 @@ extern int  audit_alloc(struct task_struct *task);
 extern void __audit_free(struct task_struct *task);
 extern struct audit_context *audit_alloc_local(gfp_t gfpflags);
 extern void audit_free_context(struct audit_context *context);
+extern void audit_free_local(struct audit_context *context);
 extern void __audit_syscall_entry(int major, unsigned long a0, unsigned long a1,
 				  unsigned long a2, unsigned long a3);
 extern void __audit_syscall_exit(int ret_success, long ret_value);
@@ -392,6 +401,19 @@ static inline void audit_ptrace(struct task_struct *t)
 		__audit_ptrace(t);
 }
 
+static inline struct audit_context *audit_alloc_for_lsm(gfp_t gfp)
+{
+	struct audit_context *context = audit_context();
+
+	if (context)
+		return context;
+
+	if (lsm_multiple_contexts())
+		return audit_alloc_local(gfp);
+
+	return NULL;
+}
+
 				/* Private API (for audit.c only) */
 extern void __audit_ipc_obj(struct kern_ipc_perm *ipcp);
 extern void __audit_ipc_set_perm(unsigned long qbytes, uid_t uid, gid_t gid, umode_t mode);
@@ -566,6 +588,8 @@ extern int audit_signals;
 }
 static inline void audit_free_context(struct audit_context *context)
 { }
+static inline void audit_free_local(struct audit_context *context)
+{ }
 static inline int audit_alloc(struct task_struct *task)
 {
 	return 0;
diff --git a/include/linux/security.h b/include/linux/security.h
index 20486380c176..3335991e99cb 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -181,6 +181,8 @@ struct lsmblob {
 #define LSMBLOB_INVALID		-1	/* Not a valid LSM slot number */
 #define LSMBLOB_NEEDED		-2	/* Slot requested on initialization */
 #define LSMBLOB_NOT_NEEDED	-3	/* Slot not requested */
+#define LSMBLOB_DISPLAY		-4	/* Use the "display" slot */
+#define LSMBLOB_FIRST		-5	/* Use the default "display" slot */
 
 /**
  * lsmblob_init - initialize an lsmblob structure.
@@ -243,6 +245,17 @@ static inline u32 lsmblob_value(const struct lsmblob *blob)
 	return 0;
 }
 
+const char *security_lsm_slot_name(int slot);
+
+static inline bool lsm_multiple_contexts(void)
+{
+#ifdef CONFIG_SECURITY
+	return security_lsm_slot_name(1) != NULL;
+#else
+	return false;
+#endif
+}
+
 /* These functions are in security/commoncap.c */
 extern int cap_capable(const struct cred *cred, struct user_namespace *ns,
 		       int cap, unsigned int opts);
@@ -559,7 +572,8 @@ int security_setprocattr(const char *lsm, const char *name, void *value,
 			 size_t size);
 int security_netlink_send(struct sock *sk, struct sk_buff *skb);
 int security_ismaclabel(const char *name);
-int security_secid_to_secctx(struct lsmblob *blob, struct lsmcontext *cp);
+int security_secid_to_secctx(struct lsmblob *blob, struct lsmcontext *cp,
+			     int display);
 int security_secctx_to_secid(const char *secdata, u32 seclen,
 			     struct lsmblob *blob);
 void security_release_secctx(struct lsmcontext *cp);
@@ -1385,7 +1399,7 @@ static inline int security_ismaclabel(const char *name)
 }
 
 static inline int security_secid_to_secctx(struct lsmblob *blob,
-					   struct lsmcontext *cp)
+					   struct lsmcontext *cp, int display)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/include/net/netlabel.h b/include/net/netlabel.h
index 73fc25b4042b..9bc1f969a25d 100644
--- a/include/net/netlabel.h
+++ b/include/net/netlabel.h
@@ -97,7 +97,8 @@ struct calipso_doi;
 
 /* NetLabel audit information */
 struct netlbl_audit {
-	u32 secid;
+	struct audit_context *localcontext;
+	struct lsmblob lsmdata;
 	kuid_t loginuid;
 	unsigned int sessionid;
 };
diff --git a/include/net/scm.h b/include/net/scm.h
index b77a52f93389..f4d567d4885e 100644
--- a/include/net/scm.h
+++ b/include/net/scm.h
@@ -101,7 +101,7 @@ static inline void scm_passec(struct socket *sock, struct msghdr *msg, struct sc
 		 * and the infrastructure will know which it is.
 		 */
 		lsmblob_init(&lb, scm->secid);
-		err = security_secid_to_secctx(&lb, &context);
+		err = security_secid_to_secctx(&lb, &context, LSMBLOB_DISPLAY);
 
 		if (!err) {
 			put_cmsg(msg, SOL_SOCKET, SCM_SECURITY, context.len,
diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index b2a06f10b62c..bfe3ba2a5233 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -669,13 +669,22 @@ struct xfrm_spi_skb_cb {
 #define XFRM_SPI_SKB_CB(__skb) ((struct xfrm_spi_skb_cb *)&((__skb)->cb[0]))
 
 #ifdef CONFIG_AUDITSYSCALL
-static inline struct audit_buffer *xfrm_audit_start(const char *op)
+static inline struct audit_buffer *xfrm_audit_start(const char *op,
+						    struct audit_context **lac)
 {
+	struct audit_context *context;
 	struct audit_buffer *audit_buf = NULL;
 
 	if (audit_enabled == AUDIT_OFF)
 		return NULL;
-	audit_buf = audit_log_start(audit_context(), GFP_ATOMIC,
+	context = audit_context();
+	if (lac != NULL) {
+		if (lsm_multiple_contexts() && context == NULL)
+			context = audit_alloc_local(GFP_ATOMIC);
+		*lac = context;
+	}
+
+	audit_buf = audit_log_start(context, GFP_ATOMIC,
 				    AUDIT_MAC_IPSEC_EVENT);
 	if (audit_buf == NULL)
 		return NULL;
diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index cd2d8279a5e4..2a63720e56f6 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -139,6 +139,7 @@
 #define AUDIT_MAC_UNLBL_STCDEL	1417	/* NetLabel: del a static label */
 #define AUDIT_MAC_CALIPSO_ADD	1418	/* NetLabel: add CALIPSO DOI entry */
 #define AUDIT_MAC_CALIPSO_DEL	1419	/* NetLabel: del CALIPSO DOI entry */
+#define AUDIT_MAC_TASK_CONTEXTS	1420	/* Multiple LSM contexts */
 
 #define AUDIT_FIRST_KERN_ANOM_MSG   1700
 #define AUDIT_LAST_KERN_ANOM_MSG    1799
diff --git a/kernel/audit.c b/kernel/audit.c
index 4e219d1c1781..554279cb1e20 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -386,10 +386,12 @@ void audit_log_lost(const char *message)
 static int audit_log_config_change(char *function_name, u32 new, u32 old,
 				   int allow_changes)
 {
+	struct audit_context *context;
 	struct audit_buffer *ab;
 	int rc = 0;
 
-	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_CONFIG_CHANGE);
+	context = audit_alloc_for_lsm(GFP_KERNEL);
+	ab = audit_log_start(context, GFP_KERNEL, AUDIT_CONFIG_CHANGE);
 	if (unlikely(!ab))
 		return rc;
 	audit_log_format(ab, "op=set %s=%u old=%u ", function_name, new, old);
@@ -398,7 +400,7 @@ static int audit_log_config_change(char *function_name, u32 new, u32 old,
 	if (rc)
 		allow_changes = 0; /* Something weird, deny request */
 	audit_log_format(ab, " res=%d", allow_changes);
-	audit_log_end(ab);
+	audit_log_end_local(ab, context);
 	return rc;
 }
 
@@ -1072,12 +1074,6 @@ static void audit_log_common_recv_msg(struct audit_context *context,
 	audit_log_task_context(*ab);
 }
 
-static inline void audit_log_user_recv_msg(struct audit_buffer **ab,
-					   u16 msg_type)
-{
-	audit_log_common_recv_msg(NULL, ab, msg_type);
-}
-
 int is_audit_feature_set(int i)
 {
 	return af.features & AUDIT_FEATURE_TO_MASK(i);
@@ -1349,6 +1345,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 
 		err = audit_filter(msg_type, AUDIT_FILTER_USER);
 		if (err == 1) { /* match or error */
+			struct audit_context *lcontext;
 			char *str = data;
 
 			err = 0;
@@ -1357,7 +1354,8 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 				if (err)
 					break;
 			}
-			audit_log_user_recv_msg(&ab, msg_type);
+			lcontext = audit_alloc_for_lsm(GFP_KERNEL);
+			audit_log_common_recv_msg(lcontext, &ab, msg_type);
 			if (msg_type != AUDIT_USER_TTY) {
 				/* ensure NULL termination */
 				str[data_len - 1] = '\0';
@@ -1370,7 +1368,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 					data_len--;
 				audit_log_n_untrustedstring(ab, str, data_len);
 			}
-			audit_log_end(ab);
+			audit_log_end_local(ab, lcontext);
 		}
 		break;
 	case AUDIT_ADD_RULE:
@@ -1443,7 +1441,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 
 		if (lsmblob_is_set(&audit_sig_lsm)) {
 			err = security_secid_to_secctx(&audit_sig_lsm,
-						       &context);
+						       &context, LSMBLOB_FIRST);
 			if (err)
 				return err;
 		}
@@ -1550,6 +1548,7 @@ static void audit_receive(struct sk_buff  *skb)
 /* Log information about who is connecting to the audit multicast socket */
 static void audit_log_multicast(int group, const char *op, int err)
 {
+	struct audit_context *context;
 	const struct cred *cred;
 	struct tty_struct *tty;
 	char comm[sizeof(current->comm)];
@@ -1558,7 +1557,8 @@ static void audit_log_multicast(int group, const char *op, int err)
 	if (!audit_enabled)
 		return;
 
-	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_EVENT_LISTENER);
+	context = audit_alloc_for_lsm(GFP_KERNEL);
+	ab = audit_log_start(context, GFP_KERNEL, AUDIT_EVENT_LISTENER);
 	if (!ab)
 		return;
 
@@ -1576,7 +1576,7 @@ static void audit_log_multicast(int group, const char *op, int err)
 	audit_log_untrustedstring(ab, get_task_comm(comm, current));
 	audit_log_d_path_exe(ab, current->mm); /* exe= */
 	audit_log_format(ab, " nl-mcgrp=%d op=%s res=%d", group, op, !err);
-	audit_log_end(ab);
+	audit_log_end_local(ab, context);
 }
 
 /* Run custom bind function on netlink socket group connect or bind requests. */
@@ -2135,7 +2135,19 @@ int audit_log_task_context(struct audit_buffer *ab)
 	if (!lsmblob_is_set(&blob))
 		return 0;
 
-	error = security_secid_to_secctx(&blob, &context);
+	/*
+	 * If there is more than one security module that has a
+	 * subject "context" it's necessary to put the subject data
+	 * into a separate record to maintain compatibility.
+	 */
+	if (lsm_multiple_contexts()) {
+		if (ab->ctx)
+			ab->ctx->lsm = blob;
+		audit_log_format(ab, " subj=?");
+		return 0;
+	}
+
+	error = security_secid_to_secctx(&blob, &context, LSMBLOB_FIRST);
 	if (error) {
 		if (error != -EINVAL)
 			goto error_path;
@@ -2271,6 +2283,7 @@ static void audit_log_set_loginuid(kuid_t koldloginuid, kuid_t kloginuid,
 				   unsigned int oldsessionid,
 				   unsigned int sessionid, int rc)
 {
+	struct audit_context *context;
 	struct audit_buffer *ab;
 	uid_t uid, oldloginuid, loginuid;
 	struct tty_struct *tty;
@@ -2278,7 +2291,8 @@ static void audit_log_set_loginuid(kuid_t koldloginuid, kuid_t kloginuid,
 	if (!audit_enabled)
 		return;
 
-	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_LOGIN);
+	context = audit_alloc_for_lsm(GFP_KERNEL);
+	ab = audit_log_start(context, GFP_KERNEL, AUDIT_LOGIN);
 	if (!ab)
 		return;
 
@@ -2293,7 +2307,7 @@ static void audit_log_set_loginuid(kuid_t koldloginuid, kuid_t kloginuid,
 			 oldloginuid, loginuid, tty ? tty_name(tty) : "(none)",
 			 oldsessionid, sessionid, !rc);
 	audit_put_tty(tty);
-	audit_log_end(ab);
+	audit_log_end_local(ab, context);
 }
 
 /**
@@ -2393,6 +2407,21 @@ void audit_log_end(struct audit_buffer *ab)
 	audit_buffer_free(ab);
 }
 
+/**
+ * audit_log_end_local - end one audit record with local context
+ * @ab: the audit_buffer
+ * @context: the local context
+ *
+ * End an audit event in the usual way, then emit an LSM context
+ * record if approprite.
+ */
+void audit_log_end_local(struct audit_buffer *ab, struct audit_context *context)
+{
+	audit_log_end(ab);
+	audit_log_lsm(context);
+	audit_free_local(context);
+}
+
 /**
  * audit_log - Log an audit record
  * @ctx: audit context
diff --git a/kernel/audit.h b/kernel/audit.h
index 3f2285e1c6e0..624828a9a7e4 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -131,6 +131,7 @@ struct audit_context {
 	kgid_t		    gid, egid, sgid, fsgid;
 	unsigned long	    personality;
 	int		    arch;
+	struct lsmblob	    lsm;
 
 	pid_t		    target_pid;
 	kuid_t		    target_auid;
@@ -201,6 +202,7 @@ struct audit_context {
 extern bool audit_ever_enabled;
 
 extern void audit_log_session_info(struct audit_buffer *ab);
+extern void audit_log_lsm(struct audit_context *context);
 
 extern int auditd_test_task(struct task_struct *task);
 
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index 9e73a7961665..2b0a6fda767d 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -1098,12 +1098,14 @@ static void audit_list_rules(int seq, struct sk_buff_head *q)
 /* Log rule additions and removals */
 static void audit_log_rule_change(char *action, struct audit_krule *rule, int res)
 {
+	struct audit_context *context;
 	struct audit_buffer *ab;
 
 	if (!audit_enabled)
 		return;
 
-	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_CONFIG_CHANGE);
+	context = audit_alloc_for_lsm(GFP_KERNEL);
+	ab = audit_log_start(context, GFP_KERNEL, AUDIT_CONFIG_CHANGE);
 	if (!ab)
 		return;
 	audit_log_session_info(ab);
@@ -1111,7 +1113,7 @@ static void audit_log_rule_change(char *action, struct audit_krule *rule, int re
 	audit_log_format(ab, " op=%s", action);
 	audit_log_key(ab, rule->filterkey);
 	audit_log_format(ab, " list=%d res=%d", rule->listnr, res);
-	audit_log_end(ab);
+	audit_log_end_local(ab, context);
 }
 
 /**
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 5bfee5d0812d..44b150432147 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -989,12 +989,11 @@ struct audit_context *audit_alloc_local(gfp_t gfpflags)
 	context = audit_alloc_context(AUDIT_RECORD_CONTEXT, gfpflags);
 	if (!context) {
 		audit_log_lost("out of memory in audit_alloc_local");
-		goto out;
+		return NULL;
 	}
 	context->serial = audit_serial();
 	ktime_get_coarse_real_ts64(&context->ctime);
 	context->local = true;
-out:
 	return context;
 }
 EXPORT_SYMBOL(audit_alloc_local);
@@ -1015,6 +1014,13 @@ void audit_free_context(struct audit_context *context)
 }
 EXPORT_SYMBOL(audit_free_context);
 
+void audit_free_local(struct audit_context *context)
+{
+	if (context && context->local)
+		audit_free_context(context);
+}
+EXPORT_SYMBOL(audit_free_local);
+
 static int audit_log_pid_context(struct audit_context *context, pid_t pid,
 				 kuid_t auid, kuid_t uid,
 				 unsigned int sessionid,
@@ -1032,7 +1038,7 @@ static int audit_log_pid_context(struct audit_context *context, pid_t pid,
 			 from_kuid(&init_user_ns, auid),
 			 from_kuid(&init_user_ns, uid), sessionid);
 	if (lsmblob_is_set(blob)) {
-		if (security_secid_to_secctx(blob, &lsmctx)) {
+		if (security_secid_to_secctx(blob, &lsmctx, LSMBLOB_FIRST)) {
 			audit_log_format(ab, " obj=(none)");
 			rc = 1;
 		} else {
@@ -1277,7 +1283,8 @@ static void show_special(struct audit_context *context, int *call_panic)
 			struct lsmblob blob;
 
 			lsmblob_init(&blob, osid);
-			if (security_secid_to_secctx(&blob, &lsmcxt)) {
+			if (security_secid_to_secctx(&blob, &lsmcxt,
+						     LSMBLOB_FIRST)) {
 				audit_log_format(ab, " osid=%u", osid);
 				*call_panic = 1;
 			} else {
@@ -1429,7 +1436,7 @@ static void audit_log_name(struct audit_context *context, struct audit_names *n,
 		struct lsmcontext lsmctx;
 
 		lsmblob_init(&blob, n->osid);
-		if (security_secid_to_secctx(&blob, &lsmctx)) {
+		if (security_secid_to_secctx(&blob, &lsmctx, LSMBLOB_FIRST)) {
 			audit_log_format(ab, " osid=%u", n->osid);
 			if (call_panic)
 				*call_panic = 2;
@@ -1506,6 +1513,45 @@ static void audit_log_proctitle(void)
 	audit_log_end(ab);
 }
 
+void audit_log_lsm(struct audit_context *context)
+{
+	struct audit_buffer *ab;
+	struct lsmcontext lsmdata;
+	bool sep = false;
+	int error;
+	int i;
+
+	if (!lsm_multiple_contexts())
+		return;
+
+	if (context == NULL)
+		return;
+
+	if (!lsmblob_is_set(&context->lsm))
+		return;
+
+	ab = audit_log_start(context, GFP_ATOMIC, AUDIT_MAC_TASK_CONTEXTS);
+	if (!ab)
+		return; /* audit_panic or being filtered */
+
+	for (i = 0; i < LSMBLOB_ENTRIES; i++) {
+		if (context->lsm.secid[i] == 0)
+			continue;
+		error = security_secid_to_secctx(&context->lsm, &lsmdata, i);
+		if (error && error != -EINVAL) {
+			audit_panic("error in audit_log_lsm");
+			return;
+		}
+
+		audit_log_format(ab, "%ssubj_%s=%s", sep ? " " : "",
+				 security_lsm_slot_name(i), lsmdata.context);
+		sep = true;
+
+		security_release_secctx(&lsmdata);
+	}
+	audit_log_end(ab);
+}
+
 static void audit_log_exit(void)
 {
 	int i, call_panic = 0;
@@ -1630,6 +1676,8 @@ static void audit_log_exit(void)
 
 	audit_log_proctitle();
 
+	audit_log_lsm(context);
+
 	/* Send end of event record to help user space know we are finished */
 	ab = audit_log_start(context, GFP_KERNEL, AUDIT_EOE);
 	if (ab)
@@ -2635,10 +2683,12 @@ void __audit_ntp_log(const struct audit_ntp_data *ad)
 void __audit_log_nfcfg(const char *name, u8 af, unsigned int nentries,
 		       enum audit_nfcfgop op, gfp_t gfp)
 {
+	struct audit_context *context;
 	struct audit_buffer *ab;
 	char comm[sizeof(current->comm)];
 
-	ab = audit_log_start(audit_context(), gfp, AUDIT_NETFILTER_CFG);
+	context = audit_alloc_for_lsm(GFP_KERNEL);
+	ab = audit_log_start(context, gfp, AUDIT_NETFILTER_CFG);
 	if (!ab)
 		return;
 	audit_log_format(ab, "table=%s family=%u entries=%u op=%s",
@@ -2648,7 +2698,7 @@ void __audit_log_nfcfg(const char *name, u8 af, unsigned int nentries,
 	audit_log_task_context(ab); /* subj= */
 	audit_log_format(ab, " comm=");
 	audit_log_untrustedstring(ab, get_task_comm(comm, current));
-	audit_log_end(ab);
+	audit_log_end_local(ab, context);
 }
 EXPORT_SYMBOL_GPL(__audit_log_nfcfg);
 
@@ -2683,6 +2733,7 @@ static void audit_log_task(struct audit_buffer *ab)
  */
 void audit_core_dumps(long signr)
 {
+	struct audit_context *context;
 	struct audit_buffer *ab;
 
 	if (!audit_enabled)
@@ -2691,12 +2742,13 @@ void audit_core_dumps(long signr)
 	if (signr == SIGQUIT)	/* don't care for those */
 		return;
 
-	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_ANOM_ABEND);
+	context = audit_alloc_for_lsm(GFP_KERNEL);
+	ab = audit_log_start(context, GFP_KERNEL, AUDIT_ANOM_ABEND);
 	if (unlikely(!ab))
 		return;
 	audit_log_task(ab);
 	audit_log_format(ab, " sig=%ld res=1", signr);
-	audit_log_end(ab);
+	audit_log_end_local(ab, context);
 }
 
 /**
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index ae073b642fa7..5c0029a3a595 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -140,7 +140,7 @@ static void ip_cmsg_recv_security(struct msghdr *msg, struct sk_buff *skb)
 		return;
 
 	lsmblob_init(&lb, secid);
-	err = security_secid_to_secctx(&lb, &context);
+	err = security_secid_to_secctx(&lb, &context, LSMBLOB_DISPLAY);
 	if (err)
 		return;
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index e6fdcd87ab3e..b63ecc7185fc 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -339,7 +339,7 @@ static int ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
 	 * security_secid_to_secctx() will know which security module
 	 * to use to create the secctx.  */
 	lsmblob_init(&blob, ct->secmark);
-	ret = security_secid_to_secctx(&blob, &context);
+	ret = security_secid_to_secctx(&blob, &context, LSMBLOB_DISPLAY);
 	if (ret)
 		return 0;
 
@@ -655,7 +655,7 @@ static inline int ctnetlink_secctx_size(const struct nf_conn *ct)
 	struct lsmblob blob;
 	struct lsmcontext context;
 
-	ret = security_secid_to_secctx(&blob, &context);
+	ret = security_secid_to_secctx(&blob, &context, LSMBLOB_DISPLAY);
 	if (ret)
 		return 0;
 
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index c6112960fc73..2cb3a8df7932 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -177,7 +177,7 @@ static void ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
 	struct lsmcontext context;
 
 	lsmblob_init(&blob, ct->secmark);
-	ret = security_secid_to_secctx(&blob, &context);
+	ret = security_secid_to_secctx(&blob, &context, LSMBLOB_DISPLAY);
 	if (ret)
 		return;
 
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 0d8b83d84422..f2dffeed4789 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -316,7 +316,7 @@ static void nfqnl_get_sk_secctx(struct sk_buff *skb, struct lsmcontext *context)
 		 * blob. security_secid_to_secctx() will know which security
 		 * module to use to create the secctx.  */
 		lsmblob_init(&blob, skb->secmark);
-		security_secid_to_secctx(&blob, context);
+		security_secid_to_secctx(&blob, context, LSMBLOB_DISPLAY);
 	}
 
 	read_unlock_bh(&skb->sk->sk_callback_lock);
diff --git a/net/netlabel/netlabel_domainhash.c b/net/netlabel/netlabel_domainhash.c
index dc8c39f51f7d..2690a528d262 100644
--- a/net/netlabel/netlabel_domainhash.c
+++ b/net/netlabel/netlabel_domainhash.c
@@ -259,7 +259,7 @@ static void netlbl_domhsh_audit_add(struct netlbl_dom_map *entry,
 			break;
 		}
 		audit_log_format(audit_buf, " res=%u", result == 0 ? 1 : 0);
-		audit_log_end(audit_buf);
+		audit_log_end_local(audit_buf, audit_info->localcontext);
 	}
 }
 
@@ -614,7 +614,7 @@ int netlbl_domhsh_remove_entry(struct netlbl_dom_map *entry,
 		audit_log_format(audit_buf,
 				 " nlbl_domain=%s res=1",
 				 entry->domain ? entry->domain : "(default)");
-		audit_log_end(audit_buf);
+		audit_log_end_local(audit_buf, audit_info->localcontext);
 	}
 
 	switch (entry->def.type) {
diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index a84a265635c9..853b989da239 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -437,13 +437,14 @@ int netlbl_unlhsh_add(struct net *net,
 unlhsh_add_return:
 	rcu_read_unlock();
 	if (audit_buf != NULL) {
-		if (security_secid_to_secctx(lsmblob, &context) == 0) {
+		if (security_secid_to_secctx(lsmblob, &context,
+					     LSMBLOB_FIRST) == 0) {
 			audit_log_format(audit_buf, " sec_obj=%s",
 					 context.context);
 			security_release_secctx(&context);
 		}
 		audit_log_format(audit_buf, " res=%u", ret_val == 0 ? 1 : 0);
-		audit_log_end(audit_buf);
+		audit_log_end_local(audit_buf, audit_info->localcontext);
 	}
 	return ret_val;
 }
@@ -492,13 +493,14 @@ static int netlbl_unlhsh_remove_addr4(struct net *net,
 		if (dev != NULL)
 			dev_put(dev);
 		if (entry != NULL &&
-		    security_secid_to_secctx(&entry->lsmblob, &context) == 0) {
+		    security_secid_to_secctx(&entry->lsmblob, &context,
+					     LSMBLOB_FIRST) == 0) {
 			audit_log_format(audit_buf, " sec_obj=%s",
 					 context.context);
 			security_release_secctx(&context);
 		}
 		audit_log_format(audit_buf, " res=%u", entry != NULL ? 1 : 0);
-		audit_log_end(audit_buf);
+		audit_log_end_local(audit_buf, audit_info->localcontext);
 	}
 
 	if (entry == NULL)
@@ -552,13 +554,14 @@ static int netlbl_unlhsh_remove_addr6(struct net *net,
 		if (dev != NULL)
 			dev_put(dev);
 		if (entry != NULL &&
-		    security_secid_to_secctx(&entry->lsmblob, &context) == 0) {
+		    security_secid_to_secctx(&entry->lsmblob, &context,
+					     LSMBLOB_FIRST) == 0) {
 			audit_log_format(audit_buf, " sec_obj=%s",
 					 context.context);
 			security_release_secctx(&context);
 		}
 		audit_log_format(audit_buf, " res=%u", entry != NULL ? 1 : 0);
-		audit_log_end(audit_buf);
+		audit_log_end_local(audit_buf, audit_info->localcontext);
 	}
 
 	if (entry == NULL)
@@ -741,7 +744,7 @@ static void netlbl_unlabel_acceptflg_set(u8 value,
 	if (audit_buf != NULL) {
 		audit_log_format(audit_buf,
 				 " unlbl_accept=%u old=%u", value, old_val);
-		audit_log_end(audit_buf);
+		audit_log_end_local(audit_buf, audit_info->localcontext);
 	}
 }
 
@@ -1122,7 +1125,7 @@ static int netlbl_unlabel_staticlist_gen(u32 cmd,
 		lsmb = (struct lsmblob *)&addr6->lsmblob;
 	}
 
-	ret_val = security_secid_to_secctx(lsmb, &context);
+	ret_val = security_secid_to_secctx(lsmb, &context, LSMBLOB_FIRST);
 	if (ret_val != 0)
 		goto list_cb_failure;
 	ret_val = nla_put(cb_arg->skb,
@@ -1521,14 +1524,11 @@ int __init netlbl_unlabel_defconf(void)
 	int ret_val;
 	struct netlbl_dom_map *entry;
 	struct netlbl_audit audit_info;
-	struct lsmblob blob;
 
 	/* Only the kernel is allowed to call this function and the only time
 	 * it is called is at bootup before the audit subsystem is reporting
 	 * messages so don't worry to much about these values. */
-	security_task_getsecid(current, &blob);
-	/* scaffolding until audit_info.secid is converted */
-	audit_info.secid = blob.secid[0];
+	security_task_getsecid(current, &audit_info.lsmdata);
 	audit_info.loginuid = GLOBAL_ROOT_UID;
 	audit_info.sessionid = 0;
 
diff --git a/net/netlabel/netlabel_user.c b/net/netlabel/netlabel_user.c
index 951ba0639d20..4fb4c37cc4a7 100644
--- a/net/netlabel/netlabel_user.c
+++ b/net/netlabel/netlabel_user.c
@@ -83,14 +83,17 @@ int __init netlbl_netlink_init(void)
 struct audit_buffer *netlbl_audit_start_common(int type,
 					       struct netlbl_audit *audit_info)
 {
+	struct audit_context *audit_ctx;
 	struct audit_buffer *audit_buf;
 	struct lsmcontext context;
-	struct lsmblob blob;
 
 	if (audit_enabled == AUDIT_OFF)
 		return NULL;
 
-	audit_buf = audit_log_start(audit_context(), GFP_ATOMIC, type);
+	audit_ctx = audit_alloc_for_lsm(GFP_ATOMIC);
+	audit_info->localcontext = audit_ctx;
+
+	audit_buf = audit_log_start(audit_ctx, GFP_ATOMIC, type);
 	if (audit_buf == NULL)
 		return NULL;
 
@@ -98,12 +101,13 @@ struct audit_buffer *netlbl_audit_start_common(int type,
 			 from_kuid(&init_user_ns, audit_info->loginuid),
 			 audit_info->sessionid);
 
-	lsmblob_init(&blob, audit_info->secid);
-	if (audit_info->secid != 0 &&
-	    security_secid_to_secctx(&blob, &context) == 0) {
+	if (!lsm_multiple_contexts() && lsmblob_is_set(&audit_info->lsmdata) &&
+	    security_secid_to_secctx(&audit_info->lsmdata, &context,
+				     LSMBLOB_FIRST) == 0) {
 		audit_log_format(audit_buf, " subj=%s", context.context);
 		security_release_secctx(&context);
-	}
+	} else
+		audit_log_format(audit_buf, " subj=?");
 
 	return audit_buf;
 }
diff --git a/net/netlabel/netlabel_user.h b/net/netlabel/netlabel_user.h
index 438b5db6c714..bd4335443b87 100644
--- a/net/netlabel/netlabel_user.h
+++ b/net/netlabel/netlabel_user.h
@@ -34,11 +34,7 @@
 static inline void netlbl_netlink_auditinfo(struct sk_buff *skb,
 					    struct netlbl_audit *audit_info)
 {
-	struct lsmblob blob;
-
-	security_task_getsecid(current, &blob);
-	/* scaffolding until secid is converted */
-	audit_info->secid = blob.secid[0];
+	security_task_getsecid(current, &audit_info->lsmdata);
 	audit_info->loginuid = audit_get_loginuid(current);
 	audit_info->sessionid = audit_get_sessionid(current);
 }
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index d622c2548d22..6aa4bcc08848 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -4205,30 +4205,32 @@ static void xfrm_audit_common_policyinfo(struct xfrm_policy *xp,
 
 void xfrm_audit_policy_add(struct xfrm_policy *xp, int result, bool task_valid)
 {
+	struct audit_context *context;
 	struct audit_buffer *audit_buf;
 
-	audit_buf = xfrm_audit_start("SPD-add");
+	audit_buf = xfrm_audit_start("SPD-add", &context);
 	if (audit_buf == NULL)
 		return;
 	xfrm_audit_helper_usrinfo(task_valid, audit_buf);
 	audit_log_format(audit_buf, " res=%u", result);
 	xfrm_audit_common_policyinfo(xp, audit_buf);
-	audit_log_end(audit_buf);
+	audit_log_end_local(audit_buf, context);
 }
 EXPORT_SYMBOL_GPL(xfrm_audit_policy_add);
 
 void xfrm_audit_policy_delete(struct xfrm_policy *xp, int result,
 			      bool task_valid)
 {
+	struct audit_context *context;
 	struct audit_buffer *audit_buf;
 
-	audit_buf = xfrm_audit_start("SPD-delete");
+	audit_buf = xfrm_audit_start("SPD-delete", &context);
 	if (audit_buf == NULL)
 		return;
 	xfrm_audit_helper_usrinfo(task_valid, audit_buf);
 	audit_log_format(audit_buf, " res=%u", result);
 	xfrm_audit_common_policyinfo(xp, audit_buf);
-	audit_log_end(audit_buf);
+	audit_log_end_local(audit_buf, context);
 }
 EXPORT_SYMBOL_GPL(xfrm_audit_policy_delete);
 #endif
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index bbd4643d7e82..ffb75b23f261 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2740,29 +2740,31 @@ static void xfrm_audit_helper_pktinfo(struct sk_buff *skb, u16 family,
 
 void xfrm_audit_state_add(struct xfrm_state *x, int result, bool task_valid)
 {
+	struct audit_context *context;
 	struct audit_buffer *audit_buf;
 
-	audit_buf = xfrm_audit_start("SAD-add");
+	audit_buf = xfrm_audit_start("SAD-add", &context);
 	if (audit_buf == NULL)
 		return;
 	xfrm_audit_helper_usrinfo(task_valid, audit_buf);
 	xfrm_audit_helper_sainfo(x, audit_buf);
 	audit_log_format(audit_buf, " res=%u", result);
-	audit_log_end(audit_buf);
+	audit_log_end_local(audit_buf, context);
 }
 EXPORT_SYMBOL_GPL(xfrm_audit_state_add);
 
 void xfrm_audit_state_delete(struct xfrm_state *x, int result, bool task_valid)
 {
+	struct audit_context *context;
 	struct audit_buffer *audit_buf;
 
-	audit_buf = xfrm_audit_start("SAD-delete");
+	audit_buf = xfrm_audit_start("SAD-delete", &context);
 	if (audit_buf == NULL)
 		return;
 	xfrm_audit_helper_usrinfo(task_valid, audit_buf);
 	xfrm_audit_helper_sainfo(x, audit_buf);
 	audit_log_format(audit_buf, " res=%u", result);
-	audit_log_end(audit_buf);
+	audit_log_end_local(audit_buf, context);
 }
 EXPORT_SYMBOL_GPL(xfrm_audit_state_delete);
 
@@ -2772,7 +2774,7 @@ void xfrm_audit_state_replay_overflow(struct xfrm_state *x,
 	struct audit_buffer *audit_buf;
 	u32 spi;
 
-	audit_buf = xfrm_audit_start("SA-replay-overflow");
+	audit_buf = xfrm_audit_start("SA-replay-overflow", NULL);
 	if (audit_buf == NULL)
 		return;
 	xfrm_audit_helper_pktinfo(skb, x->props.family, audit_buf);
@@ -2790,7 +2792,7 @@ void xfrm_audit_state_replay(struct xfrm_state *x,
 	struct audit_buffer *audit_buf;
 	u32 spi;
 
-	audit_buf = xfrm_audit_start("SA-replayed-pkt");
+	audit_buf = xfrm_audit_start("SA-replayed-pkt", NULL);
 	if (audit_buf == NULL)
 		return;
 	xfrm_audit_helper_pktinfo(skb, x->props.family, audit_buf);
@@ -2805,7 +2807,7 @@ void xfrm_audit_state_notfound_simple(struct sk_buff *skb, u16 family)
 {
 	struct audit_buffer *audit_buf;
 
-	audit_buf = xfrm_audit_start("SA-notfound");
+	audit_buf = xfrm_audit_start("SA-notfound", NULL);
 	if (audit_buf == NULL)
 		return;
 	xfrm_audit_helper_pktinfo(skb, family, audit_buf);
@@ -2819,7 +2821,7 @@ void xfrm_audit_state_notfound(struct sk_buff *skb, u16 family,
 	struct audit_buffer *audit_buf;
 	u32 spi;
 
-	audit_buf = xfrm_audit_start("SA-notfound");
+	audit_buf = xfrm_audit_start("SA-notfound", NULL);
 	if (audit_buf == NULL)
 		return;
 	xfrm_audit_helper_pktinfo(skb, family, audit_buf);
@@ -2837,7 +2839,7 @@ void xfrm_audit_state_icvfail(struct xfrm_state *x,
 	__be32 net_spi;
 	__be32 net_seq;
 
-	audit_buf = xfrm_audit_start("SA-icv-failure");
+	audit_buf = xfrm_audit_start("SA-icv-failure", NULL);
 	if (audit_buf == NULL)
 		return;
 	xfrm_audit_helper_pktinfo(skb, x->props.family, audit_buf);
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index e83fa1c32843..8b6f8402703d 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -340,6 +340,7 @@ void ima_store_measurement(struct integrity_iint_cache *iint,
 void ima_audit_measurement(struct integrity_iint_cache *iint,
 			   const unsigned char *filename)
 {
+	struct audit_context *context;
 	struct audit_buffer *ab;
 	char *hash;
 	const char *algo_name = hash_algo_name[iint->ima_hash->algo];
@@ -356,8 +357,8 @@ void ima_audit_measurement(struct integrity_iint_cache *iint,
 		hex_byte_pack(hash + (i * 2), iint->ima_hash->digest[i]);
 	hash[i * 2] = '\0';
 
-	ab = audit_log_start(audit_context(), GFP_KERNEL,
-			     AUDIT_INTEGRITY_RULE);
+	context = audit_alloc_for_lsm(GFP_KERNEL);
+	ab = audit_log_start(context, GFP_KERNEL, AUDIT_INTEGRITY_RULE);
 	if (!ab)
 		goto out;
 
@@ -366,7 +367,7 @@ void ima_audit_measurement(struct integrity_iint_cache *iint,
 	audit_log_format(ab, " hash=\"%s:%s\"", algo_name, hash);
 
 	audit_log_task_info(ab);
-	audit_log_end(ab);
+	audit_log_end_local(ab, context);
 
 	iint->flags |= IMA_AUDITED;
 out:
diff --git a/security/integrity/integrity_audit.c b/security/integrity/integrity_audit.c
index 29220056207f..b38163c43659 100644
--- a/security/integrity/integrity_audit.c
+++ b/security/integrity/integrity_audit.c
@@ -38,13 +38,15 @@ void integrity_audit_message(int audit_msgno, struct inode *inode,
 			     const char *cause, int result, int audit_info,
 			     int errno)
 {
+	struct audit_context *context;
 	struct audit_buffer *ab;
 	char name[TASK_COMM_LEN];
 
 	if (!integrity_audit_info && audit_info == 1)	/* Skip info messages */
 		return;
 
-	ab = audit_log_start(audit_context(), GFP_KERNEL, audit_msgno);
+	context = audit_alloc_for_lsm(GFP_KERNEL);
+	ab = audit_log_start(context, GFP_KERNEL, audit_msgno);
 	audit_log_format(ab, "pid=%d uid=%u auid=%u ses=%u",
 			 task_pid_nr(current),
 			 from_kuid(&init_user_ns, current_uid()),
@@ -63,5 +65,5 @@ void integrity_audit_message(int audit_msgno, struct inode *inode,
 		audit_log_format(ab, " ino=%lu", inode->i_ino);
 	}
 	audit_log_format(ab, " res=%d errno=%d", !result, errno);
-	audit_log_end(ab);
+	audit_log_end_local(ab, context);
 }
diff --git a/security/security.c b/security/security.c
index c6b0f854c4a3..1a78f7bb808b 100644
--- a/security/security.c
+++ b/security/security.c
@@ -483,7 +483,31 @@ static int lsm_append(const char *new, char **result)
  * Pointers to the LSM id structures for local use.
  */
 static int lsm_slot __lsm_ro_after_init;
-static struct lsm_id *lsm_slotlist[LSMBLOB_ENTRIES];
+static struct lsm_id *lsm_slotlist[LSMBLOB_ENTRIES] __lsm_ro_after_init;
+
+/**
+ * security_lsm_slot_name - Get the name of the security module in a slot
+ * @slot: index into the "display" slot list.
+ *
+ * Provide the name of the security module associated with
+ * a display slot.
+ *
+ * If @slot is LSMBLOB_INVALID return the value
+ * for slot 0 if it has been set, otherwise NULL.
+ *
+ * Returns a pointer to the name string or NULL.
+ */
+const char *security_lsm_slot_name(int slot)
+{
+	if (slot == LSMBLOB_INVALID)
+		slot = 0;
+	else if (slot >= LSMBLOB_ENTRIES || slot < 0)
+		return NULL;
+
+	if (lsm_slotlist[slot] == NULL)
+		return NULL;
+	return lsm_slotlist[slot]->lsm;
+}
 
 /**
  * security_add_hooks - Add a modules hooks to the hook lists.
@@ -2193,7 +2217,7 @@ int security_setprocattr(const char *lsm, const char *name, void *value,
 		hlist_for_each_entry(hp, &security_hook_heads.setprocattr,
 				     list) {
 			rc = hp->hook.setprocattr(name, value, size);
-			if (rc < 0)
+			if (rc < 0 && rc != -EINVAL)
 				return rc;
 		}
 
@@ -2238,13 +2262,32 @@ int security_ismaclabel(const char *name)
 }
 EXPORT_SYMBOL(security_ismaclabel);
 
-int security_secid_to_secctx(struct lsmblob *blob, struct lsmcontext *cp)
+int security_secid_to_secctx(struct lsmblob *blob, struct lsmcontext *cp,
+			     int display)
 {
 	struct security_hook_list *hp;
-	int display = lsm_task_display(current);
 
 	memset(cp, 0, sizeof(*cp));
 
+	/*
+	 * display either is the slot number use for formatting
+	 * or an instruction on which relative slot to use.
+	 */
+	if (display == LSMBLOB_DISPLAY)
+		display = lsm_task_display(current);
+	else if (display == LSMBLOB_FIRST)
+		display = LSMBLOB_INVALID;
+	else if (display < 0) {
+		WARN_ONCE(true,
+			"LSM: %s unknown display\n", __func__);
+		display = LSMBLOB_INVALID;
+	} else if (display >= lsm_slot) {
+		WARN_ONCE(true,
+			"LSM: %s invalid display\n", __func__);
+		display = LSMBLOB_INVALID;
+	}
+
+
 	hlist_for_each_entry(hp, &security_hook_heads.secid_to_secctx, list) {
 		if (WARN_ON(hp->lsmid->slot < 0 || hp->lsmid->slot >= lsm_slot))
 			continue;
@@ -2274,7 +2317,7 @@ int security_secctx_to_secid(const char *secdata, u32 seclen,
 			return hp->hook.secctx_to_secid(secdata, seclen,
 						&blob->secid[hp->lsmid->slot]);
 	}
-	return 0;
+	return -EOPNOTSUPP;
 }
 EXPORT_SYMBOL(security_secctx_to_secid);
 
@@ -2767,23 +2810,17 @@ int security_key_getsecurity(struct key *key, char **_buffer)
 int security_audit_rule_init(u32 field, u32 op, char *rulestr, void **lsmrule)
 {
 	struct security_hook_list *hp;
-	bool one_is_good = false;
-	int rc = 0;
-	int trc;
+	int display = lsm_task_display(current);
 
 	hlist_for_each_entry(hp, &security_hook_heads.audit_rule_init, list) {
 		if (WARN_ON(hp->lsmid->slot < 0 || hp->lsmid->slot >= lsm_slot))
 			continue;
-		trc = hp->hook.audit_rule_init(field, op, rulestr,
-					       &lsmrule[hp->lsmid->slot]);
-		if (trc == 0)
-			one_is_good = true;
-		else
-			rc = trc;
+		if (display != LSMBLOB_INVALID && display != hp->lsmid->slot)
+			continue;
+		return hp->hook.audit_rule_init(field, op, rulestr,
+						&lsmrule[hp->lsmid->slot]);
 	}
-	if (one_is_good)
-		return 0;
-	return rc;
+	return 0;
 }
 
 int security_audit_rule_known(struct audit_krule *krule)
@@ -2815,6 +2852,8 @@ int security_audit_rule_match(struct lsmblob *blob, u32 field, u32 op,
 			continue;
 		if (lsmrule[hp->lsmid->slot] == NULL)
 			continue;
+		if (lsmrule[hp->lsmid->slot] == NULL)
+			continue;
 		rc = hp->hook.audit_rule_match(blob->secid[hp->lsmid->slot],
 					       field, op,
 					       &lsmrule[hp->lsmid->slot]);
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 139768a13d11..17391258e896 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -185,7 +185,8 @@ static void smk_netlabel_audit_set(struct netlbl_audit *nap)
 
 	nap->loginuid = audit_get_loginuid(current);
 	nap->sessionid = audit_get_sessionid(current);
-	nap->secid = skp->smk_secid;
+	lsmblob_init(&nap->lsmdata, 0);
+	nap->lsmdata.secid[smack_lsmid.slot] = skp->smk_secid;
 }
 
 /*
-- 
2.24.1

