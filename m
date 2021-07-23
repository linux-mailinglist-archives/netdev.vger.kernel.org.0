Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8B7A3D36F5
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 10:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234413AbhGWIBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 04:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbhGWIBv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 04:01:51 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86C7C061575;
        Fri, 23 Jul 2021 01:42:23 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id hs23so2392338ejc.13;
        Fri, 23 Jul 2021 01:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3M9JuvVp63fPiQaYbgdh4tvLmQS/3eXNn4ByqxrfU4I=;
        b=EmFUMnWimzTyvDGk4jNyLpn5X0UXFXZe7EDTwcCa4nKiQ89dacTdS/j+4SUICRV8cu
         bMVy7j4BqT+L5uqouHzMonYR+qwSBlsN/Twz5pczYdl58tb1lBzzO5EGWyHpHZbiNyqa
         0UVvIzphsxLVmtIh3LaMBHA0G7idenIvhjTPxv6js0q1Y0jAaErj/AOoB0kDMvIzLSJ1
         7zIEg85Oqm2h7d58df33Vbbn2CBgkHkCDk6oHrxWVH3cDBZgqva8OzuqkWwfhBQdC6qE
         UvJgqW06OKr4CDPQuljEOoPHvEjkYJP20jU0/miDKtS+mENXOmrfAsxi9FZTWC/fdHYQ
         fyKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3M9JuvVp63fPiQaYbgdh4tvLmQS/3eXNn4ByqxrfU4I=;
        b=Dq3zdu4GMEWAJpkq7jOcWT5xWjWGamZD7odIiX2Yh86PySzIRFI8MEDhL/Q2l2vnjX
         b14xfI84/JDcOkx/14d/QqqFDlYH7Tut0HpP+K3k5737khwBNLvWkjVpee1heAVV4JVr
         dqSIdQkPKUAZscbcTpypF5wFJ2tkj6fJwS+3qKgQxk1DKKr6WJrTo/V3E6InlYribvvm
         LeReGGvfsnMmpPXZJooiKD5lZW935V+qGsWaM7UCC0G2sXKv+R6peC3kBs43bcxIap1k
         2JhEe6SrQWfUg0eIN1ueQl7HqeEKFd5IPhWrPFaaALfvFucjMktSqSCcXbYKPpneQ42t
         GEUw==
X-Gm-Message-State: AOAM5322EQGlAypkxKo+cp1vpjK5Vb/Dg3Pqk0kSb1OU575njc6TYsho
        wRG4dZNUZ5PpmUwfqCit74vadK7KDL/H/A==
X-Google-Smtp-Source: ABdhPJzW5CGOPSlSxwq71OLX0j0H0B3FBUVveqD2lsyZ9GyY5Cg9m1MSl+0e/qfrvNHMWzD1ecUhPw==
X-Received: by 2002:a17:907:24d1:: with SMTP id e17mr3545660ejn.427.1627029742196;
        Fri, 23 Jul 2021 01:42:22 -0700 (PDT)
Received: from yoga-910.localhost ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id ja13sm10298477ejc.82.2021.07.23.01.42.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 01:42:21 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     corbet@lwn.net, linux-doc@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2] docs: networking: dpaa2: add documentation for the switch driver
Date:   Fri, 23 Jul 2021 11:42:44 +0300
Message-Id: <20210723084244.950197-1-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Add a documentation entry for the DPAA2 switch listing its
requirements, features and some examples to go along them.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../ethernet/freescale/dpaa2/index.rst        |   1 +
 .../freescale/dpaa2/switch-driver.rst         | 174 ++++++++++++++++++
 MAINTAINERS                                   |   1 +
 3 files changed, 176 insertions(+)
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
index 000000000000..863ca6bd8318
--- /dev/null
+++ b/Documentation/networking/device_drivers/ethernet/freescale/dpaa2/switch-driver.rst
@@ -0,0 +1,174 @@
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
+ * The minimum number of FDBs should be at least equal to the number of switch
+   interfaces. This is necessary so that separation of switch ports can be
+   done, ie when not under a bridge, each switch port will have its own FDB.
+   ::
+
+        fsl_dpaa2_switch dpsw.0: The number of FDBs is lower than the number of ports, cannot probe
+
+ * Both the broadcast and flooding configuration should be per FDB. This
+   enables the driver to restrict the broadcast and flooding domains of each
+   FDB depending on the switch ports that are sharing it (aka are under the
+   same bridge).
+   ::
+
+        fsl_dpaa2_switch dpsw.0: Flooding domain is not per FDB, cannot probe
+        fsl_dpaa2_switch dpsw.0: Broadcast domain is not per FDB, cannot probe
+
+ * The control interface of the switch should not be disabled
+   (DPSW_OPT_CTRL_IF_DIS not passed as a create time option). Without the
+   control interface, the driver is not capable to provide proper Rx/Tx traffic
+   support on the switch port netdevices.
+   ::
+
+        fsl_dpaa2_switch dpsw.0: Control Interface is disabled, cannot probe
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
+The hardware is not configurable with respect to VLAN awareness, thus any DPAA2
+switch port should be used only in usecases with a VLAN aware bridge::
+
+        $ ip link add dev br0 type bridge vlan_filtering 1
+
+        $ ip link add dev br1 type bridge
+        $ ip link set dev ethX master br1
+        Error: fsl_dpaa2_switch: Cannot join a VLAN-unaware bridge
+
+Topology and loop detection through STP is supported when ``stp_state 1`` is
+used at bridge create ::
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
+Example 4: Use a single shared filter block on both eth5 and eth6::
+
+        $ tc qdisc add dev eth5 ingress_block 1 clsact
+        $ tc qdisc add dev eth6 ingress_block 1 clsact
+        $ tc filter add block 1 ingress flower dst_mac 00:01:02:03:04:04 skip_sw \
+                action trap
+        $ tc filter add block 1 ingress protocol ipv4 flower src_ip 192.168.1.1 skip_sw \
+                action mirred egress redirect dev eth3
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

