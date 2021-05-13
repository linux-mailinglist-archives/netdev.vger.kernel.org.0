Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0B037FEFB
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 22:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232850AbhEMU0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 16:26:07 -0400
Received: from sonic309-27.consmr.mail.ne1.yahoo.com ([66.163.184.153]:43668
        "EHLO sonic309-27.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232835AbhEMU0F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 16:26:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1620937495; bh=HEKDnSOsr5dIFPnVk7iUYZ7liKQS915UhYcg8nARtyw=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=BbalSgCDfzWDuDi+XRvAZUpAfv3sLjyOzEjJJErhw3ukiiAu0RactSC2FmsTUYp+TPz8xcE+tRxJwwyxdlJej1K4OaoygmSRBkApsJsufSCgI/yJWv/JhJ/22gxkULgPa/l78tjw5LcGccJATBeobXEEaHVE2tesaLFYCmRwDQv4pL74C1xOe3Z7+zFAMNrpJZ9Ti+B+XFD1abM0vPYmLbSGUPCW9ML/2PFy8K4ptNpPfbR0U5LNR6GgrAo5uoe7m0xHA223Va1Y1vbY9s47+dFqVGuxJ6lH5Svx333y4olc4hemBkmH3kpQnOZlyQAkCHjisdIjBrTnFqvW9FxCrw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1620937495; bh=eiHrSYKSvQAlxtj3mb09JmCS2y6EawkaHusS8IiyEfa=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=SOGiOCMpM2fb5y7kPkFkY3n7XWLLHZF1uRmktDhFGhIn4TxeD78uooRF1ZwijJBfvasXmUbzlPP/mAQ3/R49KR9fgpWl6I/YBA3AmongFAxLe67KcKXPM9hRgmgfp/pBrNX3axxHSvSUpUsfSzr3AtfkyIHBMQgyi0ExPueVmV6uRLSRJCzEKJkzJxvPy+mHQ8cMog0oTPmV5VvwZL5BnD/2Byce1zF87DzSv4kMc/WvcB1vljMskzaUCRhK7SXYZhFvtSdXASLZo/UB0Mj4NnHUw99g3mHt7iAh9rOJkqeGtDVkzZWmaVAqWiGsjjuuHuVFEJG5gEr+CZ1bvPh+NA==
X-YMail-OSG: L4ONLuQVM1m0RYOa9Ivx6NQT29rx48s4hQWIAEFkL99wnhI9ZrZv9jkwSPzJC28
 s_Ey1OxBFVtg8POVVFHwBjOkHwSBbTzp4gvPCWOUjwHm9DO5FcvRMw6gzmTt7nH8Bu8.GkMJNbV0
 aRg3XeeIez6HjryjQk0oF9OpgMAjihQCC1_MqvmiQaoCYpHeg5ICO0dYXGvn41KhwIE4UqjZIwWw
 TSDy9ugmXt1epRhGBMP6L77U1RgMP7_3QfHUOmEg6sEgomIqs0Q.nI64R.OX9Pm2fRHU8np0XVC7
 jGjJEo4CbjWECl14TCwBozmc28R3eZtaNU4G9BdVV3W6lXakX2wXeceCCVcXVnYf2J9W4tbdGCT9
 oRD4tl3MOb2EfahORhQ1WDmMVTkA4EUt9ZCCc1xBn4MAy2cUscFL13dtCGteQNWayHEpLYN3se_U
 zPaCiDG198lLMddQ5WUDTaU2qjVDqHGNLFwqFmlC6H93r7ESZnpyAMJzJp.3Eedkn.dLv9tLzK9M
 Dbr.LlcWdQ0BYoP2ZKjCspWhuncXeehkbft83V88ZN4TYnBauG8o2XyKiMElYyySErvrEzBtQdsI
 gfrz5f_WEFRjZ8OLXouej8cufteaKh5fmG_gEQVyKlWpe.DqldiDOOAd1nbJbACwyiCeoOGCLaar
 eLlzTzf8mSUwd7TQ653oJA90ZALvF69le3pAa.E3k7bVlS.FYgme2ZGoanszDRIa1h9znu5qqW6C
 2xXeuRgVXSH4BFxITWvgvLk4cw2xAMYHNzWWAJspxHPdctrvwHnBh0M4o3rM3z6nF4bSRZsaiCZQ
 sE.bvcyGXN3BQDdO2C4v9LOLmq7lwQ4WFxs4GN1pbI_mQvgidjw1ve9_slM_Gl54L2LcsqlENoy_
 bbmh_rlrAkwocr0IjJWzioy4WBCLfSFI3Jfev427EUVHYjihuGwe6oX.XTBDTYv7pgdrd_4yG8zI
 WqYP29vQhjjXn51EN7FeNzPv.qd_dV3m9o.7ZhA4ygUCJ9t4_Yy8nNIHuIp7Utu0Nu2GhxnsXh1K
 OuTouabohdVFqs2hcOp.GzN.Z31GJfL82mMR_jr5n6RLp7j55T.0WdarMgv7EPUy.u.O7tHaPI9R
 AFd7o4XXxQA2.iMN59YRhK3Bpvaa_ZOVT1UOeMOnjEBHPU_.RtzEAPpB7eZa1lbNI2onAcFR0QzO
 OZp3xmEUWV0rzemNJScfp85UkZhMFq3.hlGuIgWZTpLADwGY4UteNCmJFnsUEaWYErCgRVFAul.9
 TAhZfIsNl.l.TgX30zVP7BjTAikQ535bGRQahyyjMZ2bRhFbch85KLFJEPRsnlOf.WPn1bLrXtnH
 FIGi2z8UUfPqhY8bOJLx6w5soG17S_XeZ2ETkDbouV6XY0evfYIpKGbHyx06nCnA8ycU5yYVtj8B
 WdyTReJIMh9w9qdJR5qO4fR.spO1mWk12NciwQsgXL_EaJDxcyjTSzq08w_Lu_3OymFeVKMujKGY
 M6ud6gA5cSK0fCnQXrX_foI5Sm2WSixnH0eL5G61wFZb1CFOilbTy94MTyJf3f0.MJLVIQ0u1RDD
 SzlJpnp1qsOqTBZUhmWkybTCKy9CKl0rq3ISr5SLw9PDWusx7UPv5xPpVtSSilRqom8wYsFFg0BV
 J35upPK7PXYDmq2Z488kpuzIk6a8E6XMDFvHn8Inb6ummvj5w5RAunOiwEQBPfphhTBrxVopCsWc
 o6oDkgBqYvnr1XLh79ub5yv6IESoFd8Prdvd0RUJIzScJ0KDP1h_QNqjf4y67s50hY1v2hsrfj3q
 8omY5XvoYxQffV0QPrwoT.Wu6v2qxUo_msak777AI9xVMLZtkN1MBGpJRRvDOW.Y8YvQRPqFcoGk
 WQeKMgZzyD8HpUD6DC4U5RE.qbGCs3rudKDUDfz46UNf1i_q6eW_fM0Qe_iqXi74hKiIxHL9dax9
 ySUQis8gvd8XaaiPxZSNjQMOUydcg5td2m3GUp9I94o_JleldVIOhv1QQDGvPnI1ck35y91Y2Bf7
 vBEeEU5N9YXBDRS.a9Ioi426tY4kRMMdhLqlaGdypcH2BQyyLkxzRO2GEtpRiN.pSXdeYJklQVk9
 uHk2BBcHja_WaoIG0lV7eaaRDtNqLTEMvFxUyGt.1BVWXjdOudNQjllwwHhd6kZ5UaVuicer7cyy
 JcrK_55cWprb7ofgNz1s2GFmVVPK_guMuz4dbsBDHGs5ABcmBriwRTRLfbya3q7SwvCCkKCgGdN8
 lsjicmux_sLNIOBnYdea36aL6VDR2_Cb04PpVjMZMNYfBGzkfUVHvyyP_xyfQAsDRejwb_RllauX
 IOLrwCwB_7JZFBVUTJpB9cmYnqyVdFEl5hmwW3vznkDcPDKiEIlCp8Agg0YCv.rU1OFPvjaOf4dW
 e4rtVKUMa3eLp8CrItbMAgkDlYgRwPSDKcU4Ln6BUGJXgnmBdO6Dac2.DmAei.ACkxwP_NbbsYrp
 UMGO50Qs5QQqUEA6zjtYayRMen2UExy_gTEYYB3wVn.T.IZEoZB3iVH_JJkQ.HBdyGCEWMyWBd2W
 XCNfs2S3LxQz74zO0I7JHW9fLihKPa.KnJ_Ac703vglLCmE623cAE1y4xVASKQLWNei3nBVFi24d
 E2dXzEMW_r69xdad6F7nH7WgvYqGgLwE45lqa3vNwG6K3xE0qhTcq3aGj37tAIx7oc6e6S8SfLbz
 OoHhnLRwAPoSClFIZCcypGCzpD0fhN32wCnRiOjo3_SaPbzcTi6eXrX0UyVAQvEZcWMQght6YzBU
 EO_3tmVNMOSqOA1g56FLs_MEw7iyzePTTCmaMRRWNxcDZVDeL6hfDgnx2T7XophrfW7CWr2wDVgw
 H9Y9uZZbGJZ.II0.ccRg7mniiJqTwBXLfSUApHt0KPu3rrtfRzM.XKYXpZZzDqi8gJhk8R_rZaQq
 NzGE4IP.MKb1dbfaYjTh4WNz63hvoFeezJRfcvvtoPfk_UFBvdt_M1o.KbadjyaFFD4dRbgbA2yX
 NKLnLqOeSMyIiNlt1R2ziMymwVcnzzjTEP5Y6ky_WhwerNXCt2VTB8S6nrbxWG9zKqbludyMliCI
 tDfAai2wlHwLfCo4aJ1d7CbHYOTKS3QEkNYJxvB_fVXkIsyyNWtuf_KNvxw0ataKxYx8EDe5wQgn
 lBlpUq2Iu1GQCm86XjQvNdk72e1qJ6tkvgk0eXC6jnfoKv9QCUhCV2QX6FWDc1Xzhzc_cDuc6.oA
 iuHI4WOK37BaUuQH_2LE1loKanSKauG7Evm_jVM.E1Pd3shvZqI3TDLyGl3jSZI1_HJIJGsMD0WS
 J8x61kAoJj6eOeYq6UPslIFIvF2tHfb3N0dkvYrpkKJKMzbYyNAG4mNgvjSHTwQK2GpHSyVl4OiK
 5IfWIzE33k8tCa1.ixJrCYh_aS.4D.45oDKGpfjDIRwOPwTctFNRcvDtmjRLx4FeRHGOODEbaNEt
 ErXZrcOSBRJorj4e5WuYVGcz.INaE866xYkmccXwPxmmVu6KHWtXDwUZEagxZq9hEkRn.FoY2Rs3
 ikuvvBw3K
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.ne1.yahoo.com with HTTP; Thu, 13 May 2021 20:24:55 +0000
Received: by kubenode512.mail-prod1.omega.bf1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 5f07466c1e228d479742e3c8b2251e2f;
          Thu, 13 May 2021 20:24:52 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        Chuck Lever <chuck.lever@oracle.com>,
        linux-integrity@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: [PATCH v26 15/25] LSM: Ensure the correct LSM context releaser
Date:   Thu, 13 May 2021 13:07:57 -0700
Message-Id: <20210513200807.15910-16-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210513200807.15910-1-casey@schaufler-ca.com>
References: <20210513200807.15910-1-casey@schaufler-ca.com>
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
index ab55358f868b..eca789340ef6 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2461,6 +2461,7 @@ static void binder_transaction(struct binder_proc *proc,
 	int t_debug_id = atomic_inc_return(&binder_last_id);
 	char *secctx = NULL;
 	u32 secctx_sz = 0;
+	struct lsmcontext scaff; /* scaffolding */
 
 	e = binder_transaction_log_add(&binder_transaction_log);
 	e->debug_id = t_debug_id;
@@ -2772,7 +2773,8 @@ static void binder_transaction(struct binder_proc *proc,
 			t->security_ctx = 0;
 			WARN_ON(1);
 		}
-		security_release_secctx(secctx, secctx_sz);
+		lsmcontext_init(&scaff, secctx, secctx_sz, 0);
+		security_release_secctx(&scaff);
 		secctx = NULL;
 	}
 	t->buffer->debug_id = t->debug_id;
@@ -3114,8 +3116,10 @@ static void binder_transaction(struct binder_proc *proc,
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
index 1242db8d3444..b867089e1aa4 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -1356,12 +1356,16 @@ int ceph_security_init_secctx(struct dentry *dentry, umode_t mode,
 
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
index 87d04f2c9385..a179d70eeb7e 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -136,8 +136,12 @@ nfs4_label_init_security(struct inode *dir, struct dentry *dentry,
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
index 7abeccb975b2..089ec4b61ef1 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2844,6 +2844,7 @@ nfsd4_encode_fattr(struct xdr_stream *xdr, struct svc_fh *fhp,
 	int err;
 	struct nfs4_acl *acl = NULL;
 #ifdef CONFIG_NFSD_V4_SECURITY_LABEL
+	struct lsmcontext scaff; /* scaffolding */
 	void *context = NULL;
 	int contextlen;
 #endif
@@ -3345,8 +3346,10 @@ nfsd4_encode_fattr(struct xdr_stream *xdr, struct svc_fh *fhp,
 
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
index c1c31eb23859..3b2ffef65b05 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -133,6 +133,37 @@ enum lockdown_reason {
 
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
@@ -550,7 +581,7 @@ int security_ismaclabel(const char *name);
 int security_secid_to_secctx(struct lsmblob *blob, char **secdata, u32 *seclen);
 int security_secctx_to_secid(const char *secdata, u32 seclen,
 			     struct lsmblob *blob);
-void security_release_secctx(char *secdata, u32 seclen);
+void security_release_secctx(struct lsmcontext *cp);
 void security_inode_invalidate_secctx(struct inode *inode);
 int security_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen);
 int security_inode_setsecctx(struct dentry *dentry, void *ctx, u32 ctxlen);
@@ -1414,7 +1445,7 @@ static inline int security_secctx_to_secid(const char *secdata,
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
index 8ec64e6e8bc0..c17ec23158c4 100644
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
@@ -2132,6 +2136,7 @@ int audit_log_task_context(struct audit_buffer *ab)
 	unsigned len;
 	int error;
 	struct lsmblob blob;
+	struct lsmcontext scaff; /* scaffolding */
 
 	security_task_getsecid_subj(current, &blob);
 	if (!lsmblob_is_set(&blob))
@@ -2145,7 +2150,8 @@ int audit_log_task_context(struct audit_buffer *ab)
 	}
 
 	audit_log_format(ab, " subj=%s", ctx);
-	security_release_secctx(ctx, len);
+	lsmcontext_init(&scaff, ctx, len, 0);
+	security_release_secctx(&scaff);
 	return 0;
 
 error_path:
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 573c6a8e505f..3fb9d3639123 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -996,6 +996,7 @@ static int audit_log_pid_context(struct audit_context *context, pid_t pid,
 				 struct lsmblob *blob, char *comm)
 {
 	struct audit_buffer *ab;
+	struct lsmcontext lsmcxt;
 	char *ctx = NULL;
 	u32 len;
 	int rc = 0;
@@ -1013,7 +1014,8 @@ static int audit_log_pid_context(struct audit_context *context, pid_t pid,
 			rc = 1;
 		} else {
 			audit_log_format(ab, " obj=%s", ctx);
-			security_release_secctx(ctx, len);
+			lsmcontext_init(&lsmcxt, ctx, len, 0); /*scaffolding*/
+			security_release_secctx(&lsmcxt);
 		}
 	}
 	audit_log_format(ab, " ocomm=");
@@ -1226,6 +1228,7 @@ static void audit_log_fcaps(struct audit_buffer *ab, struct audit_names *name)
 
 static void show_special(struct audit_context *context, int *call_panic)
 {
+	struct lsmcontext lsmcxt;
 	struct audit_buffer *ab;
 	int i;
 
@@ -1259,7 +1262,8 @@ static void show_special(struct audit_context *context, int *call_panic)
 				*call_panic = 1;
 			} else {
 				audit_log_format(ab, " obj=%s", ctx);
-				security_release_secctx(ctx, len);
+				lsmcontext_init(&lsmcxt, ctx, len, 0);
+				security_release_secctx(&lsmcxt);
 			}
 		}
 		if (context->ipc.has_perm) {
@@ -1408,6 +1412,7 @@ static void audit_log_name(struct audit_context *context, struct audit_names *n,
 		char *ctx = NULL;
 		u32 len;
 		struct lsmblob blob;
+		struct lsmcontext lsmcxt;
 
 		lsmblob_init(&blob, n->osid);
 		if (security_secid_to_secctx(&blob, &ctx, &len)) {
@@ -1416,7 +1421,8 @@ static void audit_log_name(struct audit_context *context, struct audit_names *n,
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
index caf3ecb5a66b..914ab6a96573 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -339,6 +339,7 @@ static int ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
 	int len, ret;
 	char *secctx;
 	struct lsmblob blob;
+	struct lsmcontext context;
 
 	/* lsmblob_init() puts ct->secmark into all of the secids in blob.
 	 * security_secid_to_secctx() will know which security module
@@ -359,7 +360,8 @@ static int ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
 
 	ret = 0;
 nla_put_failure:
-	security_release_secctx(secctx, len);
+	lsmcontext_init(&context, secctx, len, 0); /* scaffolding */
+	security_release_secctx(&context);
 	return ret;
 }
 #else
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index b02afa0a1516..b039445f3efc 100644
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
index bdbb0b60bf7b..06b7751c7668 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -397,6 +397,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	enum ip_conntrack_info ctinfo;
 	struct nfnl_ct_hook *nfnl_ct;
 	bool csum_verify;
+	struct lsmcontext scaff; /* scaffolding */
 	char *secdata = NULL;
 	u32 seclen = 0;
 
@@ -626,8 +627,10 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
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
@@ -635,8 +638,10 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
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
index b08442582874..8ca1e2b33dcf 100644
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
index 1ce125c01782..f6a33bf2a7fc 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2359,16 +2359,17 @@ int security_secctx_to_secid(const char *secdata, u32 seclen,
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
2.29.2

