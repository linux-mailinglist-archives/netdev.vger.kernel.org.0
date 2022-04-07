Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E45A4F8A41
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 00:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231615AbiDGVdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 17:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231487AbiDGVc6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 17:32:58 -0400
Received: from sonic311-30.consmr.mail.ne1.yahoo.com (sonic311-30.consmr.mail.ne1.yahoo.com [66.163.188.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BCA61A5920
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 14:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1649367054; bh=w40bsvxz1maTfxCP5OPrFydafSqo7FsPfYgUwwtQr5s=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=l9gyPK8FzolcWzaM+AAaSCluyFWhXXvjx90RIBJ9UPdhX+lbYLoL0Bk0VdcVO8Of2YQcgkpoEDoLd4WmfeTA9jQCQ5+5Sp/TE7AekdLKQFrRzLYY6FptIrEvq/ukbs64jczsNabRjWXi+3PK5zTukuK0jWW00ZFhxxMYVYl/T4IGlDzb1Nd1xZK3XRNpDqEfU7d0DvRUoCs+ciwblbpVt+h0b4R0tgxzGkKi6OVYZVesZswiZ2eXww4oCNOK0Ws4ovU+1MQj+SMZf9NlrpC9M3PkZbNsHsP8c0MNNhQBEq8Y6sIjRohXjKsnT+l39EDkminFYq7MFAe1X3A4Qb7hQg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1649367054; bh=BmAupHtE6MCpIZ0XgmX1SzcB+r3A9L5lJj6gjfvgs1/=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=AvBtWtKMOEhfg7gg/z1vh/wd9anBrqcyN1EyQdLEoiXRGc0HkDXlvBjpKtBeVU8NLpWrs0ulh8SgMkwOIxnd48u4dQA1fqTfjOaF3pZtYttHqHMsqGz3hDBrzV/2bD41KrgsOx5+ejbDnMLHdU4QJvVQM6UTpCDrZOl6aLXHexKvDhDYdme/7MEjclq7ru4lXr9a73JMm75HJdgtqXV72o6kVveyS65VVyapfcwYz4oGPu8av1T09MLg5LMVqXVEtZVFhfzSFluajdPFmIpk6EOJDUQDAfKdmBW6eBmpWV495KysSZSpYZCMe2Pu8AOBZj73Fk+S07kZeYx78UxPKA==
X-YMail-OSG: G7Hhjl0VM1n90CjZkEr5mkNBS.sGNjKvudF0jyNJCUWJjPVSy7fGrpqxiXr6ahN
 6VYiHI2yjjDPZrZ5wOQlUtfxOsBX6q6rYGlHHkfG7M9lBnni_KJGBWZ1zNoqilx9INLt6ez_pIGh
 bH7Ng2quZCPXMS9.lxxCBIAxIQsEgb8WZTmOI14f8boca5qe1sO5khoGK7p5unYNvC.DU_HCWKQs
 FyV3KjJxYEMINjSrVhyjlhXNRnG5avCTbNYKJZgXuQszrD4BcesLxn80yS8eEBbR3sxq1tPe5D.v
 pIWKXmEo9fOc_NJAokyEaM6OpktktMZAE9C06Qpnz8ikWvLkH245tql7Ssje54m7c3uFqaQS69td
 HI.k.39EcFSBi1tyxci2kGI_utFkeNQ36XpSpPFlHs_xsZhh113x_VkWpm8R1Y_F.DWQ6feGPFjy
 2bSdPLezwGi5kpvQ6vY.EMERKt56dFZK4xzngo3RanTjokf6bJGI9SsVHSOSzah4MfdRPVqyg9a3
 9732bqJa0nxAUr.dUUfiiFj6ieIdYpEpV3HHre_iXr_6_V3.tw9f7FIFFSwXCxBZpT3MMTG7qWeA
 _6MXmAacVs1Tr3SBi5.2gYirsH8hZMK1zuS2bwgsZcwLNmZrRdSgCRN_gMLwEwc0CxeRPqbMLnIU
 I.vgO6NalJvdCOuc88eSG24HJDVK0VG6TulpSTGzWlcou0qb8vbIfpo3WbO1Lco1jzx6NsrBU6nF
 BxFdj1aBsgg1wR6VoBNA59eZ.2vLtAgnTBkdMTt7M4Wqlm0ezvsGd33YX5AYpN8wcSLRU_726frK
 Rdzx6xLTuUmfDOqrgJfMRZDO9qjZM6S8qMfjfnFOP6IZ26FI6wNd_nSC2ZeeTsbGvfkJXpWJT9.6
 fkD1bGZxnTOHe65xTMBcdXwLaVn8SMOz05bQahbQEa4JbzlwhYXzcur3lv9JXYiAvYSoLQsWIUVW
 yVbUTHDVoToLCE86wGi2JX0c7_vjrkQTZpaipzgg9blGM7AAAK_JVJ30fw8Znh2a2nn0N_HnF.bt
 MnxhdHhk.XXZFxRyXUGLb3sn95Yc18jr5KM777SpxZzkMhMomgOKUuDqgFOVGN1F6zC17WwpNaOv
 TKJxAQInhqJXOZ6d6ZuAkX95QZko_Mlh4.kctakg41Z8fIDgFhyYAN8sdgfwVLmw3tGVOc_OHq_1
 XuxTw8OEij3S9DH_LQw4XjKAjtSuw7u3QglPpbvT8jGMmD7W1Q6E_qPYbAcbRzsE63uRPFccLfA1
 e82iYwyRFYT5m3dCPoUjavHhWV6GnY_dPGzQuwDGtLALcIJaL8nJD70psY6W5O_eXLrojS4QQuw_
 2Big4WKUNw6hReLeFP025t9AL7ch_P66XtVML9E2aNdkloAvo1nO0D8AYmd5dSfM0_msD2VOy9bx
 YQuNU3tFv5zVVLNh_jj03p6wzx2Ak9w97uHi2ArIO4cF2xHLIuUHsDHgtdTu.GKDUGz4nk7uBOsU
 Jw2j4wZhI2XrNlGw003t_wJ1xrQnJ1VYK4XyS_5J7Etusgfg0E9LwI_RWegkBTt3kCcHPIIaY0bJ
 vFZQ9hhCm866CrGh7LPfY4pbT8DFhc9Qzp5Yf0nvbx91uaBGtlqCU7Mordnr1S9sEUWZ7OJxobcP
 7Ct590b2ywioFmtt7BXafJBXb1acWLJ04twwo2uWQrNRq4jmVIxSKdTmGrBbAq59n15g9NVPGwFJ
 YCpeeFNbsq_r.yAh6y5n88SX7gwpGdyNzMR2kbr_lvZ9QifXyzLtl_moPRKVY85PuPFHtLut2F4F
 XZQS2Y7AxqYi8LonBvG.yWQop899mewzIz5eYGttfqqXD8VCW7.R5cZsSI.fDr.TgeIrk4nhVxzB
 7d_vt7erHRGze9c1g.yBTpXxnbVPpU9sZdmWXXA.m1iA_d7Rimi8aFwRDzzFAd.C3B2TUGytrgkZ
 YRGVCBlD81qvXiNtxpUmR4BLgYprbA4KOhGh6OnzBbIiuvbnWi9vvWzjjRhXq.LCqix2Ky.4IZEk
 0CWqgQGoIXEX0U3K7rxQ0H4xf0bQCAgF8XMtmv8vKP.wpDq9rE5QsTe6AQbyUeehhL7L1ARquCq2
 n3h4z63iAqNZhdoN1uzPqwgFOpN3fFghviZ3o0.u9d94zXs45_t1K30vHin4guJMLBPN8pT2flQ7
 jA_AbNBZB6o7Zq5e98tC.Zk9YA.wd_zghrXRXngk4hm9RYgpeaiyTgnRPrm5c2F74Jvsb0.Sugjn
 x2uP6pdbNQl4Vq4v5_Y3y2YIX.P2Eb3zkMroIZJqdnOdsh3TjjHW51eO8HnxuVOI7NnR9nX8mK8U
 HXo2aDCzaYYyO_lpmwfcSlj0eLAeKTlc5YPp6W4vMzNSTNYMkGdFVnN84
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic311.consmr.mail.ne1.yahoo.com with HTTP; Thu, 7 Apr 2022 21:30:54 +0000
Received: by kubenode532.mail-prod1.omega.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID c3ff6cebaa6b68d3aee0bdab632d6ae4;
          Thu, 07 Apr 2022 21:30:51 +0000 (UTC)
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
Date:   Thu,  7 Apr 2022 14:22:16 -0700
Message-Id: <20220407212230.12893-16-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220407212230.12893-1-casey@schaufler-ca.com>
References: <20220407212230.12893-1-casey@schaufler-ca.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
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

