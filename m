Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD8953D1B2C
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 03:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbhGVAYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 20:24:10 -0400
Received: from sonic313-16.consmr.mail.ne1.yahoo.com ([66.163.185.39]:37948
        "EHLO sonic313-16.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229909AbhGVAYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 20:24:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1626915884; bh=Bcd17Z4mRBYEGxEMRMolb/6U+A3obw3/nhHKIji4ysE=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=aTM8rM9LS2vJ9wBgFPWF+UA3bsaYahz9bn0A6e/SssC/IcBvdY1T+hDkkv51nJ86/a9MiY5tmV1NUZYuAJFymV1piLWtciIeTb8rOr9bzZB83fu8tUpDvryy5rTh+jpvjQPZpLOrLqiYayBhnrG83lFGr3DlJWoVxdkbi1fhnZy6I3wqYKwca2M9k+XVHIo+ykm4yeWMGn6EafwFxhhdUsbB9R0LvJCk2FGyRp5dpKu4IeWVBdg4/gpDqaqCuf9bW+Gv+DEgFCdbXST7KNneQfcFGscAVsBiQRj34tTr8wLB8IgiFUVORppyVH0h781dkME+64c+dCxcpuRVS/A5iQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1626915884; bh=7Xrq2+0JcwQGxqmnpBxge7RA0iGgSihT6gphcN/RF1a=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=psUxmFSqEXo0CBK4ttxswRK1625m0vxzL6cJGr4niXGElzpvHs3BqVgewOMSZc/3PyujnR4c529dnqN4W12X1NEd819mGUrKkf1dufUNOcj+9LKFaQsXmxsjCLUeN5Us+bjwpcEZyazJxOYF/ypSXgRM5Xk4ctEq+niN28GmaqBkwg1+/zrlawEnzuPWol1xMi8XM5u/jZYX9m3UO1DATuW9i99wcNg5xkuDPYiYY9oNWFL9ZTWsHuAZWL2CmbhiK0pgfCUKki2td0KiZEyE90dKQagE3g1sD0XzyF5mPBCyimMFVZuqnCz1mdpwGccNfrUYT2ziCzcyJRjepA9+WQ==
X-YMail-OSG: 4JVQ.Z4VM1kuX_oiySrwabFzzxq3Z3AVvKFgGiX8YdgRFX1.L.fZar154yDkjBM
 cpMLQiiKUIjYaembwGaBApV9wUDBJffc4TWgoc81OcllMcwhQGMtDw9p515u5Jbp4sY8mF9N64hG
 .K69D5A_Wx4yhwI8xVcHsObVpJVDY85axFW6pUDqsQjKu6kDoT.70u4ZawmdLv9WAtuJt2ZvaUw0
 jmBJGflhxzupy7KJc5ziTNbnqzDDOmZ6ajQOcz70KECAhs.l60vSX1SvUhx8sOVZrRA2_E7d9gfh
 tURSpGbXRvRaZg5tn4896.0NqVDvEWScSUtd0W5cIYgh5RZ6iUvm4n03SqWz4tcSqPhoWhMcps0_
 UAiJEeSazqKxyxqWIMMeGdtCzJPcixn7lKp66tw8BbDDLZ53wC9z1SsJI1hp2qTtWrHyb3yINaHB
 pzi6Zq8eJ8P0temHYniiIsqJcCeVjiq9JZQQIg2dqAbJSuePhE2qRuP9fJWRDgBnOSbrDpl3Oa3N
 R4qVW_6zu1L.ArEEodT9nYJA33wxqcCiprZyz2HF4keAzwn8bAXtdDeD.ayMYYG5fAZLa3DBfYAM
 2AyZlUKI.8vxKnQDGdLSHO6lk2jS8u9Wxt1LmmAFTCY5PdFDfSBLG23396R06o67bPjTKouXTegx
 gtgXskb15GOurdhJkwLivoHCrB8yC0wnSIbAcsVJ9C66_isV8UXe72D0WH35CQ6eEFcwoyUdGcPi
 7uOPc_inZoeKXX.mIIU7mzZWJIjzchBxfg8CmJnVh6v5mZKMKM3snbc2Zg.L0nk3qlvZrwJ2rL3d
 SNMiLKqMc5fJDShFRu_UZsV6deBG3aj31YnnoBJA2EnxaFLsZQx_fuiW7B6rmYjDs_wRPSiOY3aD
 Z9BnQxz_OrTnIZ4Xd3hhkN5jxCKCkM4rqcmCu.MCKwaK3y.UkoseeJDvR3oMfDY121ZSttc3OeB9
 SWTimh_3L1UdjzunauQsA2w7inejrwiq4u9L.NQ5KJp0HBbx.jpDyP8JEqSwoI0CH7BoYF8nbT5T
 FoaUax5mhKF5jNt7J5HtjqoD_vWHSyCSLe3K4N26ZkVfwRtIlqiwNtwl8iMyiQG_uwGuuPbYkKWE
 nCjAheC2OZN10o.QfDxznycVc1STsqadXuU2T.4pu25xp1lDUa0MJ9tikawWmAdJWLw8m7qBS_iH
 fGYqiL8Cmb7lKZo3ZTdYkn7INuGyZXLunA_PEV2KMPaf85_nmCa_ad5FVHOWNQVmeOKbYvF6mvwq
 K.V7_TXO0MzZKsSACC8Aq2Kg74EmchwpyDWDhHGggWNjWaAJsinsZpuBj1LyTVemi.ToJ2W.Ocnz
 qIeWv3ePPTHlfjohu4.0uPlG_NTTV4a2Rfh1yxxu6rAMOp3PTUvnmfabCZ0TWOC5zSrNTm3U0Kze
 5tRpwXhsOlecVHQCTNq3f6dZSdjm4RB.zJjg.fPP_mDodF4ALx1_p.aSO3uQUDumvTdeiOGKHGtZ
 dA.HdxlFq.1eUnuZnOv1ptQAUUNlim_jQVrdVXMGZr9PBW7AE_EzVnVyOSnqKIjeKTmFdMo3kW9s
 uW.Fy.eVV4ouQd8Cc0hfwh_UOsDiZI7SZj9wCjwjYbHRzpbY43tmkcL9onoaze9yWrlEClT0TOjx
 ln_OVOtCgzjRilp2QS7t.zv_BdHf8zbfyt4IbYkzmx14bpQPlnX4dvtD0GEA76cwMnD.iH3dJV28
 EpFTynZDYBblhaioT8LEH4sL5Rb_jC3gfakjSD4IrbJW9ARYt7W.3G3d5CHr9Z_qrwliwNwrED_8
 9sYqSyh8UoYEk.7iafl9Wl1ASt2v_gJu.USCpBzX8.QSlC8g.qddpuGZQ0UEZV_3dDZtu6EivDUR
 qm8LypFBeOLqq2acZLYJCJfgHy7geUmXHqil.XOt9O0YIViG8krbkvUVANLoBrXDmXgdD5reZGYj
 ia4YrYwZFG0t9iMSaHhHxL34LDn5U7DSVsbkz3EBn.T_RAAlVC5NgoDyRYaMKTl2MsVXZKoLvGjf
 8eB.wTr9hP_soGfUqp77qGcsx9T5f.biGnmRTdPcJE0TVbMuJ2FtY67M.9_NtO5szCVdTJEyiZzn
 kgKJSQY5z_8G4mFBLX4OZvxESUWYdy871O_hqQhFETg9NZ2dR3Jacg1.YlOODGqVXvYiQwvg0915
 MqOjm1mdlOg_cmL2RcR2t63AfjR0EMefyagpeKIYm.6Bk1a32KGylWLbJTxFWXUF5nbzl6kxsgdm
 E_oEu_lgeKsmAFRDg4Sc5jjBUoaeK8ujkB8Smyr7jMCrITxAgxbT.V9luvq2SDj7pxfSmVHJ8j6Y
 .V6L8pFXJpPympU4AXmASDHBddHS6Z..f9ahPq7U1ToUZ7UY5alx6bij0whAEuYMawuK99Shk4yb
 GSH2SI9icJs0xO9XArDxnHBeCCJ5oeuirNJSNXZjMtoyX1sbTCY873anYevO8N7pjT77jJhTbGZv
 xsulJq18TyE1umpBjtfXAP6XsXdM2RPrvtm0xj03vubma.ukWDsQDCvOPwTgpkasJDQlq5xfWInu
 fvmhLEv1u44poI_WdOPMY5yRgkriQwYQA1fXgLlfhQ1knS4zWPFKokq8hsgD3fiE0vJfjltxWMVM
 lT8TrUnqLNwB.vyOoUCdxa6MuvzpQXHAGFFxj76iafVo8hhR8yFgcSzXe06dpgqvsNO_1dgIyJCi
 twrWCNiDdao_zYnXEmKEOSsJkemyyXtC8vTh5o2vWOpdthYbg40umfc0X97yi1u2NjyFAWohUr1_
 wrwA2fGHkdf8d2s0vBCKWIF49Bg3vYqSnG956LZzTv.L1Y_RC6x_NYjbS2bhLAwiVtZ3U4.v81Ny
 osNrRAb2TTvV1sFaWztJcabP7oYJi0.cnsCRSVGPoKCkcvoV4rNzAYlEVklyyaiLd7pH9trhz9_3
 e9u0t7XS3d54vJ8_mok2WwDg.KnMCsugJw.FtG07I.ZOvrhzMGAWb9lUROC9ZJcck6fHG7ZPMQJv
 hbl.FUeL5NJ.CnwPQ7CZ.OUnPoJSusSlCOMOc8XfhV9X_oNMRMGOc1ao9otbANa2VjTNmmBueFrQ
 7jccdCsYYuvptMo.ngiL4swySwWA6JC579f1jQdkrU3ESzjhd40r_XNd2peIpxjx_CfWswpLFnc.
 B3B.VmCF2g21k4IAUqJq8zzEQuWA8jl0Ax2NzhIir8K.nkxMMopQxx7LROEmQn2aArtG8yQKHZKF
 jBVDB9UWV4Rd3yHa58jwnI9_uStm2aFj4noL8kumJrrrt5Fd17Yyd7RRy65nPLA6VmT.U0.2.y9W
 XI1P7TyFkvNubVLH_Rycy0FC4rzO8fAmSTZif9YvBuZgOxMHGAJep626vAzwMPEHVu8FApJ.hZfJ
 ghPpzoxLVYRqj32dsKFC9dUH63DKmbOzHI..0bd9vHErnlCHU.FITeD.hYiIsudoPr7jIJBkDquN
 JzgxubprQtlLSHH4MJNnugdPaD3Znfw7Sid2HIH4EBEG8Cjydai_IKPxxZz39nYJThPuJtBsMw6Y
 1WXc-
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.ne1.yahoo.com with HTTP; Thu, 22 Jul 2021 01:04:44 +0000
Received: by kubenode548.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 5a5e18f5df3293bfb2e0344944082a10;
          Thu, 22 Jul 2021 01:04:40 +0000 (UTC)
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
Subject: [PATCH v28 15/25] LSM: Ensure the correct LSM context releaser
Date:   Wed, 21 Jul 2021 17:47:48 -0700
Message-Id: <20210722004758.12371-16-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210722004758.12371-1-casey@schaufler-ca.com>
References: <20210722004758.12371-1-casey@schaufler-ca.com>
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
Acked-by: Paul Moore <paul@paul-moore.com>
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
index 96dd728809ef..8976ac6a5adb 100644
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
index e1214bb6b7ee..71004670455b 100644
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
index cdd8d9122795..041e87f3fe4e 100644
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
index b5807b9b8a4d..1b1ddd62de6c 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1002,6 +1002,7 @@ static int audit_log_pid_context(struct audit_context *context, pid_t pid,
 				 struct lsmblob *blob, char *comm)
 {
 	struct audit_buffer *ab;
+	struct lsmcontext lsmcxt;
 	char *ctx = NULL;
 	u32 len;
 	int rc = 0;
@@ -1019,7 +1020,8 @@ static int audit_log_pid_context(struct audit_context *context, pid_t pid,
 			rc = 1;
 		} else {
 			audit_log_format(ab, " obj=%s", ctx);
-			security_release_secctx(ctx, len);
+			lsmcontext_init(&lsmcxt, ctx, len, 0); /*scaffolding*/
+			security_release_secctx(&lsmcxt);
 		}
 	}
 	audit_log_format(ab, " ocomm=");
@@ -1232,6 +1234,7 @@ static void audit_log_fcaps(struct audit_buffer *ab, struct audit_names *name)
 
 static void show_special(struct audit_context *context, int *call_panic)
 {
+	struct lsmcontext lsmcxt;
 	struct audit_buffer *ab;
 	int i;
 
@@ -1266,7 +1269,8 @@ static void show_special(struct audit_context *context, int *call_panic)
 				*call_panic = 1;
 			} else {
 				audit_log_format(ab, " obj=%s", ctx);
-				security_release_secctx(ctx, len);
+				lsmcontext_init(&lsmcxt, ctx, len, 0);
+				security_release_secctx(&lsmcxt);
 			}
 		}
 		if (context->ipc.has_perm) {
@@ -1417,6 +1421,7 @@ static void audit_log_name(struct audit_context *context, struct audit_names *n,
 		char *ctx = NULL;
 		u32 len;
 		struct lsmblob blob;
+		struct lsmcontext lsmcxt;
 
 		lsmblob_init(&blob, n->osid);
 		if (security_secid_to_secctx(&blob, &ctx, &len)) {
@@ -1425,7 +1430,8 @@ static void audit_log_name(struct audit_context *context, struct audit_names *n,
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
index 9bf1f5460681..89be957f26bd 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -342,6 +342,7 @@ static int ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
 	int len, ret;
 	char *secctx;
 	struct lsmblob blob;
+	struct lsmcontext context;
 
 	/* lsmblob_init() puts ct->secmark into all of the secids in blob.
 	 * security_secid_to_secctx() will know which security module
@@ -362,7 +363,8 @@ static int ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
 
 	ret = 0;
 nla_put_failure:
-	security_release_secctx(secctx, len);
+	lsmcontext_init(&context, secctx, len, 0); /* scaffolding */
+	security_release_secctx(&context);
 	return ret;
 }
 #else
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 89b6f5ebcfc4..ca2ae290d6ee 100644
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
index a781e757d593..005900a0c397 100644
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
index 098d0a1a3330..61346aaa2898 100644
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
index 7829b8f5d15f..4cb540d93ab8 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2361,16 +2361,17 @@ int security_secctx_to_secid(const char *secdata, u32 seclen,
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
2.31.1

