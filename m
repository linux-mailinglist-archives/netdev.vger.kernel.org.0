Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09CBE4A7C3F
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 01:04:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348263AbiBCAET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 19:04:19 -0500
Received: from sonic317-39.consmr.mail.ne1.yahoo.com ([66.163.184.50]:36469
        "EHLO sonic317-39.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348172AbiBCAES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 19:04:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1643846658; bh=I80onzhH7yaXfwP7a2cDirDLzjQGllxXcwrQXJDrD1E=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=sl2vn5CsnLhXxibT5i0d9OAC+MJMR5dwimCH2/9IOH8QFQMKj6V918jHwhuOqySAZp9RGuKRDTRq6FybvxzGGwRRSfm2Dqop0InZA0Te2P2e+Bitt8ASCGxOJVo1j+3cyDNQIR+/v6SJtJC3k0h6yw2ZYdjC9SWDS92ywdOnMTZgbrsUpLheaUYdMtyXHFZzOxBtWCXrWqtL+UMLAn7P+aEDm73JV7oIYusC5o91JTPn9DP5YmTjS+Y2J/h853P+AJrJQShfza925dhR2pL0GftmHQGueDskgDq6K6F6g32+aB5bcjOpZZXOz3BmeuIUWnDQc69X0a3j50ghXptOVg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1643846658; bh=/ZVnweut/G6a2pLmWhASOB1ZcpaUEHVDFi5ai2J15bz=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=Wbe5CpCfVGPFldOyjmNSVbNp5lLHitgII5JUovbVQkZFyFuSb093h55JeruNnuo/VwLvOMKliktaE81bP0U3eXdYQvgu4eiMQ5n3GxQNABD6x8VZxc0lKVHXgL+hdQGM8wYUgD7uU0s31pXSKbQQG/mJkUzNB9bWGJqSwFTec0zSzDm5ZSDUkxEZY0ykAaZENTcOWddAlXkK74osI2BbmsgIAGdqFF8XA7HLtbhsSkwlnlY1+2iuYYFfptk0Y/c3VS4n2w47qx+f00qsEaSSoZEPRIy7bTnYU4X9wG1CGrmIzz7uLM4plvPGfulrxIZDfErdRkaU/kxDjKTXUBc6RA==
X-YMail-OSG: NagP35cVM1mFDy6.WtM5HptQCC3g53KyPWLExW.mHWhJpJkNky0hbbLv1Ts3QsI
 vEgmKsvI3Fr7M0gZrPZ9AK.oY5FzdeZcxckkowH8C7WZwCXkm8yDlxfx3MQ2EGOkMLoVsw2AFeM6
 VIeJ0T.fpd9AnU1SGNBimBvOrpNmpyFJ_XjHj8oGUo5pojAtNRVkxBFzPrsMDuqRNioo0aM.EoIT
 cVTWmij.HZ1FxHfeeMBCKuPP9XA_q83cbJFvfCFykAfVTQKTG6to7NewfeFyfGJijqkLV4aHPfOf
 1_qJ9stBzQ7.p2ADC7h1hDkeuPheqkZ0xlbJHr1FCF2O5YF4m7Lv_CV34jxkg0kbN_Raa8tqtH9M
 4gyWvyrZy_hnlFK162cwz5RUj9.q5SEzb0.e2Xz8S0SYZyaIchB4KxpSsxo_mLFZxkeOJGDrkHcH
 vjRe3aJqEKP6dqA9QAOK01RbByUcuIAHmj7SDCLT5I4M51rUiVEaZHdqE_NKIEsJmUUNRik5vtkX
 gudLGpvUg1gDZuo05dyAwTG4kUyTi6uN2tLORRqy1snnhLWuzhHS2IJLrmOShsnNQHtTlglkEGkJ
 Z3t5QNbwH542u9U7PQy05pNBtqjihCezewKKKeVv1Di5IRf5pkRCJYDZIp2_Gv9i1IvQiAKdvMmI
 b5jN8LvT43IxZPfIhfURnJUENcR.iX8Kx6TrrlbYINht_xvUHQwDCg4g7ooDobm9dvW9xCX.wE44
 VsKmZm7PN17kXGPSBoj7dfdePKOydRhERWc6SY8FdVUNUsDH0.POt1aEau0MzTsRoE7dXGEFeZVf
 pwbLBDQnYG52BRXtTMHjjAnU03cYDT9Yn.a80OrxhJy79ro6PpM.dZNdJyFlvHOe50Fxz.p1tsmy
 0hjbbBLUkcggy04j6EXHVhgNcbYpsa9N3TlXl9fWB5cBG5tLYbobPOZggr_e7Axp9c4H.Ib75DBb
 gG5mBhTrmKDbyexpSfPOP.ix4Cu.1QzNiF35l7XRAawvy7E4uH8b9BPtjSuwmm2HBkfqtmCvxdcj
 ucE52QbpSQJC_eGTlNKO0KwV6RgPJ_9hwlqVdbKxZIcp4A_co05k8oAg.8uNXfRO__mSm7TcQS_I
 woWLtuAKOPtA.syvEysczblE_LB4QwZQ99hOjGfMB4QRYcXPtwKad80KJO22gP39xel4Y5wiGnnz
 63ksOudSJdfsLXGKndhUh3u5zHGefMMxJO7IOkfIeSNosqSO.Fs1xbSpB07ujs79hhly9iLrN8oA
 1hMvv5Jraz.Dt_Z6a9l5sHQy7xvitiMPvrTwtpCo6OiqPN86wFbXWFqnXqR8tgIHpwQccIsPa94V
 petmr4oeFvGLt5YN.yRxF5nnABmbqDsK4MzlIeUlCa.D.UHSK9GJc9JxMo_psiczmvGup4kqAaN1
 lGdEBgX09lORjmGsAq_D7Icw1IpeaIr_7PdFXurR42NHrSqYmRG22njPz33WAjJsFqYM_M3loUXx
 dFx9nwuFcfjFnaCPZOqmsOF2FiCaa5pVR2QZ0IcaV1D4iRIFM30fb7VM2_wHFhdC51JQuV5PkvGa
 HeN4pMvVSOAPK6ybWkUchfWfme3XgEzyB9OEh3scTWJKQkUFl6xIYOe867Axvl30njZnLMs7VVX7
 MPSUlPvfZOHrmwNvO_fO7wQRiNkWBTS0CBLwmLX_fnQGO8ETiRFqPATy6_t_p0plNkA0Cz5sVj5P
 nS9UXPHsA8kP8LAlkfdagqTjTxqhyMs7cBzNCrot0OzVuX_rVAoRx42UAJkCQJQxM3EnmzDpy.hV
 BhHvFcvpczqRHiwksS3xa_CLm24QS33hKUzNfccCjSBUvSd1QzIOgwn5a5TXDgwudoCm5TzBQJWO
 y77yy1xjAivv_Hq.Srl5BDiiuAoVH2.aVethsXlml0gB5SPhvhDxErGGzCFGGHiXVTBfYHorZQU_
 5bWQKWnqx5vLk2xFKTOKOurqavPCLkKSta1.2jDYKLf9Y4p.dNaCJUvKAy.M7QqStTZeiNgNACUK
 ZsWby5CbXTXZz89Z4qe4C5w1PeUrSMZC.BLG.99xxUuUrk3jTWjgYAc8lZ7V6M6.M5o_bwuOc6ht
 HcQBI1Lde1M6mcm8eH89J9jUOZJTU1NHzq7Ih9I5x_NG4dOdg20TqDnaRpU2Z1vFKUY.gNcmenHP
 v0r3FaTVGMSpwXyGTk8kuABjgi3B7YNpTKC3NgtjtkmGd1eOuH8gX1R3IykcswEfeykpzoyW0IFL
 fyz_l7hCthdgNCAcEXmQROgqq059xCCiAOLtLNlTuJ8QJFuHmLeADJaZS_GtWwBYRaVlUSmmKLA-
 -
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic317.consmr.mail.ne1.yahoo.com with HTTP; Thu, 3 Feb 2022 00:04:18 +0000
Received: by kubenode522.mail-prod1.omega.bf1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID e2553693f3b26411334448521192e2ae;
          Thu, 03 Feb 2022 00:04:13 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH v32 09/28] LSM: Use lsmblob in security_secid_to_secctx
Date:   Wed,  2 Feb 2022 15:53:04 -0800
Message-Id: <20220202235323.23929-10-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220202235323.23929-1-casey@schaufler-ca.com>
References: <20220202235323.23929-1-casey@schaufler-ca.com>
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

Acked-by: Paul Moore <paul@paul-moore.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Cc: netdev@vger.kernel.org
Cc: linux-audit@redhat.com
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
---
 drivers/android/binder.c                | 12 +++++++++-
 include/linux/security.h                |  5 +++--
 include/net/scm.h                       |  7 +++++-
 kernel/audit.c                          | 21 +++++++++++++++--
 kernel/auditsc.c                        | 27 ++++++++++++++++++----
 net/ipv4/ip_sockglue.c                  |  4 +++-
 net/netfilter/nf_conntrack_netlink.c    | 14 ++++++++++--
 net/netfilter/nf_conntrack_standalone.c |  4 +++-
 net/netfilter/nfnetlink_queue.c         | 11 +++++++--
 net/netlabel/netlabel_unlabeled.c       | 30 +++++++++++++++++++++----
 net/netlabel/netlabel_user.c            |  6 ++---
 security/security.c                     | 11 +++++----
 12 files changed, 123 insertions(+), 29 deletions(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 8351c5638880..381a4fddd4a5 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2981,10 +2981,20 @@ static void binder_transaction(struct binder_proc *proc,
 
 	if (target_node && target_node->txn_security_ctx) {
 		u32 secid;
+		struct lsmblob blob;
 		size_t added_size;
 
 		security_cred_getsecid(proc->cred, &secid);
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
index 085565914515..44843d665f35 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -548,7 +548,7 @@ int security_setprocattr(const char *lsm, const char *name, void *value,
 			 size_t size);
 int security_netlink_send(struct sock *sk, struct sk_buff *skb);
 int security_ismaclabel(const char *name);
-int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen);
+int security_secid_to_secctx(struct lsmblob *blob, char **secdata, u32 *seclen);
 int security_secctx_to_secid(const char *secdata, u32 seclen,
 			     struct lsmblob *blob);
 void security_release_secctx(char *secdata, u32 seclen);
@@ -1398,7 +1398,8 @@ static inline int security_ismaclabel(const char *name)
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
index e4bbe2c70c26..40d8cb824eae 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1440,7 +1440,16 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
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
@@ -2146,12 +2155,20 @@ int audit_log_task_context(struct audit_buffer *ab)
 	unsigned len;
 	int error;
 	u32 sid;
+	struct lsmblob blob;
 
 	security_current_getsecid_subj(&sid);
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
+
 	if (error) {
 		if (error != -EINVAL)
 			goto error_path;
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index e5ca89160b5f..5edb16cb12e0 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -679,6 +679,13 @@ static int audit_filter_rules(struct task_struct *tsk,
 					security_current_getsecid_subj(&sid);
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
 							f->type, f->op,
@@ -695,6 +702,13 @@ static int audit_filter_rules(struct task_struct *tsk,
 			if (f->lsm_str) {
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
@@ -1118,6 +1132,7 @@ static int audit_log_pid_context(struct audit_context *context, pid_t pid,
 	char *ctx = NULL;
 	u32 len;
 	int rc = 0;
+	struct lsmblob blob;
 
 	ab = audit_log_start(context, GFP_KERNEL, AUDIT_OBJ_PID);
 	if (!ab)
@@ -1127,7 +1142,8 @@ static int audit_log_pid_context(struct audit_context *context, pid_t pid,
 			 from_kuid(&init_user_ns, auid),
 			 from_kuid(&init_user_ns, uid), sessionid);
 	if (sid) {
-		if (security_secid_to_secctx(sid, &ctx, &len)) {
+		lsmblob_init(&blob, sid);
+		if (security_secid_to_secctx(&blob, &ctx, &len)) {
 			audit_log_format(ab, " obj=(none)");
 			rc = 1;
 		} else {
@@ -1371,8 +1387,10 @@ static void show_special(struct audit_context *context, int *call_panic)
 		if (osid) {
 			char *ctx = NULL;
 			u32 len;
+			struct lsmblob blob;
 
-			if (security_secid_to_secctx(osid, &ctx, &len)) {
+			lsmblob_init(&blob, osid);
+			if (security_secid_to_secctx(&blob, &ctx, &len)) {
 				audit_log_format(ab, " osid=%u", osid);
 				*call_panic = 1;
 			} else {
@@ -1533,9 +1551,10 @@ static void audit_log_name(struct audit_context *context, struct audit_names *n,
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
index 445a9ecaefa1..933a8f94f93a 100644
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
index ac438370f94a..073510c94b56 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -341,8 +341,13 @@ static int ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
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
 
@@ -650,8 +655,13 @@ static inline int ctnetlink_secctx_size(const struct nf_conn *ct)
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
index 3e1afd10a9b6..bba3a66f5636 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -178,8 +178,10 @@ static void ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
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
index ea2d9c2a44cf..a9f7c9418ad3 100644
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
index f3e2cde76919..0a99663e6edb 100644
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
@@ -493,8 +499,13 @@ static int netlbl_unlhsh_remove_addr4(struct net *net,
 					  (dev != NULL ? dev->name : NULL),
 					  addr->s_addr, mask->s_addr);
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
@@ -536,6 +547,7 @@ static int netlbl_unlhsh_remove_addr6(struct net *net,
 	struct net_device *dev;
 	char *secctx;
 	u32 secctx_len;
+	struct lsmblob blob;
 
 	spin_lock(&netlbl_unlhsh_lock);
 	list_entry = netlbl_af6list_remove(addr, mask, &iface->addr6_list);
@@ -553,8 +565,13 @@ static int netlbl_unlhsh_remove_addr6(struct net *net,
 					  (dev != NULL ? dev->name : NULL),
 					  addr, mask);
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
@@ -1080,6 +1097,7 @@ static int netlbl_unlabel_staticlist_gen(u32 cmd,
 	u32 secid;
 	char *secctx;
 	u32 secctx_len;
+	struct lsmblob blob;
 
 	data = genlmsg_put(cb_arg->skb, NETLINK_CB(cb_arg->nl_cb->skb).portid,
 			   cb_arg->seq, &netlbl_unlabel_gnl_family,
@@ -1134,7 +1152,11 @@ static int netlbl_unlabel_staticlist_gen(u32 cmd,
 		secid = addr6->secid;
 	}
 
-	ret_val = security_secid_to_secctx(secid, &secctx, &secctx_len);
+	/* lsmblob_init() secid into all of the secids in blob.
+	 * security_secid_to_secctx() will know which security module
+	 * to use to create the secctx.  */
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
index 0fc75d355e9d..ffdd366d2098 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2179,17 +2179,16 @@ int security_ismaclabel(const char *name)
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
2.31.1

