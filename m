Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 355B78B1BA
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 09:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728123AbfHMH4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 03:56:23 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:54233 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727777AbfHMH4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 03:56:22 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 822A82FC4;
        Tue, 13 Aug 2019 03:56:21 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 13 Aug 2019 03:56:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=KKvSdMyusgRmxi3WBUEpj2mLncKCa9vRS/3USrrgzDs=; b=MAfMf7MA
        StnyY6ad5p1s77rXPSlKDIEVeUJXYHAh7s7XJW1nvsBs5h0XuTIZvRNaHV58WnAb
        7GLNt1EKACa0DbaGls0+4yWJ1Yn6OeWpbFxaxQe8ItE6fiMYa8Qn1jcvrdz2ksk5
        7EXJusb/0a0SRF7pxCMucSJ/oocSFGE/cc4ZvKU4xzf5xmDxkKGfhW1JI6S+Hdhj
        hl4RnmcdrXY+M9bZxBIUyianurH5a7j0bwelYrW3QslUKs4JkFDX0fsC/XJOXHIi
        1jQCNS3xHoZ9/xQu5iP5NDEpf36qcqqEZJeBc+p/L1V//09b1DVUkTcy92EpJMIC
        iCAiePxmPLlwQw==
X-ME-Sender: <xms:JW1SXSCdO1PX9v43C-_fGsaRXWjBA-p19jUCaQsvbHNUKaXqZjhJqw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddvhedguddviecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgv
    rhfuihiivgeptd
X-ME-Proxy: <xmx:JW1SXQycMTpWs3IbrW1RTOxgpgY_m7vL6Jw9R_8sJyzCSYJ0c1phIA>
    <xmx:JW1SXQkmDV5mVhN92ED2z27TRXc8pd4bCG1M3GpTSfyXJD1gBXxnqw>
    <xmx:JW1SXVFREMm6fPkkoEMKaLtDNgwYq8_ONbf_lmqIOAZHCIzowL9r9A>
    <xmx:JW1SXbZwxlheoq_aTAQ13UEsKybwTrWdU5jipz717prvPEwCDr_aYA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id E74D580059;
        Tue, 13 Aug 2019 03:56:17 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, jiri@mellanox.com,
        toke@redhat.com, dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 10/14] Documentation: Add devlink-trap documentation
Date:   Tue, 13 Aug 2019 10:53:56 +0300
Message-Id: <20190813075400.11841-11-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190813075400.11841-1-idosch@idosch.org>
References: <20190813075400.11841-1-idosch@idosch.org>
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
 Documentation/networking/devlink-trap.rst | 187 ++++++++++++++++++++++
 Documentation/networking/index.rst        |   1 +
 include/net/devlink.h                     |   6 +
 3 files changed, 194 insertions(+)
 create mode 100644 Documentation/networking/devlink-trap.rst

diff --git a/Documentation/networking/devlink-trap.rst b/Documentation/networking/devlink-trap.rst
new file mode 100644
index 000000000000..dbc7a3e00fd8
--- /dev/null
+++ b/Documentation/networking/devlink-trap.rst
@@ -0,0 +1,187 @@
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
+                                                   Or a summary of recent drops
+                                  ^
+                                  |
+         Userspace                |
+        +---------------------------------------------------+
+         Kernel                   |
+                                  |
+                          +-------+--------+
+                          |                |
+                          |  drop_monitor  |
+                          |                |
+                          +-------^--------+
+                                  |
+                                  |
+                                  |
+                             +----+----+
+                             |         |      Kernel's Rx path
+                             | devlink |      (non-drop traps)
+                             |         |
+                             +----^----+      ^
+                                  |           |
+                                  +-----------+
+                                  |
+                          +-------+-------+
+                          |               |
+                          | Device driver |
+                          |               |
+                          +-------^-------+
+         Kernel                   |
+        +---------------------------------------------------+
+         Hardware                 |
+                                  | Trapped packet
+                                  |
+                               +--+---+
+                               |      |
+                               | ASIC |
+                               |      |
+                               +------+
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
+traps. These groups allow the user to batch operations such as setting the trap
+action of all member traps. In addition, ``devlink-trap`` can report aggregated
+per-group packets and bytes statistics, in case per-trap statistics are too
+narrow. The description of these groups must be added to the following table:
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
index fb02e0e89f9d..7f43c48f54cd 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -540,6 +540,9 @@ struct devlink_trap {
 	u32 metadata_cap;
 };
 
+/* All traps must be documented in
+ * Documentation/networking/devlink-trap.rst
+ */
 enum devlink_trap_generic_id {
 	DEVLINK_TRAP_GENERIC_ID_SMAC_MC,
 	DEVLINK_TRAP_GENERIC_ID_VLAN_TAG_MISMATCH,
@@ -556,6 +559,9 @@ enum devlink_trap_generic_id {
 	DEVLINK_TRAP_GENERIC_ID_MAX = __DEVLINK_TRAP_GENERIC_ID_MAX - 1,
 };
 
+/* All trap groups must be documented in
+ * Documentation/networking/devlink-trap.rst
+ */
 enum devlink_trap_group_generic_id {
 	DEVLINK_TRAP_GROUP_GENERIC_ID_L2_DROPS,
 	DEVLINK_TRAP_GROUP_GENERIC_ID_L3_DROPS,
-- 
2.21.0

