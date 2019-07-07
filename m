Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 751546144F
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 10:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727250AbfGGIAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 04:00:02 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:55233 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726330AbfGGIAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 04:00:01 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 09F8926BA;
        Sun,  7 Jul 2019 04:00:00 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 07 Jul 2019 04:00:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=vWJjvBoBJlmg+J3YiEnVGOj58wT74fml9CoyvCxV30U=; b=MQE1obR9
        3M9p0yaHQIQHJjsj9Z3rEvZjO6X+S3H36gfaEOdP40pqB8dy9LB/IqADxHWE8poG
        ShjA7XQf4H7KdisVQ+q/d7Ws0ftaWhqTic5vcPi+HBzSRWo8B5me0HqpNO5uz4yR
        bRKgGAaeDs29MTy1rBi2STzAXVPeowkTO5hZtRJOBlcfoWija11+j35DiE/PnHzc
        H6Rr66QZVhUDtaYE33krPllj++FF30VPz7G4vzIffMcvjL/cVbl9TMfSKy9ylEBP
        W1lEXeLLK5Nc0qTLp42RSfQZ6xQGGfOiGQVk53wuIPlKers6z7WCv+Sk6dMNUv01
        oL9BzIgdvWFiPg==
X-ME-Sender: <xms:f6YhXX8x-n3EhTVRiDt1t8Ie2c-92xE22gJnMGPmmPdhLZEg7SsPZw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrfeejgdduvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:f6YhXUf8iJWRxx59UYHPFIyUqUzEp-hxhpV5aKRlFHeqCCgH2mRH1Q>
    <xmx:f6YhXRJTn3BW5EzxHCjwl6tXko-ltr_1a9yBqIxfjam47I62bnT64g>
    <xmx:f6YhXUgBGVeOEZdBbP4UHjfzci7NfC6KBCcpqB1ethWtQuPH5ctVHw>
    <xmx:f6YhXcZnyPmZHHBzlfmO8nGs8mGwjbiy_rSDc1PJlupIsth6QiEUFw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5F620380079;
        Sun,  7 Jul 2019 03:59:57 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, andy@greyhouse.net,
        pablo@netfilter.org, jakub.kicinski@netronome.com,
        pieter.jansenvanvuuren@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 04/11] Documentation: Add devlink-trap documentation
Date:   Sun,  7 Jul 2019 10:58:21 +0300
Message-Id: <20190707075828.3315-5-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190707075828.3315-1-idosch@idosch.org>
References: <20190707075828.3315-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Add initial documentation of the devlink-trap mechanism, explaining the
background, motivation and the semantics of the interface.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 Documentation/networking/devlink-trap.rst | 179 ++++++++++++++++++++++
 Documentation/networking/index.rst        |   1 +
 include/net/devlink.h                     |   6 +
 3 files changed, 186 insertions(+)
 create mode 100644 Documentation/networking/devlink-trap.rst

diff --git a/Documentation/networking/devlink-trap.rst b/Documentation/networking/devlink-trap.rst
new file mode 100644
index 000000000000..4a4fd42f5372
--- /dev/null
+++ b/Documentation/networking/devlink-trap.rst
@@ -0,0 +1,179 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+============
+Devlink Trap
+============
+
+Background
+==========
+
+Devices capable of offloading the kernel's datapath and perform functions such
+as bridging and routing must also be able to send specific packets to the
+kernel (i.e., the CPU) for processing.
+
+For example, a device acting as a multicast-aware bridge must be able to send
+IGMP membership reports to the kernel for processing by the bridge module.
+Without processing such packets, the bridge module could never populate its
+MDB.
+
+As another example, consider a device acting as router which has received an IP
+packet with a TTL of 1. Upon routing the packet the device must send it to the
+kernel so that it will route it as well and generate an ICMP Time Exceeded
+error datagram. Without letting the kernel route such packets itself, utilities
+such as ``traceroute`` could never work.
+
+The fundamental ability of sending certain packets to the kernel for processing
+is called "packet trapping".
+
+Overview
+========
+
+The ``devlink-trap`` mechanism allows capable device drivers to register their
+supported packet traps with ``devlink`` and report trapped packets to
+``devlink`` for further analysis.
+
+Upon receiving trapped packets, ``devlink`` will perform a per-trap packets and
+bytes accounting and potentially report the packet to user space via a netlink
+event along with all the provided metadata (e.g., trap reason, timestamp, input
+port). This is especially useful for drop traps (see :ref:`Trap-Types`)
+as it allows users to obtain further visibility into packet drops that would
+otherwise be invisible.
+
+The following diagram provides a general overview of ``devlink-trap``::
+
+                                    Netlink event: Packet w/ metadata
+                                  ^
+                                  |
+         Userspace                |
+	+---------------------------------------------------+
+	 Kernel                   |
+				  |
+			     +----+----+
+			     |         |      Kernel's Rx path
+			     | devlink |      (non-drop traps)
+			     |         |
+			     +----^----+      ^
+				  |           |
+				  +-----------+
+				  |
+			  +-------+-------+
+			  |               |
+			  | Device driver |
+			  |               |
+			  +-------^-------+
+	 Kernel                   |
+	+---------------------------------------------------+
+	 Hardware                 |
+				  | Trapped packet
+				  |
+			       +--+---+
+			       |      |
+			       | ASIC |
+			       |      |
+			       +------+
+
+.. _Trap-Types:
+
+Trap Types
+==========
+
+The ``devlink-trap`` mechanism supports the following packet trap types:
+
+  * ``drop``: Trapped packets were dropped by the underlying device. Packets
+    are only processed by ``devlink`` and not injected to the kernel's Rx path.
+    The trap action (see :ref:`Trap-Actions`) can be changed.
+  * ``exception``: Trapped packets were not forwarded as intended by the
+    underlying device due to an exception (e.g., TTL error, missing neighbour
+    entry) and trapped to the control plane for resolution. Packets are
+    processed by ``devlink`` and injected to the kernel's Rx path. Changing the
+    action of such traps is not allowed, as it can easily break the control
+    plane.
+
+.. _Trap-Actions:
+
+Trap Actions
+============
+
+The ``devlink-trap`` mechanism supports the following packet trap actions:
+
+  * ``trap``: The sole copy of the packet is sent to the CPU.
+  * ``drop``: The packet is dropped by the underlying device and a copy is not
+    sent to the CPU.
+
+Generic Packet Traps
+====================
+
+Generic packet traps are used to describe traps that trap well-defined packets
+or packets that are trapped due to well-defined conditions (e.g., TTL error).
+Such traps can be shared by multiple device drivers and their description must
+be added to the following table:
+
+.. list-table:: List of Generic Packet Traps
+   :widths: 5 5 90
+
+   * - Name
+     - Type
+     - Description
+   * - ``source_mac_is_multicast``
+     - ``drop``
+     - Traps incoming packets that the device decided to drop because of a
+       multicast source MAC
+   * - ``vlan_tag_mismatch``
+     - ``drop``
+     - Traps incoming packets that the device decided to drop in case of VLAN
+       tag mismatch: The ingress bridge port is not configured with a PVID and
+       the packet is untagged or prio-tagged
+   * - ``ingress_vlan_filter``
+     - ``drop``
+     - Traps incoming packets that the device decided to drop in case they are
+       tagged with a VLAN that is not configured on the ingress bridge port
+   * - ``ingress_spanning_tree_filter``
+     - ``drop``
+     - Traps incoming packets that the device decided to drop in case the STP
+       state of the ingress bridge port is not "forwarding"
+   * - ``port_list_is_empty``
+     - ``drop``
+     - Traps packets that the device decided to drop in case they need to be
+       flooded and the flood list is empty
+   * - ``port_loopback_filter``
+     - ``drop``
+     - Traps packets that the device decided to drop in case after layer 2
+       forwarding the only port from which they should be transmitted through
+       is the port from which they were received
+   * - ``blackhole_route``
+     - ``drop``
+     - Traps packets that the device decided to drop in case they hit a
+       blackhole route
+   * - ``ttl_value_is_too_small``
+     - ``exception``
+     - Traps unicast packets that should be forwarded by the device whose TTL
+       was decremented to 0 or less
+   * - ``tail_drop``
+     - ``drop``
+     - Traps packets that the device decided to drop because they could not be
+       enqueued to a transmission queue which is full
+
+Generic Packet Trap Groups
+==========================
+
+Generic packet trap groups are used to aggregate logically related packet
+traps. These groups allow the user to batch operations such as setting the
+trap action and report state of all member traps. In addition, ``devlink-trap``
+can report aggregated per-group packets and bytes statistics, in case per-trap
+statistics are too narrow. The description of these groups must be added to the
+following table:
+
+.. list-table:: List of Generic Packet Trap Groups
+   :widths: 10 90
+
+   * - Name
+     - Description
+   * - ``l2_drops``
+     - Contains packet traps for packets that were dropped by the device during
+       layer 2 forwarding (i.e., bridge)
+   * - ``l3_drops``
+     - Contains packet traps for packets that were dropped by the device or hit
+       an exception (e.g., TTL error) during layer 3 forwarding
+   * - ``buffer_drops``
+     - Contains packet traps for packets that were dropped by the device due to
+       an enqueue decision
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index a46fca264bee..86a814e4d450 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -14,6 +14,7 @@ Contents:
    device_drivers/index
    dsa/index
    devlink-info-versions
+   devlink-trap
    ieee802154
    kapi
    z8530book
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 9121eb45b1c0..5a578750f6b4 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -520,6 +520,9 @@ struct devlink_trap {
 	u32 metadata_cap;
 };
 
+/* All traps must be documented in
+ * Documentation/networking/devlink-trap.rst
+ */
 enum devlink_trap_generic_id {
 	DEVLINK_TRAP_GENERIC_ID_SMAC_MC,
 	DEVLINK_TRAP_GENERIC_ID_VLAN_TAG_MISMATCH,
@@ -536,6 +539,9 @@ enum devlink_trap_generic_id {
 	DEVLINK_TRAP_GENERIC_ID_MAX = __DEVLINK_TRAP_GENERIC_ID_MAX - 1,
 };
 
+/* All trap groups must be documented in
+ * Documentation/networking/devlink-trap.rst
+ */
 enum devlink_trap_group_generic_id {
 	DEVLINK_TRAP_GROUP_GENERIC_ID_L2_DROPS,
 	DEVLINK_TRAP_GROUP_GENERIC_ID_L3_DROPS,
-- 
2.20.1

