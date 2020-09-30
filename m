Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C644528F1DC
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 14:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727571AbgJOMJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 08:09:08 -0400
Received: from mailomta1-re.btinternet.com ([213.120.69.94]:46859 "EHLO
        re-prd-fep-048.btinternet.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727157AbgJOMJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 08:09:08 -0400
Received: from re-prd-rgout-005.btmx-prd.synchronoss.net ([10.2.54.8])
          by re-prd-fep-040.btinternet.com with ESMTP
          id <20200930094938.CXJB10362.re-prd-fep-040.btinternet.com@re-prd-rgout-005.btmx-prd.synchronoss.net>;
          Wed, 30 Sep 2020 10:49:38 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=btinternet.com; s=btmx201904; t=1601459378; 
        bh=+vrKffhYTy6fGNPYV9F9FxF8k25qSn8lVNOuV3fc2mM=;
        h=From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version;
        b=FU55HmcF/ENPIbyVDdXqTwXsN5gtSZMAdAxjMIr6CqyptHLuIvEAnaMhy2nEZwVr3GLBbWU2HkYOJ2Roz/vpcaw55ql+XlFi0eUdO8CQjj6EhQFEvQ8vLUKuO9Pwy4G4VZEqYYp2t8d7Xk5e15wup3WADKFe8589u8AULB95Q2+Cg/6cT36leqErxiZPv7r3YpWW3CS8MzpZV6u+MBQufHwSauXbvyw+Pa0EPT+PCdZpgH1Y7qu3PAqed/B1WUV4VQF8d9xQQXBGHVE2gdTKf+lemEcjHEPNsD8da/GLS0eTLeXlzJWw0WbLYi1IFSepPPpZyKtk/fJ7Aj+Jl8wKqw==
Authentication-Results: btinternet.com; none
X-Originating-IP: [81.141.56.129]
X-OWM-Source-IP: 81.141.56.129 (GB)
X-OWM-Env-Sender: richard_c_haines@btinternet.com
X-VadeSecure-score: verdict=clean score=0/300, class=clean
X-RazorGate-Vade: gggruggvucftvghtrhhoucdtuddrgedujedrfedvgdduhecutefuodetggdotefrodftvfcurfhrohhfihhlvgemuceutffkvffkuffjvffgnffgvefqofdpqfgfvfenuceurghilhhouhhtmecufedtudenucenucfjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomheptfhitghhrghrugcujfgrihhnvghsuceorhhitghhrghruggptggphhgrihhnvghssegsthhinhhtvghrnhgvthdrtghomheqnecuggftrfgrthhtvghrnhepuedttdelleehueeggfeihfeitdehueekffeviedtffegffeiueegleejgeevgfeinecukfhppeekuddrudeguddrheeirdduvdelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehhvghloheplhhotggrlhhhohhsthdrlhhotggrlhguohhmrghinhdpihhnvghtpeekuddrudeguddrheeirdduvdelpdhmrghilhhfrhhomhepoehrihgthhgrrhgupggtpghhrghinhgvshessghtihhnthgvrhhnvghtrdgtohhmqedprhgtphhtthhopeeojhhmohhrrhhishesnhgrmhgvihdrohhrgheqpdhrtghpthhtohepoehlrghfohhrghgvsehgnhhumhhonhhkshdrohhrgheqpdhrtghpthhtohepoehlihhnuhigqdhsvggtuhhrihhthidqmhhoughulhgvsehvghgvrhdrkhgvrhhnvghlrdhorhhgqedprhgtphhtthhopeeonhgvthguvghvsehvghgvrhdrkhgvrhhnvghlrdhorhhgqedprhgtphhtthhopeeoohhsmhhotghomhdqnhgvthdqghhp
        rhhssehlihhsthhsrdhoshhmohgtohhmrdhorhhgqedprhgtphhtthhopeeophgrsghlohesnhgvthhfihhlthgvrhdrohhrgheqpdhrtghpthhtohepoehprghulhesphgruhhlqdhmohhorhgvrdgtohhmqedprhgtphhtthhopeeorhhitghhrghruggptggphhgrihhnvghssegsthhinhhtvghrnhgvthdrtghomhequcfqtfevrffvpehrfhgtkedvvdenrhhitghhrghruggptggphhgrihhnvghssegsthhinhhtvghrnhgvthdrtghomhdprhgtphhtthhopeeoshgvlhhinhhugiesvhhgvghrrdhkvghrnhgvlhdrohhrgheqpdhrtghpthhtohepoehsthgvphhhvghnrdhsmhgrlhhlvgihrdifohhrkhesghhmrghilhdrtghomheq
X-RazorGate-Vade-Verdict: clean 0
X-RazorGate-Vade-Classification: clean
X-SNCR-hdrdom: btinternet.com
Received: from localhost.localdomain (81.141.56.129) by re-prd-rgout-005.btmx-prd.synchronoss.net (5.8.340) (authenticated as richard_c_haines@btinternet.com)
        id 5ED9C74D136117CE; Wed, 30 Sep 2020 10:49:38 +0100
From:   Richard Haines <richard_c_haines@btinternet.com>
To:     selinux@vger.kernel.org, linux-security-module@vger.kernel.org,
        osmocom-net-gprs@lists.osmocom.org, netdev@vger.kernel.org
Cc:     stephen.smalley.work@gmail.com, paul@paul-moore.com,
        pablo@netfilter.org, laforge@gnumonks.org, jmorris@namei.org,
        Richard Haines <richard_c_haines@btinternet.com>
Subject: [PATCH 2/3] gtp: Add LSM hooks to GPRS Tunneling Protocol (GTP)
Date:   Wed, 30 Sep 2020 10:49:33 +0100
Message-Id: <20200930094934.32144-3-richard_c_haines@btinternet.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200930094934.32144-1-richard_c_haines@btinternet.com>
References: <20200930094934.32144-1-richard_c_haines@btinternet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add security hooks to allow security modules to exercise access control
over GTP.

The 'struct gtp_dev' has been moved to include/net/gtp.h so that
it is visible to LSM security modules where their security blob
is stored.

Signed-off-by: Richard Haines <richard_c_haines@btinternet.com>
---
 drivers/net/gtp.c | 50 ++++++++++++++++++++++++++++++++---------------
 include/net/gtp.h | 21 ++++++++++++++++++++
 2 files changed, 55 insertions(+), 16 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 21640a035..100ee4f9c 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -60,21 +60,6 @@ struct pdp_ctx {
 	struct rcu_head		rcu_head;
 };
 
-/* One instance of the GTP device. */
-struct gtp_dev {
-	struct list_head	list;
-
-	struct sock		*sk0;
-	struct sock		*sk1u;
-
-	struct net_device	*dev;
-
-	unsigned int		role;
-	unsigned int		hash_size;
-	struct hlist_head	*tid_hash;
-	struct hlist_head	*addr_hash;
-};
-
 static unsigned int gtp_net_id __read_mostly;
 
 struct gtp_net {
@@ -663,6 +648,10 @@ static int gtp_newlink(struct net *src_net, struct net_device *dev,
 
 	gtp = netdev_priv(dev);
 
+	err = security_gtp_dev_alloc(gtp);
+	if (err < 0)
+		return err;
+
 	err = gtp_encap_enable(gtp, data);
 	if (err < 0)
 		return err;
@@ -705,7 +694,13 @@ static void gtp_dellink(struct net_device *dev, struct list_head *head)
 {
 	struct gtp_dev *gtp = netdev_priv(dev);
 	struct pdp_ctx *pctx;
-	int i;
+	int i, err;
+
+	err = security_gtp_dev_free(gtp);
+	if (err < 0) {
+		pr_err("Failed security_gtp_dev_free() err: %d\n", err);
+		return;
+	}
 
 	for (i = 0; i < gtp->hash_size; i++)
 		hlist_for_each_entry_rcu(pctx, &gtp->tid_hash[i], hlist_tid)
@@ -1076,6 +1071,10 @@ static int gtp_genl_new_pdp(struct sk_buff *skb, struct genl_info *info)
 		goto out_unlock;
 	}
 
+	err = security_gtp_dev_cmd(gtp, GTP_CMD_NEWPDP);
+	if (err < 0)
+		goto out_unlock;
+
 	if (version == GTP_V0)
 		sk = gtp->sk0;
 	else if (version == GTP_V1)
@@ -1139,6 +1138,7 @@ static struct pdp_ctx *gtp_find_pdp(struct net *net, struct nlattr *nla[])
 static int gtp_genl_del_pdp(struct sk_buff *skb, struct genl_info *info)
 {
 	struct pdp_ctx *pctx;
+	struct gtp_dev *gtp;
 	int err = 0;
 
 	if (!info->attrs[GTPA_VERSION])
@@ -1152,6 +1152,11 @@ static int gtp_genl_del_pdp(struct sk_buff *skb, struct genl_info *info)
 		goto out_unlock;
 	}
 
+	gtp = netdev_priv(pctx->dev);
+	err = security_gtp_dev_cmd(gtp, GTP_CMD_DELPDP);
+	if (err < 0)
+		goto out_unlock;
+
 	if (pctx->gtp_version == GTP_V0)
 		netdev_dbg(pctx->dev, "GTPv0-U: deleting tunnel id = %llx (pdp %p)\n",
 			   pctx->u.v0.tid, pctx);
@@ -1208,6 +1213,7 @@ static int gtp_genl_get_pdp(struct sk_buff *skb, struct genl_info *info)
 {
 	struct pdp_ctx *pctx = NULL;
 	struct sk_buff *skb2;
+	struct gtp_dev *gtp;
 	int err;
 
 	if (!info->attrs[GTPA_VERSION])
@@ -1221,6 +1227,11 @@ static int gtp_genl_get_pdp(struct sk_buff *skb, struct genl_info *info)
 		goto err_unlock;
 	}
 
+	gtp = netdev_priv(pctx->dev);
+	err = security_gtp_dev_cmd(gtp, GTP_CMD_GETPDP);
+	if (err < 0)
+		goto err_unlock;
+
 	skb2 = genlmsg_new(NLMSG_GOODSIZE, GFP_ATOMIC);
 	if (skb2 == NULL) {
 		err = -ENOMEM;
@@ -1250,6 +1261,7 @@ static int gtp_genl_dump_pdp(struct sk_buff *skb,
 	struct net *net = sock_net(skb->sk);
 	struct pdp_ctx *pctx;
 	struct gtp_net *gn;
+	int err;
 
 	gn = net_generic(net, gtp_net_id);
 
@@ -1263,6 +1275,12 @@ static int gtp_genl_dump_pdp(struct sk_buff *skb,
 		else
 			last_gtp = NULL;
 
+		err = security_gtp_dev_cmd(gtp, GTP_CMD_GETPDP);
+		if (err < 0) {
+			rcu_read_unlock();
+			return err;
+		}
+
 		for (i = bucket; i < gtp->hash_size; i++) {
 			j = 0;
 			hlist_for_each_entry_rcu(pctx, &gtp->tid_hash[i],
diff --git a/include/net/gtp.h b/include/net/gtp.h
index 0e16ebb2a..84b68cf8d 100644
--- a/include/net/gtp.h
+++ b/include/net/gtp.h
@@ -32,4 +32,25 @@ struct gtp1_header {	/* According to 3GPP TS 29.060. */
 #define GTP1_F_EXTHDR	0x04
 #define GTP1_F_MASK	0x07
 
+/*
+ * One instance of the GTP device.
+ * Any LSM security module can access their security blob here.
+ */
+struct gtp_dev {
+	struct list_head	list;
+
+	struct sock		*sk0;
+	struct sock		*sk1u;
+
+	struct net_device	*dev;
+
+	unsigned int		role;
+	unsigned int		hash_size;
+	struct hlist_head	*tid_hash;
+	struct hlist_head	*addr_hash;
+#ifdef CONFIG_SECURITY
+	void			*security;
+#endif
+};
+
 #endif
-- 
2.26.2

