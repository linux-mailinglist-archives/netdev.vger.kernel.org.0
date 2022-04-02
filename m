Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7952A4F043D
	for <lists+netdev@lfdr.de>; Sat,  2 Apr 2022 16:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346162AbiDBOs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Apr 2022 10:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356912AbiDBOsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Apr 2022 10:48:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F87213DE1;
        Sat,  2 Apr 2022 07:46:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B60C61652;
        Sat,  2 Apr 2022 14:46:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34381C340F0;
        Sat,  2 Apr 2022 14:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648910791;
        bh=S18Nwc+bp2jFTgXWo3F+mzMifw7/oZoGEU4fQotLFlo=;
        h=From:To:Cc:Subject:Date:From;
        b=HM/XUzDXCbwEL9qiZ9ayNGyTVTVgK64Fu4O2It9I/M5jndryPhhuOiNjaoW1L9l8z
         O0FmH4BxXzWfPAAxurTr18UdifiVYvbkgX14yWCXlpd3SeBJoYMHzLewgHNK62suD/
         +UJKmmjekfuge9RzCgVl7w4v6hNYxOYhNAsaZ6vi3JGpGU1cQisbEcOqC32vzpiu1j
         PD1AwBxHMRbi9q86fZY8vlheRx9cSEOJayqC2j21bEsMrfSWkZ4NA+8pAgPIAg6LQm
         qwYhFjfNd7i1PPak9y+7FlJ/8JPKl+UdaM4Gylfl6kiOLBrI+4Hoo/mb1jKMdKvY3i
         obhV8BH/QctJQ==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH] docs: net: dsa: fix minor grammar and punctuation issues
Date:   Sat,  2 Apr 2022 09:46:23 -0500
Message-Id: <20220402144623.202965-1-helgaas@kernel.org>
X-Mailer: git-send-email 2.25.1
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

From: Bjorn Helgaas <bhelgaas@google.com>

Fix a few typos and minor grammatical issues.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 Documentation/networking/dsa/dsa.rst | 64 ++++++++++++++--------------
 1 file changed, 32 insertions(+), 32 deletions(-)

diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
index 89bb4fa4c362..ddc1dd039337 100644
--- a/Documentation/networking/dsa/dsa.rst
+++ b/Documentation/networking/dsa/dsa.rst
@@ -10,21 +10,21 @@ in joining the effort.
 Design principles
 =================
 
-The Distributed Switch Architecture is a subsystem which was primarily designed
-to support Marvell Ethernet switches (MV88E6xxx, a.k.a Linkstreet product line)
-using Linux, but has since evolved to support other vendors as well.
+The Distributed Switch Architecture subsystem was primarily designed to
+support Marvell Ethernet switches (MV88E6xxx, a.k.a. Link Street product
+line) using Linux, but has since evolved to support other vendors as well.
 
 The original philosophy behind this design was to be able to use unmodified
 Linux tools such as bridge, iproute2, ifconfig to work transparently whether
 they configured/queried a switch port network device or a regular network
 device.
 
-An Ethernet switch is typically comprised of multiple front-panel ports, and one
-or more CPU or management port. The DSA subsystem currently relies on the
+An Ethernet switch typically comprises multiple front-panel ports and one
+or more CPU or management ports. The DSA subsystem currently relies on the
 presence of a management port connected to an Ethernet controller capable of
 receiving Ethernet frames from the switch. This is a very common setup for all
 kinds of Ethernet switches found in Small Home and Office products: routers,
-gateways, or even top-of-the rack switches. This host Ethernet controller will
+gateways, or even top-of-rack switches. This host Ethernet controller will
 be later referred to as "master" and "cpu" in DSA terminology and code.
 
 The D in DSA stands for Distributed, because the subsystem has been designed
@@ -33,14 +33,14 @@ using upstream and downstream Ethernet links between switches. These specific
 ports are referred to as "dsa" ports in DSA terminology and code. A collection
 of multiple switches connected to each other is called a "switch tree".
 
-For each front-panel port, DSA will create specialized network devices which are
+For each front-panel port, DSA creates specialized network devices which are
 used as controlling and data-flowing endpoints for use by the Linux networking
 stack. These specialized network interfaces are referred to as "slave" network
 interfaces in DSA terminology and code.
 
 The ideal case for using DSA is when an Ethernet switch supports a "switch tag"
 which is a hardware feature making the switch insert a specific tag for each
-Ethernet frames it received to/from specific ports to help the management
+Ethernet frame it receives to/from specific ports to help the management
 interface figure out:
 
 - what port is this frame coming from
@@ -125,7 +125,7 @@ other switches from the same fabric, and in this case, the outermost switch
 ports must decapsulate the packet.
 
 Note that in certain cases, it might be the case that the tagging format used
-by a leaf switch (not connected directly to the CPU) to not be the same as what
+by a leaf switch (not connected directly to the CPU) is not the same as what
 the network stack sees. This can be seen with Marvell switch trees, where the
 CPU port can be configured to use either the DSA or the Ethertype DSA (EDSA)
 format, but the DSA links are configured to use the shorter (without Ethertype)
@@ -270,21 +270,21 @@ These interfaces are specialized in order to:
   to/from specific switch ports
 - query the switch for ethtool operations: statistics, link state,
   Wake-on-LAN, register dumps...
-- external/internal PHY management: link, auto-negotiation etc.
+- manage external/internal PHY: link, auto-negotiation, etc.
 
 These slave network devices have custom net_device_ops and ethtool_ops function
 pointers which allow DSA to introduce a level of layering between the networking
-stack/ethtool, and the switch driver implementation.
+stack/ethtool and the switch driver implementation.
 
 Upon frame transmission from these slave network devices, DSA will look up which
-switch tagging protocol is currently registered with these network devices, and
+switch tagging protocol is currently registered with these network devices and
 invoke a specific transmit routine which takes care of adding the relevant
 switch tag in the Ethernet frames.
 
 These frames are then queued for transmission using the master network device
-``ndo_start_xmit()`` function, since they contain the appropriate switch tag, the
+``ndo_start_xmit()`` function. Since they contain the appropriate switch tag, the
 Ethernet switch will be able to process these incoming frames from the
-management interface and delivers these frames to the physical switch port.
+management interface and deliver them to the physical switch port.
 
 Graphical representation
 ------------------------
@@ -330,9 +330,9 @@ MDIO reads/writes towards specific PHY addresses. In most MDIO-connected
 switches, these functions would utilize direct or indirect PHY addressing mode
 to return standard MII registers from the switch builtin PHYs, allowing the PHY
 library and/or to return link status, link partner pages, auto-negotiation
-results etc..
+results, etc.
 
-For Ethernet switches which have both external and internal MDIO busses, the
+For Ethernet switches which have both external and internal MDIO buses, the
 slave MII bus can be utilized to mux/demux MDIO reads and writes towards either
 internal or external MDIO devices this switch might be connected to: internal
 PHYs, external PHYs, or even external switches.
@@ -349,7 +349,7 @@ DSA data structures are defined in ``include/net/dsa.h`` as well as
   table indication (when cascading switches)
 
 - ``dsa_platform_data``: platform device configuration data which can reference
-  a collection of dsa_chip_data structure if multiples switches are cascaded,
+  a collection of dsa_chip_data structures if multiple switches are cascaded,
   the master network device this switch tree is attached to needs to be
   referenced
 
@@ -426,7 +426,7 @@ logic basically looks like this:
   "phy-handle" property, if found, this PHY device is created and registered
   using ``of_phy_connect()``
 
-- if Device Tree is used, and the PHY device is "fixed", that is, conforms to
+- if Device Tree is used and the PHY device is "fixed", that is, conforms to
   the definition of a non-MDIO managed PHY as defined in
   ``Documentation/devicetree/bindings/net/fixed-link.txt``, the PHY is registered
   and connected transparently using the special fixed MDIO bus driver
@@ -481,7 +481,7 @@ Device Tree
 DSA features a standardized binding which is documented in
 ``Documentation/devicetree/bindings/net/dsa/dsa.txt``. PHY/MDIO library helper
 functions such as ``of_get_phy_mode()``, ``of_phy_connect()`` are also used to query
-per-port PHY specific details: interface connection, MDIO bus location etc..
+per-port PHY specific details: interface connection, MDIO bus location, etc.
 
 Driver development
 ==================
@@ -509,7 +509,7 @@ Switch configuration
 
 - ``setup``: setup function for the switch, this function is responsible for setting
   up the ``dsa_switch_ops`` private structure with all it needs: register maps,
-  interrupts, mutexes, locks etc.. This function is also expected to properly
+  interrupts, mutexes, locks, etc. This function is also expected to properly
   configure the switch to separate all network interfaces from each other, that
   is, they should be isolated by the switch hardware itself, typically by creating
   a Port-based VLAN ID for each port and allowing only the CPU port and the
@@ -526,13 +526,13 @@ PHY devices and link management
 - ``get_phy_flags``: Some switches are interfaced to various kinds of Ethernet PHYs,
   if the PHY library PHY driver needs to know about information it cannot obtain
   on its own (e.g.: coming from switch memory mapped registers), this function
-  should return a 32-bits bitmask of "flags", that is private between the switch
+  should return a 32-bit bitmask of "flags" that is private between the switch
   driver and the Ethernet PHY driver in ``drivers/net/phy/\*``.
 
 - ``phy_read``: Function invoked by the DSA slave MDIO bus when attempting to read
   the switch port MDIO registers. If unavailable, return 0xffff for each read.
   For builtin switch Ethernet PHYs, this function should allow reading the link
-  status, auto-negotiation results, link partner pages etc..
+  status, auto-negotiation results, link partner pages, etc.
 
 - ``phy_write``: Function invoked by the DSA slave MDIO bus when attempting to write
   to the switch port MDIO registers. If unavailable return a negative error
@@ -554,7 +554,7 @@ Ethtool operations
 ------------------
 
 - ``get_strings``: ethtool function used to query the driver's strings, will
-  typically return statistics strings, private flags strings etc.
+  typically return statistics strings, private flags strings, etc.
 
 - ``get_ethtool_stats``: ethtool function used to query per-port statistics and
   return their values. DSA overlays slave network devices general statistics:
@@ -564,7 +564,7 @@ Ethtool operations
 - ``get_sset_count``: ethtool function used to query the number of statistics items
 
 - ``get_wol``: ethtool function used to obtain Wake-on-LAN settings per-port, this
-  function may, for certain implementations also query the master network device
+  function may for certain implementations also query the master network device
   Wake-on-LAN settings if this interface needs to participate in Wake-on-LAN
 
 - ``set_wol``: ethtool function used to configure Wake-on-LAN settings per-port,
@@ -607,14 +607,14 @@ Power management
   in a fully active state
 
 - ``port_enable``: function invoked by the DSA slave network device ndo_open
-  function when a port is administratively brought up, this function should be
-  fully enabling a given switch port. DSA takes care of marking the port with
+  function when a port is administratively brought up, this function should
+  fully enable a given switch port. DSA takes care of marking the port with
   ``BR_STATE_BLOCKING`` if the port is a bridge member, or ``BR_STATE_FORWARDING`` if it
   was not, and propagating these changes down to the hardware
 
 - ``port_disable``: function invoked by the DSA slave network device ndo_close
-  function when a port is administratively brought down, this function should be
-  fully disabling a given switch port. DSA takes care of marking the port with
+  function when a port is administratively brought down, this function should
+  fully disable a given switch port. DSA takes care of marking the port with
   ``BR_STATE_DISABLED`` and propagating changes to the hardware if this port is
   disabled while being a bridge member
 
@@ -622,12 +622,12 @@ Bridge layer
 ------------
 
 - ``port_bridge_join``: bridge layer function invoked when a given switch port is
-  added to a bridge, this function should be doing the necessary at the switch
-  level to permit the joining port from being added to the relevant logical
+  added to a bridge, this function should do what's necessary at the switch
+  level to permit the joining port to be added to the relevant logical
   domain for it to ingress/egress traffic with other members of the bridge.
 
 - ``port_bridge_leave``: bridge layer function invoked when a given switch port is
-  removed from a bridge, this function should be doing the necessary at the
+  removed from a bridge, this function should do what's necessary at the
   switch level to deny the leaving port from ingress/egress traffic from the
   remaining bridge members. When the port leaves the bridge, it should be aged
   out at the switch hardware for the switch to (re) learn MAC addresses behind
@@ -663,7 +663,7 @@ Bridge layer
   point for drivers that need to configure the hardware for enabling this
   feature.
 
-- ``port_bridge_tx_fwd_unoffload``: bridge layer function invoken when a driver
+- ``port_bridge_tx_fwd_unoffload``: bridge layer function invoked when a driver
   leaves a bridge port which had the TX forwarding offload feature enabled.
 
 Bridge VLAN filtering
-- 
2.25.1

