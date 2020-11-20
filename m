Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6332E2BB69B
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 21:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730624AbgKTUV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 15:21:58 -0500
Received: from sonic302-28.consmr.mail.ne1.yahoo.com ([66.163.186.154]:39257
        "EHLO sonic302-28.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730591AbgKTUV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 15:21:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1605903713; bh=9KYvMBO0f3QJAkGUkYTSB7tT/AsRWsETYIOQ/jkgV7A=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject; b=RIUMXi0jtNWgALJlhitgaJOz+UmuyQu2YNN5dM3GmBS6DTCMHMYCMPpTXO6Nar2FhaJoUXGvYGh5N+1+JNKWaaSbc+RhL4X1uP3RpUFa3lY1ApCjI0LIeYrPeM4bNM0NYK2V04Xo0V+F0KooHpYomNjdPwKHOfqxkoKaTBbmIo5kuBCOHBO0UbOgI2wnJ06Xyu5NPoIfHFwOf77f+7Q7Gr4VZVJwPtvIBWaUfcADEaRZgj78s3Pz/TUItvLic1+ITt+j91R0iLZvj7+jouh8Yzx6hD1qfFu8bBh03ym6CESwaIHCNLxaUJA4p72d3kyhTHsaUm0p/aiIgj6FRKuAAA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1605903713; bh=lFg+SIWAaOvQAbVmA8auJ1GwibrjS679QpVZg5eTeiZ=; h=From:To:Subject:Date:From:Subject; b=lr6mFlbCIxQWgbHcsybwyC0EpgSvJbn7jhLEDI1LyiXK9SGP8RsbKv0mxWQXPO5+oLHmba472cT9oLroHoK76guBqtWYuvukDwf0gydR1aXnffpA9BbMFbzAhzbnFvFn9NLr7VH9kUJVI70F7plOWGZnmD8F5sdBYJ9x0KEa62zjqXdLG0wcFZV6U+oBmeYifdCHT2CnPVA7dKiO5eXQDXUZsSUOZVIxka7wMFKtZx1o7kSP7sOF1RIOJzzuObX1KvS5cUifCNb3Bwb8PMxL8xVP4ZnlsgUA99QAldkiDyBGK+Z+xOGfe9jXHMc5XQrym1cP0LMXwKr817S3losjog==
X-YMail-OSG: EadB0l0VM1muBY1RoRD_5Q8zv.8hRIGh_kn51W4eyeNTn20Ro3K4GixmeP3squO
 eet90UoRVnmwG3VElsa0D8j_Qzt5cWIeldHv9Aa9xlfVdkmuzs8ExOyI1i8FN6KiFdsNBicoVHkv
 Mg3h8Tza7qTUCAkHz6K6fZehYhA_03JGRgwj2lmQzOr9CWxgPHZbrJqSdXv94L.QhUgLdvRa.LIo
 T57m6fna3LyfKGkfE9FpNUsyeKFNIEH_hCZSydm5dyPIRojGJHvud5F4OEqb699TRqcwWYAK83gZ
 Gm3b7EE4qkBifm6bKHFw2uUvGCNDnk2J44kZQp.z4AjPRdn0T1L4tbwGLIw9ZPsugmbpwHUl0CZW
 n1J1oxkfz5NDGq6fA9fDRlu8P39fC.FX_ju._F4VbZuw5UNJpOhHtGOPzx0By3l2rANgDkvWHL9V
 UaSZsAsSfmrZy5ng6Gecxy.D_lxKAvcmylG40UlncyvsenVwBfSRBv2_H7ZavqHPKwzVeYisRatK
 ZQrOGG_n.9FLDfDKvrJzX94U6m0qSQb1zTHvjt4Qw4bXmPJALsLA6d24KOYxB0fFQ1gPGxTV_KZy
 pFyj2ZXsxd9ltFvOBu4G374FHg.ELSmpWHev0SGgAZASlZgNCI3RDZooxQbsglb08C0wRAf56gd9
 XYmpMRoNb2tzdFuv0Wy7iW9yjmR6H29l9p_oaFbxoeGA_7Hqc_SfPgaSs8uJ_jukwcVTq0PUbuLo
 Lgfc5lyVVm5.utgudJ7uZqiFRcnGnoB864FD2X3tXcsR6ne4insyEj21x5mSZMIxy6dP0YSrY7oN
 RWQ9UUNmeTsatOU8YKLPH.mBHmtUtLXzhewHqEti5fFGGnr19SS_JS9nj_wkxBkGoEdje9VPpV3q
 mTBXPPL2CAbH9VJEFCsn4p5essuieUDl8It8KNlRjDL44YkN4MuXN02Dy0lvQMPPy5FJvE9awbeF
 K9UISZe.vGJFUM4Ru2.9kPZBntLlewfHnuZBm8k0pcEcsYVdUlL3qDE2X_VHbtn2XQzmDtZJFVH.
 TnxQdPseKE9FZGb9Eg1shBuLE3oha3ECXRBHcUeMfCXcTSGhCibthVxu9SzqEvxjwrqzvHqbQu5q
 9pOg8Pe9sfjAeLztQl3fJF30kEzW1mciPcO1dQ9quXfxgddosCai4ctxQSqzQy0ZWJroS36iN2qY
 ZeIEoVYkZvgMzmbKfhmrWjb1hBf0EJS0s4N1C5FpN910.Uj2fO69br95_K6KtdnyGpsPiaMmiUTQ
 s_t5NuYnCaSRBNRF2VR6i4C2kG2BT.9VUaZEuYI_smZ8G6d2OyxP6.Ev8RFhyp6AF8TWZDLSHnGB
 pzfPeqSglIuoW_clthpOvCXJIVVwnh.MfbQ39yZiUWj6F1qiWad6dh8LJ.4wLIHwk8FzTN48MsOv
 Tt_6BBefRpuspfSZasvFAE0jvp2fR6QvVVbigO66aLXfTEFj_hJODte4cKPLg3G9i_QBt1vbUhNx
 CnQOqpGpDXO5r5gK_r1YgQjZcClccxoJwu6gKRQcNWSB_YqgRM22SXAUIa4uuCRUEGLGn55J2AGJ
 UvudaJTGHsNoXsEePcyxJqrYI2ox8.96Z8V5CfjFWZqtqFX5XOnM9FsGvEMArQNC0T7wyFS4vWuc
 d.pWTjcM2sQ33hgSLfYQrkIutim_R1bpQmDumtosXguJTpvgh_GwsZuim8GyHvT39syLqFGZF.mL
 NjfRsKX9BJzyjJwASGOwi3FQf.N_xUuOdgCIsTWmqlSoIh.j_pVV6CaaWAMODfh4DQKuZZgQuEUv
 hNhLqsdF6JylzMo9eUV3bRvvWAFD_FYAyi9a4i8rlSHxUdUzs_54bHd9Ec6h5XPDBLma2QHGIad2
 laq7UzH.rxZd1fqGaLWj6mUBbugAw9n81hUj2P46zTki95CocWqKCKlD93TgrtjCaEyVUE1bqUVz
 XA_wjzBg1WqFG3A6C16UPSVvUEeKWfHvH_bgU9G02oS4kW6Nc2qyplo8qWaqIYsG0zXTTjyu2h8t
 vExfv4TA_6keahl9cRb5u5v.KUKU6zsaCV6LsP8Ho4jGXeD79RPh0xztPPVaF2_ofRT_9b6G7DAi
 M6R9gu1b0GiToWj_qKPK3a9Z7yH42iiEFtr_nrIpXdpHxhBWU5XmqQo3ZL69XTWx9H2Fk0MLFTw1
 rt0.EBvp2sQG7jdqtR7fs1zGZEZMVVts5r0ZMCadiMsZGOMSy3x_y_QaXXV2HX32w3r3y1JSHFjc
 WTw15_fvEudfUUseWudrZS9vxkLTqDTTXCPsh2EgaBbf.L2BWnO9xPYYjtnr.GofyA0lS5sElKpj
 vMR3PiCwHF0xVCybxcDDfpi79TdzQKUbqFaHzZzfFzLq_Wm5f6d10IR8a_97B_gI8rIfKewZfx4N
 cUN6SkJSPkWSm0Y3_1sWTKQBh1HwGemNP7FUileJACLFTmMjZqlU5hmUmgtf_ig89rPGMFDnLsKm
 fC3APdjwQFOHQylU4q.2RXoo3ve3UYoWDKE7I1rGg1yvvbROUSo601xiv9ofvmiA9pQDcfwqC8qh
 oyHP94DeSRMnDLbgXVYwJjWh62Lg9Vk3aj_nrm3gcjsUXC4MZTQXCfHtt6FITRoqgdB9Z4W4YR1p
 PN2xQ1tBwj7ApqwKc0vR0rDlDkhOOD8pRjXtm8x5lCqCcYOrbJApGwe5PITPXQ2zFIiWW8YQH3Iy
 xbb84h0bOPkmhmg0g.Yzm6bAciMzwiptCyL9sh9y.06VAzFrZzcRNgywC66mt_aVKBg4uNZLw2w_
 K.I8tZiz3aBCymdDJMxIq480tOer0FLwYjyqfBbrDxQ7jMA0Ilv29Yt8z4nfUsrC_1WOjmM634mP
 _A1gH4YC78ZNIY1LeKqWQibn.7dQJ1CxCZ3_wSQOcuq25kOYgPcbuRUBYTAIy9oXEg.0aFNsIIa8
 o5ZdDLoDjSxvrq3Q0sl5YyPg9zaatYHyRsSUSg93ODikYlDJ5iaepYKgf74_jpEW8nuG6kMFKDEr
 qc.kh8ahj9sqcUn5d4LTBBq1QcTmxhQ6tZE3AoqaVVJXraOq08C7aCvR7fIt3FiDImA77qEVuJe6
 snnJ6Zyfgy8_gSJTgVWwcaEFGKdNVQMtLWJGCfOOaw0Qm05Rk53E01yCslaead54YbR93WwKAKwt
 1SzxSiLwr71EvcGAuXeb_.jo4Q17PKiYwU4PYq2WSi0WUFRVNfD5Izcej24l1VX6y8T8E7xisAk0
 7PdIPrZUIYQz5PVd5qeY0jr25qAWTmMuzBrPdJTCYmnHFw5Jzm5psmrG4QZMpyuylb1WGfTu7WS2
 L6SAbg20V20pEPMGQH9a0254UdGc.jmjn966Bex5PCjqb.xhuCuGvmwyA3Acscqj56b.3aeDOzTV
 ESm6kpsWvbO1aGxpEFGbOxwY_tImikvnmGpd7rno4TsXyKrFpQRXrZUVOLQD0nLQ9j0.4jTyDYcf
 O0opq5TegelOH2ACvY_5tNOS8sgKJb4i3pNmXiwFbdRAeOh3Q8qOO8PfFiXlZgVnOUioU7Q--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic302.consmr.mail.ne1.yahoo.com with HTTP; Fri, 20 Nov 2020 20:21:53 +0000
Received: by smtp422.mail.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 3798a4b2d2c9f40636660acc6adcaf57;
          Fri, 20 Nov 2020 20:21:52 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH v23 06/23] LSM: Use lsmblob in security_secid_to_secctx
Date:   Fri, 20 Nov 2020 12:14:50 -0800
Message-Id: <20201120201507.11993-7-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201120201507.11993-1-casey@schaufler-ca.com>
References: <20201120201507.11993-1-casey@schaufler-ca.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change security_secid_to_secctx() to take a lsmblob as input
instead of a u32 secid. It will then call the LSM hooks
using the lsmblob element allocated for that module. The
callers have been updated as well. This allows for the
possibility that more than one module may be called upon
to translate a secid to a string, as can occur in the
audit code.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Cc: netdev@vger.kernel.org
Cc: linux-audit@redhat.com
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
To: Paul Moore <paul@paul-moore.com>
---
 drivers/android/binder.c                | 12 +++++++++-
 include/linux/security.h                |  5 +++--
 include/net/scm.h                       |  7 +++++-
 kernel/audit.c                          | 20 +++++++++++++++--
 kernel/auditsc.c                        | 28 +++++++++++++++++++----
 net/ipv4/ip_sockglue.c                  |  4 +++-
 net/netfilter/nf_conntrack_netlink.c    | 14 ++++++++++--
 net/netfilter/nf_conntrack_standalone.c |  4 +++-
 net/netfilter/nfnetlink_queue.c         | 11 +++++++--
 net/netlabel/netlabel_unlabeled.c       | 30 +++++++++++++++++++++----
 net/netlabel/netlabel_user.c            |  6 ++---
 security/security.c                     | 11 +++++----
 12 files changed, 123 insertions(+), 29 deletions(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index b5117576792b..55f3fa073c7b 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -3088,10 +3088,20 @@ static void binder_transaction(struct binder_proc *proc,
 
 	if (target_node && target_node->txn_security_ctx) {
 		u32 secid;
+		struct lsmblob blob;
 		size_t added_size;
 
 		security_task_getsecid(proc->tsk, &secid);
-		ret = security_secid_to_secctx(secid, &secctx, &secctx_sz);
+		/*
+		 * Later in this patch set security_task_getsecid() will
+		 * provide a lsmblob instead of a secid. lsmblob_init
+		 * is used to ensure that all the secids in the lsmblob
+		 * get the value returned from security_task_getsecid(),
+		 * which means that the one expected by
+		 * security_secid_to_secctx() will be set.
+		 */
+		lsmblob_init(&blob, secid);
+		ret = security_secid_to_secctx(&blob, &secctx, &secctx_sz);
 		if (ret) {
 			return_error = BR_FAILED_REPLY;
 			return_error_param = ret;
diff --git a/include/linux/security.h b/include/linux/security.h
index 0766725a6b21..fad361bf320e 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -528,7 +528,7 @@ int security_setprocattr(const char *lsm, const char *name, void *value,
 			 size_t size);
 int security_netlink_send(struct sock *sk, struct sk_buff *skb);
 int security_ismaclabel(const char *name);
-int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen);
+int security_secid_to_secctx(struct lsmblob *blob, char **secdata, u32 *seclen);
 int security_secctx_to_secid(const char *secdata, u32 seclen,
 			     struct lsmblob *blob);
 void security_release_secctx(char *secdata, u32 seclen);
@@ -1350,7 +1350,8 @@ static inline int security_ismaclabel(const char *name)
 	return 0;
 }
 
-static inline int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
+static inline int security_secid_to_secctx(struct lsmblob *blob,
+					   char **secdata, u32 *seclen)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/include/net/scm.h b/include/net/scm.h
index 1ce365f4c256..23a35ff1b3f2 100644
--- a/include/net/scm.h
+++ b/include/net/scm.h
@@ -92,12 +92,17 @@ static __inline__ int scm_send(struct socket *sock, struct msghdr *msg,
 #ifdef CONFIG_SECURITY_NETWORK
 static inline void scm_passec(struct socket *sock, struct msghdr *msg, struct scm_cookie *scm)
 {
+	struct lsmblob lb;
 	char *secdata;
 	u32 seclen;
 	int err;
 
 	if (test_bit(SOCK_PASSSEC, &sock->flags)) {
-		err = security_secid_to_secctx(scm->secid, &secdata, &seclen);
+		/* There can only be one security module using the secid,
+		 * and the infrastructure will know which it is.
+		 */
+		lsmblob_init(&lb, scm->secid);
+		err = security_secid_to_secctx(&lb, &secdata, &seclen);
 
 		if (!err) {
 			put_cmsg(msg, SOL_SOCKET, SCM_SECURITY, seclen, secdata);
diff --git a/kernel/audit.c b/kernel/audit.c
index 68cee3bc8cfe..4cd6339e513d 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1442,7 +1442,16 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 	case AUDIT_SIGNAL_INFO:
 		len = 0;
 		if (audit_sig_sid) {
-			err = security_secid_to_secctx(audit_sig_sid, &ctx, &len);
+			struct lsmblob blob;
+
+			/*
+			 * lsmblob_init sets all values in the lsmblob
+			 * to audit_sig_sid. This is temporary until
+			 * audit_sig_sid is converted to a lsmblob, which
+			 * happens later in this patch set.
+			 */
+			lsmblob_init(&blob, audit_sig_sid);
+			err = security_secid_to_secctx(&blob, &ctx, &len);
 			if (err)
 				return err;
 		}
@@ -2128,12 +2137,19 @@ int audit_log_task_context(struct audit_buffer *ab)
 	unsigned len;
 	int error;
 	u32 sid;
+	struct lsmblob blob;
 
 	security_task_getsecid(current, &sid);
 	if (!sid)
 		return 0;
 
-	error = security_secid_to_secctx(sid, &ctx, &len);
+	/*
+	 * lsmblob_init sets all values in the lsmblob to sid.
+	 * This is temporary until security_task_getsecid is converted
+	 * to use a lsmblob, which happens later in this patch set.
+	 */
+	lsmblob_init(&blob, sid);
+	error = security_secid_to_secctx(&blob, &ctx, &len);
 	if (error) {
 		if (error != -EINVAL)
 			goto error_path;
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 7dd6b815a9eb..5f9bdd62f78d 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -673,6 +673,13 @@ static int audit_filter_rules(struct task_struct *tsk,
 					security_task_getsecid(tsk, &sid);
 					need_sid = 0;
 				}
+				/*
+				 * lsmblob_init sets all values in the lsmblob
+				 * to sid. This is temporary until
+				 * security_task_getsecid() is converted to
+				 * provide a lsmblob, which happens later in
+				 * this patch set.
+				 */
 				lsmblob_init(&blob, sid);
 				result = security_audit_rule_match(&blob,
 								   f->type,
@@ -690,6 +697,13 @@ static int audit_filter_rules(struct task_struct *tsk,
 			if (f->lsm_isset) {
 				/* Find files that match */
 				if (name) {
+					/*
+					 * lsmblob_init sets all values in the
+					 * lsmblob to sid. This is temporary
+					 * until name->osid is converted to a
+					 * lsmblob, which happens later in
+					 * this patch set.
+					 */
 					lsmblob_init(&blob, name->osid);
 					result = security_audit_rule_match(
 								&blob,
@@ -995,6 +1009,7 @@ static int audit_log_pid_context(struct audit_context *context, pid_t pid,
 	char *ctx = NULL;
 	u32 len;
 	int rc = 0;
+	struct lsmblob blob;
 
 	ab = audit_log_start(context, GFP_KERNEL, AUDIT_OBJ_PID);
 	if (!ab)
@@ -1004,7 +1019,8 @@ static int audit_log_pid_context(struct audit_context *context, pid_t pid,
 			 from_kuid(&init_user_ns, auid),
 			 from_kuid(&init_user_ns, uid), sessionid);
 	if (sid) {
-		if (security_secid_to_secctx(sid, &ctx, &len)) {
+		lsmblob_init(&blob, sid);
+		if (security_secid_to_secctx(&blob, &ctx, &len)) {
 			audit_log_format(ab, " obj=(none)");
 			rc = 1;
 		} else {
@@ -1247,7 +1263,10 @@ static void show_special(struct audit_context *context, int *call_panic)
 		if (osid) {
 			char *ctx = NULL;
 			u32 len;
-			if (security_secid_to_secctx(osid, &ctx, &len)) {
+			struct lsmblob blob;
+
+			lsmblob_init(&blob, osid);
+			if (security_secid_to_secctx(&blob, &ctx, &len)) {
 				audit_log_format(ab, " osid=%u", osid);
 				*call_panic = 1;
 			} else {
@@ -1397,9 +1416,10 @@ static void audit_log_name(struct audit_context *context, struct audit_names *n,
 	if (n->osid != 0) {
 		char *ctx = NULL;
 		u32 len;
+		struct lsmblob blob;
 
-		if (security_secid_to_secctx(
-			n->osid, &ctx, &len)) {
+		lsmblob_init(&blob, n->osid);
+		if (security_secid_to_secctx(&blob, &ctx, &len)) {
 			audit_log_format(ab, " osid=%u", n->osid);
 			if (call_panic)
 				*call_panic = 2;
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index ec6036713e2c..2f089733ada7 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -130,6 +130,7 @@ static void ip_cmsg_recv_checksum(struct msghdr *msg, struct sk_buff *skb,
 
 static void ip_cmsg_recv_security(struct msghdr *msg, struct sk_buff *skb)
 {
+	struct lsmblob lb;
 	char *secdata;
 	u32 seclen, secid;
 	int err;
@@ -138,7 +139,8 @@ static void ip_cmsg_recv_security(struct msghdr *msg, struct sk_buff *skb)
 	if (err)
 		return;
 
-	err = security_secid_to_secctx(secid, &secdata, &seclen);
+	lsmblob_init(&lb, secid);
+	err = security_secid_to_secctx(&lb, &secdata, &seclen);
 	if (err)
 		return;
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 3d0fd33be018..8627ec7e13fb 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -333,8 +333,13 @@ static int ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
 	struct nlattr *nest_secctx;
 	int len, ret;
 	char *secctx;
+	struct lsmblob blob;
 
-	ret = security_secid_to_secctx(ct->secmark, &secctx, &len);
+	/* lsmblob_init() puts ct->secmark into all of the secids in blob.
+	 * security_secid_to_secctx() will know which security module
+	 * to use to create the secctx.  */
+	lsmblob_init(&blob, ct->secmark);
+	ret = security_secid_to_secctx(&blob, &secctx, &len);
 	if (ret)
 		return 0;
 
@@ -647,8 +652,13 @@ static inline int ctnetlink_secctx_size(const struct nf_conn *ct)
 {
 #ifdef CONFIG_NF_CONNTRACK_SECMARK
 	int len, ret;
+	struct lsmblob blob;
 
-	ret = security_secid_to_secctx(ct->secmark, NULL, &len);
+	/* lsmblob_init() puts ct->secmark into all of the secids in blob.
+	 * security_secid_to_secctx() will know which security module
+	 * to use to create the secctx.  */
+	lsmblob_init(&blob, ct->secmark);
+	ret = security_secid_to_secctx(&blob, NULL, &len);
 	if (ret)
 		return 0;
 
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 46c5557c1fec..54da1a3e8cb1 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -175,8 +175,10 @@ static void ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
 	int ret;
 	u32 len;
 	char *secctx;
+	struct lsmblob blob;
 
-	ret = security_secid_to_secctx(ct->secmark, &secctx, &len);
+	lsmblob_init(&blob, ct->secmark);
+	ret = security_secid_to_secctx(&blob, &secctx, &len);
 	if (ret)
 		return;
 
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index d1d8bca03b4f..a6dbef71fc32 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -305,13 +305,20 @@ static u32 nfqnl_get_sk_secctx(struct sk_buff *skb, char **secdata)
 {
 	u32 seclen = 0;
 #if IS_ENABLED(CONFIG_NETWORK_SECMARK)
+	struct lsmblob blob;
+
 	if (!skb || !sk_fullsock(skb->sk))
 		return 0;
 
 	read_lock_bh(&skb->sk->sk_callback_lock);
 
-	if (skb->secmark)
-		security_secid_to_secctx(skb->secmark, secdata, &seclen);
+	if (skb->secmark) {
+		/* lsmblob_init() puts ct->secmark into all of the secids in
+		 * blob. security_secid_to_secctx() will know which security
+		 * module to use to create the secctx.  */
+		lsmblob_init(&blob, skb->secmark);
+		security_secid_to_secctx(&blob, secdata, &seclen);
+	}
 
 	read_unlock_bh(&skb->sk->sk_callback_lock);
 #endif
diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index 3b7a3e0ae8af..18749705a862 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -376,6 +376,7 @@ int netlbl_unlhsh_add(struct net *net,
 	struct audit_buffer *audit_buf = NULL;
 	char *secctx = NULL;
 	u32 secctx_len;
+	struct lsmblob blob;
 
 	if (addr_len != sizeof(struct in_addr) &&
 	    addr_len != sizeof(struct in6_addr))
@@ -438,7 +439,11 @@ int netlbl_unlhsh_add(struct net *net,
 unlhsh_add_return:
 	rcu_read_unlock();
 	if (audit_buf != NULL) {
-		if (security_secid_to_secctx(secid,
+		/* lsmblob_init() puts secid into all of the secids in blob.
+		 * security_secid_to_secctx() will know which security module
+		 * to use to create the secctx.  */
+		lsmblob_init(&blob, secid);
+		if (security_secid_to_secctx(&blob,
 					     &secctx,
 					     &secctx_len) == 0) {
 			audit_log_format(audit_buf, " sec_obj=%s", secctx);
@@ -475,6 +480,7 @@ static int netlbl_unlhsh_remove_addr4(struct net *net,
 	struct net_device *dev;
 	char *secctx;
 	u32 secctx_len;
+	struct lsmblob blob;
 
 	spin_lock(&netlbl_unlhsh_lock);
 	list_entry = netlbl_af4list_remove(addr->s_addr, mask->s_addr,
@@ -494,8 +500,13 @@ static int netlbl_unlhsh_remove_addr4(struct net *net,
 					  addr->s_addr, mask->s_addr);
 		if (dev != NULL)
 			dev_put(dev);
+		/* lsmblob_init() puts entry->secid into all of the secids
+		 * in blob. security_secid_to_secctx() will know which
+		 * security module to use to create the secctx.  */
+		if (entry != NULL)
+			lsmblob_init(&blob, entry->secid);
 		if (entry != NULL &&
-		    security_secid_to_secctx(entry->secid,
+		    security_secid_to_secctx(&blob,
 					     &secctx, &secctx_len) == 0) {
 			audit_log_format(audit_buf, " sec_obj=%s", secctx);
 			security_release_secctx(secctx, secctx_len);
@@ -537,6 +548,7 @@ static int netlbl_unlhsh_remove_addr6(struct net *net,
 	struct net_device *dev;
 	char *secctx;
 	u32 secctx_len;
+	struct lsmblob blob;
 
 	spin_lock(&netlbl_unlhsh_lock);
 	list_entry = netlbl_af6list_remove(addr, mask, &iface->addr6_list);
@@ -555,8 +567,13 @@ static int netlbl_unlhsh_remove_addr6(struct net *net,
 					  addr, mask);
 		if (dev != NULL)
 			dev_put(dev);
+		/* lsmblob_init() puts entry->secid into all of the secids
+		 * in blob. security_secid_to_secctx() will know which
+		 * security module to use to create the secctx.  */
+		if (entry != NULL)
+			lsmblob_init(&blob, entry->secid);
 		if (entry != NULL &&
-		    security_secid_to_secctx(entry->secid,
+		    security_secid_to_secctx(&blob,
 					     &secctx, &secctx_len) == 0) {
 			audit_log_format(audit_buf, " sec_obj=%s", secctx);
 			security_release_secctx(secctx, secctx_len);
@@ -1082,6 +1099,7 @@ static int netlbl_unlabel_staticlist_gen(u32 cmd,
 	u32 secid;
 	char *secctx;
 	u32 secctx_len;
+	struct lsmblob blob;
 
 	data = genlmsg_put(cb_arg->skb, NETLINK_CB(cb_arg->nl_cb->skb).portid,
 			   cb_arg->seq, &netlbl_unlabel_gnl_family,
@@ -1136,7 +1154,11 @@ static int netlbl_unlabel_staticlist_gen(u32 cmd,
 		secid = addr6->secid;
 	}
 
-	ret_val = security_secid_to_secctx(secid, &secctx, &secctx_len);
+        /* lsmblob_init() secid into all of the secids in blob.
+         * security_secid_to_secctx() will know which security module
+         * to use to create the secctx.  */
+	lsmblob_init(&blob, secid);
+	ret_val = security_secid_to_secctx(&blob, &secctx, &secctx_len);
 	if (ret_val != 0)
 		goto list_cb_failure;
 	ret_val = nla_put(cb_arg->skb,
diff --git a/net/netlabel/netlabel_user.c b/net/netlabel/netlabel_user.c
index 3ed4fea2a2de..893301ae0131 100644
--- a/net/netlabel/netlabel_user.c
+++ b/net/netlabel/netlabel_user.c
@@ -86,6 +86,7 @@ struct audit_buffer *netlbl_audit_start_common(int type,
 	struct audit_buffer *audit_buf;
 	char *secctx;
 	u32 secctx_len;
+	struct lsmblob blob;
 
 	if (audit_enabled == AUDIT_OFF)
 		return NULL;
@@ -98,10 +99,9 @@ struct audit_buffer *netlbl_audit_start_common(int type,
 			 from_kuid(&init_user_ns, audit_info->loginuid),
 			 audit_info->sessionid);
 
+	lsmblob_init(&blob, audit_info->secid);
 	if (audit_info->secid != 0 &&
-	    security_secid_to_secctx(audit_info->secid,
-				     &secctx,
-				     &secctx_len) == 0) {
+	    security_secid_to_secctx(&blob, &secctx, &secctx_len) == 0) {
 		audit_log_format(audit_buf, " subj=%s", secctx);
 		security_release_secctx(secctx, secctx_len);
 	}
diff --git a/security/security.c b/security/security.c
index eac7c10b8cfa..ea927a00de18 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2062,17 +2062,16 @@ int security_ismaclabel(const char *name)
 }
 EXPORT_SYMBOL(security_ismaclabel);
 
-int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
+int security_secid_to_secctx(struct lsmblob *blob, char **secdata, u32 *seclen)
 {
 	struct security_hook_list *hp;
 	int rc;
 
-	/*
-	 * Currently, only one LSM can implement secid_to_secctx (i.e this
-	 * LSM hook is not "stackable").
-	 */
 	hlist_for_each_entry(hp, &security_hook_heads.secid_to_secctx, list) {
-		rc = hp->hook.secid_to_secctx(secid, secdata, seclen);
+		if (WARN_ON(hp->lsmid->slot < 0 || hp->lsmid->slot >= lsm_slot))
+			continue;
+		rc = hp->hook.secid_to_secctx(blob->secid[hp->lsmid->slot],
+					      secdata, seclen);
 		if (rc != LSM_RET_DEFAULT(secid_to_secctx))
 			return rc;
 	}
-- 
2.24.1

