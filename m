Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB263A385D
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 02:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbhFKAPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 20:15:39 -0400
Received: from sonic314-27.consmr.mail.ne1.yahoo.com ([66.163.189.153]:45911
        "EHLO sonic314-27.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230059AbhFKAPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 20:15:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1623370421; bh=NhU/d3Db3zuCYWZxZW/jmwX6G1B94MLUPpcrS0Hvsvo=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=PFMfeTNvE1uZp+5rdjwDMIX08Wm9FXfH24jHu1ekvvf0Rrym7tmpA60r2zvS338Aw+bp9ShVn2wvS9ved6zozlUViPWyA+1LAY7DCY1W1DRYZxzSXE9lfQffUQT3oygCnhQq23ouV/kirv50ikQIPjbKK8y6OZVtLdwcGG/XxGDEkcWH7VG9HcW+SgzZqlCQ5zTxky3dprniKwvCua/dq2grok3F5TR2MsD3wVou3LYyuN1bFDJy4KA8/M+5yOu4yUgaBaxgwlMoBypekLnmiV1nw0Nd1AB/IQXQ85QmDQFxe6iXI/X0yru4vqjyPGQtXvMw4cYE+/SjakFn7YU2Ew==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1623370421; bh=O11C2vjmtb2/+cXMGpxcWPpsnWo7vnymVp7x1AgmVq2=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=hIALXKYzYrF34GxF6V22gCVGXNXmF62dduvw8mpU/z0WZMZYOodmpFDRSLFEx5Amwir+tYdCk9NlpNv+hnpyN1nEUMVcYLXBYPmkNJLiV+2pPuwK58e2bGVP0DF6RMlyquPLNPgJomPIOQrIRo0+ziK2/u6a2qUhbfsutU17V1X2qDMe98/di3qvWY+aro+i+VnfR4aQ3PJoiIEZnoXba7L90vO7gnzG9YIv+WstgSlm8ohaagxgu/mbOiOqoq1pJ8pOh8FDr4U4820CCDph4sbWtxHq3aYGwkkbxGICbvGOLbe7khZQOicBp0iY5+yuJ4dDovVJ2v0RFChGbZUmUA==
X-YMail-OSG: _D_Jq_QVM1mwmGERgeLqyJzizyn5Hs51_8rhQb9Eq3fj5Yx3H8hJ88LN8KGvDpN
 Lo0DQwGmkh8DiM.0gGZM200ojK1LwH8nxy3DcVSksbb6fcop1.32RGJrSfVWX66B_woVtZlfSyQp
 KMUtyVIMiNs_iWuPyxTKeU4kHRWA6Pl.P0AGLZuGiDL95XwA4xm.e30JSLJ.B4XZJ6V1t5xmU8xr
 gb.SHNWdbFfMogeQ_QqdmTPonpa2omyxRAkEnc.lTQxLmocu5hWFO9isPPEdI9Ie8neArlJGr8nC
 hxMz2TeeGaH5S9SXv.FwANDxGjaj_nsgd2RqiLqQRR2KSQlEdo32e1AjdH221GhwU9XFRQn6xagb
 BCCaKd1u8XWtfVqvUjzmNmeZGw1XAAPVH2FdLChs8grsNc5jVmbjLSC_ssUEw_y.OwqbJlf90UxB
 VPyv5P1pkEWJ.8sLq7OojCHl8jGHTrL3b8zEBHHSPsoxG4wNtLoVnZv1rw4LvHQn2mGWOjN.FvZe
 f.J0NvRejTwrlxW4r4yTml.L50vUEjg1lZOxZ2hAuS5abdHV_rcXXlRWwcNIpVH3FjIJjR9doGva
 f4gILceDM1qK_qsLLF1sFGr1mC5d3qLjFAFodklwcVwHjjVEpXAjqqRj6vFjF.z4a0WMGEBCDbFb
 p_dPcA82G6vOeudmy7js7l59.VA4ACxxI9mmtarmV42ZkpYSpiv36pePv6sVf0DaPOrCYhcANtKC
 F73j8Dpn.Vo_azSPNbaXqGjLmoUVJGruOm9TS0x4yHEyBuTxcwFh7eUE7nDJRedgccHUO_TXXTYp
 RfYq6hdZ.SP8.Z9C4Lfcb4VLwJf.CG1Ot5gH9WTVKdx8.ubz6zRjdt81nKnn9E3zLev5.BiuRSJS
 vOX5nLOgiBrJ_TzB1m5Ms4OBwaMZdQ9Jbc0Cs33HOSGf6.1OWyINtqD_kwS0vxCYzrIYfQkSHAip
 QOSeh_6M5Cpxqc7QkvNavunNY4gDC6Xml2Hmj_gr_ejnsmK.mLusk5AedjngYMWVC7pNiw2hrAoS
 y.2D8z4QAUWSyg3tPowR1MWqRNLJ55lcIrtS7yd6grWTaM6DkkcU1ZxpAg3fCZtsiEvrAonzJVE.
 IiMt2j.3fK5tQ_NAh._dwhnkRWFc2CzFL6bS4YR4okYMHlaGG1hEiAIEKpNhwu2gAxs30b6jeNFu
 N1cciqNJ7NMv1IYistbza7zRXWXx6u3TZaRltwBhnXpUwEzz0ZcKHJe5o5lc.YUf6LuS34xAefTV
 vLTQJnBhRJeXth5oIS.Zapi887InyPW65gVgTreUH5W4eysYfrvc6brIhb7nXBtUZ38GDrratOq3
 EWnlYis04cu8C0jfMS35gOBQE0kgoJzpLDJwDJwkigxIm0_77m9I6hnM2IzzBPuWxVdCpfoSVmS0
 jlywhh4IsH6uNt7cRlcu6YooAjg87hW9dsm5156JF3.IKDx2J1Mvs1TVXy_GIUdR7d_HOeApj4FA
 zWjh.tulIKp4fIDX6lIZ01OTg5OsyTodPE_NA5LuKin8s_35MWQti229FOTOPY7TWHm8ljmA.zCN
 fxg_QlAufFz7g.5YfWDCNaDrCgU48CTSJb77.Uhc66jGmL2m_dT4gqfjpKLoqNyMPx6zA9OjfJkE
 Egr_H5zF_ItKM7GWjgFhJifuhMz89WnDTQ8x_ZD3NdGQ4cww1bDLA_ixJC.g0Tr8wIbQ8ea5.gwt
 R2CO0Rmlz7lu2h4cNedcnN40wPaddh1DBnYFnNgpnoHoScFevD1YgfBvDsgVh3jMNnkAsmjrzwJD
 QJugXLzsGrRQwAW6fU0qC5LRf70eUrcGpacYnI_3vrVuZKYemRvw6E71pxZ6DVZhy2RrycGO5tXe
 8Q6Rz17MOHMrqIthD0AqB1WX.VNU6xO6xYHmIsSB4aKrp.kwStPwSN_GKxKbu0BV5HjxVYeyhNJI
 WENR2radB1d9zeG8hnm98G6WOKyE2p.7GzYVSxNm.IUA_ilJ7gZW.gZahWoIdn7_WbVDQI9j_V0Q
 hzl3bHsirWngtB6ekn.puBOpsP.YZLUjwraWoEjx0GjgaMdTYeD1ns7Gc8GqLh9eMdbNCYCt9yst
 E0xdjMYeSkGhEfdVro56g6qiIOW0tjH8Omzb6k.o8GrLf8E594JKZEvv15x2mTajfX9foVTaZVFC
 fHV.s.U_hlLsR7ep0NGlEJwDLXAkTRNqgpvYPdoVMiFvzJWZqKhICzusJ51w2C0G_jP88G5n2BE1
 EKe3rsI8ZDQcerx3_8TE5DA830pZhirK3BGXnj.qgQYcw8yGirQqyyEjxVCNL9Y4WjgQrjqWafT2
 EOfSqDmS3aKE1j1wZ_A49FoKvEdtBlne20KqBRCHQLP9OrQsxz8T6DrcMJRTyEyPIaBYcnDqhgiQ
 nyHBYNQ.ysWetN8WbYtPEhFf5HjQ3mNqGsDTZE6CLpGXcPDKlGQN4xOmaWJMb64C7P9zi_Oo3Uo2
 T.FNsvUvGNdyzMJMqZ_2dhTz2ZXgJ9moSIvq3DCnAqGUKjZH5mZgKgKRwwaiHT1ry3nK63iESLa0
 p.N2kOs7Tohy_By.3yv7steKEEeCfC90FrIAyEtgGBDWgnlgHS6J.jzvyWbYwe.q7TCLlE2uS_PC
 GBUC_ruXMl4bMbc0KVvEHjQembDMHRa9S1xyBE1wpi0hKI1tE8fBZZ6apujeaINsI3QBIuz_Hv3g
 BBZhZ.KyeXhsk6AtuNzbccans.j3u_rUg7saPf9unxLDAR55Ium7SDl2AamZx8sR_eSmLJaMhI8n
 VEd8rLOCCFzvQc3ZzTMbRUiMx5c.SvwGCDk4pxV.xgQd3YN0KyyyWuLrvFi6ckB9z1Knpssr5cBu
 A5RJ18dM9.zxefeGrNdg3khx.2emwghpkZUM4tXunTjI4WfwMg7GTmOUncfpu9ahaEJmDmRhD3uo
 M_4Zfa.TkLDlKMXDVwcjFRgSA7GB6f.alSqTDp_qHlT6GFv.QAKYXWQIkKbBR7xk4b3Y55MSvAtW
 oAbAvyQmsl.2esCXd1Mvh8.KBwMOBgnRZ1vTc75d10r14CzWa6Tgf_YB0x7KypYmXiKPpPWoCNOg
 3w5nyXgCDCus2akrkJdAjRgjy_5H3SczfA1FYlXlNfaR_kcHj2oMvcYLUS.bhOhJ8H0726GPZTBz
 NshOQkvKKDkmkLAWB2SIjBC0cq45O5l7Qz4CZmDl.O6GBibFb48vpraF3Zj5LkR5g9ZycFlFZPoD
 LO2dFI5nlf1IvlRanhy.n6C2XqtmF_dAGZseNCJTwCjMDtWP0QFKBWZbrWj6qIRqZNZOeai8TTV1
 dsr81Go5Z7dNuiObvrUvw8CRixMuJn8u_rVHTQHwkUb4EJEraEW2..Q--
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic314.consmr.mail.ne1.yahoo.com with HTTP; Fri, 11 Jun 2021 00:13:41 +0000
Received: by kubenode557.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 58617b8d910087d304301c88d6db5406;
          Fri, 11 Jun 2021 00:13:35 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH v27 08/25] LSM: Use lsmblob in security_secid_to_secctx
Date:   Thu, 10 Jun 2021 17:04:18 -0700
Message-Id: <20210611000435.36398-9-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210611000435.36398-1-casey@schaufler-ca.com>
References: <20210611000435.36398-1-casey@schaufler-ca.com>
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
index 578c3c6604f0..b0faeee91d02 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2174,17 +2174,16 @@ int security_ismaclabel(const char *name)
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

