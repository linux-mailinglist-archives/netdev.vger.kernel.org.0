Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2079A1D40A7
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 00:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728368AbgENWR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 18:17:27 -0400
Received: from sonic316-27.consmr.mail.ne1.yahoo.com ([66.163.187.153]:37661
        "EHLO sonic316-27.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728348AbgENWR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 18:17:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1589494644; bh=u4PR1jFNgyHDosRxvpDBu0NOf2VSMAR5RDbUvfJ7o/c=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject; b=BDg91qtDuyinDEuV2w/Yzh4GpKcRODW6+WD5ZKi0EhL1+6Qe0TaB20epHf8m+GI4pU3j9oN6I8EJmK50huLbfVbmQOSKdr4bO51Sh6kR+FzPXwbPnCm1m84W0UO1Zw1yMKc3B/03SB0uaWUsyWZ7Gui7G83EymHxAsIqcDbzbm7mZJEx9My0UhZMqTcTao5ILeqG6A9gK424823An2iatIdIn5blRVunj/RzmxMWiUtQLYbkEraPPV8ROhXRYoTww66WMAdnfhpHyeNqGCvI+2yjxKFclFP2inWOwM6tefirpKi+VA5uFdAYORgoi+4mmHtEvK8aIffFuV2r+OozVw==
X-YMail-OSG: oXU6uCUVM1mQzMG6pu6YrJmBu0aUT5C.8mFZRxSGpx0pDfGoaO2VOgQkJ_BS5DT
 LW1aIbUqyBQguIz4TbxPtLzh5SkgSHrhdBrgW3tP9I.sBcCU4OcdtY8SYYoWmmmlnTe2G2cXAW_q
 YnKUpcncdwUfCLjbna7Jr1peehuEyxZwr7g0t8zeUQU_ytRBo7DkzvdtjOk75TiD8h6XDVHYK_Uj
 r7IvQTK2y.NK3_VNf2Dle.cTe9dDkgu_edw_fvWllEJcpQc3IO_4JnN8CeRh3VSEcmiy7KACbPzH
 Qa69MbtoMp9tcEubWZFTpKZ.qPYHC6tn2WuNKcQu28_4uMDlmucJ34J.troqR_Pp294lRNVa.I97
 JSUQph0oRbEe6BRRvM55wmhfJOs7HIU30nkTc49rpmhLjSqJVFcdlsesUqvvFjjVXwy3VEDO8yyY
 .wU2HE5E9TTUFz9sB6HxqLdhGItSd.ag3v0Zmdsxh5_4H4nWU5nQML0KaBDKIaRdGIH5hEecX_WH
 ANkpOlooQmF__jpk8mIbvpYTykepMXvBybz77L0srxTL.L_e5Frg4HrcFJuM4ChpLFP7D_2abSuG
 oICNOITQpWimq_ajK1xH6sRIv.ae7SqX4WGxkY0kcCeV9prwcJghE8aBSI3WY0a08z7gAK7na9zj
 pyjV4Gcqp5LkgpoH42VDkUJHJnt0FATJfQIpvegbqaJvpfn3CIZgZhkzGYLchlU7J7QmwyfYwX7z
 KxcbbYQvLZ2ByuGyROSOdk7nEYSJqfacixNeSUyv9ZDsqKS4_yQ4LtFwkm94QoLbJxeREXXU.46n
 KxHjJZoJbzBIyac8uCVCODkQ5CukZMw1R.PHQcArvlMxpBE6PMnVrnSUVL.fEZn0Fu6IKVbEFNsG
 2oIeB7lb8bSwbrkFHshVG8Fp.grrqd5orVJ7SRFChngaPm6FjBHTJhevk0d.kuUMYLBAAWO7BmbB
 0zVaZbKNQakKBG8Dq7OAoBligfqWS8ZBpaxzvl1EmlHI_mq2ayEBftBq6nIRsChyhp37gzS5wS.H
 Rcupwa3CphtO7AATbdM3OO.aKD2ddpHxAyFP_V8fi_9saDHsPI1uhZqbd6IOgEr6yfIW8ScnFquC
 ktgm33NSMWxQLur2_Ww91V2.fQ5kTH9mkzUx6XeugnC9SGpltsf6manXBSbaCnaX5py12oEDAo62
 yrwh9RzGLG2ptGkdwNRs.McRyrxHlZL60dgLm5Kccyt4vAIwTJCm9Sgg8oG12I8CsQqyJJ2yt05Z
 tO5hiTvMy7y6oeYsHZRLyThYhx8iIUkKwhPw4BarJNzJ98H38d7D3dq8tS5lj6bopL38GiEgxgbA
 Cu015JFlNRecziL.Xq2IvmUKBTCs43Hc7UIBaVFJ8fKCaPS4LLruAG5adV1F2fSTnlZu5BXaaM5s
 KLGFodbafXrayRqy6JGx4bvCBEVRo8AsgmhKB9mLnXl4-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic316.consmr.mail.ne1.yahoo.com with HTTP; Thu, 14 May 2020 22:17:24 +0000
Received: by smtp408.mail.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 93c3c5cec162e79885943e41cf62d47a;
          Thu, 14 May 2020 22:17:22 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, keescook@chromium.org,
        john.johansen@canonical.com, penguin-kernel@i-love.sakura.ne.jp,
        paul@paul-moore.com, sds@tycho.nsa.gov, linux-audit@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH v17 05/23] net: Prepare UDS for security module stacking
Date:   Thu, 14 May 2020 15:11:24 -0700
Message-Id: <20200514221142.11857-6-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200514221142.11857-1-casey@schaufler-ca.com>
References: <20200514221142.11857-1-casey@schaufler-ca.com>
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
cc: netdev@vger.kernel.org
---
 include/linux/security.h |  7 +++++--
 include/net/af_unix.h    |  2 +-
 include/net/scm.h        |  8 +++++---
 net/ipv4/ip_sockglue.c   |  8 +++++---
 net/unix/af_unix.c       |  7 ++++---
 net/unix/scm.c           |  6 ++++++
 security/security.c      | 18 +++++++++++++++---
 7 files changed, 41 insertions(+), 15 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index 453737cefe09..2715b8dd115e 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1357,7 +1357,8 @@ int security_socket_shutdown(struct socket *sock, int how);
 int security_sock_rcv_skb(struct sock *sk, struct sk_buff *skb);
 int security_socket_getpeersec_stream(struct socket *sock, char __user *optval,
 				      int __user *optlen, unsigned len);
-int security_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *skb, u32 *secid);
+int security_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *skb,
+				     struct lsmblob *blob);
 int security_sk_alloc(struct sock *sk, int family, gfp_t priority);
 void security_sk_free(struct sock *sk);
 void security_sk_clone(const struct sock *sk, struct sock *newsk);
@@ -1495,7 +1496,9 @@ static inline int security_socket_getpeersec_stream(struct socket *sock, char __
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
index 3385a7a0b231..a5c1a029095d 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -138,17 +138,18 @@ static struct hlist_head *unix_sockets_unbound(void *addr)
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
+	scm->lsmblob = *(UNIXCB(skb).lsmdata);
 }
 
 static inline bool unix_secdata_eq(struct scm_cookie *scm, struct sk_buff *skb)
 {
-	return (scm->secid == UNIXCB(skb).secid);
+	return lsmblob_equal(&scm->lsmblob, UNIXCB(skb).lsmdata);
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
index 0a13e98ec6fc..fb003806807b 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2159,10 +2159,22 @@ int security_socket_getpeersec_stream(struct socket *sock, char __user *optval,
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

