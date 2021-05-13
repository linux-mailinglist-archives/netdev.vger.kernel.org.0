Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4409337FEC3
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 22:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232555AbhEMUS0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 16:18:26 -0400
Received: from sonic317-38.consmr.mail.ne1.yahoo.com ([66.163.184.49]:40446
        "EHLO sonic317-38.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232633AbhEMUSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 16:18:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1620937032; bh=K+g6ymJe1BwDYckxJIENQEgzeJI9bR03NQWSV9PeId4=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=DrEPIeikM+mVF85KsdSGoY/aiMiauhJ56o0Af8Plypsc6sswELOiFgg3jzWq2d3Ofp53N5CTW5eD5ZuH9ft3HH/GQLizdjyP1hWNklCU8kloUDS2qgbbanWKPAKejm+RrY8KuTPSrlLlxHe4p0PJw7LiczP7bHaV1JNLcg5pl/E17/MASBivWuZK+BnsZCEKvOeDW/SrJMsJ9cv52SZSjzzjKXQs7fmXlqFipy13H1bh+tpHxBhE7C9tUr8uZGGwrRN9qKYrEBj+zUU7DWv62ImJakl/+3tk9DpiLWfYt3aYOnkAtxLI4TfWUZpiWEA47Dbj18olM/OkghIvcLlH5w==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1620937032; bh=DAQk3XROJJRhAfhdKRCd2zCtzYCOllSYx4VPu37/k9t=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=L/6x8gyf3dss/6/sfk9CVMxA7inkQqJ9rhkdaqecwMKTJlnZ+wpYo/Q//McqGOTeT63r8plD3cd0AanrnA5MCk+PyctOsGgzvKiztewYRb0sje7WPRv0GVy0rb9SnJucaFAwUdIdt2nzrXJRnseEkcCeaDEi2eEpSlKg8ArEWgMYaccbKDuCJyr5JILrs0zmg0OgbzELm2GO6xH7rlPuqllWg2JHTUhqGrkrh4zrKD0qEEsPkDVaFEXeSB0De3iE4L8EGz1QwA4KgcBjL0DSxtOu1CFljHVHsCITz4yaafc6WIHIJY/MaRmvJDY4s6hHkxNPfiM0JkC0uCwicAOI8Q==
X-YMail-OSG: nSPVlT8VM1k86yeXJIWFUsaD1jxHwXWDgTN3Uu9tehskZbdGxZij8zj0cEckzOd
 .MBjPD41CtV56BRyXZ9BxyMBdqBDH4kPZlXGkBFEzERiAwJO1k8H7FaXaMHfoWPheVEjBYlQlSnM
 US72gcEK2kN2qelVbJDbYJJV2n3cmkVcRZ82ZiD2t06DmYmewh3IRgaUQIHOHMAb4gbKetZnh29Z
 n2HM7r3aRCvOPl0dmLNDqzt2bRlvg4LPNxJz2QBiFx0yvA2OfEwrL4lBz17Tv6e1Y9MsyFpL4RIv
 gQ.eJZuryaHA0EAZTYlwUi1dN1WAoHwbas8thSUCFPn46BwFdljtUeJo5LZBtT0nFXG4EADC.CGQ
 ul32w8t40z_MuCGnd1ZVfo1QW9gMhifG73y25HdoEZTPY.oJl.0ksrd7h6R.yeDApMfceNm6LJtS
 ZGiXtv4mHMdK_Wk6ksgAueq8swv1p7Mf1Rt9oN5kWT3VTJqPm_A3IvOYgEH1JXgqskBrRBM_2jnS
 dwICvItw8FLJEQvgSHKh0shIUie6DSQW9nD4JwvgyCuLefEsv2924OkQ2KF7t80HnCHS9ThKBRJz
 t1NPCwZh5lNcvvmsII1qB4CA3NuSqIsVjbP9_G_nH39qvMY8P6P78A6Z8qeUNPzT19rclrfTciVS
 FdDuSjUyKnhWRE95LJ8_DJ6VetbVhWSFsSOyF5228OcaJWZxpFDXydqQStg5i6J.mwG8t8RIwklh
 lc1dr3lHOBElZQHYUE_cKHsQr7_E1DB93V3Hu2oTXFNROlYdmL23Ik28ASql52ya3XE4HPXapn7E
 7ihZm1g3qX7xm1Z7jT13nld59SD4PlMS05pOcvjG.oxVQr359i6aVF2s4E8xuN4nWAIRJHi5oFuV
 hLiF3wN935az9Q.lljuDBSEGG3OXMJaWFJcU8Zob4x6LMfBv863.x9e9SLiQWLw19f5Unm7M8awx
 InOiKw2LALLA.PCY4Mam_dHy00vPjb6.sD51lJlEYEY3vpmqPF.MbqbzRW4D82zyv07LPK7LGYhc
 fqctYMyLXej_ZjsQ9vDFsLxKMd0.N2nflG1B2oWc9agcyv5Rxp2E6IIwn2SCDrxR9IFi4cZcnP4X
 bz.CUbE.FXumDQdCUc_tv_LjAuUDamefM3G6Z73_hkrOkm2JjtaMdVqscSls4FYJZzDBFSaur4um
 YWbw6d7UC2ThVDmlSagqVzWUHN2siG0cy.y2OhtSzKt1PCHu95orMWgwaYK9K_eSeZ6oJ94G.72e
 dNcuYc05fe6GB0XPLqgmz3JDBUKY3ebCFpT6itZZtA6F1gsBBmUFCa9I_2bLqWZxbkIO_Mqn7c5s
 FKH9Xx2XzV.0k.ndXdAIbjBKTKvkT.oPPZQmixKmTG_6l9CAljqq5gKHeQBEgCfsXLQ_xrgmjeI4
 0LPbUxeV_8Kl7oxLcKf8PAqZ2kHybPFuOTMU6sWfKj.HWek.7jm8s1g2JO4a_AC17YYBO54CW2iF
 j.k8NqoirCYmw4wM04T1QN2i8bdeKK.i3zDW8Oe4ZTGbdOY1bdGEkofmFRJ_VjYAr6wp2IYRMjQ3
 nx78MWWXdrNNAVhLLQWt_7PEkVMGOsCn3Na7gbWaDx9939ZbyiXNovlXp9.x0Jc_5ApTgx9N6hyp
 eedtU0x6Jd1Du4wEHRrj1UDpLSrXgiiR1qrStmwddBOmtUJRwLT6wowc2RjkujEz_C.J9zQimSnf
 76im09jfT679QCnLby5FUMQ9MXebuel5ZNKQVHVmZrc9DkAFCUtwyasW1J9uKq7lY3NBm79DbSzl
 U6ABdygZ6eP39aHKPPVIIM5LE4u_SRxDuAgftKisDNm8XGmc6oz_PqnXildv5Qcc09IF_5NJAj2F
 4UKXLPwO1xanh1ptBEqWqMjJW4RQxgwnEy0A8kKUKjQ2x.U4FZx_T3ffFo5QHoycGNv16lPWcEjN
 fBMemLVSze8uZ9hbImvxIWQXJ8xbHXZCdjqoqT.JhPZbSsOIJYtD5WGcU5X2itfS8Qu7B3GhEwPw
 wSOj33o0UPg36YE0h1dT7xwEYgH0EzhJw5J_P0AiTgt23LlL93Nvaa7V_0G2ceYIL4dQdpZ0IyPO
 HMobCRTWCSEJAmm9f_pPX7gJ1aXR_ncj7ABdHfi7oOBjdMfawUosMjsnytQO_wMzdLk3aCVmcmXn
 yRGVyoxH.q4NLMqwkyRVsx78Rt.GTcQcNrBz0t.p_NUcSEjHZr.lNAykWl0QY_EG1p9DIqI5VpZ.
 3Bmi.bFtFY7hTk6YAQQOTKRnIYn3ysfSzYzWAZMLvilE74C9fHOKBc_3ufrCOUe4n.eONRbtS2kp
 TBW8hE4I9Pfp0TJl653zLjN.KNdvZftcEGy1AkPoyi1CnqSjeMR0JKOKkBK5LYWZPF8qTpzfHFSO
 AxsVBN87VMexAEYVj8WnSemJint7QBTiu4JV1HQKWA6JcAGoUcJDVrTvOB5WxjyhDmcydWEqCcKw
 5jbjtqxVKbn8uDfRjXEoJnrLadUcl.HHmTHDkoRwSG8tzYUVLj9TfmpQgTj5RmMwulJZN0Uh9vBR
 CwFNOj2m61M4J9_HaNYKR7ohKva68mu3TIMAfSFle2.hswUJRIBekay4v5J7mp7mqwSyoVoF2di7
 6iIL2JgvBoyCMKNg_e47D69V8ocjp6Yg.92hKeyoSVfh9ZQZTm99abfHx_w9IouAGks6y0srynaf
 Fq4EcTZWBKNs4Sf703tmLr9lkVqfJGqGmYj6JoQtaEg5CH5WESMmpAEZ8GISIZ8P30MhC_EJCdz3
 RBISUi502h7YbKXCRh9_yvxUw1ZRYjV95aoUmoDL8j_GwO4T3zaeM91h4cMFgJufY4eYBuyhqj0Z
 xjVzL2Dxxyi9tYMOMcIgqNgJFQe5YazxISzKzEKyMUJrY0nWHGRC9heBH73pLo3UnqVjlYAwwYJE
 jv5hAn5fL4gwT14HUBsOP5.tx9Lo1NbAhQFnv6_36jhNO1_Dp2NuTHo_eADNV4yjSjqcoDvGo_Ms
 mG31jafIWKSjS9KyfeLyB2jPAksECEnU58jczHw69hOhptCi5Cc2K1Kt3GIjh2_PQ167ZmTQhXjj
 hNhytuQ0JINuvW_M95xmBAbDoyTnsqXQT2rsrsiaQvUn0COtJQnspA7MwZ_GacBLARfJT9re4yXV
 WoP8YTrUbU5YfqgrBJQ1nndEpyYEYz_YRp0DEuQIY3rWadPLoUqvmUx2lpZ4DOoE.ULl_trpqtit
 9.tt.yT3JAtpSfWE0hHVTLOHaAEvv2s3sQVrsvgh_cd215_BITspsugxEx..KYtxwIMXPXpxBCVz
 fng--
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic317.consmr.mail.ne1.yahoo.com with HTTP; Thu, 13 May 2021 20:17:12 +0000
Received: by kubenode508.mail-prod1.omega.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID cb03e82022346e6b80364451e06275af;
          Thu, 13 May 2021 20:17:07 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH v26 08/25] LSM: Use lsmblob in security_secid_to_secctx
Date:   Thu, 13 May 2021 13:07:50 -0700
Message-Id: <20210513200807.15910-9-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210513200807.15910-1-casey@schaufler-ca.com>
References: <20210513200807.15910-1-casey@schaufler-ca.com>
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
index 61d34e1dc59c..193397a1fece 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2711,6 +2711,7 @@ static void binder_transaction(struct binder_proc *proc,
 
 	if (target_node && target_node->txn_security_ctx) {
 		u32 secid;
+		struct lsmblob blob;
 		size_t added_size;
 
 		/*
@@ -2723,7 +2724,16 @@ static void binder_transaction(struct binder_proc *proc,
 		 * case well anyway.
 		 */
 		security_task_getsecid_obj(proc->tsk, &secid);
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
index dbb1e5f5b591..5a8c50a95c46 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -547,7 +547,7 @@ int security_setprocattr(const char *lsm, const char *name, void *value,
 			 size_t size);
 int security_netlink_send(struct sock *sk, struct sk_buff *skb);
 int security_ismaclabel(const char *name);
-int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen);
+int security_secid_to_secctx(struct lsmblob *blob, char **secdata, u32 *seclen);
 int security_secctx_to_secid(const char *secdata, u32 seclen,
 			     struct lsmblob *blob);
 void security_release_secctx(char *secdata, u32 seclen);
@@ -1397,7 +1397,8 @@ static inline int security_ismaclabel(const char *name)
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
index 121d37e700a6..22286163e93e 100644
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
 
 	security_task_getsecid_subj(current, &sid);
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
index 71d894dcdc01..6e977d312acb 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -671,6 +671,13 @@ static int audit_filter_rules(struct task_struct *tsk,
 					security_task_getsecid_subj(tsk, &sid);
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
@@ -687,6 +694,13 @@ static int audit_filter_rules(struct task_struct *tsk,
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
@@ -993,6 +1007,7 @@ static int audit_log_pid_context(struct audit_context *context, pid_t pid,
 	char *ctx = NULL;
 	u32 len;
 	int rc = 0;
+	struct lsmblob blob;
 
 	ab = audit_log_start(context, GFP_KERNEL, AUDIT_OBJ_PID);
 	if (!ab)
@@ -1002,7 +1017,8 @@ static int audit_log_pid_context(struct audit_context *context, pid_t pid,
 			 from_kuid(&init_user_ns, auid),
 			 from_kuid(&init_user_ns, uid), sessionid);
 	if (sid) {
-		if (security_secid_to_secctx(sid, &ctx, &len)) {
+		lsmblob_init(&blob, sid);
+		if (security_secid_to_secctx(&blob, &ctx, &len)) {
 			audit_log_format(ab, " obj=(none)");
 			rc = 1;
 		} else {
@@ -1245,7 +1261,10 @@ static void show_special(struct audit_context *context, int *call_panic)
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
@@ -1398,9 +1417,10 @@ static void audit_log_name(struct audit_context *context, struct audit_names *n,
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
index 8690fc07030f..caf3ecb5a66b 100644
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
index aaa55246d0ca..b02afa0a1516 100644
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
index f37a575ebd7f..bdbb0b60bf7b 100644
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
index dd18b259272f..534dee9c7b6f 100644
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
index cc61dd46f517..67140d6c17a2 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2172,17 +2172,16 @@ int security_ismaclabel(const char *name)
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

