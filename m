Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 656C73189AD
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 12:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231651AbhBKLkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 06:40:08 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:19366 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230527AbhBKLhM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 06:37:12 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602516b20000>; Thu, 11 Feb 2021 03:36:18 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 11 Feb
 2021 11:36:17 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 11 Feb 2021 11:36:14 +0000
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Boris Pismenny <borisp@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next 3/3] net/mlx5: Remove TLS dependencies on XPS
Date:   Thu, 11 Feb 2021 13:35:53 +0200
Message-ID: <20210211113553.8211-4-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210211113553.8211-1-tariqt@nvidia.com>
References: <20210211113553.8211-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613043378; bh=+3gMQLFY4TlxalhWaD4il2P7z+xRDknu5WPT8tLyZAM=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type;
        b=WrQa0o7nlkJtH+JLat14sB3MA3deIiCmJmHUlAMyd0oh4EWWs3IlsJBHUmPrRefuQ
         PgOEhkS3wgrAVK+DvF1tMgdq6o6ogPIiZ8Clmz77cBO8+zZDW2DC75j7QcUZzR2Z1Q
         XC/i/Sd1iUZTxqtKHODo8wDDoPnlCkdjZKgY2oub01ZUTTkNTLpy+BRFA5274YqDra
         jbMsMUPk5zpa2rbYjHpk6xXea6727Xrq32f8w/7l1218WJXFf8Nf3vyj3SLOUryyO0
         M10AJpB9lnMDBCxnFElq3Ma6xzevkw1dn9mnAggXZyRZ471tg7Qzgrr/51nGMzAl2N
         D4ovC/YmzZl8Q==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No real dependency on XPS, but on RX queue mapping, which
is being selected by TLS_DEVICE.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/=
ethernet/mellanox/mlx5/core/Kconfig
index ad45d20f9d44..372d902bca5a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -166,7 +166,6 @@ config MLX5_FPGA_TLS
 	depends on TLS=3Dy || MLX5_CORE=3Dm
 	depends on MLX5_CORE_EN
 	depends on MLX5_FPGA
-	depends on XPS
 	select MLX5_EN_TLS
 	default n
 	help
@@ -181,7 +180,6 @@ config MLX5_TLS
 	depends on TLS_DEVICE
 	depends on TLS=3Dy || MLX5_CORE=3Dm
 	depends on MLX5_CORE_EN
-	depends on XPS
 	select MLX5_ACCEL
 	select MLX5_EN_TLS
 	default n
--=20
2.21.0

