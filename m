Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D292102F7A
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 23:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727233AbfKSWrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 17:47:24 -0500
Received: from sonic313-15.consmr.mail.ne1.yahoo.com ([66.163.185.38]:44734
        "EHLO sonic313-15.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725978AbfKSWrX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 17:47:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1574203643; bh=fQopPU+QHEIhU1rMxngnZt5dLriz8PONEvXZFfDzj2M=; h=From:To:Subject:Date:In-Reply-To:References:From:Subject; b=iA3uj1SNnHCTKNqi6gMv5N5GUFm2PIGyAHJQ/MG5rX3N9Ty8yO/loZZuY71LoW4nLcgGhih2j7qKMdAPHpUI2cikqtwDpXboj1bBli4/lliucj7SRUZL1Y1hfabyKbUcjbAoojp/rxtD6bWUocjDQ/vIi/RIQCb5X9qjBF1mL3GtOLrQd+KeYSGSau5s5hS9WXTtgHi2GVyI+g1IcwJPmSGvJHPw4A2KQRpZGPl8nNDHqwiXSohVJ14f+J3nfXDSS/ZsCb9tmoC7hrnVMr754u4ThGVa06dBNWgetpE9LBbknd8RXZNQgzoowLMoO6S67fxzIn8Q41Xk+GuJFvXyrQ==
X-YMail-OSG: VZjamvUVM1kgZ1Bm6rfM3ph.MIFJpksyA2u7VFgYLWZciFH1efd3p3J9V92YMNt
 7sBWdUARaM6GGdGsEAuQBSZyrT22irGYXE7cT88eqbxUHGuVTvc3hjJf9KwWo6wSrnwDJD9J5Imr
 VYY1A3KfdZPi9YSckqUGfGKZNpFWcDFy9imFRm3u48WoeOcf9u8Q8NAC0y3G2OrSulAK.DRKk1zr
 2LL4L0Ep3QBZNDr2fZqcVA6NNaJmR0dlQb2OYnBpj4WDX2TTR3kR88GF1vibXae2swNiYMXMjII3
 LwoqdKFmqnOdMdc56ryjjupOYIxkFCQ3gXujt.6QITfSY_i0.7LDskgNQiK54NepwKSQyrIajJ2x
 G.062r55ohMBbVF4DsKkaTMlbnQhndFYms6hz3hJnkMpN_55PELGmTODIRXW9F8QeRpzF4Sm4Aqd
 N4PH62ucBbzsXOY4zQocZ8jYtHpDWHrvxSGwiP3d3IbZv7k1PpaDD_fHDwKX5z9QJRAhGOt8Opvf
 _BXAOGtT7DwCZPHuyn6OE757tSa3phlLJmycnwq79w5qlV4rMBA0bNyfExXv143osL1mh40UUMPK
 xwF6dSIMdr8Qs4IhrpQxrlgKR2zwCt3tCNU2hdzAX6H10GMOvL.oOQVxF3URhTeqfDaxDzJGB7cL
 zxX62QZxhdjGZAWI.5G0SaePiued1rcL9KRNsew6GlizpJx4DGk2uH_U36KTtZeMDk93IVzzg8CX
 N21hAc9O5hDhCo0TwExwT2qvEeTKJ8vUmMPap0yf_a1jSq4u45tmtliRD91ZcacYmaBGDuCY5rD2
 VEveWpoibUwxjxiR2vumQE88AXcxshxXqzUHzevmTi5XFIWq5oNre3dgzQYzxKQ0gBfPBghuS98U
 R5SCDs9iSvdTp_gHQSlC09RO3X3I2gkv7pkRqbUSAD2Kkq28s._STzfk.dOlfqPqyGTzNs88OyUm
 iadZsc5ORW4pOvzINXgqn5U1vUlSNXsSLGcWp5TmgBjOdRdUumH4AmhHdnC4HdT0sgwtPcfZWJeC
 fBrjinnFfHeZCBl8Zimy6.CF7.Hu8LgxSjKG56FLQzYKr7DXgqQb2A1YMGqx8GhgpOXm4mkCg1TR
 wLB3vVt_ZNirEoh7E38cbzU3EDIKL7HRoj6dpaH0RA0jL_AaauVYqCergCBT64gU6OHwQNYWsSla
 LyUE8PD9kEIbIIce2zPnM0TpiIq6fN3BcDWDN7SJLAGMtWE8Zrc6UsEnS1z0LE5BXMhN0HRt3TIS
 v54bFT5ZYzmPqpZWAnhVyWXnYsJzSXGQGfJA8.RXeb4dsTn33nt6tY27FkLhqk_E_O.QMnEQOl9K
 rmX5Ki_RiibMyUljeiAZtTA7QcUq.dirzSNACk06FR3jXVsskzbibXmL902wx6QJUCDplCk5Kcpt
 yUhhESVgCagpZ.7OzIopGzkZK4M3JY7xym6dw
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.ne1.yahoo.com with HTTP; Tue, 19 Nov 2019 22:47:23 +0000
Received: by smtp418.mail.bf1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID f0ce218b5cf5f7d004bf13262887f557;
          Tue, 19 Nov 2019 22:47:21 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     netdev@vger.kernel.org
Subject: [PATCH v11 05/25] net: Prepare UDS for security module stacking
Date:   Tue, 19 Nov 2019 14:47:04 -0800
Message-Id: <20191119224714.13491-3-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191119224714.13491-1-casey@schaufler-ca.com>
References: <20191119224714.13491-1-casey@schaufler-ca.com>
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

Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
cc: netdev@vger.kernel.org
---
 include/linux/security.h |  7 +++++--
 include/net/af_unix.h    |  2 +-
 include/net/scm.h        |  8 +++++---
 net/ipv4/ip_sockglue.c   |  8 +++++---
 net/unix/af_unix.c       |  6 +++---
 security/security.c      | 18 +++++++++++++++---
 6 files changed, 34 insertions(+), 15 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index 2b0ab47cfb26..d57f400a307e 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1354,7 +1354,8 @@ int security_socket_shutdown(struct socket *sock, int how);
 int security_sock_rcv_skb(struct sock *sk, struct sk_buff *skb);
 int security_socket_getpeersec_stream(struct socket *sock, char __user *optval,
 				      int __user *optlen, unsigned len);
-int security_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *skb, u32 *secid);
+int security_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *skb,
+				     struct lsmblob *blob);
 int security_sk_alloc(struct sock *sk, int family, gfp_t priority);
 void security_sk_free(struct sock *sk);
 void security_sk_clone(const struct sock *sk, struct sock *newsk);
@@ -1492,7 +1493,9 @@ static inline int security_socket_getpeersec_stream(struct socket *sock, char __
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
index 3426d6dacc45..933492c08b8c 100644
--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -36,7 +36,7 @@ struct unix_skb_parms {
 	kgid_t			gid;
 	struct scm_fp_list	*fp;		/* Passed files		*/
 #ifdef CONFIG_SECURITY_NETWORK
-	u32			secid;		/* Security ID		*/
+	struct lsmblob		lsmblob;	/* Security LSM data	*/
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
index aa3fd61818c4..6cf57d5ac899 100644
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
index 0d8da809bea2..189fd6644e7f 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -138,17 +138,17 @@ static struct hlist_head *unix_sockets_unbound(void *addr)
 #ifdef CONFIG_SECURITY_NETWORK
 static void unix_get_secdata(struct scm_cookie *scm, struct sk_buff *skb)
 {
-	UNIXCB(skb).secid = scm->secid;
+	UNIXCB(skb).lsmblob = scm->lsmblob;
 }
 
 static inline void unix_set_secdata(struct scm_cookie *scm, struct sk_buff *skb)
 {
-	scm->secid = UNIXCB(skb).secid;
+	scm->lsmblob = UNIXCB(skb).lsmblob;
 }
 
 static inline bool unix_secdata_eq(struct scm_cookie *scm, struct sk_buff *skb)
 {
-	return (scm->secid == UNIXCB(skb).secid);
+	return lsmblob_equal(&scm->lsmblob, &(UNIXCB(skb).lsmblob));
 }
 #else
 static inline void unix_get_secdata(struct scm_cookie *scm, struct sk_buff *skb)
diff --git a/security/security.c b/security/security.c
index dd6f212e11af..55837706e3ef 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2108,10 +2108,22 @@ int security_socket_getpeersec_stream(struct socket *sock, char __user *optval,
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
2.20.1

