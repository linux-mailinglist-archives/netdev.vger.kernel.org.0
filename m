Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65BBA2A72DC
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 00:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387749AbgKDXtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 18:49:35 -0500
Received: from sonic301-38.consmr.mail.ne1.yahoo.com ([66.163.184.207]:41133
        "EHLO sonic301-38.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387696AbgKDXtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 18:49:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1604533755; bh=2NyewPO53/4iI2Tr/R68jXRbY58jiTgqBTe9D9i5YK0=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject; b=d9sX9jaQB/cgQo9ZC0b5xZpK+ThkHBcTMsl70NzsPSswNoTbPh9MNEGi/mRt/NOYwU7vvBvhVMpyC4nvYPXB689v3q6UD2Hp9pQ62EtPfD05VyedOQeEWtAto6PDEdq+B/+buFWZTerN7z8fjj9ZjTf/stGKPeM6CnctyJZplP3w74dcOdV5+2k1odu55aI0xFOCK99cI6dVlf3O3M0b7ogPRtWGpl/wmkuzN5ZWnEzc/8psbjjgg1VtpVeGNvZo+lRvkcoX51tOx4s1DvQ6BCfR6eStQvdStWUysvGEHyKa/J4dRV5J/2gBpubwlNxmwv4c5Nrw4pBTWRLNP+gmGg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1604533755; bh=WZcAgyNM4+jZY0eGaP3rDPKNbQXXHglG02YFpRngFGD=; h=From:To:Subject:Date; b=PbObaTose9DCjuIBwLQC/cLknzZD2AitFAlPKgHPBtQn67A3WkyLHmkio8PO/sjeYuO/xUGiXz2ecDYjZupXbn1SK1UQkRONLP+YGzp7BFY4AH5UtVzIAMaKl6hCnAiMy8w3piT14orI/cfPVSYTGm2BPmmFu9hhyc2U9Qe0+EnBTm1ansLJO3xvgC8IqOZoiE/80VvxjUt7Q+xKh6an+8IH0mXVQlS3dFXNySLeo60/E8eEW1fUA+nHWEVQdhu59a4f3t4ZJptrhz4GncYUuoLBH1GVxKeK36xsFDoHdcHGDmtfxIwAoIq0/p6jcfSWZ/xJ/O6QmIxaXrskEAlxuw==
X-YMail-OSG: hUXPO.MVM1k2KPZzdKAxjIcQSQwPyeIQBlPqV4OqW.bKiRIfpBhEl2WgOQUKeWl
 wc853OUumGKsKvKw72Ld1UbEGObWN1juRs19DXYMe11XiAuZXJ.zcfaO9aNVbLQ.7K5ostoDxa2v
 yW1MQ43Gc3AoJfApkPDLlyxW4g5xzvatjSTGk1J_YOVL7A2jU_GFFiO47sS8u0PmSonA3iflBeU3
 aNS2NfW5.vi2PbLO_B6WlaUMLINJ0dnvPoM2lQykgapjgcWnB4C9MQDkV9_I4j87KmLJtjiPoTg6
 ETGc15mTwU2YRg1AII3uyi7WKfkhvGjeXyrGr5BTG9rYyKh.zrwcUSigP5bl0u9PL2cQoMcOcQqc
 Czrtp2LJ_YqMNaDvYDUSw_U06Kas3WCnGfxfeBP2csknuzybUG_DlUdLNHfvjt4IxyfkZbniqsSw
 VguacZD6z3cN0tyZgQzWNVKwNFqGMg2_COCCKjJotF81btl5jT5ui9uHoxMfrz5B_OWJX9XVqdi_
 Bs9o2Xq0jwbt1UwrWH2SRj.omqCKWtOcpOe41xenGeX_fWSy5UkEjoHGf1sbMtihryvOAYsEH2p5
 xYwrYgISLqffbXS6Aq6sYdVPlkJ.Z35QGcCW2eQEzn4h6NMCzi3naJLZPIePD2YjdiQOETGNQpLA
 0t.AqOQMpTDjwsYrpcZPFFa3jKdwq0kbqY6eaY_3ZCkSp9rDeRkwYqMhn.I2ZdoTz08L8ZHCk.5I
 .a6W8DVB5jWcSkDqWe8ypSsaHCyeSPIYLtryzckbsVp5IBn27YCML9PqO8.wz5y6i7lPLSyaFrIi
 GsGdSCQEgDDkROnLa0k2rsakdygK59vebmJ3Y1h5VFPS.3a5Z7ixbVMv4_InPuHFvnAJ07tZz_ew
 K87v9YyV8Hik.4Mk.L7tkIiMorI.ltyoDTBEoeDP3bRoktxUWXL_Ax.6LwO45UcThDC077xQ.95j
 4ZneHs7vvSws5KcLr3i1n2nnzI.UNRKV9O7WGIQvqy4jv5Fxp.ogCKFovdaDBsVj0p2Jl2zVxXmG
 iCwpow14H816pshwqRZgdpcBwkyvbcoQb4oreV2J1SiQzIphI5AIKUi22rM3DoQHH8CZ9M86_ICl
 d8lCxCBjrwFlRrL9s76oF4NDZt.DdAonFWLrPspdf9p0lt6IgvfWsfAUjyUXviG7_4VU6OTmDVuU
 pQo40SUpYUf_zF5Riha3yF3SKT7PqJKh3gW1q6esiab7bvJmjjEKDpz66CIKxqFUYxb.._mRXr4y
 PwcdxsyWCyVuVoDKIcbFV9.UBCqHp9aL6dJ_PjDqzmgjsz.H9v0lrYDVAtVCUyQ6c3h.IAhn_E_R
 XCPqKVs8a14POLS.QEK1F.KUJc8myUuNeg1Q3MdJ0BUkxwAHIqBiAZ66l.38QQmX11H6PHxEwVz_
 WZSHYcA7qcCulzV8ml2fCXzarJPSqRxG0HyWfvv8kSfYQDyjjf4Ua2WGZfOUfhoS5.HFGWZ9JiJ4
 8_.9mEwnSsr0D_ILu6N6TRFa2GEIufNEZyF2VkCUIW2UzUQA5We5p8ER9cyoTYnn.1J.8FDSSOW.
 7RsWM7U2OyHRwQ5g940eHqpOQBh8C2B6Ju1Zz1gby4fARYPD556ZXIWiknM_suLLanZYJJ3Nofnd
 3aVFRmeik4B5bKQWivbaQZnYk0hEmqCmye1D4_gl4nxTjTcyeqKn8EaRlWKfIaOwzeEHISSu_Sfm
 teV6FcY4CV2cHoCySaQ8IaO51Loqtnn4OjzswAiimKbxSVmgWqzV.uPIelcDmlckW86SbUlPJPof
 zQNvUAJaUBjWYRvQsOfhoR_a1N64oTBYkaWguZ8h9GxluPdRK2zaOWfm6K9XdEOf1jREWl_bDQ.O
 xxdw2VgLguUeVHAXDsjugn2c_qHbtggMJhsVxBzByD4wzWsnZ0sMWOI5WeuKvh5EogsgerzxcFUo
 H_s_yvkCOWrJgScoAS5LvrFNW0pjSDC6g2wIw8o3mQTxA1i_5rWahqo3wfdFQomMh8JO2wWSXfx0
 uPWgFJ5u4VsHsXSw7OCHXnI0a2.vAiCtNayifOxwnNgCGWsaiS.iErgpx4iXfMTBtto3IjPuofpf
 hJ39jjz03EFXIlklpfe_ET7J7UdieqFSpfn.Iv12dIsLdsMDnAuxKPjBrViSJohrTxF2iYCmg57q
 HFH3NZwJq4wkM7_8_u7PJfXmenPixb.Rx0wpAfigm5RhHxznEsohuLvZxgJRS7AmBoElp32BczlV
 pIyKb5Y.IA3zlgl5p59NHPzBxFCfcuzQpE2SRxITW5wd4JSskntiiSy5IkYIU7OBBdAOz2x9iWQc
 DF_eZ.UtMthIkCaCOnM_I6gWEEEsm7G9Q83AUNyYJg3QIXJRjxdJknOscf.F922n6AMGQ2MyoRiR
 H8gwEB46vrIKrPzW.sK03GXrUVkIQ0rJ6YSsDXtok64pDFDB8UcwpNAP8kf.3uI1BSnxmMGU_IGF
 bljUjAQfK.Ys6aRyXkBmKFKEp_elgevJbFm1gH0Jq9bielPGzzx9jQhlSxIR9Ia8UeO_ZCJLfzQT
 .i2Ha7OZleOBkVxbXTh7QNUpa904lctLRtP2Ulp1LJ5tdsO6_PM89rkB.w6P7UewCWUL.bcJWZeZ
 bClV_EORiTfMxFAj6PU1g9H.No237_pezjArtTUf2KZf0jOrpBskEi4YbgD1I2KMi6LqVO0etK2D
 ZDuzk9EyiB.OJzGLETDR_uT2L6gjMiF0oXtQlGqT1N0VhkQxEVMt732B1lWYf5hJcwSwrLqidrl.
 H2MnUcBGCnnvZSr4_4ZZeNx2knysx8JKxfK21Qx5tE9bFPDYwZL.w_xEc3N3SQt.tkhA3p1I4xw8
 TF.lFxhpAIIGNQl0PbLU61PrbLndb1_uuagUuyjzsmL0SBr_0bASSpBnQsZNGYNTHlArGnWZiH0w
 0jlKXQflNG.GMk4qrF3yyfD50tXmQ_ypWaeNVZ3mgR5sgKswb_a9FujkBR.JtmMKBLMSyu4wlP3B
 VtO4z8KUJD3nMYQ39d9JfnYckhPGrUeXAiB88ewnV38wFy1sqxIqVGFA2.elw.2ar_FUGmiBLkmu
 PwRYbS8vrKPQMmIdFkfeorzNBkALKGMdDVDXvBwGOv2tBMWJJftxqIrfV.M0hk3jcOOG1q5Kg5nF
 5K8b4iyMT9zBOlOoNGqS8bnnAT.Od4zGJbKhJs7EttUjzQHAPgBAMSTDsBkHD8uti9C_umErGftY
 UNTHsRCrUnM47UIF.z4O4hlLIwUeadUpa2QBfXtn3gnkDvXQVarX6L1RO6LL52q.N9XwTwUU._6B
 nzeDIkhMXdubrC62_M9HHQw6zTREjz4YLuAwpg44IEg53NmhQZPOl6004D7Z6TGU7fKjKQ6JfSqp
 xW8P4D5RlguWXhZWKIakEDWFFoiFKprz_Ct472HjaPKI-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic301.consmr.mail.ne1.yahoo.com with HTTP; Wed, 4 Nov 2020 23:49:15 +0000
Received: by smtp424.mail.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 0a1c713e7d1496881f68596c73cc8fa8;
          Wed, 04 Nov 2020 23:49:11 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v22 06/23] LSM: Use lsmblob in security_secid_to_secctx
Date:   Wed,  4 Nov 2020 15:40:57 -0800
Message-Id: <20201104234114.11346-7-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201104234114.11346-1-casey@schaufler-ca.com>
References: <20201104234114.11346-1-casey@schaufler-ca.com>
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
index 8c064342169f..ba74901b89a8 100644
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

