Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D33A2C688
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 14:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbfE1Mbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 08:31:32 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:48723 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727135AbfE1MbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 08:31:22 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id E3F9B211D;
        Tue, 28 May 2019 08:22:43 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 28 May 2019 08:22:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=7rU2txfDb0uDs4sYXa/9uIqO5Ud4IP06r0WvU/4vEb8=; b=GCe9QEzE
        LGLLqvxJx/q2heXVCIebxZGvWSiyFkKcOlZaRPNO4TPyL7DTJTDIuZbIzNOFCuIY
        SN8KUG6eGfvDImCFm6ygdvJD6qAE5c/ZlzNYWDux7xX8Jhggiu5y+yRL7VyLVo9L
        K2Vgp1RCq1ST/DArkdtjFHAMpPLu69Rqher3F2yVbH5KpcLE727GcIzmyrWiHsrT
        UDyJ5BgdtkSI7Dsb+/9R6SW26WWdBRm8npkh4rnfgmdNzAv4e7icdERJ2xH8vS2H
        GPQVaNzErH1A9nItCUZyHqD/Z5HwaiPXX9M9OOVcim/E3bAF34jjgLMDndQI4D7N
        RzSX7hmRi6OY3A==
X-ME-Sender: <xms:EyjtXHtkLUr3aw1CWXxiU076AzSHLJrsMiO8XTo2s9sivaxL4dd5Ww>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddvhedgheduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedv
X-ME-Proxy: <xmx:EyjtXKtOzKfOLM5NCdRqDprb4ucpRYK9yUAkySC3HVkhj2h-OtRynQ>
    <xmx:EyjtXND8krsw4Q2r08WRvaLLhRh2-V9PtD0YDFGeMvFFWA2f005Chg>
    <xmx:EyjtXMPyJ-tFCScZMQQh0DAqjNUr1lpm21EQUEWQLuK2070VA35RUg>
    <xmx:EyjtXEoti48sqVbi0cCPl9UAWy5Aa4sCmLDAab97SWGAruBL_ML1Ig>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2B2C0380085;
        Tue, 28 May 2019 08:22:41 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, andy@greyhouse.net,
        pablo@netfilter.org, jakub.kicinski@netronome.com,
        pieter.jansenvanvuuren@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@savoirfairelinux.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [RFC PATCH net-next 04/12] Documentation: Add devlink-trap documentation
Date:   Tue, 28 May 2019 15:21:28 +0300
Message-Id: <20190528122136.30476-5-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190528122136.30476-1-idosch@idosch.org>
References: <20190528122136.30476-1-idosch@idosch.org>
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
---
 Documentation/networking/devlink-trap.rst | 189 ++++++++++++++++++++++
 Documentation/networking/index.rst        |   1 +
 include/net/devlink.h                     |   6 +
 3 files changed, 196 insertions(+)
 create mode 100644 Documentation/networking/devlink-trap.rst

diff --git a/Documentation/networking/devlink-trap.rst b/Documentation/networking/devlink-trap.rst
new file mode 100644
index 000000000000..4b3045bc76d1
--- /dev/null
+++ b/Documentation/networking/devlink-trap.rst
@@ -0,0 +1,189 @@
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
+   * - ``ingress_smac_mc_drop``
+     - ``drop``
+     - Traps incoming packets that the device decided to drop because of a
+       multicast source MAC
+   * - ``ingress_vlan_tag_allow_drop``
+     - ``drop``
+     - Traps incoming packets that the device decided to drop in case the
+       ingress bridge port is not configured with a PVID and the packet is
+       untagged or prio-tagged
+   * - ``ingress_vlan_filter_drop``
+     - ``drop``
+     - Traps incoming packets that the device decided to drop in case they are
+       tagged with a VLAN that is not configured on the ingress bridge port
+   * - ``ingress_stp_filter_drop``
+     - ``drop``
+     - Traps incoming packets that the device decided to drop in case the STP
+       state of the ingress bridge port is "listening", "disabled" or
+       "blocking"
+   * - ``uc_empty_tx_list_drop``
+     - ``drop``
+     - Traps packets with a unicast MAC that the device decided to drop in case
+       they need to be flooded and the flood list is empty
+   * - ``mc_empty_tx_list_drop``
+     - ``drop``
+     - Traps packets with a multicast MAC that the device decided to drop in
+       case they need to be flooded and the flood list is empty
+   * - ``uc_loopback_filter_drop``
+     - ``drop``
+     - Traps packets with a unicast MAC that the device decided to drop in case
+       after layer 2 forwarding the only port from which they should be
+       transmitted through is the port from which they were received
+   * - ``blackhole_route_drop``
+     - ``drop``
+     - Traps packets that the device decided to drop in case they hit a
+       blackhole route
+   * - ``ttl_error_exception``
+     - ``exception``
+     - Traps unicast packets that should be forwarded by the device whose TTL
+       was decremented to 0 or less
+   * - ``tail_drop``
+     - ``drop``
+     - Traps packets that the device decided to drop because they could not be
+       enqueued to a transmission queue which is full
+   * - ``early_drop``
+     - ``drop``
+     - Traps packets that the device decided to drop due to the decision of the
+       Random Early Detection (RED) queueing discipline to earlydrop the
+       packet
+
+Generic Packet Trap Groups
+==========================
+
+Generic packet trap groups are used to aggregate logically related packet
+traps. These groups allow the user to batch operations such as setting the
+trap action and report state of all member traps. In addtion, ``devlink-trap``
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
index f390fe3cfdfb..c09bf85ec050 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -26,6 +26,7 @@ Contents:
    device_drivers/intel/ice
    dsa/index
    devlink-info-versions
+   devlink-trap
    ieee802154
    kapi
    z8530book
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 6cfa1ab36e3f..4e095a70b466 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -524,6 +524,9 @@ struct devlink_trap {
 	u32 metadata_cap;
 };
 
+/* All traps must be documented in
+ * Documentation/networking/devlink-trap.rst
+ */
 enum devlink_trap_generic_id {
 	DEVLINK_TRAP_GENERIC_ID_INGRESS_SMAC_MC_DROP,
 	DEVLINK_TRAP_GENERIC_ID_INGRESS_VLAN_TAG_ALLOW_DROP,
@@ -542,6 +545,9 @@ enum devlink_trap_generic_id {
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

