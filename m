Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C143102F85
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 23:48:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbfKSWs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 17:48:29 -0500
Received: from sonic306-28.consmr.mail.ne1.yahoo.com ([66.163.189.90]:45886
        "EHLO sonic306-28.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727329AbfKSWs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 17:48:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1574203704; bh=xoM89yPX0lmllKNbzJ/Q/tL4KuocEab57fB3n0i0OOs=; h=From:To:Subject:Date:In-Reply-To:References:From:Subject; b=jvvKdEZEfhKwQpLWkoKdEN4+E/nG8qKEs24t7JBjH2dMSBD+hDHyZmaAP3bL5YxEbKQ6ayD+5OewgiEAyMWpmkKpiChfDdlWyDl0+pig5XON2URPqfk4sIjwI32UDlg9qbCkD4+pT/0SdrcBRg/4LLIscYF9Ymvq09NDqik3T6F8doBzATg3RmsV9iK38JqDS6U3WldrtLyvodZ+e6nddpK+GfmTS+iDaH+c+zRu+P+CZ+WILbHLzQwsJz0wtu3JWqnBiGzTr5oLLe92LpTX2C3wBzgLJLLQFuZHozt50WCUVAjGbQLcLl4h+4ad4OQhEKSqOj1XUl5TgyE7JTRywA==
X-YMail-OSG: gdlfgrMVM1map5c0vHLo3guV.pD5jwESmFRdVrUOn80LWVImweqEuWCcGPJGREh
 14AGg5PO3hYlZa73wvr_MqA1.YGEH6NHkNoULDktatWNhI.cB_Z..rhB8OUu.duUofPdjmquJgEG
 slF4oARB3HAMNPbV6SCww.lUhYTEi0IDAHF2sEukW3UFUOEwT4sE3AifXvmn_jo8km._pUxEYX2B
 Rv42VWOQ7hcy.FytnoafT9ppfi9qwa81GMWQo8bOh7aGEzRmp6fjaynh3Vu2dnNma5.kJOowk47V
 7lOyPNmbLbuScyV86XjcM5wr_niGmyG3kQAsAVcOWLLI4BjbeEmHjUPD9CuOh7ir56Ln34y3cqqW
 LsvV1.2lDvm057fF06zwgn02INCAhwmtiSFHnbRePZu8lAmtBQr2pd8cQwYTP3UUDT7.AeAHipGf
 lMLxXZb06Z9hi2ILVKfdJhnFqBZhwYYFu_aLEChp.hAZR9qhGBOsAGVyP53Jg03LCFkmZuTQ5zPe
 od6dkigt3uoeRvGdTDbC3XP1Nobs3ZowxE7gS.5lCf3ay0wBQM7krNYhoP9moUKYQzWpZo8aDGiF
 xZfOmFICSLCrzvn26SQXkxeW1vDLDHKv8PH6r7XvUfZdxSCrQQU0wqhjfv921l1zZcrvF_tCnoGa
 ZnzCGbQPiuTQsCWL8r.nVjv6HcE9NunONRLf8_fseb_FM5c7x6b8cZhTSElwS7pniHrPB8JGXznK
 ONI1xlPAqNXqqueKsxbShF34gIJQbrK83eyFem8iO_jU0aKA9aIkebtLLHEHJ4MQWFhfuMqPKIs8
 SSefPtN2cUoWPKZD0bsMyn9rUY5.d.ZSDfZ1Pl0GNrA9tYsp1Gs_MG7gxH0jSe9qrpnh6CmAAH9g
 SaH_lC1lIBV8u6WDtIvjtuCHG8y1iWOfNU8yYhf5wxplUrHSWJ8Ce5OoWQ0dq3aO2ZnUs1xtA56b
 rxt4TXAegRQVfgfCKaBtBN8hnI5Mjc0Phd1W._hxpA9cwz1AhNdRBIhAm.sOID9_BPQvtXbEVfEd
 h2Ox2Iu4Hl9y8y0Sjgz07Ana9cNraCN9JAyvoYHkXHTGDCayEX96KWlNTAyEQoX75zw0mbT_bGYv
 NU6Xv.p1MRNA7WcaDjzZ4kCtynBXCkjTYavbFxyv0COmzSwzfDYhPg9Lpy1y11bge2WMB7BxvgNW
 eZOOB.VNWakUisRx2VL.EDe24dxVKF185FEvXxiLyjm8e2aYkmhFN1syu6GexzQmg_gW_F4_Yjls
 Z0x7DvmcnrYbmUcXs7tHDGQ4e9yR41FkHWNEmdtlfYM7YfxYAhmVdvJ3IKAkDLpiqgYyS.CvnVG8
 w6ZK_WczgthXixLHRGNmk0h.1oIaLRBNLiit_elXRJ9_10UV_qRMkoftK3m3QTxrcKQcaLEd9Rjs
 frsZSSSX_VvHfnW4NhqN82b73dvVEr8jmVw--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.ne1.yahoo.com with HTTP; Tue, 19 Nov 2019 22:48:24 +0000
Received: by smtp411.mail.ne1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID 939285467b98f231d124ce17b8252f0d;
          Tue, 19 Nov 2019 22:48:21 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     netdev@vger.kernel.org
Subject: [PATCH v11 23/25] NET: Add SO_PEERCONTEXT for multiple LSMs
Date:   Tue, 19 Nov 2019 14:47:14 -0800
Message-Id: <20191119224714.13491-13-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191119224714.13491-1-casey@schaufler-ca.com>
References: <20191119224714.13491-1-casey@schaufler-ca.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The getsockopt SO_PEERSEC provides the LSM based security
information for a single module, but for reasons of backward
compatibility cannot include the information for multiple
modules. A new option SO_PEERCONTEXT is added to report the
security "context" of multiple modules using a "compound" format

        lsm1\0value\0lsm2\0value\0

This is expected to be used by system services, including dbus-daemon.
The exact format of a compound context has been the subject of
considerable debate. This format was suggested by Simon McVittie,
a dbus maintainer with a significant stake in the format being
usable.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
cc: netdev@vger.kernel.org
---
 arch/alpha/include/uapi/asm/socket.h  |   1 +
 arch/mips/include/uapi/asm/socket.h   |   1 +
 arch/parisc/include/uapi/asm/socket.h |   1 +
 arch/sparc/include/uapi/asm/socket.h  |   1 +
 include/linux/lsm_hooks.h             |   9 +-
 include/linux/security.h              |  11 ++-
 include/uapi/asm-generic/socket.h     |   1 +
 kernel/audit.c                        |   4 +-
 net/core/sock.c                       |   7 +-
 net/netlabel/netlabel_unlabeled.c     |   9 +-
 net/netlabel/netlabel_user.c          |   2 +-
 security/apparmor/lsm.c               |  20 ++---
 security/security.c                   | 118 +++++++++++++++++++++++---
 security/selinux/hooks.c              |  20 ++---
 security/smack/smack_lsm.c            |  31 +++----
 15 files changed, 164 insertions(+), 72 deletions(-)

diff --git a/arch/alpha/include/uapi/asm/socket.h b/arch/alpha/include/uapi/asm/socket.h
index de6c4df61082..b26fb34e4226 100644
--- a/arch/alpha/include/uapi/asm/socket.h
+++ b/arch/alpha/include/uapi/asm/socket.h
@@ -123,6 +123,7 @@
 #define SO_SNDTIMEO_NEW         67
 
 #define SO_DETACH_REUSEPORT_BPF 68
+#define SO_PEERCONTEXT          69
 
 #if !defined(__KERNEL__)
 
diff --git a/arch/mips/include/uapi/asm/socket.h b/arch/mips/include/uapi/asm/socket.h
index d0a9ed2ca2d6..10e03507b1ed 100644
--- a/arch/mips/include/uapi/asm/socket.h
+++ b/arch/mips/include/uapi/asm/socket.h
@@ -134,6 +134,7 @@
 #define SO_SNDTIMEO_NEW         67
 
 #define SO_DETACH_REUSEPORT_BPF 68
+#define SO_PEERCONTEXT          69
 
 #if !defined(__KERNEL__)
 
diff --git a/arch/parisc/include/uapi/asm/socket.h b/arch/parisc/include/uapi/asm/socket.h
index 10173c32195e..e11df59a84d1 100644
--- a/arch/parisc/include/uapi/asm/socket.h
+++ b/arch/parisc/include/uapi/asm/socket.h
@@ -115,6 +115,7 @@
 #define SO_SNDTIMEO_NEW         0x4041
 
 #define SO_DETACH_REUSEPORT_BPF 0x4042
+#define SO_PEERCONTEXT          0x4043
 
 #if !defined(__KERNEL__)
 
diff --git a/arch/sparc/include/uapi/asm/socket.h b/arch/sparc/include/uapi/asm/socket.h
index 8029b681fc7c..5b41ef778040 100644
--- a/arch/sparc/include/uapi/asm/socket.h
+++ b/arch/sparc/include/uapi/asm/socket.h
@@ -116,6 +116,7 @@
 #define SO_SNDTIMEO_NEW          0x0045
 
 #define SO_DETACH_REUSEPORT_BPF  0x0047
+#define SO_PEERCONTEXT           0x0048
 
 #if !defined(__KERNEL__)
 
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index b2ec81fcd1e2..6740bc713f12 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -880,8 +880,8 @@
  *	SO_GETPEERSEC.  For tcp sockets this can be meaningful if the
  *	socket is associated with an ipsec SA.
  *	@sock is the local socket.
- *	@optval userspace memory where the security state is to be copied.
- *	@optlen userspace int where the module should copy the actual length
+ *	@optval memory where the security state is to be copied.
+ *	@optlen int where the module should copy the actual length
  *	of the security state.
  *	@len as input is the maximum length to copy to userspace provided
  *	by the caller.
@@ -1724,9 +1724,8 @@ union security_list_options {
 	int (*socket_setsockopt)(struct socket *sock, int level, int optname);
 	int (*socket_shutdown)(struct socket *sock, int how);
 	int (*socket_sock_rcv_skb)(struct sock *sk, struct sk_buff *skb);
-	int (*socket_getpeersec_stream)(struct socket *sock,
-					char __user *optval,
-					int __user *optlen, unsigned len);
+	int (*socket_getpeersec_stream)(struct socket *sock, char **optval,
+					int *optlen, unsigned len);
 	int (*socket_getpeersec_dgram)(struct socket *sock,
 					struct sk_buff *skb, u32 *secid);
 	int (*sk_alloc_security)(struct sock *sk, int family, gfp_t priority);
diff --git a/include/linux/security.h b/include/linux/security.h
index 79f5177a6b52..55bcb4ed8a21 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -179,7 +179,7 @@ struct lsmblob {
 #define LSMBLOB_NEEDED		-2	/* Slot requested on initialization */
 #define LSMBLOB_NOT_NEEDED	-3	/* Slot not requested */
 #define LSMBLOB_DISPLAY		-4	/* Use the "display" slot */
-#define LSMBLOB_FIRST		-5	/* Use the default "display" slot */
+#define LSMBLOB_COMPOUND	-5	/* A compound "display" */
 
 /**
  * lsmblob_init - initialize an lsmblob structure.
@@ -1398,7 +1398,8 @@ int security_socket_setsockopt(struct socket *sock, int level, int optname);
 int security_socket_shutdown(struct socket *sock, int how);
 int security_sock_rcv_skb(struct sock *sk, struct sk_buff *skb);
 int security_socket_getpeersec_stream(struct socket *sock, char __user *optval,
-				      int __user *optlen, unsigned len);
+				      int __user *optlen, unsigned len,
+				      int display);
 int security_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *skb,
 				     struct lsmblob *blob);
 int security_sk_alloc(struct sock *sk, int family, gfp_t priority);
@@ -1532,8 +1533,10 @@ static inline int security_sock_rcv_skb(struct sock *sk,
 	return 0;
 }
 
-static inline int security_socket_getpeersec_stream(struct socket *sock, char __user *optval,
-						    int __user *optlen, unsigned len)
+static inline int security_socket_getpeersec_stream(struct socket *sock,
+						    char __user *optval,
+						    int __user *optlen,
+						    unsigned len, int display)
 {
 	return -ENOPROTOOPT;
 }
diff --git a/include/uapi/asm-generic/socket.h b/include/uapi/asm-generic/socket.h
index 77f7c1638eb1..e3a853d53705 100644
--- a/include/uapi/asm-generic/socket.h
+++ b/include/uapi/asm-generic/socket.h
@@ -118,6 +118,7 @@
 #define SO_SNDTIMEO_NEW         67
 
 #define SO_DETACH_REUSEPORT_BPF 68
+#define SO_PEERCONTEXT          69
 
 #if !defined(__KERNEL__)
 
diff --git a/kernel/audit.c b/kernel/audit.c
index 77e5d54a3e30..f75db95e6a9e 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1424,7 +1424,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		len = 0;
 		if (lsmblob_is_set(&audit_sig_lsm)) {
 			err = security_secid_to_secctx(&audit_sig_lsm,
-						       &context, LSMBLOB_FIRST);
+						       &context, 0);
 			if (err)
 				return err;
 		}
@@ -2099,7 +2099,7 @@ int audit_log_task_context(struct audit_buffer *ab)
 	if (!lsmblob_is_set(&blob))
 		return 0;
 
-	error = security_secid_to_secctx(&blob, &context, LSMBLOB_FIRST);
+	error = security_secid_to_secctx(&blob, &context, 0);
 	if (error) {
 		if (error != -EINVAL)
 			goto error_path;
diff --git a/net/core/sock.c b/net/core/sock.c
index ac78a570e43a..7a1c41a79b0b 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1413,7 +1413,12 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
 		break;
 
 	case SO_PEERSEC:
-		return security_socket_getpeersec_stream(sock, optval, optlen, len);
+		return security_socket_getpeersec_stream(sock, optval, optlen,
+							 len, LSMBLOB_DISPLAY);
+
+	case SO_PEERCONTEXT:
+		return security_socket_getpeersec_stream(sock, optval, optlen,
+							 len, LSMBLOB_COMPOUND);
 
 	case SO_MARK:
 		v.val = sk->sk_mark;
diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index 60a7665de0e3..fefd1f2d26f8 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -436,8 +436,7 @@ int netlbl_unlhsh_add(struct net *net,
 unlhsh_add_return:
 	rcu_read_unlock();
 	if (audit_buf != NULL) {
-		if (security_secid_to_secctx(lsmblob, &context,
-					     LSMBLOB_FIRST) == 0) {
+		if (security_secid_to_secctx(lsmblob, &context, 0) == 0) {
 			audit_log_format(audit_buf, " sec_obj=%s",
 					 context.context);
 			security_release_secctx(&context);
@@ -493,7 +492,7 @@ static int netlbl_unlhsh_remove_addr4(struct net *net,
 			dev_put(dev);
 		if (entry != NULL &&
 		    security_secid_to_secctx(&entry->lsmblob, &context,
-					     LSMBLOB_FIRST) == 0) {
+					     0) == 0) {
 			audit_log_format(audit_buf, " sec_obj=%s",
 					 context.context);
 			security_release_secctx(&context);
@@ -554,7 +553,7 @@ static int netlbl_unlhsh_remove_addr6(struct net *net,
 			dev_put(dev);
 		if (entry != NULL &&
 		    security_secid_to_secctx(&entry->lsmblob, &context,
-					     LSMBLOB_FIRST) == 0) {
+					     0) == 0) {
 			audit_log_format(audit_buf, " sec_obj=%s",
 					 context.context);
 			security_release_secctx(&context);
@@ -1125,7 +1124,7 @@ static int netlbl_unlabel_staticlist_gen(u32 cmd,
 		lsmb = (struct lsmblob *)&addr6->lsmblob;
 	}
 
-	ret_val = security_secid_to_secctx(lsmb, &context, LSMBLOB_FIRST);
+	ret_val = security_secid_to_secctx(lsmb, &context, 0);
 	if (ret_val != 0)
 		goto list_cb_failure;
 	ret_val = nla_put(cb_arg->skb,
diff --git a/net/netlabel/netlabel_user.c b/net/netlabel/netlabel_user.c
index 1941877fd16f..537c0bf25e3c 100644
--- a/net/netlabel/netlabel_user.c
+++ b/net/netlabel/netlabel_user.c
@@ -100,7 +100,7 @@ struct audit_buffer *netlbl_audit_start_common(int type,
 
 	lsmblob_init(&blob, audit_info->secid);
 	if (audit_info->secid != 0 &&
-	    security_secid_to_secctx(&blob, &context, LSMBLOB_FIRST) == 0) {
+	    security_secid_to_secctx(&blob, &context, 0) == 0) {
 		audit_log_format(audit_buf, " subj=%s", context.context);
 		security_release_secctx(&context);
 	}
diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index fefccd559541..b4c964fdc2f9 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -1065,10 +1065,8 @@ static struct aa_label *sk_peer_label(struct sock *sk)
  *
  * Note: for tcp only valid if using ipsec or cipso on lan
  */
-static int apparmor_socket_getpeersec_stream(struct socket *sock,
-					     char __user *optval,
-					     int __user *optlen,
-					     unsigned int len)
+static int apparmor_socket_getpeersec_stream(struct socket *sock, char **optval,
+					     int *optlen, unsigned int len)
 {
 	char *name;
 	int slen, error = 0;
@@ -1088,17 +1086,11 @@ static int apparmor_socket_getpeersec_stream(struct socket *sock,
 	if (slen < 0) {
 		error = -ENOMEM;
 	} else {
-		if (slen > len) {
+		if (slen > len)
 			error = -ERANGE;
-		} else if (copy_to_user(optval, name, slen)) {
-			error = -EFAULT;
-			goto out;
-		}
-		if (put_user(slen, optlen))
-			error = -EFAULT;
-out:
-		kfree(name);
-
+		else
+			*optval = name;
+		*optlen = slen;
 	}
 
 done:
diff --git a/security/security.c b/security/security.c
index 0dce15d74cb5..f1fefa187ef8 100644
--- a/security/security.c
+++ b/security/security.c
@@ -723,6 +723,42 @@ static void __init lsm_early_task(struct task_struct *task)
 		panic("%s: Early task alloc failed.\n", __func__);
 }
 
+/**
+ * append_ctx - append a lsm/context pair to a compound context
+ * @ctx: the existing compound context
+ * @ctxlen: size of the old context, including terminating nul byte
+ * @lsm: new lsm name, nul terminated
+ * @new: new context, possibly nul terminated
+ * @newlen: maximum size of @new
+ *
+ * replace @ctx with a new compound context, appending @newlsm and @new
+ * to @ctx. On exit the new data replaces the old, which is freed.
+ * @ctxlen is set to the new size, which includes a trailing nul byte.
+ *
+ * Returns 0 on success, -ENOMEM if no memory is available.
+ */
+static int append_ctx(char **ctx, int *ctxlen, const char *lsm, char *new,
+		      int newlen)
+{
+	char *final;
+	int llen;
+
+	llen = strlen(lsm) + 1;
+	newlen = strnlen(new, newlen) + 1;
+
+	final = kzalloc(*ctxlen + llen + newlen, GFP_KERNEL);
+	if (final == NULL)
+		return -ENOMEM;
+	if (*ctxlen)
+		memcpy(final, *ctx, *ctxlen);
+	memcpy(final + *ctxlen, lsm, llen);
+	memcpy(final + *ctxlen + llen, new, newlen);
+	kfree(*ctx);
+	*ctx = final;
+	*ctxlen = *ctxlen + llen + newlen;
+	return 0;
+}
+
 /*
  * Hook list operation macros.
  *
@@ -2164,8 +2200,8 @@ int security_setprocattr(const char *lsm, const char *name, void *value,
 	hlist_for_each_entry(hp, &security_hook_heads.setprocattr, list) {
 		if (lsm != NULL && strcmp(lsm, hp->lsmid->lsm))
 			continue;
-		if (lsm == NULL && *display != LSMBLOB_INVALID &&
-		    *display != hp->lsmid->slot)
+		if (lsm == NULL && display != NULL &&
+		    *display != LSMBLOB_INVALID && *display != hp->lsmid->slot)
 			continue;
 		return hp->hook.setprocattr(name, value, size);
 	}
@@ -2196,7 +2232,7 @@ int security_secid_to_secctx(struct lsmblob *blob, struct lsmcontext *cp,
 	 */
 	if (display == LSMBLOB_DISPLAY)
 		display = lsm_task_display(current);
-	else if (display == LSMBLOB_FIRST)
+	else if (display == 0)
 		display = LSMBLOB_INVALID;
 	else if (display < 0) {
 		WARN_ONCE(true,
@@ -2246,6 +2282,15 @@ void security_release_secctx(struct lsmcontext *cp)
 	struct security_hook_list *hp;
 	bool found = false;
 
+	if (cp->slot == LSMBLOB_INVALID)
+		return;
+
+	if (cp->slot == LSMBLOB_COMPOUND) {
+		kfree(cp->context);
+		found = true;
+		goto clear_out;
+	}
+
 	hlist_for_each_entry(hp, &security_hook_heads.release_secctx, list)
 		if (cp->slot == hp->lsmid->slot) {
 			hp->hook.release_secctx(cp->context, cp->len);
@@ -2253,6 +2298,7 @@ void security_release_secctx(struct lsmcontext *cp)
 			break;
 		}
 
+clear_out:
 	memset(cp, 0, sizeof(*cp));
 
 	if (!found)
@@ -2389,17 +2435,67 @@ int security_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
 EXPORT_SYMBOL(security_sock_rcv_skb);
 
 int security_socket_getpeersec_stream(struct socket *sock, char __user *optval,
-				      int __user *optlen, unsigned len)
+				      int __user *optlen, unsigned len,
+				      int display)
 {
-	int display = lsm_task_display(current);
 	struct security_hook_list *hp;
+	char *final = NULL;
+	char *cp;
+	int rc = 0;
+	unsigned finallen = 0;
+	unsigned clen = 0;
 
-	hlist_for_each_entry(hp, &security_hook_heads.socket_getpeersec_stream,
-			     list)
-		if (display == LSMBLOB_INVALID || display == hp->lsmid->slot)
-			return hp->hook.socket_getpeersec_stream(sock, optval,
-								 optlen, len);
-	return -ENOPROTOOPT;
+	switch (display) {
+	case LSMBLOB_DISPLAY:
+		rc = -ENOPROTOOPT;
+		display = lsm_task_display(current);
+		hlist_for_each_entry(hp,
+				&security_hook_heads.socket_getpeersec_stream,
+				list)
+			if (display == LSMBLOB_INVALID ||
+			    display == hp->lsmid->slot) {
+				rc = hp->hook.socket_getpeersec_stream(sock,
+							&final, &finallen, len);
+				break;
+			}
+		break;
+	case LSMBLOB_COMPOUND:
+		/*
+		 * A compound context, in the form [lsm\0value\0]...
+		 */
+		hlist_for_each_entry(hp,
+				&security_hook_heads.socket_getpeersec_stream,
+				list) {
+			rc = hp->hook.socket_getpeersec_stream(sock, &cp, &clen,
+							       len);
+			if (rc == -EINVAL || rc == -ENOPROTOOPT) {
+				rc = 0;
+				continue;
+			}
+			if (rc) {
+				kfree(final);
+				return rc;
+			}
+			rc = append_ctx(&final, &finallen, hp->lsmid->lsm,
+					cp, clen);
+		}
+		if (final == NULL)
+			return -EINVAL;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (finallen > len)
+		rc = -ERANGE;
+	else if (copy_to_user(optval, final, finallen))
+		rc = -EFAULT;
+
+	if (put_user(finallen, optlen))
+		rc = -EFAULT;
+
+	kfree(final);
+	return rc;
 }
 
 int security_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *skb,
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 16348270b98e..ca7b32631636 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -5048,10 +5048,8 @@ static int selinux_socket_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
 	return err;
 }
 
-static int selinux_socket_getpeersec_stream(struct socket *sock,
-					    char __user *optval,
-					    int __user *optlen,
-					    unsigned int len)
+static int selinux_socket_getpeersec_stream(struct socket *sock, char **optval,
+					    int *optlen, unsigned int len)
 {
 	int err = 0;
 	char *scontext;
@@ -5071,18 +5069,12 @@ static int selinux_socket_getpeersec_stream(struct socket *sock,
 	if (err)
 		return err;
 
-	if (scontext_len > len) {
+	if (scontext_len > len)
 		err = -ERANGE;
-		goto out_len;
-	}
-
-	if (copy_to_user(optval, scontext, scontext_len))
-		err = -EFAULT;
+	else
+		*optval = scontext;
 
-out_len:
-	if (put_user(scontext_len, optlen))
-		err = -EFAULT;
-	kfree(scontext);
+	*optlen = scontext_len;
 	return err;
 }
 
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index e23792dae35c..d6983fb67d31 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -3958,28 +3958,29 @@ static int smack_socket_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
  *
  * returns zero on success, an error code otherwise
  */
-static int smack_socket_getpeersec_stream(struct socket *sock,
-					  char __user *optval,
-					  int __user *optlen, unsigned len)
+static int smack_socket_getpeersec_stream(struct socket *sock, char **optval,
+					  int *optlen, unsigned len)
 {
-	struct socket_smack *ssp;
-	char *rcp = "";
-	int slen = 1;
+	struct socket_smack *ssp = smack_sock(sock->sk);
+	char *rcp;
+	int slen;
 	int rc = 0;
 
-	ssp = smack_sock(sock->sk);
-	if (ssp->smk_packet != NULL) {
-		rcp = ssp->smk_packet->smk_known;
-		slen = strlen(rcp) + 1;
+	if (ssp->smk_packet == NULL) {
+		*optlen = 0;
+		return -EINVAL;
 	}
 
+	rcp = ssp->smk_packet->smk_known;
+	slen = strlen(rcp) + 1;
 	if (slen > len)
 		rc = -ERANGE;
-	else if (copy_to_user(optval, rcp, slen) != 0)
-		rc = -EFAULT;
-
-	if (put_user(slen, optlen) != 0)
-		rc = -EFAULT;
+	else {
+		*optval = kstrdup(rcp, GFP_KERNEL);
+		if (*optval == NULL)
+			rc = -ENOMEM;
+	}
+	*optlen = slen;
 
 	return rc;
 }
-- 
2.20.1

