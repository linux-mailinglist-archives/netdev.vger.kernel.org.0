Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 013A15F2690
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 00:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbiJBWyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 18:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbiJBWxn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 18:53:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E52A3140C3;
        Sun,  2 Oct 2022 15:51:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2698C60EF1;
        Sun,  2 Oct 2022 22:51:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95795C4347C;
        Sun,  2 Oct 2022 22:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664751082;
        bh=FwbwQPKFTF3a8L2qY0gfAa0I4GeaFvNfWc6aR5w3SX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HHXorzxTRODPEvpZGz9N91Rlo88moHhsMcYJWBgQFDkbjtRxXrDV+XCbD2BAV4aGt
         FapEamhSbdXoA7iIeQ/A1Kfh+XK8wOeZQTcleVXJXOCp1O89EW/NrXdCd/aEng4/9I
         RA1Bw4lQxjYhIRAuu0xBuCl5cBieJs4EZot48hgSTzNQUtgYrzefUe+RkJqteKReJw
         /5w6gy5CWIUFH/UTDDH4nGBezqa8fSa7zmxAfwxaHZCiFbBGAPeBX9dyJbFPEIVhtq
         js4UItQSVsPQSzXDDrODDI/F+PdlrJ2HcjIPcKvw2kk2+P2J2Wr3GN9Z9WRFQGkLtZ
         g/3lSzZL9NNmQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, tchornyi@marvell.com,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 11/20] net: marvell: prestera: add support for for Aldrin2
Date:   Sun,  2 Oct 2022 18:50:50 -0400
Message-Id: <20221002225100.239217-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221002225100.239217-1-sashal@kernel.org>
References: <20221002225100.239217-1-sashal@kernel.org>
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
index a250d394da38..a8d7b889ebee 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_pci.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
@@ -815,6 +815,7 @@ static void prestera_pci_remove(struct pci_dev *pdev)
 static const struct pci_device_id prestera_pci_devices[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0xC804) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0xC80C) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0xCC1E) },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, prestera_pci_devices);
-- 
2.35.1

