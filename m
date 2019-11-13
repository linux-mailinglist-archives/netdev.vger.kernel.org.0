Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABF9FF9EEE
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 01:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbfKMAJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 19:09:44 -0500
Received: from sonic315-27.consmr.mail.ne1.yahoo.com ([66.163.190.153]:34393
        "EHLO sonic315-27.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727134AbfKMAJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 19:09:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1573603781; bh=fQopPU+QHEIhU1rMxngnZt5dLriz8PONEvXZFfDzj2M=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject; b=VIrKDrhyq9bFHOTNVoJJR+7kFNmfXmjbQnWVLE5ZMITv5HHkWVODswQ7TawSpL+0BfOABsLv6pWEY4YkFnzLEKJy+NBMaBz1cg5oQzbNq3iGvNZ3y4PfpAV/SadXkC+sT2dKPnPnKMLA6R4Bh/fxQ+qJZ6kAoqjcsd1t/FJdLyYDP+sDJMSNDdSZ78Tl9c53TfciZxPsEqmAi9EIhb0lMk0i90bmY8RIigXHwUKusVFSUekNvt1HUBoEb18RzOQAh1tNw14uG0p5xhuAOhn+E9NaCThL37OdPRoNFm+19vuo6qo1d5n6Em5xelZXbCLEsxD4HTNGnW95a3huhpr7JA==
X-YMail-OSG: nXHSJ0UVM1mNznJO.AkXuFiBGQrd1UtHzHox9XQuRYjtuL.PPsY6OcT2bZATAJq
 BIWMN_dylpUvbmeayEpGIo_SXDa40KAATm8.ypX7vNTajR5CaK2X7hSfM1ZqKE96dtNDiQtFFXx2
 LZjV4M5HgZoQA1KJVwG0AGQLXYZAYrwin.PfH23XNkJKDX_RS.BLh2fPmoEUooNWXVecoOkyb4aH
 KproHUnRvb18gFL01wZ76sR.ulGjEJLomrMIbHq56W5Y.z72E8jmmXCnbKlaFO3RXROOHrQ6J6IL
 lBl82YQk3UIPs8uu3vK8PoevcHNbNRBDBenI1reJNA7k5LrDiM4JxnFn_vicDTaJpkEkqbd.gV2K
 N9sPZjXjpguVg_lajo9YmNBrfoOsWS9QoVYwROE1Pn6ru9L7FyI1Kdsxf4.r.ikEjvSzvD6hjXJo
 6QmBNhSR4yh73ZR4h.wZ7egE9lAKvZ0LsGeGuBmqMANtRBD0chUYN2FuxNWMvhRQW94bnWk.2tXJ
 kJ6Xk7Qi7n12m4tnhYZK49EIaMkGzOMKMFXNmdS3U.GdDHVk7g82lJocxV_QtdACIG9bM9x1UJo_
 43Pt3.MMQ6SxBHrQrcyP4zpvHCCcHGK_DQraGzpafZTmdp7fUQDspAP2gJ2hMBF9Q1joeMN8VOQr
 DnZx63hmO2z5Fnv1Nt8yJhlDP4shkiomIgiVPaS2ihudi9IYCoEATUxR6TZdblaoK0BMGMlu8.Q3
 STvSB1HNMksBxo0nEqbKU1MTZD94oM3HkFbvr8ABUARJ5MYhpKHShhx.rgyBqtadUgWCApbMHoBJ
 RrdhGDR_MyxEUcC1AMwgYcqzGwaaTCcC3j1ytpuM6nOs_XlioTKWX_5.Eg7OusOVGYLRx0lgMANg
 9unbRS01iF.JlZ__0EBcrs6gRyMLVFXy.83nD3Z9llo8l5fcU6BFPx8915g.9Jp2wv4mLBEMlQz_
 Kn3pDCEGWPDRE3p6FoaGeE9N4vPz4Al4b03iVZRpSKUVvnQD03n97Jw8l1iyG65K7xHjJXH2E8.m
 z3ElSlJIzo1Yo9vGhFK5Po27hq7GtuGEUXkkt7E01fu04t8WDLE2WlgUQ6_kPBECFZaswMS9Scnx
 zOnW6lf6EDtY0gGyOpyugl1ePgZWF4kHrZrJ1sXUqaWxkg6gFs3gmzOUATUYrW0nFZunoOXNFsyP
 NCHxcFok18aPiis9kcQ7o9UdionZEJFKXcMrMJqVa2ZbhbtTrJ61ufEFfgaLCL5082DFNUG.3Eco
 0XrXhanRHnvbdiFoZb.rUBxfTbT6mzOyhmE_e4E7a3DxRrExybCUTmlZSiP0fg7K56TT2yxDDSUU
 CQA2VJLqogykdyhIXkEP6huKziOHE8eyripBT3wGlfJ.Tq_FcY709ZupsYElAMF9nlknlIUW1OJ7
 iFMASNAM0hZCRr1miiwcX5V8bjaMIMfeEssGy8qc61jwz.Lqni5rF.bTDZSKm.4F9kl5BSg--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic315.consmr.mail.ne1.yahoo.com with HTTP; Wed, 13 Nov 2019 00:09:41 +0000
Received: by smtp427.mail.ne1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID eba4c54ba4d55f2cad95fb20ef489486;
          Wed, 13 Nov 2019 00:09:38 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, keescook@chromium.org,
        john.johansen@canonical.com, penguin-kernel@i-love.sakura.ne.jp,
        paul@paul-moore.com, sds@tycho.nsa.gov, netdev@vger.kernel.org
Subject: [PATCH 05/25] net: Prepare UDS for security module stacking
Date:   Tue, 12 Nov 2019 16:08:53 -0800
Message-Id: <20191113000913.5414-6-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113000913.5414-1-casey@schaufler-ca.com>
References: <20191113000913.5414-1-casey@schaufler-ca.com>
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

