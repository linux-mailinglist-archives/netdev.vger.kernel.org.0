Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA58667D004
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 16:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232262AbjAZPWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 10:22:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232259AbjAZPWs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 10:22:48 -0500
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [IPv6:2001:4b98:dc4:8::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D7B36BBD6;
        Thu, 26 Jan 2023 07:22:28 -0800 (PST)
Received: from booty.fritz.box (unknown [77.244.183.192])
        (Authenticated sender: luca.ceresoli@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPA id CCC7724000B;
        Thu, 26 Jan 2023 15:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1674746531;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=y4XXZUb/eXTVLt3Io7nRJONtjd6MFURYEBCczeziRlI=;
        b=n4O/TPhP8ss3Yw55rWDZdfKA5BDB3pD/eXKOubNenym/Wz0Z3oFGqXygem7AXQ4QxtQUs0
        aTFUIxv3UvBbXaXdfjKt/+DxdiIH3m9pjffuOqX3kEawUd0mIoICswgkMt7Cl2V+9f/nlP
        wZtZJUP9mFhHT8NCsMwnF+uxqasFUWG+4xeiWbYsWAqegNctl6/A3D+q+p+1IifdAbD+ru
        UjJ9ogApnYQW65IA/tLjadQBDynMEBwsEPvMih4MQzWaAqI8kJqr9zHQN6Oc88cQ1ZyKA8
        qBD027A6BojfXIfwIovLnoGdIEzq5/ovTr1GPKV7MYxKP8XDojIjVN3rfVcGNQ==
From:   Luca Ceresoli <luca.ceresoli@bootlin.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Shengjiu Wang <shengjiu.wang@gmail.com>,
        Xiubo Li <Xiubo.Lee@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        Nicolin Chen <nicoleotsuka@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Luca Ceresoli <luca.ceresoli@bootlin.com>
Cc:     Colin Ian King <colin.i.king@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        dev@openvswitch.org, alsa-devel@alsa-project.org,
        linuxppc-dev@lists.ozlabs.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: [PATCH] scripts/spelling.txt: add "exsits" pattern and fix typo instances
Date:   Thu, 26 Jan 2023 16:22:05 +0100
Message-Id: <20230126152205.959277-1-luca.ceresoli@bootlin.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix typos and add the following to the scripts/spelling.txt:

  exsits||exists

Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c | 2 +-
 net/openvswitch/flow_table.c             | 2 +-
 scripts/spelling.txt                     | 1 +
 sound/soc/fsl/fsl-asoc-card.c            | 2 +-
 4 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 620ae5b2d80d..6b7603765383 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -446,7 +446,7 @@ iscsi_iser_conn_create(struct iscsi_cls_session *cls_session,
  * @is_leading:      indicate if this is the session leading connection (MCS)
  *
  * Return: zero on success, $error if iscsi_conn_bind fails and
- *         -EINVAL in case end-point doesn't exsits anymore or iser connection
+ *         -EINVAL in case end-point doesn't exists anymore or iser connection
  *         state is not UP (teardown already started).
  */
 static int iscsi_iser_conn_bind(struct iscsi_cls_session *cls_session,
diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index 0a0e4c283f02..cfac54cbafdf 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -1012,7 +1012,7 @@ static int flow_mask_insert(struct flow_table *tbl, struct sw_flow *flow,
 
 	mask = flow_mask_find(tbl, new);
 	if (!mask) {
-		/* Allocate a new mask if none exsits. */
+		/* Allocate a new mask if none exists. */
 		mask = mask_alloc();
 		if (!mask)
 			return -ENOMEM;
diff --git a/scripts/spelling.txt b/scripts/spelling.txt
index ded8bcfc0247..0147bd8dc6e2 100644
--- a/scripts/spelling.txt
+++ b/scripts/spelling.txt
@@ -625,6 +625,7 @@ exeuction||execution
 existance||existence
 existant||existent
 exixt||exist
+exsits||exists
 exlcude||exclude
 exlcusive||exclusive
 exmaple||example
diff --git a/sound/soc/fsl/fsl-asoc-card.c b/sound/soc/fsl/fsl-asoc-card.c
index 8d14b5593658..2f25358196ee 100644
--- a/sound/soc/fsl/fsl-asoc-card.c
+++ b/sound/soc/fsl/fsl-asoc-card.c
@@ -811,7 +811,7 @@ static int fsl_asoc_card_probe(struct platform_device *pdev)
 	priv->card.num_links = 1;
 
 	if (asrc_pdev) {
-		/* DPCM DAI Links only if ASRC exsits */
+		/* DPCM DAI Links only if ASRC exists */
 		priv->dai_link[1].cpus->of_node = asrc_np;
 		priv->dai_link[1].platforms->of_node = asrc_np;
 		priv->dai_link[2].codecs->dai_name = codec_dai_name;
-- 
2.34.1

