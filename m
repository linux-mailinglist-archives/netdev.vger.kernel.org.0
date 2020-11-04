Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC34B2A735D
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 00:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733248AbgKDX6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 18:58:48 -0500
Received: from sonic305-28.consmr.mail.ne1.yahoo.com ([66.163.185.154]:34071
        "EHLO sonic305-28.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732557AbgKDX5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 18:57:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1604534221; bh=NjD1+KtwElZe56/UGI6PApTnqSE+EEj9ZLVXzNuLfBA=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject; b=TacPj9ApVH+EUYrhvYkRyDwcUoWB4r/z2ezYwS6ns2zJCM31poZV0t16JAdi7acv5+NjGXcrpeA9zsRxq3TpupV4ttsa70JjKi5GoMCEJr1j7nxfdhCHEK5CDfUSf+A9mQTyTiI4uDivH/1FjB9ytosqLd87gDAvD8+vlPTO+jdZY1PC4PreHY/91Bq6KK+buM3q9BOWxFqj/19Mqy4a1eVKvIupMr1HRO9BKvF3tEwN8nWw2vGNqdm02GGAtOVlIBIBlJEd20c/B5jKNxHd6wW0OQOEXKECLFYwzF2EFcRiBD12aXVYUfnbVhGvWYIiLoNNkAiy2fpPtoMWtS/LmA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1604534221; bh=MdJFTVIwice8z6Qr31BjcYfd6OGiITBBohbEvul5xSK=; h=From:To:Subject:Date; b=VVYOH1ZuV8Gp39UyFQ6qxlimGlRLRprmQqFmICJm6iNTkQDDHmFP7o3D3ZeGi/TlQYYIDd+TpPEBkKL5bbfswmWQ8+LvDKd+TFjD83+Ldm/39oUJ7ybf1mAxayLPnWm7u13mcyL10cYJhZfyjUFG9mG/XxfUkboYBypUVxqiFdlOnSp+OMX3ybK584VqRgT5+j8L8YvyhEe01IFLVV7WNXC0QF3yuhX+Y7UkwcrxfbeOZIPg+2oZ3e2XNY5rCwA2Ww2+A0pCkhuBLYZkFVrDtJAp85A9nKsJJunROkb+wM9fIORKCpjM7rus2fIZCjnlwPJS/PixIftnlKF2SR0sPw==
X-YMail-OSG: agIkQ8MVM1l.5pnlaHlRT3CENiUjgSNFPp7zfOkfh7jR.V.U6WTOMPzOL2kcuNX
 6QzRoCOkBw5.jmYRuNqTTzgTMFl8RQ.v2bVN4cvF3ZscpUpxPTQjMgMt7wuw8Mp7LmIGMSCql_af
 kSvc2Wivk_2KN1sNG15GpHINxpvz3Kl.7DB2GTUkCKdJO7H92mw0wDnh8PgfTeL2aH9NB8JQy7A6
 i.E.XrsYDZyrUyOC2JVqAZvOoM6DC7IGvUmGcQrYUHqomOzm3Opy247mEsk3pWRSKNLI_wDgydzC
 7fs3UbYlsPXdi3uiVl.6d6_9NRozvMrUs0wIIul.v97a9m1fEaWOr.Ao2iwYuDLVNWdWUVCCY9dH
 qJ3vNbvttso5yaFnA1dl6xVl1n.TSGbsbXNe0D404uTFksALT3Wwwj2sU9r7teMWJDLKqsHeo7Ww
 wJFnKiO8bB6SnX7LOZrgacP_paYWpNRikGHz3vKA6NBpc3xwJ_gACd._olB79Z0WFtvihL6jHCAl
 sM89EStGS0_G4nAMBJWcHHaSt7GrlLuzTImBJ4KuRfHwPbfYDRCOtWA2z6_FEkNf8059MwNMNUGR
 XwzKCuFDMtBRWYhNSPk7mMraH88fr9mcB3Yt6T9HwpbkL2dMBE6B38NHx.Y.wXQGCkeGSFafdBEW
 XaRjZtkhpQiVsnTEC.se2A0nrXGUnCauxCOgkVkjrzKfCy95CLtusrK5BSTvvqL0PV9wSNrDPD8p
 9vsQAOO3cpwJ3ncAKcF2XTEYcBwW8xx8OWJ5JBO66ZJ7WTqe1FxMAn.NIeBM11wpSYFBurcjR6RK
 DLUFVNdBD20Ifqmh2wyDGGBzXoB7UerohXg8lveyLkL2EzVwqMgroA12E_7R2vpGsHa7nrGhoo2u
 bBN0MfJdmhuKnyuf8lWOV2iXufSSDrIXxdasRmR7zF5kiC2LqgwxRrs9YxEDlFVNDtlmN5zlcPxL
 vvqSAC1uT0yESOF39WALZ2icDu7ASvOY2BphlqqYaujDSFfzO7fUmDWfH.4lF5sIQjbPUIWbfQn0
 NOIOdjkKdvzufMV.cXEzx2ECQCOdrREGTiy6DuiwFIDP_DXnM_azSBQjU8EHUSx31Q_CBWe9AF8l
 9tDIPlIrX8bnUuFxJvKsntcM7epFWMoSziPyPZjb5Q13wENKldgiTP2Tf_LM5yMb9w5CNH8eITgF
 qXIFjoSJob17B9jGAL5VJKyXmbf0r7YjQGipbS9qX9HVVpXI_AN8U5yhwzQCCagRv0alpp3wz6OA
 M22vMa.daiR9K.cKEBz7p6BT4vzZra7MiSKLqqc67xY27irdhWCS5vvXn_jZYyvuzxakF334dX36
 MttX8lDMEBsCOXXnOmvM5GahQTQ_ygvnAyR3w8y6JVWNQD2SgXSisOYnLAiEM9QH0FapxSpIxxw9
 Ce3tzp_ihzsUyz79T_02l.NlDsDj1besOPF3Tfq3xGHIOH92AUtx5lPUob9hWwZmOXrbX09XJLLq
 Aw3aFml2PrybJe.vFhrg6Afh7LPi_ybX5I_wqZOncaT7F0.Whsv_nhpzzzVL_eyLgjXqQBaN6Cc_
 5UMduR9bnwEZqisRE7vQdTXOYaTfgzyUJdas.lMd6QrT2LL9FKpbAwXx9QKxKzbpcLW2i4x2N.l1
 SnX17VG6bIhdjzsh0W1QAzerx.DRaZkpjTT8ukiC0GYxzjLKOzWOfdvclXcz0g9puzqHtJ.rodmE
 E8GKh9GkWSL_dsRpvPMoGyp6sqtR_WYqYImTFaCodGrR9cGdKHwbkndXja_Yeue792pr06.9gY2l
 nHi9jqeh6HigDaLaLoIdEeqjhgeDrWtI7e4Xdsy.ABHz0kTa6vel9kOTmYoQfSMX1SqrPTG30gHN
 LyhF8HBlbgqJO0pwjSFH_kyvRmxHtLowALkhjunoTZJE1nnTTlCIHfyC8Zm0_zJIUA1PrhDI4Kl9
 GJdoy9Vot3QTwprJkwQ28r6JWFB.dLH_t5lVVMChdMR4.FwZglwuaEkZjTS3_Q.y3fIu2YiwZqoZ
 HJ1_wiHFoAKqukHgVJceA7P7XZixDRyM6Vl5cPdkmw.gHCs70iRYuy6TyIVXxVMwuqVdjHXW_7AJ
 8c2paT7AjYxwa6ED..8ovYJO.p4mk7jxlb_VQmwYRwqK5o07f_Cfok9BKAe2yVX8uoY2XBOenRXF
 1kBSYdZQn1bIhWzFsb_AfmCBllvU9jos96GF5vXP63Q4qJVVTTDMQ2k06DXqHLJHDPWt6aX3Xa12
 x3u.KB3Idv5Jr3ZdfRzFo4iWao2JeoSUDVDp.pDxIVGQbESBcr40Fa20uuffCQ.C8uYCsdhCYOCc
 2.3bXTxYsrVYk3qsqPC4CICDYP2A_R2LTQos_9hartcEAo6J6CWfhgCE05U4luG4w5QVbQrD7zfe
 Bq0V_n1HVkf3vJsFVb5IRFJDKkx7._tXrO5XfMo4VEO5xCLaj5I6l0jgafonHH_Mg2dwGmPvK5om
 I6xYK.hZ8oPs7nzjePHjZGH9wSEK6ELBXqeB_E98zroysZYA5DLn7ldPa0hO9gc9u3M08ysauuUm
 gc5dKaAxwkPriU8c9_8H0wJ7NvTju1Xkjd6utJ1AWlobHN8b9Z2ioDUhGQOHv5lmPu2dmXvv0uiv
 A5usJbFLH84Kgt8or2R7Sag.daz2U1NAZN_0FqbzfgsM0etii7WH2pabodH67CtT0CBOx.0z4BuH
 X8PjspK_ahjaAeEeV3R9ItcuQR03Ws3..1l3cP7YJJeQBRzq8D_XdKqK2WkenqObPhVfNAz1GGyk
 LeaKFS60MXC5tQVZkz6cmUNtYbD_HDtZzZR6zokq10cvx5b3WpyRNgVvLYRwXHKQEPO24KOwfQsy
 9KYqltzQCN5h7dpXbsK6amfbTR1X4O594.jJYCz6PM3k97D2NC20mPbPcERNpsVpd1dN3PW5ixAG
 yWvwoX_TofDzcU4Ss26bki2hANGA8iA3fIaE4d9GzlUGJGoU_BQXg8RthLshSASQuZ.Cb1tYKnZr
 3_OS2dYeXADbGCsXaKviBxKPGwKmppRYe2Noj6zizn_4ESmnxm5e1S1Wme3OLiVoZeRpSZygJ5JU
 Cs.lv1TUn0WRh9eUlukui5bD.Ugj4IoW5MtcuA7JKXOUTcNOmHfhqmIttpsdFkaOw54.aa_Rv82g
 pABt3WTVFL_toqPY2ZxRFTcomQ9ENkRTlDDpczChCe8UI2Tchk7dSfW.VEaN3XsKamRaCP9E5sWK
 HTfGJYB3slNA0ufc6Ov8z08H9NRroPZsGE5PHNtaMogcPRDplZ0wyhOSStaaLF6NlKd4ub0WQseX
 CyIXGzLDxD3xmBb9ktnJFbrFX.04I63BQ3_Wnflg7_D6FSk5Rvvu3HZ.01y6wEGkRQ6pPCi4EZlx
 8iF4Xf4jiR1Yzqk9VsftyLabO8sco2gOyjyugGOXzwKT2W7BTfv8GoVu0gd1ApC7u2mBTHV27DWL
 LiwZ3i5PkTpp7.b93r9MKo2hE3Od.PkeFWLzpYtwNYWLUUfhfRg8kVurQ2OFAgRegFw--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic305.consmr.mail.ne1.yahoo.com with HTTP; Wed, 4 Nov 2020 23:57:01 +0000
Received: by smtp404.mail.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID d10307ef7e6d7a3eff163ccc4c899d4e;
          Wed, 04 Nov 2020 23:56:59 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        linux-integrity@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v22 13/23] LSM: Ensure the correct LSM context releaser
Date:   Wed,  4 Nov 2020 15:41:04 -0800
Message-Id: <20201104234114.11346-14-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201104234114.11346-1-casey@schaufler-ca.com>
References: <20201104234114.11346-1-casey@schaufler-ca.com>
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
index 94071f67e461..3e06efe29cfa 100644
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
index f9d9f68d40cf..9107ca5a6af3 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2245,16 +2245,17 @@ int security_secctx_to_secid(const char *secdata, u32 seclen,
 }
 EXPORT_SYMBOL(security_secctx_to_secid);
 
-void security_release_secctx(char *secdata, u32 seclen)
+void security_release_secctx(struct lsmcontext *cp)
 {
 	struct security_hook_list *hp;
-	int display = lsm_task_display(current);
 
 	hlist_for_each_entry(hp, &security_hook_heads.release_secctx, list)
-		if (display == LSMBLOB_INVALID || display == hp->lsmid->slot) {
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

