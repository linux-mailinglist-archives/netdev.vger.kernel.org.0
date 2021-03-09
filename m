Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 576EF332927
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 15:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231683AbhCIOwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 09:52:05 -0500
Received: from sonic317-38.consmr.mail.ne1.yahoo.com ([66.163.184.49]:41021
        "EHLO sonic317-38.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231707AbhCIOvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 09:51:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1615301507; bh=r7g+WSMCH453ybpndKJi0Mx2b6uBapcQsdt8icGIdLk=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=tSYSGlL3yGd/zTd4jYsgmXYjOzNui8lO4uYyTyh9v3Mmk6cDJzV7y+X0ISMD3S1QID2yNaeACuRhxZriQA0Tp70MMGpPF5lkqZsBFWhVfQd4NxSv3YWMHnUvv4ugHKEQsChxWN3cH8xxthXnfT3yfbmphFS9MgJW9DDQm3Xuw4MGQD/EfnWPsSbpOmO8V/T4PO32AJUOGituvLCcUtLNmMxmY18mcdyENFyWsyeVVfkWbEHuZ1ASKjxfhGaPlvpVQN0PXSwvi5yMaxQn8FXvweqYQStvXFedlStizOOo/smFCYsc0wYYD3vPXV8ECkzkViulvRQeBIlp5xg029HnGg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1615301507; bh=y8DTFQqifpy43eDktaWffNG0zwfSPquPxanzYFgfwvV=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=WFf+RrNWLYQiPIkKj48Qq+wMu4SOCd5vlOdHJ/stjX4p8cHkNW9DUePiVN/mmfO9bCrbHANncOZrnJBsjiRqZWpHREZVuQWL5GB+Aug/jWIQFaYCxskraDoP4U5cRu0oEyWDBYOy3C9fYcmSl3ImDTO19BL7Z/V977CqSmndPkrsEZmn6g7KPnZ8aAFJ+xSTjKmhFO6oUeIk4pEABEWHSsjAR9GrFCTIf4fiuXZ7wpZwpM4bVebbT7LYZS6p9nlC13g4yec3eu5HVPev9S6xPj+jm7qaNkdzzaO07E+Xmi0dX2qJC3om1XLP7RQpdTRMIyZkLM9vshGXi7tUvDfZ5Q==
X-YMail-OSG: G2bKkdkVM1lBFoF2QB5o6WxcZl0OJh9vretO8MTB3P7.fjEee30ng1KwxN_vcbj
 TSPPUrHgq08w.hntYJT6_w_2O43huUMmBqIM23et2cDkVydMF2XeS0DwDOD1vKBUsxSquFEwGpMz
 nK_Z2dnJjEQaRfPjbUzeM5ijKrr5McPizCfhBrdgSGImhvTh3YD1VGYhghqlBNlLGoQw.HfqqwH3
 WT8DMvb8NpLzIbgUURSL6GRQcfv6o9y9Lpbax4BBKDmtP3WBgK.evaauGjyKTP0f51UECYXQg5yM
 hMxhY4ux.4WYZfwjS8KIAvrRwmBhpaczfnQ_j4.JvIXMiAQ1VwdrmoyZGCgzgEgKRZwYwhu1lU4w
 fSvAB8KCR_l8MmofHFMkBafr8RamJnEmRCKjI6sZMili6.kgUXhHRyNXSeE1KItc3.RyAQ0IFQQF
 7EquGBJJ.LkqWEv2HPKMh6OhctCQYDM4r7Q24ECuHU_cESul24q.M6FdC1gEzp7.OhjG38QTEWlI
 h643So.WQrrcMpkjaYqkdTn_Gwy8SgW4lE9MbgYHeVZVnZgvmdt0CxnA40Mb9nRZBBw_OW..dsug
 uP2RaoIqzCJVU86mppcfiSftdwDJsn.2x83KENWRMrD_3.Q3y1vXRjPex9fX7yCceWNX9zvUOBi4
 n60oGXUYcaAqOUvnc5BCezZRW.ZJWxVqe7uowpi9RoYQODxK4D8lOfNAVI0CvGAwGsvX49KLgCFB
 TzxlAGdqB7IwmubwbUg6dkBRWucO3T41T8nqLQKR4ym1EBU71ciRwW12vtmbHLdvQaM7gwPG57PK
 xA7mXyuffR7cemFKkLtqxC9WBmKnx_t.Az6HO4hGu16rKr234_cLcVVYJpNp2M9fBd_okJHgxKt.
 UEmw.RSZNDKDCio_dIu4kW52EqXzN8G1.Kk5nfw3GeDKm4e3jMxrsivqPnrQiU9bfrGdqK1lhsIn
 sVfHRBUXAVRNacJnaI3L27TYc.M1UO0CVRzpPpmtbURTyLIT5d7WbTeWhqeScqdUEBhmSLVHc1Ni
 XSunWtHE0lIOA4kziQ2RHPghEZoTBjVFsygZH8qM3VnROEiGIG7W9dzDe8kXpziAPLfmJnq_JFhy
 8NSIBMwrm9wOm0miQ_AQOO7i1J7AuS9spwVh_VcNzgxj1S1p4tawtMv7L6Jql.9vtx0Cx4IkGg_9
 oUuFW6DjHGfCkjqqMMh2s_qoi1z4zJQSpFlnTHYiAGL2N7WKHZjU2M4Jn7wxMGLND0I3OqqL2mtg
 F40XNFy_LqlVKjpp7bmv.NK9SqXLU89tzZYqzFidRGgK_.H4JpWxolxR33ywD6Q9V5iDyPble5ht
 PQywoTNLfIXIpOzQkPvpVpvNKLJZ7Hsh6_pCr29zSMzAtBVYqv.kfwsLcrkdzU9qZ3FCeiFZg8XO
 3QbD_jm8Xz8nso7InmQ2JbGNFRoP8b.37Eg4Md_jQtMNTGUk7aQxA1cX90ahL2JaGTbfs88VWIcQ
 rqENyN_ZQLaU_voJ1iUMVi8pDgydKHyfE51MVfOc7wOSw3ne.XluVso.T.XlJ.DCq7m8QSJSp1dQ
 XmobfBH.Ryaj8B2oESzSRWXke5P.flncBDhP0.ODvZzn432cdQfVM9Q4tx6UgSVz_I8e7fNQs11x
 q..s1y2I7dI87al_PD0RcNjNGY7gvjgbget6LW3C5FRC5cilpTvQ2H6onrJjkylQCKEpv7kKZXKc
 U_L4fVU45ozYs3rw0JynIuh0_IFlh2pfs0R_7zRsEJUGLseQ2gqSa7j0jFM231DlFv97aMfPEFLB
 7HhGvlkwatxIr6J3IEMe_U7QB5mvMgO91Oz2XEaUhaIateKEzmaYuX4IYxUj.cbuBZInNb2a..Sk
 kwItnLOrh4TDt4gvg_KtAiOfdY5KppwfWWud4MXB30FqR2QcnhisN9VGY_gydAq_tj0sL6KXRDhl
 owNDPq94cCjXOxtfKvqiT.rWfqFQFCBBizyP8QlrWvItyTQoVskD3PUfW4QXuwX49sIxw6swyKQr
 T6HrVbtMUjpMBQt4hVc.akpqo2.yaVMsni.Uk.9sBMpsc1ZdITqQ0DpcD_hOFa4BGvUDjaQPQ2V8
 qz5dIbDM6CQH7hxzj.1xBuVi9GlQ5xHJnUD_jZPAVfpqpbP_EPCH_Ytw_WI43N3jraoB3btb1vlr
 rEbv_GAT1Otg1ifGeXj6UggKrMkfSrqK_zFIXOIo10qqujvAdIZmbR3vCjooYxkhNSbt5xYj8IIN
 9v5YwAOJsElZfRJ2AZiz5mh73AJDqikj4NpzcsICZo1VplNEsMRAIYsTfJR2W3Jx7hZBhonOIT4o
 yDNfBAQPPQG0YUr04jigVQN_tFUtozAyPz1Y2VNInoJzqRMw5Ln522ihmg1mYuJOiPO4KhY9XW4d
 qNISfApDE1TQF88QIFHRpl5Pstot52MhM4SH.EtWnldlcM1U6c9g3VqN4gRTcKHC2cg1js6yJp9U
 2kq.lsuxMMSBsqGYw8slWxFb4cR0_e7v7WZmh5ysDJz.WbQ3Kmc7Gg4k8WZNlbDH_4zmikUiYyeN
 20Mm2xRbsgcT9McQhAIXi_2yUxdPnFoc3jejDcZZQJvj36H_2bx29uOCz6HWrHKAJoHCL7ndL7NB
 NJcMJmvtwPtgNqmttyDtFCODP2XNXcQi2A_EXWQ63TnqUsGWasqSaNdemaTrlQfdMa5dZDecmhN9
 xiUXP4fOd2skL.3VtE1fmEgGt4IX84SHJBEhG3S1jXdXVriCrbJIUNMBcmrgtn1hZNODxGRGQj.c
 JMAHORlcWm.5qZBdE923Gf4w47e0z3Wb7p4beBCtFMj_n6nw3ZD6w1VRZ90z6FmDCfRU1hE4tnjq
 Ai.n8b7XAJ4nlhJEX71m0LwvgThI4pLHeAWqdChoJkG3.c.Fi5hFSa1W.pzoFbthe1SfwI9Sqjnf
 hcNOOHzUG.xAOMFxVoLFS88EZFyChtXvnwWhczLeIs8yXOYpu9qKGlnl_WfSg9PussXtmaMuuBRQ
 ZkLp._LHrCXFyENQyqn5PEUR2Sgqd6O_SeM0nUbEYvX_mlBL59qPyowj.NKkYtJQpNR08jWRLnG1
 z_.QiVBYGPGAWL4SPRu0aguJhfg3YfDO6nRZHlJKtPvmoFQAJOJq_MeQeeldofEXPt294hdm9OFf
 3NFsIulv9KrY2gvhjTSbuh0XzekqgIXIhVIsFPo5UoLWZG50rC2hHYI9sodUZnNlSYTCNtEpjF4l
 uVLPVPaGhatxE85rO1MKt.YJF9epQEhTdIOz3mxATYpFft_LX6Sz78B.8Mg--
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic317.consmr.mail.ne1.yahoo.com with HTTP; Tue, 9 Mar 2021 14:51:47 +0000
Received: by smtp425.mail.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID b1b2dc86cf23afd985c4744288b8a0b6;
          Tue, 09 Mar 2021 14:51:43 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH v25 08/25] LSM: Use lsmblob in security_secid_to_secctx
Date:   Tue,  9 Mar 2021 06:42:26 -0800
Message-Id: <20210309144243.12519-9-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210309144243.12519-1-casey@schaufler-ca.com>
References: <20210309144243.12519-1-casey@schaufler-ca.com>
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
index c119736ca56a..5fb8555ce166 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2698,10 +2698,20 @@ static void binder_transaction(struct binder_proc *proc,
 
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
index 1a1fbe0746a0..01bf23c68847 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -544,7 +544,7 @@ int security_setprocattr(const char *lsm, const char *name, void *value,
 			 size_t size);
 int security_netlink_send(struct sock *sk, struct sk_buff *skb);
 int security_ismaclabel(const char *name);
-int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen);
+int security_secid_to_secctx(struct lsmblob *blob, char **secdata, u32 *seclen);
 int security_secctx_to_secid(const char *secdata, u32 seclen,
 			     struct lsmblob *blob);
 void security_release_secctx(char *secdata, u32 seclen);
@@ -1379,7 +1379,8 @@ static inline int security_ismaclabel(const char *name)
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
index 551a394bc8f4..fcbdce83a9d8 100644
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
@@ -2131,12 +2140,19 @@ int audit_log_task_context(struct audit_buffer *ab)
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
index 829005d3228d..9963c3bb240b 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -671,6 +671,13 @@ static int audit_filter_rules(struct task_struct *tsk,
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
@@ -688,6 +695,13 @@ static int audit_filter_rules(struct task_struct *tsk,
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
@@ -1400,9 +1419,10 @@ static void audit_log_name(struct audit_context *context, struct audit_names *n,
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
index 1469365bac7e..cc2826cdba8e 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -338,8 +338,13 @@ static int ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
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
 
@@ -652,8 +657,13 @@ static inline int ctnetlink_secctx_size(const struct nf_conn *ct)
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
index 0ee702d374b0..ef1394f7fcf9 100644
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
index 48a07914fd94..1956b0312ec7 100644
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
index df9448af23dd..0e5d03c228e7 100644
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
index 4fcffbf1ff8d..7a168d7adc02 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2121,17 +2121,16 @@ int security_ismaclabel(const char *name)
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
2.29.2

