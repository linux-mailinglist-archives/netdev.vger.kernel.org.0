Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00CAA4CAFA1
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 21:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243270AbiCBUWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 15:22:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242455AbiCBUWC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 15:22:02 -0500
Received: from smtp.smtpout.orange.fr (smtp06.smtpout.orange.fr [80.12.242.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D38A4CA0F0
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 12:21:18 -0800 (PST)
Received: from pop-os.home ([90.126.236.122])
        by smtp.orange.fr with ESMTPA
        id PVTInnglzSrXTPVTInhu5e; Wed, 02 Mar 2022 21:21:17 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Wed, 02 Mar 2022 21:21:17 +0100
X-ME-IP: 90.126.236.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Rasesh Mody <rmody@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org
Subject: [PATCH] bnx2: Fix an error message
Date:   Wed,  2 Mar 2022 21:21:15 +0100
Message-Id: <a6cf1111d372dd0a682f4ba929f9e8e2538260a6.1646252465.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix an error message and report the correct failing function.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/broadcom/bnx2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index e20aafeb4ca9..b97ed9b5f685 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -8216,7 +8216,7 @@ bnx2_init_board(struct pci_dev *pdev, struct net_device *dev)
 		rc = dma_set_coherent_mask(&pdev->dev, persist_dma_mask);
 		if (rc) {
 			dev_err(&pdev->dev,
-				"pci_set_consistent_dma_mask failed, aborting\n");
+				"dma_set_coherent_mask failed, aborting\n");
 			goto err_out_unmap;
 		}
 	} else if ((rc = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32))) != 0) {
-- 
2.32.0

