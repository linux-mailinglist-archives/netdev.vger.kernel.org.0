Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 744612A7469
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 02:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388063AbgKEBFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 20:05:47 -0500
Received: from sonic301-36.consmr.mail.ne1.yahoo.com ([66.163.184.205]:37275
        "EHLO sonic301-36.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388043AbgKEBFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 20:05:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1604538344; bh=RhDyTRIUUvKNSYKelEuTITA9CN5VF/9jr5GLz/2ip2o=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject; b=tR1M2vespoEs2pHc21LYSe0JHsrOYq+rheO7zlUxyRB3IH3YSMI1oivJ72iFC2A+8Tt18GmkO/9Qu5y/KtMJd6ckz0pa9C0TLicaMA3AWEJhxefkn60zQ5QMV5OcSplFw2I8a+vwpbSw85TI6M41FBbUhm5XDpVttJ/dQTZy0/2gIHZV+tsckun1i8ChWB7JL5jE/6Yc5XByhNok+b87pDf76+oUm1Tn1sCqiE+mBDH1ZdufTB/So8xJ47lA2nL5lE6hO/2zvTcHFIUZPbREJcVESllFprVpnX3KDRva8XE4SdvyTv0xCka5Pjwxs0WtWhr/E0Jl0EeiMWsVWErUaQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1604538344; bh=23ZHddgEpQEb0JeWZQaKaLay5UUDoqB1PLWETjtjWUU=; h=From:To:Subject:Date; b=ZwR7W0Y7sW/P6P8SaCY4/w/hI7m9cH+JDodPQwYDQD2QGNn4evzbjlCek+nhJEUCJRzhX1zSlALSqyeWtF+MYizM6rrFanK84exLzyHemMNNYsi7sIiEpys57lk9RHmHhaZU3bAPtj/skvEl0u2OPPHVj14g2cmGxTABMOwt5u+gfPGqwVc1igiRU1X+anbnYhblJTmoPtrBSAAmONl/kG0Q6GLc4rJ47tXshPoxFeai9bieURZ/PDNcvfAcA5zTsI2Y0idJ3Q3n2eEM4capheyT2eX/Ozu+pLnPM3tUgbgGSK7rRWCRvORKhTmdAyCIT2Oqt1iLB9LXn8aQJw5Q9A==
X-YMail-OSG: kUGqNbsVM1nuUyEFXsUXffXVXr5oBvKVGCszW.OVtBNDqJNLIwQolw7FZG.NRh8
 hopjQUMqIlP3.kqNvx5PlSZk8ShTbUrEyy.AYF.HEE6YGybMxz4CV6U4twkT4T.E8daIhLFdNHGa
 uT2hBQ6w7bc0SkhPEhZehu9UDSeTI2beVNs.F.ehceEwEWqtZx2RLJZRRP8JpdkvUB0u2Pddfxhd
 XsSAMGDHEjgU4gpRBZZ9WdFXpDKepNQ7WFrh04dxxIzcYZT5Ag6cMxbw5hItQDeMRza1OT1RyCXZ
 UxyzxzpiEem.eA5TCp_WBXIK884tF9_8LraEsy3TJiRWN2D4ifOENADBZ.Bq_VdyvMOk6Y6Lie.b
 2M_qm5_YoMDd8KArLh8rDEEKo.lyHlIHSgId1JMKsFAijsZgCP5Hin4J71b77OKOMyJuUIw7AQcz
 WFBAIirOGBRUy.L6tEQqK6jZ4WKaJCLVefR_oPPen4s8CHw.JMGhyOsKG.NpUNziK6OFPMLR5gQ4
 9_Wt0dozFIDsURn_YnKJQoLX2xQBNGPQAcK_oNIwd8ML6pXZvo.ZRGdy8xjt0BNt.FOC9iWs1XsS
 9mM4Z1oHORLexf5TzNEYC.OvawI1jUAz74L5z6Ui3MzVK.X7daDqp.OXJH64y0FlgAd2X6QEfs4X
 myjdEAnsKDG80y9nhezGgsSRBSXXis_vrP2YNaEy..Mw5fnhMVfe6mAR3urycndMKTeAMoZw26vV
 vDC2EaT2OcFMFCy7cP.cofgyfaU5a0xN4j9CiW62yNo4BgfrhKt5NbvfCoTyFxp0Oc_57MhiJDul
 ispQ7XVPNAlWYBsS3fslTIcVb83CMVUHBuzPWyeV3v_28LaOENxnzPgVWNIv4yKDbDLHkmERYcyV
 ZqxT0fCDjCQE_k1kc6BSe6HYpYCRSOC1z58_wcSEfYeilMopxDyeiQN9mhTbbYpvF2XfSPMFgvcn
 EqZyO7RSppdMFcM4t0XxtYqveJ1FoAVWQ58IeLM04sUcrBohRWN6Cdt3uqFeyg7YrTOyvkj5_WgI
 b.oDV0nJkqW7BozunNsNG0kvLG8OAzDCISDVo5gC0GzqDwoSXPDO9PMkIFR6RJ4VfRrWpuQpdmrR
 s1uT2Ww3LwxFxlmgBNKGpa.EpLQIZl2Hyyt9ErrF2C6FXzFujm9entnl2I1MxdfS.G_IcxEG8xKA
 zkbo8MMze9Vr1mYxd724fiBUdWTpoDrqDYagYnvEFYvdQQKcZptf_Gn.16_c2Z4_Inc_S9_g_y21
 hi7yKO2lyumS.wqbMulzqpa3QkDGN0Owp5qmUQ7_yiOl2Sdm7MAj8kjaC5Q8wIwluTGw25_cZQK5
 8loevKmIsGtTABHtoECdSPLFQ9s1zNS4Y7AgOK1ibhX8lDdcZkzkzBXuS_xPIYsCeCQtNWaNud0F
 JfDGvcUXpidB8ELFg0dYkQ9J_d0HelStxi6OlfINvr07UggcCDTSu9qGtLE9rv9F5sO5hb_aHvUy
 _GtcDlE5G9UCDui1lJ5jA718NCG6rEkpqY9U0kLHC1zEAeEpQGjKik_kVNoVRdjvOKQa1GgSzyUY
 TG9_1uvewVkvbx3KtQBPXPZTHOhQLHATo2RY0xVbhdMpR4le7qff4rAk7gCimp.KDzzdb4F9isG0
 sIq7A2aL_xvp6TAS7Mk2p8pDMmyt2IzHxItOarZkVFGaHDouAH41bbPv0LioehQJeXO0H9Wl1i5n
 6TZbBwM4HAlvtcRWioiBZuMb7LprEra9EdmzBq_6ZDmUOWrfyg1QnZS6M03sRQnDwuuwCMDediND
 Cn4xcxOMvPpl2d3KKDppElK7eTtwLkvuS1o9gf7VA0.RKWKaA_5ebfhRPazYH6_pG8qg9lgn8kHh
 ujNIrL4maJodUWqyRXsHvgbr5jFl9gfsivFGw_hPwq3shpN3eUavTWXnkAULEIwRg_htyW_eAvZA
 lfyr7xaCvFPO3_4HHf1YLN68g8_P1SM57Dl5Zasofgts1gTjnfNzMsdQupK8OsQA_Me.FFshutnl
 4KMEsm9SBEs0U_EGv2g2Rsf7mC8Z9ub3zVuU_lh_5kMRlXCLyTBvN3.oqW4Ck9r5t5RyuxVMtaKx
 PVU0c7wTdwRiychMNHSsbwjk_uHf3C7AVJFIpZgu2kbE4kT24sXYqgCgLiG5wIOYtAZ6PmYniUgX
 VI79yamO8nMpcEfqfSTQcZFwu3.zaHG78l1k9mrKWPrmMnEb.rJMdlTaa3wOFlGshKYyrhMX5pMR
 lqeVQOvs4MIt1abEv4d_2tO1fXoqo3RefBsET3ktoifGd.YJgSg1XvNoOeg_KsBiOG5qN7yvmhbM
 5VynPAnFKwmRemda_PVjijrkErB0HQCTdpn6LNEBIeFQtP6hzo2YbQgB6QtzivIXsQr0slnDQ3Xn
 A0kjlgL5Guz5Q5clRP7symInL7z_q4X4DhMiu6p3Lfdsz97wB7UGTqck1LSL96P89ToalM7T3dHn
 1IfdWHLkU.KmqdJAfp5hDqtA5S5jIU_86S3Z7F62lt.8EiJaCMh0REwJdWkLBnV.b_wvm3C7HkVs
 gz57CHABLqvG4cTK2xvoq1KorNPvNfVBa8dCFqIB3uz.PxGnXpaGxGH9vyL6v1YDBsnUkp6jEujj
 AARTNBfpBNGUlCP_2__M812UUiFVzrJv7tTlp.b4pRdWAtVNdsu4kCxi0KtF.K5kSvUSvgYKLXWc
 rF4S67VAWFsf7an70zkMV38KDaVrOF82rqLmacp60losvqpNI8qEe2T.NZFtQrBGUu1qxcukOILT
 BzxWGeYR6Mk79feQlUpaajJYvNYhm3cwG1Xb8_Lbm7JsLo9KDVkGaxSCnAQC7n2JRRM_XAVW_v3i
 7h2CucrjiqZwmokovlHrehyUtTUf0uhKZJC.qcfwi3wynUUAQTGOF0rnVV5UYvwkbQ95_i5fom7u
 IdW_3pO2JW7Y9jMs4D3AA.0P0O9oD.Ikhbu8Bej5AFwUSvPqOadBxPWQybsraEDKchRhehCDSkIr
 KVuvgy6MQMv3dbZ1GA96v1TU19Hu2_ACBW7.cEx2_rICHEkr6XlrPtIjssAbjOaCIKWfLkaLsV5M
 ocoGZfSoW7GlysetKI8ndbwwOAI754NPxnfDYy0kH79W4RC_01wKODJnHbSNEWD6Tzx05fEJnCGZ
 3QOAoH0BmTAcek8eO4dZH2CYkNr5luaBRlHkxNcN8xF3Gv0qFbzvSAuemnBrRjAtwsSOf0jSIOjU
 5hAh1GV7IuBvNoSrSi3MhsVmdASTHhMfXr4mauj693gYQqL..jxOjhkgURQPt3Jd.LAy0QcGsoNt
 NextR76u.Yd9_cCUTR5XRUqSR.VyKGIfX2rjlA11eyh3Fu.XjwrTgHd42kSVGjX4HpjKwXAJ4MJQ
 a.AeV__jfPSGUw3tEoejqCxIIzbTtr_uTVmfcAXALy0j5Z0Jf_JaWU8p9EJok
Received: from sonic.gate.mail.ne1.yahoo.com by sonic301.consmr.mail.ne1.yahoo.com with HTTP; Thu, 5 Nov 2020 01:05:44 +0000
Received: by smtp422.mail.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 24df8e7de125f43047aba718b8097292;
          Thu, 05 Nov 2020 01:05:42 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v22 14/23] LSM: Use lsmcontext in security_secid_to_secctx
Date:   Wed,  4 Nov 2020 16:49:15 -0800
Message-Id: <20201105004924.11651-15-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201105004924.11651-1-casey@schaufler-ca.com>
References: <20201105004924.11651-1-casey@schaufler-ca.com>
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
index 3e06efe29cfa..7d426ca1aff6 100644
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
index 9107ca5a6af3..007f23797de1 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2209,18 +2209,22 @@ int security_ismaclabel(const char *name)
 }
 EXPORT_SYMBOL(security_ismaclabel);
 
-int security_secid_to_secctx(struct lsmblob *blob, char **secdata, u32 *seclen)
+int security_secid_to_secctx(struct lsmblob *blob, struct lsmcontext *cp)
 {
 	struct security_hook_list *hp;
 	int display = lsm_task_display(current);
 
+	memset(cp, 0, sizeof(*cp));
+
 	hlist_for_each_entry(hp, &security_hook_heads.secid_to_secctx, list) {
 		if (WARN_ON(hp->lsmid->slot < 0 || hp->lsmid->slot >= lsm_slot))
 			continue;
-		if (display == LSMBLOB_INVALID || display == hp->lsmid->slot)
+		if (display == LSMBLOB_INVALID || display == hp->lsmid->slot) {
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

