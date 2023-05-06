Return-Path: <netdev+bounces-693-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E42706F90FE
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 11:44:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1AEB11C2196B
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 09:44:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67B9B1FB0;
	Sat,  6 May 2023 09:44:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A45A20
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 09:44:54 +0000 (UTC)
Received: from mail.nfschina.com (unknown [42.101.60.195])
	by lindbergh.monkeyblade.net (Postfix) with SMTP id 1A7F42719;
	Sat,  6 May 2023 02:44:51 -0700 (PDT)
Received: from localhost.localdomain (unknown [180.167.10.98])
	by mail.nfschina.com (Maildata Gateway V2.8.8) with ESMTPA id 59AB61801064F9;
	Sat,  6 May 2023 17:44:30 +0800 (CST)
X-MD-Sfrom: yunchuan@nfschina.com
X-MD-SrcIP: 180.167.10.98
From: wuych <yunchuan@nfschina.com>
To: ioana.ciornei@nxp.com,
	davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: netdev@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	wuych <yunchuan@nfschina.com>
Subject: [PATCH] net:ethernet:freescale:dpaa2:Remove unnecessary (void*) conversions
Date: Sat,  6 May 2023 17:44:28 +0800
Message-Id: <20230506094428.772239-1-yunchuan@nfschina.com>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Pointer variables of void * type do not require type cast.

Signed-off-by: wuych <yunchuan@nfschina.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
index 1af254caeb0d..7b2a3acd3211 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
@@ -13,7 +13,7 @@ static struct dentry *dpaa2_dbg_root;
 
 static int dpaa2_dbg_cpu_show(struct seq_file *file, void *offset)
 {
-	struct dpaa2_eth_priv *priv = (struct dpaa2_eth_priv *)file->private;
+	struct dpaa2_eth_priv *priv = file->private;
 	struct rtnl_link_stats64 *stats;
 	struct dpaa2_eth_drv_stats *extras;
 	int i;
@@ -58,7 +58,7 @@ static char *fq_type_to_str(struct dpaa2_eth_fq *fq)
 
 static int dpaa2_dbg_fqs_show(struct seq_file *file, void *offset)
 {
-	struct dpaa2_eth_priv *priv = (struct dpaa2_eth_priv *)file->private;
+	struct dpaa2_eth_priv *priv = file->private;
 	struct dpaa2_eth_fq *fq;
 	u32 fcnt, bcnt;
 	int i, err;
@@ -93,7 +93,7 @@ DEFINE_SHOW_ATTRIBUTE(dpaa2_dbg_fqs);
 
 static int dpaa2_dbg_ch_show(struct seq_file *file, void *offset)
 {
-	struct dpaa2_eth_priv *priv = (struct dpaa2_eth_priv *)file->private;
+	struct dpaa2_eth_priv *priv = file->private;
 	struct dpaa2_eth_channel *ch;
 	int i;
 
-- 
2.30.2


