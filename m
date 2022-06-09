Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E64E95457E0
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 01:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345867AbiFIXF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 19:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345871AbiFIXFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 19:05:21 -0400
Received: from sonic301-38.consmr.mail.ne1.yahoo.com (sonic301-38.consmr.mail.ne1.yahoo.com [66.163.184.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E1FA3C26
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 16:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1654815918; bh=9jUZwLW4KWH1kzKdw9qNpe66c2Aiuqh5NAN3p+Ltk6g=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=XGV2n8m79iduH9KxK8jHXesCmAMnpGyA9H8krj5UduGmrbvthnZNN7h2Dz33PNZqqM7jq+SkgydB4RSw/xJYRhUlG5nylRWSpKjA1pT3pGMU8A0Xu/bMbpX8pkCxFrukFeGJNMOUU3IcwErafwGWyReao/m+EWwzvLET4nXgk/HDdKeCLIF7BS2IXk2mxMIqBpgYGaJ60nVIBWYNnzSktiMWPMy5GBG82C3rc6bDHXWULozdfXmX9G7/clieK7nLNa21hrE+DTzLwHjNJklcLeHuPiJyB24r56kWj10dr0NaeWuF1fcU8cSav6FN2/Vu7Rlwl+stYXyFjMRWbkdXWQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1654815918; bh=LrPzdmfOoNN4I8dNsqtDrrpjOa86BWePtUJg7YgaYCR=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=E2vJ0JjeWwiQhrWAUNBI7oSSIeSYI2UsAl23ooZL6BfDnOeCZ+Wu4/mt32q5RcKBOyJBFzeMNiNMHhBrJen3A7cqvneK2v6GikunHqc6zlvOzhCfm24hH7nndDN2iGRzVQaKNQX3+nzLkSo9Q/u8LwelUBvv9CmvogO1xkUnShs6ioIjg6b5R3gfsXFHMR76EXEBNQj2U68X+p+2jkXV22916gBeechQAKXZ/kcIipb5vISfF6iNbIEYkLFiSmHInLL1QqUz5mBnREW+atUg2jqqxbmAz2DzdOgo6nyXm7UFb3o9IvXSEo3qWMgylDdZpW62/FTU+1rn/8A4hfkO9w==
X-YMail-OSG: GweqzFUVM1kUtL6z32ycSut04rQpfUFYG94Ur1JiWugWXy0uUYDiAIgZ7fQt_yx
 kYaqlT1xWdm0dkqEe85FlkA6zZlXQLTc2txRRBJp030t5pdzDyPyhi5eWHlhLH3C6HjVDBlReFhv
 dO0kd1hinnHU8m0E6Fa.1NbGoEr0ZHAm4UiximkJ47wsdxxEeW6gNXWY8wHqOEC5ZmsPqS7g.5SP
 WwLb9YkE983glSo0Ersci1VhCg6uz3o8Qs5HC7QAifkGTwqZSWf_HiOAlDOI2J8oI7xP4fft.y7C
 L1WSVlCRLFMayyiv.iw471jxLnCBBfrD6oQee0bum2WpF8Qk4rEBoLcUOuxIO0AzbproiYA9fGQm
 Smef64G.6wFspC3nOG.4F9NzncwFqgwz9C_y6zTSZof2uYZ8ocAb2jhATRxkUG6x3reMo8wgFQez
 LUDkPGn4yDlhRrUEkGkBxwIVFCl0ZU40YqJMlJ246pKdrOM_k.JYgOiELqeKEhmjsdBrT6DpKRPY
 mh5Vqt1s.UCdbgqJWG.s7LI9TDL0M2RkUvTHLf.ssBspX2S79BQySVIiimCXBLiV6AcfQ.vRcjP5
 1QIEGp7jdLBOWdPWif3vLmNCc2GK_qtehIGWTA53lO.Ike5GWSikBpl7yc7iQ6gmXpBBTEFDur2P
 Xf1XMv4hCu2y0ZPcDDEVOcQsRwY16HIIhR4gPfffZ_6zzltt_bIgw4OIsoKQlkr9FJ.nowcSpCmh
 .2Fw4l89ea0UT3Nq3XrL0KGFhTII.Zj4bkX6q2VYGsAft_2pzBI8hy8JrI1QC_qSOKHk5E0PbWoF
 HINeqE8X4WJANZ2QBYwl4JWE9g5w9AYczGYaZEB7KUYESo7hkOTTFod7Pn2t.o2RuTEDjXVC8rV3
 bUhb8oUARggD8Hmzc_..kgjLvNGoKEKg1V7THw_dXT20weA1GlbNytNXyngRf85JHE0XlL2EyALn
 hP.25JCEEoyt.DA2O2VXs1Iq6B_OaLo9362Eoeg1WcRUFgGnxyqdX1iQJG1Kv1fwTuDj4BfVG9X0
 zRhDH_n4M9_MoAzXB.NUlCmdMs.kMNxJkB8Mc3sLeX1JEJ.geRhDBuYD7u_i7VniNXLDdfsjO4vI
 NBMtxFSNx7lR48Sv9GN_MZHCo9YQYKKLddHIivovQcsVBkY4wfkPGgAvlt70py8Poe1HesyXHiZK
 r1czegmHW.1ALUp6WxzUr.2p7ljh7BSxXI1eJB0dlslJD.ezMHd9G727y5g6uVvOqYUnRcg6.vZU
 mCi_daZnQ3hzGse6pcFIk7MvgNzUL2QtrutitNf3TCW99t4l7zU8HKlmfSQPZfGuseRY2Bzbnc1G
 dxp5sq_HTurE98VRCBTNTzWHjefgXOACjN9QVHePleHG5b4yRMwljLLAPNXvNoPVR_iyqsrCvBD9
 .e0sMNOOf8BPr56fOro_UhOY2ufTPQu458ChtsZWec0vcunF8F02TVoAzXZBuyAzFJP8yznIqBOw
 vPuDJrsocQGvHLb0urifrEkwbJkepk5M.qk__XZK4MXbv0d5kr.8KKWPoIJBgFaaCO7D_0oPVQCJ
 5K1kK.gQf06UapMH1rOKTZ8QNCz_wUQFdjRhuVsim_AzP2qCFm_r1sqL7F1PSiyV23xPu3nsEsah
 s0uOWGIMy2rAqnZvgUG2KXwTdSUD1yGr7XHxxnZSkS924Wt6Yl6Z_.H5aA31FVqjrDHBR3CG.oxa
 LWFqtKh61xWm5b8yZJnNusKDRAFwbPvVl.yks70rpTn8WUvf_l99ho9vJdrnYhT0493H5Uq.NwbA
 TJTdgaWaAP1RLmDJgYa.z6d73cQMgxV5Tpw_48lp8n65Z1dOgzS1Ugl1o22aYNPVic97_VjUUyvo
 HDvAe6ddHDgZu_bZtHDS_vHzBz1MjwUpGxask0NG33bLOg9PT2chq0B74sgc1p_7GnV68MYIblzT
 6IogLd_HKv0YnYH40LVluAS.O_jCJrOd__bCEfGluW4lxVNQqa3WtI4ZPWEyh5BtRGOmj9Yle5WU
 W7GnTK49kAOrtAGuNV0M1XqZNMiZZTxvErK898fYchu02Zn5AfY.1aVL9VSkRckGEm9EKBnP.7lc
 MHkZEC6qzxFy0Bx8msx1AWvrpb4viyFgXbDyMe2Lu411YtUHz8tm2ayx6zSdu1JcKCQLKlWc7xTZ
 KUBiKcHw51IJRkh6T8aw10V.D39VvdsTjmH1qg3_uxdggMShluLWhZ8LsOLBHKaVNz.MykfuyAop
 oJWR0wll3l.hCGSI90zNMd73WPv64ZtLwEpuK0q7vIoMe4choM.jkhW5Un7RUpFdrTV98_AnrAbR
 OWandOO0DP89vFoMGfs59ri2CvNeQyFxrMke3TZdMNdmRJHrwmUZXe5aPnCKYqICsgkQikbtv5FV
 QRXuuR9oi
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic301.consmr.mail.ne1.yahoo.com with HTTP; Thu, 9 Jun 2022 23:05:18 +0000
Received: by hermes--canary-production-bf1-856dbf94db-mq9q8 (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID a994d58746f340bf5c8b571efdccf4f1;
          Thu, 09 Jun 2022 23:05:13 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        stephen.smalley.work@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH v36 08/33] LSM: Use lsmblob in security_secctx_to_secid
Date:   Thu,  9 Jun 2022 16:01:21 -0700
Message-Id: <20220609230146.319210-9-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220609230146.319210-1-casey@schaufler-ca.com>
References: <20220609230146.319210-1-casey@schaufler-ca.com>
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
2.35.1

