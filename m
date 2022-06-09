Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB525457EB
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 01:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239457AbiFIXGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 19:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231710AbiFIXGw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 19:06:52 -0400
Received: from sonic304-28.consmr.mail.ne1.yahoo.com (sonic304-28.consmr.mail.ne1.yahoo.com [66.163.191.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D8826C0D5
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 16:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1654816009; bh=nefeTtnhXzPjjsSwoDn1M1Z5DUt1kxzzojqO9qby85s=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=GWPGq+0Z4TqOwRoaCxAGSwLDWt8MSQl3VdtkHb5L2jB2Djm7XVU9B3oJ6F2v/f/In3uMBAwWRK+1tQz9R9X4sn79k/agnpxAy/08mYtiSxlvi8xDyP/LENNu7ebIUpN6gMTO6TtVKvk7XAeJ93faXsb51cAQiabFo9/fptWzpuYM4NeuDlG2xX9kPpMDL+EGprC9K4KX+CkM22Y30ve69hYBy6A3e0dIgLQ9yV0d3uUNUUF3DuBVAxtEYFsln8tcS7Jy42qFwvI2LrZ/wMAPtNC9YYbzUiG2ujiMJSLoweg+kWCkfaeEOzkHrHo7Y8AjAQxeSXfXSRui/MyukWsRTw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1654816009; bh=QMS6zo77mQAAdq7Abuil2+qo6QCmsBzMnj94lDY9xYn=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=TpTqhtQofO2IrIYptFKrdQT4iGQs6sMwUII31IBE+b1vVQi9SEXNSUvS8PLV7bLQTIOwQ325Vkcyfg9UGSbcURIyRu882dGAi8VE/gFIIIBdWVqZ7X7aD+EhVmEylRrUSl3AubKzSjiCtXaKQYZNH5VLSum0Adc7CE1n9G4UAo1fpGRJeqxX3tM32pVN2LwS4L2tBUO1glYtKjT46ujlL4OV9mbJhq8DTPuU7VNXk0Tg99Jgr0oerU+PYdYgg4JGL3U/ULLc4Kw2v0Nf0Z0ZtprSBK3iXtJMFdU0Pp280br903C0jMuzLeWdieElu7Y84WrwqyIdDAmZdJjUCb1gRQ==
X-YMail-OSG: _OIvWnMVM1nwdvuBJFTT7loZ2_RYrKH68rB_yPqv.EUKBF92Eh8lug8vkqdGE9p
 5_O1rKKic8iCmsEDmrIUU9UQNhL.S9dZsZgF9WlRfJAS4ll4hIm0Mku7NgLzObszGKOHwGjTKxmG
 rzNW.LvHSA8wiWjgwHBzy2jdHCMGGKEvPORGRJ_.gKwOYq3Q2fyYhqs5leauPcURVY5PzLBe5tV1
 JzEancb2DJMGkH.sDw9.wUrv1vVEVEG_K8Q4xyKCZZkoX_gVx.af_FqOD7qtc.tdMRFFlNS4HOik
 D0iTsH0jZ.6Wq.rvMvd5DIwN6XiTO9ax645P3CJsi.9.UYMO.tG8dJ0pIGpZUZ6Bb6_n1jJkQk9.
 pV1oAWEDdK7zVhOrWoawtLDAWSA25XSTvlHGhyHoB.Ob4Htf88stUjmAjYvxU.Gsyt7KKOPbCGcF
 vMXh8c3vIMMOQxivmF7A84_B9QM3AtXIh0._vIMum69FxqK55uDa5zoQc_sovcdtknHY4KeHGU5c
 j7iY.VI725rYg_kl2zedMD6idsSLO4QEFHfsvj355b8WJtqH7gAKbKl8b1.GEvQbix75J4J_IlAi
 jAAqIQ_Km_w2NMqfFeF73IvvHKq3gYSniSz.Or4FdVMrYVZ0GxMzBvh7L83fgRQOf9lIOeHj14wC
 ocIe9AGdkEVekM.CcDpRXcjH9eLVs._Vu0jv34ftyUl7rbaE4Fxon9iYXplmjDfCOKYgUj1.o.yT
 wBsdBMN6a1OrmN2UTrTbxyv_qzgrjHY.VF.CSU0I8CL8heWClkVNlO0FUVPjWHHSdebBGfuMWM9P
 avcisbEeazkX6Jv628vMXMDRGSxJz8Wp8sZG4PVqkbpDTfS0gL78OQnd8UW_vWlg0g3mAu3VM6bu
 s4XgGpTohl_g1d5I9nh_l2Vo_1UOvsX0Huwc3EBkTz9Gn2xPtig06bZZesffpF.ik9ftKeTKS5vQ
 U1IiExM3TtgqdeZqa.w5iuBpmwmmh0arL6zFJaa2Q4kQ7vWoaa1vePZP1B4kPZxPB2JW1hnjI8bB
 lcfjzToiB_LukVeyISHEzH0YFVOkDkKfhk9X0pXHO3wbNgadwl7kj2GuXDUPEdaAwOZAiosMvEHM
 3.UO_xqf7zfVSQCXYzVVPHd8PEv1K3ZuzZqD5fvPHyNmx5bb2PZKoL8_4pI4Xq.LNy9FynuQpWvC
 nk5gVqVAxfdOIJgN7rhpa9VJLpd0Ndz..Lh0KDzFY_2nV9OZzy2spKymJNV4EL33u7ua9NfAKCJN
 HA_2ztxVarHePJv4QT0_48yva.bdenOAvQnQK3GjnkDkjm_JV6Jv1NJLi6wsVIE4ujE784F6Zi5Z
 vUCJJRD0f2o9XdArnDFyzyq2.ziVvknXidlB2YGY45UaeTts6cRD42S3mouXmwFRXDq4udjAT6C8
 PQ9MfJ.MAkj1GSLSiaFQ3pdF1NesH7z2sMIMup_iqc3t3cDggDxt2gpsFMRZ5xc3lvm1Dmu7zQVc
 1s0zWFs_1PAM1_kWk3RRuZwjxmZrEmSAnGSL5OQGqoZ3NQo5.y9GrVe7UsuV5ain4Y3PqV1o_G9c
 x9P2CsrTdVYIsfTgO8gRa4VopfG2itQ6.c914MEDqg4kru2ArBWZobhK_jB4plNYCLJtIGJ_c4z0
 VpDyb7YfQzCUJXEoQzw4V.wyeLkL3e9QID2SvLLsEwoL4NNwtK_VPIOofgRWzXVaMOvI3yoWIv5U
 7qfgaotVpTthjyaK2pWtfIhVAkz37CMlUSXNsfyF1aT6qcN8GHlaaVWBNG8NVLcgYttG.4E._Akx
 03sD.0.7CM64_5jjxAvc6MXe9GM7emukbut1i7.3vDOF7h1ZZVXbDyA8mPfqqbE6sqKREOX37nQu
 yJoSXME7LTGDDh5DNjqFFm7qbzY0w8S0Vk2zu7MQpnBdC7.UiICihuE.R2GOcs89UA6eTsCN0oMz
 ZOrIiXUpK2gsIJgurIpZR96BfVTxXKvTvXIb4QBTXXYqVvUgUxfhh5rjO4761_CT.z9Tw8sUMegd
 CRXFN4aeqvfHP0yFE524BhAmhejMo2znjFusvwtWuZjA5csxEAJ.brnwHZW1V9SgTK4Z5tzPelF6
 AI0XFbcrQxBKiBpEkoO7VscE1P.UpMsJDQHaQIbpg2JJZg9xOj_4b4k1bFSHqqeRSjx6QWYmNieO
 AxZnfXM4I4GkOD7m0ZD_tTudXyKdMO5BT4kSHtMwGgHeXXC19DZ3cOLaAoS7DLy44rPPqqzxPiw2
 BMrv4CrN4HrWK6.v.CK19oHyp757ge_Ssf7KzOCrcugTxLOlHGR.lh54gIp24KUn3vehERz.EazE
 Z6CDXms_fLuy9NHN955fPPBQSwFnJgP8-
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic304.consmr.mail.ne1.yahoo.com with HTTP; Thu, 9 Jun 2022 23:06:49 +0000
Received: by hermes--canary-production-ne1-799d7bd497-2pzdr (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID b20ca8b25547b2b344a65fa8c4e3e611;
          Thu, 09 Jun 2022 23:06:46 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        stephen.smalley.work@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH v36 09/33] LSM: Use lsmblob in security_secid_to_secctx
Date:   Thu,  9 Jun 2022 16:01:22 -0700
Message-Id: <20220609230146.319210-10-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220609230146.319210-1-casey@schaufler-ca.com>
References: <20220609230146.319210-1-casey@schaufler-ca.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index 362c0deb65f1..4ead3360a1c0 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -3055,10 +3055,20 @@ static void binder_transaction(struct binder_proc *proc,
 
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
 			binder_txn_error("%d:%d failed to get security context\n",
 				thread->pid, proc->pid);
diff --git a/include/linux/security.h b/include/linux/security.h
index 8e09302bded7..e8e4a7a1029b 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -551,7 +551,7 @@ int security_setprocattr(const char *lsm, const char *name, void *value,
 			 size_t size);
 int security_netlink_send(struct sock *sk, struct sk_buff *skb);
 int security_ismaclabel(const char *name);
-int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen);
+int security_secid_to_secctx(struct lsmblob *blob, char **secdata, u32 *seclen);
 int security_secctx_to_secid(const char *secdata, u32 seclen,
 			     struct lsmblob *blob);
 void security_release_secctx(char *secdata, u32 seclen);
@@ -1401,7 +1401,8 @@ static inline int security_ismaclabel(const char *name)
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
index 7690c29d4ee4..2acf95cf9895 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1464,7 +1464,16 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
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
@@ -2170,12 +2179,20 @@ int audit_log_task_context(struct audit_buffer *ab)
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
index 7701dba499f5..58e3f39f47ab 100644
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
@@ -1418,8 +1434,10 @@ static void show_special(struct audit_context *context, int *call_panic)
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
@@ -1585,9 +1603,10 @@ static void audit_log_name(struct audit_context *context, struct audit_names *n,
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
index 722af5e309ba..ddc8cd65ed12 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -347,8 +347,13 @@ static int ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
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
 
@@ -656,8 +661,13 @@ static inline int ctnetlink_secctx_size(const struct nf_conn *ct)
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
index 6ad7bbc90d38..2c1f3280d56e 100644
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
index a364f8e5e698..6269fe122345 100644
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
index 08ed7acf4205..552a08750843 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2186,17 +2186,16 @@ int security_ismaclabel(const char *name)
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
2.35.1

