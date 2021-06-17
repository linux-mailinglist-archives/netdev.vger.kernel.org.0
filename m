Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2663AA923
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 04:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbhFQCuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 22:50:08 -0400
Received: from mx21.baidu.com ([220.181.3.85]:52774 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230267AbhFQCuH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 22:50:07 -0400
Received: from BC-Mail-Ex31.internal.baidu.com (unknown [172.31.51.25])
        by Forcepoint Email with ESMTPS id 25E1EB5CA77508766B1A;
        Thu, 17 Jun 2021 10:32:23 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BC-Mail-Ex31.internal.baidu.com (172.31.51.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.4; Thu, 17 Jun 2021 10:32:22 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.4; Thu, 17 Jun 2021 10:32:22 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <saeedm@nvidia.com>, <leonro@nvidia.com>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        caihuoqing <caihuoqing@baidu.com>
Subject: [PATCH] net/mlx5: remove "default n" from Kconfig
Date:   Thu, 17 Jun 2021 10:32:15 +0800
Message-ID: <20210617023215.176-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BJHW-Mail-Ex10.internal.baidu.com (10.127.64.33) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: caihuoqing <caihuoqing@baidu.com>

remove "default n" and "No" is default

Signed-off-by: caihuoqing <caihuoqing@baidu.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
index d62f90aedade..e1a5a79e27c7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -12,7 +12,6 @@ config MLX5_CORE
        depends on MLXFW || !MLXFW
        depends on PTP_1588_CLOCK || !PTP_1588_CLOCK
        depends on PCI_HYPERV_INTERFACE || !PCI_HYPERV_INTERFACE
-       default n
        help
          Core driver for low level functionality of the ConnectX-4 and
          Connect-IB cards by Mellanox Technologies.
@@ -36,7 +35,6 @@ config MLX5_CORE_EN
        depends on NETDEVICES && ETHERNET && INET && PCI && MLX5_CORE
        select PAGE_POOL
        select DIMLIB
-       default n
        help
          Ethernet support in Mellanox Technologies ConnectX-4 NIC.
 
@@ -141,7 +139,6 @@ config MLX5_CORE_EN_DCB
 config MLX5_CORE_IPOIB
        bool "Mellanox 5th generation network adapters (connectX series) IPoIB offloads support"
        depends on MLX5_CORE_EN
-       default n
        help
          MLX5 IPoIB offloads & acceleration support.
 
@@ -149,7 +146,6 @@ config MLX5_FPGA_IPSEC
        bool "Mellanox Technologies IPsec Innova support"
        depends on MLX5_CORE
        depends on MLX5_FPGA
-       default n
        help
        Build IPsec support for the Innova family of network cards by Mellanox
        Technologies. Innova network cards are comprised of a ConnectX chip
@@ -163,7 +159,6 @@ config MLX5_IPSEC
        depends on XFRM_OFFLOAD
        depends on INET_ESP_OFFLOAD || INET6_ESP_OFFLOAD
        select MLX5_ACCEL
-       default n
        help
        Build IPsec support for the Connect-X family of network cards by Mellanox
        Technologies.
@@ -176,7 +171,6 @@ config MLX5_EN_IPSEC
        depends on XFRM_OFFLOAD
        depends on INET_ESP_OFFLOAD || INET6_ESP_OFFLOAD
        depends on MLX5_FPGA_IPSEC || MLX5_IPSEC
-       default n
        help
          Build support for IPsec cryptography-offload acceleration in the NIC.
          Note: Support for hardware with this capability needs to be selected
@@ -189,7 +183,6 @@ config MLX5_FPGA_TLS
        depends on MLX5_CORE_EN
        depends on MLX5_FPGA
        select MLX5_EN_TLS
-       default n
        help
        Build TLS support for the Innova family of network cards by Mellanox
        Technologies. Innova network cards are comprised of a ConnectX chip
@@ -204,7 +197,6 @@ config MLX5_TLS
        depends on MLX5_CORE_EN
        select MLX5_ACCEL
        select MLX5_EN_TLS
-       default n
        help
        Build TLS support for the Connect-X family of network cards by Mellanox
        Technologies.
@@ -227,7 +219,6 @@ config MLX5_SW_STEERING
 config MLX5_SF
        bool "Mellanox Technologies subfunction device support using auxiliary device"
        depends on MLX5_CORE && MLX5_CORE_EN
-       default n
        help
        Build support for subfuction device in the NIC. A Mellanox subfunction
        device can support RDMA, netdevice and vdpa device.
-- 
2.22.0

