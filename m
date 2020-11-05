Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7C02A7421
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 01:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387930AbgKEA4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 19:56:36 -0500
Received: from sonic305-28.consmr.mail.ne1.yahoo.com ([66.163.185.154]:33440
        "EHLO sonic305-28.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727923AbgKEA4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 19:56:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1604537794; bh=2NyewPO53/4iI2Tr/R68jXRbY58jiTgqBTe9D9i5YK0=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject; b=cZ5tb5lww/TOLmJH8neuejTKvWIXPLLQTKNRjWr8NXg5IuQU4zdLYKZQdJW8LIfHPHB3vfLW9njfdSAjKUS3M9mqsG3VAEDpa/p7h+i7DpY/SChyVlbxvNzxeg9o8At3n5LWqt9+4VZo3bXUvhAX6VXdJzSs9bzg/CFGxI86D0Ht3n0lzq4oDXtRO3etzG8acwGDfxysmLYm6tteLR7CrUBc60lS1SfAcbGjoZX8nrru2mk5j50uWdPnDh299OBoFDWpfCtFxk8Wwn5mwJz2Jnrw/ESxjMBF5VS5L0FCURWEBzvc1Iyt30Z6x6qxsELYFDwyqVT9+3eNq3Isd2muEg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1604537794; bh=rjRA7oKQSTliFAWaie/0qWKj0KcJxpZiaNbTsi3OtW9=; h=From:To:Subject:Date; b=UcA+CQjoCr+GIwccJsTK3M26WliOn8PvzDz784EJZ2G3Vb7TSQKevnOOk4IE7wOKqWIdJbMcO+OcIOqfhtfFLVeH56Ud7uAwYGAeUDEresW2w6ttQW0FMFW+FoH8hiuwWkoqlFmMgv8h21CSBnpI+PkwLTcx/OeE/dczql14k5qQeygeOBtcepTqy3NN8IEGu9SSPoVBJGtUZMPNor8a3z4hvGzXxw0WghbgUzoVw/RL5OzSK7IMfkJ+OK7HobH/BYkjrWFtsMAo/yNZuJz3pEfLnzTVD6e4QbTGmXEYXpCswmri7xbE2uYz+kuOP5ev7bDJaKQp6RzxifIaOlbQDQ==
X-YMail-OSG: N5bqMWcVM1me_AEXwRrPbVnsXVnpF4SbkPSfmu9JGQFExNMVbXNumopx8DEaYmj
 Si7F3ZCTXlWnmrIgNU15ZfcgAYh2OuHX9GU27lP78mrHUXnsT2yBVpS7uPKFv8nhok77KtgPFMYI
 bM0eyTkv_GCw5JU5dKoE6t1I8ByWth42W4WGXBuJS948aUkZnH9Op5eeW0OSzq4Kl7Qfkqo76ial
 OIw8K9C2f7DVAhQFeBu28165XHnRdWBWVnNx4zE66J2jRwk3wEuF.D0mwkz.McfbHxN0lcApAO4q
 68j1oKsHOCW1asjRo0hV.Ek0K8dHc.XGv2bO_Yxzs7L9HC_rNCrQX8CVyXYGL1FWvox4ClXb8QSo
 b1GpTmU8DA.qqJAhvp0MUcR9vlWqYwybSKXtNiEY5Vfciaw6rM_dA7p9z90KWYJfTDJPrdftqjTi
 l0WzQLbYcRTwsX8HUN0PCHOwyop7rGjw7D1TbfUVvTiozUG0Ws37S5vJPWua9uP7p2ZSnxBn58mw
 uvrdPFGRhjdqFOuFZNGmtWHDU4cWRTqdnstGiM5U3CLPvL1LJW94aL855Fj9koK123xQyr8BV8aA
 fDXWa2DpZDnCXWtjDWwyuD1nXir5tWzR3rjZ_52Umk.jBkcdqQNuluWsmACqBGkJT9kQ.9Vo1Bok
 U.S.Rb6r67VMUlRPeEn117UJKpPRbukVTXRqXVdIlc4j0hHkNf8Rf.iSKapMwy3eUc06eolFaoIg
 cuwXiNpA2li7rJ7VLmag58ErbXORw1Zc4g1O2rGJO6k7UqCsNQYcnIy5ITnSGD9ST_Qf3qIZ8gzz
 DDnjjQobP5hMy4aJwONvFQ5BZKL300TFfKSEcmAHp2.Ewt.Vz_J_fQXm92f6pyOeiMyb6pkoVdLt
 H9imvmoDKRZSci4MSAu5UEjTnJUoxZ26SUy2AcZ_9qYCLS94y5.Zv5BHyDsQUB_CFfFH6iVRo72G
 1sqQUfQFblM4GlgpvvdbfBiVHEGq4qjolvWjM9Rj0rUQFZwF5_ONAWq_5cRnvDq4q2PQbqQG_Y3i
 plzq3bTxrSgK1eN1.WUHVqEyPJAYwNxYxMHDXmr5l59OqcAOEKkblq3ysmrpHUaRvP2nbw0sgEmh
 y70R4ow16W6YN7eWW9ub0ag96iis_AOBjDj79NK25CWk0Tm27lVtF0XWcf4ZyG30jtEQLBFRUwhK
 1jmztI.zS6bFX3fbAAU.Q3dlcSYnh_iZhtw4iw2NUt.P2T_DcFH75VqXhRzMd1oAxcEvn6KFnP5z
 TtICFB1ljcFnayOQ6HrEAmJB_6heWgxEr29O.Eur2bHTt5XHpHI6.OnU0LYYSc_OUHbcH1K1tp.x
 4om5MMGrHQiTUsWomR6LG8j8U9v5bptDPOpYkchZ_l5Irp58_7a_Teg_UEJjp8yLyJXwIf2UGSOh
 lHgp.670SfwMXIKmNKTNtfLQryyHalirbo3184OFwKUPMUggziA91ei7p2_Uzqd88biJpnqqfhP5
 aKCRlmyLESuzVpsGoJiHsuRxPc0VyAYwXCLxQCLsqVSs02kovl4nZrA5axlbGDsHMRbSiPaBfsk9
 .Kw7Oj_b8VUKpRvd1tRiBmpx5HDPyioEvo_Ka5Fon6kZ8S4bUIa4wnREJ2bZ0HlxH58CyrB12gxq
 5olLU.44tXUgDJpkegeq00WhGKpUNmrU0xF8ueu2lGJsT3azbONE5VJ3azjTriPr5KUTKcLti6J5
 YVY9jBKzaxJKvFSffG0l7zjh0_.WahjN.8sSjXj37Ae_aS2jeYxyr8X51F8dyTPKD1YdEQaxJRUS
 KqaLjROlOtO764Xq25CqkAWdmTaMRhi2J5bsWDKiVS6cvs_nMYsFFvpyzNUZzrMuovv1hsm2AwVO
 1QMO5MYxI6bSvb9279Hk5VH4BuONxz1UvND9Mdo3LtlZySOa4DYfXglg.epPPF4WoTkwoN.kNkNV
 ajN8pd1ZIYqJocwDQo4ievbcxhhFa5HYgsvJbNA0kWamyqExsvxLFOVb3emazksGeYgSRc5RF30x
 q2cp4F9CoFHoxrFHSISQV4hE_DOtBHwohpYM1nuKWoDgiZo7b41elxRz8hNqC4zjXGEDeaIVgzdF
 hA7bG_s8sFWefLWfLxK3vkmieuXsso8ifprCx2vNAO6sJB2LQL8yxf7NlO3vDwToS7yD00GrX6Mx
 d2Nn4ynuhLLgEcXsG4CpYvjGZiiZcUUAxkpZ1B_qsjD2XHvsk9bttaETbGl3yBwLSt_KdecfAxx.
 uzQyv.IQEYGsZa69e9pcW.dVr9XfKmxW7Yy9nWmvvvLfqkdc0wn8RskmbWeVQIszElgkHly0TNnH
 KyPHzG8wb.ED8rbwnf6Q6AcEyd73XdJH5ZQACL7RNBFazPkGjEJeSKA7IWk2izXGiKPQ_6CKIGUM
 XoJTtrj8Ji9iLqfQ33fydQqrQ9t7su_AVukiNZyptbw9TRaanYRlJd2zZMgsnpl.FYDsoD3j68tu
 1Pa.16IqWE3hrUUNj25CAL6NFe0Lip7QW3asdAy__ITINGJaO6T48u_7.MLAoa0mAo1C_cdmI5Eu
 32kZNFehhjCgcXbduYcLwukTByQcHE8W0URFo1G6SGBqwbkXYr8rK0F9vnD26GoddmuciI8F9itl
 _Zwj8axcknP2IUg5PU744daOHx4gujE_t6B15hDpzPvuCq.pH3FxPxvxI37La9nVxf5A6BC8oamN
 ZfLFza_YXioqdeytDiZizfMasv.2visYUVbMO9fE3ROVmINq7OxIBXGo2l5JHT_LGq7rQXXQvQ8A
 5w3mfZE1Ch_iJQ6rz1SPK4dPoVIgJaYV1BpoUkHT2vOLzqJYA5m79nxu.rkXVa9Xn4dXkZRy.gM1
 .g0hLv_qod26HyqFntQc5thmctGpkuk4q0FvmZrtmETR_3uV_oS62U5YKiWNNTdGOMXF8HTuTI5N
 s__9f78mUsa5NGaWIJJD.Bg878R93H7j.4D0wGzzajYM81FVHYsRfzNcXx9SG6YzhI.7hgqcSWY1
 Ksh8UXagCL.3_ZawKvM.YXJpv_T_VtxPgEZT1FjeqDxg6aNubu4vqfM5gRa7gGmHFJuqgJIAyUOW
 WFpUfTXmc97LmqM.LFTB8ctAPEsbSseI3N6qm8Ysci4R2ujaKFHyD0OdEl.BZMdel7zHlGRf1Dhc
 UPTwE.5Lw8_wUBMeHOApc7WnqgKkreLlrmklUn_u542AqFH._X4N2p81YV9AR4tdMEwC9z3IgIxW
 n2W0XpRR38YAcbsFV4pmP8Zi09f7grIduEHo2za2pI8Xr.MZ2UvSG6GoEZET_0E2csdfC0UA288m
 wXPswW1gP6K7sMioQ8ivrMqtC7wybM63pJ2j0jSBSyqHKIbTaEJTRE67L1mfOKDzQueLjRHK59XY
 xgrtXP_AHx2vwg1_YoOV9hE_ISQy6tfUhW7Pu6_q4oBpR3ceRug--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic305.consmr.mail.ne1.yahoo.com with HTTP; Thu, 5 Nov 2020 00:56:34 +0000
Received: by smtp417.mail.bf1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID d32dd9481194f8f302170fa4e066c7cd;
          Thu, 05 Nov 2020 00:56:32 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v22 06/23] LSM: Use lsmblob in security_secid_to_secctx
Date:   Wed,  4 Nov 2020 16:49:07 -0800
Message-Id: <20201105004924.11651-7-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201105004924.11651-1-casey@schaufler-ca.com>
References: <20201105004924.11651-1-casey@schaufler-ca.com>
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

