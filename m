Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE163D1B52
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 03:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbhGVAbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 20:31:55 -0400
Received: from sonic313-16.consmr.mail.ne1.yahoo.com ([66.163.185.39]:42430
        "EHLO sonic313-16.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229990AbhGVAby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 20:31:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1626916350; bh=totCkXXbljmk28mBeylIMSCxhVoY9uHDY9U5Hm/rKj4=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=Zfy0igP/osRQ+9fCASF0aUweqKZbaFR3CzlkiWapYi/xcVB+aHj5T0ljGxhRGnaaiOgYfakXDrirCdPU9+OHTIAoDfsh6neOZUQ2EqQ3DobVUlqDF1Mea6k3sKXYS3cTyGKAJDIrTATOdbDLP0O2xQj7Gaq3AF1tqMhQP5t/tiCgsUXFRWfj8YJ6Yr7m2TKaERzz920GTBxVm7SygPb+5gGxC+O7KU3Vf/CGFqmkqTDfMSrRC0o3mpuo5TWlozTExaNz2TS3UhbUlRi5wyo8nnWwdySXjWid09PBeVZdKFoFZhjD7SLjCogNqSYrMVunLlN5Jp76qIPfmvDa/easxQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1626916350; bh=hTmWFSKphDYRj4jX15ygCHDKyum+OCLAdFRJD52nMhM=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=P8JeNKAv8fEcW5r+qa+nAXnLT2jT2bE43NCkDD6VlbzoTqRN9SpvB62Ai7uvhfjalZ9D60Y9427TekEkcGQnkVT4hr0Ts44dszYEIibc8OHGQebKY2hsOD2XIF9/xaHFeYo4F3Fb36kJ2/G5ShObz9/eAkpVicITPn064zTEnG9AlfJhzAXZzCuhUsmUFCUyQtatAYE1GzUGqwDccJvyrsndh+m9Vi/s6G36tGoLTDcnDAGotUKkmlGV0z+fRdAXhoMqGw3uPGl/39GefGeDrXTN1XqPfpxGG5KxUd2DvbG+wXmnjCozdKMiLwylkkcZ21icz2XdVzUEzQQpWYZPuQ==
X-YMail-OSG: 7izSpxUVM1mOtEyUE2qHUm3vO6Kzz2kjNZdoUNMTBRvh8Ec_Z2vVSJMzRsuOQaN
 j6r1fWcCQlTELM55MpPi9NX9DAR6borMXLPuaUm5EGOeIwyHo.7weTyqpAhEzmZARyZEecly7vp7
 KJrr9j25KBLjhQpfmau_cXkvum3n0Yfb_nwzSVdHeNGL8YiBykIpOe7jvqvqS.j9Dn1L_NezhY5O
 C3s_.zxn3i5pspBgX0DOg6ERpECWGUTtEjGagpO7qOg9.djjm9hyTWGTKwFPTLirKiWNtlRqSAww
 BtmYQGJFWNNjZ_EK6gyT5ksK5L04og13dSECckKsAUg.5Hctei_ZgZ.S23UCNI.PNrRgnLiFxOfU
 egWhLX4XmjdIBBNzwztLxI6fCawayE4UOW9i2oEpqWiagfRPTrzQpz6rMJcbzknxr8brenR_WEr5
 zut69LpKNbGqwp9tEyvXP4QNDOnAh4kTPtq7.ImU2l6rZnTOXCJFq1T02yCd.jo5pKX0sAdceAbU
 Uny_MzxkGLkhhlS7A1_b5a5.J01ZcUSsA2k_Hx2g.ijFt7Pb1BJK3Vqqjf4ztFIU7ajZNkjVeOvK
 nN6NnpUrTjvNyVtOd_L9pass3XEocvRsSUh3ugZaQY7TSRCWMqxhwTHPTKm9_ZIO6sd.YxA_h3o8
 QF9F.M5dR6V5E0r4_biR_G6.S8YIpEMtUHbUjQ8_mG22UJwrOh4apsqSvOuW3SdGlGZi3q._BDAj
 va87NCv.GbDiM9bHWlj2XjcHDjdhedIK7NyUIpEGtV6rZzN6BwvINtdcAwXluo8Qbs8stH9opvOs
 LsdXeWIJh8LCal4xL_Q.OVSeimel6D99M6lVWX5.yvFh9KWh3AhxIcbucgQpEYYZJIDIUcCefaoY
 3KFXZ.LBPzKQISrlTZBrFrEwdzADi9dd.k6DZgT4JNW9pLlwY3E1mGYB.QuHXgQsHBHd.cF6Zuc7
 SrgnYN.914BbJ3Bm9k53EfYztGnKjy1qMyYIYcfzA95NPBSm7q.i1B2XU1s7CImx8Eup2kW1jx_t
 l8.GRe983zZKboxsoJvzD.R1FZYJqbEkYjebx5JvIqEtUM6e217t6859Lsg8uex7029t6J700sif
 rsNsCLwQza0ckCkiQgPD1ylo.6khWwH.lW4UDl0sKWgv_GBw_G2KVrROvfUBmjfcmxFpgbWpZNF8
 ogHGx0u29foFCfH11sCrWiWcvimR7l5t1PBqpdW3ey541TIKGFEtsPj7EGWYKZHis.PKAHxvKJ_m
 rpDDg0SDSNi7ad0iXBf8BpUH_8cMPI1Z2IWWZY2OGoT8UmRmdkSjWdK6c7q0tIfhAN2JcgRZ0MxV
 OpqG0ZXuRJbOY4bwycBSdFUnZ1YzAH6C7bZFt5AZV6IEW6bSSBbjxvMmpJc0qje3EazX9W1FbvnP
 K42UvpH.pWSZnOm5_STcgNZ2ZtF4zc3SUihl9GOQFjU8cV1lyAUv4EzZQxSYifreuiFHDFPAqKvM
 V7bg1xx5atOcS1zbxzEtMnvWq2ON18pFZto9ptrdyJHLDKl3AyieyoC6jKOZ5oGKAO7Py6TBx2.T
 byoYoFeWiYBT98zKMBOJ_.win.rJuTgM3oydOQJNUk_myNiAd7k37stattWj1f9EQQpFWW7rtiuU
 TN.MD4WC_xOkJL1B6ymbMS6G4.7pT0lhHb4iWBwGoJ.zjewheJ14QJkZiq3azZ7D1ovRyfEInEln
 PtBRux7WpcoBmU1oW8oxOKEeYzeJzGRIZr5izpH0_ajCvGL.mbftulsUT0QR.R1QjrJwpRQ4xvDb
 akQSDrN1AkqlQWiwJMNlmxS14KQCeHEqUUPyFiwgZY.GokqBJ8B6Gju49O6H_nvqknwYXxi.YaV2
 W9FoMhS9Mfi5tKQM2hyNnGl5r711E14Mw7xt83U060C0nk8CGQN8dxSLTquoYJldWOGTu2ZewZ4v
 bM9UrGJ.oZOt5Fk7_xlHQu7uznB4rZ.uObQg67MUZ_xyP8JBe.6VrVOcx._oDGMgteruLoPmfIqA
 rHp.NgNIiVO5Er6IEtNJP07OQT_9BKw8gmSP5FR8lUk6T6kQt54_G2ocr70XbQ87kD58a2YgpgSP
 zmkbING3.04KIFxRvVDRdoocPQl2YxFf4SSGN5DQvdCWlxodE72VdneHUQ_pkXoPvdwamp2Qz2Yq
 SwSmCBZ2hDe86QEwBn4sEKXnM3uUa2sPCnYTjVDegUs7BaBiZ5NNJXe9_7pWFMfjUmm4TLtzCVYc
 cbER3ekH9mg7XoOt8yzaG7myYb1XFJOG3R4Fgl9pp8PjYZQtkpD4OQsHC05H3xu6ljoQC2TO5vXw
 xTR0df_YSeZ8pbHNSOalB2FvVKSuNuWduO_7Ncb8rOyjK6dHwJ36fKAL8xktT2.JEmI4y_FMaZS1
 _6Bp7KPpV9YLVbHVhHHC4AbN6o1S49yhiMGqbCsO6CxEM9CPr5g57K3FLhL0cX.HzrJ1NExhqKH1
 n.O4O498Cf.GW2p6jb9tveDxGyzM9So9XGyGEryO1IJDdyKjNuckPxrtQ.3PHbFbwWWjD_YwJlJz
 SPS5TdgA3QZb2SOaB1eig5bRZpxN9Uv62MXpt_T1sKhZ.du2r2z7uI5AbqzHNSdy9TILVKi_fVjP
 NWQiryx2EQnPdo0Ag3PahR8SyqT3EDUWnm6WvEdoYxogkUepogl48.hFr3vOxAiu4AxMWg8kda2m
 pGrgTaPu00G861pdIuwAWGmRyLlLgu..msb61gxwfnMUHwvxvzgbm.RlatoZeSC32rmnbWRnw00E
 ZGhez_KulT4tiaiDL5wKRutuNcl3zL8TDN5IA3vK.GIF3j1p.EiyFCH2nE.vc5MIEfGsqWhwpjUO
 SUy86QZ7goxqTXMIqaz6nMt0BKtktthGlLM9p5JFREsVDPEz6qQuvMMdBONgUexM1Oasg01N588a
 db.42zE_VIwy.HA73Xkc_MPSMn7_reltyRHB44PiNcNATyuuL_eI8zgeq3fVLK79exE1sbCl2MkL
 _C3KYh1mjbuvAwZzZwNGOQAsFcn3ISEgJ_HRbAzV7tidbVR94SceG7zy.foG2KQRSZ8quF..wcGi
 xBmM8mHvp_hUkmciu70K_Na8KRRRbS9rnlW2AWMw8TAnAxSsjsuE2EDH2VBtX.HNZNcsT7aQzmvI
 7..J2PoiuojT_E4DY8w4bN5.Nx4W6S3Mle4ngrBSvBYFDw756pLbb3YR0zApYpT4sPK3MxwY3tfv
 V13DEhZyEnCufm8xLQiYvs7kN2_4fcgw-
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.ne1.yahoo.com with HTTP; Thu, 22 Jul 2021 01:12:30 +0000
Received: by kubenode523.mail-prod1.omega.bf1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 1d522cf2f444aeac678d47f4ddf51e15;
          Thu, 22 Jul 2021 01:12:28 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v28 22/25] Audit: Add record for multiple process LSM attributes
Date:   Wed, 21 Jul 2021 17:47:55 -0700
Message-Id: <20210722004758.12371-23-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210722004758.12371-1-casey@schaufler-ca.com>
References: <20210722004758.12371-1-casey@schaufler-ca.com>
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
        subj_apparmor="=unconfined"
        subj_smack="_"

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
index 2c3a2348a144..3520caa0260c 100644
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
index 3e9743118fb9..b3cf68cf2bd6 100644
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
index cbff7c2a9724..a10fa01f7bf4 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -660,13 +660,22 @@ struct xfrm_spi_skb_cb {
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
index daa481729e9b..4432a8bed8e0 100644
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
index 841123390d41..cba63789a164 100644
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
+		audit_log_format(ab, "%ssubj_%s=\"%s\"", sep ? " " : "",
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
index 0e58a3ab56f5..01fdcbf468c0 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -993,12 +993,11 @@ struct audit_context *audit_alloc_local(gfp_t gfpflags)
 	context = audit_alloc_context(AUDIT_STATE_BUILD, gfpflags);
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
@@ -1019,6 +1018,13 @@ void audit_free_context(struct audit_context *context)
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
@@ -1036,7 +1042,7 @@ static int audit_log_pid_context(struct audit_context *context, pid_t pid,
 			 from_kuid(&init_user_ns, auid),
 			 from_kuid(&init_user_ns, uid), sessionid);
 	if (lsmblob_is_set(blob)) {
-		if (security_secid_to_secctx(blob, &lsmctx)) {
+		if (security_secid_to_secctx(blob, &lsmctx, LSMBLOB_FIRST)) {
 			audit_log_format(ab, " obj=(none)");
 			rc = 1;
 		} else {
@@ -1282,7 +1288,8 @@ static void show_special(struct audit_context *context, int *call_panic)
 			struct lsmblob blob;
 
 			lsmblob_init(&blob, osid);
-			if (security_secid_to_secctx(&blob, &lsmcxt)) {
+			if (security_secid_to_secctx(&blob, &lsmcxt,
+						     LSMBLOB_FIRST)) {
 				audit_log_format(ab, " osid=%u", osid);
 				*call_panic = 1;
 			} else {
@@ -1439,7 +1446,7 @@ static void audit_log_name(struct audit_context *context, struct audit_names *n,
 		struct lsmcontext lsmctx;
 
 		lsmblob_init(&blob, n->osid);
-		if (security_secid_to_secctx(&blob, &lsmctx)) {
+		if (security_secid_to_secctx(&blob, &lsmctx, LSMBLOB_FIRST)) {
 			audit_log_format(ab, " osid=%u", n->osid);
 			if (call_panic)
 				*call_panic = 2;
@@ -2637,10 +2644,12 @@ void __audit_ntp_log(const struct audit_ntp_data *ad)
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
@@ -2651,6 +2660,7 @@ void __audit_log_nfcfg(const char *name, u8 af, unsigned int nentries,
 	audit_log_format(ab, " comm=");
 	audit_log_untrustedstring(ab, get_task_comm(comm, current));
 	audit_log_end(ab);
+	audit_free_local(context);
 }
 EXPORT_SYMBOL_GPL(__audit_log_nfcfg);
 
@@ -2685,6 +2695,7 @@ static void audit_log_task(struct audit_buffer *ab)
  */
 void audit_core_dumps(long signr)
 {
+	struct audit_context *context;
 	struct audit_buffer *ab;
 
 	if (!audit_enabled)
@@ -2693,12 +2704,14 @@ void audit_core_dumps(long signr)
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
index 668b31ecd638..05bdbb942499 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -347,7 +347,7 @@ static int ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
 	 * security_secid_to_secctx() will know which security module
 	 * to use to create the secctx.  */
 	lsmblob_init(&blob, ct->secmark);
-	ret = security_secid_to_secctx(&blob, &context);
+	ret = security_secid_to_secctx(&blob, &context, LSMBLOB_DISPLAY);
 	if (ret)
 		return 0;
 
@@ -658,7 +658,7 @@ static inline int ctnetlink_secctx_size(const struct nf_conn *ct)
 	struct lsmblob blob;
 	struct lsmcontext context;
 
-	ret = security_secid_to_secctx(&blob, &context);
+	ret = security_secid_to_secctx(&blob, &context, LSMBLOB_DISPLAY);
 	if (ret)
 		return 0;
 
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index b5796a8e5e90..3da3770e9739 100644
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
index cffb04baf7b8..9bef0bddf7d6 100644
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
index 289602835b75..245f63f5773a 100644
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
index aa31f7bf79ee..e5b15ad41df7 100644
--- a/net/netlabel/netlabel_user.h
+++ b/net/netlabel/netlabel_user.h
@@ -32,11 +32,7 @@
  */
 static inline void netlbl_netlink_auditinfo(struct netlbl_audit *audit_info)
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
index 827d84255021..2152e319951d 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -4178,30 +4178,34 @@ static void xfrm_audit_common_policyinfo(struct xfrm_policy *xp,
 
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
index a2f4001221d1..4d174f42eb60 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2796,29 +2796,33 @@ static void xfrm_audit_helper_pktinfo(struct sk_buff *skb, u16 family,
 
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
 
@@ -2828,7 +2832,7 @@ void xfrm_audit_state_replay_overflow(struct xfrm_state *x,
 	struct audit_buffer *audit_buf;
 	u32 spi;
 
-	audit_buf = xfrm_audit_start("SA-replay-overflow");
+	audit_buf = xfrm_audit_start("SA-replay-overflow", NULL);
 	if (audit_buf == NULL)
 		return;
 	xfrm_audit_helper_pktinfo(skb, x->props.family, audit_buf);
@@ -2846,7 +2850,7 @@ void xfrm_audit_state_replay(struct xfrm_state *x,
 	struct audit_buffer *audit_buf;
 	u32 spi;
 
-	audit_buf = xfrm_audit_start("SA-replayed-pkt");
+	audit_buf = xfrm_audit_start("SA-replayed-pkt", NULL);
 	if (audit_buf == NULL)
 		return;
 	xfrm_audit_helper_pktinfo(skb, x->props.family, audit_buf);
@@ -2861,7 +2865,7 @@ void xfrm_audit_state_notfound_simple(struct sk_buff *skb, u16 family)
 {
 	struct audit_buffer *audit_buf;
 
-	audit_buf = xfrm_audit_start("SA-notfound");
+	audit_buf = xfrm_audit_start("SA-notfound", NULL);
 	if (audit_buf == NULL)
 		return;
 	xfrm_audit_helper_pktinfo(skb, family, audit_buf);
@@ -2875,7 +2879,7 @@ void xfrm_audit_state_notfound(struct sk_buff *skb, u16 family,
 	struct audit_buffer *audit_buf;
 	u32 spi;
 
-	audit_buf = xfrm_audit_start("SA-notfound");
+	audit_buf = xfrm_audit_start("SA-notfound", NULL);
 	if (audit_buf == NULL)
 		return;
 	xfrm_audit_helper_pktinfo(skb, family, audit_buf);
@@ -2893,7 +2897,7 @@ void xfrm_audit_state_icvfail(struct xfrm_state *x,
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
index cb359e185d1a..5d7fd982f84a 100644
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
index 9cda52f2ec31..2f0f412fc403 100644
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
2.31.1

