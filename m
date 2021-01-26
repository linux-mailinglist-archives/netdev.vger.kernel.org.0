Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2445304D05
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 00:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731485AbhAZXBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:01:08 -0500
Received: from sonic307-15.consmr.mail.ne1.yahoo.com ([66.163.190.38]:43949
        "EHLO sonic307-15.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387535AbhAZRLd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 12:11:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1611681045; bh=QikK5FDa9ha7K4Pey08ED+rnanltyysxQB2wrUvqcV0=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=GjMtAVKB02q4nFFSnOmhdjYMGe5lqIPzwYojSlfYjSDTiu0fK2XKrgS+TtGtTaYibV4WGXfTzeo7BreyDtW+V3EUU/0aFkGrKzdVwEgJuJByQ17ey8K27pSpoOGNHRii0C/DnkAAMhw15j13ZeX6TR8bCedN4FlVkI6AU8xQXl2G2MG8jZVzonDAHAyEtqnBuOsr5BT/THIq3qbvy0tINV58AHNpEtxSbOukGzS00ZpcPKPm0weokbkX4WcgTJxOhUtkW4yhYQ59HrXx3Jb4heIpa0AbhVuz6poWajjCrGqNhQyT+9P5wijPZ64LuwtZ7UIfzgdfEDRCmsgYXNvMcQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1611681045; bh=mIeYpe96uog47inFM7rOo54QLnt+oY2W1sj/Wv254jU=; h=From:To:Subject:Date:From:Subject:Reply-To; b=Wixw6+xm6rANZ4IQpghncoAnWrXukdcYiHRzzkLsmQW9IsOuB7McGluBn4EaTFytwr3Zlt7lut3bQge2soc+p9AsgYiyMxn5GRuuBuypHnfbCtSVDcP7wvkQXYrfG/GtbIN/g8CxxC/uKYoNssmNNmza/kJHOCrcunaURLpwZQAj5FBLXwj2LWy1gXETMxYnzKWGAPXWq8JyuwpCjS1JVTFKHCT/E4BFhT4g1Bq/4gLOM9rCk4KxciPW0Xt3hHbj31pKdydpDKK8ZgCjRNcRD69F1sJueU8G3ElMr6gA39DsRiKmj239QCOP4iC3okeGY+/rFcUWEpAa4+GaCuy4aQ==
X-YMail-OSG: JjBztuwVM1mkQQIU0PiQJj9zaECOXd_1WsXXmVMEfcFeyjY3Ng2tXACP78ghX68
 TA9SkZxeoy00TL5kWE9LvdjvK5AAa41ur2EO3QkiQR3qERCiJiiDg2B2LaM4VjFwpC3Gt3td8jKd
 7oHWof7EApS93MNptVu8pUjoB4_lLeiEU_sCsVDdmG0SBHlD7XS2T5sg_iJBmaezqav_QDuCHf9L
 AbFnts4I0g1hpf7VssE9gmO.N6UAqvB5DkBuprI2NY2.fQ3rv0bSHsi9SyjOsed1oDV.Dw9l7tTI
 ZzlGye64Jzqj9IM118SFgpjlZ84ATT._ZOFx.gPspukzga96MbeuG6aTUAb0WrwMkJRKe.UV52fH
 LAGTbcHzWkpYa4SLtpe3m4_h0QWtBtJGYT_09yIlWfs6kdQ395opJdXzBBUivvOtMe73Pyfo3vUE
 lC.69rEEvBotuz.nonLRet2vOw1NIWe_VEhnHeZqxZRIzYuJcNtwMm63rJtctiroRHda2axAMxa_
 FDTPokwgI3KacSe8US0NhP3J6w8PQe22Dmuw3gt0BlFchtwW3KWAWCAhvy8gQVgz4AMsmM1BE8Y5
 04DVNDNuXvL.2kMgI0tID6W30Z8KtNOaCj.OITWu9hapWFLmFEvWTIkCRTE94RJCj9bpDASVEgrK
 4OM5GEAnw6HCsWDn53vfWxNAtdFZni2fYTF155a5plCXj.odTbTLGwJttxDwa4.Gce1rZfWkntoo
 nSLuZLz_DGVlVbTVHdycxQy2IlrcXZnLq6ujMDDrharPdrZs4cM_fO_qA2nhUxb4TYUQ5kczbGiM
 8l6VONuOv9gcQTcf8gEQHAT0279Rv0YGHEUNjPfbCpOh5VzqhPpICOplPcKJkohfoiSCriIB.CA0
 kguPvaKZBYeBblz6ZopGOppZ6u36xeFyvwhT8YxCuM2ay.21xIaRQkkqugdrzwyy8Ft2olPxFWSM
 NAI4gOvHMSMG2R6sHs5fVbq2PeMEEIgBIc9Izick2hURvJwqisdTuHmvtdWQOibqTyTay9moxzIe
 Onz1cnn_fqn7ej7WbXeQfbNCo2cu7QSwrc_bS.rDkbTEmqBsflthaM.31x7CoquDM1qCuY0nttCx
 VJHHNjIn_yuqTz6KaeCchxwe0u6REi_uhSU0rgf.NBhr8F6pCr1hHOClJBM35MmiGVBN5phGHwVt
 7QmYbHG54ydN7wwPHi2Mdg0y7Kut3.byXSl7C8TH1BbHAB42zvAd3_TUhys3mapc_IHfFEudxBL4
 qsEnbLZIpoP3DSVluEWZJu6MOgFIO0dFTiZzJaU7HyyeB09YRhhR6ccSzCN8saiDqw1R9pP623dl
 zZFpyT6tNjrqZYfct2qxt.0v0dsqpasZpNfPx5_rWCk6jJodj4flgDax5698HaOnWmDDaXlUTq6L
 Z5oSWaHFsCN_SniICXZOJTw30WVS1zJHDrpQY2OQMH8hl_Et3f2bzNWv1vDtRSieRwiK7v0jl1fp
 lo31d_L6.atm3.epkqWR4wPAp.H7AhFCiBSu_u6P.wFFu5DGkWRCjehAzLtrG9pNxM8A23.Mi9jV
 gA8DTq_SdBGgtcqYjbWNe3WMlKpNoe9m6eS9i867VD1w6xFJdOGoMyGjVLBoSr4EMHt1uB.vbqLH
 nWgUT8FY68g2TFRezmB0h2mcr67jtgjKPEpnh_UWDJwk8lxOV50x1ZUB3voIalwoEsrJCGj9nj6.
 mYae4DUGF.pTqs0aXM22b_zGm1NcDrjOv0y3CtEKbqtL1P4Isr5quWy91dJwTIY5mkPlAzFdTx2w
 zeFQ0cUtEKvvIVE1Qj7YXCrA2UsJDU2oXPoLRPQM67TnI6ser4F3M_zqdS7_Hg8dlpB42P45AE7C
 Xaou.41LIcILE7dXyNEmqox3C.577Q_aCmM_7Xno7toB1fPVPBLG.RwBUz8vvHmGfEYN7PyAO.Ap
 J4EoEfsVGH1ijlT0I0U21AWRPVwWl_5OHqV5kWZKgtgLnI8EX4lRgze079dHaRvmS8.UTzkuToaG
 .tnI1_bYQzCv76HNmykZeLhA.zC1EDB1SIgB92m_DIaK8B1Gvmda7QfCQkhXUPnArghyakEtLsmX
 AmqSZ2sFy5XpnPy5ANPXvvg1XiFT4eo6y9OX.fUiAZ19J2BZAThUf7Pli1PUMnqZBAjUliRKXhjT
 p.LBRnpbLLiwVgcMxF5j.xIGnHMMxXamJw86nGbBBtOn97Lv7k05qa7SbvderagDbFVvzN6HdTmc
 82DBWETMh6V09JeqhwnGTOML1d8EUpgcLpPzqlv3AxFZloTjjHG4Dcnhe5WIhI5gXcFVXX66QwTB
 fq5XatYgM6pgjj4PRmzkXgq2PPBNLvh7orcU3.DPEvmhTE91rzQG3ayEsLoBKwS6VjPceIYw79xY
 UJpDozxwLTvYsPscRmSpgsVWUkT7jifRUySdABP4TUdngnYJrN3g2zcPGhsg12o7AvyGk6pY1km4
 dB2wSi6mgrkKLgS6qyUAxJR0C31V5sSZhZPiF9O56elauLqMr2qvsnlBwn3rh2RBnwN2S0HF49jn
 NQe4G8DhDAV0W0W0zNcwa_iL4EFXRbIX8BdsGXmgAIzKWmOfHeC.8bHOOXpKirQG5k1VH_26n6JN
 7LrCiqhL.rWYiNwmqAeiaT8Io51XslAZ13GArhSlEc9WnL4emay8QsPwx09vIHDrkU.yPAzzrzKo
 jfbSSX9NFwWBzUs1rTSSQPtF.tuk_Dex1qGaSx0H_LnjfsEWylqUE9bYmmkuED_WgVul0SQxtG3D
 eONd8ZZDP8AqdejMDz4199wJhJDpBZ4oQVcBQoGe66ucRDwL30UJJzqH9plP8BAwtkEQmBxIhGe2
 51yNOTEXlmSxv11gCuA98zdS7Ra8dJUWgLHTDy.EzCAp4Q8IMqn27GK_hwQrsWDhEcI_mUZbXHfv
 jU3Ezg2DrRAmhcgd2fUhn_p3loprVCQzkh86_cPBNUeTWG0R2P8uQwXuAG52ktYgEZgOsVisUB.l
 Jcb2vSfB4pjSB6jojqJ8md_AhtDaDSQgB9UMISZLrMZx8B0wH_mClysEOWQdR.WMOWArGmEgp7BQ
 tMqAvyW30K5.mOhSucatRS__JXCfpcJOzlhkHDpH27feNWhTozvBW.4j0_cDuK1R9kYBBz4L2j.8
 nPdCOtQU4L6TSJdDjpyrj7w3TtI_tuJexjsjHe9RpAlzncpCREmRold7FdpKMHh_9p3SO6pBgAHx
 YtX8aGSNEq678OFruSxfQhIoC3cWZgFOfRLsuoXy7HpMGyL0Kgz0kZMfDRjJ9w4CosyDWEDso4cx
 csQgHGQ3El0EcnvidP84jJuojFpbn1yTFah42p5jVbIcBbGgmXPkHIbpjJhbml.O3Kpa_gbXIIwx
 370N1KHUz9YsL4_kDg0H6TOs8OxmKbLQKK_0-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic307.consmr.mail.ne1.yahoo.com with HTTP; Tue, 26 Jan 2021 17:10:45 +0000
Received: by smtp405.mail.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 14a20754c00469ce98c71e55bb16a4d7;
          Tue, 26 Jan 2021 16:57:57 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        linux-integrity@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: [PATCH v24 15/25] LSM: Ensure the correct LSM context releaser
Date:   Tue, 26 Jan 2021 08:40:58 -0800
Message-Id: <20210126164108.1958-16-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210126164108.1958-1-casey@schaufler-ca.com>
References: <20210126164108.1958-1-casey@schaufler-ca.com>
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
index 24997982de01..cc4f911f0d74 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -1348,12 +1348,16 @@ int ceph_security_init_secctx(struct dentry *dentry, umode_t mode,
 
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
index 0ce04e0e5d82..d3c29eb2e9dd 100644
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
index 45ee6b12ce5b..43698f15a52b 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2834,6 +2834,7 @@ nfsd4_encode_fattr(struct xdr_stream *xdr, struct svc_fh *fhp,
 	int err;
 	struct nfs4_acl *acl = NULL;
 #ifdef CONFIG_NFSD_V4_SECURITY_LABEL
+	struct lsmcontext scaff; /* scaffolding */
 	void *context = NULL;
 	int contextlen;
 #endif
@@ -3335,8 +3336,10 @@ nfsd4_encode_fattr(struct xdr_stream *xdr, struct svc_fh *fhp,
 
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
index e4a4816f1b94..cfa19eb9533b 100644
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
@@ -536,7 +567,7 @@ int security_ismaclabel(const char *name);
 int security_secid_to_secctx(struct lsmblob *blob, char **secdata, u32 *seclen);
 int security_secctx_to_secid(const char *secdata, u32 seclen,
 			     struct lsmblob *blob);
-void security_release_secctx(char *secdata, u32 seclen);
+void security_release_secctx(struct lsmcontext *cp);
 void security_inode_invalidate_secctx(struct inode *inode);
 int security_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen);
 int security_inode_setsecctx(struct dentry *dentry, void *ctx, u32 ctxlen);
@@ -1371,7 +1402,7 @@ static inline int security_secctx_to_secid(const char *secdata,
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
index f6af7b27a6fa..902962ea9be6 100644
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
index c766502b58f2..a73253515bc9 100644
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
index d4902d120799..3b9cf2a1fed7 100644
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
index 517623ba81dc..904ae6c46be0 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2288,16 +2288,17 @@ int security_secctx_to_secid(const char *secdata, u32 seclen,
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
2.25.4

