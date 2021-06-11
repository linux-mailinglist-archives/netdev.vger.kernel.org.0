Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D94223A38BD
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 02:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbhFKAbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 20:31:04 -0400
Received: from sonic311-31.consmr.mail.ne1.yahoo.com ([66.163.188.212]:36271
        "EHLO sonic311-31.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231315AbhFKAbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 20:31:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1623371346; bh=STIbxkicnE7xrqxJMIgYjDC4jP2LqKZLYR2SQhbHGU8=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=G3lNbl/V/c/DE08gd4+ufZ4jA0P5DVLp1YTcaedks6u7/JEZcyx3ss7NcU+CdITOWxeH3bZ25Nt6qv8uDZ+HfU7eYC9BR3mwX+enWg47ucb8/BjWX4xG0Xuy7bW+rVBQW79oFIJTemvtgU82tsSKOgXq6Yl1VjCYOHIj6czr3fide3ITEMERG3mK/YHY2sBMH4xWFTGO3A05hHFBmPi9T4iesfUN9KvNWTFMkQ5XZBtJb0bTOBT1jmZjSm9SL2yPIjt4Os4sB2k4YvS7avHEKJmH1+ThkfMFKmj31+3/zDh0lzSLHpQm37mMWEgy6DxPvkvowQseGqShdEwwV0/wcg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1623371346; bh=LL3DzLjQ1BYcbO6M7k18DteVsjRBF3KwOQMKe5jdkEK=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=Muhv7G/CXMILQA2PFgotMtkj+mEk8qMsOCU6/1fR6RNqpp+sov0juQweLsSiJWJSC4UwmT/bmeTbXdX7+Lya/9K6++CKqc8eOcXCBCqDqfIsh4TpibyoB6y67KHpPqWDEgc+mrGHuOo/qT8T0iW9UHIHfmF8bSPy+i8FkV+h3rI+AivD42faCbibtqMZhSoazxDycSdVP16qY0A7zLdNjSybiX8btiYJzp5SGdZAmQwrKTO6yAnptIzj8esUpOxoU5jFOFsPuDH7b4iv26uQzOi5ExKl/0fKjOaij8g7jxcU4psNND5idd6dJsNX+bBOgExFG+n59+jVUWYXbBbuMw==
X-YMail-OSG: 03RhpfUVM1nKhjuFOgbR8b_CoMdFEmnqi7TYy7ma7VeAsAvEDK95KCVGgCkkjkE
 9gZQoewDDBs5nBDTplxHpJZGsbqLCBf173LA79h5LviBn.gAw5CwGHubh2AcrYIkK8Ryj_AeqEAX
 WdQWkgflUCKVR6vL5KT1CTtdprKY6jeZzGSCFvZgutQ0ly6curApKJRDU_iuPz8Fi7IfFG8bUSSB
 GzRCxaaprtz9k9KLxoE9ddtyTMGcKPBmDp60DLsXn4kXEpvFSvxHe7iZzl82jJqidfg7F0EDg5oC
 8aPAelMQ31bRDfyw34D6I3SLz.luwYlTGDi4Do3WgQteVR8oGIDrT.DcSAFMBI.q.VmurDfNWvlb
 I3XagYmrP1fFhjqD7JdRu6JGYv1_3gzGx.CSCIr.urXz0KsQkRnYDMMVYvrxAOOsRs5etn78BxEf
 k5ig6rAPAFScjSxITRIdkMRdSq5IfMzx9ZWiqq03Jlp0HTT_QaPo924q6lQwPo9v0fJkouryaAHw
 lRSTXqKsnI9a852NVFCpnZIv6ckhLay4bE8f34cyjVdQ21Q3V1RVHrDX087s4gI0erq_xOVGYNeX
 j6qBG2XmRPJH_PGFB.ZLqTHk7GecdvzY90aQIl7aJABjKiVE2jtXYFMGW1guyqAa03d3aqscGrsa
 9GT3FIAgJIMF9DP3k1lKJPWkC3QaeN_qf8DAselF63yRAg5m5rtMLlYhKitUaknLpqSSPpCttGFd
 Dd3YCCFkJOqPn8N5wHIGQqzCS7CwZl8xoXbJo.fctxohBhkS2qgeCSKN9sLrhcg5Hlen0ZHoKnKF
 mBK.2gnSj5JtSAQZFzUNQeQ39h2fWJkHgWMphos3zUzQ5aWfktt8n6PDcRjUjg0NqGT.7LR1Uiqz
 CnzATvcJ2Qvvyt8MCLNwm3T7xfZzh5DMQlrPs46tZm_lyTHPxuWVBVNMTEInlC5RRoJ8msNOrCyH
 LNbMPWBvxK8AeuxRwolsWOQ_kjGYyQD12kXQuzuX5pbyhsaX9t3K9aToR71A0F1Gd.xSUZkpcqOF
 3_LA.x380hk9uKYLopsy1K_XP_BtxFGDoZKlxLph2LBTJTROUBoMOmcawGthVrgVDJ0nzQf74Vrh
 fMGHYkwtQpKVIM7BGhd_44.4BpylQ0KS8H8uCj1u0h7dGjZpj1Y3sSRnKferdh9aJO0YB6wC9uKk
 jC3Cy3uTi5njBgPZXaSJngSGrCrGDklwTV_93.xKQDd9lzkW_pce__MoL7cdvlJbo859BfjmiMCj
 9ftUPLN2iRm2qMgG94y7HhzyZFgg9sRSGjgNVsriIEW.yEW5T.vw2n6rHc6nRezEkmd6F0iplCt7
 py.oJfLJvOQRGi.qL.S_bb9NsdMkKUpl1exUVt3QzVlZnaz20zkUciHqy3Xbk19IJ.fsz_GdEEi0
 eb2KgwMBuntzsotcvd1HScZdg3RLZer6_vxIi1aFCWgKCwIZB7QxMbsHKWIAmnwkAjn7nae.AxEy
 UUOFBdujcln6WAs6KJQGBp4l.sW54ESNjesgn9mzDihUWMUJMEEPc2C5nPQ3Q549xzz0j6.meHEe
 NbyWcdwaEM3eH.opmGm0uULW7MDeFyd.D2uIKk68phQzr9so4oPgFxW1AE4WEcDE84.BEaZJ5K9d
 ZM6TBtdP73UKM5NuWZYz3i4Zj3xRmz_oYqBJgi7XywmqWR4m4KpqL7Wd8E46ydrjtw184NDLgJll
 dU4s22lUXkdJehhxjU3cy_aTG4Oos0W6SIMIewDJ3h0jrL5gf3G.LQChOa87iSzAQkZcpVKJfG1F
 UlKxGW_sN_NAF.iLAOCuOEgBoIMmK16RAUFy9AT9Hv2nz2raTOlwuOpQ.bcox_vgR07y4.S4m.B7
 nBuvn1OjxLo3CXt2HmCxk9P3R4lRuuWdWMU72.HuVUtJCjzxAzyV1f6h9RE6kV2ihB_vRJUE.knQ
 0P5nIoGZJ9DoVizHKRQBoC.c6yKBPI9CNLq2RjuvrcKgcja0kIgZy0ZbpjCGnIwlCFrXfLEWgCVJ
 TwTq8dWc3I1E10gAHf7CTqmUBllNA6HmJ9n96VpqGcUKYip0R0KquKhm_PxaBPv7G9OsXU4T9Np6
 9ZZV_ln4DjyC3OM4i87JM3wDl3JT2GtZQT9XM22__P2jEf31V6mGogZMwljMxWAjAo3G8QHC.n_x
 a5h3QF4QY0dzEb17VgluaOSaaqSW5C2EySphWNkDZrS56U_ZXr8.yTRUnDHPc40mkmTxYq7uPUnM
 tkDIcsVNVQZzn4pQ.cG84mu4AR6Vu0XOEphrfvyWtfSKv6d0Pr.lig9RaCccGAIZAtPL.p9JE.3t
 v1U2.Z0z8kYwone7mZ5HfUGp7pyAtlWmyS9fZrodS69hz0fK5pCrBjpCdF8f4HYBV3GrOfi6k3S2
 k4zfDQj7qCTqQru1IfqnKJvRWnLj6tpHOQr_qWLgcrktwG5tzHepuSYBDncss2MQRCRyBy9O89Gd
 h4aZkhLh6.GEErOTrguJhSROvGmp.mpHq7B4tGD0D7McShSG8Z5Z9yrU8sI7YP8axBs1UnYMrZwd
 pKFX0GKmp0TwapeLCJ08VzUpWEfnrItk2YNWgF13Hv9X0Mds0dwFauUaVxh3AliIgxeCKBynSGAk
 3_0DCcK81TAQQ.HEydJVCS5gkYTb7.qS4Io_VKV60njpvEuV2Fi98qYj_jY2c8wRBXu0__1YxLJk
 3p4cPQD6dHpGdqdnIBrajzOk0SOFjDo1oP6NGrpEYqbJjOLvtN1dgOJs_BtSWId48rwaN5Bp6vdV
 bDdqrVgNWvaHkLmbE5_N2RoUrrBIb9w0tTvnOspwFsVmzDyXQEzhLgM6FZqYDNfesVRCxmcr_HXs
 Z3TDxNVmrBJBptGYZmSPX6eH13RaoSUiHbT9EuM54Kqoku7YsHm0HoWkukC66TzJZpQi.WEX7u45
 G2yPA1dil4339lfTEpppEUFhPjnMdEQ4Iox1YjoYpvPxwdcFt7eha9zmo2H2DTtayErBA3dGwJXx
 4yLCEQQPwhWSXDcdMxByO0Y1RK3GOZAu_lLVCKxhNiUISO.ABDSPhl.NVpx6f69I93kVv8V7p4I7
 Ithtrja8fCz4MXe6qZeYU0xfjQBJLXLS9j.QYC97NZWqUu3h0bJPaanZUEJsfmgnnhzHq9YLxF35
 UkqrecIw8.SGweek_taP4bPNdgEj9DJd5adsmui5bi7eK4cWIQTDVog--
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic311.consmr.mail.ne1.yahoo.com with HTTP; Fri, 11 Jun 2021 00:29:06 +0000
Received: by kubenode541.mail-prod1.omega.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID d56ccfb1d1290dfeb1ea823a34bab5ff;
          Fri, 11 Jun 2021 00:29:05 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v27 22/25] Audit: Add record for multiple process LSM attributes
Date:   Thu, 10 Jun 2021 17:04:32 -0700
Message-Id: <20210611000435.36398-23-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210611000435.36398-1-casey@schaufler-ca.com>
References: <20210611000435.36398-1-casey@schaufler-ca.com>
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
 include/linux/audit.h                   | 16 +++++
 include/linux/security.h                | 16 ++++-
 include/net/netlabel.h                  |  2 +-
 include/net/scm.h                       |  2 +-
 include/net/xfrm.h                      | 13 +++-
 include/uapi/linux/audit.h              |  1 +
 kernel/audit.c                          | 90 +++++++++++++++++++------
 kernel/auditfilter.c                    |  5 +-
 kernel/auditsc.c                        | 27 ++++++--
 net/ipv4/ip_sockglue.c                  |  2 +-
 net/netfilter/nf_conntrack_netlink.c    |  4 +-
 net/netfilter/nf_conntrack_standalone.c |  2 +-
 net/netfilter/nfnetlink_queue.c         |  2 +-
 net/netlabel/netlabel_unlabeled.c       | 21 +++---
 net/netlabel/netlabel_user.c            | 14 ++--
 net/netlabel/netlabel_user.h            |  6 +-
 net/xfrm/xfrm_policy.c                  |  8 ++-
 net/xfrm/xfrm_state.c                   | 18 +++--
 security/integrity/ima/ima_api.c        |  6 +-
 security/integrity/integrity_audit.c    |  5 +-
 security/security.c                     | 46 ++++++++-----
 security/smack/smackfs.c                |  3 +-
 23 files changed, 221 insertions(+), 90 deletions(-)

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
index 97cd7471e572..85eb87f6f92d 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -291,6 +291,7 @@ extern int  audit_alloc(struct task_struct *task);
 extern void __audit_free(struct task_struct *task);
 extern struct audit_context *audit_alloc_local(gfp_t gfpflags);
 extern void audit_free_context(struct audit_context *context);
+extern void audit_free_local(struct audit_context *context);
 extern void __audit_syscall_entry(int major, unsigned long a0, unsigned long a1,
 				  unsigned long a2, unsigned long a3);
 extern void __audit_syscall_exit(int ret_success, long ret_value);
@@ -386,6 +387,19 @@ static inline void audit_ptrace(struct task_struct *t)
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
@@ -560,6 +574,8 @@ extern int audit_signals;
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
index 73fc25b4042b..216cb1ffc8f0 100644
--- a/include/net/netlabel.h
+++ b/include/net/netlabel.h
@@ -97,7 +97,7 @@ struct calipso_doi;
 
 /* NetLabel audit information */
 struct netlbl_audit {
-	u32 secid;
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
index 841123390d41..36249dab3280 100644
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
@@ -399,6 +401,7 @@ static int audit_log_config_change(char *function_name, u32 new, u32 old,
 		allow_changes = 0; /* Something weird, deny request */
 	audit_log_format(ab, " res=%d", allow_changes);
 	audit_log_end(ab);
+	audit_free_local(context);
 	return rc;
 }
 
@@ -1072,12 +1075,6 @@ static void audit_log_common_recv_msg(struct audit_context *context,
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
@@ -1371,6 +1370,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 				audit_log_n_untrustedstring(ab, str, data_len);
 			}
 			audit_log_end(ab);
+			audit_free_local(lcontext);
 		}
 		break;
 	case AUDIT_ADD_RULE:
@@ -1378,13 +1378,15 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
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
 			audit_log_end(ab);
+			audit_free_local(lcontext);
 			return -EPERM;
 		}
 		err = audit_rule_change(msg_type, seq, data, data_len);
@@ -1394,10 +1396,11 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		break;
 	case AUDIT_TRIM:
 		audit_trim_trees();
-		audit_log_common_recv_msg(audit_context(), &ab,
-					  AUDIT_CONFIG_CHANGE);
+		lcontext = audit_alloc_for_lsm(GFP_KERNEL);
+		audit_log_common_recv_msg(lcontext, &ab, AUDIT_CONFIG_CHANGE);
 		audit_log_format(ab, " op=trim res=1");
 		audit_log_end(ab);
+		audit_free_local(lcontext);
 		break;
 	case AUDIT_MAKE_EQUIV: {
 		void *bufp = data;
@@ -1425,14 +1428,15 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		/* OK, here comes... */
 		err = audit_tag_tree(old, new);
 
-		audit_log_common_recv_msg(audit_context(), &ab,
-					  AUDIT_CONFIG_CHANGE);
+		lcontext = audit_alloc_for_lsm(GFP_KERNEL);
+		audit_log_common_recv_msg(lcontext, &ab, AUDIT_CONFIG_CHANGE);
 		audit_log_format(ab, " op=make_equiv old=");
 		audit_log_untrustedstring(ab, old);
 		audit_log_format(ab, " new=");
 		audit_log_untrustedstring(ab, new);
 		audit_log_format(ab, " res=%d", !err);
 		audit_log_end(ab);
+		audit_free_local(lcontext);
 		kfree(old);
 		kfree(new);
 		break;
@@ -1443,7 +1447,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 
 		if (lsmblob_is_set(&audit_sig_lsm)) {
 			err = security_secid_to_secctx(&audit_sig_lsm,
-						       &context);
+						       &context, LSMBLOB_FIRST);
 			if (err)
 				return err;
 		}
@@ -1498,13 +1502,14 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		old.enabled = t & AUDIT_TTY_ENABLE;
 		old.log_passwd = !!(t & AUDIT_TTY_LOG_PASSWD);
 
-		audit_log_common_recv_msg(audit_context(), &ab,
-					  AUDIT_CONFIG_CHANGE);
+		lcontext = audit_alloc_for_lsm(GFP_KERNEL);
+		audit_log_common_recv_msg(lcontext, &ab, AUDIT_CONFIG_CHANGE);
 		audit_log_format(ab, " op=tty_set old-enabled=%d new-enabled=%d"
 				 " old-log_passwd=%d new-log_passwd=%d res=%d",
 				 old.enabled, s.enabled, old.log_passwd,
 				 s.log_passwd, !err);
 		audit_log_end(ab);
+		audit_free_local(lcontext);
 		break;
 	}
 	default:
@@ -1550,6 +1555,7 @@ static void audit_receive(struct sk_buff  *skb)
 /* Log information about who is connecting to the audit multicast socket */
 static void audit_log_multicast(int group, const char *op, int err)
 {
+	struct audit_context *context;
 	const struct cred *cred;
 	struct tty_struct *tty;
 	char comm[sizeof(current->comm)];
@@ -1558,7 +1564,8 @@ static void audit_log_multicast(int group, const char *op, int err)
 	if (!audit_enabled)
 		return;
 
-	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_EVENT_LISTENER);
+	context = audit_alloc_for_lsm(GFP_KERNEL);
+	ab = audit_log_start(context, GFP_KERNEL, AUDIT_EVENT_LISTENER);
 	if (!ab)
 		return;
 
@@ -1577,6 +1584,7 @@ static void audit_log_multicast(int group, const char *op, int err)
 	audit_log_d_path_exe(ab, current->mm); /* exe= */
 	audit_log_format(ab, " nl-mcgrp=%d op=%s res=%d", group, op, !err);
 	audit_log_end(ab);
+	audit_free_local(context);
 }
 
 /* Run custom bind function on netlink socket group connect or bind requests. */
@@ -2128,6 +2136,36 @@ void audit_log_key(struct audit_buffer *ab, char *key)
 		audit_log_format(ab, "(null)");
 }
 
+static void audit_log_lsm(struct audit_context *context, struct lsmblob *blob)
+{
+	struct audit_buffer *ab;
+	struct lsmcontext lsmdata;
+	bool sep = false;
+	int error;
+	int i;
+
+	ab = audit_log_start(context, GFP_ATOMIC, AUDIT_MAC_TASK_CONTEXTS);
+	if (!ab)
+		return; /* audit_panic or being filtered */
+
+	for (i = 0; i < LSMBLOB_ENTRIES; i++) {
+		if (blob->secid[i] == 0)
+			continue;
+		error = security_secid_to_secctx(blob, &lsmdata, i);
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
+}
+
 int audit_log_task_context(struct audit_buffer *ab)
 {
 	int error;
@@ -2138,7 +2176,18 @@ int audit_log_task_context(struct audit_buffer *ab)
 	if (!lsmblob_is_set(&blob))
 		return 0;
 
-	error = security_secid_to_secctx(&blob, &context);
+	/*
+	 * If there is more than one security module that has a
+	 * subject "context" it's necessary to put the subject data
+	 * into a separate record to maintain compatibility.
+	 */
+	if (lsm_multiple_contexts()) {
+		audit_log_format(ab, " subj=?");
+		audit_log_lsm(ab->ctx, &blob);
+		return 0;
+	}
+
+	error = security_secid_to_secctx(&blob, &context, LSMBLOB_FIRST);
 	if (error) {
 		if (error != -EINVAL)
 			goto error_path;
@@ -2274,6 +2323,7 @@ static void audit_log_set_loginuid(kuid_t koldloginuid, kuid_t kloginuid,
 				   unsigned int oldsessionid,
 				   unsigned int sessionid, int rc)
 {
+	struct audit_context *context;
 	struct audit_buffer *ab;
 	uid_t uid, oldloginuid, loginuid;
 	struct tty_struct *tty;
@@ -2281,7 +2331,8 @@ static void audit_log_set_loginuid(kuid_t koldloginuid, kuid_t kloginuid,
 	if (!audit_enabled)
 		return;
 
-	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_LOGIN);
+	context = audit_alloc_for_lsm(GFP_KERNEL);
+	ab = audit_log_start(context, GFP_KERNEL, AUDIT_LOGIN);
 	if (!ab)
 		return;
 
@@ -2297,6 +2348,7 @@ static void audit_log_set_loginuid(kuid_t koldloginuid, kuid_t kloginuid,
 			 oldsessionid, sessionid, !rc);
 	audit_put_tty(tty);
 	audit_log_end(ab);
+	audit_free_local(context);
 }
 
 /**
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index 1ba14a7a38f7..fd71c6bac200 100644
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
@@ -1112,6 +1114,7 @@ static void audit_log_rule_change(char *action, struct audit_krule *rule, int re
 	audit_log_key(ab, rule->filterkey);
 	audit_log_format(ab, " list=%d res=%d", rule->listnr, res);
 	audit_log_end(ab);
+	audit_free_local(context);
 }
 
 /**
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index d4e061f95da8..c3e3749328aa 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -987,12 +987,11 @@ struct audit_context *audit_alloc_local(gfp_t gfpflags)
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
@@ -1013,6 +1012,13 @@ void audit_free_context(struct audit_context *context)
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
@@ -1030,7 +1036,7 @@ static int audit_log_pid_context(struct audit_context *context, pid_t pid,
 			 from_kuid(&init_user_ns, auid),
 			 from_kuid(&init_user_ns, uid), sessionid);
 	if (lsmblob_is_set(blob)) {
-		if (security_secid_to_secctx(blob, &lsmctx)) {
+		if (security_secid_to_secctx(blob, &lsmctx, LSMBLOB_FIRST)) {
 			audit_log_format(ab, " obj=(none)");
 			rc = 1;
 		} else {
@@ -1275,7 +1281,8 @@ static void show_special(struct audit_context *context, int *call_panic)
 			struct lsmblob blob;
 
 			lsmblob_init(&blob, osid);
-			if (security_secid_to_secctx(&blob, &lsmcxt)) {
+			if (security_secid_to_secctx(&blob, &lsmcxt,
+						     LSMBLOB_FIRST)) {
 				audit_log_format(ab, " osid=%u", osid);
 				*call_panic = 1;
 			} else {
@@ -1430,7 +1437,7 @@ static void audit_log_name(struct audit_context *context, struct audit_names *n,
 		struct lsmcontext lsmctx;
 
 		lsmblob_init(&blob, n->osid);
-		if (security_secid_to_secctx(&blob, &lsmctx)) {
+		if (security_secid_to_secctx(&blob, &lsmctx, LSMBLOB_FIRST)) {
 			audit_log_format(ab, " osid=%u", n->osid);
 			if (call_panic)
 				*call_panic = 2;
@@ -2619,10 +2626,12 @@ void __audit_ntp_log(const struct audit_ntp_data *ad)
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
@@ -2633,6 +2642,7 @@ void __audit_log_nfcfg(const char *name, u8 af, unsigned int nentries,
 	audit_log_format(ab, " comm=");
 	audit_log_untrustedstring(ab, get_task_comm(comm, current));
 	audit_log_end(ab);
+	audit_free_local(context);
 }
 EXPORT_SYMBOL_GPL(__audit_log_nfcfg);
 
@@ -2667,6 +2677,7 @@ static void audit_log_task(struct audit_buffer *ab)
  */
 void audit_core_dumps(long signr)
 {
+	struct audit_context *context;
 	struct audit_buffer *ab;
 
 	if (!audit_enabled)
@@ -2675,12 +2686,14 @@ void audit_core_dumps(long signr)
 	if (signr == SIGQUIT)	/* don't care for those */
 		return;
 
-	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_ANOM_ABEND);
+	context = audit_alloc_for_lsm(GFP_KERNEL);
+	ab = audit_log_start(context, GFP_KERNEL, AUDIT_ANOM_ABEND);
 	if (unlikely(!ab))
 		return;
 	audit_log_task(ab);
 	audit_log_format(ab, " sig=%ld res=1", signr);
 	audit_log_end(ab);
+	audit_free_local(context);
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
diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index 0ce9bee43dd3..061b0c04740b 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -437,7 +437,8 @@ int netlbl_unlhsh_add(struct net *net,
 unlhsh_add_return:
 	rcu_read_unlock();
 	if (audit_buf != NULL) {
-		if (security_secid_to_secctx(lsmblob, &context) == 0) {
+		if (security_secid_to_secctx(lsmblob, &context,
+					     LSMBLOB_FIRST) == 0) {
 			audit_log_format(audit_buf, " sec_obj=%s",
 					 context.context);
 			security_release_secctx(&context);
@@ -492,7 +493,8 @@ static int netlbl_unlhsh_remove_addr4(struct net *net,
 		if (dev != NULL)
 			dev_put(dev);
 		if (entry != NULL &&
-		    security_secid_to_secctx(&entry->lsmblob, &context) == 0) {
+		    security_secid_to_secctx(&entry->lsmblob, &context,
+					     LSMBLOB_FIRST) == 0) {
 			audit_log_format(audit_buf, " sec_obj=%s",
 					 context.context);
 			security_release_secctx(&context);
@@ -552,7 +554,8 @@ static int netlbl_unlhsh_remove_addr6(struct net *net,
 		if (dev != NULL)
 			dev_put(dev);
 		if (entry != NULL &&
-		    security_secid_to_secctx(&entry->lsmblob, &context) == 0) {
+		    security_secid_to_secctx(&entry->lsmblob, &context,
+					     LSMBLOB_FIRST) == 0) {
 			audit_log_format(audit_buf, " sec_obj=%s",
 					 context.context);
 			security_release_secctx(&context);
@@ -738,11 +741,10 @@ static void netlbl_unlabel_acceptflg_set(u8 value,
 	netlabel_unlabel_acceptflg = value;
 	audit_buf = netlbl_audit_start_common(AUDIT_MAC_UNLBL_ALLOW,
 					      audit_info);
-	if (audit_buf != NULL) {
+	if (audit_buf != NULL)
 		audit_log_format(audit_buf,
 				 " unlbl_accept=%u old=%u", value, old_val);
-		audit_log_end(audit_buf);
-	}
+	audit_log_end(audit_buf);
 }
 
 /**
@@ -1122,7 +1124,7 @@ static int netlbl_unlabel_staticlist_gen(u32 cmd,
 		lsmb = (struct lsmblob *)&addr6->lsmblob;
 	}
 
-	ret_val = security_secid_to_secctx(lsmb, &context);
+	ret_val = security_secid_to_secctx(lsmb, &context, LSMBLOB_FIRST);
 	if (ret_val != 0)
 		goto list_cb_failure;
 	ret_val = nla_put(cb_arg->skb,
@@ -1528,14 +1530,11 @@ int __init netlbl_unlabel_defconf(void)
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
index 951ba0639d20..9c43c3cb2088 100644
--- a/net/netlabel/netlabel_user.c
+++ b/net/netlabel/netlabel_user.c
@@ -85,7 +85,6 @@ struct audit_buffer *netlbl_audit_start_common(int type,
 {
 	struct audit_buffer *audit_buf;
 	struct lsmcontext context;
-	struct lsmblob blob;
 
 	if (audit_enabled == AUDIT_OFF)
 		return NULL;
@@ -98,11 +97,14 @@ struct audit_buffer *netlbl_audit_start_common(int type,
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
index ce500f847b99..18a0a7be7230 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -4173,30 +4173,34 @@ static void xfrm_audit_common_policyinfo(struct xfrm_policy *xp,
 
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
 	audit_log_end(audit_buf);
+	audit_free_local(context);
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
 	audit_log_end(audit_buf);
+	audit_free_local(context);
 }
 EXPORT_SYMBOL_GPL(xfrm_audit_policy_delete);
 #endif
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 4496f7efa220..a2ba060af6f1 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2747,29 +2747,33 @@ static void xfrm_audit_helper_pktinfo(struct sk_buff *skb, u16 family,
 
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
 	audit_log_end(audit_buf);
+	audit_free_local(context);
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
 	audit_log_end(audit_buf);
+	audit_free_local(context);
 }
 EXPORT_SYMBOL_GPL(xfrm_audit_state_delete);
 
@@ -2779,7 +2783,7 @@ void xfrm_audit_state_replay_overflow(struct xfrm_state *x,
 	struct audit_buffer *audit_buf;
 	u32 spi;
 
-	audit_buf = xfrm_audit_start("SA-replay-overflow");
+	audit_buf = xfrm_audit_start("SA-replay-overflow", NULL);
 	if (audit_buf == NULL)
 		return;
 	xfrm_audit_helper_pktinfo(skb, x->props.family, audit_buf);
@@ -2797,7 +2801,7 @@ void xfrm_audit_state_replay(struct xfrm_state *x,
 	struct audit_buffer *audit_buf;
 	u32 spi;
 
-	audit_buf = xfrm_audit_start("SA-replayed-pkt");
+	audit_buf = xfrm_audit_start("SA-replayed-pkt", NULL);
 	if (audit_buf == NULL)
 		return;
 	xfrm_audit_helper_pktinfo(skb, x->props.family, audit_buf);
@@ -2812,7 +2816,7 @@ void xfrm_audit_state_notfound_simple(struct sk_buff *skb, u16 family)
 {
 	struct audit_buffer *audit_buf;
 
-	audit_buf = xfrm_audit_start("SA-notfound");
+	audit_buf = xfrm_audit_start("SA-notfound", NULL);
 	if (audit_buf == NULL)
 		return;
 	xfrm_audit_helper_pktinfo(skb, family, audit_buf);
@@ -2826,7 +2830,7 @@ void xfrm_audit_state_notfound(struct sk_buff *skb, u16 family,
 	struct audit_buffer *audit_buf;
 	u32 spi;
 
-	audit_buf = xfrm_audit_start("SA-notfound");
+	audit_buf = xfrm_audit_start("SA-notfound", NULL);
 	if (audit_buf == NULL)
 		return;
 	xfrm_audit_helper_pktinfo(skb, family, audit_buf);
@@ -2844,7 +2848,7 @@ void xfrm_audit_state_icvfail(struct xfrm_state *x,
 	__be32 net_spi;
 	__be32 net_seq;
 
-	audit_buf = xfrm_audit_start("SA-icv-failure");
+	audit_buf = xfrm_audit_start("SA-icv-failure", NULL);
 	if (audit_buf == NULL)
 		return;
 	xfrm_audit_helper_pktinfo(skb, x->props.family, audit_buf);
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 691f68d478f1..3481990a25a6 100644
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
 
@@ -369,6 +370,7 @@ void ima_audit_measurement(struct integrity_iint_cache *iint,
 
 	audit_log_task_info(ab);
 	audit_log_end(ab);
+	audit_free_local(context);
 
 	iint->flags |= IMA_AUDITED;
 out:
diff --git a/security/integrity/integrity_audit.c b/security/integrity/integrity_audit.c
index 29220056207f..c3b313886e15 100644
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
@@ -64,4 +66,5 @@ void integrity_audit_message(int audit_msgno, struct inode *inode,
 	}
 	audit_log_format(ab, " res=%d errno=%d", !result, errno);
 	audit_log_end(ab);
+	audit_free_local(context);
 }
diff --git a/security/security.c b/security/security.c
index ae23b5a8fe87..81baa94092f4 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2309,7 +2309,7 @@ int security_setprocattr(const char *lsm, const char *name, void *value,
 		hlist_for_each_entry(hp, &security_hook_heads.setprocattr,
 				     list) {
 			rc = hp->hook.setprocattr(name, value, size);
-			if (rc < 0)
+			if (rc < 0 && rc != -EINVAL)
 				return rc;
 		}
 
@@ -2354,13 +2354,31 @@ int security_ismaclabel(const char *name)
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
@@ -2390,7 +2408,7 @@ int security_secctx_to_secid(const char *secdata, u32 seclen,
 			return hp->hook.secctx_to_secid(secdata, seclen,
 						&blob->secid[hp->lsmid->slot]);
 	}
-	return 0;
+	return -EOPNOTSUPP;
 }
 EXPORT_SYMBOL(security_secctx_to_secid);
 
@@ -2884,23 +2902,17 @@ int security_key_getsecurity(struct key *key, char **_buffer)
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
@@ -2932,6 +2944,8 @@ int security_audit_rule_match(struct lsmblob *blob, u32 field, u32 op,
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

