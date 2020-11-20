Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB4512BB6D6
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 21:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730651AbgKTU3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 15:29:49 -0500
Received: from sonic317-38.consmr.mail.ne1.yahoo.com ([66.163.184.49]:41135
        "EHLO sonic317-38.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730955AbgKTU3t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 15:29:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1605904187; bh=H7Ri/VHtHrASIh5rh+CWAH+f7yizZE1UTVXdJjukPwQ=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject; b=XQCNbbDLwcc+M2e7NWSO+Z0i/f/Dnzs1VXDAT4xrDDsPHCFFleDGmGCwsTOFldht2v2PsVutAYGIoXKzTDRWelR8/rRBw86a6tAnqvLILuo4S9DnF2a/skQx/a0jDV+6y8CBHBc85DSQIijY9PcEmvxr8tufq8FrGvf3KvAzutOnqJhavd3nQdVnHuMjfC5xjgCLVhMkXlk4j0WBpJYW1g52GBKjzi4t18AovbAqGWtGuZ/4Ety4yjlQ61sy29X0jxFWwVVcVf+SnJOZ9oBGfVXzRk2vnJNIeRqAiKbo9VYB5bdwF9pnW7YBvFBGAhZA8hTu3UU7fNFqUhWiY/HXqw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1605904187; bh=z8hyZDD1baUbJI5PJE+uj1fcLiaZZLovwrM5tueFnFr=; h=From:To:Subject:Date:From:Subject; b=Yef/QAHJcAixNkvdK+O8Gh/Enhyus6x59NvG2yBSlqUsDWm+2rIEeRlE3LCVDYaoWHmPx4zSYYIxtwtNz5giHu/602IQgaovxWbsyW9sjHCSbzLABjKCo3KX/sOSiGJAlsUwslvk98G/OOYngHpGHk/CdinW7PMWwVPmIx38Ac+l2BUnDrlt4PHY4hh4yH5s9X3GVO7NFSLH19vIV7uLey0OpFPzdvGhnAx5KezT6m074nS+ZM7LjPL790IFAiA24IGya0KVpF/60RJm6QFYQKgUUfdrzTcHux+fHoHQL9zsuwzh8zmV8E7zCTl3XM96jCOHsohyG0eahIFXL2gz1g==
X-YMail-OSG: m7d5C.wVM1lVkOMtOCJJ5ZCDH9QzQBWGEvifAZZso_wufrwRtUosAFMBmykBbyG
 8lcMdBsMGenjr53.94Ey2_W66XZ6X7h.GkexKb5GP8k37Kn0gPlcagiYvIuEtRWq_MmugPMqQxLB
 HP.uu7ppUZxtUyy4.IR38ZbBL7XWlU6LC9fsf1T2AkgBfsSfbi4D9T9wrNPG2iQFFqpmD7XlkQc4
 aQzTXNaSToD5Flf0G8ElkArx7inEoDbUqUkEQpAx4BGC6v._RkV5g00yHACisLodUuoJCLfmVxgg
 wXuzuO6nUj6VhugzFG6XlHUSXJKsB5VY3rNvwWyQLsAnKDqj69eAxyD6fdSdU6kkj4dxrZRBLvlK
 lwEBQAR4yHOCYJ3mGpiOhAxonNBeILmAQMVk6TJslH5Y0Mv475ScbaF7zoH2Fq2PjmEojTrGQq_Q
 RXkvK4zWriBoD4FMCXBmIt5SLRVyKHV9AyAiYpgad7DLN9Arap.0zjI6Leyl2w1BlnlY8W54kUcN
 m1FKxcI4BDmRpQUyN1oY9M3Y46Od8Dv9THZmO9VRlrtIjzgf8JWDLKsenxSmkcqtLYmWBrhzsRCw
 yjoaXszQD4RXPHmE.wqvxalSk2nmmyy6PwN9LqeaJFAbOv37mHwzaEQp9qM9gpAUJeXQjk3smqBu
 Gsv47PMx9MOuUcVxDE9pJXUtTEiNaoAi9QDJTmd8GRYmiJJOUOi3.maBQS5X_MsJM2oKZnTrkBL_
 KudgM_3U8Q_9rN.Bpgf1q466gctKqC7REKEl.VO9jEDOthZTA0ucyjP2f2XzMbCocio3ESg.tR_i
 M3ladDGCLf8d39XMIFmLWFVP6jPXg3fazrYFdNnibKfe8nXzfQJCClpk8qndVdnCsRtYVPzxTJHV
 YmimtEZ8eNPQ8zJWIBQgas5xrQ7dzIokvTwK0KyEbR0lwc_Ht4n66PSuzIPon4ShG3ZSgKyyQiPF
 t38jPsQUb0kg1uuXiwifBazF5JGxn2GhJ4WsIfVPkeo59.LmgxYL6dq5L90lve87gfH_YhPAykMX
 vQoqhQppaHsKp_ROjkyPIVxaOQ6tbzsANK3Ac7EyC89WLfdLWiGtXcgqfvJPfni5KSrG2k1TUMIP
 2E9wos71q6ztSM5AzGmcglbC1EfbSosmBPP_1K6G9tDuh8Hq5KKcmXwGiT4sHpI_HPWhX42hYYOY
 .lS749sdmqgvDkfsscN6TnRdf_F2s3715HCsItPTFrUXIpdD6EQOQdeSQ.O42X47yFT4lrmZDrsg
 jFh2_XMzJ5Gj2hlbtFnlZJgjRq34OQADwWJmvw8rBm3iuMAPtJepST0sIDi5L3nSjXT3AaR4Oh5p
 r1fwbKNT2okoJun84JLfIOp9NQotLxkLhmY.8y9Wh2JjF1JyXWphD49CAmiMDmjy6yjPToVcFO5X
 BDxBYi9Y0uMCtiqsnOZu6npwaLRl4td8PCgcWwT4RFMmQdWf4ElF1ThDXthnzPPGVTrWPer6t0u_
 zu0VL21B.Yb0KpgLwF_OgD68je_qUFMKq18UXQIQof1ASXz8ajbon_AYBVXWHw9DX7DHy.dHKV6B
 _qmjA.cMEaktgIUvIqsvZKU6QSfudr8tNWmMDeqtNOvt9vfpHT39d_2_JTyiqt11QGwQ7x.gEoFu
 7CHvEk4raQ5J1Y3opGariz2T3ZknZ6RxGa1VTG3SCGIl9b26OkF9zuIXC67UnNCKJq1Ze9wVorj2
 4730eOflvhB3AtKqwhqpZSs27ta6gd3OAg63fxBl5XVPgk_8NN.CQnHdhTZg2cjHJCW712c95kOa
 UVzM1UeaJTdZYwTMYnsQ7gJ60awF3joU1UEnYmt2fz9gPQBwF7IaEn_43A51NJw3BGFqszypfn.5
 gf2oZTGC4YwmHthf4q_WImVVfnNMyN8A2OHhVFV5JyepbReRsmb2JEZjTOhL9KcXAFBsI3KcJHG2
 v3G_6NpFV8Hrn8P7Zrdke8PESKKq.yONi5AYS7HWagRT8AIwcpImXocmHFiokCRJOzudz5ySpxel
 X4S8_fPxOShuvxKmWH6hmcGfnlbPILQ.afigzoSP0gL_XQp6coNTOIKs6auQmmTFIWqLHWfSYSx.
 xDV9iY92ws8B0vkyRWTZKgRSzXgoHs_udV2TebmSwzF.M_DHHM4K7ITRU2CaOHUSfHsAxGcq_vbv
 cohPGurDhJDE4gHTw.y3buTxKPCRA4Xg3ra_PEGvxUh1JCk5hmWSvj559dSZXNVPOhmssleuWjyF
 qv.OlQBH6dqbygqFKwWKXOrEhlMmUS9__U3917YSsB5YMKELpV07u1hKOcjY3fiFlQj8nE4nHy_k
 3PbHjELiYnq3giuyNbbkCBdwbMcQSD3raVtqsH0WGaKcLPaNb7ick.bFJvSMPoNHc8_H_PpknhE4
 ySb7IKVNBV1Yo0abXiJNbgGwW8U1EVLJigbYne.A0R6zXJHwvhOndqXp.4nU.Iew38DoQRLKKCw_
 BE0mg5BWKIHOhoUgjk23VrMlPu4BYuAVE4xgg9dYpc4Gqkry2IhFqnHkAajcDPVOu1GSO1nsVX9t
 MzQ6qq.1jM2UeJsqQEUiFYMSM.J8nrxPnIG40PBHjHekAERqS0XXl9vATnkB1hkWRXex7iw2xnzY
 hWhB.SpAcxEGpLd9skwQ7J61uV8Iokyu6CgSi35QPtj8YEK3NxcRAWb75TvN4kCEBPt2r.uK0a3f
 R6Mx0qUyL3BAsCah2X42d.s0ypABt0PXT2fyTA88qJH5bXS.C8Ke_EaasVLUqXl8FWjSSWwCSxZb
 4RtPBWQDSizs7XfBF4SRI9N4fo6LAcfTNdIF9uxmf2s.0VBw_tST5yWa1fcb1hrF75qxmmCt7QHe
 ciCcu5xiEFKYRyBMJr1dLC_KFbGR9cZGR8xy4ODNOSu2BGO1GIz3iuLa8bzUY5A2X4MJMVof1lQd
 LQnq_AJSzZCYKR2az6ogTcV1jTvPBUBhfsgnuwjImuS5OH9oylzPeEtozQXWiefy_l5qWf97OW92
 RcgDJ7KMgQEwwesR6.qEsYOUOeph28n6pffIsE3Me.k.zqOZI9WXvhUFiGAu37gPzZ53pvtjG.p3
 lplk9sVh8IMPa1T3.kVbUpXdnkexuJsDoprdUWNpqxjLIuQY4egwDNSYwt_8ulKMLGIao7pJx2_Z
 lJ5PcAc6YNA7Bhzw_5cNRMAlWkCmIFx0AoyyNJMKi_w36iNYPkSWT085nZECMOij44.ryR.OiBm2
 jgmZFCv64NKyQbVf3aHIqCnFmh_6zX0.POObOlU4PCe3csmhZr8eyghx2z9Z4I7S9SkZX4PqUi8N
 ijR37hKPSOThEFPz7ULp4MS77Fz1xIWieP0ARZzbtMwH0QnNQKlyfk95khV9foEQMaAXSzQ--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic317.consmr.mail.ne1.yahoo.com with HTTP; Fri, 20 Nov 2020 20:29:47 +0000
Received: by smtp401.mail.bf1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 62e1877e1887933df0f6b34e459fde17;
          Fri, 20 Nov 2020 20:29:42 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        linux-integrity@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: [PATCH v23 13/23] LSM: Ensure the correct LSM context releaser
Date:   Fri, 20 Nov 2020 12:14:57 -0800
Message-Id: <20201120201507.11993-14-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201120201507.11993-1-casey@schaufler-ca.com>
References: <20201120201507.11993-1-casey@schaufler-ca.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
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
index 08737a07f997..05266b064c38 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2838,6 +2838,7 @@ static void binder_transaction(struct binder_proc *proc,
 	int t_debug_id = atomic_inc_return(&binder_last_id);
 	char *secctx = NULL;
 	u32 secctx_sz = 0;
+	struct lsmcontext scaff; /* scaffolding */
 
 	e = binder_transaction_log_add(&binder_transaction_log);
 	e->debug_id = t_debug_id;
@@ -3140,7 +3141,8 @@ static void binder_transaction(struct binder_proc *proc,
 			t->security_ctx = 0;
 			WARN_ON(1);
 		}
-		security_release_secctx(secctx, secctx_sz);
+		lsmcontext_init(&scaff, secctx, secctx_sz, 0);
+		security_release_secctx(&scaff);
 		secctx = NULL;
 	}
 	t->buffer->debug_id = t->debug_id;
@@ -3473,8 +3475,10 @@ static void binder_transaction(struct binder_proc *proc,
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
index 197cb1234341..5dfd08357dc3 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -1273,12 +1273,16 @@ int ceph_security_init_secctx(struct dentry *dentry, umode_t mode,
 
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
index 9e0ca9b2b210..4b03a3e596e9 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -139,8 +139,12 @@ nfs4_label_init_security(struct inode *dir, struct dentry *dentry,
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
index 833a2c64dfe8..4ae7e156ea87 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2717,6 +2717,7 @@ nfsd4_encode_fattr(struct xdr_stream *xdr, struct svc_fh *fhp,
 	int err;
 	struct nfs4_acl *acl = NULL;
 #ifdef CONFIG_NFSD_V4_SECURITY_LABEL
+	struct lsmcontext scaff; /* scaffolding */
 	void *context = NULL;
 	int contextlen;
 #endif
@@ -3228,8 +3229,10 @@ nfsd4_encode_fattr(struct xdr_stream *xdr, struct svc_fh *fhp,
 
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
index dacd64d2d141..4ed7a0790cc5 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -132,6 +132,37 @@ enum lockdown_reason {
 
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
@@ -531,7 +562,7 @@ int security_ismaclabel(const char *name);
 int security_secid_to_secctx(struct lsmblob *blob, char **secdata, u32 *seclen);
 int security_secctx_to_secid(const char *secdata, u32 seclen,
 			     struct lsmblob *blob);
-void security_release_secctx(char *secdata, u32 seclen);
+void security_release_secctx(struct lsmcontext *cp);
 void security_inode_invalidate_secctx(struct inode *inode);
 int security_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen);
 int security_inode_setsecctx(struct dentry *dentry, void *ctx, u32 ctxlen);
@@ -1366,7 +1397,7 @@ static inline int security_secctx_to_secid(const char *secdata,
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
index 1f987ac23e90..8867df3de920 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1192,6 +1192,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 	struct audit_sig_info   *sig_data;
 	char			*ctx = NULL;
 	u32			len;
+	struct lsmcontext	scaff; /* scaffolding */
 
 	err = audit_netlink_ok(skb, msg_type);
 	if (err)
@@ -1449,15 +1450,18 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		}
 		sig_data = kmalloc(sizeof(*sig_data) + len, GFP_KERNEL);
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
 				 sig_data, sizeof(*sig_data) + len);
@@ -2129,6 +2133,7 @@ int audit_log_task_context(struct audit_buffer *ab)
 	unsigned len;
 	int error;
 	struct lsmblob blob;
+	struct lsmcontext scaff; /* scaffolding */
 
 	security_task_getsecid(current, &blob);
 	if (!lsmblob_is_set(&blob))
@@ -2142,7 +2147,8 @@ int audit_log_task_context(struct audit_buffer *ab)
 	}
 
 	audit_log_format(ab, " subj=%s", ctx);
-	security_release_secctx(ctx, len);
+	lsmcontext_init(&scaff, ctx, len, 0);
+	security_release_secctx(&scaff);
 	return 0;
 
 error_path:
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index b15222181700..2b06171bedeb 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -998,6 +998,7 @@ static int audit_log_pid_context(struct audit_context *context, pid_t pid,
 				 struct lsmblob *blob, char *comm)
 {
 	struct audit_buffer *ab;
+	struct lsmcontext lsmcxt;
 	char *ctx = NULL;
 	u32 len;
 	int rc = 0;
@@ -1015,7 +1016,8 @@ static int audit_log_pid_context(struct audit_context *context, pid_t pid,
 			rc = 1;
 		} else {
 			audit_log_format(ab, " obj=%s", ctx);
-			security_release_secctx(ctx, len);
+			lsmcontext_init(&lsmcxt, ctx, len, 0); /*scaffolding*/
+			security_release_secctx(&lsmcxt);
 		}
 	}
 	audit_log_format(ab, " ocomm=");
@@ -1228,6 +1230,7 @@ static void audit_log_fcaps(struct audit_buffer *ab, struct audit_names *name)
 
 static void show_special(struct audit_context *context, int *call_panic)
 {
+	struct lsmcontext lsmcxt;
 	struct audit_buffer *ab;
 	int i;
 
@@ -1261,7 +1264,8 @@ static void show_special(struct audit_context *context, int *call_panic)
 				*call_panic = 1;
 			} else {
 				audit_log_format(ab, " obj=%s", ctx);
-				security_release_secctx(ctx, len);
+				lsmcontext_init(&lsmcxt, ctx, len, 0);
+				security_release_secctx(&lsmcxt);
 			}
 		}
 		if (context->ipc.has_perm) {
@@ -1407,6 +1411,7 @@ static void audit_log_name(struct audit_context *context, struct audit_names *n,
 		char *ctx = NULL;
 		u32 len;
 		struct lsmblob blob;
+		struct lsmcontext lsmcxt;
 
 		lsmblob_init(&blob, n->osid);
 		if (security_secid_to_secctx(&blob, &ctx, &len)) {
@@ -1415,7 +1420,8 @@ static void audit_log_name(struct audit_context *context, struct audit_names *n,
 				*call_panic = 2;
 		} else {
 			audit_log_format(ab, " obj=%s", ctx);
-			security_release_secctx(ctx, len);
+			lsmcontext_init(&lsmcxt, ctx, len, 0); /* scaffolding */
+			security_release_secctx(&lsmcxt);
 		}
 	}
 
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index 2f089733ada7..a7e4c1b34b6c 100644
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
index 8627ec7e13fb..5d2784461798 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -334,6 +334,7 @@ static int ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
 	int len, ret;
 	char *secctx;
 	struct lsmblob blob;
+	struct lsmcontext context;
 
 	/* lsmblob_init() puts ct->secmark into all of the secids in blob.
 	 * security_secid_to_secctx() will know which security module
@@ -354,7 +355,8 @@ static int ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
 
 	ret = 0;
 nla_put_failure:
-	security_release_secctx(secctx, len);
+	lsmcontext_init(&context, secctx, len, 0); /* scaffolding */
+	security_release_secctx(&context);
 	return ret;
 }
 #else
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 54da1a3e8cb1..e2bdc851a477 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -176,6 +176,7 @@ static void ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
 	u32 len;
 	char *secctx;
 	struct lsmblob blob;
+	struct lsmcontext context;
 
 	lsmblob_init(&blob, ct->secmark);
 	ret = security_secid_to_secctx(&blob, &secctx, &len);
@@ -184,7 +185,8 @@ static void ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
 
 	seq_printf(s, "secctx=%s ", secctx);
 
-	security_release_secctx(secctx, len);
+	lsmcontext_init(&context, secctx, len, 0); /* scaffolding */
+	security_release_secctx(&context);
 }
 #else
 static inline void ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index a6dbef71fc32..dcc31cb7f287 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -398,6 +398,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	enum ip_conntrack_info ctinfo;
 	struct nfnl_ct_hook *nfnl_ct;
 	bool csum_verify;
+	struct lsmcontext scaff; /* scaffolding */
 	char *secdata = NULL;
 	u32 seclen = 0;
 
@@ -628,8 +629,10 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
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
@@ -637,8 +640,10 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
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
index cabec85136e1..5b83967e3f27 100644
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
@@ -509,7 +513,9 @@ static int netlbl_unlhsh_remove_addr4(struct net *net,
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
@@ -546,6 +552,7 @@ static int netlbl_unlhsh_remove_addr6(struct net *net,
 	struct netlbl_unlhsh_addr6 *entry;
 	struct audit_buffer *audit_buf;
 	struct net_device *dev;
+	struct lsmcontext context;
 	char *secctx;
 	u32 secctx_len;
 	struct lsmblob blob;
@@ -576,7 +583,8 @@ static int netlbl_unlhsh_remove_addr6(struct net *net,
 		    security_secid_to_secctx(&blob,
 					     &secctx, &secctx_len) == 0) {
 			audit_log_format(audit_buf, " sec_obj=%s", secctx);
-			security_release_secctx(secctx, secctx_len);
+			lsmcontext_init(&context, secctx, secctx_len, 0);
+			security_release_secctx(&context);
 		}
 		audit_log_format(audit_buf, " res=%u", entry != NULL ? 1 : 0);
 		audit_log_end(audit_buf);
@@ -1095,6 +1103,7 @@ static int netlbl_unlabel_staticlist_gen(u32 cmd,
 	int ret_val = -ENOMEM;
 	struct netlbl_unlhsh_walk_arg *cb_arg = arg;
 	struct net_device *dev;
+	struct lsmcontext context;
 	void *data;
 	u32 secid;
 	char *secctx;
@@ -1165,7 +1174,9 @@ static int netlbl_unlabel_staticlist_gen(u32 cmd,
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
index 543d9b707fe5..352c9eb98425 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2245,16 +2245,17 @@ int security_secctx_to_secid(const char *secdata, u32 seclen,
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
2.24.1

