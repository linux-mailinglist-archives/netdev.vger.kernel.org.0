Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8688355E0CC
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242893AbiF1BDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 21:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242849AbiF1BCd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 21:02:33 -0400
Received: from sonic316-27.consmr.mail.ne1.yahoo.com (sonic316-27.consmr.mail.ne1.yahoo.com [66.163.187.153])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D24C722B31
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 18:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1656378151; bh=z3jiL2tCAI8K9XeufR5jyTcN598SmLsZZztorcUuBNM=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=XIUprzOOn613dOmiS1XbrYT4yPlc6d55MhS5QawvlPhdb4CoW5J06pi2WPHJHVwTyGZdR50J7qT5hgA/2VAQ6ZdgfZQWTTFItITg1QK5iywfcJNCAJOZ1t/krOXN1hTJGoVgjS+0KhA9zM0eTxI5XkWaiVVPWA4sthY1c0/dR61a33YWWT16FRZRTq29x5eITTADTr3YC4E4PVIzFiC0gxvSEGZMZoXAfC8YqMAGn53V9P9EqHMiXd65Msxf06fbBl7jkbtk3aLgM447/w2iQb8xBTYmcR4okVRXVH0VXADk7eYnwdQbB/qvVu9J2SQuAv/U2pCePhf1YGQQEYvudA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1656378151; bh=NNZ8jDM4uDDZqf6115zwAN06m2X+w/j043teU3HyfDP=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=cJm2kcoyOEhHvzjH6mAsyAYE7ar/ZswJXp6ZkW/t+OIDk06L2SggO4AYLORlTMmHvskNTMQUXjfh/DlcBY9RRobuQ2hvnIt1GEjXkof78kQzLstidJdU5taGFnBrMmP0v4SJInGNXhoN9FZm3KDG5NmbLgg0aiOSFKH+rJidQEVYbwETSxKhmJXdNn3QhLU55GAzxI/8jRIZfsKlVc9iynT0GPfr7r/HK3NHaZ+qcsVgi4up7T/mlE0UiuxMNfjocMe48VoU9eWk+NqMoZU0Xcwh5ZVI7a9tFa1Cn8vevc7vPEncUtzNL9PL6dViyDqGMDz+E2IwOvOOuNlQLbop1g==
X-YMail-OSG: 6AvIDGcVM1kGIjMnTaPeAbSRNjUbhRHB0lUa7MF.sbYvlB45vlC6b0F5oyMxRtu
 6gujOHQPCcfKq1Qf0B72_ZucWzWi.48cI69nuG.6LuZ9TOiVzSMIXgdbKnV2wVCNRgT8Br_2.GoV
 giuODmTQMjGksOTQgK2AxhhrB9e5Qhj9aAr_GbDbqnTDB3LR9xzMRuj3WHFPicgJYfO7v8NaW5gf
 zMCmZWEioDf0FJimiUBAdKhex2SWvJK7LWRa.qM5IGst8OSvwsUh.zbE5gv8pmXYN22niYvIFQ4.
 cxX45dpPpRwNeVGoo0lzDXGoDdm4zMexhhHwV02SwgtyJOa6pp0WOyoKbMB5Gt4jqAstGIEUeVij
 6yCw9TwTSmxuLnABOj_.25PAn8X.dvHmocGDbK.12fqGaF9Szf.63hDea5.to9P2m8VS94P.BkjF
 aDJAid.jmOAUjrgDCztCXCk.ykemTpKQHJ5IoBY46kYu9J2LnX1m02VkgGtUuSPKAcHr4OYOEq5u
 yNv.RjpSV2QoSUSSy20ZLhwAEo8.iegZ6odZ4X_qzPOq_sqgRW9INhhIZKBnuHSoaGFc2XfBK9Qp
 QTBHe0t22iHcQn6KhzawX8tvEODfUI8C5lCw2A88DUL4GIEDy6Sh9HjWUy7crqzrAfSCU0YVIizj
 SlWSvUmgAD8SS8.o76UPuKFbUo9wl0rITZNI5e15l7tQY74J6IfPHFBuD4mtLt0asTdYRwSrFwfJ
 iLdhyhQjhoTZDFBotbunksFe3pigpmUahDTVXZ4u82h.r8tOB282cIYWI0klcN8Ws9YkPWklpu8U
 fHqkoVLksOosTEwz5nYe1u6aU40h0o2kFpdrGrrfcMWnhk6fHd6WFMwufKo.3n1xNyNlCShFavmc
 3LUF.klGnEuD74kZl6nC7OPFoUv73RsOILQX4gbi2tkPwr.mjDFsjne2qKvOn55Xkve9_RnDJUGs
 MFWbBkw4pn9odrZGnTFbkxIZaN1p_h4.s_PTlKvOekqPvPs.aUkFRk1ENPGrEwRWlj4lp.Yu6m_p
 MOua9gilxjMynHGV9sU.fXzT837SL1i2E3J_YD1H.fHQ6RfILTUQgx0apgxCwZ0KC2qkwRjpJ2Zl
 bcYQDk4eM.ebwA5BElA630Trvj5Ucbzl5ifvHoycaEPP6Dex23GhxV6G5Plt17J1yXmnNmV9vo7T
 rkEH7qasEHRyLxxKF3CJSLuMEVMXN5JP7PKUWnqF2Tk2Z.5.El6upeOuq9minSpCzqGy4gF1a7iW
 HTMY6kbbLFj7O9oDw0uOPMqfMMjdgw0.pVbGdFp8QU9nBIuPoJiCSe1t2oYPk_oUxTxhd6yDlJH.
 bFQFhtZlcp1DjgzlWHil40uG8TUOGe9sECTMDwsdEBn2eu4AhpMFNKmUSjTKEbpJCh1oz70ZHDSB
 uGApgIfiPYKy1V7buBUFkyAMLhj8LVgeByd25ZZf7oM3AUDbCqy4e8ivxgD9VUm6HdXDaOlfET.B
 2RU1fvxmZ2bq2rCjmwZPQB2SokdsBkLZHdPR._.B5kF8FDN53bP_qq34gxMmo_qAbvypyNdbFuKZ
 BYjkiShaUBH2rrT56eb3o24E78CiqI7sZQznxLlHIF4LklxUpPncpFM4bWxhD_QZalR0ChHfzOZt
 hcARMEsjRmJ8gtgSdPBVBDa3XZmGVhhFk6LId1aB_4GF7_Y4KkkED49MB6zMdXrjoeSppUA2fLre
 RTytQ8E2jbyczVWBBgCKINIrxXOzzhUXXeGkYVxhMiWwJ5DIiCqVqN04hCg0lU.m_o6wN9PCWUAL
 E5KviX5dG1sITPnz8WV27h8zWy_lNTBKbzX0vHNXt4xKMccbAq25fkhZaXK_B4.exQ1gBNC9hMXQ
 FuDQ.3lxy56rqSc8cgrpRndv2nVPl2cwTKP8AVrGXin14pg30dVXWYpXPOtHW5TnoZrT884O1Rqh
 RhUWdefwyyOdVbat_Z0obfQju7Uuq9rnfdt5ADnqFvy0__LdxoUL1IR64O.cgz9xERBeeBfhaq5H
 ZpOxXSeHK5HtbMqhTgsoGFunEngAi5VjQDFdlniMZEuZ9DCVt0LrBz31hzTBK_sTZujuyU8zR6TN
 yozckMq1TVeOwJS.KqcjiehH.nHpxXJmSPhOWuHivdZuAWUlf3bvFsjhu7qgZBQwEFDgboyB81l2
 lZnj.w9JCHFw.PGvp36CAadNixwU76TOffauHQcVwrwQypHGiDiJ7hl3PyyDjNKbig4U5ruTPQ5w
 Q27rUC7vIsLkZmJH_AAJNVCs3M_rDqTeseAZVajD7S53AtDpN.4pdG.3ZbkGNGHpcAVdDj7uWum2
 qicBMEKiR.4mIzN5mBRIyWdu8kGjKrkH9S9j_74vreI9VXEPSskqF2DXLdc4A1Fs-
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic316.consmr.mail.ne1.yahoo.com with HTTP; Tue, 28 Jun 2022 01:02:31 +0000
Received: by hermes--production-bf1-7f5f59bd5b-wm5tz (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID dbf52cafe43ef47006ff0c558ab03737;
          Tue, 28 Jun 2022 01:02:23 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        stephen.smalley.work@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH v37 08/33] LSM: Use lsmblob in security_secctx_to_secid
Date:   Mon, 27 Jun 2022 17:55:46 -0700
Message-Id: <20220628005611.13106-9-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628005611.13106-1-casey@schaufler-ca.com>
References: <20220628005611.13106-1-casey@schaufler-ca.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the security_secctx_to_secid interface to use a lsmblob
structure in place of the single u32 secid in support of
module stacking. Change its callers to do the same.

The security module hook is unchanged, still passing back a secid.
The infrastructure passes the correct entry from the lsmblob.

Acked-by: Paul Moore <paul@paul-moore.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Cc: netdev@vger.kernel.org
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/security.h          | 26 ++++++++++++++++++--
 kernel/cred.c                     |  4 +---
 net/netfilter/nft_meta.c          | 10 ++++----
 net/netfilter/xt_SECMARK.c        |  7 +++++-
 net/netlabel/netlabel_unlabeled.c | 23 +++++++++++-------
 security/security.c               | 40 ++++++++++++++++++++++++++-----
 6 files changed, 85 insertions(+), 25 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index 823880ba613e..8e09302bded7 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -201,6 +201,27 @@ static inline bool lsmblob_equal(const struct lsmblob *bloba,
 extern int lsm_name_to_slot(char *name);
 extern const char *lsm_slot_to_name(int slot);
 
+/**
+ * lsmblob_value - find the first non-zero value in an lsmblob structure.
+ * @blob: Pointer to the data
+ *
+ * This needs to be used with extreme caution, as the cases where
+ * it is appropriate are rare.
+ *
+ * Return the first secid value set in the lsmblob.
+ * There should only be one.
+ */
+static inline u32 lsmblob_value(const struct lsmblob *blob)
+{
+	int i;
+
+	for (i = 0; i < LSMBLOB_ENTRIES; i++)
+		if (blob->secid[i])
+			return blob->secid[i];
+
+	return 0;
+}
+
 /* These functions are in security/commoncap.c */
 extern int cap_capable(const struct cred *cred, struct user_namespace *ns,
 		       int cap, unsigned int opts);
@@ -531,7 +552,8 @@ int security_setprocattr(const char *lsm, const char *name, void *value,
 int security_netlink_send(struct sock *sk, struct sk_buff *skb);
 int security_ismaclabel(const char *name);
 int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen);
-int security_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid);
+int security_secctx_to_secid(const char *secdata, u32 seclen,
+			     struct lsmblob *blob);
 void security_release_secctx(char *secdata, u32 seclen);
 void security_inode_invalidate_secctx(struct inode *inode);
 int security_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen);
@@ -1386,7 +1408,7 @@ static inline int security_secid_to_secctx(u32 secid, char **secdata, u32 *secle
 
 static inline int security_secctx_to_secid(const char *secdata,
 					   u32 seclen,
-					   u32 *secid)
+					   struct lsmblob *blob)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/kernel/cred.c b/kernel/cred.c
index 3925d38f49f4..adea727744f4 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -791,14 +791,12 @@ EXPORT_SYMBOL(set_security_override);
 int set_security_override_from_ctx(struct cred *new, const char *secctx)
 {
 	struct lsmblob blob;
-	u32 secid;
 	int ret;
 
-	ret = security_secctx_to_secid(secctx, strlen(secctx), &secid);
+	ret = security_secctx_to_secid(secctx, strlen(secctx), &blob);
 	if (ret < 0)
 		return ret;
 
-	lsmblob_init(&blob, secid);
 	return set_security_override(new, &blob);
 }
 EXPORT_SYMBOL(set_security_override_from_ctx);
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index ac4859241e17..fc0028c9e33d 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -860,21 +860,21 @@ static const struct nla_policy nft_secmark_policy[NFTA_SECMARK_MAX + 1] = {
 
 static int nft_secmark_compute_secid(struct nft_secmark *priv)
 {
-	u32 tmp_secid = 0;
+	struct lsmblob blob;
 	int err;
 
-	err = security_secctx_to_secid(priv->ctx, strlen(priv->ctx), &tmp_secid);
+	err = security_secctx_to_secid(priv->ctx, strlen(priv->ctx), &blob);
 	if (err)
 		return err;
 
-	if (!tmp_secid)
+	if (!lsmblob_is_set(&blob))
 		return -ENOENT;
 
-	err = security_secmark_relabel_packet(tmp_secid);
+	err = security_secmark_relabel_packet(lsmblob_value(&blob));
 	if (err)
 		return err;
 
-	priv->secid = tmp_secid;
+	priv->secid = lsmblob_value(&blob);
 	return 0;
 }
 
diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
index 498a0bf6f044..87ca3a537d1c 100644
--- a/net/netfilter/xt_SECMARK.c
+++ b/net/netfilter/xt_SECMARK.c
@@ -42,13 +42,14 @@ secmark_tg(struct sk_buff *skb, const struct xt_secmark_target_info_v1 *info)
 
 static int checkentry_lsm(struct xt_secmark_target_info_v1 *info)
 {
+	struct lsmblob blob;
 	int err;
 
 	info->secctx[SECMARK_SECCTX_MAX - 1] = '\0';
 	info->secid = 0;
 
 	err = security_secctx_to_secid(info->secctx, strlen(info->secctx),
-				       &info->secid);
+				       &blob);
 	if (err) {
 		if (err == -EINVAL)
 			pr_info_ratelimited("invalid security context \'%s\'\n",
@@ -56,6 +57,10 @@ static int checkentry_lsm(struct xt_secmark_target_info_v1 *info)
 		return err;
 	}
 
+	/* xt_secmark_target_info can't be changed to use lsmblobs because
+	 * it is exposed as an API. Use lsmblob_value() to get the one
+	 * value that got set by security_secctx_to_secid(). */
+	info->secid = lsmblob_value(&blob);
 	if (!info->secid) {
 		pr_info_ratelimited("unable to map security context \'%s\'\n",
 				    info->secctx);
diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index 8490e46359ae..f3e2cde76919 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -880,7 +880,7 @@ static int netlbl_unlabel_staticadd(struct sk_buff *skb,
 	void *addr;
 	void *mask;
 	u32 addr_len;
-	u32 secid;
+	struct lsmblob blob;
 	struct netlbl_audit audit_info;
 
 	/* Don't allow users to add both IPv4 and IPv6 addresses for a
@@ -904,13 +904,18 @@ static int netlbl_unlabel_staticadd(struct sk_buff *skb,
 	ret_val = security_secctx_to_secid(
 		                  nla_data(info->attrs[NLBL_UNLABEL_A_SECCTX]),
 				  nla_len(info->attrs[NLBL_UNLABEL_A_SECCTX]),
-				  &secid);
+				  &blob);
 	if (ret_val != 0)
 		return ret_val;
 
+	/* netlbl_unlhsh_add will be changed to pass a struct lsmblob *
+	 * instead of a u32 later in this patch set. security_secctx_to_secid()
+	 * will only be setting one entry in the lsmblob struct, so it is
+	 * safe to use lsmblob_value() to get that one value. */
+
 	return netlbl_unlhsh_add(&init_net,
-				 dev_name, addr, mask, addr_len, secid,
-				 &audit_info);
+				 dev_name, addr, mask, addr_len,
+				 lsmblob_value(&blob), &audit_info);
 }
 
 /**
@@ -931,7 +936,7 @@ static int netlbl_unlabel_staticadddef(struct sk_buff *skb,
 	void *addr;
 	void *mask;
 	u32 addr_len;
-	u32 secid;
+	struct lsmblob blob;
 	struct netlbl_audit audit_info;
 
 	/* Don't allow users to add both IPv4 and IPv6 addresses for a
@@ -953,13 +958,15 @@ static int netlbl_unlabel_staticadddef(struct sk_buff *skb,
 	ret_val = security_secctx_to_secid(
 		                  nla_data(info->attrs[NLBL_UNLABEL_A_SECCTX]),
 				  nla_len(info->attrs[NLBL_UNLABEL_A_SECCTX]),
-				  &secid);
+				  &blob);
 	if (ret_val != 0)
 		return ret_val;
 
+	/* security_secctx_to_secid() will only put one secid into the lsmblob
+	 * so it's safe to use lsmblob_value() to get the secid. */
 	return netlbl_unlhsh_add(&init_net,
-				 NULL, addr, mask, addr_len, secid,
-				 &audit_info);
+				 NULL, addr, mask, addr_len,
+				 lsmblob_value(&blob), &audit_info);
 }
 
 /**
diff --git a/security/security.c b/security/security.c
index d3b28a6b9248..08ed7acf4205 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2205,10 +2205,22 @@ int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
 }
 EXPORT_SYMBOL(security_secid_to_secctx);
 
-int security_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid)
+int security_secctx_to_secid(const char *secdata, u32 seclen,
+			     struct lsmblob *blob)
 {
-	*secid = 0;
-	return call_int_hook(secctx_to_secid, 0, secdata, seclen, secid);
+	struct security_hook_list *hp;
+	int rc;
+
+	lsmblob_init(blob, 0);
+	hlist_for_each_entry(hp, &security_hook_heads.secctx_to_secid, list) {
+		if (WARN_ON(hp->lsmid->slot < 0 || hp->lsmid->slot >= lsm_slot))
+			continue;
+		rc = hp->hook.secctx_to_secid(secdata, seclen,
+					      &blob->secid[hp->lsmid->slot]);
+		if (rc != 0)
+			return rc;
+	}
+	return 0;
 }
 EXPORT_SYMBOL(security_secctx_to_secid);
 
@@ -2359,10 +2371,26 @@ int security_socket_getpeersec_stream(struct socket *sock, char __user *optval,
 				optval, optlen, len);
 }
 
-int security_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *skb, u32 *secid)
+int security_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *skb,
+				     u32 *secid)
 {
-	return call_int_hook(socket_getpeersec_dgram, -ENOPROTOOPT, sock,
-			     skb, secid);
+	struct security_hook_list *hp;
+	int rc = -ENOPROTOOPT;
+
+	/*
+	 * Only one security module should provide a real hook for
+	 * this. A stub or bypass like is used in BPF should either
+	 * (somehow) leave rc unaltered or return -ENOPROTOOPT.
+	 */
+	hlist_for_each_entry(hp, &security_hook_heads.socket_getpeersec_dgram,
+			     list) {
+		if (WARN_ON(hp->lsmid->slot < 0 || hp->lsmid->slot >= lsm_slot))
+			continue;
+		rc = hp->hook.socket_getpeersec_dgram(sock, skb, secid);
+		if (rc != -ENOPROTOOPT)
+			break;
+	}
+	return rc;
 }
 EXPORT_SYMBOL(security_socket_getpeersec_dgram);
 
-- 
2.36.1

