Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB0C1D9934
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 16:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729215AbgESOP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 10:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726880AbgESOP3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 10:15:29 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C59C08C5C0
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 07:15:28 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id l18so16116708wrn.6
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 07:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VT2Ke45pejmh9YGJr9yS5mzgPUWSNMfFYXyMzWsp4i0=;
        b=Q8li5lOB/oOjlt4qGFTogL90HtaSelc1sDk7gv3S3R536DMSBKJO5qLQU8RfUIXnzR
         pvo6FRBeevXdmUjwatW02PgFtRPqLlEW51IVH2KIhxHzCXuOrNfe13iX4bpyfNQUwvnE
         5F6jGCvwR3qIxJa9NiH5UTSZmcNxfUHqdRS2sNIXiXP0/0P8Gv892Fmq22tIYNfzRCgW
         AdwrHq3AakFogDY6JBKyt90doZXcq7l5MsCF4HZCrxhsZ7C81ocwq0xJXVHCi6fD/nci
         k1baNscufXcz3XJW501aBxYdHltb+lgfrH4t49Oc06af5aKNUY8ubA8rz/XkumifEb7b
         w8Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VT2Ke45pejmh9YGJr9yS5mzgPUWSNMfFYXyMzWsp4i0=;
        b=Tl3zXX/drVMAR/HnhwaHKU9uJ/ZktSycVQbmF1opAVRz0NCukvc/RCIjmRS2q7UkMk
         +I/b3XIkhWTu7Dv/Q4fPkuE9Tp61r6CPlQ4MiEPw7iS+FrIzbvgi57rjQeUFWRZuQgL3
         Ssk6Ngp0QuYdqRLkP0HrJVouCVbB2ZHY+Nt2B6muAkiAZjvqmfsB/lg9wDMfQ0LXl4TE
         +aE7oPOtRtv/wc79hERXhKDF4DFmms1wAi1bKXsvuEDpLWXKcHNB5/2fbwVpG4KmeCUz
         zy0D2hCoxgs3QsdjKN1OCNDsKbKEaoHi8NEomxms/jTCGLrW79y1r2RHmNcSIo5ifV8i
         0Naw==
X-Gm-Message-State: AOAM532s8ip7BwznRGSyWdT7v971dDtAq6OixP+J2UbfHxdAXuFOIxlE
        B9SJ1tPe+/xJZwyDHBQAhW6DIw==
X-Google-Smtp-Source: ABdhPJxZHQNo8FP9JS6DcWArL45MYPK+lStHeqmCjQRBMTuBFDlYns0QPx1cNUS7UBPZjel3gPZTIw==
X-Received: by 2002:a5d:68c7:: with SMTP id p7mr27867094wrw.29.1589897727592;
        Tue, 19 May 2020 07:15:27 -0700 (PDT)
Received: from madeliefje.horms.nl ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id c140sm4242222wmd.18.2020.05.19.07.15.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2020 07:15:26 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Louis Peens <louis.peens@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net-next v2 1/2] nfp: flower: renaming of feature bits
Date:   Tue, 19 May 2020 16:15:01 +0200
Message-Id: <20200519141502.18676-2-simon.horman@netronome.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200519141502.18676-1-simon.horman@netronome.com>
References: <20200519141502.18676-1-simon.horman@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@netronome.com>

Clean up name aliasing. Some features gets enabled using a slightly
different method, but the bitmap for these were stored in the same
field. Rename their #defines and move the bitmap to a new variable.

Signed-off-by: Louis Peens <louis.peens@netronome.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/flower/action.c |  4 ++--
 drivers/net/ethernet/netronome/nfp/flower/cmsg.c   |  4 ++--
 drivers/net/ethernet/netronome/nfp/flower/main.c   | 14 +++++++-------
 drivers/net/ethernet/netronome/nfp/flower/main.h   |  9 ++++++---
 4 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/action.c b/drivers/net/ethernet/netronome/nfp/flower/action.c
index 1c76e1592ca2..ff844e5cc41f 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/action.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/action.c
@@ -209,7 +209,7 @@ nfp_fl_output(struct nfp_app *app, struct nfp_fl_output *output,
 					    NFP_FL_OUT_FLAGS_USE_TUN);
 		output->port = cpu_to_be32(NFP_FL_PORT_TYPE_TUN | tun_type);
 	} else if (netif_is_lag_master(out_dev) &&
-		   priv->flower_ext_feats & NFP_FL_FEATS_LAG) {
+		   priv->flower_en_feats & NFP_FL_ENABLE_LAG) {
 		int gid;
 
 		output->flags = cpu_to_be16(tmp_flags);
@@ -956,7 +956,7 @@ nfp_flower_output_action(struct nfp_app *app,
 
 	*a_len += sizeof(struct nfp_fl_output);
 
-	if (priv->flower_ext_feats & NFP_FL_FEATS_LAG) {
+	if (priv->flower_en_feats & NFP_FL_ENABLE_LAG) {
 		/* nfp_fl_pre_lag returns -err or size of prelag action added.
 		 * This will be 0 if it is not egressing to a lag dev.
 		 */
diff --git a/drivers/net/ethernet/netronome/nfp/flower/cmsg.c b/drivers/net/ethernet/netronome/nfp/flower/cmsg.c
index a595ddb92bff..a050cb898782 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/cmsg.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/cmsg.c
@@ -264,7 +264,7 @@ nfp_flower_cmsg_process_one_rx(struct nfp_app *app, struct sk_buff *skb)
 		nfp_flower_cmsg_portmod_rx(app, skb);
 		break;
 	case NFP_FLOWER_CMSG_TYPE_MERGE_HINT:
-		if (app_priv->flower_ext_feats & NFP_FL_FEATS_FLOW_MERGE) {
+		if (app_priv->flower_en_feats & NFP_FL_ENABLE_FLOW_MERGE) {
 			nfp_flower_cmsg_merge_hint_rx(app, skb);
 			break;
 		}
@@ -285,7 +285,7 @@ nfp_flower_cmsg_process_one_rx(struct nfp_app *app, struct sk_buff *skb)
 		nfp_flower_stats_rlim_reply(app, skb);
 		break;
 	case NFP_FLOWER_CMSG_TYPE_LAG_CONFIG:
-		if (app_priv->flower_ext_feats & NFP_FL_FEATS_LAG) {
+		if (app_priv->flower_en_feats & NFP_FL_ENABLE_LAG) {
 			skb_stored = nfp_flower_lag_unprocessed_msg(app, skb);
 			break;
 		}
diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.c b/drivers/net/ethernet/netronome/nfp/flower/main.c
index d8ad9346a26a..62c202307940 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.c
@@ -759,7 +759,7 @@ static int nfp_flower_init(struct nfp_app *app)
 	err = nfp_rtsym_write_le(app->pf->rtbl,
 				 "_abi_flower_balance_sync_enable", 1);
 	if (!err) {
-		app_priv->flower_ext_feats |= NFP_FL_FEATS_LAG;
+		app_priv->flower_ext_feats |= NFP_FL_ENABLE_LAG;
 		nfp_flower_lag_init(&app_priv->nfp_lag);
 	} else if (err == -ENOENT) {
 		nfp_warn(app->cpp, "LAG not supported by FW.\n");
@@ -772,7 +772,7 @@ static int nfp_flower_init(struct nfp_app *app)
 		err = nfp_rtsym_write_le(app->pf->rtbl,
 					 "_abi_flower_merge_hint_enable", 1);
 		if (!err) {
-			app_priv->flower_ext_feats |= NFP_FL_FEATS_FLOW_MERGE;
+			app_priv->flower_ext_feats |= NFP_FL_ENABLE_FLOW_MERGE;
 			nfp_flower_internal_port_init(app_priv);
 		} else if (err == -ENOENT) {
 			nfp_warn(app->cpp, "Flow merge not supported by FW.\n");
@@ -793,7 +793,7 @@ static int nfp_flower_init(struct nfp_app *app)
 	return 0;
 
 err_lag_clean:
-	if (app_priv->flower_ext_feats & NFP_FL_FEATS_LAG)
+	if (app_priv->flower_ext_feats & NFP_FL_ENABLE_LAG)
 		nfp_flower_lag_cleanup(&app_priv->nfp_lag);
 err_cleanup_metadata:
 	nfp_flower_metadata_cleanup(app);
@@ -813,10 +813,10 @@ static void nfp_flower_clean(struct nfp_app *app)
 	if (app_priv->flower_ext_feats & NFP_FL_FEATS_VF_RLIM)
 		nfp_flower_qos_cleanup(app);
 
-	if (app_priv->flower_ext_feats & NFP_FL_FEATS_LAG)
+	if (app_priv->flower_en_feats & NFP_FL_ENABLE_LAG)
 		nfp_flower_lag_cleanup(&app_priv->nfp_lag);
 
-	if (app_priv->flower_ext_feats & NFP_FL_FEATS_FLOW_MERGE)
+	if (app_priv->flower_en_feats & NFP_FL_ENABLE_FLOW_MERGE)
 		nfp_flower_internal_port_cleanup(app_priv);
 
 	nfp_flower_metadata_cleanup(app);
@@ -886,7 +886,7 @@ static int nfp_flower_start(struct nfp_app *app)
 	struct nfp_flower_priv *app_priv = app->priv;
 	int err;
 
-	if (app_priv->flower_ext_feats & NFP_FL_FEATS_LAG) {
+	if (app_priv->flower_en_feats & NFP_FL_ENABLE_LAG) {
 		err = nfp_flower_lag_reset(&app_priv->nfp_lag);
 		if (err)
 			return err;
@@ -907,7 +907,7 @@ nfp_flower_netdev_event(struct nfp_app *app, struct net_device *netdev,
 	struct nfp_flower_priv *app_priv = app->priv;
 	int ret;
 
-	if (app_priv->flower_ext_feats & NFP_FL_FEATS_LAG) {
+	if (app_priv->flower_en_feats & NFP_FL_ENABLE_LAG) {
 		ret = nfp_flower_lag_netdev_event(app_priv, netdev, event, ptr);
 		if (ret & NOTIFY_STOP_MASK)
 			return ret;
diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index d55d0d33bc45..7db3be0b17e9 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -44,8 +44,9 @@ struct nfp_app;
 #define NFP_FL_FEATS_FLOW_MOD		BIT(5)
 #define NFP_FL_FEATS_PRE_TUN_RULES	BIT(6)
 #define NFP_FL_FEATS_IPV6_TUN		BIT(7)
-#define NFP_FL_FEATS_FLOW_MERGE		BIT(30)
-#define NFP_FL_FEATS_LAG		BIT(31)
+
+#define NFP_FL_ENABLE_FLOW_MERGE	BIT(0)
+#define NFP_FL_ENABLE_LAG		BIT(1)
 
 struct nfp_fl_mask_id {
 	struct circ_buf mask_id_free_list;
@@ -145,6 +146,7 @@ struct nfp_fl_internal_ports {
  * @mask_id_seed:	Seed used for mask hash table
  * @flower_version:	HW version of flower
  * @flower_ext_feats:	Bitmap of extra features the HW supports
+ * @flower_en_feats:	Bitmap of features enabled by HW
  * @stats_ids:		List of free stats ids
  * @mask_ids:		List of free mask ids
  * @mask_table:		Hash table used to store masks
@@ -180,6 +182,7 @@ struct nfp_flower_priv {
 	u32 mask_id_seed;
 	u64 flower_version;
 	u64 flower_ext_feats;
+	u8 flower_en_feats;
 	struct nfp_fl_stats_id stats_ids;
 	struct nfp_fl_mask_id mask_ids;
 	DECLARE_HASHTABLE(mask_table, NFP_FLOWER_MASK_HASH_BITS);
@@ -346,7 +349,7 @@ nfp_flower_internal_port_can_offload(struct nfp_app *app,
 {
 	struct nfp_flower_priv *app_priv = app->priv;
 
-	if (!(app_priv->flower_ext_feats & NFP_FL_FEATS_FLOW_MERGE))
+	if (!(app_priv->flower_en_feats & NFP_FL_ENABLE_FLOW_MERGE))
 		return false;
 	if (!netdev->rtnl_link_ops)
 		return false;
-- 
2.20.1

