Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01AD1E3E74
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 23:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729225AbfJXVpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 17:45:05 -0400
Received: from sonic317-39.consmr.mail.ne1.yahoo.com ([66.163.184.50]:46108
        "EHLO sonic317-39.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726965AbfJXVpE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 17:45:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1571953502; bh=LCpRAal86o/xAMqGwYkdQW9t87uiX/01PxsMjwVKvIc=; h=From:To:Subject:Date:From:Subject; b=DlYWnnkzNKXEXvHN6AaMgx+Rwy6cTHDNJm/PARnfHTA05BCYHJFfBNS+KWd3Rc4zZTSyrn0ZWnicrACxofDWh/sEem7PAXwadR6DKmqNFmywLMs/EB/F238wzrdwBp04zSj9EXMCZRPAzKd6FPtI+CRMIONw2tXRNqQ/lDUbWq4/qK6v4Fe7OeRehGIcrb99V1DP9xAGHj3CSdrpX86cNe9ugz3X0Cxei8Bsr5r7vKojL8+rfxIFG1FJskG5FBElN80M1+umvkysEzdQquJnmCTRjh0yCDGpqds4I/ht/WhKC2EIEsRme6OW87HvlwXmReM2ChJcexF6+3TXt6TE8Q==
X-YMail-OSG: eH3uWjEVM1ktkaNK3loYc0xqSzWGMv4uopD2q19fsDMvhv8xr2k_tBip_Kf.IG8
 kR_wvmmIhTBZMe2xsqHGWiRkh4Xq74XpeXbWDGQk_EvdVf2pghf5LoIyLyEgCntZcpyjhjLzm7vL
 f_.H5_0URZf2eMHsNmIIIfFrBwBHiCP9m1tzX_R1ddtMz2gJZFq1b7q7xVV1ivc1skyflr_Vzupd
 iRh.yMHB1Nld2HgGM2CrruaFmGVhb8dF8R6dLLCiYOnpFUOI0es58VQnDseuDMTr0wPwYl4QcSCa
 mCNySgPCqUOUB2ZZ823DVKfNUDt3nF68EVaGh7foppfY.5pVmO18oAcMgI7AMv8WUPZcoa8POqwn
 cfljV47akTgqXOIMSKN2OZvR9JzW1HzKRiEHKmBJEFqCdEX61fxPMfoye4npfC_4QQqaJHBjsbqH
 gG1nf0c344RwyuViDb.s1C3N6anLAbExVi6RIf4B3Hw4ZjIbWXk6cWZwddyqepjCC4SmnfFZSs3o
 mlecdIHQ4r8GIkrbJK5Ca9hnIc0z5iI4kbJV2dCWeN_bS7r8XkYA0xAkiUpfm9dlTvwjyiOe_T3H
 hgG_ZqFyWcbB.SeTPdZyducuXVnxftKxE0EqH6C_ndfq1bdjxUzdrrwFzYWdQ0gryTlIlbLWzAnz
 ONf_wi49d83fZEcFe.2W.wopysCqwdHZXdTzkpOj7c5EIHQuzJ6z9o5Tv919PHcPgpNcZKQTPBOi
 8IJ.CLsEwrbId7TJa6qLw2sOPD5QJ3Bic5x3SmKcuxjADEdcu.0.zbc90Kbbt14Qdt1IzwxFQbjN
 wnY4wVo2MeEpO1go.qq7m0yYtWRUBdRKi28CMr.exTHxbf01wVSocIBLvL6YERcvDIr3Ggo9rIe7
 I561tFwQ2vfqjHjBk60iitaKBUw3KlFu8HwO_gCm9pPK8HVFYWJuPYs6ABVIyxA73yaY0f8b8VDf
 NUQvTBLFfDrIvZA94otef3akWrHTqY4l3PA4QylCMkb41KLrC3uvZ2lX3OBCFKxDLkTnkau4nnG1
 bLFSta989vjyjCRn25In.RPNhAe9Vsr8Y89Y8zhvK9Fd6NYN0.S.ai_3eWtmr_icDM0enQdaxfyJ
 obtUPAJBbZL9w6cI3d0qTLWzfhXUuZdFvBQQJqf862MEnUiT0fIChpHXMn6MtaomdeAF8Qzz5jyF
 CtCqAkEAzsmc2SakOrn7SWwyMpPmpLUW8r7N91QH3a5J0yMr5E5bL.HBX88gCLI8co96mr7K_HI7
 Ky4ANSlhbVyTPaeB3TY6fvRCoati.FXKuX64U9h5SX2l8hBp3dJJs21n1ONbM_6pjXsuHC6h9X9o
 AwLq7AxhesxJyAfilQgtKh.gf5rKH_LFP18ju4qouXlXP983Ec5mqMdCx45R_l1RtIpBGz3x4DpE
 68A--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic317.consmr.mail.ne1.yahoo.com with HTTP; Thu, 24 Oct 2019 21:45:02 +0000
Received: by smtp420.mail.ne1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID eaf5054cc9d2e89fbdd41d6e12cec122;
          Thu, 24 Oct 2019 21:45:01 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     netdev@vger.kernel.org
Subject: [PATCH v10 05/25] net: Prepare UDS for security module stacking
Date:   Thu, 24 Oct 2019 14:44:58 -0700
Message-Id: <20191024214500.7356-1-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.20.1
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
---
 include/linux/security.h |  7 +++++--
 include/net/af_unix.h    |  2 +-
 include/net/scm.h        |  8 +++++---
 net/ipv4/ip_sockglue.c   |  8 +++++---
 net/unix/af_unix.c       |  6 +++---
 security/security.c      | 18 +++++++++++++++---
 6 files changed, 34 insertions(+), 15 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index cd09e7b1df9f..02ff6250bf2b 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1272,7 +1272,8 @@ int security_socket_shutdown(struct socket *sock, int how);
 int security_sock_rcv_skb(struct sock *sk, struct sk_buff *skb);
 int security_socket_getpeersec_stream(struct socket *sock, char __user *optval,
 				      int __user *optlen, unsigned len);
-int security_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *skb, u32 *secid);
+int security_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *skb,
+				     struct lsmblob *blob);
 int security_sk_alloc(struct sock *sk, int family, gfp_t priority);
 void security_sk_free(struct sock *sk);
 void security_sk_clone(const struct sock *sk, struct sock *newsk);
@@ -1410,7 +1411,9 @@ static inline int security_socket_getpeersec_stream(struct socket *sock, char __
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
index 82f341e84fae..2a5c868ce135 100644
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
index ddb838a1b74c..c50a004a1389 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -143,17 +143,17 @@ static struct hlist_head *unix_sockets_unbound(void *addr)
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
index 7879da7025d2..bd685be33b56 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2059,10 +2059,22 @@ int security_socket_getpeersec_stream(struct socket *sock, char __user *optval,
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

