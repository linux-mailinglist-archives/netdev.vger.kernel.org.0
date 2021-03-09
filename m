Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA32F332982
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 16:01:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231718AbhCIPBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 10:01:14 -0500
Received: from sonic313-14.consmr.mail.ne1.yahoo.com ([66.163.185.37]:45015
        "EHLO sonic313-14.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231393AbhCIPAj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 10:00:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1615302039; bh=fqIXKdEyjJ9CliJ8wDI5KKMLcufMAvwpUcNeZ1GoA4w=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=P/1M/aFJOjuyHiwmTNvbU4frPfzkfc+5rCw/3S253QkpOoC+1TFZPteRWhfa6gCSfsXKovN8JofKPeZYzc6H7lBG6VBTme7JLGCZCVF7HygiZe7xChtZZX0HdW2An27ti9iFDFC7RLnwLeo3XlunJ6uaXF6itWz/b2QpkMAuKB6FL2ixQotOL+o8nxixetBND+u7+68s18+9Cf9cODcdrZPMcZLOCriwLDDDLo8Nh1miZRYSDI/Smp+23qYui3buUaJ/MO4jtr7xp5pO9LcWNa7zf5vexhCVfvUuTUN1h56Jaj9X82mZQZhBVdRJJA/D4jWszwM14OukdVeiXXuQLA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1615302039; bh=3CnFWksLkYGaXlHYyqOqV6YzA6690cGQlXoeiP9fQZ9=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=fQGZXfcyixao6Rhyc4grDu818Rl00NsV1TPuyOv+Ivmmpw3QgOGO+FSRHs5sh7dEoxBYlHARuj8VTt5yb7sbV3M8zIfEgMxPnG57kiHBs8oh7VC/VpJRLEvEBD3r9EEgXqWvbQwIeBV6izKp+lMfgsvnJ6fL27gFGVYDFshidaH76yBThE5X2XrWqd9MZZUSy1PlUFlnpJcP3qErOav49PCEr76hwNU9XuLfYto6J4btzOqcK8oY7+MudW4PLwvWDwSpdCLs3fwhExDIXGRFcbZkaL+CsIwJb+DVJcpkN3yCVeLFor6wjJFgJDQkKQ3NWJotulDIwYlf/emTDHecfA==
X-YMail-OSG: 2WghRAIVM1lC9tPtSsxK5_FCqhrEAnksZWRc0mCV3wlw6uRzxLSZmK7p60fnoDa
 8l6TGWp48H6cEsbTZO4yyHAqV3zw_6aLeYiuZ2G61UIsqSwTd0OBSoq0zehgl9L9pNi_yyeL9fJM
 Hf81JcoiIyNpbctX7kdqq8ZfHFiSUX_2ORwlCz_T89jzHXptH638ycDuod5WrN1qWttXWJg5joBp
 Uu9gfRVbnQMivCBzuWY9p2q9jg6qPGAsge7c4wl1a2Jr_nCS8XqDcLEchFZp7ETilt3ivMMdKkS7
 OP58FOHj_Hivt5QDsHYwI6LxR1SMISbcrJ2jk0xjP9kR1YxwTcWr91K2LV.Y4ClB7Fn8nnxql8_Q
 H8_NAU_Pa8Do696192OO5.6gTcgTCEeWZuqWmzIJmzMIBeNKw.eim.sTnsusx5XyYqTQXVznQaLU
 AvYsLy6kCYq.Fbg8TxjKKEInvAvvvfYNdgxjXczsFLL.UMiuCbkYjl3q7BpFmG1rjYiKK65FasVA
 qvRBWT5ydu6kJUxCbkC4kmrUfyoJrg9TV9FIG_TGg6BuKyEaMQd3C83NzoBLkxfNOpShLyc.949c
 FUp_r82IjZwswSnTxfeG3qfW7MKA6OA8CJ9QfsJIx8fHnWoO45QY_9n9FqUmwHw.cp_BllP2oZ6h
 VygGOdFN7zTeOwLQgOGTsJ.s_huqVJlaOfCVgyfROcC581QSsvKvdWupRfgzIWBx38LXuiaNWY8Q
 DsnZCCMYtPpUbztxhf4KpJEbB4S6rc10mr_CUHNs68fyP3aM0EVwP4xKz9uYuydKXgL3xNtg6h7i
 u7vH3VFjA4XXZdAw551S3Ytbb5nsn_hTsNz1YHBR90AdnSS3L4xRv3dioX_IS2guWtN0fYuaMq35
 LoV4WkfzsRKBydi3F7VLat32aLgVpDegGMonUlurlM7gKOmpyMYzcIBNceggtZqDFb.FjrkZI1RW
 4CJ7iBBHKvCX.g0Xkom6U2qh8nBrJNFTqnD2XlW7f1Iz8nvlyAyPRDSluwwq3mZC8pSJf637CFyp
 L560Q5oMBACwLQE9tw_aV6CPotZ.29J4xZdEWhAmVlKBVaeW3Bvs6gH5TcYVH0R1S1.DS6.ARfng
 HofLWYRNlmVY34d6Rxbo3cAUYecSM6cGTvGvBC9ytBsVTGTMg9_2G4VhMxIk4xbicDy6rhlxkss_
 eKQzNewe6XMq9.CpCc.SLYODIF6QDSiZMgDEw2tCQTbciBH3MpC3puYT8bCgwElIYvDigAmmEAfL
 l5aDsFfpWjHsgg4IwAFB6T_7m2kDLFFtu1jnZECsSy0W3xN8k5cGJvOdndt38oDTFlmXvI9Xu8NS
 NzekDljNZu.QkjwRb1XtlCZi.KkzmDJHqBkF9JpBtlYgVE3hz3BIyxahselTBJs87pNiee6K_NjA
 pLpryrm_3zEujiMu3Ah.BwXOYFU20q97XgnVccB.Upe82Lk7qOLyusnrQ7QUWxh.D4jbvAN2PHoL
 QX5qxVht9dK5awo9EvpJXMYCH8T9_5H9URk4qdDTrq3V29Ynk_7foLmcSPe0esRxPiD2KQDNY.fV
 bVqdJYDnXRPMYeBbDtKEiLDNkpICwUY0qrBRS1vnADoWlwEKH_72eeq4zIHz5ZFeXdvJzwhhUu1_
 eXsiIZEn7dhpZTRVrWMgVem2LDxmrNuS2o.Bl8slrFeSzVfQQ6MpkzKgZDKgU_pfg4vvo.HuJvEk
 X7wTLvDk8V7HxHzck_f0cWCrKIIpgcilL7rsJ_Jvk1fWnQNB.ufS2_nR84PJ4w.uwk0_.m9dVJYT
 IhDwzZHQQKDAjhlq.EfB.I5UYMGJ2audUoTjdeK9355WXPMM0NCf0E0z_LATQ7T0PWgvzi.NbJXS
 IYlLGAWu8bOwevKafMcMCM.NfROcNPfHNpy0l3JIIzGOqJEAuVCqTeGKt6rMt0Bvngcl7_0kIj9c
 MbTs9zaQhW3QuWTZa0ykzXpmaTDAgu4lR_TwMmbah6e_Rs0rfTsHPruG6oo4s45YKyFsgF5cApqj
 FS4G3nHOqEAGn_90M3s9BEmN_OsTyQlFG1G3.jNka2KWGvMP2rSXLZ.9PMCoIOS.30eBumrtSCXC
 p1vnEIFZ0pEXTO21hdhbLTZqd8V_7sAE6BJg8Rcu_vVVENCYWuGNBL1RY_c434X9zYB6szje21IH
 mvgb6SgduHyJ8qaah4XfE.7rPGaOe4hJVpObdFukNnRK09ZEllTjHXcALIQ9humgW.ObAjc2e3w9
 vSjGuPWA8ZOYIi2FaDF29JYRTN5CCOiIfZsgLjc9RoxvcDAVotuW7F6LVlTAOzKb64DAowRTavrs
 BmUGaBJEfZqWMTpAFpfYPq46ByeqOj4B0VoRYsmr24cZ26dFITXiBy8.5Okezc9yddgAn9BritFA
 TBU3OTCxT.KX6m9iEyUVJaISegRae4qiFUxZji16QE.X7yDJgfSuJIuxu8xGzMHiXXs2mkYLqulK
 eTj85lgAQ3pWRTux2FE7TLlncjwep7s8h1wxfAMhTEOBhKy5hqQjdQmCJuj2jw6RWvXvBT0OMM.R
 pkrLEMQhKSQco_9OdD7TL7TornqLzAdkuFRzorVNTKN6Gf80fikibT8HkvtejQIgxwPJZSWRctAU
 PEWa2NSmYacIH_LMuUEnBWgDKAC_jEhkIgGSLRr3it1K_m_Cy9Sw5_UbmEirdPQbJ0CAqbo1Ij88
 cRu59fFc6i2Jp6FrvtKsfFDbXZWN_1yxu9riQc8ecZnIN8txwTlFBGZkvHp6Sr5DNxGMKS.2Y49M
 oYmCYeZfe8q67uXhxBV0pmNGYwz9QL0hwsTcb9uZmk2wXAnsYXPEiere0gUnpmcC1DMFXzjW_nny
 ka_g7GBL9AWyTDYRnmLUFYyn6wFD8bmpZR3SeaOhW2Mkka4wtXP3hVspHmIKArY4lfE4eoUVlFlh
 ksAMIoCGdBqeky1oMQ9MFTVCmo9LrrhF6yjk7E58_I7Fldzxrl41jBXDWkVmhdJSMuwO1BgeQxFd
 i7uRhEtK5_GHMnGiKbFKJuCoVxVdxWvOUF0xvGaPgiOqfKYrH3oQa87MxTQzbovF85082s8gm5QU
 6ju61p0iat37SbOjosSEgaIJzSijRwrX7eOoOSASJCb9M0P3tUKL2RBx3IreJYdcEZn5.b0aJCri
 vhMjZynuMqa1_PZFyoWHqk5JbOE7pefLdmaR2aKIDRcBNcND.LgcA_FJNNk7jzlHl.XE27KaArz.
 cjQidxBQ6tiTPEnmzaxqnFSUWjczjCxe3DE.WucrtntHFPNObx6FFn9Kh9onWx_dn2aO_
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.ne1.yahoo.com with HTTP; Tue, 9 Mar 2021 15:00:39 +0000
Received: by smtp410.mail.bf1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID f41cd409b216605d7a8190a333a6c8b3;
          Tue, 09 Mar 2021 15:00:35 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH v25 16/25] LSM: Use lsmcontext in security_secid_to_secctx
Date:   Tue,  9 Mar 2021 06:42:34 -0800
Message-Id: <20210309144243.12519-17-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210309144243.12519-1-casey@schaufler-ca.com>
References: <20210309144243.12519-1-casey@schaufler-ca.com>
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
index f74a72867ec9..4c810ea52ab7 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2446,9 +2446,7 @@ static void binder_transaction(struct binder_proc *proc,
 	binder_size_t last_fixup_min_off = 0;
 	struct binder_context *context = proc->context;
 	int t_debug_id = atomic_inc_return(&binder_last_id);
-	char *secctx = NULL;
-	u32 secctx_sz = 0;
-	struct lsmcontext scaff; /* scaffolding */
+	struct lsmcontext lsmctx = { };
 
 	e = binder_transaction_log_add(&binder_transaction_log);
 	e->debug_id = t_debug_id;
@@ -2702,14 +2700,14 @@ static void binder_transaction(struct binder_proc *proc,
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
@@ -2736,24 +2734,22 @@ static void binder_transaction(struct binder_proc *proc,
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
@@ -2810,7 +2806,7 @@ static void binder_transaction(struct binder_proc *proc,
 	off_end_offset = off_start_offset + tr->offsets_size;
 	sg_buf_offset = ALIGN(off_end_offset, sizeof(void *));
 	sg_buf_end_offset = sg_buf_offset + extra_buffers_size -
-		ALIGN(secctx_sz, sizeof(u64));
+		ALIGN(lsmctx.len, sizeof(u64));
 	off_min = 0;
 	for (buffer_offset = off_start_offset; buffer_offset < off_end_offset;
 	     buffer_offset += sizeof(binder_size_t)) {
@@ -3086,10 +3082,8 @@ static void binder_transaction(struct binder_proc *proc,
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
index 554e9da831b6..d0e1b6ba330d 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -575,7 +575,7 @@ int security_setprocattr(const char *lsm, const char *name, void *value,
 			 size_t size);
 int security_netlink_send(struct sock *sk, struct sk_buff *skb);
 int security_ismaclabel(const char *name);
-int security_secid_to_secctx(struct lsmblob *blob, char **secdata, u32 *seclen);
+int security_secid_to_secctx(struct lsmblob *blob, struct lsmcontext *cp);
 int security_secctx_to_secid(const char *secdata, u32 seclen,
 			     struct lsmblob *blob);
 void security_release_secctx(struct lsmcontext *cp);
@@ -1414,7 +1414,7 @@ static inline int security_ismaclabel(const char *name)
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
index bfb4696503b7..a8dc5f55cfa3 100644
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
index caa69696672e..3db1ec97720e 100644
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
@@ -1411,20 +1405,17 @@ static void audit_log_name(struct audit_context *context, struct audit_names *n,
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
index 6edb78c9cc87..f14c0049d7cc 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -336,8 +336,7 @@ static int ctnetlink_dump_mark(struct sk_buff *skb, const struct nf_conn *ct)
 static int ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
 {
 	struct nlattr *nest_secctx;
-	int len, ret;
-	char *secctx;
+	int ret;
 	struct lsmblob blob;
 	struct lsmcontext context;
 
@@ -345,7 +344,7 @@ static int ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
 	 * security_secid_to_secctx() will know which security module
 	 * to use to create the secctx.  */
 	lsmblob_init(&blob, ct->secmark);
-	ret = security_secid_to_secctx(&blob, &secctx, &len);
+	ret = security_secid_to_secctx(&blob, &context);
 	if (ret)
 		return 0;
 
@@ -354,13 +353,12 @@ static int ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
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
@@ -660,15 +658,15 @@ static inline int ctnetlink_secctx_size(const struct nf_conn *ct)
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
index 5ee033a1f885..241089cb7e20 100644
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
index 08ca87fa97b7..449c2c7c7b27 100644
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
index 32b6eea7ba0c..aa53a94115f4 100644
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
index f1c1b387bc63..73fb5c6c4cf8 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2265,18 +2265,22 @@ int security_ismaclabel(const char *name)
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
2.29.2

