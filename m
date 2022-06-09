Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E35E545816
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 01:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345904AbiFIXKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 19:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231657AbiFIXKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 19:10:11 -0400
Received: from sonic308-16.consmr.mail.ne1.yahoo.com (sonic308-16.consmr.mail.ne1.yahoo.com [66.163.187.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8802414A928
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 16:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1654816206; bh=oje8zQ4VCRBDmqjoigGlMIX5a/E3pyPEAc2tsL9W+gA=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=B55to1FCRZX1YdwrNJNchU/0/o3Md6+GOfjGsUMArl6WPbh2E693NgjblLgbqmJ+BsgWrLF4x25ps6nlM9CnqcvC//VRlvsmVOREEID4CSrkw++dYr3wc5WM+dE0tyn3QJOIbSzRh6BEW582xcFiwcr5TvvSjyeLGhM5DOLi5NhcYtFepsgbLwKJNJGxr7/qRfeEEbtwzjhXNkPJ2Kx4IORAkaSTmsQoM8RGssH4/d85OotvapQPRQpc9qrV7pTtzEsJg6QyqEOCSqvpEodekXetoSrLX9jGTWImYIig4KYoceuoW7OD34GS5FIwkk50JoetLmhjk3Xn7vAfh+4gGw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1654816206; bh=CqzXq3iQmMd4vQS9ZElBjIDiU4NZnare2qoWshabyvX=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=VAGUNkNiCk7dzaubmlZkzdBQzkTZkbiqFsmhIzgNw8QJfz5SgJXhYLgVIoMy1wBfX63Oxmc/N3/Trg4D3xVFYr3OhS5DxaijAQ8SzS5+cgEHDzI+h0jJEpuIcpBZvrKu1BUTp3Up1d8OX9Op8vTVX04cn44iVmh6cw9PyydThwgCJ7oF/QXuCzBgzRC0AvRqlJnjePZy+t88jX1cJ0zuO+QHeBl6w0pmWSM+p+pHCoBgRTFNHL9P4lgMRoUHi+ovMLU9fPAFSjsbVOMb4g8Gg5WyG0n8ZgbRNwXcOw6lJ5HLC0oft/7KKI+BcomhbhCejSSv8jeB1MA+SmnNv/QJsQ==
X-YMail-OSG: PHVLovEVM1lj4RfjXzil.wvsOm1FDdshO3vQ5WSuWtkoXysGSWpjFloxbF7Gahe
 KDmb3VqgxgoRFI2cCG_YlzJ8jdVTokkWTs8iqA3Etr8Tl9N.kkoIEkehSAcYFCQEBuV05MczdQM5
 wGSo1puPbL6jOlxzhsD.PfkP2KE99rNpwGQ4vOEvO9E6.vH_XsNTnDbLds2DT_PE6_ngqRw66vnv
 mQ69MRAT5.kjR4mxkB8eZBPbXqgooUMS0rS.IHo7Xc8TAIosx7Im646hrHHVNjuMyVFPzTqW24KL
 XMsadvD7tsPjC19PY.hVI1fNTiVywRssqefTQaWN90qvd7D7Obzc9wN_G0USzFlylUfBtBkTFWRK
 9DYnPMzZYHFBgt_gXFXgm6e.4iMFZjFrHuck9fXSqpr57Ff5qvPtkSxpcd5jWD5ti6Fkcg9_lEDC
 9oWITLtveN5Pv66vDY_411iOIfc4pQNGAD3ElG.fE5YMyR9CC5CowuTzFKqJP170aCA22BTboa7G
 cpMuZ56ZH69H33kHjea0mGwMThhi8X6NFcZ4RLAYymjmBeH_xGMtOSJHxrvpNsgYsrjvAA2Rv3VV
 S.U4RjLTuUiu1MaFiWTcya_cOXdmQpM_q1noyyMdx4ZmTygidmlzwlwBOD7ByDHFbjdFUG0JSXIB
 TDXVqTCdljkJ31NXoNWM8TmHG0783wFWvS0gyQosUvo4lcxRln1ex.1fzfr_fo2KSmK9uTm4Laki
 2jtwoNE102liq9_KIiHu4tcypgQQ.wI4LjQdMrHgDHvgfl3IChQLwT1F47kf2gmbV48UOwzTs6pF
 _u55rnwuHD7iYtTsMk85pogObTWMwRE6wd_B0mvplyivBPIxSP6X_8IgaoluB.6MhZ0xpklRkQ5t
 FKs6Weuckx5zHovJ4ZDnffFunKET0N_9Q36toSZE79isAPiTkcfoFQKb7aduHhwZVTOxNiRKIt_R
 GwDGfucGWt.wgM8KsnzbGFl4e7Vklx67EuHU7R_Khx88F.BcdW.8up.pBxphSIDA7l5AHw00GhrI
 7ECwOV10Zj04Z5ZonyRTkf032pPkv4urKY.h2fvWA2g3Jegqq23BVI13Yx.eU4t08qSQZzV7kDog
 dhrg1mY9_HEIcmp0qWhZhC.liveT0rV0ekkUsPBgZsNuBFbFPK.T0M8yKVfvP9IRcm7TDnVs3hFe
 i4YBCAOb3yw3piw3NpmOnIvZTjmOAk6_87V3fty7pm1O09vxJP5w625SBHuLs09n4eChDvKNmB21
 ICTg3sw06n9zX9Az2xnzLb0JEI080rgnibsFY6iTyEyoVauqIIjRI7eDHUyHvIP5b1dV7DXNd2e_
 dsCs6rl2FymT3Ji.6l.Ja_xPAjSyaZAVAjHPjb_RX1ebLvudfSvypbU8ZLASW2U8KEqVZ9jJ0as4
 9ljpCd2DXaYdUfpLzEs3dsxaX0EyHSWpVV1fOA0sZUUUkznmdvUwG2QVYLhOgSsgrsGDWyw_ZRNe
 YWRjp61ju172pPuzURpxbYmy6u1390G9lXGRw1arQb_LvaD7RJCsLXRhGtSoyculV7iXcV4F2i0p
 XOkQ26jVN1VFAr3BF8aL0uBCCmoeUTY6lPNLXKOhGpEk9kPxs3xbDuySbDNsseqBIyElmTHXKxc9
 m_AskE1JMCgXlZp8dCWaxdX33DBU9iKm18HMS2QwVwOxH98sYyKw12QeAEzZp3Y9aDKlXhp33SOi
 KlYfU8RNiu6ukmmYy644lE9Tdu5KOeB46V4dpuLaBau7JJlRVlyD6evd1MfBQ1Uc_lWcWYTcAgke
 dFv8YNMYtA5F614MQd1zWRiku5ZDThv2l6NlRnqNk6oH.i6ByjBxa1vF0iprC0FTtzkn9ZNbSSxZ
 bkJOvtXHf6mpdmhuwCxk.3Gqoe3P0MoBtgfPEyreS_2HKm6kIMuYFKD5vdlgsxLYWQH.Sl2DlnLq
 g.75IXCd_F5OItVRahwPdfyDQB1xBSbJEuvuzsybaEHnV.b_mvysZQCRpz.Wp0oE5dFLWjjXixNi
 cbkRcQonPnldDY62Cs14h0l.RF6CtVKL.s4HeS5kGoytbltZF4R21TpvXWHZNVU3OIAyXWh.caGJ
 Hj81KysODfemCYlWs3ClzQaFLF13Qy3jn2FNSHNDuaEmQvm1q5AkMwxuwTIz_Q_zPKtUxGXYoHF_
 kl05nfcfmYmkgzq2fqkJ9WILS_CXbg4ojdbGYdvgFsj9lUU5mK3tmVdf6P6EWt7sIyLFhYWS60p0
 rQy8WM80.dzH.R823j7uvquylR5WB52gn62L_PW2d4gZqObwh1qAGzPM8Q2N7gZ.1lApLcaNHLWH
 kFzXhqrimnJziTO9XBiVmKHD5u4f5QF6NmiuEtAZGHQAKfcAc4IeRTbXQqJJIaiQxuvWVLowFYaG
 nzboo4As4
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.ne1.yahoo.com with HTTP; Thu, 9 Jun 2022 23:10:06 +0000
Received: by hermes--canary-production-ne1-799d7bd497-7z8w4 (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 62296d5a5fc11a6b88291aff65d8e04f;
          Thu, 09 Jun 2022 23:10:01 +0000 (UTC)
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
Subject: [PATCH v36 15/33] LSM: Ensure the correct LSM context releaser
Date:   Thu,  9 Jun 2022 16:01:28 -0700
Message-Id: <20220609230146.319210-16-casey@schaufler-ca.com>
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
index c2f71c22a90e..9c1ed7fbda87 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2783,6 +2783,7 @@ static void binder_transaction(struct binder_proc *proc,
 	int t_debug_id = atomic_inc_return(&binder_last_id);
 	char *secctx = NULL;
 	u32 secctx_sz = 0;
+	struct lsmcontext scaff; /* scaffolding */
 	struct list_head sgc_head;
 	struct list_head pf_head;
 	const void __user *user_buffer = (const void __user *)
@@ -3116,7 +3117,8 @@ static void binder_transaction(struct binder_proc *proc,
 			t->security_ctx = 0;
 			WARN_ON(1);
 		}
-		security_release_secctx(secctx, secctx_sz);
+		lsmcontext_init(&scaff, secctx, secctx_sz, 0);
+		security_release_secctx(&scaff);
 		secctx = NULL;
 	}
 	t->buffer->debug_id = t->debug_id;
@@ -3532,8 +3534,10 @@ static void binder_transaction(struct binder_proc *proc,
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
index 8c2dc2c762a4..b1c81e75f37f 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -1391,12 +1391,16 @@ int ceph_security_init_secctx(struct dentry *dentry, umode_t mode,
 
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
index c0fdcf8c0032..d6bdb0868729 100644
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
index 61b2aae81abb..512ad208d62a 100644
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
index a7a445bac8ce..a20fc156c697 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -137,6 +137,37 @@ enum lockdown_reason {
 
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
@@ -589,7 +620,7 @@ int security_ismaclabel(const char *name);
 int security_secid_to_secctx(struct lsmblob *blob, char **secdata, u32 *seclen);
 int security_secctx_to_secid(const char *secdata, u32 seclen,
 			     struct lsmblob *blob);
-void security_release_secctx(char *secdata, u32 seclen);
+void security_release_secctx(struct lsmcontext *cp);
 void security_inode_invalidate_secctx(struct inode *inode);
 int security_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen);
 int security_inode_setsecctx(struct dentry *dentry, void *ctx, u32 ctxlen);
@@ -1453,7 +1484,7 @@ static inline int security_secctx_to_secid(const char *secdata,
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
index 030f6e84026e..cc902c9df77f 100644
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
index ddc8cd65ed12..da36301e2185 100644
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
index 2c1f3280d56e..644dec6a8ef5 100644
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
index bbb3b6a4f0d7..b3e3d920034d 100644
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
index d60bc6abaa40..e434f085afab 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2373,16 +2373,17 @@ int security_secctx_to_secid(const char *secdata, u32 seclen,
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

