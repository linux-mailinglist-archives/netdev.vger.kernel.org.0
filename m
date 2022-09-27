Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B597E5ECDF1
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 22:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232679AbiI0UJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 16:09:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232968AbiI0UIm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 16:08:42 -0400
Received: from sonic306-27.consmr.mail.ne1.yahoo.com (sonic306-27.consmr.mail.ne1.yahoo.com [66.163.189.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDFAB1EAD68
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 13:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1664309260; bh=19fz2r4tdUwi9f2YLanw8DvLYsfijFntK/RyI7lZMC8=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=Vs+szPYSi/IwPCHX6fIcuScQVXo1s0gYnTU1NvgKIgk37rn/WMU90YG2o/kjYrF0FmIFAIcRjDuWxI8pyPBMRxC04iEHf+9qKBsM6kU70bTmjaPhDtaKZbvP5/JMjZlQWTdJNApMC78whI4/OsJCVK8P9hoLI/5ZnzP01d0sb3acLVqzCvNW23WUNrUNMzh/bB/zjBI5UD1u5HlOI/Y0y+Ma+Z0yaWjGh1b+67uE5G8kIgotlxKN69prWgdByrQNSlY2jRjNCBgCXvQ8Lv1Bs4Wvs3QGVzBvDl5Wo5i0+7KP4j6kwMbL1Y/0A0UpoA75IBFvB/Z9uuCgklQwuhyvJg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1664309260; bh=v8wgkczAXBgvuvzIdWq2pgqwVnimIAH4KKGL8+5ziVI=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=Yj3qPpXofcmgQFC5gb5D2jF9/S5N79VkylDtqpIjdLysfyjklzl42chKfCUtKx34UzQ9c17VWkHuW8bmu1Q4l3uXYpcNjxihfPPSjmu46CQ7pWCgEe7jiqy6f150lHBkRpASRSJoczVHrC2/MzJFUN97ZLtGSA30tlVVJIbL0iCv2uuk7XOchNotwKFmFHkCal8Epq3tvpHOxd3dSUd+3Y5JkhDnXvKOpL7A2by/j+p79HGLaKe3RXMtOQxzwn2SqMw9TOByqK0ohhsPN4GOiskr43pJSoQLK6kCDc8mrHcl1AJ7TZrOdRFXfuf7cD/xc/0YIVBHbpxJeAAEDLA+Yg==
X-YMail-OSG: 6Xb80iYVM1med_FqrYJSdoE41fQTHk5Rd6b264kdHQujTkqo.ef71oIibPf3rKD
 juz7OwGxD.H8DjOgHUCj7dC0SQS5A8W7wt3WZrg491Qhlp776tPcBbd_XG5tR9AmD.sT98Po9FtJ
 t9N13lBkp0HLAFByKfu_Mv.cffmO2FeKxfUDNcyMZmz5khgER19BQN_fHNw71aR.B99P1ZAilwJ8
 Q1_tG755Er_bvgFXu70H.BLIEygQAcWZNDURC8Pnuykl8PJ52yoAM2wUdnL.QPxLlBjaZPjvQqIE
 60HXHRwPVz0uMkPy7qRlTBzw12uSsejhPphNYhLDyhfG5g8cFN7_nL_I65kdSnYgGjA0idZL3P64
 n.OvBm8_0rYFpVxk_.TPXaPJ0WXt.JoXcRzYuGJxB0XjdTb4duXk3IuM5TX77YB0mi.vZh7DyNnW
 6AObfVSR4y_mJjRYLK60_sXuOqW26GeZsMC6EU3PIodHzSjeDF41v8p2tfaoLVSCct0k_C2rOHFm
 ls6DIIu4.PFnMuJduv3DH2QS0N2hfZLEcd_kKT4FJ7aKmZbeKeWy6JBJ1uYPljcbbWVklqcgNc6k
 LI8QLWEFyOMXDVHBv1hTdjVIotG7tf57sz.70rs.NMBRD12itWMBxjkgRe8VyudHACHqfxpVv0mb
 Me5Njoa.iIo3_R52IULxON40A53Dn29hKNIDQQpOAWcBLiuvlnQdeiEXj48IDCTqAvyK632UJ7Bw
 XryphxHZy5wZ103VV96bgacu726tgtmOoA15AP9deltPuS9mn9dg6OLnfU2WRMJV1deChaua_guh
 n.22oJf.rYY3SfZTW.qBAGbii0fnaAL6CZLXe8qoqPZTi8GhOYZRoN8_2tXy5cbmqtKX.l54tfM4
 BEn1OteZCwzs2SetGHvO2YWJc1fK.eMSMe8LBQKr0DemS1biEd9syPLOna0v_QRAJ35pPakTBSIA
 hBF7wipvv_0xjlWyTBZs0c12Avai1X7cifX45gd3O37waP7TjlRdPzIUHh0ItddKi3D86EtXSDtJ
 8rJcLjogQe9E.SlnFY8gyb7SEz9h1fjBOL0wiXJZLInt_nAlQ1TWPUrTYUhrmZW44th9.AkJ3Bfz
 yptpbIwySQPMdyWJ9GJ.thPAdEYSMMsmNp6nTIASLGNX5J3XllbzsIzQJGKSYkWoQS0PAn7Ovo7.
 xSYAf3DNkiLBoYgVjIexRhd._t1s_KYD0lgDDd6hKVvB0BQZaTCfhrYt6YNwO3ipmSu8bWqqXQvu
 RBcHWH78fKdke.bpLH4FL32JG9YtebzdmZRMwTngKbrlGprrLkHkmyGL5mpNz1jU0rz.fO_AO5jh
 r7KTKZ0ijVDdNzjpeC0onhJDt5sPMATYOwssOpHCfma_.1x3Djdmj0rO2k2jWxxsnLoqH1ddUHbZ
 YVLoQ54SWVlcBBpArEmlvVX11z9POTp6j8fUUqoZlXyLGTHbxC6eBbx7rRazBg00ieUnF4pOMyah
 NSAwQxJMvKe_JHDUwonWgVjTy6roAm7fiWLBfetyS92b_17viuyyG0Y5c8gLcmrvx1C.82l31Z1B
 Eg8FcNv1DPbggeFlKty8exBDh6eoDuMXoeQdvQR5Or.m9WvlA6lRqtVmhuNJZQVpkctCi4.fG5U0
 UQyOhey5efHmTghYU1ZLrtUzVe5G8ZRCZOA6z.HoRnUndryuZ9FoWRU4BR2ANFNGR1ao4aukE.mB
 4ffwdEZqu3odeQHkhGMuuvy3be0FJOrime0ksum86HwCbhSOMaOSXj729b18RF1ojqKER2yBx65i
 i8Gnxg4yn8cWW0H0J_U3VAAs1jwdijEkwnO3lJs_EV1G6yvY33q17pDfo7U2iTOfiCBNp0z.0GoT
 MSSDlRtATcwHUw9hVFifvEbMSj2QCQeyljeadkZZBMxbDtKdJcUxdWDgY_IWBkVLJP5SMcCN1wyG
 QTCGTXv0I95LnVmD6DDwT1at.LUC1uc9cs_vYBjkwu9RDuDyhW9ermiC9XTm8kqjrS6_BxKsMoy5
 ddEfe2M0Z2JiOV.kSKJ2Wtr0Hk3QhfNpjUv0J.RVTU2Xuiq5EEQcnv1RVI2_7VeX3EKix7xioFyP
 KPnEDSzJFwaCLgbDOmJmCl9ZlPeZfOOYlk9nT.UuQ.AOfEIHjYFscf6j.kgXCmht9YGPuGtH2eHE
 czdfSmiWSOx0Bw9kTuvGTCOB6tkx41luh8KBfVGS4x7O6_857I0QPh8QfWynPUKPuX8IDXlg7FKy
 1vCmNBuCxgnVeio04AGTvOtmfi6Mjlip6ydj4WG.6C173wAG12tUnlhIKt8xpni_bJzkNp_53NZ4
 gr07zs1TSnZzs9nHGivsCYXEUmcej2gb2RrfZoNQPLA--
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.ne1.yahoo.com with HTTP; Tue, 27 Sep 2022 20:07:40 +0000
Received: by hermes--production-gq1-7dfd88c84d-mgq76 (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 3a50061892aa4d3f76ff4b42bdd2ab9e;
          Tue, 27 Sep 2022 20:07:35 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, paul@paul-moore.com,
        linux-security-module@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com, jmorris@namei.org,
        selinux@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, penguin-kernel@i-love.sakura.ne.jp,
        stephen.smalley.work@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v38 26/39] NET: Store LSM netlabel data in a lsmblob
Date:   Tue, 27 Sep 2022 12:54:08 -0700
Message-Id: <20220927195421.14713-27-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220927195421.14713-1-casey@schaufler-ca.com>
References: <20220927195421.14713-1-casey@schaufler-ca.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
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
index 6cd3b6c559f0..5aafec36ac26 100644
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
@@ -1462,7 +1464,11 @@ static int cipso_v4_gentag_loc(const struct cipso_v4_doi *doi_def,
 
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
@@ -1482,7 +1488,7 @@ static int cipso_v4_parsetag_loc(const struct cipso_v4_doi *doi_def,
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
index 744857eac2f8..ae2f49f3398d 100644
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
index aad795306bd2..92c818d37a4c 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -7029,7 +7029,7 @@ static int selinux_uring_cmd(struct io_uring_cmd *ioucmd)
 }
 #endif /* CONFIG_IO_URING */
 
-static struct lsm_id selinux_lsmid __lsm_ro_after_init = {
+struct lsm_id selinux_lsmid __lsm_ro_after_init = {
 	.lsm      = "selinux",
 	.id       = LSM_ID_SELINUX,
 	.features = LSM_ATTR_CURRENT | LSM_ATTR_EXEC | LSM_ATTR_FSCREATE |
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
index fe5fcf571c56..f3e7d9da64a9 100644
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
index 585e5e35710b..ce9cb48213ed 100644
--- a/security/smack/smack_access.c
+++ b/security/smack/smack_access.c
@@ -521,7 +521,7 @@ int smack_populate_secattr(struct smack_known *skp)
 {
 	int slen;
 
-	skp->smk_netlabel.attr.secid = skp->smk_secid;
+	skp->smk_netlabel.attr.lsmblob.secid[smack_lsmid.slot] = skp->smk_secid;
 	skp->smk_netlabel.domain = skp->smk_known;
 	skp->smk_netlabel.cache = netlbl_secattr_cache_alloc(GFP_ATOMIC);
 	if (skp->smk_netlabel.cache != NULL) {
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index fbcf20ef1394..0f6424fb8549 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -3716,11 +3716,12 @@ static struct smack_known *smack_from_secattr(struct netlbl_lsm_secattr *sap,
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
@@ -4769,7 +4770,7 @@ struct lsm_blob_sizes smack_blob_sizes __lsm_ro_after_init = {
 	.lbs_superblock = sizeof(struct superblock_smack),
 };
 
-static struct lsm_id smack_lsmid __lsm_ro_after_init = {
+struct lsm_id smack_lsmid __lsm_ro_after_init = {
 	.lsm      = "smack",
 	.id       = LSM_ID_SMACK,
 	.features = LSM_ATTR_CURRENT,
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
2.37.3

