Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4D723D1B36
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 03:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbhGVAZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 20:25:15 -0400
Received: from sonic313-16.consmr.mail.ne1.yahoo.com ([66.163.185.39]:44230
        "EHLO sonic313-16.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230159AbhGVAZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 20:25:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1626915949; bh=bcsGWRNg9stoCvb3cZ6B/7vL0GBO7VYIbuyzJPZmpCo=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=K4Yb0B2feumS/3R4v44APz3WlLgz1hx2GsCjfCpHc8t6R4lk+04Ndd85vdsjShJnHWSDDzMSNpFanuKkMJJkfACZGgYMTgCc1AenUVxOIko3rFC2m1KIjP/5eflWvB50eFPeihYNpSAOU52cungAll5ehHpX6YuBJhyG9u8MGckzWvZ7fG+qUu2YryFrojBzFb5xIsHOSGcdrDbVprZekzUM0rWB+W7ektOGJcpR3c5MQRc4r+Ol6N/9XVkWwlIqeDt6FstuFoLEzlquniYx6JkZ1kAg9mA/zK8DVgwmHHQP0XiGOOAF6+Jmt7WdtCZflW/qKIkF+fOwild9iLnNtQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1626915949; bh=Xv+zNm/xcXYWcOY4Zv136rJ3yqU8sKik/a21WWOZhZl=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=dlhEvLbXZ0VO1Rhn6ioprsTon9hSBO2NQm/viqZl0zdlqrYb9Q3Efi2zZ9kgN8yCeVJiBGHCMB8xJmuqgFG23KuaMRx7oV/i5pSugVBdiVEwWvieA6lV3NCGqr32RLHEcEIoErUx6IC+zrIfhHaCIAK9uNEN6sunqA+CfQCsv2buHVDlsgAiJRwsVZ4HeOibc5RJb2RjmiudiLr56dPns3xmdprNgAak+Ve5fo9iE7a9kvsOLTt6MtbqGjuf7TEa5mjLAgGmlo8nEwV2tikJt7hHAgrZ64tAN8gIBaybKIFqjhKrtiwM+pcNW1UoKmPOVEW8MXqfNyNeB6GOogVg7Q==
X-YMail-OSG: BCm_vP0VM1nv6tcw2NX8zYm8xOoqbGgEEAHzXKptdy99luearKOKVxotzs8HRyx
 7JhcqzLUmeXngfJawg83xn3N86k6Dk9KxwWCMYN10xFDBG_BQSQ75b_A7ZvnwfLW0uiBAjjfkBjq
 ft_BxzT4D77YS0x7IplMJwltLEP6EmGBgyvbWvEbXpiB0F161EAyV5Q2nHebx1Y8a1iD29NvKDpw
 L.WKCFvoblUXMtIO.6aQxXAB7mfzS5IPim9hgPH4unGZvj.9CRsak.NB9Q7pRhscM9EvPXf.jON2
 psJYlu8RKjJRhfm9rBQLfuu7lRDIPwKKd30KNGmrOuNvhtNn.3ON.5m6nGJ68E9ShnOXNLuDQ8e1
 B8LePWO7dFfcAbiNbVUaeqhE_aAP47Qoano7gfraC_T3GdcvDWAS.DNt0ygcrP7_boCDPO8XrAR_
 fmSUQ11po5eLVt5qe93TV051p4p3lqmdjkHxA8cEK6Cgr1aHQy5odVbGXup92e5iOyn.jDynCf_y
 Y7eKHpLKWDi9Ex2MfgCbIhx1YD7iKtL4FmdnJ_T9ZGS.rnYFkjMGWQjctDO15rAkddeR4f9L2IbB
 MhBb7C6Icf6sKAuXlaZjI9.KAlnzJHx._63sZTHBtqcl2iymeJiLN_lqn1FTlk8jRNM9HutEJVYW
 33xnAnmkluszRwgp_TcngN0T.8wT6VdxuNnZm7PGU488lDx2DZNPnTcR0PMQyOl75DPtOLLuQKUm
 pquqt8tI5ZTQDerUz1qFjOflqWElXgvhToZHxzjIU.QSx4rcAqKYR1RHf7V_9KpBe7AozRP_dkpE
 ho99ki634BdRPaHVcWZXZkbf1X6Z2XPUyBigrv1tOWhGN_fdOmTdlyhjTwQvShTf9lMTTePcCY11
 z8nFA1avcWilOG0h8NS7bRf9xapYTXOZwiEfvNybjC_dQX7g2FFVUsJhbLLNDHRVAsVAOIw2GRjI
 YqXL76IwkQrNkguetFJLkVNEn5UmIiaXxxU3s5hi0A4vEBt6IyVeSruD1pd_4fX_rotjL8vkMjyZ
 dnJ8nxwUKu9xX592kiwEW8D2F3.gw_IYfBuiOZHXY9F9C6vnKPTLIvNMqdieYHRqgGzmxlLBKkIp
 LntzOvGSmwHrEkTr2b7ls28E_Re3onV.7ajOOf2iyt.InyMghTyfEepiOH0Xp6JAD74utMizwrNx
 0baZ8a_2XlPlBktcl5wctzzaE6H._fqvq7VP.o.W6jryaOIg2oiVJ1qX7jpsPvJ_g8ucPlMqIocF
 tRX7ijZ4Jp5MdwKa5LkON_Z4KiT9iQ23u.zsSGScDnRDdWyk.2_GhDlE6x33Ed8EYFfHa6ENeb6l
 m23tSMK.lvaTqCIUNxyIGrG_88eUISxrG1VN9baw1FmlyR3n7jzkLUs5mzoDO4S_Dm3FoDYSUlMO
 Iiulco05tIeFFYxvbxKIMvq86_uNPoFyO68CS2QvRpZTWuINmJAvdnqBIExeZys8XM6xvDJfLTw.
 Xu9ROGBuQLmFDspCnf93pviwYGiHzMAU7fzMgnamJvE6ZmgdOa4_YzhUir0TFC141EHnrV3G_buw
 6SjIndaqq72.IIhQuZiqwyWivLVmTeBW9nLN7eMo9EauqxpLVfQZQ1AFaWesj9a3ZyhViMsLQWQh
 bILI_URzBygO6JkmkGNYB33V7_IAfoDk0DdU9P91UlWTw7M1Uo76yqeVUoCXQ0YLBwBl0gncAsNL
 4k6SgVaPmiAfQiDDXzosECLl9jselqMjTVPXN0RLYqTF.Ke_fkK_GcAKAUFh_ev_Zgfh74_0UpYX
 cho.n85jRrrHzwoFyq1e3L0bMReXdJcsaWaz57A8UBaaERv61VQPFmHhudQ90g8WeXrRJN3bGQTU
 4VnF_PdQb6Wt0383bnVOIkdYBN7G1Fg1BdYcvlw8x5pVyzn8fVC7xaY9o.M65bU2JZvotb34ke1P
 XZur9Is108JLZb2MDiqBwSkKBP3mU57CQ40PM4kPt0yrnJoI.212peEr3jaL5xUfmnyyzD16.o0x
 c0liK5mLLPGzQ06aFJHmRYIDT2jZ0RRKNPiQySzQL.YT1nO61jeiPx4fnz9O_UC_BCxIti9yFIgC
 ix4aa5Y_7mxD6Udo5SovCZQF7xvgu6oUY5WnQSmWWuMU2yapB6lyiPTCr2DYqCe8RSAvrE5rNbM4
 EISHmMDOQHL9dLoN5SUhvwUlVdmM0_I.rZQegRb4.LAvWRxQ7i0KHONRyZD0Ajcx7jSBI9YMUU1T
 U6.PUF0A.APD.WFdscrZaLxiws30Uws5w6EVRoSruJGtqd5BmjSt1p7114T2JpgJ0O7MJYapHP0m
 z.rO0On0B5UFvI3wyAksWccUibG5hToPV.WQUrtS29zzyPKas53xaK30TbS2.__CRYB_5rxONVfM
 JYaeq0ulqLd9ADq48GCOiqrFoKK45hgNmSzjKVGXdTMMB_TimZ4jPJhZk7VAVNXVftorQu2jh.1L
 w5AfibsC5N2EpRjbeA2VUIrH8TGnMg5TW6SH63cO_tvh4b3dsBNnvPT3t_YE0Y7vNZjYHTVGk7qN
 qbsth6i0V_lH9ZluuOhbwzphcuDofwJJeuve9EJVqoJRfQsL3gfcaEkkMQBlh7LC2dcLC5xxTyXG
 h8g9pjMzoUkTXVuV76Oz54QLX.xfEYbilg8AC7Svr1QuFEGQl1DRJHfFYUG2rNWnztTlS6nfay08
 9JOFLMPeZElGJgy60LzHWEzTxtJCQY4e4ZwTL678aZQI4w.GHra0ZR392aFjYZP357nBQ8gQgAN_
 aZ3_8XlUmLFZdGXnBpNOpX_A7EmapTN5meyAl9n1DMybEF0ompHwnZXy8XKwxQxkq12fLZUHFR.3
 iKbbe8QLEGgGYkafhE_.mSJhb2DwWu3bnJ5bjcPLK7nRa3JeymYL5VB.ueR_qlPBHmzzwM1egHRU
 wLfnD1phRmjYm9vy7rbwnHgE34BCZiAjIQF1Siknm8F0GsyuFVIDbrM6q.cUT821HHQt_66qZCRt
 Qrtl4GE1eQiUsk_B8rK4obyYn_EC.cFeVEgyNnY0bv82m8BSW3WreHc_dQXVBNzUI6moCZWf7oD.
 qc8HsU7iXv7Hovxh61d.Zm.6ghtm0c6oBHDMh8IPaIE5aAA3..WWWPkZ3.QvUwGomOky5P5b6V3D
 j52he7wRT15Nrww.AAcc0d937.uAMU96ZVNTYlNnhbhLLhAsQZgLJyiNy5NEC6h0iDUhdIQ6eOE0
 8kx6K0yqpQgoby8x5830bFWmASQIUi3o.O8NOJsciqGsEPRRFJWVkemILMjWnYujbI54_BGPDAhx
 vMn8-
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.ne1.yahoo.com with HTTP; Thu, 22 Jul 2021 01:05:49 +0000
Received: by kubenode531.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID c59849c02fd015e8d97a1c115f73a394;
          Thu, 22 Jul 2021 01:05:46 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH v28 16/25] LSM: Use lsmcontext in security_secid_to_secctx
Date:   Wed, 21 Jul 2021 17:47:49 -0700
Message-Id: <20210722004758.12371-17-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210722004758.12371-1-casey@schaufler-ca.com>
References: <20210722004758.12371-1-casey@schaufler-ca.com>
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
index 8976ac6a5adb..2c3a2348a144 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2459,9 +2459,7 @@ static void binder_transaction(struct binder_proc *proc,
 	binder_size_t last_fixup_min_off = 0;
 	struct binder_context *context = proc->context;
 	int t_debug_id = atomic_inc_return(&binder_last_id);
-	char *secctx = NULL;
-	u32 secctx_sz = 0;
-	struct lsmcontext scaff; /* scaffolding */
+	struct lsmcontext lsmctx = { };
 
 	e = binder_transaction_log_add(&binder_transaction_log);
 	e->debug_id = t_debug_id;
@@ -2724,14 +2722,14 @@ static void binder_transaction(struct binder_proc *proc,
 		 * case well anyway.
 		 */
 		security_task_getsecid_obj(proc->tsk, &blob);
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
@@ -2758,24 +2756,22 @@ static void binder_transaction(struct binder_proc *proc,
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
@@ -2832,7 +2828,7 @@ static void binder_transaction(struct binder_proc *proc,
 	off_end_offset = off_start_offset + tr->offsets_size;
 	sg_buf_offset = ALIGN(off_end_offset, sizeof(void *));
 	sg_buf_end_offset = sg_buf_offset + extra_buffers_size -
-		ALIGN(secctx_sz, sizeof(u64));
+		ALIGN(lsmctx.len, sizeof(u64));
 	off_min = 0;
 	for (buffer_offset = off_start_offset; buffer_offset < off_end_offset;
 	     buffer_offset += sizeof(binder_size_t)) {
@@ -3116,10 +3112,8 @@ static void binder_transaction(struct binder_proc *proc,
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
index 041e87f3fe4e..b19bd9e1d583 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -578,7 +578,7 @@ int security_setprocattr(const char *lsm, const char *name, void *value,
 			 size_t size);
 int security_netlink_send(struct sock *sk, struct sk_buff *skb);
 int security_ismaclabel(const char *name);
-int security_secid_to_secctx(struct lsmblob *blob, char **secdata, u32 *seclen);
+int security_secid_to_secctx(struct lsmblob *blob, struct lsmcontext *cp);
 int security_secctx_to_secid(const char *secdata, u32 seclen,
 			     struct lsmblob *blob);
 void security_release_secctx(struct lsmcontext *cp);
@@ -1433,7 +1433,7 @@ static inline int security_ismaclabel(const char *name)
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
index c17ec23158c4..841123390d41 100644
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
@@ -2132,26 +2130,23 @@ void audit_log_key(struct audit_buffer *ab, char *key)
 
 int audit_log_task_context(struct audit_buffer *ab)
 {
-	char *ctx = NULL;
-	unsigned len;
 	int error;
 	struct lsmblob blob;
-	struct lsmcontext scaff; /* scaffolding */
+	struct lsmcontext context;
 
 	security_task_getsecid_subj(current, &blob);
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
index 1b1ddd62de6c..d198f307a4d8 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1002,9 +1002,7 @@ static int audit_log_pid_context(struct audit_context *context, pid_t pid,
 				 struct lsmblob *blob, char *comm)
 {
 	struct audit_buffer *ab;
-	struct lsmcontext lsmcxt;
-	char *ctx = NULL;
-	u32 len;
+	struct lsmcontext lsmctx;
 	int rc = 0;
 
 	ab = audit_log_start(context, GFP_KERNEL, AUDIT_OBJ_PID);
@@ -1015,13 +1013,12 @@ static int audit_log_pid_context(struct audit_context *context, pid_t pid,
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
@@ -1234,7 +1231,6 @@ static void audit_log_fcaps(struct audit_buffer *ab, struct audit_names *name)
 
 static void show_special(struct audit_context *context, int *call_panic)
 {
-	struct lsmcontext lsmcxt;
 	struct audit_buffer *ab;
 	int i;
 
@@ -1259,17 +1255,15 @@ static void show_special(struct audit_context *context, int *call_panic)
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
@@ -1418,20 +1412,17 @@ static void audit_log_name(struct audit_context *context, struct audit_names *n,
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
index 89be957f26bd..668b31ecd638 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -339,8 +339,7 @@ static int ctnetlink_dump_mark(struct sk_buff *skb, const struct nf_conn *ct)
 static int ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
 {
 	struct nlattr *nest_secctx;
-	int len, ret;
-	char *secctx;
+	int ret;
 	struct lsmblob blob;
 	struct lsmcontext context;
 
@@ -348,7 +347,7 @@ static int ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
 	 * security_secid_to_secctx() will know which security module
 	 * to use to create the secctx.  */
 	lsmblob_init(&blob, ct->secmark);
-	ret = security_secid_to_secctx(&blob, &secctx, &len);
+	ret = security_secid_to_secctx(&blob, &context);
 	if (ret)
 		return 0;
 
@@ -357,13 +356,12 @@ static int ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
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
@@ -658,15 +656,15 @@ static inline int ctnetlink_secctx_size(const struct nf_conn *ct)
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
index ca2ae290d6ee..b5796a8e5e90 100644
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
index 005900a0c397..d5cff4559237 100644
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
index 61346aaa2898..9910d3e9d287 100644
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
index 4cb540d93ab8..713e0340a0d4 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2325,18 +2325,22 @@ int security_ismaclabel(const char *name)
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
2.31.1

