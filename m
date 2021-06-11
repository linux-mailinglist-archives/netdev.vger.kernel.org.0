Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD66F3A38AC
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 02:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbhFKA1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 20:27:46 -0400
Received: from sonic311-31.consmr.mail.ne1.yahoo.com ([66.163.188.212]:38428
        "EHLO sonic311-31.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231140AbhFKA1n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 20:27:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1623371146; bh=B6/eTJ18z4eQ+mOCYA8J02+OIxRGwvinHOaRQJDorLg=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=UxPfNlH4Ll+HYAFtOOrURU++m9CFus81AUTZ7jclg1eJSXAjfWBjJAvYjfS1ErkxXsxaR57mcNDv21SK1q789AEFQZcJv0v9Enwo1DoFPVSNjW+fpqZwbwaGCiMVT0s/fNssQuwQGXksRElLRrT5in9wZ0q9X8V6AROADtEjbH0mHKPQOKe1pXrs22Hgp2CgVYGvZzgAHPAkyr9vC9QrRDVgTyKUBRYkpqkx+RXygQpb7kd/0A+JFqmLzJzBn2FUIeYYx1zcZ+rEMNrZCzl47H8sqYXvOBs0RTDSf0jtaO135z4OIY69/inCeh6KDSC+1zIXBhZwlH+5io4s1p/Ptg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1623371146; bh=SgN8XCGj7OU65W5r9ql5GunVdtaIyDzOxSDyo6N9ayX=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=iVIsyAsAI+k0+Ze5zMdgrkXEOU+l1ckmYZbiY7ffU5PrnpiG1/IFSb/9wnjkP3b5wOXuunuaNy1cTYihL3zCIpTzKYDPrtsy+kcV39zb42L6asHBz5O0xU0N01XCbaZtlPiiCxlZ9cgo6YVA7Ylp7FojuV1tWzKNODWIyQ9g6JTeKiA94oLLn6eK12Jr+DIFtSyPU27ybt3p0pSRAXe22Jfw1A6QA+Y6oyszqe5HhITOZ/Nub1D/y7f6ODtSxWJ/RKItBK07N/nLa99JGoU2h9pmlrxnoFrJ7jVPmWxBlW6flTxuBeLMXxPyw/on5JN636F4hv4MO6XT9o/x8+ugSg==
X-YMail-OSG: CP.BRq0VM1mYg7UCoXYtfxYRrQjMW7.8nECBOngBTPm50BO5xYBDBikhXKsRM0N
 MlOlM68Jg9xpgNGAIMvm8Xkvg7KhdbgJavBH1I0Ob6d9576WCzTMDNjbqqpBgzNm7puTYti7toKt
 zCad82E4U0wbtFn_p.ELN0uZls8UHKE1lP1XVQnWn8TlnroQYWscp1R9Ee0A9zhDeZN7Uy6F6IqM
 L6G8vJFQC0xbx_2GcAjV15ixKwvsqP_Y5nnOP0YdpoDpPbHsYw.4SDw1zwMjz9Jz2CRWC8ZHP_SL
 55DlKhweRN1fIoic4z5yWwWufJ_Ke3_cMpecqkeXPkZ.n7_ctaXebt3RFSuQDUMwuH8AC7qcgNsK
 Ego7IYwDfbQbomh9NDFHokfgLQdN.ZX3fQof9GumY3rGTvTRlO5jcl_eJbHeoYJI4NycSogje4Hg
 qj9rxTbKST4wSxnp.rD66TGdeTUqKqcRtLnkaSTMTiaJfe9cukUe72O6g3CNOhQti7CzJRRa.mv_
 l9WOhEfAtUOB0pgjPmhbFFTCHfyxtbaia7Sc_FVeLrormLpxBo7F1v.Qs6zKEaFY_v_Np9mxwT_U
 lovfLiYKWZdvztmyhCd8gTugvPrzkT27bxx5frZXjkyu0RSkfkgXW3tz7JJ0X.WzXw4zovVlHRQB
 AmiHTCuYfsybNG8ZI0o_Ol5cGVR37ggd.JHHfdr_dNtxnbCwFyW1dHUkclUfL9UexFW7oG_zzwQz
 SM3VTjqhQgq0tIeOT7GqlOzul2iGWgmLw6FZ6bCGwa06resooAcc5j0Vw8k6B42w.DfgTLSJ1tQt
 WSQB51_b6v10zxX0d0hiQxgsBHoLyONtAdqFV1ZkFQ_VmxiIL6ZNjrSygijK3zlbpWnJOAYzdi.u
 2j1IfrLNggcrfLhC8UcWVY90kePk0YdBQYKw7R1fgfwpTzTnCx6ZXYObW4q3tTfTGVnV6RJ.EtG1
 2h0tL1X_meIJSg1UOlCIjdiYo.VugnD6LLCLk9Atw76mccfy8DrOsU30HzAFWua_p3wsnKoO4rrB
 _J1e1A07_px_zjnXuN7Lhb8kzZNst2XdrwbqoepsD12m3qXi6Dup6EEQFmy6s7WKlplq4TLzeJLZ
 5M_59BbC0sXZP_3lRCyjt1qw5TZi_2KhY005.l2L_exYP_Jt2S1QtONwfLf1E__zZ5QXGvO0WbFZ
 JDJ13XGf47OyU9kaRKjXWuDli.RgWmA7_SuPfjMIJzXvCQmk6LguFRcCPqEWeRdcyF1Rm9RjGtke
 m3F0lASX0slubhSM.9CKB2bp6mEK76kNgavlKAz_9L8N6Jt_mzq2.6Nur2pZRXUIqLVai27wNiQI
 _3dHcUGMeHvkTenlsmA3xg66LNtzKFxLMF908lGfzMHo6MMlfz6_Ffi47CBcKSZQF.sn4jgC.4qr
 TTDT0eh_bhyAbSuJOyf2barAtCc218Hu4s0ISlREbhJIVBZVZ2M6raeTdNzbNPbq2jvkn7cgHV75
 Ph.ggoTuAV4iZffbuac9eyz_sgUs05f56qKrvuW792lkXygufe23SGvJ2cQ1H5YfyujT_XefUwDg
 kBsDSZx.le0.Cq2EsrkC9cDCiuMc1YURMpIe_y9FZ5HDQsdq_PvfsK.WDDhx0qxHRkDtoubK19MF
 TKRwrufiXCx6yh3YMLmlix9fII9KHpy0UOSPX9rh86OBT8GE39XwGhOSZQ184Mwu6QQaTn5Duoly
 eCINrTHQFVPH5cZ_3zYFJG9afAd4F16YXxMUqOsaJOoPRCgtslg_K.3Ksab20PJ7vDrBLd3HYKlO
 6iJt2EcdJk8tXVg.LJoqHgZYj9llTQR_Ea2toSPusWIxLIC6Htl0xztXzHtofQM_nJqsSxme2Vqi
 0tY.xWX1El8QI075t7RwljwGqSKLcGvDWRTGqnw1bvjdDTSLTFbC1hUM5zIbkLPB.0Gd6W55KEu2
 2Ho.7.Wptec71xfW7rRGKLGt6TSuOLRqYN_y3FAcx9mFCYL8RN1DiNA_EbN8WtXvYuHiGKOTERuv
 KRrB6FA90MldqJhPCFl6MHCP90PvIjYBlpJ7ODFfHSueHS.0cVpJde1ByNSq34wnmKNF0Qgh_vQl
 iC6T.mAnKkJFId3M_KjPMZBQHHiGHR2kD4F3rfCp8Ha7sS7dbIsbM6YXCQNYT2ak1KkZMf2kn1gO
 vaKstGwjpAS5LcV6NK.mzdig3ahorVdhR32egHHzXK7tzCyvDYvQUS7bUpcvOS1g7G51rJBlUS05
 qnjYQt_mkvQOiemBWFKFNoxpgEYqc_Myr_LJf019JW.qYCmjbIrfPVSYSQAJ6fJgUYvJC6Mi6osz
 Le.ZnYZK.ySN5NDYOfao413lKxIB65Bag99w3UHBiAvHKW6My3Gz52bLACMajjG7Hn2btscJ_bjW
 1_OL2e.mheF8wg3Q71NUW4Vg4BG_NMltLiD.97hMW1oDnzuIhiu.5pkijDkzPoi79rsTqPgpEZE6
 t7pORwaYkZTotssnMpsu5eeSmrro6zhuQcaTux_9ja5u4p.rchH8nI.IbPcGTI7cfVcMqHUqBq8E
 ELRZbJ5Wajh6BxdQC5Q.v_Q3A5g7xefboQi7lKWOA66kZ8eKiWWTQ_t7jXWMJ_yiFbo.Tv0SBgir
 idFXjxzzJT3rioHVny3wWpneufQVVEnDB74pVkYGOuuNXQZfmAV7Yf_4H.lCygiV8AIe3ckTH2JM
 LJQubaBhtbxW.izL3Z5VE5pIgEGG2._Rx1EvAkP.Z0E_3Dm5cvGMWi0GulhyoVvJCVt.hSqmJaIj
 90GgOSqSRPKmcd4FEvLhgMT4vJZmzzWWXDGCpYgCXtHWOmo0OvNrm2ScBOqx3x03A3lydkbtZ.rH
 NUMjt9w749hM8Co48bf_xjh_fiPwyRKZMdSzQXGQbAXy5rV1AbRRq_MDXs7hs0ml7EfK06m1y_hy
 tvGPMk_dooLHV1YNod_LOeRM.p7Gpwj2JsYpTkhVnngzlF0hnyd0Q5OMWC7.ypDcrgHtYUJzIGuJ
 uN677FrWhrBM_E_j.afPbEXbYT7z5NXCufIoDL2yuVNJxN9RTLkHO6CataXB4QtnNsRAi.HUPJgX
 iSJ6dJdPRakEaPvXe1v2Qbm3WhYHJ1ZZJwh6TfejRiEy8LZPUP11gcwrvh0yRPzeN9TeglMtpEFy
 NuULUqICywDuqikCi12onUOk.1TkxUxSXxn1W23CP9fJwm.Ez07flUXSJm.EYlAItQWfWMHTGW6i
 GvbXmoJEb8.rNDUZPaiCwfFLL
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic311.consmr.mail.ne1.yahoo.com with HTTP; Fri, 11 Jun 2021 00:25:46 +0000
Received: by kubenode541.mail-prod1.omega.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID b70099fafe50c312cedcf1dadbd3a2cd;
          Fri, 11 Jun 2021 00:25:44 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v27 19/25] NET: Store LSM netlabel data in a lsmblob
Date:   Thu, 10 Jun 2021 17:04:29 -0700
Message-Id: <20210611000435.36398-20-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210611000435.36398-1-casey@schaufler-ca.com>
References: <20210611000435.36398-1-casey@schaufler-ca.com>
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
index bfaf327e9d12..6f289821edb7 100644
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
index 3daa99396335..0ce9bee43dd3 100644
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
index dba867721336..b7800fa55a34 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -7122,7 +7122,7 @@ static int selinux_perf_event_write(struct perf_event *event)
 }
 #endif
 
-static struct lsm_id selinux_lsmid __lsm_ro_after_init = {
+struct lsm_id selinux_lsmid __lsm_ro_after_init = {
 	.lsm  = "selinux",
 	.slot = LSMBLOB_NEEDED
 };
diff --git a/security/selinux/include/security.h b/security/selinux/include/security.h
index ac0ece01305a..9f856f2cd277 100644
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
index 0a5ce001609b..b6071e977cdf 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -3883,7 +3883,7 @@ int security_netlbl_secattr_to_sid(struct selinux_state *state,
 	if (secattr->flags & NETLBL_SECATTR_CACHE)
 		*sid = *(u32 *)secattr->cache->data;
 	else if (secattr->flags & NETLBL_SECATTR_SECID)
-		*sid = secattr->attr.secid;
+		*sid = secattr->attr.lsmblob.secid[selinux_lsmid.slot];
 	else if (secattr->flags & NETLBL_SECATTR_MLS_LVL) {
 		rc = -EIDRM;
 		ctx = sidtab_search(sidtab, SECINITSID_NETMSG);
@@ -3960,7 +3960,7 @@ int security_netlbl_sid_to_secattr(struct selinux_state *state,
 	if (secattr->domain == NULL)
 		goto out;
 
-	secattr->attr.secid = sid;
+	secattr->attr.lsmblob.secid[selinux_lsmid.slot] = sid;
 	secattr->flags |= NETLBL_SECATTR_DOMAIN_CPY | NETLBL_SECATTR_SECID;
 	mls_export_netlbl_lvl(policydb, ctx, secattr);
 	rc = mls_export_netlbl_cat(policydb, ctx, secattr);
diff --git a/security/smack/smack.h b/security/smack/smack.h
index b5bdf947792f..0eaae6b3f935 100644
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
index 7aa7ea38f627..e65497a5c095 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -3720,11 +3720,12 @@ static struct smack_known *smack_from_secattr(struct netlbl_lsm_secattr *sap,
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
@@ -4701,7 +4702,7 @@ struct lsm_blob_sizes smack_blob_sizes __lsm_ro_after_init = {
 	.lbs_superblock = sizeof(struct superblock_smack),
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

