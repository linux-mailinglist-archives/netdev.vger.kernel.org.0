Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9DA55CA7D
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242130AbiF1BJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 21:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242964AbiF1BJF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 21:09:05 -0400
Received: from sonic301-36.consmr.mail.ne1.yahoo.com (sonic301-36.consmr.mail.ne1.yahoo.com [66.163.184.205])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F296122511
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 18:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1656378542; bh=D1JsPsnCVN0+jqrYq4LFS3OvZjCufzqNfNeCL92tKX8=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=WriS1hX9aPFkg7+2hLWZC0zYRNl+FZabHbW89LdJl3qGKK8B3HIe+EBiRhW0yyq3tNdVQHWVH+1kJk/L9ReLge52mWKpLYxBzTeprfaWisjLp1SY5zSXs2isMSWYXXRfJq7Hi7U8VPKJscUBjEC6Llryl2GI1eGZHSux2TFkZqZVqJWVyGoLbH667g8MpxmKP1C0kprnC1o2SnsmeQROgMPlYjfK0Lckr0lfUM+Ppy6ME+OKUWqm92TVOvkd0TGefhsy1rAP+1UEnZergbVw/CyULY5svyFKMVhns+815s9u8GA5bNS4Z0mWv07l//8hn9mggg1jkfgGXswCTl+2Iw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1656378542; bh=tbOjgeAv4/DLNTiLg+E/EKrNcLq6lLIP/YSlvzCg3+N=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=GyrIcxJ5VY+n7D33gA4Gv9FJVwXROpqGqvLCz34zJAiPn6g9DJLTLZKH/+uev6tAaVBZ85Jl2THgbKYJCsJQXCelYnCDWrku/z7/56SUnoOjG4zsh7H/2wZm2HdzxOZzT7K0TQHEqz9VBdS+fKGMKRCupv5I4p2x5I0zv/Jg+1vNxfKHGDe4ZOQWbtwgJ95ZigFKqg9k5Fx2vG/tmMz9S2jGnXixJYBS9IYXxNM5FpyAV1Yjcfn/QXYO6g1J3DK3HtIkgMioO0j+z4Rh6nRcTVj3g0TuayU/znejP42N1I9/iEiPbiIF0aWOtqY0bvV3/GTeTDEEZ31fs5zish0yUw==
X-YMail-OSG: Uo0AqoIVM1mA6f015e5WJkK4ZGIfCskhQpQtmW6yQ9NQSRtGW3OnGjYBEwDT4iL
 r5xbMKuoNBhZ0ihRrvGvXyHIdQBV75iYzJvcpeZsm.zepjw_bw.UwwEZI58rReNGAAdTT7GpWo45
 v4x8YgSBp5pV12hftXOFvlTgr9jJQFhy2S2v.hHa7KZzymQRidFJItqFpLCmq_zFZt.._zkOy1rc
 Mr7g5ANatpyNemrYmKEyUI7S0XcbYCQnYE_Ed4pzu31HKeoFKxrMH1MW_Qga7uFOfS2xGJBhTN4K
 bgtRENOZhgn8W_OcqhRrv9S57ZQgrOBNQofrQKUpd6EM.xZYXn3YdcKzvQHy3Vv2n4ga638hLzB6
 xNqienqYagS6e0W.em5MLwgUyFMpwiZLiSdl.4XooX6QMrAN5Dj9v2xpH2RxWSk.s7BGnux9rLKS
 nFAZjZaG3hLOaHlaBIB_cqRMVS64E70CK3ddS._BVj3mJlboksQoLSwyiut9c2Oq5yNqbilgTXdk
 5wX68eZQUJ87NvlcHtD0vrhDgDQzII_DQHwKXRE.6QyjM_Cn6vaz6RhMiqs1rYJAEC8TV1iQZL3.
 WgpPO57iBr8eHZXXy8S.XWBXw6f_M6ewDMtXg2lczCAioIBnBnl_Nz1sgE8UKLKiInRMm4f3ADzZ
 t2NjteqwaYpHnXcjaDA9dBPr_cUiptwL7uX6lgiFRgHZDU1hI5PC5DYW62PZE2c4QYYRljh9AouG
 a6CxoXyn8nl4aiTFeUfShSddFwCAfg9Hr5DNdjRIHFpJt6lcnIMomUjt1TfKlNxltsD7yek8V.wX
 ZIfXwLCoG97wVzhEQmQZYCKUYmcjwADeSa6yVIPRR1APpTKK_8rt778WU0US7YH3QXfYQsTTMU7g
 EfHH8fkID9ZDlPoP5z1GPKimk.JEiHnhgpKAeIelsvgfkBNdyKhx78F38hRxXYnJmsbGv2GBSqwK
 OZ1S3siymcNZrO5O44E9isXeAlNaE0QRylS5TYCwPpvrrqsExzn5F8ZI6XpOZ9HZVTxPw.nxBCDX
 hID0Juw5rUUJlidvBjOfP2aB8XiiNebZsi1KEO16WXWsDDfQbGOKt6nguQNvkyj8P71xd8uAJqJ6
 Psn2bdrIq_Y4LaVAQ5OFtNeipdpwIMT0KABbwc35YnrLu6glszHTkXlkRNIIWwSp0U11.CVpPUUY
 8FFntk18RQhlylbU_GJw6A.upVOUrH4nwHU539eov.pi7FVxpFnGlAcLp1MUOiybsMUazLvAJHq7
 HztbO.zcAFtFYWamZVUw28fuxfAF5siGuEf7fgBvgNN3eTq5nPcwy32z2qVeVkiGnVlp4Pks89Rx
 FgC9b2DcIvNO6OUJLFzWElgT_Hv0PG634AILLt01cYbpFDW2_o7YwuDk7gAOdRgDA3NfYZ7aJXoS
 AKCEe8Ypy6Wn8HVuVj6K6_.rS_IsCClWe7sbi1W.pUILyOVSGjspNGxpddBosiTCBMjuQRHz7dPf
 VVrFusiHBB4roRmOi3e.BJFRDPk0LHnqv.UmFjh43E1Z7dFH0GRcl9klk2CgtJnmoZhvyI2pUHVN
 _dstJy_9d3IqPfhrrciGfrzWlEtZNShg4bU7Os1izEhabXGvJBDdYCAkrOE1JMAf3mzQo1oND5Gv
 c__QuiDWRD8rajxGTA7hkkzk9tIq.aht32I91Z4f_dCx3kxn5ZqtlqKHVl9BYiHZqpcRXn9BIoxJ
 r2LgD4W2U.vq2FSfLFm5Eb6ow_rs4xzonKMCgQh7XZKIWUy_Qkm_OFASl9ZLkhj0lO.FONDUdftR
 H4Wfs9fHqPHX_mMDNdA0zemwjzsLVmu289vzU9FrX9DaNuZ36pll.fwZ9kTRP4uWgaXymvHQ4wAK
 AO9dloOKLkah9XUOunUZLfaGtkvtp44X9k2sdq7QRxHIjyGm5oieaeE82avKlrEPUsILc5Y5zDC6
 QEUjghh.ZlXYD76GVaoOBwwjd6kAfyE_CBTPs8.0IYk.ndDtgT3aTx68JsDVoZ0PfgcMwsYsE6LC
 sZz2X6rEVKyHMvKXenNHaT_LSzgeZmu3kFR8wkk5pquI.FoKZ35qlNr8etER0ZQBRrhZBbyFu06E
 dRDZnRv5jy9NM6KaIA5rBJsoai0rKdEiqr0wOyz3rOgFcbqm6lP43yip98ooItEzluITSgrnnqJ2
 _HTaQeRGhF.XlCqBFDkcDVP.ykBhuhMUPQ7Q_eBJFzwWEGxq8HmFj0JOL0zJZPs1u6aWwBWlaW.c
 Ek_LB.yXJSB9o_BiqjPHtdTwOUgwUbw9h4cra96e1x.autKNOKxUUQvkLjOIr0wyUV2wJwL_4139
 202K6ROB9D6DP5bqwlCJVNz47.WTa_ZmA_Og_5Q--
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic301.consmr.mail.ne1.yahoo.com with HTTP; Tue, 28 Jun 2022 01:09:02 +0000
Received: by hermes--production-bf1-7f5f59bd5b-fj9wt (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 05fbaa230dcbeea0318fe174d0a2d20b;
          Tue, 28 Jun 2022 01:08:56 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        stephen.smalley.work@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v37 20/33] NET: Store LSM netlabel data in a lsmblob
Date:   Mon, 27 Jun 2022 17:55:58 -0700
Message-Id: <20220628005611.13106-21-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628005611.13106-1-casey@schaufler-ca.com>
References: <20220628005611.13106-1-casey@schaufler-ca.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Netlabel uses LSM interfaces requiring an lsmblob and
the internal storage is used to pass information between
these interfaces, so change the internal data from a secid
to a lsmblob. Update the netlabel interfaces and their
callers to accommodate the change. This requires that the
modules using netlabel use the lsm_id.slot to access the
correct secid when using netlabel.

Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: John Johansen <john.johansen@canonical.com>
Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Acked-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Cc: netdev@vger.kernel.org
---
 include/net/netlabel.h              |  8 +--
 net/ipv4/cipso_ipv4.c               | 26 ++++++----
 net/netlabel/netlabel_kapi.c        |  6 +--
 net/netlabel/netlabel_unlabeled.c   | 79 +++++++++--------------------
 net/netlabel/netlabel_unlabeled.h   |  2 +-
 security/selinux/hooks.c            |  2 +-
 security/selinux/include/security.h |  1 +
 security/selinux/netlabel.c         |  2 +-
 security/selinux/ss/services.c      |  4 +-
 security/smack/smack.h              |  1 +
 security/smack/smack_access.c       |  2 +-
 security/smack/smack_lsm.c          | 11 ++--
 security/smack/smackfs.c            | 10 ++--
 13 files changed, 68 insertions(+), 86 deletions(-)

diff --git a/include/net/netlabel.h b/include/net/netlabel.h
index 43ae50337685..73fc25b4042b 100644
--- a/include/net/netlabel.h
+++ b/include/net/netlabel.h
@@ -166,7 +166,7 @@ struct netlbl_lsm_catmap {
  * @attr.mls: MLS sensitivity label
  * @attr.mls.cat: MLS category bitmap
  * @attr.mls.lvl: MLS sensitivity level
- * @attr.secid: LSM specific secid token
+ * @attr.lsmblob: LSM specific data
  *
  * Description:
  * This structure is used to pass security attributes between NetLabel and the
@@ -201,7 +201,7 @@ struct netlbl_lsm_secattr {
 			struct netlbl_lsm_catmap *cat;
 			u32 lvl;
 		} mls;
-		u32 secid;
+		struct lsmblob lsmblob;
 	} attr;
 };
 
@@ -415,7 +415,7 @@ int netlbl_cfg_unlbl_static_add(struct net *net,
 				const void *addr,
 				const void *mask,
 				u16 family,
-				u32 secid,
+				struct lsmblob *lsmblob,
 				struct netlbl_audit *audit_info);
 int netlbl_cfg_unlbl_static_del(struct net *net,
 				const char *dev_name,
@@ -523,7 +523,7 @@ static inline int netlbl_cfg_unlbl_static_add(struct net *net,
 					      const void *addr,
 					      const void *mask,
 					      u16 family,
-					      u32 secid,
+					      struct lsmblob *lsmblob,
 					      struct netlbl_audit *audit_info)
 {
 	return -ENOSYS;
diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index 62d5f99760aa..bb9c900da6b0 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -106,15 +106,17 @@ int cipso_v4_rbm_strictvalid = 1;
 /* Base length of the local tag (non-standard tag).
  *  Tag definition (may change between kernel versions)
  *
- * 0          8          16         24         32
- * +----------+----------+----------+----------+
- * | 10000000 | 00000110 | 32-bit secid value  |
- * +----------+----------+----------+----------+
- * | in (host byte order)|
- * +----------+----------+
- *
+ * 0          8          16                    16 + sizeof(struct lsmblob)
+ * +----------+----------+---------------------+
+ * | 10000000 | 00000110 | LSM blob data       |
+ * +----------+----------+---------------------+
+ *
+ * All secid and flag fields are in host byte order.
+ * The lsmblob structure size varies depending on which
+ * Linux security modules are built in the kernel.
+ * The data is opaque.
  */
-#define CIPSO_V4_TAG_LOC_BLEN         6
+#define CIPSO_V4_TAG_LOC_BLEN         (2 + sizeof(struct lsmblob))
 
 /*
  * Helper Functions
@@ -1460,7 +1462,11 @@ static int cipso_v4_gentag_loc(const struct cipso_v4_doi *doi_def,
 
 	buffer[0] = CIPSO_V4_TAG_LOCAL;
 	buffer[1] = CIPSO_V4_TAG_LOC_BLEN;
-	*(u32 *)&buffer[2] = secattr->attr.secid;
+	/* Ensure that there is sufficient space in the CIPSO header
+	 * for the LSM data. */
+	BUILD_BUG_ON(CIPSO_V4_TAG_LOC_BLEN > CIPSO_V4_OPT_LEN_MAX);
+	memcpy(&buffer[2], &secattr->attr.lsmblob,
+	       sizeof(secattr->attr.lsmblob));
 
 	return CIPSO_V4_TAG_LOC_BLEN;
 }
@@ -1480,7 +1486,7 @@ static int cipso_v4_parsetag_loc(const struct cipso_v4_doi *doi_def,
 				 const unsigned char *tag,
 				 struct netlbl_lsm_secattr *secattr)
 {
-	secattr->attr.secid = *(u32 *)&tag[2];
+	memcpy(&secattr->attr.lsmblob, &tag[2], sizeof(secattr->attr.lsmblob));
 	secattr->flags |= NETLBL_SECATTR_SECID;
 
 	return 0;
diff --git a/net/netlabel/netlabel_kapi.c b/net/netlabel/netlabel_kapi.c
index 54c083003947..14ebe0424811 100644
--- a/net/netlabel/netlabel_kapi.c
+++ b/net/netlabel/netlabel_kapi.c
@@ -196,7 +196,7 @@ int netlbl_cfg_unlbl_map_add(const char *domain,
  * @addr: IP address in network byte order (struct in[6]_addr)
  * @mask: address mask in network byte order (struct in[6]_addr)
  * @family: address family
- * @secid: LSM secid value for the entry
+ * @lsmblob: LSM data value for the entry
  * @audit_info: NetLabel audit information
  *
  * Description:
@@ -210,7 +210,7 @@ int netlbl_cfg_unlbl_static_add(struct net *net,
 				const void *addr,
 				const void *mask,
 				u16 family,
-				u32 secid,
+				struct lsmblob *lsmblob,
 				struct netlbl_audit *audit_info)
 {
 	u32 addr_len;
@@ -230,7 +230,7 @@ int netlbl_cfg_unlbl_static_add(struct net *net,
 
 	return netlbl_unlhsh_add(net,
 				 dev_name, addr, mask, addr_len,
-				 secid, audit_info);
+				 lsmblob, audit_info);
 }
 
 /**
diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index 12e5d508bd08..910a03f15b0d 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -66,7 +66,7 @@ struct netlbl_unlhsh_tbl {
 #define netlbl_unlhsh_addr4_entry(iter) \
 	container_of(iter, struct netlbl_unlhsh_addr4, list)
 struct netlbl_unlhsh_addr4 {
-	u32 secid;
+	struct lsmblob lsmblob;
 
 	struct netlbl_af4list list;
 	struct rcu_head rcu;
@@ -74,7 +74,7 @@ struct netlbl_unlhsh_addr4 {
 #define netlbl_unlhsh_addr6_entry(iter) \
 	container_of(iter, struct netlbl_unlhsh_addr6, list)
 struct netlbl_unlhsh_addr6 {
-	u32 secid;
+	struct lsmblob lsmblob;
 
 	struct netlbl_af6list list;
 	struct rcu_head rcu;
@@ -220,7 +220,7 @@ static struct netlbl_unlhsh_iface *netlbl_unlhsh_search_iface(int ifindex)
  * @iface: the associated interface entry
  * @addr: IPv4 address in network byte order
  * @mask: IPv4 address mask in network byte order
- * @secid: LSM secid value for entry
+ * @lsmblob: LSM data value for entry
  *
  * Description:
  * Add a new address entry into the unlabeled connection hash table using the
@@ -231,7 +231,7 @@ static struct netlbl_unlhsh_iface *netlbl_unlhsh_search_iface(int ifindex)
 static int netlbl_unlhsh_add_addr4(struct netlbl_unlhsh_iface *iface,
 				   const struct in_addr *addr,
 				   const struct in_addr *mask,
-				   u32 secid)
+				   struct lsmblob *lsmblob)
 {
 	int ret_val;
 	struct netlbl_unlhsh_addr4 *entry;
@@ -243,7 +243,7 @@ static int netlbl_unlhsh_add_addr4(struct netlbl_unlhsh_iface *iface,
 	entry->list.addr = addr->s_addr & mask->s_addr;
 	entry->list.mask = mask->s_addr;
 	entry->list.valid = 1;
-	entry->secid = secid;
+	entry->lsmblob = *lsmblob;
 
 	spin_lock(&netlbl_unlhsh_lock);
 	ret_val = netlbl_af4list_add(&entry->list, &iface->addr4_list);
@@ -260,7 +260,7 @@ static int netlbl_unlhsh_add_addr4(struct netlbl_unlhsh_iface *iface,
  * @iface: the associated interface entry
  * @addr: IPv6 address in network byte order
  * @mask: IPv6 address mask in network byte order
- * @secid: LSM secid value for entry
+ * @lsmblob: LSM data value for entry
  *
  * Description:
  * Add a new address entry into the unlabeled connection hash table using the
@@ -271,7 +271,7 @@ static int netlbl_unlhsh_add_addr4(struct netlbl_unlhsh_iface *iface,
 static int netlbl_unlhsh_add_addr6(struct netlbl_unlhsh_iface *iface,
 				   const struct in6_addr *addr,
 				   const struct in6_addr *mask,
-				   u32 secid)
+				   struct lsmblob *lsmblob)
 {
 	int ret_val;
 	struct netlbl_unlhsh_addr6 *entry;
@@ -287,7 +287,7 @@ static int netlbl_unlhsh_add_addr6(struct netlbl_unlhsh_iface *iface,
 	entry->list.addr.s6_addr32[3] &= mask->s6_addr32[3];
 	entry->list.mask = *mask;
 	entry->list.valid = 1;
-	entry->secid = secid;
+	entry->lsmblob = *lsmblob;
 
 	spin_lock(&netlbl_unlhsh_lock);
 	ret_val = netlbl_af6list_add(&entry->list, &iface->addr6_list);
@@ -366,7 +366,7 @@ int netlbl_unlhsh_add(struct net *net,
 		      const void *addr,
 		      const void *mask,
 		      u32 addr_len,
-		      u32 secid,
+		      struct lsmblob *lsmblob,
 		      struct netlbl_audit *audit_info)
 {
 	int ret_val;
@@ -375,7 +375,6 @@ int netlbl_unlhsh_add(struct net *net,
 	struct netlbl_unlhsh_iface *iface;
 	struct audit_buffer *audit_buf = NULL;
 	struct lsmcontext context;
-	struct lsmblob blob;
 
 	if (addr_len != sizeof(struct in_addr) &&
 	    addr_len != sizeof(struct in6_addr))
@@ -408,7 +407,7 @@ int netlbl_unlhsh_add(struct net *net,
 		const struct in_addr *addr4 = addr;
 		const struct in_addr *mask4 = mask;
 
-		ret_val = netlbl_unlhsh_add_addr4(iface, addr4, mask4, secid);
+		ret_val = netlbl_unlhsh_add_addr4(iface, addr4, mask4, lsmblob);
 		if (audit_buf != NULL)
 			netlbl_af4list_audit_addr(audit_buf, 1,
 						  dev_name,
@@ -421,7 +420,7 @@ int netlbl_unlhsh_add(struct net *net,
 		const struct in6_addr *addr6 = addr;
 		const struct in6_addr *mask6 = mask;
 
-		ret_val = netlbl_unlhsh_add_addr6(iface, addr6, mask6, secid);
+		ret_val = netlbl_unlhsh_add_addr6(iface, addr6, mask6, lsmblob);
 		if (audit_buf != NULL)
 			netlbl_af6list_audit_addr(audit_buf, 1,
 						  dev_name,
@@ -438,11 +437,7 @@ int netlbl_unlhsh_add(struct net *net,
 unlhsh_add_return:
 	rcu_read_unlock();
 	if (audit_buf != NULL) {
-		/* lsmblob_init() puts secid into all of the secids in blob.
-		 * security_secid_to_secctx() will know which security module
-		 * to use to create the secctx.  */
-		lsmblob_init(&blob, secid);
-		if (security_secid_to_secctx(&blob, &context) == 0) {
+		if (security_secid_to_secctx(lsmblob, &context) == 0) {
 			audit_log_format(audit_buf, " sec_obj=%s",
 					 context.context);
 			security_release_secctx(&context);
@@ -477,7 +472,6 @@ static int netlbl_unlhsh_remove_addr4(struct net *net,
 	struct audit_buffer *audit_buf;
 	struct net_device *dev;
 	struct lsmcontext context;
-	struct lsmblob blob;
 
 	spin_lock(&netlbl_unlhsh_lock);
 	list_entry = netlbl_af4list_remove(addr->s_addr, mask->s_addr,
@@ -496,13 +490,8 @@ static int netlbl_unlhsh_remove_addr4(struct net *net,
 					  (dev != NULL ? dev->name : NULL),
 					  addr->s_addr, mask->s_addr);
 		dev_put(dev);
-		/* lsmblob_init() puts entry->secid into all of the secids
-		 * in blob. security_secid_to_secctx() will know which
-		 * security module to use to create the secctx.  */
-		if (entry != NULL)
-			lsmblob_init(&blob, entry->secid);
 		if (entry != NULL &&
-		    security_secid_to_secctx(&blob, &context) == 0) {
+		    security_secid_to_secctx(&entry->lsmblob, &context) == 0) {
 			audit_log_format(audit_buf, " sec_obj=%s",
 					 context.context);
 			security_release_secctx(&context);
@@ -543,7 +532,6 @@ static int netlbl_unlhsh_remove_addr6(struct net *net,
 	struct audit_buffer *audit_buf;
 	struct net_device *dev;
 	struct lsmcontext context;
-	struct lsmblob blob;
 
 	spin_lock(&netlbl_unlhsh_lock);
 	list_entry = netlbl_af6list_remove(addr, mask, &iface->addr6_list);
@@ -561,13 +549,8 @@ static int netlbl_unlhsh_remove_addr6(struct net *net,
 					  (dev != NULL ? dev->name : NULL),
 					  addr, mask);
 		dev_put(dev);
-		/* lsmblob_init() puts entry->secid into all of the secids
-		 * in blob. security_secid_to_secctx() will know which
-		 * security module to use to create the secctx.  */
-		if (entry != NULL)
-			lsmblob_init(&blob, entry->secid);
 		if (entry != NULL &&
-		    security_secid_to_secctx(&blob, &context) == 0) {
+		    security_secid_to_secctx(&entry->lsmblob, &context) == 0) {
 			audit_log_format(audit_buf, " sec_obj=%s",
 					 context.context);
 			security_release_secctx(&context);
@@ -921,14 +904,8 @@ static int netlbl_unlabel_staticadd(struct sk_buff *skb,
 	if (ret_val != 0)
 		return ret_val;
 
-	/* netlbl_unlhsh_add will be changed to pass a struct lsmblob *
-	 * instead of a u32 later in this patch set. security_secctx_to_secid()
-	 * will only be setting one entry in the lsmblob struct, so it is
-	 * safe to use lsmblob_value() to get that one value. */
-
-	return netlbl_unlhsh_add(&init_net,
-				 dev_name, addr, mask, addr_len,
-				 lsmblob_value(&blob), &audit_info);
+	return netlbl_unlhsh_add(&init_net, dev_name, addr, mask, addr_len,
+				 &blob, &audit_info);
 }
 
 /**
@@ -975,11 +952,8 @@ static int netlbl_unlabel_staticadddef(struct sk_buff *skb,
 	if (ret_val != 0)
 		return ret_val;
 
-	/* security_secctx_to_secid() will only put one secid into the lsmblob
-	 * so it's safe to use lsmblob_value() to get the secid. */
-	return netlbl_unlhsh_add(&init_net,
-				 NULL, addr, mask, addr_len,
-				 lsmblob_value(&blob), &audit_info);
+	return netlbl_unlhsh_add(&init_net, NULL, addr, mask, addr_len, &blob,
+				 &audit_info);
 }
 
 /**
@@ -1091,8 +1065,7 @@ static int netlbl_unlabel_staticlist_gen(u32 cmd,
 	struct net_device *dev;
 	struct lsmcontext context;
 	void *data;
-	u32 secid;
-	struct lsmblob blob;
+	struct lsmblob *lsmb;
 
 	data = genlmsg_put(cb_arg->skb, NETLINK_CB(cb_arg->nl_cb->skb).portid,
 			   cb_arg->seq, &netlbl_unlabel_gnl_family,
@@ -1130,7 +1103,7 @@ static int netlbl_unlabel_staticlist_gen(u32 cmd,
 		if (ret_val != 0)
 			goto list_cb_failure;
 
-		secid = addr4->secid;
+		lsmb = (struct lsmblob *)&addr4->lsmblob;
 	} else {
 		ret_val = nla_put_in6_addr(cb_arg->skb,
 					   NLBL_UNLABEL_A_IPV6ADDR,
@@ -1144,14 +1117,10 @@ static int netlbl_unlabel_staticlist_gen(u32 cmd,
 		if (ret_val != 0)
 			goto list_cb_failure;
 
-		secid = addr6->secid;
+		lsmb = (struct lsmblob *)&addr6->lsmblob;
 	}
 
-	/* lsmblob_init() secid into all of the secids in blob.
-	 * security_secid_to_secctx() will know which security module
-	 * to use to create the secctx.  */
-	lsmblob_init(&blob, secid);
-	ret_val = security_secid_to_secctx(&blob, &context);
+	ret_val = security_secid_to_secctx(lsmb, &context);
 	if (ret_val != 0)
 		goto list_cb_failure;
 	ret_val = nla_put(cb_arg->skb,
@@ -1510,7 +1479,7 @@ int netlbl_unlabel_getattr(const struct sk_buff *skb,
 					      &iface->addr4_list);
 		if (addr4 == NULL)
 			goto unlabel_getattr_nolabel;
-		secattr->attr.secid = netlbl_unlhsh_addr4_entry(addr4)->secid;
+		secattr->attr.lsmblob = netlbl_unlhsh_addr4_entry(addr4)->lsmblob;
 		break;
 	}
 #if IS_ENABLED(CONFIG_IPV6)
@@ -1523,7 +1492,7 @@ int netlbl_unlabel_getattr(const struct sk_buff *skb,
 					      &iface->addr6_list);
 		if (addr6 == NULL)
 			goto unlabel_getattr_nolabel;
-		secattr->attr.secid = netlbl_unlhsh_addr6_entry(addr6)->secid;
+		secattr->attr.lsmblob = netlbl_unlhsh_addr6_entry(addr6)->lsmblob;
 		break;
 	}
 #endif /* IPv6 */
diff --git a/net/netlabel/netlabel_unlabeled.h b/net/netlabel/netlabel_unlabeled.h
index 058e3a285d56..168920780994 100644
--- a/net/netlabel/netlabel_unlabeled.h
+++ b/net/netlabel/netlabel_unlabeled.h
@@ -211,7 +211,7 @@ int netlbl_unlhsh_add(struct net *net,
 		      const void *addr,
 		      const void *mask,
 		      u32 addr_len,
-		      u32 secid,
+		      struct lsmblob *lsmblob,
 		      struct netlbl_audit *audit_info);
 int netlbl_unlhsh_remove(struct net *net,
 			 const char *dev_name,
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 332214d17268..aaf602d7daaf 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -6999,7 +6999,7 @@ static int selinux_uring_sqpoll(void)
 }
 #endif /* CONFIG_IO_URING */
 
-static struct lsm_id selinux_lsmid __lsm_ro_after_init = {
+struct lsm_id selinux_lsmid __lsm_ro_after_init = {
 	.lsm  = "selinux",
 	.slot = LSMBLOB_NEEDED
 };
diff --git a/security/selinux/include/security.h b/security/selinux/include/security.h
index 393aff41d3ef..cfd6c1075b16 100644
--- a/security/selinux/include/security.h
+++ b/security/selinux/include/security.h
@@ -75,6 +75,7 @@
 struct netlbl_lsm_secattr;
 
 extern int selinux_enabled_boot;
+extern struct lsm_id selinux_lsmid;
 
 /*
  * type_datum properties
diff --git a/security/selinux/netlabel.c b/security/selinux/netlabel.c
index 800ab4b4239e..0b8f99703462 100644
--- a/security/selinux/netlabel.c
+++ b/security/selinux/netlabel.c
@@ -109,7 +109,7 @@ static struct netlbl_lsm_secattr *selinux_netlbl_sock_getattr(
 		return NULL;
 
 	if ((secattr->flags & NETLBL_SECATTR_SECID) &&
-	    (secattr->attr.secid == sid))
+	    (secattr->attr.lsmblob.secid[selinux_lsmid.slot] == sid))
 		return secattr;
 
 	return NULL;
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index 69b2734311a6..b4a0570b48bb 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -3896,7 +3896,7 @@ int security_netlbl_secattr_to_sid(struct selinux_state *state,
 	if (secattr->flags & NETLBL_SECATTR_CACHE)
 		*sid = *(u32 *)secattr->cache->data;
 	else if (secattr->flags & NETLBL_SECATTR_SECID)
-		*sid = secattr->attr.secid;
+		*sid = secattr->attr.lsmblob.secid[selinux_lsmid.slot];
 	else if (secattr->flags & NETLBL_SECATTR_MLS_LVL) {
 		rc = -EIDRM;
 		ctx = sidtab_search(sidtab, SECINITSID_NETMSG);
@@ -3974,7 +3974,7 @@ int security_netlbl_sid_to_secattr(struct selinux_state *state,
 	if (secattr->domain == NULL)
 		goto out;
 
-	secattr->attr.secid = sid;
+	secattr->attr.lsmblob.secid[selinux_lsmid.slot] = sid;
 	secattr->flags |= NETLBL_SECATTR_DOMAIN_CPY | NETLBL_SECATTR_SECID;
 	mls_export_netlbl_lvl(policydb, ctx, secattr);
 	rc = mls_export_netlbl_cat(policydb, ctx, secattr);
diff --git a/security/smack/smack.h b/security/smack/smack.h
index ef9d0b7b1954..ac79313ea95d 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -303,6 +303,7 @@ int smack_populate_secattr(struct smack_known *skp);
  * Shared data.
  */
 extern int smack_enabled __initdata;
+extern struct lsm_id smack_lsmid;
 extern int smack_cipso_direct;
 extern int smack_cipso_mapped;
 extern struct smack_known *smack_net_ambient;
diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
index d2186e2757be..c6dcafe18912 100644
--- a/security/smack/smack_access.c
+++ b/security/smack/smack_access.c
@@ -524,7 +524,7 @@ int smack_populate_secattr(struct smack_known *skp)
 {
 	int slen;
 
-	skp->smk_netlabel.attr.secid = skp->smk_secid;
+	skp->smk_netlabel.attr.lsmblob.secid[smack_lsmid.slot] = skp->smk_secid;
 	skp->smk_netlabel.domain = skp->smk_known;
 	skp->smk_netlabel.cache = netlbl_secattr_cache_alloc(GFP_ATOMIC);
 	if (skp->smk_netlabel.cache != NULL) {
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 552c4d4d8fac..2190c03ae3d0 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -3728,11 +3728,12 @@ static struct smack_known *smack_from_secattr(struct netlbl_lsm_secattr *sap,
 	if ((sap->flags & NETLBL_SECATTR_CACHE) != 0)
 		return (struct smack_known *)sap->cache->data;
 
+	/*
+	 * Looks like a fallback, which gives us a secid.
+	 */
 	if ((sap->flags & NETLBL_SECATTR_SECID) != 0)
-		/*
-		 * Looks like a fallback, which gives us a secid.
-		 */
-		return smack_from_secid(sap->attr.secid);
+		return smack_from_secid(
+				sap->attr.lsmblob.secid[smack_lsmid.slot]);
 
 	if ((sap->flags & NETLBL_SECATTR_MLS_LVL) != 0) {
 		/*
@@ -4751,7 +4752,7 @@ struct lsm_blob_sizes smack_blob_sizes __lsm_ro_after_init = {
 	.lbs_superblock = sizeof(struct superblock_smack),
 };
 
-static struct lsm_id smack_lsmid __lsm_ro_after_init = {
+struct lsm_id smack_lsmid __lsm_ro_after_init = {
 	.lsm  = "smack",
 	.slot = LSMBLOB_NEEDED
 };
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 4b58526450d4..314336463111 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -1144,6 +1144,7 @@ static void smk_net4addr_insert(struct smk_net4addr *new)
 static ssize_t smk_write_net4addr(struct file *file, const char __user *buf,
 				size_t count, loff_t *ppos)
 {
+	struct lsmblob lsmblob;
 	struct smk_net4addr *snp;
 	struct sockaddr_in newname;
 	char *smack;
@@ -1274,10 +1275,13 @@ static ssize_t smk_write_net4addr(struct file *file, const char __user *buf,
 	 * this host so that incoming packets get labeled.
 	 * but only if we didn't get the special CIPSO option
 	 */
-	if (rc == 0 && skp != NULL)
+	if (rc == 0 && skp != NULL) {
+		lsmblob_init(&lsmblob, 0);
+		lsmblob.secid[smack_lsmid.slot] = snp->smk_label->smk_secid;
 		rc = netlbl_cfg_unlbl_static_add(&init_net, NULL,
-			&snp->smk_host, &snp->smk_mask, PF_INET,
-			snp->smk_label->smk_secid, &audit_info);
+			&snp->smk_host, &snp->smk_mask, PF_INET, &lsmblob,
+			&audit_info);
+	}
 
 	if (rc == 0)
 		rc = count;
-- 
2.36.1

