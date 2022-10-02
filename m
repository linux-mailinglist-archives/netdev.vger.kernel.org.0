Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 267195F264F
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 00:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbiJBWwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 18:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbiJBWut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 18:50:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A55AD17880;
        Sun,  2 Oct 2022 15:50:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 401B9B80DA8;
        Sun,  2 Oct 2022 22:50:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03EEFC433D6;
        Sun,  2 Oct 2022 22:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664751002;
        bh=6pTTRmUAv0wG9o5dh0evjFMOU1DGy3ZXeepzUNql1x8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DehSZ2kQxW7nkY/xf9pOSvXTN68IeJPEAwdYyYTpn+bMu8lq338WS8c8JqKX3k+9x
         cfra6q7JSc+kXTVPCqXiApesW1Wtgj8BWozPXbPdQBjDuQ0HXjOPhIXsWcDBORpAmU
         lNUBUyzrhShxRP0ankyIh6BWQFc4IwI5X9+dOz5iFhfQlds/c3Zsyo/KWy4zighVaK
         Q6MLMIve6ABdtPBITWANuMeMib4Vw1MjpjOQqGnS+HnPaGirqdJABXaRF7Z3S/o95+
         N7Q1qogdxastZGZakMOOBnvHcSMLixfQxiAouL6Dtcjy/bxD/AZSlQL6MG9gSX5Lfz
         f7tvzGVZ3yqZQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, tchornyi@marvell.com,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 14/29] net: marvell: prestera: add support for for Aldrin2
Date:   Sun,  2 Oct 2022 18:49:07 -0400
Message-Id: <20221002224922.238837-14-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221002224922.238837-1-sashal@kernel.org>
References: <20221002224922.238837-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oleksandr Mazur <oleksandr.mazur@plvision.eu>

[ Upstream commit 9124dbcc2dd6c51e81f97f63f7807118c4eb140a ]

Aldrin2 (98DX8525) is a Marvell Prestera PP, with 100G support.

Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>

V2:
  - retarget to net tree instead of net-next;
  - fix missed colon in patch subject ('net marvell' vs 'net: mavell');
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/prestera/prestera_pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_pci.c b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
index f538a749ebd4..59470d99f522 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_pci.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
@@ -872,6 +872,7 @@ static void prestera_pci_remove(struct pci_dev *pdev)
 static const struct pci_device_id prestera_pci_devices[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0xC804) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0xC80C) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0xCC1E) },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, prestera_pci_devices);
-- 
2.35.1

