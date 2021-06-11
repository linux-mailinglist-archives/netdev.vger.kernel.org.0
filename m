Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C48543A3891
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 02:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbhFKAXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 20:23:24 -0400
Received: from sonic311-31.consmr.mail.ne1.yahoo.com ([66.163.188.212]:46135
        "EHLO sonic311-31.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230493AbhFKAXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 20:23:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1623370886; bh=QuAc0epTafYMBXFMqan6qDl7uFPACC+4m3UbqSQqeHE=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=lokW0fCqPJQMN7jxrfQ+zzfgMlthyZLPd/25Fe/w2Ex7o2QqWambRaKIm/y9nKXnj7VqA78wp0WfuaQ0/FmnW3NZhhTqdzP8Qs+zXcOolaJ2fnc8i+5hjOyngmb3nnYjO/is5KDoNjsuE7NZYC803gtswVgWiuzC8h4fpcbgni8yZSR1nCTEaRazL8DV7BxBFDT/ppeDvPzArDqX9mz9FXl1F2cqlekuN0LDjO6E6Lp4VIppQwwHdN5Bawm6IK4musJ7tXObjebwHO9Drrskhd8rRdiSZOw9WK8tNz7QNfBDYxd1ecUP0UD6k8VUVR7Iz8XDt43/Tlw3/2LhwgXfpQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1623370886; bh=z3LtOPBB/4364EVxbDu5uzU+tvUvVycPRNNdyPUZZlJ=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=KIM3HfxZV0flx6oamOzDqOqu4Rq9ohXu1eAa75KYKMC2F31jo/dJoe8kP37qJ/9/LLrKb4TuVFPtFO5saVgJCrtXIoVDCYRNW47xQSTDWNuO+sJqdokN1d0MjxIc6lr2PM8lvIL65YQLRdnsai35ruVGrETRPg6txg0GrKZ3q18NwL4lI8JHYJRob7NVLuL3s1G8SGaoMjHiRVImNr4jBflUHAQtjqLC4hWxs41U7I4K5uQUZgpvJBOr/5DrLkikJnJnK/KTrj8/TQF8fKW2wE2jwElxgnXKMXjVCfWwuEUwwbfsEPuS83eYWt/cZJsdMwjhKdNjSjU+G5Gw1gMHFw==
X-YMail-OSG: bf1fAZcVM1lpMfhZtz.3SbQuoPWnow6a8LCzKu5Mbf2hQ58z4bTVHCkjOezKpQb
 WJAeahTDAgekp.hdI0CuS1jyae0rPTE8HquO3jjwEbdC5NEYkzvWdi.mTPJLIP2YtludUO7M0_7A
 XGqQC8VNUPAs1kOdt.CZLwRsqoTC2X7OWFqrWJmbHvV785DH0zA9g89YRX1Z.BRHaNC0iQI0AAjg
 cBYdxjSRGBO1zzITlK6DWhItVxyKEQNbSO6o0xrNWVEyoZUnuuunmdkAlrEY2Hqph9hcgIY7XHkT
 .9L.Y8anvboh81gAVGM46oucWT.Q8RGqUDl75dF241qGeHTU8y_QqYBBxDDZqw2Gi9rnuKsInGHw
 LQtdr5OQaxIf_Q_Ady0mKRSd3SuNS42w7nAWezJkv12kzeSil5z58_rPWGrz7b6xQDsTH0_I6pTR
 UEp2H3fXRowtI223K5SsY2i_M6bS1iQpSOozeveSAFIWLVD0owTgsW6to9Cvx8kFGdztCMrX6XMB
 .XrVCe074Nhe.6Imfckdpd5xjsc2etYVKBwGaq0hQOK_DLEU1jB8jQe0Og.YjJ944PcCSGSryBIO
 Y1wOU_zZVy8SfM0TV2bIl8OqpjhMe9QzEyCqcevfn3UDE8fWovUBN8a5KZToH97gN.UFzCNypWrt
 APOS0MIZF3cSzoNsipdTM.h.XkmRZZj7dpvFUHazavpw0oTan50_Hnaa8PK7OzkeUguKwVvIXtAM
 npU3pLiScckMVCc_Y5q_Cya51P4H45R4.Af7DVvkX1HwOfwULxxmNsr9IzKYKNmF7gyuT_WVC4Le
 0uVohZCmqcn4zea.0mGbAQOZN.sOndGhcnGp5l7vQdaYuidpFaqG7priaBrdIGpI.MaTV0EnkT7O
 .fG1gM1kboCqNwChtTJIZuBRaV50Bk_bOuBUdq0Wd4DUZntqEURtvIZyO.tmlgY.iNPZaDen1PlQ
 fYmNpet4D53K7DdDcs8UUMojrCXNFlXlssVQgvdhPa9BXlt9bVL3A4qauf_yoQeQ1hXYQbWfbsXy
 cRYpYkda8jPE8vdAmKApr8ifr8t1YoKHT5wUKDkDj2N4xj4nXhajNA6XKTX.rLqin9QmvEM5aS3r
 wrGLQwuW8AVh3DU80Sp_nYjtKfnuOFHQy40U6_N7MIdtwXT94x_etv70B5j5hfjGuG5XgUQQ1K8m
 cu04QKbMgKa4u5y_2oyabKbQrv2Ikote8.qX65OH5QjFUDD3kzhJRzCZ7a5kt_msjVkSBglUGiu2
 df_Vc7_6U7BUCJV.UPw.XJWoy4I7B0dy7pISN.dPUoTjEUXKl.IO8mF44LA5VbWvh894eUdA6L2v
 xW2Xp8VJ_AON8XPAQ2J03iLxZGhbx0pzT2SlsZtGy1Fk7G9ANstX7Jx2sS5yo1LJShii.AzhB7cM
 VHjHokZ_aqZRf1Xuoo.0zmMWmCVDQZ.B6hS0XGvMWnCsYi4HW39ShqGZdiYjSlKGR3Jop9XepgtH
 aP8nM6LmPuGQYBUAm0sC.opf40Rtf5Xn01h37v.fz1VkXFPIfaEZ5cg3zBXXreEjyBUg6gixBydB
 9pwQFhF20AnnIMJTp4gDjShsa2RGfXHXFPhxUwfT8QjJN.z_m9LmUS1pgoCd90.7yrWskd_QUsBN
 iSYErM1GmEXtaKZSZLjdZgbCAV.4p7YYfTUzvutwVTN802m.q6MSg7IHFNyYwlnpxP0eMkeTfNEB
 xm26.y03UzvW93XvDAaJtpxffDKZadZwj0Uvv7521Q90o6Idnl6yVh2ecCTlJUQrWukxc4cChZUq
 .gkx3ERM0zdyjGe3VmTWMp781vBLj6SLtYhfUoXWno2muNO7x4wa52uhuIUyryeyU7JrjrYO25OK
 IKQX0AppvM53hpEjh3R0VSo2_4MZDCn_vs28nf5YGfdtbnfRI5y7NJno1d2lcSABLyGTwi8_ZtsE
 79KM3aRCJdDooOMBUZJZEmqTk2t0LimpCYkole.UwLwM_xv0olkdyGTdIAoFrY_qAbWG7IHCAptx
 zCEXd7o7avqr0Zd.Ub96Gnp0eCkjSW2t1xh8l0KVG3JSTVIQ.L0qJ8f8SHzTb.7E_WvH6r1D54R_
 1ic.6yaza0wiKC_2FB_pxQlPC5EMRZqVtEwKs8W9u54h4bniKHDMMSE14hGaNJsHgSMVXmFyQ3X7
 Hcc_vnsxj04PDksvyxQlmAbYNkLSpn2NYLxxc3F4Qxj0jZP1rdze9nH5HWyDvswzDh_3bFLUD0qB
 fr7LJUlFCmxHNQvJYifGDgJ6bLO.PzD7wOjtLa.Q6XOsnfx1xhJFRHaXqydCrIKW6pz_enDHUvpZ
 m7BOis6_9N9uEZSpNjPQzo58OOGVWtMs2oJnLwZKeZ5iyKrs2Hfoh7yJl4HId2dF2wmxstsGFgCP
 2vWl..WwWDRVGM7847dty49U23btXtSmALZLmrWcMyOerf0I0hczXRJiYVdDWAjHgaF0yL54F91w
 ZvU9OMLUiJV3ISQCsayfmlWKIi4ARExXaUdR8wef_9lyRSU4FWAgLFITy.KJE2zec6518k0bl.qM
 NjGLzvCatV7AWU.OsyPbCrScEnatp52vtA22oK1z5EFoEyuzUosCNNjDznvYuA_gT_y.mjutuewy
 I4qP9k7tgIqPFumeovTUWm.2B4.BNdu8La2i0ldq.peXviZxU5eBGrXK29mzv5stR34L3iFp5emc
 FIwQXtLxJ9_ONsdei5pAYtG6FNL26.46QFRgQpvkW_O9iJf5SSc1XWNMj1s4Dd.R8_ao_6IBLKxp
 iA.VWG7LGZ4zLl.Cqm5p9lLXEyxDp5yHE9zTNjn3r2lN7_rNtwVBC.PGw1tqwMdczZwIgV0kSIO3
 J1dmqrZH7gPIExqO80HUeGbrWjCk8uxUi0kQ_rAfKvGMWkD1x2fes5yBtQmL7Y8YRDJaOZfx.cbB
 Nox._EbwyCx2IYB_egsVOMiKRfYDdpSHG5m2a6IU4Vd9.88kduaQFlde1T9hF3xDe6hzOg4izfMc
 7rLtNTzUm4F0Spb42Uraw7r1iZvx8NrQWOh9oyWwpPC6w1SY_xvgQTM2dBQWpJan5lP25AP5HfyH
 8dHmsTArfTElb0r0f_S4ZM2agmdYJpuYmDBUBp28v8sy1KkInIwW9866xIcB.VqPsa1NYsLu1bPe
 mgaZKOHacvoF8USKi2c1n1MvOEDFx976s0P3bkd6ZApfmbdCvzkzDJarzDJAOWvTclVZO.bdtdC4
 M75AXR3xvRaeu.G_jHGkIn_nA33OX2XmoMJcgkROMY0uz31qX1LnbMN8WcOoO0zeTfDEBKY1Z7pR
 X7BKiQtXaCM0JasY.l5O5mJhvjPrZC4iQnhCWjfozZchiCtpNrOlG4x0UQGWGd8pbeYdllSqzOvy
 I_JlG7uEEuWhYgU07lWw8f_vtXF8JMXXeyEBbdIbuCQng4ynnZ0Oi9qDAkbD1FVUu8qJg5_0a1Kx
 XvsuYWSn_m9ZujJ3S0nf9vRKF9xNSmUrb1R9D_YvqEgk5vQ.npBXkTVUL3xuqoJh4rJZFL3NF9q9
 0tk2QuDrL
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic311.consmr.mail.ne1.yahoo.com with HTTP; Fri, 11 Jun 2021 00:21:26 +0000
Received: by kubenode502.mail-prod1.omega.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 45e3f949d7db4fa60da3a4cc7605cd8d;
          Fri, 11 Jun 2021 00:21:20 +0000 (UTC)
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
Subject: [PATCH v27 15/25] LSM: Ensure the correct LSM context releaser
Date:   Thu, 10 Jun 2021 17:04:25 -0700
Message-Id: <20210611000435.36398-16-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210611000435.36398-1-casey@schaufler-ca.com>
References: <20210611000435.36398-1-casey@schaufler-ca.com>
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
index fe18c8d8bc22..afa0b116d222 100644
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
2.29.2

