Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB3F5031A6
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 01:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354770AbiDOVaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 17:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354646AbiDOV3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 17:29:50 -0400
Received: from sonic317-39.consmr.mail.ne1.yahoo.com (sonic317-39.consmr.mail.ne1.yahoo.com [66.163.184.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C4CD3AF4
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 14:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1650057986; bh=w40bsvxz1maTfxCP5OPrFydafSqo7FsPfYgUwwtQr5s=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=oaWhSOQqIp+rGNYrrZYea0GYlJWahNtcVJXx52K7Q1T5ih0jUcgRAomNEe6IgKO+JzKhb479tkPrm+kJEahXZnxkB1gpppVZGFem3AQwMt4pFj6nhFi/JxDMKWDrXdVcQFBfjSr06jYACcf7B/9u2p7GfCxGisyYIuqRTJQP5zidaxdeALsJ9Llj7WSXtywcOUmZOEe0Lr5cytQeWh5xChNGVKA9fm3ss7AgC05rF6grEMwCVS4lhsiEeRI/nei4oqY0qR07tGfilW88Rq1AsuBXrhuRmBVINX3KNTe7uzt0DOOK3IByMNVDZ4tfQuapxVq3GI0y8UK+TDJVUrNqTA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1650057986; bh=wtsVw27xPLxCqSUmhyj2kv6qS02lu4MpXdzUpNISyxE=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=b9EgObqnQ4SxI6ZMwLUpCiyZ4v2VYkyjGZb0vSer9vhKiQbR0O1BHH7iosdIEPjUOimgdIF8cE2r361/7AbFGFmA+bhGs5HoAHGXxxAHvgVsQ6dTCx5hPA/zzecqk1ZXZwP5G0gXttvuEnzbVDfWASL13DN6wYrk8oy0lkZMJdsfst+agvee3q1emdVHgg4rHaEJQo6JuRTTslBAe5GCkQzI1pQmGiIhmua7x2IfzI9hRQSXjV1KZwnKAVnEGH+omcsgxOUk6KNzFg4afJ5EmH44a5mglvMuyKMK1u5ooqpoPao1F0UNr9cppLeiHqCBWdlQNlSdJXS9shFsTiId/g==
X-YMail-OSG: 9xZ8PEoVM1mW32.vc1fypnK.bH.ALuse3KHHMY_77QrA0519_TtZjc42HsYa89m
 Gy1D8oYYEjwGVRmX_7AK..rnKetjAQq3JPaQYROyEQY4R5ns6tq.rHn.czKbtHY_Yqw5Hm96JpxD
 Y6SqVXhqiLfdI_4NnWzFVFN1KmXzBfCyq83IJZh1MNWCpUFNy8P674l5VkCLW5CGWXH6Wg5M4bkn
 5_xaF4nXr7aflAuK1BXQG3Iea0oWEEj8j.4jELzgUXTgpvJKUtE_X4p9mnTRt6NluHBmlwCCYNhQ
 AvFSnwHutgrf8i85SfqTAE1S58JR3FsbyBB6pBgXwCmkBAW58hdOLIXK9IpjfJM1jx07CC5rBHSJ
 y3HqpZzwDjj1AKije.I0WfE89pYkOvRnmQJOK1Gdam.nzh4cTkoK8dsYW8aFRZTQh2h04DGRZTbZ
 6b.eTH.55q_jsXMQ_Rh.IdxLa1KppPdo_Btb_oqgoxb3pphcWmdYhjEkuPGvbC_OD43.EJDEUPyq
 9J6ilPF9VKgOk5S8att5m4sasrH7qHdM05_GDVq5OQAPZsj6_npGvYemqzdBQkASiUVFxOEyUfwb
 yt1R57t5Gu2wz9C.UeACW3UL2OJFmKn4rArEy1IWtpr0cR2qIXmfXgd2ZEuwZD0aNI6Sx.4b5IFE
 vc0f8ax55H.EJ40RxDaY49yhhAKo42SLYe0MPReniJaIvkEoXLEuX1YnVSsF3vQiI6onJpenuskP
 PYKEsYUjI93WvUFrAlF1ypcRO8Ko9a_LfJtRcXczAl7nScMogGpIytloV.5coObgyi3D8G7gXOyC
 A1o9hkzaZCzUrEVOf6RYrzs1QqBFK5.iLBuYQVezc8KF5JjFxA7xOPoFUez4I9zn8h38xQOVhCOn
 YLX0pe7dAQSBLR.CTKmPP9A2maqCcJX3F05sIBTayM_.wVek13hisuzvCDDCR7x8tTmDVVqcDR9Y
 pQ.keSVQiyL2Eb3X5m6JnUmFKIEYLZHVUULnnZ2CcvHuP5I.mzwjB4QSFYturfP9mqbtVbmqthgn
 RG09BwH0OWqftvEh6LE8DVzgNOqEy71RD6VbZN73nfjGkwfLxvjS8aaUkLGii6BbdJkGwl8zDTkM
 bBf2XFrLDYDu6p1a5u3gGGTkVj_PGLAxwOuGsJReKTwO8Jhr32dmwL5pdLMFWMG_FcGt1xYyebcI
 5hwme_TecnhZPF.nRYEUPvKK3ncVcSAYJDl6yLxEQtsn5TBMADH3pMclUqao7WIHS7eOLYRABsmw
 qFn.PKLS.snJ7HUEX52cP7YYWpR27738ycMd4KMAYhZhmkwzR3B9uBEbnRKQ40g5ySoqIYMTPf5F
 8akn2qMK05q.y1keQwVdZyEo9ZUYg3GbmF8hqPLk3fqWUSguC3xTXnY_GU.RHaR0pypJuTOAwmUH
 Xr2BG8dWcp___ggl_IUSxhbLYV0tvwG8JANi2pzl6Zm1Nq96xq4p6BvphFTCi0GpmcmC66F8maOR
 GwFIrKxzItNje3Ho0xvjWXM8JH4vGPh2b.Nzw5Q8uwo2fYFwQiFzQH2QlYn9sLPnj2PdnrVTpfgi
 Y5AIfKZ7aBB7le_YvvinWkRhz5EsMwdP8bh8r2E8IQhmNv8JTLkC1Sj6XLrzqientNtm6LTQlSk6
 OkAH3Ug1adE1tOdL..LXViHXzhLeV_qY0UGFOtJY6NwpCdrALzlbmPvhLd9S9Pruv.1Nn_NWV5MU
 NFVc8_rY77UKOO8aEJwNRE6Gsvo36G_50pVvdp7K7ACW1kcCkgwxDo4xutIegzao2MEmzMC8sxVR
 hBLphO1YG.B15FwBBrlZ2zFPS4hRfZ6Owdr0PhjMj31BhgNZQ0D40w3.qlPpN6JgcEtjYQj0d36Q
 dv2fkubweaxDaNP4YvdVUOJXOFExPpnFUM8c7fV76fVA2lm58ZpEDlWC5ma0vIpDRXzlK9Hrq.GF
 itlNMm78cxQthfMEMV2.2ERD8Tu9DtgKeLxXfyLJM_npMrWQflBqk8TeyWpdAjjbovsqN_OD0yHA
 0U1W8YB5HDzxgUmI3D_uk0R9FJj0FCqtV7FRl45mYV19EMR7ru3wSV.9gOBD7Rz4gBI4u8oE14AM
 ekLgstzIYk1dNKQ2MUHZCeuV6NRvrBT4V.73_hPmDuAD5OyJyRxJzGFdRcNBWdvE3dQ94xA8GAZI
 pgOJPoLo9vHJ3neRvpotByRQIBKWcrYj3c0jT7Wfr96GGMlqR5zrREKpDNLdftzT3mY_Fx2vDs1l
 LK0x2f2TIYuejTdz3JbmYuZYmYT_PpPIeavBc7XaADzusMyWtEJ3s1aEyK6lC923IITCwf0K1CGL
 8UJt8jso03ROxIY_wkPrTcmkcJJfgMFk-
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic317.consmr.mail.ne1.yahoo.com with HTTP; Fri, 15 Apr 2022 21:26:26 +0000
Received: by hermes--canary-production-ne1-c7c4f6977-8bhqd (VZM Hermes SMTP Server) with ESMTPA ID 6a671e6207f140a4363de0fabf2a4e74;
          Fri, 15 Apr 2022 21:26:25 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        stephen.smalley.work@gmail.com, linux-kernel@vger.kernel.org,
        Chuck Lever <chuck.lever@oracle.com>,
        linux-integrity@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: [PATCH v34 15/29] LSM: Ensure the correct LSM context releaser
Date:   Fri, 15 Apr 2022 14:17:47 -0700
Message-Id: <20220415211801.12667-16-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220415211801.12667-1-casey@schaufler-ca.com>
References: <20220415211801.12667-1-casey@schaufler-ca.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new lsmcontext data structure to hold all the information
about a "security context", including the string, its size and
which LSM allocated the string. The allocation information is
necessary because LSMs have different policies regarding the
lifecycle of these strings. SELinux allocates and destroys
them on each use, whereas Smack provides a pointer to an entry
in a list that never goes away.

Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: John Johansen <john.johansen@canonical.com>
Acked-by: Paul Moore <paul@paul-moore.com>
Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Acked-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-integrity@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-audit@redhat.com
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: linux-nfs@vger.kernel.org
---
 drivers/android/binder.c                | 10 ++++---
 fs/ceph/xattr.c                         |  6 ++++-
 fs/nfs/nfs4proc.c                       |  8 ++++--
 fs/nfsd/nfs4xdr.c                       |  7 +++--
 include/linux/security.h                | 35 +++++++++++++++++++++++--
 include/net/scm.h                       |  5 +++-
 kernel/audit.c                          | 14 +++++++---
 kernel/auditsc.c                        | 12 ++++++---
 net/ipv4/ip_sockglue.c                  |  4 ++-
 net/netfilter/nf_conntrack_netlink.c    |  4 ++-
 net/netfilter/nf_conntrack_standalone.c |  4 ++-
 net/netfilter/nfnetlink_queue.c         | 13 ++++++---
 net/netlabel/netlabel_unlabeled.c       | 19 +++++++++++---
 net/netlabel/netlabel_user.c            |  4 ++-
 security/security.c                     | 11 ++++----
 15 files changed, 121 insertions(+), 35 deletions(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 26838061defb..2125b4b795da 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2725,6 +2725,7 @@ static void binder_transaction(struct binder_proc *proc,
 	int t_debug_id = atomic_inc_return(&binder_last_id);
 	char *secctx = NULL;
 	u32 secctx_sz = 0;
+	struct lsmcontext scaff; /* scaffolding */
 	struct list_head sgc_head;
 	struct list_head pf_head;
 	const void __user *user_buffer = (const void __user *)
@@ -3033,7 +3034,8 @@ static void binder_transaction(struct binder_proc *proc,
 			t->security_ctx = 0;
 			WARN_ON(1);
 		}
-		security_release_secctx(secctx, secctx_sz);
+		lsmcontext_init(&scaff, secctx, secctx_sz, 0);
+		security_release_secctx(&scaff);
 		secctx = NULL;
 	}
 	t->buffer->debug_id = t->debug_id;
@@ -3433,8 +3435,10 @@ static void binder_transaction(struct binder_proc *proc,
 	binder_alloc_free_buf(&target_proc->alloc, t->buffer);
 err_binder_alloc_buf_failed:
 err_bad_extra_size:
-	if (secctx)
-		security_release_secctx(secctx, secctx_sz);
+	if (secctx) {
+		lsmcontext_init(&scaff, secctx, secctx_sz, 0);
+		security_release_secctx(&scaff);
+	}
 err_get_secctx_failed:
 	kfree(tcomplete);
 	binder_stats_deleted(BINDER_STAT_TRANSACTION_COMPLETE);
diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index afec84088471..8ac30a5c05ef 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -1383,12 +1383,16 @@ int ceph_security_init_secctx(struct dentry *dentry, umode_t mode,
 
 void ceph_release_acl_sec_ctx(struct ceph_acl_sec_ctx *as_ctx)
 {
+#ifdef CONFIG_CEPH_FS_SECURITY_LABEL
+	struct lsmcontext scaff; /* scaffolding */
+#endif
 #ifdef CONFIG_CEPH_FS_POSIX_ACL
 	posix_acl_release(as_ctx->acl);
 	posix_acl_release(as_ctx->default_acl);
 #endif
 #ifdef CONFIG_CEPH_FS_SECURITY_LABEL
-	security_release_secctx(as_ctx->sec_ctx, as_ctx->sec_ctxlen);
+	lsmcontext_init(&scaff, as_ctx->sec_ctx, as_ctx->sec_ctxlen, 0);
+	security_release_secctx(&scaff);
 #endif
 	if (as_ctx->pagelist)
 		ceph_pagelist_release(as_ctx->pagelist);
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index e3f5b380cefe..9d84e592e7d3 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -133,8 +133,12 @@ nfs4_label_init_security(struct inode *dir, struct dentry *dentry,
 static inline void
 nfs4_label_release_security(struct nfs4_label *label)
 {
-	if (label)
-		security_release_secctx(label->label, label->len);
+	struct lsmcontext scaff; /* scaffolding */
+
+	if (label) {
+		lsmcontext_init(&scaff, label->label, label->len, 0);
+		security_release_secctx(&scaff);
+	}
 }
 static inline u32 *nfs4_bitmask(struct nfs_server *server, struct nfs4_label *label)
 {
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index da92e7d2ab6a..77388b5ece56 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2830,6 +2830,7 @@ nfsd4_encode_fattr(struct xdr_stream *xdr, struct svc_fh *fhp,
 	int err;
 	struct nfs4_acl *acl = NULL;
 #ifdef CONFIG_NFSD_V4_SECURITY_LABEL
+	struct lsmcontext scaff; /* scaffolding */
 	void *context = NULL;
 	int contextlen;
 #endif
@@ -3341,8 +3342,10 @@ nfsd4_encode_fattr(struct xdr_stream *xdr, struct svc_fh *fhp,
 
 out:
 #ifdef CONFIG_NFSD_V4_SECURITY_LABEL
-	if (context)
-		security_release_secctx(context, contextlen);
+	if (context) {
+		lsmcontext_init(&scaff, context, contextlen, 0); /*scaffolding*/
+		security_release_secctx(&scaff);
+	}
 #endif /* CONFIG_NFSD_V4_SECURITY_LABEL */
 	kfree(acl);
 	if (tempfh) {
diff --git a/include/linux/security.h b/include/linux/security.h
index 4a4abda5d06d..ce63621c45af 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -135,6 +135,37 @@ enum lockdown_reason {
 
 extern const char *const lockdown_reasons[LOCKDOWN_CONFIDENTIALITY_MAX+1];
 
+/*
+ * A "security context" is the text representation of
+ * the information used by LSMs.
+ * This structure contains the string, its length, and which LSM
+ * it is useful for.
+ */
+struct lsmcontext {
+	char	*context;	/* Provided by the module */
+	u32	len;
+	int	slot;		/* Identifies the module */
+};
+
+/**
+ * lsmcontext_init - initialize an lsmcontext structure.
+ * @cp: Pointer to the context to initialize
+ * @context: Initial context, or NULL
+ * @size: Size of context, or 0
+ * @slot: Which LSM provided the context
+ *
+ * Fill in the lsmcontext from the provided information.
+ * This is a scaffolding function that will be removed when
+ * lsmcontext integration is complete.
+ */
+static inline void lsmcontext_init(struct lsmcontext *cp, char *context,
+				   u32 size, int slot)
+{
+	cp->slot = slot;
+	cp->context = context;
+	cp->len = size;
+}
+
 /*
  * Data exported by the security modules
  *
@@ -569,7 +600,7 @@ int security_ismaclabel(const char *name);
 int security_secid_to_secctx(struct lsmblob *blob, char **secdata, u32 *seclen);
 int security_secctx_to_secid(const char *secdata, u32 seclen,
 			     struct lsmblob *blob);
-void security_release_secctx(char *secdata, u32 seclen);
+void security_release_secctx(struct lsmcontext *cp);
 void security_inode_invalidate_secctx(struct inode *inode);
 int security_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen);
 int security_inode_setsecctx(struct dentry *dentry, void *ctx, u32 ctxlen);
@@ -1432,7 +1463,7 @@ static inline int security_secctx_to_secid(const char *secdata,
 	return -EOPNOTSUPP;
 }
 
-static inline void security_release_secctx(char *secdata, u32 seclen)
+static inline void security_release_secctx(struct lsmcontext *cp)
 {
 }
 
diff --git a/include/net/scm.h b/include/net/scm.h
index 23a35ff1b3f2..f273c4d777ec 100644
--- a/include/net/scm.h
+++ b/include/net/scm.h
@@ -92,6 +92,7 @@ static __inline__ int scm_send(struct socket *sock, struct msghdr *msg,
 #ifdef CONFIG_SECURITY_NETWORK
 static inline void scm_passec(struct socket *sock, struct msghdr *msg, struct scm_cookie *scm)
 {
+	struct lsmcontext context;
 	struct lsmblob lb;
 	char *secdata;
 	u32 seclen;
@@ -106,7 +107,9 @@ static inline void scm_passec(struct socket *sock, struct msghdr *msg, struct sc
 
 		if (!err) {
 			put_cmsg(msg, SOL_SOCKET, SCM_SECURITY, seclen, secdata);
-			security_release_secctx(secdata, seclen);
+			/*scaffolding*/
+			lsmcontext_init(&context, secdata, seclen, 0);
+			security_release_secctx(&context);
 		}
 	}
 }
diff --git a/kernel/audit.c b/kernel/audit.c
index 2b670ac129be..0eff57959b4e 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1214,6 +1214,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 	struct audit_sig_info   *sig_data;
 	char			*ctx = NULL;
 	u32			len;
+	struct lsmcontext	scaff; /* scaffolding */
 
 	err = audit_netlink_ok(skb, msg_type);
 	if (err)
@@ -1471,15 +1472,18 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		}
 		sig_data = kmalloc(struct_size(sig_data, ctx, len), GFP_KERNEL);
 		if (!sig_data) {
-			if (lsmblob_is_set(&audit_sig_lsm))
-				security_release_secctx(ctx, len);
+			if (lsmblob_is_set(&audit_sig_lsm)) {
+				lsmcontext_init(&scaff, ctx, len, 0);
+				security_release_secctx(&scaff);
+			}
 			return -ENOMEM;
 		}
 		sig_data->uid = from_kuid(&init_user_ns, audit_sig_uid);
 		sig_data->pid = audit_sig_pid;
 		if (lsmblob_is_set(&audit_sig_lsm)) {
 			memcpy(sig_data->ctx, ctx, len);
-			security_release_secctx(ctx, len);
+			lsmcontext_init(&scaff, ctx, len, 0);
+			security_release_secctx(&scaff);
 		}
 		audit_send_reply(skb, seq, AUDIT_SIGNAL_INFO, 0, 0,
 				 sig_data, struct_size(sig_data, ctx, len));
@@ -2171,6 +2175,7 @@ int audit_log_task_context(struct audit_buffer *ab)
 	unsigned len;
 	int error;
 	struct lsmblob blob;
+	struct lsmcontext scaff; /* scaffolding */
 
 	security_current_getsecid_subj(&blob);
 	if (!lsmblob_is_set(&blob))
@@ -2185,7 +2190,8 @@ int audit_log_task_context(struct audit_buffer *ab)
 	}
 
 	audit_log_format(ab, " subj=%s", ctx);
-	security_release_secctx(ctx, len);
+	lsmcontext_init(&scaff, ctx, len, 0);
+	security_release_secctx(&scaff);
 	return 0;
 
 error_path:
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 2b27ef99f0f6..2202952c830d 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1121,6 +1121,7 @@ static int audit_log_pid_context(struct audit_context *context, pid_t pid,
 				 struct lsmblob *blob, char *comm)
 {
 	struct audit_buffer *ab;
+	struct lsmcontext lsmcxt;
 	char *ctx = NULL;
 	u32 len;
 	int rc = 0;
@@ -1138,7 +1139,8 @@ static int audit_log_pid_context(struct audit_context *context, pid_t pid,
 			rc = 1;
 		} else {
 			audit_log_format(ab, " obj=%s", ctx);
-			security_release_secctx(ctx, len);
+			lsmcontext_init(&lsmcxt, ctx, len, 0); /*scaffolding*/
+			security_release_secctx(&lsmcxt);
 		}
 	}
 	audit_log_format(ab, " ocomm=");
@@ -1398,6 +1400,7 @@ static void audit_log_time(struct audit_context *context, struct audit_buffer **
 
 static void show_special(struct audit_context *context, int *call_panic)
 {
+	struct lsmcontext lsmcxt;
 	struct audit_buffer *ab;
 	int i;
 
@@ -1432,7 +1435,8 @@ static void show_special(struct audit_context *context, int *call_panic)
 				*call_panic = 1;
 			} else {
 				audit_log_format(ab, " obj=%s", ctx);
-				security_release_secctx(ctx, len);
+				lsmcontext_init(&lsmcxt, ctx, len, 0);
+				security_release_secctx(&lsmcxt);
 			}
 		}
 		if (context->ipc.has_perm) {
@@ -1594,6 +1598,7 @@ static void audit_log_name(struct audit_context *context, struct audit_names *n,
 		char *ctx = NULL;
 		u32 len;
 		struct lsmblob blob;
+		struct lsmcontext lsmcxt;
 
 		lsmblob_init(&blob, n->osid);
 		if (security_secid_to_secctx(&blob, &ctx, &len)) {
@@ -1602,7 +1607,8 @@ static void audit_log_name(struct audit_context *context, struct audit_names *n,
 				*call_panic = 2;
 		} else {
 			audit_log_format(ab, " obj=%s", ctx);
-			security_release_secctx(ctx, len);
+			lsmcontext_init(&lsmcxt, ctx, len, 0); /* scaffolding */
+			security_release_secctx(&lsmcxt);
 		}
 	}
 
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index 933a8f94f93a..70ca4510ea35 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -130,6 +130,7 @@ static void ip_cmsg_recv_checksum(struct msghdr *msg, struct sk_buff *skb,
 
 static void ip_cmsg_recv_security(struct msghdr *msg, struct sk_buff *skb)
 {
+	struct lsmcontext context;
 	struct lsmblob lb;
 	char *secdata;
 	u32 seclen, secid;
@@ -145,7 +146,8 @@ static void ip_cmsg_recv_security(struct msghdr *msg, struct sk_buff *skb)
 		return;
 
 	put_cmsg(msg, SOL_IP, SCM_SECURITY, seclen, secdata);
-	security_release_secctx(secdata, seclen);
+	lsmcontext_init(&context, secdata, seclen, 0); /* scaffolding */
+	security_release_secctx(&context);
 }
 
 static void ip_cmsg_recv_dstaddr(struct msghdr *msg, struct sk_buff *skb)
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index a28e275981d4..f053d7544355 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -348,6 +348,7 @@ static int ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
 	int len, ret;
 	char *secctx;
 	struct lsmblob blob;
+	struct lsmcontext context;
 
 	/* lsmblob_init() puts ct->secmark into all of the secids in blob.
 	 * security_secid_to_secctx() will know which security module
@@ -368,7 +369,8 @@ static int ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
 
 	ret = 0;
 nla_put_failure:
-	security_release_secctx(secctx, len);
+	lsmcontext_init(&context, secctx, len, 0); /* scaffolding */
+	security_release_secctx(&context);
 	return ret;
 }
 #else
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index bba3a66f5636..3b6ba86783f6 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -179,6 +179,7 @@ static void ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
 	u32 len;
 	char *secctx;
 	struct lsmblob blob;
+	struct lsmcontext context;
 
 	lsmblob_init(&blob, ct->secmark);
 	ret = security_secid_to_secctx(&blob, &secctx, &len);
@@ -187,7 +188,8 @@ static void ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
 
 	seq_printf(s, "secctx=%s ", secctx);
 
-	security_release_secctx(secctx, len);
+	lsmcontext_init(&context, secctx, len, 0); /* scaffolding */
+	security_release_secctx(&context);
 }
 #else
 static inline void ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 6269fe122345..f69d5e997da2 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -397,6 +397,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	enum ip_conntrack_info ctinfo = 0;
 	const struct nfnl_ct_hook *nfnl_ct;
 	bool csum_verify;
+	struct lsmcontext scaff; /* scaffolding */
 	char *secdata = NULL;
 	u32 seclen = 0;
 	ktime_t tstamp;
@@ -634,8 +635,10 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	}
 
 	nlh->nlmsg_len = skb->len;
-	if (seclen)
-		security_release_secctx(secdata, seclen);
+	if (seclen) {
+		lsmcontext_init(&scaff, secdata, seclen, 0);
+		security_release_secctx(&scaff);
+	}
 	return skb;
 
 nla_put_failure:
@@ -643,8 +646,10 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	kfree_skb(skb);
 	net_err_ratelimited("nf_queue: error creating packet message\n");
 nlmsg_failure:
-	if (seclen)
-		security_release_secctx(secdata, seclen);
+	if (seclen) {
+		lsmcontext_init(&scaff, secdata, seclen, 0);
+		security_release_secctx(&scaff);
+	}
 	return NULL;
 }
 
diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index c86df6ead742..a8e9ee202245 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -374,6 +374,7 @@ int netlbl_unlhsh_add(struct net *net,
 	struct net_device *dev;
 	struct netlbl_unlhsh_iface *iface;
 	struct audit_buffer *audit_buf = NULL;
+	struct lsmcontext context;
 	char *secctx = NULL;
 	u32 secctx_len;
 	struct lsmblob blob;
@@ -447,7 +448,9 @@ int netlbl_unlhsh_add(struct net *net,
 					     &secctx,
 					     &secctx_len) == 0) {
 			audit_log_format(audit_buf, " sec_obj=%s", secctx);
-			security_release_secctx(secctx, secctx_len);
+			/* scaffolding */
+			lsmcontext_init(&context, secctx, secctx_len, 0);
+			security_release_secctx(&context);
 		}
 		audit_log_format(audit_buf, " res=%u", ret_val == 0 ? 1 : 0);
 		audit_log_end(audit_buf);
@@ -478,6 +481,7 @@ static int netlbl_unlhsh_remove_addr4(struct net *net,
 	struct netlbl_unlhsh_addr4 *entry;
 	struct audit_buffer *audit_buf;
 	struct net_device *dev;
+	struct lsmcontext context;
 	char *secctx;
 	u32 secctx_len;
 	struct lsmblob blob;
@@ -508,7 +512,9 @@ static int netlbl_unlhsh_remove_addr4(struct net *net,
 		    security_secid_to_secctx(&blob,
 					     &secctx, &secctx_len) == 0) {
 			audit_log_format(audit_buf, " sec_obj=%s", secctx);
-			security_release_secctx(secctx, secctx_len);
+			/* scaffolding */
+			lsmcontext_init(&context, secctx, secctx_len, 0);
+			security_release_secctx(&context);
 		}
 		audit_log_format(audit_buf, " res=%u", entry != NULL ? 1 : 0);
 		audit_log_end(audit_buf);
@@ -545,6 +551,7 @@ static int netlbl_unlhsh_remove_addr6(struct net *net,
 	struct netlbl_unlhsh_addr6 *entry;
 	struct audit_buffer *audit_buf;
 	struct net_device *dev;
+	struct lsmcontext context;
 	char *secctx;
 	u32 secctx_len;
 	struct lsmblob blob;
@@ -574,7 +581,8 @@ static int netlbl_unlhsh_remove_addr6(struct net *net,
 		    security_secid_to_secctx(&blob,
 					     &secctx, &secctx_len) == 0) {
 			audit_log_format(audit_buf, " sec_obj=%s", secctx);
-			security_release_secctx(secctx, secctx_len);
+			lsmcontext_init(&context, secctx, secctx_len, 0);
+			security_release_secctx(&context);
 		}
 		audit_log_format(audit_buf, " res=%u", entry != NULL ? 1 : 0);
 		audit_log_end(audit_buf);
@@ -1093,6 +1101,7 @@ static int netlbl_unlabel_staticlist_gen(u32 cmd,
 	int ret_val = -ENOMEM;
 	struct netlbl_unlhsh_walk_arg *cb_arg = arg;
 	struct net_device *dev;
+	struct lsmcontext context;
 	void *data;
 	u32 secid;
 	char *secctx;
@@ -1163,7 +1172,9 @@ static int netlbl_unlabel_staticlist_gen(u32 cmd,
 			  NLBL_UNLABEL_A_SECCTX,
 			  secctx_len,
 			  secctx);
-	security_release_secctx(secctx, secctx_len);
+	/* scaffolding */
+	lsmcontext_init(&context, secctx, secctx_len, 0);
+	security_release_secctx(&context);
 	if (ret_val != 0)
 		goto list_cb_failure;
 
diff --git a/net/netlabel/netlabel_user.c b/net/netlabel/netlabel_user.c
index 893301ae0131..ef139d8ae7cd 100644
--- a/net/netlabel/netlabel_user.c
+++ b/net/netlabel/netlabel_user.c
@@ -84,6 +84,7 @@ struct audit_buffer *netlbl_audit_start_common(int type,
 					       struct netlbl_audit *audit_info)
 {
 	struct audit_buffer *audit_buf;
+	struct lsmcontext context;
 	char *secctx;
 	u32 secctx_len;
 	struct lsmblob blob;
@@ -103,7 +104,8 @@ struct audit_buffer *netlbl_audit_start_common(int type,
 	if (audit_info->secid != 0 &&
 	    security_secid_to_secctx(&blob, &secctx, &secctx_len) == 0) {
 		audit_log_format(audit_buf, " subj=%s", secctx);
-		security_release_secctx(secctx, secctx_len);
+		lsmcontext_init(&context, secctx, secctx_len, 0);/*scaffolding*/
+		security_release_secctx(&context);
 	}
 
 	return audit_buf;
diff --git a/security/security.c b/security/security.c
index 52d3d0601636..0cdd12c4c157 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2379,16 +2379,17 @@ int security_secctx_to_secid(const char *secdata, u32 seclen,
 }
 EXPORT_SYMBOL(security_secctx_to_secid);
 
-void security_release_secctx(char *secdata, u32 seclen)
+void security_release_secctx(struct lsmcontext *cp)
 {
 	struct security_hook_list *hp;
-	int ilsm = lsm_task_ilsm(current);
 
 	hlist_for_each_entry(hp, &security_hook_heads.release_secctx, list)
-		if (ilsm == LSMBLOB_INVALID || ilsm == hp->lsmid->slot) {
-			hp->hook.release_secctx(secdata, seclen);
-			return;
+		if (cp->slot == hp->lsmid->slot) {
+			hp->hook.release_secctx(cp->context, cp->len);
+			break;
 		}
+
+	memset(cp, 0, sizeof(*cp));
 }
 EXPORT_SYMBOL(security_release_secctx);
 
-- 
2.35.1

