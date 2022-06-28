Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 048B155E6BB
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347090AbiF1OAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 10:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347059AbiF1OAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 10:00:24 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2A487366B6
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 07:00:24 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id 74948320102;
        Tue, 28 Jun 2022 15:00:23 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.95)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1o6BlO-0008II-IH;
        Tue, 28 Jun 2022 15:00:22 +0100
Subject: [PATCH net-next v2 08/10] sfc: Unsplit literal string.
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, jonathan.s.cooper@amd.com
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Tue, 28 Jun 2022 15:00:22 +0100
Message-ID: <165642482245.31669.18060038106487469452.stgit@palantir17.mph.net>
In-Reply-To: <165642465886.31669.17429834766693417246.stgit@palantir17.mph.net>
References: <165642465886.31669.17429834766693417246.stgit@palantir17.mph.net>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,KHOP_HELO_FCRDNS,NML_ADSP_CUSTOM_MED,
        SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Cooper <jonathan.s.cooper@amd.com>

Minor fix to existing code to later patch checkpatch clean.

Signed-off-by: Jonathan Cooper <jonathan.s.cooper@amd.com>
Acked-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/efx_common.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index b4a101d0d41d..e867c3457859 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -1098,8 +1098,8 @@ int efx_init_io(struct efx_nic *efx, int bar, dma_addr_t dma_mask,
 	efx->membase_phys = pci_resource_start(efx->pci_dev, bar);
 	if (!efx->membase_phys) {
 		netif_err(efx, probe, efx->net_dev,
-			  "ERROR: No BAR%d mapping from the BIOS. "
-			  "Try pci=realloc on the kernel command line\n", bar);
+			  "ERROR: No BAR%d mapping from the BIOS. Try pci=realloc on the kernel command line\n",
+			  bar);
 		rc = -ENODEV;
 		goto fail3;
 	}


