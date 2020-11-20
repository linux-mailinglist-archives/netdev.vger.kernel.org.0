Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28F252BB6F6
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 21:32:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730656AbgKTUa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 15:30:56 -0500
Received: from sonic317-38.consmr.mail.ne1.yahoo.com ([66.163.184.49]:38814
        "EHLO sonic317-38.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730741AbgKTUaz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 15:30:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1605904253; bh=4RRzO0paPwyehaIJU/rSn0qfpMiu/liXc47W7zqXUbI=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject; b=PNnxJX1E0a0nSxQYapsBEeREo53A0l0I/0554SNnHFbTYtwuzCyKQwY82ZfyUkq3uoN2pFWBJcmti3dhOAAVs6m3pXIkkGj+59Yuv5Ch0TS/ne2R841rFntn8nHkUoytSMl7ODPi6w8jr/XQ+YvHVfcvnLvbum86gEi1XxPk9GslHocN24KqbwGYA91GG7+nngVZlv+TbocX9EZE66qw9lLXV2RASlHR0k0VwhQIcy6IjgnxO0hH+/Y0rd2DHc97I8oE4xdfUBsy3MgokCEliekiJCm/p6C025RY1YWVxK8Izum4cCangLyyZfMWaH/fZOUnpy9q223w9HxZRoCljw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1605904253; bh=XFIks0hweHxrYJ3Wr3w4271Lk52T32xSa9GCbJ/19n/=; h=From:To:Subject:Date:From:Subject; b=qKc1hYFFtGKDDTC/BoVOffX2OpU/oWr2yvh5paj35A2n3xyFZxN2VSsPP1pXKZjDb0YIQIHrYj+zAO5uUH/c7UkRJDRH5nHphS0VRk0Sa30XBSswjGbuWQauZgh/WfNNc4Or3oL/Bm7TKkBLy4ACvkoNIOHS6lVs8QRTxVRIXG2rWYt9PKHxHmfd01oT2/GA7eZVLPdtPZz0TqLgqD9MOuB3cfyTHxbuMPWH8ZhfmOEjrsGoa3qV6a4asrO1TNxPrqY2WaPfxlDoKQiVLawkzGxdmBx5Cu3vlJLTbWJMnJDZ9Xwz5AErRCx1dv99jifYkwV3cxwjQHJ7Wt1dkrov4w==
X-YMail-OSG: GGluitgVM1nh6AdNYNpJhGY1uVCpJVHqkPvEt_RRzJbbQKeY83WmGPF3QR3YGM2
 hosqc032fdocyRva_vxHze6O5eSlWRzdQwqhVYEelOGpfnMjdyEjhOGSzx_O5t0aIaUfFugqxZXU
 hDCkAn.5ziPTTml6aPlMd1GELTdcMgoOC.GW81fW1iBbnNs9g25WYRqA94r6inlPGTvVyCfD_Lp5
 G9h9DjKirRXW108L69RSa8crvy2wo_JjhdJyjKVDy2XJf4nyPQeOGJ7vR9ttSMOLYxhcs8Fybk9e
 du3Ahz2QkXbwvfar67qtnuGgWidAvTIw_L0hxSJkVv5LjQc.3Q67q4ynMOca3KYismdZMiGTVzeV
 UpRBQ.pR41KEAJU6I_a2BV4tdGwL0Osiz9JpjauIi1j2j95QMqSVay2dcuMn_f4XpwkyXQSHsQKr
 XKxc0.rRg9HEP3HG716f8hcfpWrdtLyDQIZfF7Rxbi_X3tKHC1VprjGnpa_kE5wRmBKX.CvHm2Lf
 5Uc1DaTLz3vE5OTSNs09rtXDF3a4ZrQ.sIvWR3HpwAFAZbMfXtBFKNjTLC7dcr_tekxE6B2gvT2u
 NBe4Q24HDzVNkQJL.pbk7LiVNIrgYkFpFKI2WwP0LpmbO33gKflk8KNbO8wwOk4qheG_rPfHDLcn
 2GN5YrUvtdvhCSqp7cemYhKkDuKdo9C4Te40IpecPhVZ5GVIHeqewogXkHUIZY0Jj3zvMspucfBV
 P_mFILcehmT91TI73HHOhsKqBTFhQPvgqF63PY_Q2Q7RPUA2FJzJ.VYga_0tTvxuLBLKcrphbTcd
 6o82spBc5ovAyYtNmIUdYgcWwNd6TTizhg.o3bZQwaKOVyYtZPkuJ3B3wrBZ.2nIAclNk3aVs4cE
 NtWE66VNIZQOBH6A2QN0CyQsn2.NZaRR05Mj3cB.zhsq9cGhvxZmDL62KdxP7Y.7_nusdSi_D.04
 7waBN28KcWpdwoc_8PnhqL75MRIXCOWFfYnK7TvSJ5yPSNNahF6fJ33.OWhuRxXDoNPJt.oz42YE
 Dw1UXC1ZzdXLp.8igOWAjaGkORBxPw3pqw2apWmvv5GzNNhEKSjqwSDeSIAH2QLpo3pk2mk3ck1r
 cTWDOum8iR9cwh1Je5gSWcO7YMvheZCkDGfB2llfll3lkQ.HomV8rGsqvpd3t9OvPt89lIkLA0sk
 m7JPy7C99b6iDuA0OaLdK29HHdSHd11TmPGePrR5fPimDf1CgUgeqaKoHPxCedMHz03Cd8.s67X.
 JDR0WhSnp8OIQ5OHKyNhKg6REym2.myEVdVkFGslbdBVChlDOtP.nCHo4sdCHpkX.qjaAMk5Uk6M
 FHaIHM3_s0PJI44l1v5q2HJhMRBJLRYLUq42H.CE.DMGKbb_UlbeGsesHS2xsgLcmli5Ihbrb14i
 DY9FwznB9y8VJooj3EAtuA21O.9537dDMEUqcPgnmg.8JwFGqOIi1k.4NjwerZqYhLobUpNZTpPF
 IjBj5ga0nEW_Cp20LLruFGtKu4VUqJT58N69MswltvEpOvjAEKcusy_QyT8N0bI2ZQO.sEC4cxEl
 KvMIkjJotv8nmvNGeNsAhpqZMCLFvxw9uoNH.TVgTr4ZBm_kbBmKMRBiNTftnm.zkEZSG3KI6zEx
 bdMNsu367DusuhEUKWz4I9LnblyPQGyjHbi4ddAjLYI2YNbx1GI3Bl2o3uYM0wTpIcoSKTkXHxuY
 TCP1ybtReBkfIOu2DzTj7UB8XbLSl1VYv3uzudescuG2rtk4G2rNwyAWI2E9Oi1gmGGs4iFqELEG
 thtqYRXiYNNjzXj9GOSQT3qDiqUM_unEj94jV1T571kYKX6HpU0AkozbDD5fQH0rMLLonEkgqTd8
 8DVaNvryCjIFAQQSD5BPaWxDs5nkU8Kkp33MVO1pqi8ki74rEVa33aKxOPVTn7pmo4lBHXQaLwve
 EmZR0wJsN6N86cb7m3qZ0nZGpipXwqV_IRR2CWRZBmaE3D7ozzEsKHnueoRvPCyuU3mZEGryWAgJ
 V_P7vfo8Af71LCqN65FGb4b9mFTSjna2U9MXHuKkPKfHO4chVaZD0vtpsoUfqBfRibyPkN3BVuNb
 moZPHdmjSPXa2g8zxr3nWeVB3ltdt7f.LS85kmXHophAhlYwUwrV3c1zZpJFPiu44o7cdGJvFqzl
 3K8t_zckc3t7XIDH7gcwSxX1ivrhryf9xIeXfo_0xkjINYct7ooq2hebdOCnyQ_tBt.kw04svS.N
 Jn7HXvH1J9Ti.i1n_2wA40c66TFCa93yoLnxfuV3pOdJRjd.EfukOqKv38f1SoT0xHj1kV00G0rC
 5zOdl3V84FCfkhVjtmygxJIayKYfgxlJUZbEg.z2VZyjjx62a_lHX4bGPvvK2AqY2E0yIRFq2dj9
 tSGhKjAXECohD6m5UR2pxVWg1TkOFvF7n2z6Cz1ths_.aJEuz1CpuEWDPDRQNqkkgqZfaBj.MpFP
 4.g8xR0VC42aidbMdTosLbFHp_MPDLUJp8wt2ygMB5EnYsTEsRtqoAVXjVjUAAkVgpIyROxJ8ZmJ
 WKExGH8zzA6Ztxm1z97q9.AF0as13QDt1BiSChsYOFoE9HAFdEM3ZCIUjckVpP8cEKA_51VwsWQN
 HVEJF4lRRYms3wTLoh0Gc3pstcwTLCVIRzk2t9Nn63ibfZr8.1pgXlivLJXrBSXC5nBWLYNOdREt
 ueZpgnixc5hb.8Zf4JPYMJHAWHGxyAElZPUe5rYImHv6p6zxRg1iBC2LdEB55FagLIUxojhwdpSa
 IJzdhZbtzBB5MTr_YL9MCIlwzNKEb2_hSye8Il_k7I78SKZnHDf_mIlChbb57__a1ekRFYv_tUl7
 Uh9CuBMkTs916XMLxpgFRXw2x..a4EQvEQ2JQVNpoQ_xMDtxFMe3EpMWfh.TL4YNJ.EzIcFkzy0w
 AXbuuLcJ1jTAWysXhLLROPaTdWticKIVseJXhlDIMiwwKwo_k9f_002dZTXXS8oDKiJ_wW5dh63c
 Rk.MJkGjT61wFMWeAgaY3NpF9EU7LqcfBt4X_S19FE4bPSYuy_iNjFUQ1kpDdTbxHeexUa6hhlQT
 k_485AWl5JvvVqqWehz.sKFOXCbGh9WXbrO_btLHWPx8FJNDhygoTrb5azlm4tK.5j7DgrLQ_nD4
 drOB.9qZpt10JT9HWGx0FEAmbaauKZgoSXnU7eryK0G5Pfndp29nSC4BlZycQiX0sw3TL9hAW2Q-
 -
Received: from sonic.gate.mail.ne1.yahoo.com by sonic317.consmr.mail.ne1.yahoo.com with HTTP; Fri, 20 Nov 2020 20:30:53 +0000
Received: by smtp408.mail.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 8c6eb17d31118d62bc7b134126c0c400;
          Fri, 20 Nov 2020 20:30:48 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH v23 14/23] LSM: Use lsmcontext in security_secid_to_secctx
Date:   Fri, 20 Nov 2020 12:14:58 -0800
Message-Id: <20201120201507.11993-15-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201120201507.11993-1-casey@schaufler-ca.com>
References: <20201120201507.11993-1-casey@schaufler-ca.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the (secctx,seclen) pointer pair with a single
lsmcontext pointer to allow return of the LSM identifier
along with the context and context length. This allows
security_release_secctx() to know how to release the
context. Callers have been modified to use or save the
returned data from the new structure.

Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
Acked-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Cc: netdev@vger.kernel.org
Cc: linux-audit@redhat.com
Cc: netfilter-devel@vger.kernel.org
---
 drivers/android/binder.c                | 26 +++++++---------
 include/linux/security.h                |  4 +--
 include/net/scm.h                       |  9 ++----
 kernel/audit.c                          | 39 +++++++++++-------------
 kernel/auditsc.c                        | 31 +++++++------------
 net/ipv4/ip_sockglue.c                  |  8 ++---
 net/netfilter/nf_conntrack_netlink.c    | 18 +++++------
 net/netfilter/nf_conntrack_standalone.c |  7 ++---
 net/netfilter/nfnetlink_queue.c         |  5 +++-
 net/netlabel/netlabel_unlabeled.c       | 40 ++++++++-----------------
 net/netlabel/netlabel_user.c            |  7 ++---
 security/security.c                     | 10 +++++--
 12 files changed, 81 insertions(+), 123 deletions(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 05266b064c38..a75ffcd0270a 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2836,9 +2836,7 @@ static void binder_transaction(struct binder_proc *proc,
 	binder_size_t last_fixup_min_off = 0;
 	struct binder_context *context = proc->context;
 	int t_debug_id = atomic_inc_return(&binder_last_id);
-	char *secctx = NULL;
-	u32 secctx_sz = 0;
-	struct lsmcontext scaff; /* scaffolding */
+	struct lsmcontext lsmctx = { };
 
 	e = binder_transaction_log_add(&binder_transaction_log);
 	e->debug_id = t_debug_id;
@@ -3092,14 +3090,14 @@ static void binder_transaction(struct binder_proc *proc,
 		size_t added_size;
 
 		security_task_getsecid(proc->tsk, &blob);
-		ret = security_secid_to_secctx(&blob, &secctx, &secctx_sz);
+		ret = security_secid_to_secctx(&blob, &lsmctx);
 		if (ret) {
 			return_error = BR_FAILED_REPLY;
 			return_error_param = ret;
 			return_error_line = __LINE__;
 			goto err_get_secctx_failed;
 		}
-		added_size = ALIGN(secctx_sz, sizeof(u64));
+		added_size = ALIGN(lsmctx.len, sizeof(u64));
 		extra_buffers_size += added_size;
 		if (extra_buffers_size < added_size) {
 			/* integer overflow of extra_buffers_size */
@@ -3126,24 +3124,22 @@ static void binder_transaction(struct binder_proc *proc,
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
@@ -3199,7 +3195,7 @@ static void binder_transaction(struct binder_proc *proc,
 	off_end_offset = off_start_offset + tr->offsets_size;
 	sg_buf_offset = ALIGN(off_end_offset, sizeof(void *));
 	sg_buf_end_offset = sg_buf_offset + extra_buffers_size -
-		ALIGN(secctx_sz, sizeof(u64));
+		ALIGN(lsmctx.len, sizeof(u64));
 	off_min = 0;
 	for (buffer_offset = off_start_offset; buffer_offset < off_end_offset;
 	     buffer_offset += sizeof(binder_size_t)) {
@@ -3475,10 +3471,8 @@ static void binder_transaction(struct binder_proc *proc,
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
index 4ed7a0790cc5..c86c9870b352 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -559,7 +559,7 @@ int security_setprocattr(const char *lsm, const char *name, void *value,
 			 size_t size);
 int security_netlink_send(struct sock *sk, struct sk_buff *skb);
 int security_ismaclabel(const char *name);
-int security_secid_to_secctx(struct lsmblob *blob, char **secdata, u32 *seclen);
+int security_secid_to_secctx(struct lsmblob *blob, struct lsmcontext *cp);
 int security_secctx_to_secid(const char *secdata, u32 seclen,
 			     struct lsmblob *blob);
 void security_release_secctx(struct lsmcontext *cp);
@@ -1385,7 +1385,7 @@ static inline int security_ismaclabel(const char *name)
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
index 8867df3de920..4e219d1c1781 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1190,9 +1190,6 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 	struct audit_buffer	*ab;
 	u16			msg_type = nlh->nlmsg_type;
 	struct audit_sig_info   *sig_data;
-	char			*ctx = NULL;
-	u32			len;
-	struct lsmcontext	scaff; /* scaffolding */
 
 	err = audit_netlink_ok(skb, msg_type);
 	if (err)
@@ -1440,33 +1437,34 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		kfree(new);
 		break;
 	}
-	case AUDIT_SIGNAL_INFO:
-		len = 0;
+	case AUDIT_SIGNAL_INFO: {
+		struct lsmcontext context = { };
+		int len = 0;
+
 		if (lsmblob_is_set(&audit_sig_lsm)) {
-			err = security_secid_to_secctx(&audit_sig_lsm, &ctx,
-						       &len);
+			err = security_secid_to_secctx(&audit_sig_lsm,
+						       &context);
 			if (err)
 				return err;
 		}
-		sig_data = kmalloc(sizeof(*sig_data) + len, GFP_KERNEL);
+		sig_data = kmalloc(sizeof(*sig_data) + context.len, GFP_KERNEL);
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
+			len = context.len;
+			memcpy(sig_data->ctx, context.context, len);
+			security_release_secctx(&context);
 		}
 		audit_send_reply(skb, seq, AUDIT_SIGNAL_INFO, 0, 0,
 				 sig_data, sizeof(*sig_data) + len);
 		kfree(sig_data);
 		break;
+	}
 	case AUDIT_TTY_GET: {
 		struct audit_tty_status s;
 		unsigned int t;
@@ -2129,26 +2127,23 @@ void audit_log_key(struct audit_buffer *ab, char *key)
 
 int audit_log_task_context(struct audit_buffer *ab)
 {
-	char *ctx = NULL;
-	unsigned len;
 	int error;
 	struct lsmblob blob;
-	struct lsmcontext scaff; /* scaffolding */
+	struct lsmcontext context;
 
 	security_task_getsecid(current, &blob);
 	if (!lsmblob_is_set(&blob))
 		return 0;
 
-	error = security_secid_to_secctx(&blob, &ctx, &len);
+	error = security_secid_to_secctx(&blob, &context);
 	if (error) {
 		if (error != -EINVAL)
 			goto error_path;
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
index 2b06171bedeb..4af5861bcb9a 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -998,9 +998,7 @@ static int audit_log_pid_context(struct audit_context *context, pid_t pid,
 				 struct lsmblob *blob, char *comm)
 {
 	struct audit_buffer *ab;
-	struct lsmcontext lsmcxt;
-	char *ctx = NULL;
-	u32 len;
+	struct lsmcontext lsmctx;
 	int rc = 0;
 
 	ab = audit_log_start(context, GFP_KERNEL, AUDIT_OBJ_PID);
@@ -1011,13 +1009,12 @@ static int audit_log_pid_context(struct audit_context *context, pid_t pid,
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
@@ -1230,7 +1227,6 @@ static void audit_log_fcaps(struct audit_buffer *ab, struct audit_names *name)
 
 static void show_special(struct audit_context *context, int *call_panic)
 {
-	struct lsmcontext lsmcxt;
 	struct audit_buffer *ab;
 	int i;
 
@@ -1254,17 +1250,15 @@ static void show_special(struct audit_context *context, int *call_panic)
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
@@ -1408,20 +1402,17 @@ static void audit_log_name(struct audit_context *context, struct audit_names *n,
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
index a7e4c1b34b6c..ae073b642fa7 100644
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
index 5d2784461798..e6fdcd87ab3e 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -331,8 +331,7 @@ static int ctnetlink_dump_mark(struct sk_buff *skb, const struct nf_conn *ct)
 static int ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
 {
 	struct nlattr *nest_secctx;
-	int len, ret;
-	char *secctx;
+	int ret;
 	struct lsmblob blob;
 	struct lsmcontext context;
 
@@ -340,7 +339,7 @@ static int ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
 	 * security_secid_to_secctx() will know which security module
 	 * to use to create the secctx.  */
 	lsmblob_init(&blob, ct->secmark);
-	ret = security_secid_to_secctx(&blob, &secctx, &len);
+	ret = security_secid_to_secctx(&blob, &context);
 	if (ret)
 		return 0;
 
@@ -349,13 +348,12 @@ static int ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
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
@@ -655,15 +653,15 @@ static inline int ctnetlink_secctx_size(const struct nf_conn *ct)
 #ifdef CONFIG_NF_CONNTRACK_SECMARK
 	int len, ret;
 	struct lsmblob blob;
+	struct lsmcontext context;
 
-	/* lsmblob_init() puts ct->secmark into all of the secids in blob.
-	 * security_secid_to_secctx() will know which security module
-	 * to use to create the secctx.  */
-	lsmblob_init(&blob, ct->secmark);
-	ret = security_secid_to_secctx(&blob, NULL, &len);
+	ret = security_secid_to_secctx(&blob, &context);
 	if (ret)
 		return 0;
 
+	len = context.len;
+	security_release_secctx(&context);
+
 	return nla_total_size(0) /* CTA_SECCTX */
 	       + nla_total_size(sizeof(char) * len); /* CTA_SECCTX_NAME */
 #else
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index e2bdc851a477..c6112960fc73 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -173,19 +173,16 @@ static void ct_seq_stop(struct seq_file *s, void *v)
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
index dcc31cb7f287..84be5a49a157 100644
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
index 5b83967e3f27..c423c7cdd095 100644
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
@@ -510,11 +503,9 @@ static int netlbl_unlhsh_remove_addr4(struct net *net,
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
@@ -553,8 +544,6 @@ static int netlbl_unlhsh_remove_addr6(struct net *net,
 	struct audit_buffer *audit_buf;
 	struct net_device *dev;
 	struct lsmcontext context;
-	char *secctx;
-	u32 secctx_len;
 	struct lsmblob blob;
 
 	spin_lock(&netlbl_unlhsh_lock);
@@ -580,10 +569,9 @@ static int netlbl_unlhsh_remove_addr6(struct net *net,
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
@@ -1106,8 +1094,6 @@ static int netlbl_unlabel_staticlist_gen(u32 cmd,
 	struct lsmcontext context;
 	void *data;
 	u32 secid;
-	char *secctx;
-	u32 secctx_len;
 	struct lsmblob blob;
 
 	data = genlmsg_put(cb_arg->skb, NETLINK_CB(cb_arg->nl_cb->skb).portid,
@@ -1167,15 +1153,13 @@ static int netlbl_unlabel_staticlist_gen(u32 cmd,
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
index 352c9eb98425..ab5d2c9770f1 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2209,18 +2209,22 @@ int security_ismaclabel(const char *name)
 }
 EXPORT_SYMBOL(security_ismaclabel);
 
-int security_secid_to_secctx(struct lsmblob *blob, char **secdata, u32 *seclen)
+int security_secid_to_secctx(struct lsmblob *blob, struct lsmcontext *cp)
 {
 	struct security_hook_list *hp;
 	int ilsm = lsm_task_ilsm(current);
 
+	memset(cp, 0, sizeof(*cp));
+
 	hlist_for_each_entry(hp, &security_hook_heads.secid_to_secctx, list) {
 		if (WARN_ON(hp->lsmid->slot < 0 || hp->lsmid->slot >= lsm_slot))
 			continue;
-		if (ilsm == LSMBLOB_INVALID || ilsm == hp->lsmid->slot)
+		if (ilsm == LSMBLOB_INVALID || ilsm == hp->lsmid->slot) {
+			cp->slot = hp->lsmid->slot;
 			return hp->hook.secid_to_secctx(
 					blob->secid[hp->lsmid->slot],
-					secdata, seclen);
+					&cp->context, &cp->len);
+		}
 	}
 
 	return LSM_RET_DEFAULT(secid_to_secctx);
-- 
2.24.1

