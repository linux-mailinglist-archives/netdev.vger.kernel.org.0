Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36940305994
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 12:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S313701AbhAZW6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 17:58:06 -0500
Received: from sonic302-28.consmr.mail.ne1.yahoo.com ([66.163.186.154]:35543
        "EHLO sonic302-28.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727738AbhAZRA6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 12:00:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1611680411; bh=P7N+rQcdh6yEckjA7iA6fQBZGODg+ayV5pcDDqXwZu4=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=DeaoAUitTIC78nope14DYh3dje7JQSB9e/Dhe/dWnFb51YhjtTmupHg0VnKu0Lr3gft1DLbx5kpCWMqIQLI99DmVMmhk3LMbqB5SXTKLwSYfkNxWx6w0IXdIVuo9hFC294qUinl7ulSGeMDbqQ6zH8qppaVLtsE7IIqKkSvI5WyCBA9Vb+70dA5BN92rm98+ieC1CgNlM6vBfIVxH++E+n8F9Od1+NQEMteJpipboO33gbGCteYCPwPo1Cl7Og4vzSYJXqPliAPFQAnKbKzA+uYGOzz8SD86IagnCcJb0DPdPITWxKSlxqXHRc7ss7EsFwRfqJwOtJ/nKgNgJU5GfQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1611680411; bh=Zc3vL/ibOAbY/nNgHEt4ka7nXNA1oI7m6W9Jz9NV+yT=; h=From:To:Subject:Date:From:Subject:Reply-To; b=DJ/xRztiw/rUzENfIo1Ocn/chk0EVtOsNHyrkVhlZ4G5QtH1R1QbphX3089MVAC2VkG97m0Far23vJDY6vxQVLG8e1x85Odp7ry0YYuol/wggrPWq7kf9vlhRh3oqvD4pml+umWilW0sxB5SQ0F4xuO7M/qWhdmbsUpfCF+oSFcleysrCUOqSnFi7W6qjlieaVXmO8slUQnNElNgHarQ/GuQuyxcCTdD5Q1+dvGsRYKsuTbyRkm3O3UnIe02RrGjCIX5nRhfLri7MDmnZkYu9JNryd7eN/Z2vEDoqI2NrnKbhIFN034SB/pTRWzoCXoztsDlMp9mCnrbLBoDvL0IiQ==
X-YMail-OSG: 3rH4F8oVM1k8djWWlPMpmK_TyV4LMnGrbw2cj1VN2P6voX5UbYAREjZkeOT9dk7
 aMFvWIohKsMxLQMyxtF.M8_AzVJ8CHJhmgrBI6qaQSLFswdvAF6qZwfgS6MNl025Y_NfixN7.y9g
 POSIy4xFA4Mderrop77fHNdfp7r_MikIDFFkM.sEXhux8wSCKIZ8kpUW2d2PNNUrcWVOZ409JBqJ
 YtrIm94xHjxRfu4o2AsPdiEdQTCoFLvmokOPMPV4IcegoYV6kLNZfVqp.iA6Xp4ivHxM8Xx2Dmec
 NWksER5vOUtLRe0TpSXD8ssVOl7gCCEuueEPHOCch62.ba6x6bbVbimMi5pGqLN3CoTcpc15LrdW
 S7K89dsb13hPgRwHkuflPHVpZFeI3QZDE2KKegJRAAWrctHUKzDWaMd280IRjDkS1D2owdf7ojkU
 XZNzLWlYpsG5LGpXo41iSxqA95MJ_a4_p6d1w4bugZPQoR1iIPqBAfd0prp35utI.QUk6dEjOdVh
 cRQ4xyuSIzzWs.Aqt8zCAgrnNbiAF7SULJoV.grau.HFHg8PaW05kExtcDFQQtAdQbnRQMtHjkYk
 yr.mTsYlO0K78oMeCjQxwIEZIa1yDA4SU5WT._DCmDlog3qKgPRgY9Q_j_w6lyDEEIoZ52Ev0awM
 0ZDNil9LxLXQ5VHpo8Js8Kg3CJPjCYiKV15sujjDrIYaT5pigpeADXjMw.3hpOwoTXi4.QX14lvt
 z.K1O4grlWrdvpeQGMrTk.Eol9tv2UGsz_D7qfU0cBOAUVpjYp3nE9RMKGyDOtMlgUDxCEHa4qoX
 t2zl5G7awObOk6NWHGylKirAwHfi.eo7ijv92jxwz5s2jHO9IFuJd4oRDlV3l3gkpurxKg1Ug7k7
 2I1wdct9rkcooRQKifiLxYCTuowSTuZn3fNyinTBu6kd9DkNBO7coAcWpsPA35Na4oFlXHsUZr_U
 lFjihA6Lw6grUcQwrzmTJnzATNNsdU9FpiWjQYKYNF_QmaYTvAzC8yYPkBnBr_6i0RVYppCp4tx1
 9StcgxjrRqUBXARkvcoLkotkv1tRn.3xlca3Sl.CTNPQZ_3Xxhidu4_VqCr09X79cD4eXyt7NR.D
 bVwoP7xJoXvIhcyd0HfaOAyDv8DuPQN_WrQtmWcS9UO1wTDUMrClWNlgu.Yaq7OQBUB9VXYin60c
 bJ.9ysQnsshsDmhDiS02XFfCcWOGsYYDQj_TKr95BxKby8F6qdgmm4bmjcMnhgNPAXPdTi7TlPE8
 Ytg9M704d38njcZ_xl0oke53dAtFBC59hJkL.XbREB_Z32ydtFp.EGM4skrR8Qqij9X2NcX76dzK
 NFEaF.y2Apu6QQwL1GFI7i7ekqhgH0iYYA9hH7hQ_xakfKwjhvgrDzxrY8xqwLEh.Ka6Bu7rcSPB
 FfDn9qvl2Z2OYgDxl7MdcZ8tzLhbONZt0LjoHl_wToHSb6F6hAftfXs.7n3CEGgr1._pZDIjgAqs
 jUXxSRNTcksLpzEi2E5KdcwQOTjeWVGp_U5XKlucyMfWcBsC0FCOAvqdfMdm0PZ4iHiaq1qJ6aV0
 czOMqHrzRGm5wod.gRSUkks22JyXiawxPcmvNhRR0u_02ZdZWhpVKr8L7_.S15rQ3LZQGnh6x80V
 WaTLcwBR1igyP2PEtP4z.A2Pb7LM4Bz22Xfp2MeZkjhA5UaaPznQ131Ee9OxuDc68oZDzkZ2EnKD
 28rgPUEi227wyFakrgIf.bAaudPKTbHgR6JS5H722SYGRa7POrk_AV0oBoym6oSTCm4epGPfHMVl
 LmfTnr0Zo4EMcdC9PVwZcGQBEYC6X_f1Fbj3n4vaZ.cuo2hMgih464aSRwk7.8U2XWad16xk7Mxm
 afg.svZN2mFt7Xun4XhoxaQQH6RtY.wZnPdSFmd.qaOU7YMWP0lUJSfwiey_h6Yc4v6_pjPZT6lt
 rv3CCzdR0Y7iauYxGPuqsI7kSMktzoHVOqNgDNiDqXH1lLDJ8huxGcUCvdMhlS7N4Wy8Hey_wdMn
 V1R_A2JUEVPHB2rNlCFrywBvARONvfG.uxu2fkuG9.E9_CLys4Cl6neXxySmb6vJI7Jg5r_2SoWg
 TUVZ3Abj7c2RvTzFsUKJ9juIG1WkaJPImxRK2zW0Le_2gYZnURV7Hb5AgjN.LCVLYQv7SC0iQKIl
 ffGUs7gGXq3Hu4CuovpbYaF9BpC4EDM9C52XSKL31PvIoEXdUVh7XghR3fRVxf_4yohwh3Xjfiy2
 u75ircTfUVIiHsewDxiQRQT61Md4D_STe5IrPuJPStklV7T44olQCZfx9Znh5pZvxFt_DjicoAXI
 Pe3Rr4GIOeqlCY9q6d3KZxAawGhOHqFmLnyDPKL.Shsv7kET7msH4WQhyvRR.B5wuyZvkBVSrXGP
 IH7sUtMpKbC3dSyHGLpaXtxTuVUO5uX1N9OChVTTMP_b_aDwXTRbTjMFsc7XxCTV2uY03VgIYhHo
 ddKTTdzRz2rkPTNarX9WPClc4DF_egHsuDNjNzbirRFPFGGlcppbtOOMFyP9eUb.0KNGqsVxrbKz
 Y3Ee0o4arA6ure6T32GOmneNXbaAIZdgXLg2.7bkrgmofecghUwIOl0g5SIFJCJ1lzN73ZM.F4m0
 eJi0ryP9hOevyZrbv0OEMoK.D54IC4hqZC4cKs8EwoEcPNL6RZeXzdjkhOUvy5MYOwcXOfvlg1sw
 SyGuqlwwZSF.41Obw3q2PgH8dTILWWaFvZJPJWJKuJX.pNwQ8DFA0JBvsR0XB3HLEZEI98rWRDKB
 _vRcn7xqQYPDGEz66WBLKMrmJC5uM3xrkZooaPhUb7ZQKYQ6.SkADF_PbFmh8y2SrWn7wg506dx7
 UVNzQBwU63dxw8jJxLGlU9dkBgb1cx4KKuIW31v9pKHZzq_SdZTe1pgf5qicqdQ3sk2LsI5d8a2N
 sthFMXyLl0Jse8DixAlIZ0khqQW1hPVFmBoPn_KZeggbguu6DBKUDb_7OEi4iqzpGLsTxGZSmcJe
 _.gf_O0sxAdst7CSZ6tJh4FoOV98lSpScA9NjtIhyBGcrcd8kHGUQ_HjnBsXnpjPe7n5YS44yLWD
 o0bSkT5TutT1hg.JY_TgIaOsMHDdegZAQxTG4jkV6I.4zKzCxjW8AdqGYnQaZmeoVVxCGZqNtDx6
 CutUkIKYQAsJUd6oREqQY8a_ID8zM4wrOoki8hgraisvHnw1.dyc6wOkWTmlQT9dwjqi88_MmFRV
 LQ3IBIjneRN_ixY2D27q.IedA
Received: from sonic.gate.mail.ne1.yahoo.com by sonic302.consmr.mail.ne1.yahoo.com with HTTP; Tue, 26 Jan 2021 17:00:11 +0000
Received: by smtp420.mail.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 4d3ec7bb1b8474480809fc15e7b8ec0c;
          Tue, 26 Jan 2021 16:50:07 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH v24 08/25] LSM: Use lsmblob in security_secid_to_secctx
Date:   Tue, 26 Jan 2021 08:40:51 -0800
Message-Id: <20210126164108.1958-9-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210126164108.1958-1-casey@schaufler-ca.com>
References: <20210126164108.1958-1-casey@schaufler-ca.com>
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
index af1d69b41f1c..f786d8833e7d 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -533,7 +533,7 @@ int security_setprocattr(const char *lsm, const char *name, void *value,
 			 size_t size);
 int security_netlink_send(struct sock *sk, struct sk_buff *skb);
 int security_ismaclabel(const char *name);
-int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen);
+int security_secid_to_secctx(struct lsmblob *blob, char **secdata, u32 *seclen);
 int security_secctx_to_secid(const char *secdata, u32 seclen,
 			     struct lsmblob *blob);
 void security_release_secctx(char *secdata, u32 seclen);
@@ -1355,7 +1355,8 @@ static inline int security_ismaclabel(const char *name)
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
index 1ffc2e059027..72f6672a445e 100644
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
index a8335cbe0091..220b3a7ed326 100644
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
index 84caf3316946..d4902d120799 100644
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
index 1039f8a8ed09..271584938404 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2108,17 +2108,16 @@ int security_ismaclabel(const char *name)
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
2.25.4

