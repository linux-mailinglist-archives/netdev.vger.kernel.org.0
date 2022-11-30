Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E95063CE98
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 06:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233385AbiK3FMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 00:12:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233304AbiK3FMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 00:12:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 873DE76161
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 21:12:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 005AD61A0D
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 05:12:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BECEC433C1;
        Wed, 30 Nov 2022 05:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669785126;
        bh=JbIywWjO46hcOzriJ9sgPflHfCGMtKpoSMCQouRjKLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Szqe+WkZjHsfeTKuVJm3BbGp0deAbGrmyC0S7zvfkjQcCZl3h8ba13TORlEJoA7cO
         F6G3gEWXHrNxV9tPuyv4NKOjmktGQFCH/gzBpVFct/sZ1D+KskhjJ3mn7WFmDBkPeh
         t1dXFO6o+qjIEC91uUQu1Iux/jGVkv48LX+Jh1CCtaRlre24iH5aNrXBjy3YIv+DiY
         74wNYn7AyhWYzM/Pq4TJJrcXIC3OxtBOZE9bTT3MZuiFfAJSWXxtAqrb5E4nU36Tkl
         9Eup13MFNmnZqA/1Qk/5HvStTQ7Jv8CvKXhiuWa9XNfdxU8GObyMKYi09IbU0RYsdW
         vIziCowv5DRzw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>,
        Gal Pressman <gal@nvidia.com>
Subject: [net-next 08/15] net/mlx5: Fix orthography errors in documentation
Date:   Tue, 29 Nov 2022 21:11:45 -0800
Message-Id: <20221130051152.479480-9-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130051152.479480-1-saeed@kernel.org>
References: <20221130051152.479480-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rahul Rameshbabu <rrameshbabu@nvidia.com>

Improve general readability of the device driver documentation.

Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../device_drivers/ethernet/mellanox/mlx5.rst | 82 +++++++++----------
 1 file changed, 41 insertions(+), 41 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
index 5edf50d7dbd5..e8fa7ac9e6b1 100644
--- a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
+++ b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
@@ -25,7 +25,7 @@ Enabling the driver and kconfig options
 | at build time via kernel Kconfig flags.
 | Basic features, ethernet net device rx/tx offloads and XDP, are available with the most basic flags
 | CONFIG_MLX5_CORE=y/m and CONFIG_MLX5_CORE_EN=y.
-| For the list of advanced features please see below.
+| For the list of advanced features, please see below.
 
 **CONFIG_MLX5_CORE=(y/m/n)** (module mlx5_core.ko)
 
@@ -89,11 +89,11 @@ Enabling the driver and kconfig options
 
 **CONFIG_MLX5_EN_IPSEC=(y/n)**
 
-|    Enables `IPSec XFRM cryptography-offload accelaration <http://www.mellanox.com/related-docs/prod_software/Mellanox_Innova_IPsec_Ethernet_Adapter_Card_User_Manual.pdf>`_.
+|    Enables `IPSec XFRM cryptography-offload acceleration <http://www.mellanox.com/related-docs/prod_software/Mellanox_Innova_IPsec_Ethernet_Adapter_Card_User_Manual.pdf>`_.
 
 **CONFIG_MLX5_EN_TLS=(y/n)**
 
-|   TLS cryptography-offload accelaration.
+|   TLS cryptography-offload acceleration.
 
 
 **CONFIG_MLX5_INFINIBAND=(y/n/m)** (module mlx5_ib.ko)
@@ -139,14 +139,14 @@ flow_steering_mode: Device flow steering mode
 The flow steering mode parameter controls the flow steering mode of the driver.
 Two modes are supported:
 1. 'dmfs' - Device managed flow steering.
-2. 'smfs  - Software/Driver managed flow steering.
+2. 'smfs' - Software/Driver managed flow steering.
 
 In DMFS mode, the HW steering entities are created and managed through the
 Firmware.
 In SMFS mode, the HW steering entities are created and managed though by
-the driver directly into Hardware without firmware intervention.
+the driver directly into hardware without firmware intervention.
 
-SMFS mode is faster and provides better rule inserstion rate compared to default DMFS mode.
+SMFS mode is faster and provides better rule insertion rate compared to default DMFS mode.
 
 User command examples:
 
@@ -165,9 +165,9 @@ User command examples:
 enable_roce: RoCE enablement state
 ----------------------------------
 RoCE enablement state controls driver support for RoCE traffic.
-When RoCE is disabled, there is no gid table, only raw ethernet QPs are supported and traffic on the well known UDP RoCE port is handled as raw ethernet traffic.
+When RoCE is disabled, there is no gid table, only raw ethernet QPs are supported and traffic on the well-known UDP RoCE port is handled as raw ethernet traffic.
 
-To change RoCE enablement state a user must change the driverinit cmode value and run devlink reload.
+To change RoCE enablement state, a user must change the driverinit cmode value and run devlink reload.
 
 User command examples:
 
@@ -186,7 +186,7 @@ User command examples:
 
 esw_port_metadata: Eswitch port metadata state
 ----------------------------------------------
-When applicable, disabling Eswitch metadata can increase packet rate
+When applicable, disabling eswitch metadata can increase packet rate
 up to 20% depending on the use case and packet sizes.
 
 Eswitch port metadata state controls whether to internally tag packets with
@@ -253,26 +253,26 @@ mlx5 subfunction
 ================
 mlx5 supports subfunction management using devlink port (see :ref:`Documentation/networking/devlink/devlink-port.rst <devlink_port>`) interface.
 
-A Subfunction has its own function capabilities and its own resources. This
+A subfunction has its own function capabilities and its own resources. This
 means a subfunction has its own dedicated queues (txq, rxq, cq, eq). These
 queues are neither shared nor stolen from the parent PCI function.
 
-When a subfunction is RDMA capable, it has its own QP1, GID table and rdma
+When a subfunction is RDMA capable, it has its own QP1, GID table, and RDMA
 resources neither shared nor stolen from the parent PCI function.
 
 A subfunction has a dedicated window in PCI BAR space that is not shared
-with ther other subfunctions or the parent PCI function. This ensures that all
-devices (netdev, rdma, vdpa etc.) of the subfunction accesses only assigned
+with the other subfunctions or the parent PCI function. This ensures that all
+devices (netdev, rdma, vdpa, etc.) of the subfunction accesses only assigned
 PCI BAR space.
 
-A Subfunction supports eswitch representation through which it supports tc
+A subfunction supports eswitch representation through which it supports tc
 offloads. The user configures eswitch to send/receive packets from/to
 the subfunction port.
 
 Subfunctions share PCI level resources such as PCI MSI-X IRQs with
 other subfunctions and/or with its parent PCI function.
 
-Example mlx5 software, system and device view::
+Example mlx5 software, system, and device view::
 
        _______
       | admin |
@@ -310,7 +310,7 @@ Example mlx5 software, system and device view::
            |                                      (device add/del)
       _____|____                                    ____|________
      |          |                                  | subfunction |
-     |  PCI NIC |---- activate/deactive events---->| host driver |
+     |  PCI NIC |--- activate/deactivate events--->| host driver |
      |__________|                                  | (mlx5_core) |
                                                    |_____________|
 
@@ -320,7 +320,7 @@ Subfunction is created using devlink port interface.
 
     $ devlink dev eswitch set pci/0000:06:00.0 mode switchdev
 
-- Add a devlink port of subfunction flaovur::
+- Add a devlink port of subfunction flavour::
 
     $ devlink port add pci/0000:06:00.0 flavour pcisf pfnum 0 sfnum 88
     pci/0000:06:00.0/32768: type eth netdev eth6 flavour pcisf controller 0 pfnum 0 sfnum 88 external false splittable false
@@ -379,18 +379,18 @@ device created for the PCI VF/SF.
       function:
         hw_addr 00:00:00:00:00:00
 
-- Set the MAC address of the VF identified by its unique devlink port index::
+- Set the MAC address of the SF identified by its unique devlink port index::
 
     $ devlink port function set pci/0000:06:00.0/32768 hw_addr 00:00:00:00:88:88
 
     $ devlink port show pci/0000:06:00.0/32768
-    pci/0000:06:00.0/32768: type eth netdev enp6s0pf0sf88 flavour pcivf pfnum 0 sfnum 88
+    pci/0000:06:00.0/32768: type eth netdev enp6s0pf0sf88 flavour pcisf pfnum 0 sfnum 88
       function:
         hw_addr 00:00:00:00:88:88
 
 SF state setup
 --------------
-To use the SF, the user must active the SF using the SF function state
+To use the SF, the user must activate the SF using the SF function state
 attribute.
 
 - Get the state of the SF identified by its unique devlink port index::
@@ -447,7 +447,7 @@ for it.
 
 Additionally, the SF port also gets the event when the driver attaches to the
 auxiliary device of the subfunction. This results in changing the operational
-state of the function. This provides visiblity to the user to decide when is it
+state of the function. This provides visibility to the user to decide when is it
 safe to delete the SF port for graceful termination of the subfunction.
 
 - Show the SF port operational state::
@@ -464,14 +464,14 @@ tx reporter
 -----------
 The tx reporter is responsible for reporting and recovering of the following two error scenarios:
 
-- TX timeout
+- tx timeout
     Report on kernel tx timeout detection.
     Recover by searching lost interrupts.
-- TX error completion
+- tx error completion
     Report on error tx completion.
-    Recover by flushing the TX queue and reset it.
+    Recover by flushing the tx queue and reset it.
 
-TX reporter also support on demand diagnose callback, on which it provides
+tx reporter also support on demand diagnose callback, on which it provides
 real time information of its send queues status.
 
 User commands examples:
@@ -491,32 +491,32 @@ rx reporter
 -----------
 The rx reporter is responsible for reporting and recovering of the following two error scenarios:
 
-- RX queues initialization (population) timeout
-    RX queues descriptors population on ring initialization is done in
-    napi context via triggering an irq, in case of a failure to get
-    the minimum amount of descriptors, a timeout would occur and it
-    could be recoverable by polling the EQ (Event Queue).
-- RX completions with errors (reported by HW on interrupt context)
+- rx queues' initialization (population) timeout
+    Population of rx queues' descriptors on ring initialization is done
+    in napi context via triggering an irq. In case of a failure to get
+    the minimum amount of descriptors, a timeout would occur, and
+    descriptors could be recovered by polling the EQ (Event Queue).
+- rx completions with errors (reported by HW on interrupt context)
     Report on rx completion error.
     Recover (if needed) by flushing the related queue and reset it.
 
-RX reporter also supports on demand diagnose callback, on which it
-provides real time information of its receive queues status.
+rx reporter also supports on demand diagnose callback, on which it
+provides real time information of its receive queues' status.
 
-- Diagnose rx queues status, and corresponding completion queue::
+- Diagnose rx queues' status and corresponding completion queue::
 
     $ devlink health diagnose pci/0000:82:00.0 reporter rx
 
-NOTE: This command has valid output only when interface is up, otherwise the command has empty output.
+NOTE: This command has valid output only when interface is up. Otherwise, the command has empty output.
 
 - Show number of rx errors indicated, number of recover flows ended successfully,
-  is autorecover enabled and graceful period from last recover::
+  is autorecover enabled, and graceful period from last recover::
 
     $ devlink health show pci/0000:82:00.0 reporter rx
 
 fw reporter
 -----------
-The fw reporter implements diagnose and dump callbacks.
+The fw reporter implements `diagnose` and `dump` callbacks.
 It follows symptoms of fw error such as fw syndrome by triggering
 fw core dump and storing it into the dump buffer.
 The fw reporter diagnose command can be triggered any time by the user to check
@@ -537,7 +537,7 @@ running it on other PF or any VF will return "Operation not permitted".
 
 fw fatal reporter
 -----------------
-The fw fatal reporter implements dump and recover callbacks.
+The fw fatal reporter implements `dump` and `recover` callbacks.
 It follows fatal errors indications by CR-space dump and recover flow.
 The CR-space dump uses vsc interface which is valid even if the FW command
 interface is not functional, which is the case in most FW fatal errors.
@@ -552,7 +552,7 @@ User commands examples:
 
     $ devlink health recover pci/0000:82:00.0 reporter fw_fatal
 
-- Read FW CR-space dump if already strored or trigger new one::
+- Read FW CR-space dump if already stored or trigger new one::
 
     $ devlink health dump show pci/0000:82:00.1 reporter fw_fatal
 
@@ -561,10 +561,10 @@ NOTE: This command can run only on PF.
 mlx5 tracepoints
 ================
 
-mlx5 driver provides internal trace points for tracking and debugging using
+mlx5 driver provides internal tracepoints for tracking and debugging using
 kernel tracepoints interfaces (refer to Documentation/trace/ftrace.rst).
 
-For the list of support mlx5 events check /sys/kernel/debug/tracing/events/mlx5/
+For the list of support mlx5 events, check `/sys/kernel/debug/tracing/events/mlx5/`.
 
 tc and eswitch offloads tracepoints:
 
-- 
2.38.1

