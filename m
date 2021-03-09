Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C64D8332971
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 16:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbhCIO7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 09:59:36 -0500
Received: from sonic309-26.consmr.mail.ne1.yahoo.com ([66.163.184.152]:42076
        "EHLO sonic309-26.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231410AbhCIO7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 09:59:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1615301970; bh=LSU+EkqD0c5zRZoBe+7VA8ArH3JWctcbCO+fWVyN374=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=r73yZvrhDSB1Fx4qA4GLJxcTrz8gn1KBiPBUjdQg+ycwIvNDWruWd/pyUpBq35eGjETliUeRcmCn+CLEXnE5X7jqvQD47xM2yDjYcGmBY1+0EnsXgGOoAAcDuf/SE2S1+uAYJbArgKK1rGZNL/Bstc/xovN4muLCHIlHwZyilgpohs01yGkb8hPnvK34/NWj35zKjQ02bwWzuFVSdDPjXPLO+GzlT22dOVTlMGcCsszNEnR87FDSKZtCqX4Fw1zhKLfTSd+YfGWO80mR8u8rDnguTFmQytkevU1n+3lsVVJU0K6dRC1hUrIpYBQtOYbWoURBtHaYSAj9cjc48eec1g==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1615301970; bh=eFZhiRHekSkfhaVLecz7mGCLa1rzi8m3JnPk06ZRbct=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=TuQRETmVuCZcLTL2GPpO9UdT5sSWV1QWlAZ85UMZrIfY+S+x/fT+Zj1AIaxk+A7CLnswQbUVkOAiDd+VBtay1z6WJ0atZYoPupcu9sB6n53Ea/EYEWijfGQ6Ljvo8cYOfNJE5PTzN1dLN+bX1pqRsx4vCLWJ43Nh9pPqEWMOOhocyo66hIUlghTtvrLvvke5JGpLTRG9ppzBctfu/hIxf6rLm4VxeAlkLsCgI9iYNxAmssQo1gQFdxsLgv92WW2vfg9CSNBKkiMjZw/7X8CsrOpz7puMwpbwPw2HB3H/wPdqLCNQ1eDjgCfIV8zhpn+rqW0htCDW3jidpv+XiaelTQ==
X-YMail-OSG: xo5VtTwVM1lU4m8go5gnkjbknMU8xL6rVdR62umuJiPNBKOpyMcRDbcNftd_6OX
 MHi.sppbit_OyHT6LnCeVSuwM9esf53gBgTgOW6RviC8d.0oIF3JTYlLjkZeNv_GEcZtor70Iuan
 VLOZZ704YWCwT.Ke_H7sgWyCL4ZLXh9qBXDBywChD8lBtX4H2YeDU6M4GLSlQH4EYXqMhN606dnk
 URodDX8ZTHiLG5GF.oM4wpXj6WSCkh9o1mGElmKyROAKWd7bkYgszBY5FZyyEjkMAieSB3Cig1v9
 JoRIp0ucNdj2RIrqYUyMhs_dtx5F3FJDpFbgHitdI7D8V3vVkbJMFnudwLv7dkHWRmEc.FJYn9Tv
 lOqQ7i7WXT8bjNWLZ11WBxP.qfVqj.kljcsQOIJJnQMmmnyrKIppoebfE1xboaF6qTMexjJ4YaEB
 7BLO5ctsji4qA5HbbRvdG8Rh72M7tLRhBqJO1OxCLn_1Z3c.AFBSlUjnLVRKdRo12Wf_EjYOgAyD
 CmgbV2Liuh_z4bXpCkdxkk7nHqQx5h27aqLjjFe5d800kTahWFBnUxQUhSQofr1EapyE3J.osbnT
 fbP7oakpTfmCko_NmmqbuZwFnnWURcEVim2GoAYOu2s6SnRH7dSauUlHeYrR.C_OiDd4lPIDOX1g
 Hu9LQlf4QLo5HwwrGVcWmpjkihk1f.A_cozg3VHHK7DETKas_UUDBOPHJk0YUCwYWeqIILZDIDQJ
 gwmVn6YWbBcfnQ5.v0VphrZZj3gwmkuHcYxNEaMXHjQatpX4XajkWgFupng.YsNdzQuwZLMt834S
 jQa67HuPckVQdENEku.veZuSauEGTLa9dQXjlBTySNROS3XGcLsjOP.3uOo.vs1klGEBhAO9HMtT
 RirVTC9gcwqietpZdSZXj7YLLfd_S2fqAhAwTxsrGa1uYFLIpNhX4VheAAWwkerFQCMt0SpPXKvx
 UF.SemH2ckuPU_MJG7Ry4L0iGP2glIpFNVllueNXRN80LN2AC45Lfp5tIIhj62WspB.OJbEultY2
 XUSZmjmS6cK_ZpzARmQ7jfAPPZsCe0qrmO7aw_1uBm8ybM9VWomg4aw49OiEYYVfE_.3RVtY.4_j
 26FkO0.cWoAhsqwGAOHice90bHnn62qIf.zpED1dODCcqsxmoRs923_q_1iHSg72Yuf_vxeeqlGF
 V4fUXqIj7Rls4Tq5oX7nk92_TXcChhqilHGoWsTHmgTDVaWBJQUY3lCDZL7FnBHNvZWQPADz4V3m
 pqAEEyOSzqDKNElDJoldpIkVfrTER3WZZu8lNfcLMw0kYH98i3ierzxVJ7QtVWb7qRPrvnALD102
 ODGWgbuP6WAKnlo3r5aY2Y2DfO8jgk3TvQlejtVbZzBh.FHVRReKnmE_9KlUfgiHrwZ5e9xaTD1d
 o6CalHvB.NWyqymjwHTk9isSs6vXPyXo4vajfu_fkQBbzuhH1tkVriePGeRAScYymZEtfle98Ycb
 kyAtawfTPGBqcAU7XHyTPl_4R7L8UwrYyc1Uvgs5d_fFgaN0w1bSsFW1WEBwQ1MUz4Juip_fgJ9I
 xTWue4zZr_5DKSt653s0rUWxfi6Ot5RIiWpMWDraCKzkXVL7ZTBH9DzBDqFhhYpjFiFgjYPJ9R1.
 QFJin75efTp8hGI_WL3zZ6e3waDMCOX0xlXHsGvV7CXdYHNCWiZmhv9GzVqziHNAcCsd_RwYftHV
 3m7prD5C4._zV8vYp_TmfN0hIaK1FmbRK3SJmpzh2BNUIuLCVIdm9H3VJJpJ812qUwYIlwuQctuZ
 R2MyDIozwBw5y2x2qo6jU0hl.c.SeR5y.9dhf0r5FP9r6oHwXhHnF1jgVycq5up4Fg93xpF4NHDX
 0f8UepgoaK.Fip9VFpDPknum6e2WCkB2le1dhaTHMZ4bx7J3NWEtrJtBDh5qUvFSF2lXLfel3q.Q
 gVMbiETlhIB2x_jNBWFZ1.Z0pQ6g0PZkCP4ck4DfdW5wNtpTN3uDNuG4QtgnL4sbxF5w0N0rp0wk
 rjgIf58aK6b9qCYFDFhXkgQsDbJgg3UjY2edgeeIM6jFWwz2IpNLufCEVtYn8sksyDaraMFOFfSZ
 _oY9GcLi1s2VjRBKHm9xLDIrlJm8X0Ty3HfMA2OrUa9YhTxc0ydGRLCpfJ_og6HwYJHoaW.a2lGd
 B_yUbGzXpOuI6JnsfaY_vuXLZHSdz73cnJM1U1D4QK_cF.sOTw7B.fs4qgyicmOek4y52wgwzz3t
 WKNn6ynQDwcVC1UpKp7DnB7MYoXe82UhIiJgsmcmJlpniseKYsUrjFA1eCErpaHq4yiJgL0ajTAm
 gzy0dJtofK_h5ydgNgh9W8C9MIzUl12wUHEMM6b.uUjpd1_7thDxKRsiFwWo41CpA1RSBBLM.xs.
 M6PAWhB39I372Nb1KGJU.F_.qL_v5Ea2FymHCQZK.XXRV.vmVAtBaZzEZnlegWRCwBOaJlrxBbbw
 .DzaY4.tdRjNqqE42CRnWNJ0GrLBVWR42wd.EADSwJc3UurLm7biyTOijuqIWDeDFsO5ciMYbf_L
 Alit9eN1.oqSsZ7kObpIfaxkZgvuYaiI9PB6F5ZKMopX5l5akklCx671LcP3nkzxp3vbUxPy1_L2
 viv5TdqS6raTv3CKmZq4D4KopShkKq9UxxURl0U19LsHIozdoawEO7HOdxa6bCQ4UaW2PmpTLqmj
 a9RhApM08mYKVY6nwCRxkSaDJ5OVcHWWTs9OlJIODF_Enlipbjxz3C.OIrGpoIum_dyJM2FE0YZa
 BxlgryeKlVwF34e_r3tu5ymK4pvtJ0lYLOgplDVjNwPYMvdpe0tJ5RRdLwLjqnchyAEgJdkozTxR
 bFCKrTtTB43Rzlt3Q8BgPhRH8viGGwML_I96NPQWmo9RShF13p5xwmMJl76hBw0BXtEvUq1dcPVJ
 qUrO5JB2SDbHoqnJn1ZuLSPc77LQkKaQUU1Jx3.P1TdQX0Fdv0X1L.Hu1sLj53tSEJmQ6qslyXrd
 5Y0NxmwbcltNvi8JDBreuEHWnNV.NVEE8xW3H69ofpnY.aNArlaZKUquR0W7r67KWrPzMiSj_vuN
 _elzMFXjHF9AXqT29hWcmNtXe.oBX8.zSOW_VVv.HZmG5RkuhpzU2RooDyWh_i8n.UmiRx4HDs27
 t6eQ8qCm0Due.__sHs_jm3KMGfForfr03mPbPSnFFQ5yvopKuDibQyGPeY4fF2UNruzTu3KPjscK
 nFgnGWUXqiRweyepYYX8oi4JK_j53nIpQ2jPzXxOZM.GLRta_fT35JFpFq.l.DV5qY.pXhw5w5LR
 A8VUtpOQTUTbg2vL5_rNFsvp46mIJZ46ng6oEP2fIEJHeBYLiHik4uSPxWoMK36lxYaPAxl.pYUi
 uIDgLAnUdsvXfPm7.wGdWKxm8Lkn6xuE429WTlBApouiyIR7GvKtPEdQXFn4FgwtqauHxghr_ZZt
 zrV7UDJpdnVQv
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.ne1.yahoo.com with HTTP; Tue, 9 Mar 2021 14:59:30 +0000
Received: by kubenode537.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 50a94297dbc8b7791b347ff51d23fc22;
          Tue, 09 Mar 2021 14:59:27 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        linux-integrity@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: [PATCH v25 15/25] LSM: Ensure the correct LSM context releaser
Date:   Tue,  9 Mar 2021 06:42:33 -0800
Message-Id: <20210309144243.12519-16-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210309144243.12519-1-casey@schaufler-ca.com>
References: <20210309144243.12519-1-casey@schaufler-ca.com>
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
index 1a15e9e19e22..f74a72867ec9 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2448,6 +2448,7 @@ static void binder_transaction(struct binder_proc *proc,
 	int t_debug_id = atomic_inc_return(&binder_last_id);
 	char *secctx = NULL;
 	u32 secctx_sz = 0;
+	struct lsmcontext scaff; /* scaffolding */
 
 	e = binder_transaction_log_add(&binder_transaction_log);
 	e->debug_id = t_debug_id;
@@ -2750,7 +2751,8 @@ static void binder_transaction(struct binder_proc *proc,
 			t->security_ctx = 0;
 			WARN_ON(1);
 		}
-		security_release_secctx(secctx, secctx_sz);
+		lsmcontext_init(&scaff, secctx, secctx_sz, 0);
+		security_release_secctx(&scaff);
 		secctx = NULL;
 	}
 	t->buffer->debug_id = t->debug_id;
@@ -3084,8 +3086,10 @@ static void binder_transaction(struct binder_proc *proc,
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
index 02f59bcb4f27..27b1bbe5ab08 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -1349,12 +1349,16 @@ int ceph_security_init_secctx(struct dentry *dentry, umode_t mode,
 
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
index 74bc5120013d..503ee773f571 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -135,8 +135,12 @@ nfs4_label_init_security(struct inode *dir, struct dentry *dentry,
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
index eaaa1605b5b5..afccc4f257d0 100644
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
index 175c8032b636..554e9da831b6 100644
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
@@ -547,7 +578,7 @@ int security_ismaclabel(const char *name);
 int security_secid_to_secctx(struct lsmblob *blob, char **secdata, u32 *seclen);
 int security_secctx_to_secid(const char *secdata, u32 seclen,
 			     struct lsmblob *blob);
-void security_release_secctx(char *secdata, u32 seclen);
+void security_release_secctx(struct lsmcontext *cp);
 void security_inode_invalidate_secctx(struct inode *inode);
 int security_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen);
 int security_inode_setsecctx(struct dentry *dentry, void *ctx, u32 ctxlen);
@@ -1395,7 +1426,7 @@ static inline int security_secctx_to_secid(const char *secdata,
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
index c06133104695..bfb4696503b7 100644
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
 
 	security_task_getsecid(current, &blob);
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
index 768989b2f09e..caa69696672e 100644
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
@@ -1410,6 +1414,7 @@ static void audit_log_name(struct audit_context *context, struct audit_names *n,
 		char *ctx = NULL;
 		u32 len;
 		struct lsmblob blob;
+		struct lsmcontext lsmcxt;
 
 		lsmblob_init(&blob, n->osid);
 		if (security_secid_to_secctx(&blob, &ctx, &len)) {
@@ -1418,7 +1423,8 @@ static void audit_log_name(struct audit_context *context, struct audit_names *n,
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
index cc2826cdba8e..6edb78c9cc87 100644
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
index ef1394f7fcf9..5ee033a1f885 100644
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
index 1956b0312ec7..08ca87fa97b7 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -398,6 +398,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	enum ip_conntrack_info ctinfo;
 	struct nfnl_ct_hook *nfnl_ct;
 	bool csum_verify;
+	struct lsmcontext scaff; /* scaffolding */
 	char *secdata = NULL;
 	u32 seclen = 0;
 
@@ -630,8 +631,10 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
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
@@ -639,8 +642,10 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
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
index 93240432427f..32b6eea7ba0c 100644
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
index df51140a4d93..f1c1b387bc63 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2301,16 +2301,17 @@ int security_secctx_to_secid(const char *secdata, u32 seclen,
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

