Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E19F2194FA
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 02:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgGIAXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 20:23:23 -0400
Received: from sonic310-23.consmr.mail.bf2.yahoo.com ([74.6.135.197]:34290
        "EHLO sonic310-23.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726100AbgGIAXW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 20:23:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1594254200; bh=IcY1GZrj8dXmE9jxDzlH4d880IYHgHVH/i0rZhm7r4s=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject; b=WlEE5sOHzULmlPPzbl7Ual25sv6cQ0DD5g3ZhH5xxROKADljzts9LUy+54ia48+U+LdhqE1LIGzDBF/Hkha3XhoMCZxUwdW1TldgyGKjHKHcpSdP+XhlpH9D9P67vnwB4Su8a2JKsr+myZhB/t366/UKP2X6qFVXCBFnVFEiq1ROnIwImRmxDHvpg18KEroT/tho6UBKh7uanj1NH61HNhzehVu/0d7Kx8X4RzdqmDr326a3bzk+mt+f2WZfdQFl6T5gBx5Esi2+xHHA3Xo1mvDFtjFjTkYC54kSTgFUkakvMr13sTSflwkt/g+syAfWV4I0voaAR7Q6XpGm/NPENw==
X-YMail-OSG: pQDz5bUVM1miAyK8_a9HukZeTO18ksA1UrJIHcdwJFeovjU5qa5c_6QB5NEJhb1
 OiwCpsQFV8rBO3h1tUX6tP_a4hxf8t0lUKPRTwGu_h9fSuw3GvwcAQsSCUW_9lNWKOF4xwEjE9pN
 S5ZGJFYyFiadXAhxkkorS1hCOG9Fkq.AwlTF_Zir6bqC7mO5OTKmcXdWL9niYMJsKgwnm6FURfBM
 65CxtXs7gYavTpQor6cu6HtqleDeS4WwtoKmFVBEmsHhcZR9yTFNyhAl_RlcW2JBfukqwENZsgnP
 9szJixz7js503_lx2UaiVyklpj5rj2vY1moZuLAU1XDCgnFjBkYp9QfD0v0Wfn2a0Hm80vn0LpbF
 XvsIDZMXxQbcO9DN.OohMgFexAbp6FwBdRgCOa2Pnn3WPmBG63mp.p3OhMvTW52R1CluskayvSvO
 qaZu_VHUxyRnp7VjL5IiMIDOoQllY7_vmqRMzdVW20Yz4NDwR3Hi9g4TLCsMLfB_7g8ctLoEgzB4
 Ad_uEX6Q3CjjbKEs6b.vmNLAnxMFAMxn..4GnndwQS12ctXfHwz5KyOteHQyDgMuZJnCuB1866g2
 .J069vkw8B_GGAVJr09Y3pvMfMQuel5kE2criP9YoNQxRqwyB66ArnG2vF2FRFDETJB3rsxCxqbe
 tbgta87cPhfTQ1GeLXvGDv1ebM12XqnmxTdhPgDjdB6jtDuE0YjiQ4ALp9C9vLDqJnflxTIa_5gY
 MtcoofUx1dJlSdH_z40WyUUCMj.TPN0knLzgIzIx8KN2jL6f7Eyf3q7HpI9Xw1I8wgakK0lUZM0h
 XbKhVSew4lHS9f_h1bwE1XMRSIGUEFPIMbrXYdoX9MCu9635PI_kFzNFWfXk.VJY.7ujksqpZQ4w
 vV6VmT6BlhX5aOFAwei3EhsE1gw7dafkouyAWO0pE0DI0y4HboViB2vnhGEy6ZHEc4kU.Q6ZiiP_
 t43glOjaeS5MhWHdcsO44QHQba9wo3.QTpUipQE2As9Y_sV63ECZbZgG3llrtKxy_t3DxzMN5Icc
 qjiIUuVjdJHGYh05OOJELkdq5ImCC7y0iEB5RjhDGJ4C3NterbPfb7ZSHc2gnJXTVkcUMB2vBJE4
 w98OPNZaUuT6AAORUOZjYy18YwNzH_xGD3xkmRv40fFEkntZhvB.IehIbmSMSru07.My.LT53Ua5
 P524og5GcZyfDatf21u93VLj81B4I5cmxf0B__HJPpiCXiSxTFHA36pPF72qUIN1wvK0zZtZTW31
 KJNzIO69nRcfo0dr_r8jt1jGDSJAyCTUliOlzR82G0ZPPA4Mjj4NQtwiTlxiQqbybunwM.xMuWdP
 NtYuQ9WrFWM_uRrfegy7WY2myeSf5szqKoLDgaqNcid9Rf2oFcwhDrbd.4.18YnJULU5Y0dajRZL
 iLFUHEPfcyBjeHsT1BMaY1lIQEcoR61givEw-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic310.consmr.mail.bf2.yahoo.com with HTTP; Thu, 9 Jul 2020 00:23:20 +0000
Received: by smtp430.mail.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID e57ba9110eaa8ca059ae1f65970724d9;
          Thu, 09 Jul 2020 00:23:18 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, keescook@chromium.org,
        john.johansen@canonical.com, penguin-kernel@i-love.sakura.ne.jp,
        paul@paul-moore.com, sds@tycho.nsa.gov, netdev@vger.kernel.org
Subject: [PATCH v18 05/23] net: Prepare UDS for security module stacking
Date:   Wed,  8 Jul 2020 17:12:16 -0700
Message-Id: <20200709001234.9719-6-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200709001234.9719-1-casey@schaufler-ca.com>
References: <20200709001234.9719-1-casey@schaufler-ca.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the data used in UDS SO_PEERSEC processing from a
secid to a more general struct lsmblob. Update the
security_socket_getpeersec_dgram() interface to use the
lsmblob. There is a small amount of scaffolding code
that will come out when the security_secid_to_secctx()
code is brought in line with the lsmblob.

The secid field of the unix_skb_parms structure has been
replaced with a pointer to an lsmblob structure, and the
lsmblob is allocated as needed. This is similar to how the
list of passed files is managed. While an lsmblob structure
will fit in the available space today, there is no guarantee
that the addition of other data to the unix_skb_parms or
support for additional security modules wouldn't exceed what
is available.

Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Cc: netdev@vger.kernel.org
---
 include/linux/security.h |  7 +++++--
 include/net/af_unix.h    |  2 +-
 include/net/scm.h        |  8 +++++---
 net/ipv4/ip_sockglue.c   |  8 +++++---
 net/unix/af_unix.c       | 12 +++++++++---
 net/unix/scm.c           |  6 ++++++
 security/security.c      | 18 +++++++++++++++---
 7 files changed, 46 insertions(+), 15 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index 6d403a522918..d81e8886d799 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1397,7 +1397,8 @@ int security_socket_shutdown(struct socket *sock, int how);
 int security_sock_rcv_skb(struct sock *sk, struct sk_buff *skb);
 int security_socket_getpeersec_stream(struct socket *sock, char __user *optval,
 				      int __user *optlen, unsigned len);
-int security_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *skb, u32 *secid);
+int security_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *skb,
+				     struct lsmblob *blob);
 int security_sk_alloc(struct sock *sk, int family, gfp_t priority);
 void security_sk_free(struct sock *sk);
 void security_sk_clone(const struct sock *sk, struct sock *newsk);
@@ -1535,7 +1536,9 @@ static inline int security_socket_getpeersec_stream(struct socket *sock, char __
 	return -ENOPROTOOPT;
 }
 
-static inline int security_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *skb, u32 *secid)
+static inline int security_socket_getpeersec_dgram(struct socket *sock,
+						   struct sk_buff *skb,
+						   struct lsmblob *blob)
 {
 	return -ENOPROTOOPT;
 }
diff --git a/include/net/af_unix.h b/include/net/af_unix.h
index f42fdddecd41..e99c84677e14 100644
--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -36,7 +36,7 @@ struct unix_skb_parms {
 	kgid_t			gid;
 	struct scm_fp_list	*fp;		/* Passed files		*/
 #ifdef CONFIG_SECURITY_NETWORK
-	u32			secid;		/* Security ID		*/
+	struct lsmblob		*lsmdata;	/* Security LSM data	*/
 #endif
 	u32			consumed;
 } __randomize_layout;
diff --git a/include/net/scm.h b/include/net/scm.h
index 1ce365f4c256..e2e71c4bf9d0 100644
--- a/include/net/scm.h
+++ b/include/net/scm.h
@@ -33,7 +33,7 @@ struct scm_cookie {
 	struct scm_fp_list	*fp;		/* Passed files		*/
 	struct scm_creds	creds;		/* Skb credentials	*/
 #ifdef CONFIG_SECURITY_NETWORK
-	u32			secid;		/* Passed security ID 	*/
+	struct lsmblob		lsmblob;	/* Passed LSM data	*/
 #endif
 };
 
@@ -46,7 +46,7 @@ struct scm_fp_list *scm_fp_dup(struct scm_fp_list *fpl);
 #ifdef CONFIG_SECURITY_NETWORK
 static __inline__ void unix_get_peersec_dgram(struct socket *sock, struct scm_cookie *scm)
 {
-	security_socket_getpeersec_dgram(sock, NULL, &scm->secid);
+	security_socket_getpeersec_dgram(sock, NULL, &scm->lsmblob);
 }
 #else
 static __inline__ void unix_get_peersec_dgram(struct socket *sock, struct scm_cookie *scm)
@@ -97,7 +97,9 @@ static inline void scm_passec(struct socket *sock, struct msghdr *msg, struct sc
 	int err;
 
 	if (test_bit(SOCK_PASSSEC, &sock->flags)) {
-		err = security_secid_to_secctx(scm->secid, &secdata, &seclen);
+		/* Scaffolding - it has to be element 0 for now */
+		err = security_secid_to_secctx(scm->lsmblob.secid[0],
+					       &secdata, &seclen);
 
 		if (!err) {
 			put_cmsg(msg, SOL_SOCKET, SCM_SECURITY, seclen, secdata);
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index 84ec3703c909..3ea1103b4c29 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -130,15 +130,17 @@ static void ip_cmsg_recv_checksum(struct msghdr *msg, struct sk_buff *skb,
 
 static void ip_cmsg_recv_security(struct msghdr *msg, struct sk_buff *skb)
 {
+	struct lsmblob lb;
 	char *secdata;
-	u32 seclen, secid;
+	u32 seclen;
 	int err;
 
-	err = security_socket_getpeersec_dgram(NULL, skb, &secid);
+	err = security_socket_getpeersec_dgram(NULL, skb, &lb);
 	if (err)
 		return;
 
-	err = security_secid_to_secctx(secid, &secdata, &seclen);
+	/* Scaffolding - it has to be element 0 */
+	err = security_secid_to_secctx(lb.secid[0], &secdata, &seclen);
 	if (err)
 		return;
 
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 3385a7a0b231..d246aefcf4da 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -138,17 +138,23 @@ static struct hlist_head *unix_sockets_unbound(void *addr)
 #ifdef CONFIG_SECURITY_NETWORK
 static void unix_get_secdata(struct scm_cookie *scm, struct sk_buff *skb)
 {
-	UNIXCB(skb).secid = scm->secid;
+	UNIXCB(skb).lsmdata = kmemdup(&scm->lsmblob, sizeof(scm->lsmblob),
+				      GFP_KERNEL);
 }
 
 static inline void unix_set_secdata(struct scm_cookie *scm, struct sk_buff *skb)
 {
-	scm->secid = UNIXCB(skb).secid;
+	if (likely(UNIXCB(skb).lsmdata))
+		scm->lsmblob = *(UNIXCB(skb).lsmdata);
+	else
+		lsmblob_init(&scm->lsmblob, 0);
 }
 
 static inline bool unix_secdata_eq(struct scm_cookie *scm, struct sk_buff *skb)
 {
-	return (scm->secid == UNIXCB(skb).secid);
+	if (likely(UNIXCB(skb).lsmdata))
+		return lsmblob_equal(&scm->lsmblob, UNIXCB(skb).lsmdata);
+	return false;
 }
 #else
 static inline void unix_get_secdata(struct scm_cookie *scm, struct sk_buff *skb)
diff --git a/net/unix/scm.c b/net/unix/scm.c
index 8c40f2b32392..3094323935a4 100644
--- a/net/unix/scm.c
+++ b/net/unix/scm.c
@@ -142,6 +142,12 @@ void unix_destruct_scm(struct sk_buff *skb)
 	scm.pid  = UNIXCB(skb).pid;
 	if (UNIXCB(skb).fp)
 		unix_detach_fds(&scm, skb);
+#ifdef CONFIG_SECURITY_NETWORK
+	if (UNIXCB(skb).lsmdata) {
+		kfree(UNIXCB(skb).lsmdata);
+		UNIXCB(skb).lsmdata = NULL;
+	}
+#endif
 
 	/* Alas, it calls VFS */
 	/* So fscking what? fput() had been SMP-safe since the last Summer */
diff --git a/security/security.c b/security/security.c
index f54c6dfd9b89..2122ed9df058 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2204,10 +2204,22 @@ int security_socket_getpeersec_stream(struct socket *sock, char __user *optval,
 				optval, optlen, len);
 }
 
-int security_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *skb, u32 *secid)
+int security_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *skb,
+				     struct lsmblob *blob)
 {
-	return call_int_hook(socket_getpeersec_dgram, -ENOPROTOOPT, sock,
-			     skb, secid);
+	struct security_hook_list *hp;
+	int rc = -ENOPROTOOPT;
+
+	hlist_for_each_entry(hp, &security_hook_heads.socket_getpeersec_dgram,
+			     list) {
+		if (WARN_ON(hp->lsmid->slot < 0 || hp->lsmid->slot >= lsm_slot))
+			continue;
+		rc = hp->hook.socket_getpeersec_dgram(sock, skb,
+						&blob->secid[hp->lsmid->slot]);
+		if (rc != 0)
+			break;
+	}
+	return rc;
 }
 EXPORT_SYMBOL(security_socket_getpeersec_dgram);
 
-- 
2.24.1

