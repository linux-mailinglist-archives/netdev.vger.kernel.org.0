Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1340333299E
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 16:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbhCIPEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 10:04:24 -0500
Received: from sonic313-14.consmr.mail.ne1.yahoo.com ([66.163.185.37]:33517
        "EHLO sonic313-14.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231663AbhCIPEA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 10:04:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1615302239; bh=9wegpK8mcknK8Y5IEmc097UBLFU5IwOBWqh7JzNqZu0=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=qoJkwcQB7ZeMEJ8EBzrmUYQr9lDLm91ewDkxP14+JfVo2oI1ZqHEGCCWEcLT8LIgqcwYfzRqt/6xIU567swBq0yPUDo9C6ptDP1UKoZnrcGvMN6lwkFARO+nK5kI1DIKtRrTjCP2bD/ZSd7NlPCqUGUeiEcRARGN+eZC1xsjHA/9Jui1Tuzgdr0R7TgGgZUtnKfT+nm+4dWi/npUenUYv2usOQY09kOxcs+S/AkzLtZvAExttBZFUEroC9y76ZO9N0S8BTBTKNpPciCQE/pKZ/CMTbIirLl7Cv55IgHIcfBBtfilheY2xfkjk0q6Do/ZRZ7DVGTvP1sWPb5Hfc04+g==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1615302239; bh=0B4ffJrTIEvbHdwZkcQ8VCmOwBXpbEUrmJ6Ltg4rzd5=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=Lid4IBEMy+zNAZC8/7YagoUsFOvmtw1a5t0wuCcWrtV7DiZVVyaKPlW0iBPgqRk2ian0N9zbhoSs7rH1F/gXdOAix42cFYcgUiWwa/2AUK6fXiXpvZ4y+rUb8uZBXnpBzArEyY5iH9K1D5t8P+MyOpF8rsrRWlhbmDqK+imzuRwWxONQT4H/vbW0y359HBr6H25OVEKnm821u5yTz5UQ6gDyUNfDdA596oRwL8GmoR6R7uq/BpMxAN/gQ8vZzKnr/XQdeaNRy+EtQOzErL/uxCmDg7G2J/R+Z+lZuhezyo1Q0g/JLn/Nb+wK2bhMaciwKLxY6ZTP3D5s0w7laBQwxw==
X-YMail-OSG: nboaL0kVM1k1RwIHGVXVIryo1sU1ZXSJIYX3nZLRexEcDMcwtrCGm_KlDhAvjq1
 6u9BECldpwsGeZaG6UX8LrnGXWukOumArGEyApIXfsLWLBWZyvafIkTSDK6ISG07vd2pGg__QbIf
 7FaUKEcDLDY7rkE8JKfq4IGKUIdSekjoiigTJ29xg5bOW_0gT7efY45LY_0Ncc_i5f.NjInpnxPg
 a1Hab3STQjBvO5.MjG601zb8mOwL9.YJTR3QAH_ZoCXOFWmb5KCRoWNPcisTOzRggAQAqPf7WEpY
 qPPA2zX3fI8NyqBPVHQryGyywTK1dBo6sxxEdbRH.14jycY6KtPTd0TvEJslgLnh8m4_kgn.seOH
 vYh3th4Cep7M3VpZ4P9vOjeOfu7NzAHWONGQWA9sAtQnW3zkkSanzUV7S50RR6eaunVIuM.alOKu
 iScqr5YvePAAuvFMwSBM6bLwHcAJ1kJJ4QZgnouEz24NQ30v7QKjz3spXxc8X4rDFrPa8_6JComM
 nIOoKubTO8WEnM06_9bRtEs58q4PmskJ9iyJGeGavHtjS1P_DTAo.IQxrTMZy2C.x.2hN4WKOZSS
 WTcSVPMJbmhEszZmbuVp7LQGrnorCeaVLHqEbHrhTwpH2ODj2oLoLb83gbzhwmj4wsoD173U8o2D
 .z0C_NcqrSbQHlzOctQ2di6vwVBztdMKeogxoLJzyesDRkICg4r4pXD2az2HPI3s9VyGJXXlHf5c
 m7L642vOkWYeS1bcO8WJRvzkopWtFP1_DHe9jGC4DTWmmL6LcarK4mevEvwBoJHs1PJ.FtuOtVCB
 Wmi4RXYmUzICSLMzUXV59qUf9t7madKcv7gGEUp.Teon2NesezH2xPBFCklbwVY6lUaaJKFA9uvv
 fx9UgL6WHCQHa3h.mBOloss0nkDKbJu1tDmGndNTxfxsZX9EYy6dc5.kFoXryGPPz8KDTJwGrM_f
 RQx.ogn4VPp0nvBUYRWnJmI6poGyb_986zYDBHzM2iow5ypZHYBtBjOIIILIXBkCUID_.YDDrjf3
 hDI_n9vVjenNhsfzMaqOCOv3BJjdFdW931MJrji5dXrdpry7nbiTviYDxmRGAqaJeLbTVJBj24sC
 rzAXI9m_AeZInWd5Q0ix1hPKKHDzY8uwuvrDA6nd1LBbi53l0rWZ90Omk6t.EFUgZpPYXyUQcDrO
 acsILcJjeMlgEY4I0HOd0XFndYbFfQLH4OgSOhGev4vNSTk_tVOveAU.Wk4fSRGuOqXkVAP41RUJ
 gtK2c_SA0CSr5NpupFP_m3v7YGHik8B8OrgV5XdUI6rOUynPCkNT4lm1gKC4GOYfkJrNcFi3Wk9_
 m.4BUou4LzV5hRL8TcVXoKf4Q2bI7pR1vijqkfLnJe86hAQf3DPUr957yzLWPeREJy9tmy6Be5ic
 ISN5ZxdORRxshk93V1AVhC6RIs81zIGn62KZmJ.YulZUD8AebdB.AkH.vWx45BrvRJ5tfke2MiAH
 qttwUvkgk3JxcJr3XxdNvb66xfQ_VxIFe24Uv8PuR6AsCvCAHyjH4dkMQyk4aV_HnO7wCdOuXqjr
 gNqah7eH4Sw_p3kpbXka4PDEqfAh3hyIE6lVhFtbcEVQUv5hgwCRZ12peLvjBIRhOTeAtuQxNDh.
 HzyaW7dit2Yggwlx7A64jBHXBoU0aNqXEcgPwsWHBZFOn3XwqoXt3oasbfIRaeEaSvb8awARWFs1
 D9JzOCB0myHzHLSSFo.Ezq1ovUu2UpMPK.phoBQVuApxS9Jt_3FZR9vfoZGAiJjlZG1_UZ6.jbUQ
 sQ3MQELDV8448jYxZXjuKJiy4XLLZManYZQiGU5RE8w3bXTgWa22P9mxpnHyaJSR0huyouhsdbeE
 xCEmEXuHvHcWFd9Kn5416888NGInAnm7R.Mp2bJTT_OA83Ji3UBvksB_alm2mDV394.D2HYNENz8
 6Cg3qA_dB0B57.TlncjAMeMZeFdabMqddzF6PFufnhisl_ZpUqv3URgIy43isUTROw3UJZVPCggz
 y4bKNKx2NBspBGznjwtXqtBdzUkFIhOP65_G4.PGICa4maamZsuBRUDJMvzhmtu55kZN4vohr5qJ
 Wc7f8aXjUwE4TYatvwooEH.NdzKNB8.RQAOT0e1Ejjy9uGcZWOBzAk9X8eBqNQwmCemM3a0wUwNk
 priGJvGCsbRSijF1NlAHYZdL8m8IaemtWhN2ayfa.D8Ar9sy4Fu_0Ib5HvT5Hj3gfgx7K143e72B
 dkP_bvIZPVRGIj3mPcYX6t856u9_tRxPGTIk5opYFGcyKNXVlxcmD3ETx7bgn7mQG6aBmLvLtCyu
 05P6YkgDjqAXzbNe2YBIoSvFEai17vzyPwaLAVR4gjUtFcTusHAgwlxk_amq742DfpiN1pXDSplI
 XZ05ctIfAFET6S561N6JZyf6CnNhFmKebozJpSRZsCoQDAGjc9X8y1gNECDj.NNv.CPZYqCUALoI
 xyMNCNduQoShMGIBI_GEnA_DQqUQgfdvbtMHFiIA1leE8V_k.GvmhXmt9rsKEaU9JT1iQtcBbcO8
 9hbj6VZE1yY8DJdVQSKrjUs95pPnQuayz8TfV6TN81_J9r95a_oF9IAA6uOKHKyfKPLHBPYBJX1g
 lE_7EJrl.tIA.COhNUCLkW88sDo1WZZdEa_fNn_4iOwc9OWX2jncezYSsceBHSNUVoriS9AmMpZd
 njKeDWaZY2W6LsjxjzfPzzMKGRXzEDKAmgdPZwq15kLZiaVur5nrEQxlBsy3tSBkH59IY870Be2E
 PvUr1K0qu9XC4_Y0ylhMcY6Atk3.voDqU0g02_LcRugkCArcodphgoqFWGITRX5kdvqOBqtDHUiR
 xHJS3QXnuYBOhpYfe6vRL5lNDvZO5OQX8Ve9tvlAGSILVWvYWljDKlseBmPqtRko7u_gp6yc1jGy
 Ue4JHoP2HdyfYp.0Ez02GWK1Z5QLoSW2x8vG5nk3FomUCQ7IpriPNss2NYXgQoQAOhLN8uk91SCk
 BKfeMdsdtWYWMQAcC1ApQcQkVCicpzJceCFie9eyn1ImvoZYZNpEJTfbKevuuv4NSLahIZvA5wGe
 2Bb8JXYFhCRMwZnqucs92kZrmj9FQCSh8OVfFp4StPSrLiWkDLGSGxuelK7Q1uMp.LxM.5TtsVZS
 tu3Ck6BF1YGHVNMqQPy5nBBS7D22_XUbiTih2Ka3FtA--
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.ne1.yahoo.com with HTTP; Tue, 9 Mar 2021 15:03:59 +0000
Received: by smtp411.mail.bf1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 17705197e2b5b17aa17bfa4b643bbb4f;
          Tue, 09 Mar 2021 15:03:54 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v25 19/25] NET: Store LSM netlabel data in a lsmblob
Date:   Tue,  9 Mar 2021 06:42:37 -0800
Message-Id: <20210309144243.12519-20-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210309144243.12519-1-casey@schaufler-ca.com>
References: <20210309144243.12519-1-casey@schaufler-ca.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
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
index 471d33a0d095..1ac343d02b58 100644
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
@@ -1469,7 +1471,11 @@ static int cipso_v4_gentag_loc(const struct cipso_v4_doi *doi_def,
 
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
@@ -1489,7 +1495,7 @@ static int cipso_v4_parsetag_loc(const struct cipso_v4_doi *doi_def,
 				 const unsigned char *tag,
 				 struct netlbl_lsm_secattr *secattr)
 {
-	secattr->attr.secid = *(u32 *)&tag[2];
+	memcpy(&secattr->attr.lsmblob, &tag[2], sizeof(secattr->attr.lsmblob));
 	secattr->flags |= NETLBL_SECATTR_SECID;
 
 	return 0;
diff --git a/net/netlabel/netlabel_kapi.c b/net/netlabel/netlabel_kapi.c
index 5e1239cef000..bbfaff539416 100644
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
index aa53a94115f4..3befe0738d31 100644
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
@@ -497,13 +491,8 @@ static int netlbl_unlhsh_remove_addr4(struct net *net,
 					  addr->s_addr, mask->s_addr);
 		if (dev != NULL)
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
@@ -544,7 +533,6 @@ static int netlbl_unlhsh_remove_addr6(struct net *net,
 	struct audit_buffer *audit_buf;
 	struct net_device *dev;
 	struct lsmcontext context;
-	struct lsmblob blob;
 
 	spin_lock(&netlbl_unlhsh_lock);
 	list_entry = netlbl_af6list_remove(addr, mask, &iface->addr6_list);
@@ -563,13 +551,8 @@ static int netlbl_unlhsh_remove_addr6(struct net *net,
 					  addr, mask);
 		if (dev != NULL)
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
@@ -923,14 +906,8 @@ static int netlbl_unlabel_staticadd(struct sk_buff *skb,
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
@@ -977,11 +954,8 @@ static int netlbl_unlabel_staticadddef(struct sk_buff *skb,
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
@@ -1093,8 +1067,7 @@ static int netlbl_unlabel_staticlist_gen(u32 cmd,
 	struct net_device *dev;
 	struct lsmcontext context;
 	void *data;
-	u32 secid;
-	struct lsmblob blob;
+	struct lsmblob *lsmb;
 
 	data = genlmsg_put(cb_arg->skb, NETLINK_CB(cb_arg->nl_cb->skb).portid,
 			   cb_arg->seq, &netlbl_unlabel_gnl_family,
@@ -1132,7 +1105,7 @@ static int netlbl_unlabel_staticlist_gen(u32 cmd,
 		if (ret_val != 0)
 			goto list_cb_failure;
 
-		secid = addr4->secid;
+		lsmb = (struct lsmblob *)&addr4->lsmblob;
 	} else {
 		ret_val = nla_put_in6_addr(cb_arg->skb,
 					   NLBL_UNLABEL_A_IPV6ADDR,
@@ -1146,14 +1119,10 @@ static int netlbl_unlabel_staticlist_gen(u32 cmd,
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
@@ -1512,7 +1481,7 @@ int netlbl_unlabel_getattr(const struct sk_buff *skb,
 					      &iface->addr4_list);
 		if (addr4 == NULL)
 			goto unlabel_getattr_nolabel;
-		secattr->attr.secid = netlbl_unlhsh_addr4_entry(addr4)->secid;
+		secattr->attr.lsmblob = netlbl_unlhsh_addr4_entry(addr4)->lsmblob;
 		break;
 	}
 #if IS_ENABLED(CONFIG_IPV6)
@@ -1525,7 +1494,7 @@ int netlbl_unlabel_getattr(const struct sk_buff *skb,
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
index 3141ed8544de..5ed2164ea0e4 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -7045,7 +7045,7 @@ static int selinux_perf_event_write(struct perf_event *event)
 }
 #endif
 
-static struct lsm_id selinux_lsmid __lsm_ro_after_init = {
+struct lsm_id selinux_lsmid __lsm_ro_after_init = {
 	.lsm  = "selinux",
 	.slot = LSMBLOB_NEEDED
 };
diff --git a/security/selinux/include/security.h b/security/selinux/include/security.h
index 6fe25300b89d..76c251c49398 100644
--- a/security/selinux/include/security.h
+++ b/security/selinux/include/security.h
@@ -73,6 +73,7 @@
 struct netlbl_lsm_secattr;
 
 extern int selinux_enabled_boot;
+extern struct lsm_id selinux_lsmid;
 
 /*
  * type_datum properties
diff --git a/security/selinux/netlabel.c b/security/selinux/netlabel.c
index 6a94b31b5472..d8d7603ab14e 100644
--- a/security/selinux/netlabel.c
+++ b/security/selinux/netlabel.c
@@ -108,7 +108,7 @@ static struct netlbl_lsm_secattr *selinux_netlbl_sock_getattr(
 		return NULL;
 
 	if ((secattr->flags & NETLBL_SECATTR_SECID) &&
-	    (secattr->attr.secid == sid))
+	    (secattr->attr.lsmblob.secid[selinux_lsmid.slot] == sid))
 		return secattr;
 
 	return NULL;
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index 3438d0130378..c183492dd48f 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -3785,7 +3785,7 @@ int security_netlbl_secattr_to_sid(struct selinux_state *state,
 	if (secattr->flags & NETLBL_SECATTR_CACHE)
 		*sid = *(u32 *)secattr->cache->data;
 	else if (secattr->flags & NETLBL_SECATTR_SECID)
-		*sid = secattr->attr.secid;
+		*sid = secattr->attr.lsmblob.secid[selinux_lsmid.slot];
 	else if (secattr->flags & NETLBL_SECATTR_MLS_LVL) {
 		rc = -EIDRM;
 		ctx = sidtab_search(sidtab, SECINITSID_NETMSG);
@@ -3861,7 +3861,7 @@ int security_netlbl_sid_to_secattr(struct selinux_state *state,
 	if (secattr->domain == NULL)
 		goto out;
 
-	secattr->attr.secid = sid;
+	secattr->attr.lsmblob.secid[selinux_lsmid.slot] = sid;
 	secattr->flags |= NETLBL_SECATTR_DOMAIN_CPY | NETLBL_SECATTR_SECID;
 	mls_export_netlbl_lvl(policydb, ctx, secattr);
 	rc = mls_export_netlbl_cat(policydb, ctx, secattr);
diff --git a/security/smack/smack.h b/security/smack/smack.h
index 0f8d0feb89a4..b06fc332a1f9 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -303,6 +303,7 @@ int smack_populate_secattr(struct smack_known *skp);
  * Shared data.
  */
 extern int smack_enabled;
+extern struct lsm_id smack_lsmid;
 extern int smack_cipso_direct;
 extern int smack_cipso_mapped;
 extern struct smack_known *smack_net_ambient;
diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
index 7eabb448acab..fccd5da3014e 100644
--- a/security/smack/smack_access.c
+++ b/security/smack/smack_access.c
@@ -522,7 +522,7 @@ int smack_populate_secattr(struct smack_known *skp)
 {
 	int slen;
 
-	skp->smk_netlabel.attr.secid = skp->smk_secid;
+	skp->smk_netlabel.attr.lsmblob.secid[smack_lsmid.slot] = skp->smk_secid;
 	skp->smk_netlabel.domain = skp->smk_known;
 	skp->smk_netlabel.cache = netlbl_secattr_cache_alloc(GFP_ATOMIC);
 	if (skp->smk_netlabel.cache != NULL) {
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 576f412b8616..1c14983f87c7 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -3723,11 +3723,12 @@ static struct smack_known *smack_from_secattr(struct netlbl_lsm_secattr *sap,
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
@@ -4703,7 +4704,7 @@ struct lsm_blob_sizes smack_blob_sizes __lsm_ro_after_init = {
 	.lbs_sock = sizeof(struct socket_smack),
 };
 
-static struct lsm_id smack_lsmid __lsm_ro_after_init = {
+struct lsm_id smack_lsmid __lsm_ro_after_init = {
 	.lsm  = "smack",
 	.slot = LSMBLOB_NEEDED
 };
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 22ded2c26089..e592e10397af 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -1140,6 +1140,7 @@ static void smk_net4addr_insert(struct smk_net4addr *new)
 static ssize_t smk_write_net4addr(struct file *file, const char __user *buf,
 				size_t count, loff_t *ppos)
 {
+	struct lsmblob lsmblob;
 	struct smk_net4addr *snp;
 	struct sockaddr_in newname;
 	char *smack;
@@ -1271,10 +1272,13 @@ static ssize_t smk_write_net4addr(struct file *file, const char __user *buf,
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
2.29.2

