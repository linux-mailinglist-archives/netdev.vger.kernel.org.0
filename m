Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F82C2DAF62
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 15:50:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730049AbgLOOuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 09:50:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38010 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729989AbgLOOug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 09:50:36 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kpBe6-0006lA-Vs; Tue, 15 Dec 2020 14:49:47 +0000
From:   Colin King <colin.king@canonical.com>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net/mlx5: fix spelling mistake in Kconfig "accelaration" -> "acceleration"
Date:   Tue, 15 Dec 2020 14:49:46 +0000
Message-Id: <20201215144946.204104-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are some spelling mistakes in the Kconfig. Fix these.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
index 6e4d7bb7fea2..bcdee9dc4aa2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -149,14 +149,14 @@ config MLX5_IPSEC
 	IPsec support for the Connect-X family.
 
 config MLX5_EN_IPSEC
-	bool "IPSec XFRM cryptography-offload accelaration"
+	bool "IPSec XFRM cryptography-offload acceleration"
 	depends on MLX5_CORE_EN
 	depends on XFRM_OFFLOAD
 	depends on INET_ESP_OFFLOAD || INET6_ESP_OFFLOAD
 	depends on MLX5_FPGA_IPSEC || MLX5_IPSEC
 	default n
 	help
-	  Build support for IPsec cryptography-offload accelaration in the NIC.
+	  Build support for IPsec cryptography-offload acceleration in the NIC.
 	  Note: Support for hardware with this capability needs to be selected
 	  for this option to become available.
 
@@ -192,7 +192,7 @@ config MLX5_TLS
 config MLX5_EN_TLS
 	bool
 	help
-	Build support for TLS cryptography-offload accelaration in the NIC.
+	Build support for TLS cryptography-offload acceleration in the NIC.
 	Note: Support for hardware with this capability needs to be selected
 	for this option to become available.
 
-- 
2.29.2

