Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE4F74C194B
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 18:04:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243134AbiBWRFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 12:05:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243122AbiBWRFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 12:05:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48F3450078
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 09:04:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6F01B82115
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 17:04:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B678C340F1;
        Wed, 23 Feb 2022 17:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645635877;
        bh=Gfry74FnYuQXw4rfbL/4QE0F5PwrDFX+2pqJBMC8lkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aqyNC6WTCgKpEK1CjG0/h6GRddVW0IQTKmVSVTBaAyPtucrQbWoNfFo14zoiAkwMw
         Mr9BYiaZIjgPEpNxuruDr0d2gFrRyt/ANWI+gIewIp44F3CFmk0AeXHH19t1ldjPb/
         WfXbiBQ4lyDNBtyjzoKnbRd4pRDc5VBbnDUs2noFpzSjyI/axb9dJjBi8Wa4IUcBna
         DWbpORxjNyG5Ho4sQZ4GRZCpcDZDbSKivPQQl7ng4+ZpXVIK8bXto3lZnL0NR/JhoD
         9r1RCppraxKJuVhLs8x3ooaoRrISh7H0SlecAUN9hWyiMcwN1Q/dB189VF6ADqQrVj
         58kKQJTZCIm6A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Meir Lichtinger <meirl@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 01/19] net/mlx5: Update the list of the PCI supported devices
Date:   Wed, 23 Feb 2022 09:04:12 -0800
Message-Id: <20220223170430.295595-2-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220223170430.295595-1-saeed@kernel.org>
References: <20220223170430.295595-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Meir Lichtinger <meirl@nvidia.com>

Add the upcoming BlueField-4 and ConnectX-8 device IDs.

Fixes: 2e9d3e83ab82 ("net/mlx5: Update the list of the PCI supported devices")
Signed-off-by: Meir Lichtinger <meirl@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 2c774f367199..13f913c13a2d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1840,10 +1840,12 @@ static const struct pci_device_id mlx5_core_pci_table[] = {
 	{ PCI_VDEVICE(MELLANOX, 0x101e), MLX5_PCI_DEV_IS_VF},	/* ConnectX Family mlx5Gen Virtual Function */
 	{ PCI_VDEVICE(MELLANOX, 0x101f) },			/* ConnectX-6 LX */
 	{ PCI_VDEVICE(MELLANOX, 0x1021) },			/* ConnectX-7 */
+	{ PCI_VDEVICE(MELLANOX, 0x1023) },			/* ConnectX-8 */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d2) },			/* BlueField integrated ConnectX-5 network controller */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d3), MLX5_PCI_DEV_IS_VF},	/* BlueField integrated ConnectX-5 network controller VF */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d6) },			/* BlueField-2 integrated ConnectX-6 Dx network controller */
 	{ PCI_VDEVICE(MELLANOX, 0xa2dc) },			/* BlueField-3 integrated ConnectX-7 network controller */
+	{ PCI_VDEVICE(MELLANOX, 0xa2df) },			/* BlueField-4 integrated ConnectX-8 network controller */
 	{ 0, }
 };
 
-- 
2.35.1

