Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B375668A954
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 11:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233519AbjBDKJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 05:09:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233462AbjBDKJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 05:09:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C34E86810F
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 02:09:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 484A6B80AB2
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 10:09:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E37C433A4;
        Sat,  4 Feb 2023 10:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675505362;
        bh=JQuJhMMVOva4hYI4fykKNzad3sIcTucYYwCHT8VzwSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KcKdaBbwyo1bn/Qu3AURW4YiACfVVzn9QyH3/W5WekDntpQ6ehz2xblm3UOKqG7oP
         YHMsXRxy1j8G0e26286emX2ysOnUAQIRiwJeWj3e65QhYMYYRJ7Nd0j6LT6YHzsTjG
         UwT0NucvVSAogyxOgAYpQ2PbCxiViCJwW9dMTupXPaJ6JJp5K5xSDCHPnaP76muFsz
         e1ZNutNTYNelmElmTh7rFiA6YXpRTuduDTR1ecy9g/5OzX9vw5TI3LuHYnEgWYRLmq
         AIqAO+enu2lnw+3LJHqAUjRP0rddwm0f7D52ZYtsE07I1wkD9Ej1RfLA8jt6CXOqn9
         tmlaPtl64x61A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>,
        Gal Pressman <gal@nvidia.com>
Subject: [net-next 07/15] net/mlx5: Update Kconfig parameter documentation
Date:   Sat,  4 Feb 2023 02:08:46 -0800
Message-Id: <20230204100854.388126-8-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230204100854.388126-1-saeed@kernel.org>
References: <20230204100854.388126-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rahul Rameshbabu <rrameshbabu@nvidia.com>

Provide information for Kconfig flags defined but not documented till this
patch series for the mlx5 driver.

Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/kconfig.rst        | 127 ++++++++++++++----
 .../ethernet/mellanox/mlx5/switchdev.rst      |   2 +
 2 files changed, 100 insertions(+), 29 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/kconfig.rst b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/kconfig.rst
index a5186d59821e..43b1f7e87ec4 100644
--- a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/kconfig.rst
+++ b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/kconfig.rst
@@ -13,6 +13,14 @@ Enabling the driver and kconfig options
 | CONFIG_MLX5_CORE=y/m and CONFIG_MLX5_CORE_EN=y.
 | For the list of advanced features, please see below.
 
+**CONFIG_MLX5_BRIDGE=(y/n)**
+
+|    Enable :ref:`Ethernet Bridging (BRIDGE) offloading support <mlx5_bridge_offload>`.
+|    This will provide the ability to add representors of mlx5 uplink and VF
+|    ports to Bridge and offloading rules for traffic between such ports.
+|    Supports VLANs (trunk and access modes).
+
+
 **CONFIG_MLX5_CORE=(y/m/n)** (module mlx5_core.ko)
 
 |    The driver can be enabled by choosing CONFIG_MLX5_CORE=y/m in kernel config.
@@ -26,28 +34,53 @@ Enabling the driver and kconfig options
 |    built-in into mlx5_core.ko.
 
 
+**CONFIG_MLX5_CORE_EN_DCB=(y/n)**:
+
+|    Enables `Data Center Bridging (DCB) Support <https://community.mellanox.com/s/article/howto-auto-config-pfc-and-ets-on-connectx-4-via-lldp-dcbx>`_.
+
+
+**CONFIG_MLX5_CORE_IPOIB=(y/n)**
+
+|    IPoIB offloads & acceleration support.
+|    Requires CONFIG_MLX5_CORE_EN to provide an accelerated interface for the rdma
+|    IPoIB ulp netdevice.
+
+
+**CONFIG_MLX5_CLS_ACT=(y/n)**
+
+|    Enables offload support for TC classifier action (NET_CLS_ACT).
+|    Works in both native NIC mode and Switchdev SRIOV mode.
+|    Flow-based classifiers, such as those registered through
+|    `tc-flower(8)`, are processed by the device, rather than the
+|    host. Actions that would then overwrite matching classification
+|    results would then be instant due to the offload.
+
+
 **CONFIG_MLX5_EN_ARFS=(y/n)**
 
-|     Enables Hardware-accelerated receive flow steering (arfs) support, and ntuple filtering.
-|     https://community.mellanox.com/s/article/howto-configure-arfs-on-connectx-4
+|    Enables Hardware-accelerated receive flow steering (arfs) support, and ntuple filtering.
+|    https://community.mellanox.com/s/article/howto-configure-arfs-on-connectx-4
 
 
-**CONFIG_MLX5_EN_RXNFC=(y/n)**
+**CONFIG_MLX5_EN_IPSEC=(y/n)**
 
-|    Enables ethtool receive network flow classification, which allows user defined
-|    flow rules to direct traffic into arbitrary rx queue via ethtool set/get_rxnfc API.
+|    Enables `IPSec XFRM cryptography-offload acceleration <https://support.mellanox.com/s/article/ConnectX-6DX-Bluefield-2-IPsec-HW-Full-Offload-Configuration-Guide>`_.
 
 
-**CONFIG_MLX5_CORE_EN_DCB=(y/n)**:
+**CONFIG_MLX5_EN_MACSEC=(y/n)**
 
-|    Enables `Data Center Bridging (DCB) Support <https://community.mellanox.com/s/article/howto-auto-config-pfc-and-ets-on-connectx-4-via-lldp-dcbx>`_.
+|    Build support for MACsec cryptography-offload acceleration in the NIC.
 
 
-**CONFIG_MLX5_MPFS=(y/n)**
+**CONFIG_MLX5_EN_RXNFC=(y/n)**
 
-|    Ethernet Multi-Physical Function Switch (MPFS) support in ConnectX NIC.
-|    MPFs is required for when `Multi-Host <http://www.mellanox.com/page/multihost>`_ configuration is enabled to allow passing
-|    user configured unicast MAC addresses to the requesting PF.
+|    Enables ethtool receive network flow classification, which allows user defined
+|    flow rules to direct traffic into arbitrary rx queue via ethtool set/get_rxnfc API.
+
+
+**CONFIG_MLX5_EN_TLS=(y/n)**
+
+|    TLS cryptography-offload acceleration.
 
 
 **CONFIG_MLX5_ESWITCH=(y/n)**
@@ -58,13 +91,6 @@ Enabling the driver and kconfig options
 |           2) `Switchdev mode (eswitch offloads) <https://www.mellanox.com/related-docs/prod_software/ASAP2_Hardware_Offloading_for_vSwitches_User_Manual_v4.4.pdf>`_.
 
 
-**CONFIG_MLX5_CORE_IPOIB=(y/n)**
-
-|    IPoIB offloads & acceleration support.
-|    Requires CONFIG_MLX5_CORE_EN to provide an accelerated interface for the rdma
-|    IPoIB ulp netdevice.
-
-
 **CONFIG_MLX5_FPGA=(y/n)**
 
 |    Build support for the Innova family of network cards by Mellanox Technologies.
@@ -73,27 +99,70 @@ Enabling the driver and kconfig options
 |    building sandbox-specific client drivers.
 
 
-**CONFIG_MLX5_EN_IPSEC=(y/n)**
-
-|    Enables `IPSec XFRM cryptography-offload acceleration <http://www.mellanox.com/related-docs/prod_software/Mellanox_Innova_IPsec_Ethernet_Adapter_Card_User_Manual.pdf>`_.
+**CONFIG_MLX5_INFINIBAND=(y/n/m)** (module mlx5_ib.ko)
 
-**CONFIG_MLX5_EN_TLS=(y/n)**
+|    Provides low-level InfiniBand/RDMA and `RoCE <https://community.mellanox.com/s/article/recommended-network-configuration-examples-for-roce-deployment>`_ support.
 
-|   TLS cryptography-offload acceleration.
 
+**CONFIG_MLX5_MPFS=(y/n)**
 
-**CONFIG_MLX5_INFINIBAND=(y/n/m)** (module mlx5_ib.ko)
+|    Ethernet Multi-Physical Function Switch (MPFS) support in ConnectX NIC.
+|    MPFs is required for when `Multi-Host <http://www.mellanox.com/page/multihost>`_ configuration is enabled to allow passing
+|    user configured unicast MAC addresses to the requesting PF.
 
-|   Provides low-level InfiniBand/RDMA and `RoCE <https://community.mellanox.com/s/article/recommended-network-configuration-examples-for-roce-deployment>`_ support.
 
 **CONFIG_MLX5_SF=(y/n)**
 
-|   Build support for subfunction.
-|   Subfunctons are more light weight than PCI SRIOV VFs. Choosing this option
-|   will enable support for creating subfunction devices.
+|    Build support for subfunction.
+|    Subfunctons are more light weight than PCI SRIOV VFs. Choosing this option
+|    will enable support for creating subfunction devices.
+
+
+**CONFIG_MLX5_SF_MANAGER=(y/n)**
+
+|    Build support for subfuction port in the NIC. A Mellanox subfunction
+|    port is managed through devlink.  A subfunction supports RDMA, netdevice
+|    and vdpa device. It is similar to a SRIOV VF but it doesn't require
+|    SRIOV support.
+
+
+**CONFIG_MLX5_SW_STEERING=(y/n)**
+
+|    Build support for software-managed steering in the NIC.
+
+
+**CONFIG_MLX5_TC_CT=(y/n)**
+
+|    Support offloading connection tracking rules via tc ct action.
+
+
+**CONFIG_MLX5_TC_SAMPLE=(y/n)**
+
+|    Support offloading sample rules via tc sample action.
+
+
+**CONFIG_MLX5_VDPA=(y/n)**
+
+|    Support library for Mellanox VDPA drivers. Provides code that is
+|    common for all types of VDPA drivers. The following drivers are planned:
+|    net, block.
+
+
+**CONFIG_MLX5_VDPA_NET=(y/n)**
+
+|    VDPA network driver for ConnectX6 and newer. Provides offloading
+|    of virtio net datapath such that descriptors put on the ring will
+|    be executed by the hardware. It also supports a variety of stateless
+|    offloads depending on the actual device used and firmware version.
+
+
+**CONFIG_MLX5_VFIO_PCI=(y/n)**
+
+|    This provides migration support for MLX5 devices using the VFIO framework.
+
 
 **External options** ( Choose if the corresponding mlx5 feature is required )
 
+- CONFIG_MLXFW: When chosen, mlx5 firmware flashing support will be enabled (via devlink and ethtool).
 - CONFIG_PTP_1588_CLOCK: When chosen, mlx5 ptp support will be enabled
 - CONFIG_VXLAN: When chosen, mlx5 vxlan support will be enabled.
-- CONFIG_MLXFW: When chosen, mlx5 firmware flashing support will be enabled (via devlink and ethtool).
diff --git a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/switchdev.rst b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/switchdev.rst
index c8d895a17eb6..01deedb71597 100644
--- a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/switchdev.rst
+++ b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/switchdev.rst
@@ -7,6 +7,8 @@ Switchdev
 
 :Copyright: |copy| 2023, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
 
+.. _mlx5_bridge_offload:
+
 Bridge offload
 ==============
 
-- 
2.39.1

