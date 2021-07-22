Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1943D248F
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 15:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232132AbhGVMqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 08:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232118AbhGVMqk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 08:46:40 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E853BC061757
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 06:27:14 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id ga14so8378186ejc.6
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 06:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=POWpwm7eTXduCglpQjTkSnSyMZers9jD1y7x+UUfQTQ=;
        b=oUsI1HCJUP8tAwhgnFjZQESPpP/9fkh1i7W9/DhQqRySzVhxvIeT+YFJpXFqHn3/rr
         UeJKVFoKuzdKfwfw3AuXAp19L+yYHGVa1zZIHoQuIGdO3Yl7aFy3UBlS/dVb0S0Ks2fe
         mZowFBFMoDaRfMGrmKSnuuEw+06e0KAemrtyS8jMzwKTUrJEyvLL/GjquFmvV9+nD/7J
         qJ+u34QgZsgECy0SLbiDcLoMIxKJ8PSWgbTHdfq8R/IN1j0OW1wlgV5nU1u5G0Rtjs3n
         Orbv2xM/TxNoGPFUPWam5ermlQ0nfn1oN4Cxov1pVpz6PflAv62pkKkuT9axLSHO2/iL
         9X3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=POWpwm7eTXduCglpQjTkSnSyMZers9jD1y7x+UUfQTQ=;
        b=C7TmZcWSfxwmguD2r8c6itAsv3aonTbUikO/aZ3dfBjGW0Lc0wQi3A5pM/hA8wd9vX
         9kaSUFtDln2+aTJv9n2k3mey/LPtEblQpw/lTYw9ZXZdLBYkBM804V9IX+hU84MsffAK
         TOYXgVHg7289DVBQoFqw+pR0jxBHG/VHDEzUG46FzexWJDc2rlaOUSYUgd/MnmAsdMtY
         I+ZML8ApvpnWYv47q4eg0ibySn3/sqvPeQqpDvddt5mehxxyvOaGZ5VYL6goGRgaWikn
         765lgCy5AHn423nHLtwuEKuMZWDrfu5mCHgVbnYmwxSvGZLTYoxrfToKM0TKccfLKIAi
         PwyA==
X-Gm-Message-State: AOAM530picgLzwldoy7yJB3Iofak6draLuEiscs0QaDSlzmkgAT32teN
        S7zJ5aWWAK8EAoR7DaYWn0E=
X-Google-Smtp-Source: ABdhPJyeo3yJkGBQC0mgqagZ5P8e5oTWJnVZnzBzFMgmweTzPhL+4lvMaMLr3hDtU0WewPSmgFfZPA==
X-Received: by 2002:a17:906:6dcb:: with SMTP id j11mr18385674ejt.202.1626960433403;
        Thu, 22 Jul 2021 06:27:13 -0700 (PDT)
Received: from yoga-910.localhost ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id h3sm9516251ejf.53.2021.07.22.06.27.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 06:27:12 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     corbet@lwn.net, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next] docs: networking: dpaa2: add documentation for the switch driver
Date:   Thu, 22 Jul 2021 16:27:35 +0300
Message-Id: <20210722132735.685606-1-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Add a documentation entry for the DPAA2 switch listing it's
requirements, features and some examples to go along them.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../ethernet/freescale/dpaa2/index.rst        |   1 +
 .../freescale/dpaa2/switch-driver.rst         | 167 ++++++++++++++++++
 MAINTAINERS                                   |   1 +
 3 files changed, 169 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/ethernet/freescale/dpaa2/switch-driver.rst

diff --git a/Documentation/networking/device_drivers/ethernet/freescale/dpaa2/index.rst b/Documentation/networking/device_drivers/ethernet/freescale/dpaa2/index.rst
index ee40fcc5ddff..62f4a4aff6ec 100644
--- a/Documentation/networking/device_drivers/ethernet/freescale/dpaa2/index.rst
+++ b/Documentation/networking/device_drivers/ethernet/freescale/dpaa2/index.rst
@@ -9,3 +9,4 @@ DPAA2 Documentation
    dpio-driver
    ethernet-driver
    mac-phy-support
+   switch-driver
diff --git a/Documentation/networking/device_drivers/ethernet/freescale/dpaa2/switch-driver.rst b/Documentation/networking/device_drivers/ethernet/freescale/dpaa2/switch-driver.rst
new file mode 100644
index 000000000000..dbeed66e0e4d
--- /dev/null
+++ b/Documentation/networking/device_drivers/ethernet/freescale/dpaa2/switch-driver.rst
@@ -0,0 +1,167 @@
+.. SPDX-License-Identifier: GPL-2.0
+.. include:: <isonum.txt>
+
+===================
+DPAA2 Switch driver
+===================
+
+:Copyright: |copy| 2021 NXP
+
+The DPAA2 Switch driver probes on the Datapath Switch (DPSW) object which can
+be instantiated on the following DPAA2 SoCs and their variants: LS2088A and
+LX2160A.
+
+The driver uses the switch device driver model and exposes each switch port as
+a network interface, which can be included in a bridge or used as a standalone
+interface. Traffic switched between ports is offloaded into the hardware.
+
+The DPSW can have ports connected to DPNIs or to DPMACs for external access.
+::
+
+         [ethA]     [ethB]      [ethC]     [ethD]     [ethE]     [ethF]
+            :          :          :          :          :          :
+            :          :          :          :          :          :
+       [dpaa2-eth]  [dpaa2-eth]  [              dpaa2-switch              ]
+            :          :          :          :          :          :        kernel
+       =============================================================================
+            :          :          :          :          :          :        hardware
+         [DPNI]      [DPNI]     [============= DPSW =================]
+            |          |          |          |          |          |
+            |           ----------           |       [DPMAC]    [DPMAC]
+             -------------------------------            |          |
+                                                        |          |
+                                                      [PHY]      [PHY]
+
+Creating an Ethernet Switch
+===========================
+
+The dpaa2-switch driver probes on DPSW devices found on the fsl-mc bus. These
+devices can be either created statically through the boot time configuration
+file - DataPath Layout (DPL) - or at runtime using the DPAA2 object APIs
+(incorporated already into the restool userspace tool).
+
+At the moment, the dpaa2-switch driver imposes the following restrictions on
+the DPSW object that it will probe:
+
+ * The maximum number of FDBs should be at least equal to the number of switch
+   interfaces. This is necessary so that separation of switch ports can be
+   done, ie when not under a bridge, each switch port will have its own FDB.
+
+ * Both the broadcast and flooding configuration should be per FDB. This
+   enables the driver to restrict the broadcast and flooding domains of each
+   FDB depending on the switch ports that are sharing it (aka are under the
+   same bridge).
+
+ * The control interface of the switch should not be disabled
+   (DPSW_OPT_CTRL_IF_DIS not passed as a create time option). Without the
+   control interface, the driver is not capable to provide proper Rx/Tx traffic
+   support on the switch port netdevices.
+
+Besides the configuration of the actual DPSW object, the dpaa2-switch driver
+will need the following DPAA2 objects:
+
+ * 1 DPMCP - A Management Command Portal object is needed for any interraction
+   with the MC firmware.
+
+ * 1 DPBP - A Buffer Pool is used for seeding buffers intended for the Rx path
+   on the control interface.
+
+ * Access to at least one DPIO object (Software Portal) is needed for any
+   enqueue/dequeue operation to be performed on the control interface queues.
+   The DPIO object will be shared, no need for a private one.
+
+Switching features
+==================
+
+The driver supports the configuration of L2 forwarding rules in hardware for
+port bridging as well as standalone usage of the independent switch interfaces.
+
+The hardware is not configurable with respect to VLAN awareness, thus any DPAA2 switch port should be used only in usecases with a VLAN aware bridge::
+
+        $ ip link add dev br0 type bridge vlan_filtering 1
+
+        $ ip link add dev br1 type bridge
+        $ ip link set dev ethX master br1
+        Error: fsl_dpaa2_switch: Cannot join a VLAN-unaware bridge
+
+Topology and loop detection through STP is supported when ``stp_state 1`` is used at bridge create ::
+
+        $ ip link add dev br0 type bridge vlan_filtering 1 stp_state 1
+
+L2 FDB manipulation (add/delete/dump) is supported.
+
+HW FDB learning can be configured on each switch port independently through
+bridge commands. When the HW learning is disabled, a fast age procedure will be
+run and any previously learnt addresses will be removed.
+::
+
+        $ bridge link set dev ethX learning off
+        $ bridge link set dev ethX learning on
+
+Restricting the unknown unicast and multicast flooding domain is supported, but
+not independently of each other::
+
+        $ ip link set dev ethX type bridge_slave flood off mcast_flood off
+        $ ip link set dev ethX type bridge_slave flood off mcast_flood on
+        Error: fsl_dpaa2_switch: Cannot configure multicast flooding independently of unicast.
+
+Broadcast flooding on a switch port can be disabled/enabled through the brport sysfs::
+
+        $ echo 0 > /sys/bus/fsl-mc/devices/dpsw.Y/net/ethX/brport/broadcast_flood
+
+Offloads
+========
+
+Routing actions (redirect, trap, drop)
+--------------------------------------
+
+The DPAA2 switch is able to offload flow-based redirection of packets making
+use of ACL tables. Shared filter blocks are supported by sharing a single ACL
+table between multiple ports.
+
+The following flow keys are supported:
+
+ * Ethernet: dst_mac/src_mac
+ * IPv4: dst_ip/src_ip/ip_proto/tos
+ * VLAN: vlan_id/vlan_prio/vlan_tpid/vlan_dei
+ * L4: dst_port/src_port
+
+Also, the matchall filter can be used to redirect the entire traffic received
+on a port.
+
+As per flow actions, the following are supported:
+
+ * drop
+ * mirred egress redirect
+ * trap
+
+Each ACL entry (filter) can be setup with only one of the listed
+actions.
+
+A sorted single linked list is used to keep the ACL entries by their
+order of priority. When adding a new filter, this enables us to quickly
+ascertain if the new entry has the highest priority of the entire block
+or if we should make some space in the ACL table by increasing the
+priority of the filters already in the table.
+
+
+Example 1: send frames received on eth4 with a SA of 00:01:02:03:04:05 to the
+CPU::
+
+        $ tc qdisc add dev eth4 clsact
+        $ tc filter add dev eth4 ingress flower src_mac 00:01:02:03:04:05 skip_sw action trap
+
+Example 2: drop frames received on eth4 with VID 100 and PCP of 3::
+
+        $ tc filter add dev eth4 ingress protocol 802.1q flower skip_sw vlan_id 100 vlan_prio 3 action drop
+
+Example 3: redirect all frames received on eth4 to eth1::
+
+        $ tc filter add dev eth4 ingress matchall action mirred egress redirect dev eth1
+
+
+Example 4: Use a single shared filter block on both eth5 and eth6::
+
+        $ tc qdisc add dev eth5 ingress_block 1 clsact
+        $ tc qdisc add dev eth6 ingress_block 1 clsact
+        $ tc filter add block 1 ingress flower dst_mac 00:01:02:03:04:04 skip_sw action trap
diff --git a/MAINTAINERS b/MAINTAINERS
index da478d5c8b0c..a483934ac8f0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5683,6 +5683,7 @@ DPAA2 ETHERNET SWITCH DRIVER
 M:	Ioana Ciornei <ioana.ciornei@nxp.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	Documentation/networking/device_drivers/ethernet/freescale/dpaa2/switch-driver.rst
 F:	drivers/net/ethernet/freescale/dpaa2/dpaa2-switch*
 F:	drivers/net/ethernet/freescale/dpaa2/dpsw*
 
-- 
2.31.1

