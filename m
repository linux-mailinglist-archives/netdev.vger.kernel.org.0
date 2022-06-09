Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC676545814
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 01:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345925AbiFIXKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 19:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345907AbiFIXKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 19:10:11 -0400
Received: from sonic316-27.consmr.mail.ne1.yahoo.com (sonic316-27.consmr.mail.ne1.yahoo.com [66.163.187.153])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D8E412F0EC
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 16:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1654816207; bh=11Yl0L6BEXDtiUicAPpo8DaV+47sQMhyvYBeOsS8N3U=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=q485xN6wCCfj8tFJoD3/+kpNQlVt6bvb4+gHxP4okDSnpNLrAM6woDZJyPYEbA+86WP5+u4G/5SahMykk0JTy1GlhZgfY4RRqrOwk9Cb0MAAkFN//BG7B8aIms1L80Qi5zTOKhSeOfmCdkU1VXlgiF/ShlNsUE/vnp1UYg9KiGr/BxKxD4b2XvRFIiOtxluPmgVJlBQWIhOsCrwPtbxho1Wj+Uw1A6FKXt3gwIK8ZHAR6Yd9kz8bTiHnpAZE6nLalwInCmvc0Lw5CLh6C+Q5wApf+l1vT8xKAtD0nV7mQvoy/CPmr4utdhhDhuqZF5eXtHUAIxC3ThGYExkTvaTZLg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1654816207; bh=g/GDnGQLQhw/3Hwg4EqIRpY2DMXDEREWOOiXABwKWUx=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=d8RlmK8s68Zax15U7bKFyKg8K1vvT4Z6lB5We8SwBMTnSkaKpJayCeEN5uSICRxMlaDBiSRAE+jRdzfQBBC7lvFj6wEk1ebgWLBacHXj/RMYP7aVtNifDhiZpz1yDyGpw8kNfGDmI1uvCWZ9RSipx23dEsx+kFd5X9WxI7NTjsPA8wV/fqfpa3WDazdynDXrqmANzrOXieVXRy4gflfrecI4X4BhHrdYSZOk3eKRkiZDeG5CgPybQ+9ev46c8VnNhKyUJj70tBP0I8OZWdFNTEfZZoE5Bpw9KYa4qEIjxQ2gTCuGKv569PvSU8w3YNVprEPgcUIE9iKjhmDYpn3Hwg==
X-YMail-OSG: dNeGoMMVM1mnWUs7SV5csfY6F3BEXFvmofWKqDdDsjLfSjja_IVXhw2nd4mRpuU
 w7wkDcQAPzMrGxLOqI94IqCDqypR14rpQBhckn9rVuF.JZvx_e2S4SGnpnEMo8geEKQML4.SWV9w
 9CWzSOEJMylhjwtf8XztW0NHD9AWZOKtHwrGjYKNJALCbc5U8aoQQYX72SfBvYt4mo7KWYMaSMD.
 g_vcZWy..mJlVAZzu.rPvdjTM0Zk7LTfub6roan33jXiDUyipMlQODNHRfd5Pc2_hCbSJKu_cqz.
 ozih2nrY_GYg6AUDlKWOkuv1kPHolzkPie1EoQTbr0PcbLjA9F8JXz.nICl4n4Mf_qwZnxVbkNmk
 OlBn3x.6QB7.tJGDmiBuQEI7uWrUKaeTbJ.UXEVZ9nP54_A0uM.QmAH6po7MBaqmiGpCImvfqRJM
 hS2SFp0_muGjzFy_34PlblukAkb2rolXnJ3gaT90T71wlPSGEZgf6bz1LY5oLyIEqegtPAMj15CN
 QtH8c_BnWp6wI0Ekt6g9DhklQDXmUmFREsuFyCunXvtdU3Ohg0Kny32x4gzQp5jcbALZbvrXVASZ
 xjXx6IzT0yTdL_y4WXalA76EgPJi1K0zdlYnAF_a3keQnUWSCMVuQr7TKBM268Y8FL_7ud6xgTZT
 vZMi8iR1sGP5jxbIsxZeyUF6u8hTHfLCe75GwPRdLm6kJ5IGtQ3Rh16PyIAPh397uqMVGr0SGHz1
 pfzXGN0Pt7_KRPLKkEU.8Riua_ZGM1MdyDpBQK9gyydRUY9uVewtBnyR7flgMyK.RKlZ.Gb2o57U
 7JSjnTyJoMFRVzJoIdUqJP1M0mKiSQCWj0fuWzk7vO0tKm9j8_hOQBk2vF2ZF3lURo4ETgpaHpbp
 ajs9VAj9SEHtVwqiA41w_eaXED1xl5ubWgEMxq5e16yat7ztjLAyGQ3sU8L0tXa6LoyW2aFSRAcE
 4Iu7dsAvUOBvP2e7TJgfCkx38WJ.VA0_GXEsF8.wjS8rT07.S4b_m5kPF17dOk2SkFrYpITgEMHz
 HXUz0DhhBZ_CUOltX5p_gjfVFLU1mBwaxIepXltgYaWXuK_HuZ63DlKgPKTRNug2IZEIeOmteCjf
 ZyAYn4Fkkuljf0rlJUbkAxnup3PUs4MCxwzdlo5A5AhPahg7DQsDT0T0sGASOtEtcBqUGKU34rIL
 E_0gPhOt43CJIjXx5TnwoiCDGtHKw._rc55tMfhpDyDDHhheWHM0uNc_ve7ysQBzKRosON01Cf7P
 JerJUQtBhf4713pKlRlpzp5gttVekzZ5eE9qiDswef93uYEcNE7n84F9C5lxGzxmrnmVSjpc3Cnj
 _RDyfbdSd0vb8.XvS8VyAvfd2T4mUe.GFBFq1l2y244oEOFi9cyPXa6.QKPlm5rSf1kZUUiTobsn
 nIKt_70Hz1635Vd3Wg0dD8xIB8ycVFCMNEwfb.jyLHIzDXbDnoN.GfU9IhbxfFYiQJ1o7VV9IA3R
 YUInHwMzL.CvUUA5wU1PJPzuncbnvrD1LY2uo76XJVvusFh3l9Nl61lWZSSlH5A8Hf_7GdKIvS32
 m3msq35uujGR3zRwcUJIPUXdchc3CU00nabdsuFUBcDNbeUXalcIekdjbYVHqdC2TtYQzGT8qbyJ
 tQmwIRmsPaZjO_FJNyRII2BD2nKewGRjtjvjmTZg2pmFuQLDe8X9KkCqLaV_pR4ibiY78WYMEMHm
 UxK8MzhgStQKUdy120VwSfnHXR15n6scEcE9c_b8uZTMs6CHUhfpMe1b4aS0oSgglV9IY3Z8t37g
 M6WkjmPO6GL.MRMQTGg3EhBVnEEq6Qeh8Txv05ngz7YINa2t0qOCqBgX5qRz_39TVwiXa2pITUEK
 hgp5Q_s_ktXHtkx5RHn75wyHXwXeoaDChgEr8lTuwB7.SLEy.ql6nv6yMWnT6KxfABkPHASZDk4U
 TgDpaul0zTzuTMPL2TQI9a7EEBrptP0g.yTgCVMX3HPepWiz2kvSSb9IPPweFJL.4pb2nkUnnuiq
 cNYW9xIk7YECecMt63Dhm3AOOnrSPaj0bL8Y9WI1Q7isEozrGamuZULDoCfWKOUc79SlsRe.e3sf
 OLBggcrnd1oTVxeCeaFhTehilgxFKdFcPneUQZtHdaTpVcDEHKttbN14zdTSMdvIS1NeMurdDCWb
 03tLvpw5VCFch7WE3iTzU7NhvLQRQHJ5KcNXMRcb9m0dfrm1W35AcB9dT8huOH6avolgqVBV.5eQ
 w9svRzHAWYcde6mxT3_jOvUp6Bc5xaODXnn_6WuRHjhKvtAe_IQOUwtjEsO1v95f3KBuQcc7imWO
 csvdRsNU6thvR7xZmnKuzn9xyo6i_yg--
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic316.consmr.mail.ne1.yahoo.com with HTTP; Thu, 9 Jun 2022 23:10:07 +0000
Received: by hermes--canary-production-ne1-799d7bd497-7z8w4 (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 62296d5a5fc11a6b88291aff65d8e04f;
          Thu, 09 Jun 2022 23:10:02 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        stephen.smalley.work@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH v36 16/33] LSM: Use lsmcontext in security_secid_to_secctx
Date:   Thu,  9 Jun 2022 16:01:29 -0700
Message-Id: <20220609230146.319210-17-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220609230146.319210-1-casey@schaufler-ca.com>
References: <20220609230146.319210-1-casey@schaufler-ca.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the (secctx,seclen) pointer pair with a single
lsmcontext pointer to allow return of the LSM identifier
along with the context and context length. This allows
security_release_secctx() to know how to release the
context. Callers have been modified to use or save the
returned data from the new structure.

security_secid_to_secctx() will now return the length value
if the passed lsmcontext pointer is NULL.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Cc: netdev@vger.kernel.org
Cc: linux-audit@redhat.com
Cc: netfilter-devel@vger.kernel.org
---
 drivers/android/binder.c                | 26 ++++++---------
 include/linux/security.h                |  4 +--
 include/net/scm.h                       |  9 ++----
 kernel/audit.c                          | 42 +++++++++++--------------
 kernel/auditsc.c                        | 31 +++++++-----------
 net/ipv4/ip_sockglue.c                  |  8 ++---
 net/netfilter/nf_conntrack_netlink.c    | 18 ++++-------
 net/netfilter/nf_conntrack_standalone.c |  7 ++---
 net/netfilter/nfnetlink_queue.c         |  5 ++-
 net/netlabel/netlabel_unlabeled.c       | 40 +++++++----------------
 net/netlabel/netlabel_user.c            |  7 ++---
 security/security.c                     | 29 +++++++++++++++--
 12 files changed, 99 insertions(+), 127 deletions(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 9c1ed7fbda87..8ae1a624cd37 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2781,9 +2781,7 @@ static void binder_transaction(struct binder_proc *proc,
 	binder_size_t last_fixup_min_off = 0;
 	struct binder_context *context = proc->context;
 	int t_debug_id = atomic_inc_return(&binder_last_id);
-	char *secctx = NULL;
-	u32 secctx_sz = 0;
-	struct lsmcontext scaff; /* scaffolding */
+	struct lsmcontext lsmctx = { };
 	struct list_head sgc_head;
 	struct list_head pf_head;
 	const void __user *user_buffer = (const void __user *)
@@ -3059,7 +3057,7 @@ static void binder_transaction(struct binder_proc *proc,
 		size_t added_size;
 
 		security_cred_getsecid(proc->cred, &blob);
-		ret = security_secid_to_secctx(&blob, &secctx, &secctx_sz);
+		ret = security_secid_to_secctx(&blob, &lsmctx);
 		if (ret) {
 			binder_txn_error("%d:%d failed to get security context\n",
 				thread->pid, proc->pid);
@@ -3068,7 +3066,7 @@ static void binder_transaction(struct binder_proc *proc,
 			return_error_line = __LINE__;
 			goto err_get_secctx_failed;
 		}
-		added_size = ALIGN(secctx_sz, sizeof(u64));
+		added_size = ALIGN(lsmctx.len, sizeof(u64));
 		extra_buffers_size += added_size;
 		if (extra_buffers_size < added_size) {
 			binder_txn_error("%d:%d integer overflow of extra_buffers_size\n",
@@ -3102,24 +3100,22 @@ static void binder_transaction(struct binder_proc *proc,
 		t->buffer = NULL;
 		goto err_binder_alloc_buf_failed;
 	}
-	if (secctx) {
+	if (lsmctx.context) {
 		int err;
 		size_t buf_offset = ALIGN(tr->data_size, sizeof(void *)) +
 				    ALIGN(tr->offsets_size, sizeof(void *)) +
 				    ALIGN(extra_buffers_size, sizeof(void *)) -
-				    ALIGN(secctx_sz, sizeof(u64));
+				    ALIGN(lsmctx.len, sizeof(u64));
 
 		t->security_ctx = (uintptr_t)t->buffer->user_data + buf_offset;
 		err = binder_alloc_copy_to_buffer(&target_proc->alloc,
 						  t->buffer, buf_offset,
-						  secctx, secctx_sz);
+						  lsmctx.context, lsmctx.len);
 		if (err) {
 			t->security_ctx = 0;
 			WARN_ON(1);
 		}
-		lsmcontext_init(&scaff, secctx, secctx_sz, 0);
-		security_release_secctx(&scaff);
-		secctx = NULL;
+		security_release_secctx(&lsmctx);
 	}
 	t->buffer->debug_id = t->debug_id;
 	t->buffer->transaction = t;
@@ -3163,7 +3159,7 @@ static void binder_transaction(struct binder_proc *proc,
 	off_end_offset = off_start_offset + tr->offsets_size;
 	sg_buf_offset = ALIGN(off_end_offset, sizeof(void *));
 	sg_buf_end_offset = sg_buf_offset + extra_buffers_size -
-		ALIGN(secctx_sz, sizeof(u64));
+		ALIGN(lsmctx.len, sizeof(u64));
 	off_min = 0;
 	for (buffer_offset = off_start_offset; buffer_offset < off_end_offset;
 	     buffer_offset += sizeof(binder_size_t)) {
@@ -3534,10 +3530,8 @@ static void binder_transaction(struct binder_proc *proc,
 	binder_alloc_free_buf(&target_proc->alloc, t->buffer);
 err_binder_alloc_buf_failed:
 err_bad_extra_size:
-	if (secctx) {
-		lsmcontext_init(&scaff, secctx, secctx_sz, 0);
-		security_release_secctx(&scaff);
-	}
+	if (lsmctx.context)
+		security_release_secctx(&lsmctx);
 err_get_secctx_failed:
 	kfree(tcomplete);
 	binder_stats_deleted(BINDER_STAT_TRANSACTION_COMPLETE);
diff --git a/include/linux/security.h b/include/linux/security.h
index a20fc156c697..5afd0148a1a5 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -617,7 +617,7 @@ int security_setprocattr(const char *lsm, const char *name, void *value,
 			 size_t size);
 int security_netlink_send(struct sock *sk, struct sk_buff *skb);
 int security_ismaclabel(const char *name);
-int security_secid_to_secctx(struct lsmblob *blob, char **secdata, u32 *seclen);
+int security_secid_to_secctx(struct lsmblob *blob, struct lsmcontext *cp);
 int security_secctx_to_secid(const char *secdata, u32 seclen,
 			     struct lsmblob *blob);
 void security_release_secctx(struct lsmcontext *cp);
@@ -1472,7 +1472,7 @@ static inline int security_ismaclabel(const char *name)
 }
 
 static inline int security_secid_to_secctx(struct lsmblob *blob,
-					   char **secdata, u32 *seclen)
+					   struct lsmcontext *cp)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/include/net/scm.h b/include/net/scm.h
index f273c4d777ec..b77a52f93389 100644
--- a/include/net/scm.h
+++ b/include/net/scm.h
@@ -94,8 +94,6 @@ static inline void scm_passec(struct socket *sock, struct msghdr *msg, struct sc
 {
 	struct lsmcontext context;
 	struct lsmblob lb;
-	char *secdata;
-	u32 seclen;
 	int err;
 
 	if (test_bit(SOCK_PASSSEC, &sock->flags)) {
@@ -103,12 +101,11 @@ static inline void scm_passec(struct socket *sock, struct msghdr *msg, struct sc
 		 * and the infrastructure will know which it is.
 		 */
 		lsmblob_init(&lb, scm->secid);
-		err = security_secid_to_secctx(&lb, &secdata, &seclen);
+		err = security_secid_to_secctx(&lb, &context);
 
 		if (!err) {
-			put_cmsg(msg, SOL_SOCKET, SCM_SECURITY, seclen, secdata);
-			/*scaffolding*/
-			lsmcontext_init(&context, secdata, seclen, 0);
+			put_cmsg(msg, SOL_SOCKET, SCM_SECURITY, context.len,
+				 context.context);
 			security_release_secctx(&context);
 		}
 	}
diff --git a/kernel/audit.c b/kernel/audit.c
index 0eff57959b4e..a885ebdbb91e 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1212,9 +1212,6 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 	struct audit_buffer	*ab;
 	u16			msg_type = nlh->nlmsg_type;
 	struct audit_sig_info   *sig_data;
-	char			*ctx = NULL;
-	u32			len;
-	struct lsmcontext	scaff; /* scaffolding */
 
 	err = audit_netlink_ok(skb, msg_type);
 	if (err)
@@ -1462,33 +1459,33 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		kfree(new);
 		break;
 	}
-	case AUDIT_SIGNAL_INFO:
-		len = 0;
+	case AUDIT_SIGNAL_INFO: {
+		struct lsmcontext context = { };
+
 		if (lsmblob_is_set(&audit_sig_lsm)) {
-			err = security_secid_to_secctx(&audit_sig_lsm, &ctx,
-						       &len);
+			err = security_secid_to_secctx(&audit_sig_lsm,
+						       &context);
 			if (err)
 				return err;
 		}
-		sig_data = kmalloc(struct_size(sig_data, ctx, len), GFP_KERNEL);
+		sig_data = kmalloc(struct_size(sig_data, ctx, context.len),
+				   GFP_KERNEL);
 		if (!sig_data) {
-			if (lsmblob_is_set(&audit_sig_lsm)) {
-				lsmcontext_init(&scaff, ctx, len, 0);
-				security_release_secctx(&scaff);
-			}
+			if (lsmblob_is_set(&audit_sig_lsm))
+				security_release_secctx(&context);
 			return -ENOMEM;
 		}
 		sig_data->uid = from_kuid(&init_user_ns, audit_sig_uid);
 		sig_data->pid = audit_sig_pid;
 		if (lsmblob_is_set(&audit_sig_lsm)) {
-			memcpy(sig_data->ctx, ctx, len);
-			lsmcontext_init(&scaff, ctx, len, 0);
-			security_release_secctx(&scaff);
+			memcpy(sig_data->ctx, context.context, context.len);
+			security_release_secctx(&context);
 		}
-		audit_send_reply(skb, seq, AUDIT_SIGNAL_INFO, 0, 0,
-				 sig_data, struct_size(sig_data, ctx, len));
+		audit_send_reply(skb, seq, AUDIT_SIGNAL_INFO, 0, 0, sig_data,
+				 struct_size(sig_data, ctx, context.len));
 		kfree(sig_data);
 		break;
+	}
 	case AUDIT_TTY_GET: {
 		struct audit_tty_status s;
 		unsigned int t;
@@ -2171,17 +2168,15 @@ void audit_log_key(struct audit_buffer *ab, char *key)
 
 int audit_log_task_context(struct audit_buffer *ab)
 {
-	char *ctx = NULL;
-	unsigned len;
 	int error;
 	struct lsmblob blob;
-	struct lsmcontext scaff; /* scaffolding */
+	struct lsmcontext context;
 
 	security_current_getsecid_subj(&blob);
 	if (!lsmblob_is_set(&blob))
 		return 0;
 
-	error = security_secid_to_secctx(&blob, &ctx, &len);
+	error = security_secid_to_secctx(&blob, &context);
 
 	if (error) {
 		if (error != -EINVAL)
@@ -2189,9 +2184,8 @@ int audit_log_task_context(struct audit_buffer *ab)
 		return 0;
 	}
 
-	audit_log_format(ab, " subj=%s", ctx);
-	lsmcontext_init(&scaff, ctx, len, 0);
-	security_release_secctx(&scaff);
+	audit_log_format(ab, " subj=%s", context.context);
+	security_release_secctx(&context);
 	return 0;
 
 error_path:
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index cc902c9df77f..8551ce71e6c9 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1121,9 +1121,7 @@ static int audit_log_pid_context(struct audit_context *context, pid_t pid,
 				 struct lsmblob *blob, char *comm)
 {
 	struct audit_buffer *ab;
-	struct lsmcontext lsmcxt;
-	char *ctx = NULL;
-	u32 len;
+	struct lsmcontext lsmctx;
 	int rc = 0;
 
 	ab = audit_log_start(context, GFP_KERNEL, AUDIT_OBJ_PID);
@@ -1134,13 +1132,12 @@ static int audit_log_pid_context(struct audit_context *context, pid_t pid,
 			 from_kuid(&init_user_ns, auid),
 			 from_kuid(&init_user_ns, uid), sessionid);
 	if (lsmblob_is_set(blob)) {
-		if (security_secid_to_secctx(blob, &ctx, &len)) {
+		if (security_secid_to_secctx(blob, &lsmctx)) {
 			audit_log_format(ab, " obj=(none)");
 			rc = 1;
 		} else {
-			audit_log_format(ab, " obj=%s", ctx);
-			lsmcontext_init(&lsmcxt, ctx, len, 0); /*scaffolding*/
-			security_release_secctx(&lsmcxt);
+			audit_log_format(ab, " obj=%s", lsmctx.context);
+			security_release_secctx(&lsmctx);
 		}
 	}
 	audit_log_format(ab, " ocomm=");
@@ -1400,7 +1397,6 @@ static void audit_log_time(struct audit_context *context, struct audit_buffer **
 
 static void show_special(struct audit_context *context, int *call_panic)
 {
-	struct lsmcontext lsmcxt;
 	struct audit_buffer *ab;
 	int i;
 
@@ -1425,17 +1421,15 @@ static void show_special(struct audit_context *context, int *call_panic)
 				 from_kgid(&init_user_ns, context->ipc.gid),
 				 context->ipc.mode);
 		if (osid) {
-			char *ctx = NULL;
-			u32 len;
+			struct lsmcontext lsmcxt;
 			struct lsmblob blob;
 
 			lsmblob_init(&blob, osid);
-			if (security_secid_to_secctx(&blob, &ctx, &len)) {
+			if (security_secid_to_secctx(&blob, &lsmcxt)) {
 				audit_log_format(ab, " osid=%u", osid);
 				*call_panic = 1;
 			} else {
-				audit_log_format(ab, " obj=%s", ctx);
-				lsmcontext_init(&lsmcxt, ctx, len, 0);
+				audit_log_format(ab, " obj=%s", lsmcxt.context);
 				security_release_secctx(&lsmcxt);
 			}
 		}
@@ -1595,20 +1589,17 @@ static void audit_log_name(struct audit_context *context, struct audit_names *n,
 				 MAJOR(n->rdev),
 				 MINOR(n->rdev));
 	if (n->osid != 0) {
-		char *ctx = NULL;
-		u32 len;
 		struct lsmblob blob;
-		struct lsmcontext lsmcxt;
+		struct lsmcontext lsmctx;
 
 		lsmblob_init(&blob, n->osid);
-		if (security_secid_to_secctx(&blob, &ctx, &len)) {
+		if (security_secid_to_secctx(&blob, &lsmctx)) {
 			audit_log_format(ab, " osid=%u", n->osid);
 			if (call_panic)
 				*call_panic = 2;
 		} else {
-			audit_log_format(ab, " obj=%s", ctx);
-			lsmcontext_init(&lsmcxt, ctx, len, 0); /* scaffolding */
-			security_release_secctx(&lsmcxt);
+			audit_log_format(ab, " obj=%s", lsmctx.context);
+			security_release_secctx(&lsmctx);
 		}
 	}
 
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index 70ca4510ea35..ad5be7707bca 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -132,8 +132,7 @@ static void ip_cmsg_recv_security(struct msghdr *msg, struct sk_buff *skb)
 {
 	struct lsmcontext context;
 	struct lsmblob lb;
-	char *secdata;
-	u32 seclen, secid;
+	u32 secid;
 	int err;
 
 	err = security_socket_getpeersec_dgram(NULL, skb, &secid);
@@ -141,12 +140,11 @@ static void ip_cmsg_recv_security(struct msghdr *msg, struct sk_buff *skb)
 		return;
 
 	lsmblob_init(&lb, secid);
-	err = security_secid_to_secctx(&lb, &secdata, &seclen);
+	err = security_secid_to_secctx(&lb, &context);
 	if (err)
 		return;
 
-	put_cmsg(msg, SOL_IP, SCM_SECURITY, seclen, secdata);
-	lsmcontext_init(&context, secdata, seclen, 0); /* scaffolding */
+	put_cmsg(msg, SOL_IP, SCM_SECURITY, context.len, context.context);
 	security_release_secctx(&context);
 }
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index da36301e2185..8bd6ce5f9e93 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -345,8 +345,7 @@ static int ctnetlink_dump_mark(struct sk_buff *skb, const struct nf_conn *ct)
 static int ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
 {
 	struct nlattr *nest_secctx;
-	int len, ret;
-	char *secctx;
+	int ret;
 	struct lsmblob blob;
 	struct lsmcontext context;
 
@@ -354,7 +353,7 @@ static int ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
 	 * security_secid_to_secctx() will know which security module
 	 * to use to create the secctx.  */
 	lsmblob_init(&blob, ct->secmark);
-	ret = security_secid_to_secctx(&blob, &secctx, &len);
+	ret = security_secid_to_secctx(&blob, &context);
 	if (ret)
 		return 0;
 
@@ -363,13 +362,12 @@ static int ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
 	if (!nest_secctx)
 		goto nla_put_failure;
 
-	if (nla_put_string(skb, CTA_SECCTX_NAME, secctx))
+	if (nla_put_string(skb, CTA_SECCTX_NAME, context.context))
 		goto nla_put_failure;
 	nla_nest_end(skb, nest_secctx);
 
 	ret = 0;
 nla_put_failure:
-	lsmcontext_init(&context, secctx, len, 0); /* scaffolding */
 	security_release_secctx(&context);
 	return ret;
 }
@@ -662,15 +660,11 @@ static inline size_t ctnetlink_acct_size(const struct nf_conn *ct)
 static inline int ctnetlink_secctx_size(const struct nf_conn *ct)
 {
 #ifdef CONFIG_NF_CONNTRACK_SECMARK
-	int len, ret;
+	int len;
 	struct lsmblob blob;
 
-	/* lsmblob_init() puts ct->secmark into all of the secids in blob.
-	 * security_secid_to_secctx() will know which security module
-	 * to use to create the secctx.  */
-	lsmblob_init(&blob, ct->secmark);
-	ret = security_secid_to_secctx(&blob, NULL, &len);
-	if (ret)
+	len = security_secid_to_secctx(&blob, NULL);
+	if (len <= 0)
 		return 0;
 
 	return nla_total_size(0) /* CTA_SECCTX */
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 644dec6a8ef5..5003acf79794 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -176,19 +176,16 @@ static void ct_seq_stop(struct seq_file *s, void *v)
 static void ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
 {
 	int ret;
-	u32 len;
-	char *secctx;
 	struct lsmblob blob;
 	struct lsmcontext context;
 
 	lsmblob_init(&blob, ct->secmark);
-	ret = security_secid_to_secctx(&blob, &secctx, &len);
+	ret = security_secid_to_secctx(&blob, &context);
 	if (ret)
 		return;
 
-	seq_printf(s, "secctx=%s ", secctx);
+	seq_printf(s, "secctx=%s ", context.context);
 
-	lsmcontext_init(&context, secctx, len, 0); /* scaffolding */
 	security_release_secctx(&context);
 }
 #else
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index f69d5e997da2..35c3cde6bacd 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -306,6 +306,7 @@ static u32 nfqnl_get_sk_secctx(struct sk_buff *skb, char **secdata)
 	u32 seclen = 0;
 #if IS_ENABLED(CONFIG_NETWORK_SECMARK)
 	struct lsmblob blob;
+	struct lsmcontext context = { };
 
 	if (!skb || !sk_fullsock(skb->sk))
 		return 0;
@@ -317,10 +318,12 @@ static u32 nfqnl_get_sk_secctx(struct sk_buff *skb, char **secdata)
 		 * blob. security_secid_to_secctx() will know which security
 		 * module to use to create the secctx.  */
 		lsmblob_init(&blob, skb->secmark);
-		security_secid_to_secctx(&blob, secdata, &seclen);
+		security_secid_to_secctx(&blob, &context);
+		*secdata = context.context;
 	}
 
 	read_unlock_bh(&skb->sk->sk_callback_lock);
+	seclen = context.len;
 #endif
 	return seclen;
 }
diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index b3e3d920034d..12e5d508bd08 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -375,8 +375,6 @@ int netlbl_unlhsh_add(struct net *net,
 	struct netlbl_unlhsh_iface *iface;
 	struct audit_buffer *audit_buf = NULL;
 	struct lsmcontext context;
-	char *secctx = NULL;
-	u32 secctx_len;
 	struct lsmblob blob;
 
 	if (addr_len != sizeof(struct in_addr) &&
@@ -444,12 +442,9 @@ int netlbl_unlhsh_add(struct net *net,
 		 * security_secid_to_secctx() will know which security module
 		 * to use to create the secctx.  */
 		lsmblob_init(&blob, secid);
-		if (security_secid_to_secctx(&blob,
-					     &secctx,
-					     &secctx_len) == 0) {
-			audit_log_format(audit_buf, " sec_obj=%s", secctx);
-			/* scaffolding */
-			lsmcontext_init(&context, secctx, secctx_len, 0);
+		if (security_secid_to_secctx(&blob, &context) == 0) {
+			audit_log_format(audit_buf, " sec_obj=%s",
+					 context.context);
 			security_release_secctx(&context);
 		}
 		audit_log_format(audit_buf, " res=%u", ret_val == 0 ? 1 : 0);
@@ -482,8 +477,6 @@ static int netlbl_unlhsh_remove_addr4(struct net *net,
 	struct audit_buffer *audit_buf;
 	struct net_device *dev;
 	struct lsmcontext context;
-	char *secctx;
-	u32 secctx_len;
 	struct lsmblob blob;
 
 	spin_lock(&netlbl_unlhsh_lock);
@@ -509,11 +502,9 @@ static int netlbl_unlhsh_remove_addr4(struct net *net,
 		if (entry != NULL)
 			lsmblob_init(&blob, entry->secid);
 		if (entry != NULL &&
-		    security_secid_to_secctx(&blob,
-					     &secctx, &secctx_len) == 0) {
-			audit_log_format(audit_buf, " sec_obj=%s", secctx);
-			/* scaffolding */
-			lsmcontext_init(&context, secctx, secctx_len, 0);
+		    security_secid_to_secctx(&blob, &context) == 0) {
+			audit_log_format(audit_buf, " sec_obj=%s",
+					 context.context);
 			security_release_secctx(&context);
 		}
 		audit_log_format(audit_buf, " res=%u", entry != NULL ? 1 : 0);
@@ -552,8 +543,6 @@ static int netlbl_unlhsh_remove_addr6(struct net *net,
 	struct audit_buffer *audit_buf;
 	struct net_device *dev;
 	struct lsmcontext context;
-	char *secctx;
-	u32 secctx_len;
 	struct lsmblob blob;
 
 	spin_lock(&netlbl_unlhsh_lock);
@@ -578,10 +567,9 @@ static int netlbl_unlhsh_remove_addr6(struct net *net,
 		if (entry != NULL)
 			lsmblob_init(&blob, entry->secid);
 		if (entry != NULL &&
-		    security_secid_to_secctx(&blob,
-					     &secctx, &secctx_len) == 0) {
-			audit_log_format(audit_buf, " sec_obj=%s", secctx);
-			lsmcontext_init(&context, secctx, secctx_len, 0);
+		    security_secid_to_secctx(&blob, &context) == 0) {
+			audit_log_format(audit_buf, " sec_obj=%s",
+					 context.context);
 			security_release_secctx(&context);
 		}
 		audit_log_format(audit_buf, " res=%u", entry != NULL ? 1 : 0);
@@ -1104,8 +1092,6 @@ static int netlbl_unlabel_staticlist_gen(u32 cmd,
 	struct lsmcontext context;
 	void *data;
 	u32 secid;
-	char *secctx;
-	u32 secctx_len;
 	struct lsmblob blob;
 
 	data = genlmsg_put(cb_arg->skb, NETLINK_CB(cb_arg->nl_cb->skb).portid,
@@ -1165,15 +1151,13 @@ static int netlbl_unlabel_staticlist_gen(u32 cmd,
 	 * security_secid_to_secctx() will know which security module
 	 * to use to create the secctx.  */
 	lsmblob_init(&blob, secid);
-	ret_val = security_secid_to_secctx(&blob, &secctx, &secctx_len);
+	ret_val = security_secid_to_secctx(&blob, &context);
 	if (ret_val != 0)
 		goto list_cb_failure;
 	ret_val = nla_put(cb_arg->skb,
 			  NLBL_UNLABEL_A_SECCTX,
-			  secctx_len,
-			  secctx);
-	/* scaffolding */
-	lsmcontext_init(&context, secctx, secctx_len, 0);
+			  context.len,
+			  context.context);
 	security_release_secctx(&context);
 	if (ret_val != 0)
 		goto list_cb_failure;
diff --git a/net/netlabel/netlabel_user.c b/net/netlabel/netlabel_user.c
index ef139d8ae7cd..951ba0639d20 100644
--- a/net/netlabel/netlabel_user.c
+++ b/net/netlabel/netlabel_user.c
@@ -85,8 +85,6 @@ struct audit_buffer *netlbl_audit_start_common(int type,
 {
 	struct audit_buffer *audit_buf;
 	struct lsmcontext context;
-	char *secctx;
-	u32 secctx_len;
 	struct lsmblob blob;
 
 	if (audit_enabled == AUDIT_OFF)
@@ -102,9 +100,8 @@ struct audit_buffer *netlbl_audit_start_common(int type,
 
 	lsmblob_init(&blob, audit_info->secid);
 	if (audit_info->secid != 0 &&
-	    security_secid_to_secctx(&blob, &secctx, &secctx_len) == 0) {
-		audit_log_format(audit_buf, " subj=%s", secctx);
-		lsmcontext_init(&context, secctx, secctx_len, 0);/*scaffolding*/
+	    security_secid_to_secctx(&blob, &context) == 0) {
+		audit_log_format(audit_buf, " subj=%s", context.context);
 		security_release_secctx(&context);
 	}
 
diff --git a/security/security.c b/security/security.c
index e434f085afab..b52c7c55a092 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2337,18 +2337,41 @@ int security_ismaclabel(const char *name)
 }
 EXPORT_SYMBOL(security_ismaclabel);
 
-int security_secid_to_secctx(struct lsmblob *blob, char **secdata, u32 *seclen)
+/**
+ * security_secid_to_secctx - convert secid to secctx
+ * @blob: set of secids
+ * @cp: lsm context into which result is put
+ *
+ * Translate secid information into a secctx string.
+ * Return a negative value on error.
+ * If cp is NULL return the length of the string.
+ * Otherwise, return 0.
+ */
+int security_secid_to_secctx(struct lsmblob *blob, struct lsmcontext *cp)
 {
 	struct security_hook_list *hp;
 	int ilsm = lsm_task_ilsm(current);
 
+	if (cp)
+		memset(cp, 0, sizeof(*cp));
+
 	hlist_for_each_entry(hp, &security_hook_heads.secid_to_secctx, list) {
 		if (WARN_ON(hp->lsmid->slot < 0 || hp->lsmid->slot >= lsm_slot))
 			continue;
-		if (ilsm == LSMBLOB_INVALID || ilsm == hp->lsmid->slot)
+		if (ilsm == LSMBLOB_INVALID || ilsm == hp->lsmid->slot) {
+			if (!cp) {
+				int len;
+				int rc;
+				rc = hp->hook.secid_to_secctx(
+					blob->secid[hp->lsmid->slot],
+					NULL, &len);
+				return rc ? rc : len;
+			}
+			cp->slot = hp->lsmid->slot;
 			return hp->hook.secid_to_secctx(
 					blob->secid[hp->lsmid->slot],
-					secdata, seclen);
+					&cp->context, &cp->len);
+		}
 	}
 
 	return LSM_RET_DEFAULT(secid_to_secctx);
-- 
2.35.1

