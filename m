Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3EE12A462
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 00:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbfLXXOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 18:14:37 -0500
Received: from sonic313-15.consmr.mail.ne1.yahoo.com ([66.163.185.38]:45639
        "EHLO sonic313-15.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726251AbfLXXOg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 18:14:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1577229273; bh=yhnI760CPr/sBafiHMdBGzxWiIu4dshXzgZSP8tu4fE=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject; b=H7AeoyDYvq/Gt5/Q04N2hd0PbrMMFXtxsX8/5MGkPv6w+zS4/L/wSUAwNPlTWFTbch+zQJqnT5wwD8PY0NPD9Nj/PPqZ+h+IH3rE5TyZhETs2qhYfvhF8pn6dmd046BOVquXFJ0xYXAHrCjz/dj3G2w+fbDQWddLpSgVygiLUR0o4Y+OJNfgvCqDpT4jzkuW+VvmTJSBXVx4hM3qaJXsOnZFmoMymEhuUetfcMWPZDdCUKAssFiuz65IkWro4hWJXibP3M6qmGYIcIGMkYT/H2raV7SyfYHOx1URQkd81Mq/O+osuA0Yr51Mr8ptL/FN9SyOVItenEDewXhng3/u0A==
X-YMail-OSG: TkjBd.EVM1nBSIKYA9zWDfhxFzvkKtlweNHOoSdY3o_DIpLfxc5pbFWxwu386x_
 YW50fkPy20mnAQ18qE7Lt3yyJBpwm9RhY8rhl71xLdRnHGpFKpxhHy3LBikDFPCEo69yJV_grLUx
 EvdSNdISUxQzztsbrMQ4eMP6dr8mF6TCjtEIKRMILXsLwRFRN393f_WFPVt.5MIuXi9i0LUkYegx
 .AbgdRJgw5eGZlaiwMqihxJcfE0nouxEd7frjGWaNHtV7lM5AiDp9FWTjQjvb.OJlfVmPPyZucV6
 Rw1sftdPilorEgFVlZMAPMOSk1E0uq_V6i49AMgwuWDszieM.dh3cTs.3frwfaR8Bvas8ZbIN7lg
 6kC26FHy0jMBpICQIx1rbr02YcOPUhwP4NYWFxWPeuXdrwfWXXU2DMpbcHvid6V0yIurlZDfhnsu
 7XM32TEdGv2p29Sd8wGoMMvAH5Yujdwb8aW6i50ZcJG106XcncOlI6kYnyOsJPAobZYEeaGHUNJT
 B8txI0TDdvNogBGtPuHWBDFeqT.At7SkUaVHqgEg6Fe7RtJkeI1AKm7H2Pce8_rXVKZafU1my8wr
 7kApvHg99Vbs8sOv7CetnLBvBq36oGz39GeFMR30gZLlRR0QdxC3JIOoOZBNazCFxGESp1FdaX29
 2CF8YBEobSwrqjn1pcSUSYPCzXqELwIZFFtN6Kqjs0VRLP9FeHhql0ZEUSoqExQ0VV07rZnl7h5t
 RzQfJWdXke3bdJeCFit4rvjrtdq_MrTY1GICVrzxkzz3AVo6XflyJ4dkr04.VtmtFqEb8CycAjfs
 J6YTnylB8ODZ5guKpxPSz5UoVUFu9MQRas4kL7MP6w0dQ5Dcq4zBg4fuEe.PMl433OAe4ccqoJ5x
 RxfLg1w1RH3h39.d9DL2M2uEjAyW25Gxgk4zkZ5z7BlGiIVu4kj_J7LzrDVPxhDmexVf3tukjiu8
 S.ZVQ0rgqXQsH_QunDEOEo9AaSlsPnGJpSKupNuwcv00vQa8qUszhR3d19XcZQOXG66Z0rCiOMUp
 pyMt20ciw9cdF6l42hHjdo5vUanbndkzqLeOPVDbSq2sDhDy7JQKq6CxvsbFrymZ6yoDo0HNxuOa
 yytXk5X7hH9RuwR.WYNULIO3tyN06zjThyEhP7lauidm0AEVtvIqT35b4jtGQgeqApBSrCcQqhqs
 tRgMXBbwfWlBavZ9KquFohrC0Mc3OMm8wPhXpYW3338ZYHHVtIlje_lBUinMMdMn8MCE1wbUeNah
 dsr7Hn5siT0VTHy2mgPemSJGg7iLmGw2fSYTgpp.L3fbDKB3tUuni_c8fJLQF_cgv_pAtMMq9sPz
 X2iH4UA0rje0aTqfAwfbrAi1QssGJmGozeBOrrviCPBf6iSXRnkAEHHZ.fuLLikGhvozkxF4NdJC
 9U7iPWPsmFRtcEaJ9jQth535YdgkWvVASOycWDNBUtI0.S6uE_vh7yb4wKA--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.ne1.yahoo.com with HTTP; Tue, 24 Dec 2019 23:14:33 +0000
Received: by smtp405.mail.gq1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID b111bc4e15c819c06a52690148d3a3e3;
          Tue, 24 Dec 2019 23:14:28 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com
Cc:     casey@schaufler-ca.com, Kees Cook <keescook@chromium.org>,
        John Johansen <john.johansen@canonical.com>,
        netdev@vger.kernel.org
Subject: [PATCH v12 05/25] net: Prepare UDS for security module stacking
Date:   Tue, 24 Dec 2019 15:13:19 -0800
Message-Id: <20191224231339.7130-6-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191224231339.7130-1-casey@schaufler-ca.com>
References: <20191224231339.7130-1-casey@schaufler-ca.com>
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
index 322ed9622819..995faba7393f 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1356,7 +1356,8 @@ int security_socket_shutdown(struct socket *sock, int how);
 int security_sock_rcv_skb(struct sock *sk, struct sk_buff *skb);
 int security_socket_getpeersec_stream(struct socket *sock, char __user *optval,
 				      int __user *optlen, unsigned len);
-int security_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *skb, u32 *secid);
+int security_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *skb,
+				     struct lsmblob *blob);
 int security_sk_alloc(struct sock *sk, int family, gfp_t priority);
 void security_sk_free(struct sock *sk);
 void security_sk_clone(const struct sock *sk, struct sock *newsk);
@@ -1494,7 +1495,9 @@ static inline int security_socket_getpeersec_stream(struct socket *sock, char __
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
index 7cfdce10de36..73d32f655f18 100644
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
index cee032b5ce29..a3be3929a60a 100644
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

