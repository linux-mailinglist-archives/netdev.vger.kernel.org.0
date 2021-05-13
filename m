Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D746437FF2D
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 22:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232957AbhEMUds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 16:33:48 -0400
Received: from sonic317-38.consmr.mail.ne1.yahoo.com ([66.163.184.49]:36094
        "EHLO sonic317-38.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230427AbhEMUdq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 16:33:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1620937956; bh=sJ9e8qsmpa5HneGdK4dPH8thQK5rJ0jRuPc0AgwVcI4=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=EauFfg6M5Q0w4DZRikeATnp8ogwCw1+9K/KbDWfxFNDVYjZruRXPas/0uiSnaCZKxoeO2bZBUvumpb51vEwftTG1ndEoIRRARFN58T6BaRad835JUrZsjFhvLw3hVmS/lnNGZRepu1M0bvpzciYrgiZ7/+/8t9biKZPt4SPU4mhGJlu0nvUrXWHoeaFKhu4Vl6+CttsoGM+/pVFlef8v/oRfRRfaFXkfD2lplV0yC5iWF291cxdteJT0UD1at3WHHCTxF1VNm1dHSKSGnJbiKtsC22e98ahXVTWOaeNUp3RBl0XROyEqoKVM85ZKUxUltw59TmN4ViAu1zuNSRiV/g==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1620937956; bh=z+Uplu/4K2KS5E/XqCMsbkvJFCRZ7CaF4qefZ6D/R6M=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=nxzTwifUUhcccIVnkLXe1YdfLAXQcyG0r/a48vT30S6g93slBZlajfo/4JXCIJ+7N4UreoXcpf6NJZJ7JiI08Sv4IPiwNFlAu88qMvugc/eTxb9kQIXB8vUUTDJ2VWE17AA/mIN4G+8YwghcqUm/a9iM5PNXNFuG1u3W5dKdO64TgZjc6//wO/YmGpkPP3tv0CGXslytwSNSSVl2x1skrqTTP21GBfPYnqZZ28VON8V4ljxvlgTn6IL6JENGr6VoNtdzYoiM6IbwzMjM/8q5aIbOJ3OnJRxSruHwz3deiXtF3zLmFnQ8IPJ4YOmO2ypdYW41WAZgvrDGSDewiBppHw==
X-YMail-OSG: vHYBfcgVM1mNMqnZFBL7UTydBQQ92gKWNn.QM9AqkUT7HdDYqKPza9ZEGL60cO6
 zDS1n5IfdF2taKkV2dUTaVKgp_NtN4jcdWr7m2w2ajAlVDJZn8WVDd_h87b1CxEaEDNMgotEA829
 PAA6PnaBOpBEM59P6DuJ5swfj2qgj_4iT2tYNL5sy6eaeXtyGTkQBS9E9B5x9SBlL4htkZ4q6QPg
 9VgCqzIwIh4pvTTk5EmFlsXf28kcPp9uqSOYjOw0ndtPwd3OSs5_fc9RFeO6DyeP3Xz7Ofblx.NX
 lp14.n4k5ZPInaOLHF.RQ3VC1Vjo_0KC4BxmKNuHIykRaP4puKfyaMbAM52OW0BkgK4Z8fYivKgb
 QfPESv0S1g4lIufT4WjyhewPiBeLsejGDeQsLZJt5JYpV7S1Irhccpu1jfQ.sbA2.uHqRAhimguq
 yXgIoBPdQfEuHV3kD3VrFXOQA4pM6uHo3JqFaZsoXMUTYdFRU1NOHrKkBiD7EXUbg4SfOfTdmKP8
 EzRTVZXMCFSP9eOpZAYUkcbt793ahVkCoHB_1X3JYUGeUPhzXFpEgXMPt_DSOOdDIQC.adjbSIvu
 srvsQ7YmJjYJuV8VGFkk7K4ibFvisywytAOySBSk3HfhcukXUQpjDgxKCWcPWgIBkLCowEABK7eO
 u5Zi9TtkvItOeDYMhKNLSE1P9Iq8ZGggtSPtgWfiS.9t2nB2tNvIEWfoUZXiiqIN9buqhXhI5qGn
 O1lxzU9BhhYC_Iaa6Ow0zz9ZccpKHFnJ69XPxBpP7eXnRI5SO6GrJ2xqsIqOe3gJf6P2R.X.UWk5
 8gPIfIPABul3Wt8lKQgknDO9MCJWQVESw4GRDQmy5nb29MjoY6gdj8EFshAA1okRa6zXDonSr3Sv
 UAAzxRDXxjTUZYBwSSYj09h_3cu9zDVDzq7ImHeHWIAfz2iQhMJsfC5a_FgRDh3_iHmDkTyv9A4M
 UfSpYcFdlImiVBK0AC_LKdYEFRGALz.ipveDbQHq5FFowZo_GmDidFTRwDyAWoLHAEkU9HFa_WLH
 1tUT5.FsnAzU40y9KpsVPZMb4FFDrquGdHnqFSIfTgjVuxxQFEgt34i0AIbHz7HlH1DYYiBLvPEQ
 tszMxoeAYqDiofrFXp7xqmr.k8DvxadlGq9uuUskX.3OEKRabL.RGezxrsU6_1OSZ3KzjjdH1Ehk
 BKIhLZaXz2aA0C4InPW4_vc1mJxaiuzVN8guNR5SE4BhEf.s6zf4qWKJ.ojXZB.npcRTqodI9hjk
 AG94OS0CYzPbkLL9I9L8HFalreuEIzVh1PZAg.20Yc8V1b9NNvP18qXGh5npYxGIKy6L6lQ4H7Ck
 DFvBmY5tSEZVV64NwgqzdIQuETfpiztAdEqOcYpfQxRvHEI.LPX9eUpLLEvLVVY4nEPnmt3Q3Yvl
 KcGgjJtSo7XqIVnsi8XNHxnQyriu0f0QjFIiiTefUu99kggXh0TbWU.UWW4UW0iXNMSdTn23irWu
 XHd.4wmk4Juj7ZxnlRsle0WIXTxod5gJRn66sllYTzPbPxtFHyZ_hbNqdArGCzc6T0qfxh6kd7RH
 3ch9ouO8eMDlN5gFtOV2rMNiTi78YeusigV0GHgPrD5lRwQgJqmGgho6ZCYn2of3gbviP7VsWIBm
 MjhKr0havbayQqse5EL.5FaykCu3aklo9.Nn52AMIFm9QbulBsIxGS00rh_NbFko7AUQSXSxNztS
 _UUUlcIC31eS6q1ev8xtOfHTjcHL7j_tt24UczrE.v4P6I8E._dN.WUMB9bUtCUWswHLAIsYtO38
 z.ou_LEHDmHE3tHciiHrollapmlUV3hnMyhric5hLydzA8hG0DAEfPiIEXtzhx1vqLawQ5BBau.Q
 IDhh9TDX7ySs_W9hMF36QHMe544IkUMEyqoUUBP8l54n_nVTjc8WxnII1T5lC2eSqrsN_idmldq2
 NvRLzvAweGU_sEI8f38KeUueoLs3aOnmRjpCJBBCGQKLNkKODk.Bcfcka6uSKx29AGzcrhapPtv.
 nBIyT.1YsefBM15JgjISFVNCfR4BYyJ.ghC_9JR3sdTqrcRo9svdqOrFopxn5zwQ0xUnDkFlwFPQ
 1faFBLPr1ihgSjN4C4wgKMQKHynl7I2fKlTDpQqLi.b1qScYU.J7tDKY3P10PnocUTDUGEbKXp96
 mYYkOQx7vh9DoI6UKcXa3A96iZ83VVojy6oQ2HAbM41C2jHy5vCHTRzOFAXP15X30nfnk2uSq.wU
 Vf.B7H3J3n2wRHnQIsTAdYCn0Shho.u0JEfM6GIK4QOtkxEMruOvtCrpajMUlr4y7ABUo6AZqbdA
 MFs6Vk1Gnd3RaKZ0mtX9yUyoV8pn5I9IkeNTj87ja9CM1K6U5VUy7EdtzfMeiWxcmEOS_yVOfc18
 bRJgrJyD8X4y64s2TaepTN_0u6G5RIX3C1Q3DMgo82QfWzNwuHJ78oGOAz0udsrJVcH1_AhuC.3a
 _QydsFmSWuEiG2is8SPQZHPPW0T3Eea8M3y6vByzpFXQs7KbBd3FO5WhstRIu5rdpqxmT8BhtC.C
 qYgWShZjHbPjYg7RYOn6OQOzfdjuTchNvsEHlC_Qyw7BZa6nq602zRyr480ZueNop9V5yrS9QH2o
 xIFnvcIils.OlVr0fTPM9KfBfCKSUz0l0800HEuhIC7.0ZqEY6syav6Id2_Y5zxz7008zYMq3O3v
 TtT5VsjTKP3SqyDrd.4jGIEmFPgUOofdJsmFw_xg_YtWF36Swi2RnLDYDdciqvC2PpHRqS7wCbgN
 L6qIWL2JoEf5ZLo1RJmsqNpGfWhhZ9Nur8iE6V93fdFcAb84g56Cdd2Qy6k6.EsIP7Lx4sPKPlI1
 baLc5p64UgnD62YoqNqeScyLxfevWWIXgGrtQfqtXGa2ABd2UXso0Q4Yrq4rYPYuVlKM8DqPK4jx
 DQfLHTcTwPcZVSf_hJmcM.MvYpUih35Z8LsD1xKdzYteRUb5qotvcDy8St0ihGvxDBGqZe81aAWj
 cIpsdCd0fUDcNesL0qkOcafWnLinhdpD6sCTrcJ_gyWrQO5cGMpI1krneAPIOHqqRz69MsltkJgf
 rjuNN2FcwQ42uBa67Lm.8m.TTL.xDH32Au6q5U9FsYntiQxY3hiiPcXAIHNmjdDeb.PrSRYkBkRE
 LdgL8IsWm2Xhm9I.bTSuXjeXYJkx4z7p72LxU0u_8PL2Pkq7nBBOr0DKd_ljo4UzR8ZMNqQzfHo8
 AIrHw9iyveaZ8F6NXbEzb.F6uIPt7a1mzVKXd7kJSxw--
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic317.consmr.mail.ne1.yahoo.com with HTTP; Thu, 13 May 2021 20:32:36 +0000
Received: by kubenode518.mail-prod1.omega.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 30b071452c09b5da941082a96c8657ff;
          Thu, 13 May 2021 20:32:33 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v26 22/25] Audit: Add new record for multiple process LSM  attributes
Date:   Thu, 13 May 2021 13:08:04 -0700
Message-Id: <20210513200807.15910-23-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210513200807.15910-1-casey@schaufler-ca.com>
References: <20210513200807.15910-1-casey@schaufler-ca.com>
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
To: paul@paul-moore.com
To: linux-audit@redhat.com
To: rgb@redhat.com
Cc: netdev@vger.kernel.org
---
 drivers/android/binder.c                |  2 +-
 include/linux/audit.h                   | 24 ++++++++
 include/linux/security.h                | 16 ++++-
 include/net/netlabel.h                  |  3 +-
 include/net/scm.h                       |  2 +-
 include/net/xfrm.h                      | 13 +++-
 include/uapi/linux/audit.h              |  1 +
 kernel/audit.c                          | 80 ++++++++++++++++++-------
 kernel/audit.h                          |  3 +
 kernel/auditfilter.c                    |  6 +-
 kernel/auditsc.c                        | 75 ++++++++++++++++++++---
 net/ipv4/ip_sockglue.c                  |  2 +-
 net/netfilter/nf_conntrack_netlink.c    |  4 +-
 net/netfilter/nf_conntrack_standalone.c |  2 +-
 net/netfilter/nfnetlink_queue.c         |  2 +-
 net/netlabel/netlabel_domainhash.c      |  4 +-
 net/netlabel/netlabel_unlabeled.c       | 24 ++++----
 net/netlabel/netlabel_user.c            | 20 ++++---
 net/netlabel/netlabel_user.h            |  6 +-
 net/xfrm/xfrm_policy.c                  | 10 ++--
 net/xfrm/xfrm_state.c                   | 20 ++++---
 security/integrity/ima/ima_api.c        |  7 ++-
 security/integrity/integrity_audit.c    |  6 +-
 security/security.c                     | 46 +++++++++-----
 security/smack/smackfs.c                |  3 +-
 25 files changed, 274 insertions(+), 107 deletions(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index f2a27bbbbe4d..7818c0fe0f38 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2722,7 +2722,7 @@ static void binder_transaction(struct binder_proc *proc,
 		 * case well anyway.
 		 */
 		security_task_getsecid_obj(proc->tsk, &blob);
-		ret = security_secid_to_secctx(&blob, &lsmctx);
+		ret = security_secid_to_secctx(&blob, &lsmctx, LSMBLOB_DISPLAY);
 		if (ret) {
 			return_error = BR_FAILED_REPLY;
 			return_error_param = ret;
diff --git a/include/linux/audit.h b/include/linux/audit.h
index 97cd7471e572..229cd71fbf09 100644
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
@@ -386,6 +395,19 @@ static inline void audit_ptrace(struct task_struct *t)
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
@@ -560,6 +582,8 @@ extern int audit_signals;
 }
 static inline void audit_free_context(struct audit_context *context)
 { }
+static inline void audit_free_local(struct audit_context *context)
+{ }
 static inline int audit_alloc(struct task_struct *task)
 {
 	return 0;
diff --git a/include/linux/security.h b/include/linux/security.h
index 0129400ff6e9..ddab456e93d3 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -182,6 +182,8 @@ struct lsmblob {
 #define LSMBLOB_INVALID		-1	/* Not a valid LSM slot number */
 #define LSMBLOB_NEEDED		-2	/* Slot requested on initialization */
 #define LSMBLOB_NOT_NEEDED	-3	/* Slot not requested */
+#define LSMBLOB_DISPLAY		-4	/* Use the "display" slot */
+#define LSMBLOB_FIRST		-5	/* Use the default "display" slot */
 
 /**
  * lsmblob_init - initialize an lsmblob structure
@@ -248,6 +250,15 @@ static inline u32 lsmblob_value(const struct lsmblob *blob)
 	return 0;
 }
 
+static inline bool lsm_multiple_contexts(void)
+{
+#ifdef CONFIG_SECURITY
+	return lsm_slot_to_name(1) != NULL;
+#else
+	return false;
+#endif
+}
+
 /* These functions are in security/commoncap.c */
 extern int cap_capable(const struct cred *cred, struct user_namespace *ns,
 		       int cap, unsigned int opts);
@@ -578,7 +589,8 @@ int security_setprocattr(const char *lsm, const char *name, void *value,
 			 size_t size);
 int security_netlink_send(struct sock *sk, struct sk_buff *skb);
 int security_ismaclabel(const char *name);
-int security_secid_to_secctx(struct lsmblob *blob, struct lsmcontext *cp);
+int security_secid_to_secctx(struct lsmblob *blob, struct lsmcontext *cp,
+			     int display);
 int security_secctx_to_secid(const char *secdata, u32 seclen,
 			     struct lsmblob *blob);
 void security_release_secctx(struct lsmcontext *cp);
@@ -1433,7 +1445,7 @@ static inline int security_ismaclabel(const char *name)
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
index c58a6d4eb610..f8ad20d34498 100644
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
index 841123390d41..60c027d7759c 100644
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
@@ -1110,6 +1106,7 @@ static void audit_log_feature_change(int which, u32 old_feature, u32 new_feature
 	audit_log_format(ab, " feature=%s old=%u new=%u old_lock=%u new_lock=%u res=%d",
 			 audit_feature_names[which], !!old_feature, !!new_feature,
 			 !!old_lock, !!new_lock, res);
+	audit_log_lsm(ab->ctx);
 	audit_log_end(ab);
 }
 
@@ -1190,6 +1187,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 	struct audit_buffer	*ab;
 	u16			msg_type = nlh->nlmsg_type;
 	struct audit_sig_info   *sig_data;
+	struct audit_context	*lcontext;
 
 	err = audit_netlink_ok(skb, msg_type);
 	if (err)
@@ -1357,7 +1355,8 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 				if (err)
 					break;
 			}
-			audit_log_user_recv_msg(&ab, msg_type);
+			lcontext = audit_alloc_for_lsm(GFP_KERNEL);
+			audit_log_common_recv_msg(lcontext, &ab, msg_type);
 			if (msg_type != AUDIT_USER_TTY) {
 				/* ensure NULL termination */
 				str[data_len - 1] = '\0';
@@ -1370,7 +1369,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 					data_len--;
 				audit_log_n_untrustedstring(ab, str, data_len);
 			}
-			audit_log_end(ab);
+			audit_log_end_local(ab, lcontext);
 		}
 		break;
 	case AUDIT_ADD_RULE:
@@ -1378,13 +1377,14 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		if (data_len < sizeof(struct audit_rule_data))
 			return -EINVAL;
 		if (audit_enabled == AUDIT_LOCKED) {
-			audit_log_common_recv_msg(audit_context(), &ab,
+			lcontext = audit_alloc_for_lsm(GFP_KERNEL);
+			audit_log_common_recv_msg(lcontext, &ab,
 						  AUDIT_CONFIG_CHANGE);
 			audit_log_format(ab, " op=%s audit_enabled=%d res=0",
 					 msg_type == AUDIT_ADD_RULE ?
 						"add_rule" : "remove_rule",
 					 audit_enabled);
-			audit_log_end(ab);
+			audit_log_end_local(ab, lcontext);
 			return -EPERM;
 		}
 		err = audit_rule_change(msg_type, seq, data, data_len);
@@ -1394,10 +1394,10 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		break;
 	case AUDIT_TRIM:
 		audit_trim_trees();
-		audit_log_common_recv_msg(audit_context(), &ab,
-					  AUDIT_CONFIG_CHANGE);
+		lcontext = audit_alloc_for_lsm(GFP_KERNEL);
+		audit_log_common_recv_msg(lcontext, &ab, AUDIT_CONFIG_CHANGE);
 		audit_log_format(ab, " op=trim res=1");
-		audit_log_end(ab);
+		audit_log_end_local(ab, lcontext);
 		break;
 	case AUDIT_MAKE_EQUIV: {
 		void *bufp = data;
@@ -1425,6 +1425,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		/* OK, here comes... */
 		err = audit_tag_tree(old, new);
 
+		lcontext = audit_alloc_for_lsm(GFP_KERNEL);
 		audit_log_common_recv_msg(audit_context(), &ab,
 					  AUDIT_CONFIG_CHANGE);
 		audit_log_format(ab, " op=make_equiv old=");
@@ -1432,7 +1433,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		audit_log_format(ab, " new=");
 		audit_log_untrustedstring(ab, new);
 		audit_log_format(ab, " res=%d", !err);
-		audit_log_end(ab);
+		audit_log_end_local(ab, lcontext);
 		kfree(old);
 		kfree(new);
 		break;
@@ -1443,7 +1444,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 
 		if (lsmblob_is_set(&audit_sig_lsm)) {
 			err = security_secid_to_secctx(&audit_sig_lsm,
-						       &context);
+						       &context, LSMBLOB_FIRST);
 			if (err)
 				return err;
 		}
@@ -1498,13 +1499,14 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		old.enabled = t & AUDIT_TTY_ENABLE;
 		old.log_passwd = !!(t & AUDIT_TTY_LOG_PASSWD);
 
+		lcontext = audit_alloc_for_lsm(GFP_KERNEL);
 		audit_log_common_recv_msg(audit_context(), &ab,
 					  AUDIT_CONFIG_CHANGE);
 		audit_log_format(ab, " op=tty_set old-enabled=%d new-enabled=%d"
 				 " old-log_passwd=%d new-log_passwd=%d res=%d",
 				 old.enabled, s.enabled, old.log_passwd,
 				 s.log_passwd, !err);
-		audit_log_end(ab);
+		audit_log_end_local(ab, lcontext);
 		break;
 	}
 	default:
@@ -1550,6 +1552,7 @@ static void audit_receive(struct sk_buff  *skb)
 /* Log information about who is connecting to the audit multicast socket */
 static void audit_log_multicast(int group, const char *op, int err)
 {
+	struct audit_context *context;
 	const struct cred *cred;
 	struct tty_struct *tty;
 	char comm[sizeof(current->comm)];
@@ -1558,7 +1561,8 @@ static void audit_log_multicast(int group, const char *op, int err)
 	if (!audit_enabled)
 		return;
 
-	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_EVENT_LISTENER);
+	context = audit_alloc_for_lsm(GFP_KERNEL);
+	ab = audit_log_start(context, GFP_KERNEL, AUDIT_EVENT_LISTENER);
 	if (!ab)
 		return;
 
@@ -1576,7 +1580,7 @@ static void audit_log_multicast(int group, const char *op, int err)
 	audit_log_untrustedstring(ab, get_task_comm(comm, current));
 	audit_log_d_path_exe(ab, current->mm); /* exe= */
 	audit_log_format(ab, " nl-mcgrp=%d op=%s res=%d", group, op, !err);
-	audit_log_end(ab);
+	audit_log_end_local(ab, context);
 }
 
 /* Run custom bind function on netlink socket group connect or bind requests. */
@@ -2138,7 +2142,19 @@ int audit_log_task_context(struct audit_buffer *ab)
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
@@ -2224,6 +2240,7 @@ void audit_log_task_info(struct audit_buffer *ab)
 	audit_log_untrustedstring(ab, get_task_comm(comm, current));
 	audit_log_d_path_exe(ab, current->mm);
 	audit_log_task_context(ab);
+	audit_log_lsm(ab->ctx);
 }
 EXPORT_SYMBOL(audit_log_task_info);
 
@@ -2274,6 +2291,7 @@ static void audit_log_set_loginuid(kuid_t koldloginuid, kuid_t kloginuid,
 				   unsigned int oldsessionid,
 				   unsigned int sessionid, int rc)
 {
+	struct audit_context *context;
 	struct audit_buffer *ab;
 	uid_t uid, oldloginuid, loginuid;
 	struct tty_struct *tty;
@@ -2281,7 +2299,8 @@ static void audit_log_set_loginuid(kuid_t koldloginuid, kuid_t kloginuid,
 	if (!audit_enabled)
 		return;
 
-	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_LOGIN);
+	context = audit_alloc_for_lsm(GFP_KERNEL);
+	ab = audit_log_start(context, GFP_KERNEL, AUDIT_LOGIN);
 	if (!ab)
 		return;
 
@@ -2296,7 +2315,7 @@ static void audit_log_set_loginuid(kuid_t koldloginuid, kuid_t kloginuid,
 			 oldloginuid, loginuid, tty ? tty_name(tty) : "(none)",
 			 oldsessionid, sessionid, !rc);
 	audit_put_tty(tty);
-	audit_log_end(ab);
+	audit_log_end_local(ab, context);
 }
 
 /**
@@ -2396,6 +2415,21 @@ void audit_log_end(struct audit_buffer *ab)
 	audit_buffer_free(ab);
 }
 
+/**
+ * audit_log_end_local - end one audit record with local context
+ * @ab: the audit_buffer
+ * @context: the local context
+ *
+ * Emit an LSM context record if appropriate, then end the audit event
+ * in the usual way.
+ */
+void audit_log_end_local(struct audit_buffer *ab, struct audit_context *context)
+{
+	audit_log_end(ab);
+	audit_log_lsm_common(context);
+	audit_free_local(context);
+}
+
 /**
  * audit_log - Log an audit record
  * @ctx: audit context
diff --git a/kernel/audit.h b/kernel/audit.h
index 27ef690afd30..5ad0c6819aa8 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -100,6 +100,7 @@ struct audit_context {
 	int		    dummy;	/* must be the first element */
 	int		    in_syscall;	/* 1 if task is in a syscall */
 	bool		    local;	/* local context needed */
+	bool		    lsmdone;	/* multiple security reported */
 	enum audit_state    state, current_state;
 	unsigned int	    serial;     /* serial number for record */
 	int		    major;      /* syscall number */
@@ -131,6 +132,7 @@ struct audit_context {
 	kgid_t		    gid, egid, sgid, fsgid;
 	unsigned long	    personality;
 	int		    arch;
+	struct lsmblob	    lsm;
 
 	pid_t		    target_pid;
 	kuid_t		    target_auid;
@@ -201,6 +203,7 @@ struct audit_context {
 extern bool audit_ever_enabled;
 
 extern void audit_log_session_info(struct audit_buffer *ab);
+extern void audit_log_lsm_common(struct audit_context *context);
 
 extern int auditd_test_task(struct task_struct *task);
 
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index 1ba14a7a38f7..be59ca46b0a2 100644
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
index d4e061f95da8..55509faf5341 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -940,6 +940,7 @@ static inline struct audit_context *audit_alloc_context(enum audit_state state,
 	INIT_LIST_HEAD(&context->names_list);
 	context->fds[0] = -1;
 	context->return_valid = AUDITSC_INVALID;
+	context->lsmdone = false;
 	return context;
 }
 
@@ -987,12 +988,11 @@ struct audit_context *audit_alloc_local(gfp_t gfpflags)
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
@@ -1013,6 +1013,13 @@ void audit_free_context(struct audit_context *context)
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
@@ -1030,7 +1037,7 @@ static int audit_log_pid_context(struct audit_context *context, pid_t pid,
 			 from_kuid(&init_user_ns, auid),
 			 from_kuid(&init_user_ns, uid), sessionid);
 	if (lsmblob_is_set(blob)) {
-		if (security_secid_to_secctx(blob, &lsmctx)) {
+		if (security_secid_to_secctx(blob, &lsmctx, LSMBLOB_FIRST)) {
 			audit_log_format(ab, " obj=(none)");
 			rc = 1;
 		} else {
@@ -1275,7 +1282,8 @@ static void show_special(struct audit_context *context, int *call_panic)
 			struct lsmblob blob;
 
 			lsmblob_init(&blob, osid);
-			if (security_secid_to_secctx(&blob, &lsmcxt)) {
+			if (security_secid_to_secctx(&blob, &lsmcxt,
+						     LSMBLOB_FIRST)) {
 				audit_log_format(ab, " osid=%u", osid);
 				*call_panic = 1;
 			} else {
@@ -1430,7 +1438,7 @@ static void audit_log_name(struct audit_context *context, struct audit_names *n,
 		struct lsmcontext lsmctx;
 
 		lsmblob_init(&blob, n->osid);
-		if (security_secid_to_secctx(&blob, &lsmctx)) {
+		if (security_secid_to_secctx(&blob, &lsmctx, LSMBLOB_FIRST)) {
 			audit_log_format(ab, " osid=%u", n->osid);
 			if (call_panic)
 				*call_panic = 2;
@@ -1504,6 +1512,47 @@ static void audit_log_proctitle(void)
 	audit_log_end(ab);
 }
 
+void audit_log_lsm_common(struct audit_context *context)
+{
+	struct audit_buffer *ab;
+	struct lsmcontext lsmdata;
+	bool sep = false;
+	int error;
+	int i;
+
+	if (!lsm_multiple_contexts() || context == NULL ||
+	    !lsmblob_is_set(&context->lsm))
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
+				 lsm_slot_to_name(i), lsmdata.context);
+		sep = true;
+
+		security_release_secctx(&lsmdata);
+	}
+	audit_log_end(ab);
+	context->lsmdone = true;
+}
+
+void audit_log_lsm(struct audit_context *context)
+{
+	if (!context->lsmdone)
+		audit_log_lsm_common(context);
+}
+
 static void audit_log_exit(void)
 {
 	int i, call_panic = 0;
@@ -1538,6 +1587,8 @@ static void audit_log_exit(void)
 	audit_log_key(ab, context->filterkey);
 	audit_log_end(ab);
 
+	audit_log_lsm(context);
+
 	for (aux = context->aux; aux; aux = aux->next) {
 
 		ab = audit_log_start(context, GFP_KERNEL, aux->type);
@@ -1628,6 +1679,8 @@ static void audit_log_exit(void)
 
 	audit_log_proctitle();
 
+	audit_log_lsm(context);
+
 	/* Send end of event record to help user space know we are finished */
 	ab = audit_log_start(context, GFP_KERNEL, AUDIT_EOE);
 	if (ab)
@@ -2619,10 +2672,12 @@ void __audit_ntp_log(const struct audit_ntp_data *ad)
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
@@ -2632,7 +2687,7 @@ void __audit_log_nfcfg(const char *name, u8 af, unsigned int nentries,
 	audit_log_task_context(ab); /* subj= */
 	audit_log_format(ab, " comm=");
 	audit_log_untrustedstring(ab, get_task_comm(comm, current));
-	audit_log_end(ab);
+	audit_log_end_local(ab, context);
 }
 EXPORT_SYMBOL_GPL(__audit_log_nfcfg);
 
@@ -2667,6 +2722,7 @@ static void audit_log_task(struct audit_buffer *ab)
  */
 void audit_core_dumps(long signr)
 {
+	struct audit_context *context;
 	struct audit_buffer *ab;
 
 	if (!audit_enabled)
@@ -2675,12 +2731,13 @@ void audit_core_dumps(long signr)
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
index 215d3f9e9715..60539221e023 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -344,7 +344,7 @@ static int ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
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
index df6043d1bc22..861106a5f605 100644
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
index bf8db099090b..90ecf03b35ba 100644
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
index 0ce9bee43dd3..380eeffd8e00 100644
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
@@ -1528,14 +1531,11 @@ int __init netlbl_unlabel_defconf(void)
 	int ret_val;
 	struct netlbl_dom_map *entry;
 	struct netlbl_audit audit_info;
-	struct lsmblob blob;
 
 	/* Only the kernel is allowed to call this function and the only time
 	 * it is called is at bootup before the audit subsystem is reporting
 	 * messages so don't worry to much about these values. */
-	security_task_getsecid_subj(current, &blob);
-	/* scaffolding until audit_info.secid is converted */
-	audit_info.secid = blob.secid[0];
+	security_task_getsecid_subj(current, &audit_info.lsmdata);
 	audit_info.loginuid = GLOBAL_ROOT_UID;
 	audit_info.sessionid = 0;
 
diff --git a/net/netlabel/netlabel_user.c b/net/netlabel/netlabel_user.c
index 951ba0639d20..90a18b245380 100644
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
 
@@ -98,11 +101,14 @@ struct audit_buffer *netlbl_audit_start_common(int type,
 			 from_kuid(&init_user_ns, audit_info->loginuid),
 			 audit_info->sessionid);
 
-	lsmblob_init(&blob, audit_info->secid);
-	if (audit_info->secid != 0 &&
-	    security_secid_to_secctx(&blob, &context) == 0) {
-		audit_log_format(audit_buf, " subj=%s", context.context);
-		security_release_secctx(&context);
+	if (lsmblob_is_set(&audit_info->lsmdata)) {
+		if (!lsm_multiple_contexts() &&
+		    security_secid_to_secctx(&audit_info->lsmdata, &context,
+					     LSMBLOB_FIRST) == 0) {
+			audit_log_format(audit_buf, " subj=%s",
+					 context.context);
+			security_release_secctx(&context);
+		}
 	}
 
 	return audit_buf;
diff --git a/net/netlabel/netlabel_user.h b/net/netlabel/netlabel_user.h
index 11f6da93f31b..bc1f0cd824d5 100644
--- a/net/netlabel/netlabel_user.h
+++ b/net/netlabel/netlabel_user.h
@@ -34,11 +34,7 @@
 static inline void netlbl_netlink_auditinfo(struct sk_buff *skb,
 					    struct netlbl_audit *audit_info)
 {
-	struct lsmblob blob;
-
-	security_task_getsecid_subj(current, &blob);
-	/* scaffolding until secid is converted */
-	audit_info->secid = blob.secid[0];
+	security_task_getsecid_subj(current, &audit_info->lsmdata);
 	audit_info->loginuid = audit_get_loginuid(current);
 	audit_info->sessionid = audit_get_sessionid(current);
 }
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index ce500f847b99..a4d554214d4b 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -4173,30 +4173,32 @@ static void xfrm_audit_common_policyinfo(struct xfrm_policy *xp,
 
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
index 4496f7efa220..a1fd0e122be8 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2747,29 +2747,31 @@ static void xfrm_audit_helper_pktinfo(struct sk_buff *skb, u16 family,
 
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
 
@@ -2779,7 +2781,7 @@ void xfrm_audit_state_replay_overflow(struct xfrm_state *x,
 	struct audit_buffer *audit_buf;
 	u32 spi;
 
-	audit_buf = xfrm_audit_start("SA-replay-overflow");
+	audit_buf = xfrm_audit_start("SA-replay-overflow", NULL);
 	if (audit_buf == NULL)
 		return;
 	xfrm_audit_helper_pktinfo(skb, x->props.family, audit_buf);
@@ -2797,7 +2799,7 @@ void xfrm_audit_state_replay(struct xfrm_state *x,
 	struct audit_buffer *audit_buf;
 	u32 spi;
 
-	audit_buf = xfrm_audit_start("SA-replayed-pkt");
+	audit_buf = xfrm_audit_start("SA-replayed-pkt", NULL);
 	if (audit_buf == NULL)
 		return;
 	xfrm_audit_helper_pktinfo(skb, x->props.family, audit_buf);
@@ -2812,7 +2814,7 @@ void xfrm_audit_state_notfound_simple(struct sk_buff *skb, u16 family)
 {
 	struct audit_buffer *audit_buf;
 
-	audit_buf = xfrm_audit_start("SA-notfound");
+	audit_buf = xfrm_audit_start("SA-notfound", NULL);
 	if (audit_buf == NULL)
 		return;
 	xfrm_audit_helper_pktinfo(skb, family, audit_buf);
@@ -2826,7 +2828,7 @@ void xfrm_audit_state_notfound(struct sk_buff *skb, u16 family,
 	struct audit_buffer *audit_buf;
 	u32 spi;
 
-	audit_buf = xfrm_audit_start("SA-notfound");
+	audit_buf = xfrm_audit_start("SA-notfound", NULL);
 	if (audit_buf == NULL)
 		return;
 	xfrm_audit_helper_pktinfo(skb, family, audit_buf);
@@ -2844,7 +2846,7 @@ void xfrm_audit_state_icvfail(struct xfrm_state *x,
 	__be32 net_spi;
 	__be32 net_seq;
 
-	audit_buf = xfrm_audit_start("SA-icv-failure");
+	audit_buf = xfrm_audit_start("SA-icv-failure", NULL);
 	if (audit_buf == NULL)
 		return;
 	xfrm_audit_helper_pktinfo(skb, x->props.family, audit_buf);
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 691f68d478f1..8e7c660b9b01 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -342,6 +342,7 @@ void ima_store_measurement(struct integrity_iint_cache *iint,
 void ima_audit_measurement(struct integrity_iint_cache *iint,
 			   const unsigned char *filename)
 {
+	struct audit_context *context;
 	struct audit_buffer *ab;
 	char *hash;
 	const char *algo_name = hash_algo_name[iint->ima_hash->algo];
@@ -358,8 +359,8 @@ void ima_audit_measurement(struct integrity_iint_cache *iint,
 		hex_byte_pack(hash + (i * 2), iint->ima_hash->digest[i]);
 	hash[i * 2] = '\0';
 
-	ab = audit_log_start(audit_context(), GFP_KERNEL,
-			     AUDIT_INTEGRITY_RULE);
+	context = audit_alloc_for_lsm(GFP_KERNEL);
+	ab = audit_log_start(context, GFP_KERNEL, AUDIT_INTEGRITY_RULE);
 	if (!ab)
 		goto out;
 
@@ -368,7 +369,7 @@ void ima_audit_measurement(struct integrity_iint_cache *iint,
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
index d1e9a54e22b4..bb4c7f6c62ec 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2307,7 +2307,7 @@ int security_setprocattr(const char *lsm, const char *name, void *value,
 		hlist_for_each_entry(hp, &security_hook_heads.setprocattr,
 				     list) {
 			rc = hp->hook.setprocattr(name, value, size);
-			if (rc < 0)
+			if (rc < 0 && rc != -EINVAL)
 				return rc;
 		}
 
@@ -2352,13 +2352,31 @@ int security_ismaclabel(const char *name)
 }
 EXPORT_SYMBOL(security_ismaclabel);
 
-int security_secid_to_secctx(struct lsmblob *blob, struct lsmcontext *cp)
+int security_secid_to_secctx(struct lsmblob *blob, struct lsmcontext *cp,
+			     int ilsm)
 {
 	struct security_hook_list *hp;
-	int ilsm = lsm_task_ilsm(current);
 
 	memset(cp, 0, sizeof(*cp));
 
+	/*
+	 * ilsm either is the slot number use for formatting
+	 * or an instruction on which relative slot to use.
+	 */
+	if (ilsm == LSMBLOB_DISPLAY)
+		ilsm = lsm_task_ilsm(current);
+	else if (ilsm == LSMBLOB_FIRST)
+		ilsm = LSMBLOB_INVALID;
+	else if (ilsm < 0) {
+		WARN_ONCE(true,
+			"LSM: %s unknown interface LSM\n", __func__);
+		ilsm = LSMBLOB_INVALID;
+	} else if (ilsm >= lsm_slot) {
+		WARN_ONCE(true,
+			"LSM: %s invalid interface LSM\n", __func__);
+		ilsm = LSMBLOB_INVALID;
+	}
+
 	hlist_for_each_entry(hp, &security_hook_heads.secid_to_secctx, list) {
 		if (WARN_ON(hp->lsmid->slot < 0 || hp->lsmid->slot >= lsm_slot))
 			continue;
@@ -2388,7 +2406,7 @@ int security_secctx_to_secid(const char *secdata, u32 seclen,
 			return hp->hook.secctx_to_secid(secdata, seclen,
 						&blob->secid[hp->lsmid->slot]);
 	}
-	return 0;
+	return -EOPNOTSUPP;
 }
 EXPORT_SYMBOL(security_secctx_to_secid);
 
@@ -2882,23 +2900,17 @@ int security_key_getsecurity(struct key *key, char **_buffer)
 int security_audit_rule_init(u32 field, u32 op, char *rulestr, void **lsmrule)
 {
 	struct security_hook_list *hp;
-	bool one_is_good = false;
-	int rc = 0;
-	int trc;
+	int ilsm = lsm_task_ilsm(current);
 
 	hlist_for_each_entry(hp, &security_hook_heads.audit_rule_init, list) {
 		if (WARN_ON(hp->lsmid->slot < 0 || hp->lsmid->slot >= lsm_slot))
 			continue;
-		trc = hp->hook.audit_rule_init(field, op, rulestr,
-					       &lsmrule[hp->lsmid->slot]);
-		if (trc == 0)
-			one_is_good = true;
-		else
-			rc = trc;
+		if (ilsm != LSMBLOB_INVALID && ilsm != hp->lsmid->slot)
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
@@ -2930,6 +2942,8 @@ int security_audit_rule_match(struct lsmblob *blob, u32 field, u32 op,
 			continue;
 		if (lsmrule[hp->lsmid->slot] == NULL)
 			continue;
+		if (lsmrule[hp->lsmid->slot] == NULL)
+			continue;
 		rc = hp->hook.audit_rule_match(blob->secid[hp->lsmid->slot],
 					       field, op,
 					       &lsmrule[hp->lsmid->slot]);
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index e592e10397af..d56e55c04aa4 100644
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
2.29.2

