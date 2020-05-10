Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF78D1CCC5E
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 18:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729312AbgEJQoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 12:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729225AbgEJQnq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 May 2020 12:43:46 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D707C05BD09;
        Sun, 10 May 2020 09:43:46 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id s8so7910044wrt.9;
        Sun, 10 May 2020 09:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Vv8Y68lEcckqpjaX1Ww0vGpx3GEjoFzLyevxXV72hA0=;
        b=QgeegJyEmcC2D4fjl1YELffkihWsvPVrFdyQFtT4BQcK0VeLvSJ0q3w7MjnnptpvQL
         KuMElZoJ0SgcoW3nr7I9WThP3CmXhWGZmIH0AmZr506JugGBlONdYbGW28XtOosgLoxZ
         /RRvXVXd6gV36efojgqBdOxVWKOJPshYGVR1JyFwa7v1X3pfm2W/0n71NnqwEgAOGHd2
         S5a1+oJ8PVMjfioPVD4yDKeo64djrOdzDowY0urwqDVSmXRP9GZLlJQHtzagPVk2LNMq
         8zXO84mi5tDm49qWoV3tLLkpdxSQops/AbCrcbhqO+vAuIHvjrh2n74BvyUnObIjhNJ6
         P3Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Vv8Y68lEcckqpjaX1Ww0vGpx3GEjoFzLyevxXV72hA0=;
        b=r3cttg26Y3fpBSmqqrKFZsxOFKGPpFPvef7YhXyTXi26jOaNW/Yrpl+zLwtJ1SlTBJ
         +14RgJKrWFIaFbbWuq5UJ7Bw+JHj9bp0h/Bcx2mMfNXXGX2ac686K/9/V3FDcVVA3P/U
         DYLtBaytPCORFD4+R7B8+5i0Cqzp1KpctHatv6KSsTivOEEhNwfUASYHEVdDrfGa0Szc
         qEMqmh1u5vPKZDOlXsXCWRYJQ7+v4CCxEiS0CsCbU8Bmo2azjzaNLW48TCEVIcZdwnyz
         bIK4JcXlxE7Sm1SBVx3CR+s6DM62xD/hiBzXNYNA1YIbkaU5nXJA8fTkvyOounWChZIW
         7dPg==
X-Gm-Message-State: AGi0PubKt0VVkRKGSIwOvCrQPEdm8ezN2jI1qz/dUne0cT/hW9qMDWI6
        5U/GFZV5U2GSp73pf6X1W70=
X-Google-Smtp-Source: APiQypLeDMIVEjJAI62Dun/oS3tU2pZUmWVo4IQGM9RqdKqiCc0n4bXjDYQvjAByu5L9UY9Wb++6Ag==
X-Received: by 2002:adf:b301:: with SMTP id j1mr13872024wrd.221.1589129024736;
        Sun, 10 May 2020 09:43:44 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id i1sm13390916wrx.22.2020.05.10.09.43.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 May 2020 09:43:44 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 15/15] docs: net: dsa: sja1105: document the best_effort_vlan_filtering option
Date:   Sun, 10 May 2020 19:42:55 +0300
Message-Id: <20200510164255.19322-16-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200510164255.19322-1-olteanv@gmail.com>
References: <20200510164255.19322-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../networking/devlink-params-sja1105.txt     |  27 +++
 Documentation/networking/dsa/sja1105.rst      | 211 +++++++++++++++---
 2 files changed, 212 insertions(+), 26 deletions(-)
 create mode 100644 Documentation/networking/devlink-params-sja1105.txt

diff --git a/Documentation/networking/devlink-params-sja1105.txt b/Documentation/networking/devlink-params-sja1105.txt
new file mode 100644
index 000000000000..1d71742e270a
--- /dev/null
+++ b/Documentation/networking/devlink-params-sja1105.txt
@@ -0,0 +1,27 @@
+best_effort_vlan_filtering
+			[DEVICE, DRIVER-SPECIFIC]
+			Allow plain ETH_P_8021Q headers to be used as DSA tags.
+			Benefits:
+			- Can terminate untagged traffic over switch net
+			  devices even when enslaved to a bridge with
+			  vlan_filtering=1.
+			- Can terminate VLAN-tagged traffic over switch net
+			  devices even when enslaved to a bridge with
+			  vlan_filtering=1, with some constraints (no more than
+			  7 non-pvid VLANs per user port).
+			- Can do QoS based on VLAN PCP and VLAN membership
+			  admission control for autonomously forwarded frames
+			  (regardless of whether they can be terminated on the
+			  CPU or not).
+			Drawbacks:
+			- User cannot use VLANs in range 1024-3071. If the
+			  switch receives frames with such VIDs, it will
+			  misinterpret them as DSA tags.
+			- Switch uses Shared VLAN Learning (FDB lookup uses
+			  only DMAC as key).
+			- When VLANs span cross-chip topologies, the total
+			  number of permitted VLANs may be less than 7 per
+			  port, due to a maximum number of 32 VLAN retagging
+			  rules per switch.
+			Configuration mode: runtime
+			Type: bool.
diff --git a/Documentation/networking/dsa/sja1105.rst b/Documentation/networking/dsa/sja1105.rst
index 34581629dd3f..b6bbc17814fb 100644
--- a/Documentation/networking/dsa/sja1105.rst
+++ b/Documentation/networking/dsa/sja1105.rst
@@ -66,34 +66,193 @@ reprogrammed with the updated static configuration.
 Traffic support
 ===============
 
-The switches do not support switch tagging in hardware. But they do support
-customizing the TPID by which VLAN traffic is identified as such. The switch
-driver is leveraging ``CONFIG_NET_DSA_TAG_8021Q`` by requesting that special
-VLANs (with a custom TPID of ``ETH_P_EDSA`` instead of ``ETH_P_8021Q``) are
-installed on its ports when not in ``vlan_filtering`` mode. This does not
-interfere with the reception and transmission of real 802.1Q-tagged traffic,
-because the switch does no longer parse those packets as VLAN after the TPID
-change.
-The TPID is restored when ``vlan_filtering`` is requested by the user through
-the bridge layer, and general IP termination becomes no longer possible through
-the switch netdevices in this mode.
-
-The switches have two programmable filters for link-local destination MACs.
+The switches do not have hardware support for DSA tags, except for "slow
+protocols" for switch control as STP and PTP. For these, the switches have two
+programmable filters for link-local destination MACs.
 These are used to trap BPDUs and PTP traffic to the master netdevice, and are
 further used to support STP and 1588 ordinary clock/boundary clock
-functionality.
-
-The following traffic modes are supported over the switch netdevices:
-
-+--------------------+------------+------------------+------------------+
-|                    | Standalone | Bridged with     | Bridged with     |
-|                    | ports      | vlan_filtering 0 | vlan_filtering 1 |
-+====================+============+==================+==================+
-| Regular traffic    |     Yes    |       Yes        |  No (use master) |
-+--------------------+------------+------------------+------------------+
-| Management traffic |     Yes    |       Yes        |       Yes        |
-| (BPDU, PTP)        |            |                  |                  |
-+--------------------+------------+------------------+------------------+
+functionality. For frames trapped to the CPU, source port and switch ID
+information is encoded by the hardware into the frames.
+
+But by leveraging ``CONFIG_NET_DSA_TAG_8021Q`` (a software-defined DSA tagging
+format based on VLANs), general-purpose traffic termination through the network
+stack can be supported under certain circumstances.
+
+Depending on VLAN awareness state, the following operating modes are possible
+with the switch:
+
+- Mode 1 (VLAN-unaware): a port is in this mode when it is used as a standalone
+  net device, or when it is enslaved to a bridge with ``vlan_filtering=0``.
+- Mode 2 (fully VLAN-aware): a port is in this mode when it is enslaved to a
+  bridge with ``vlan_filtering=1``. Access to the entire VLAN range is given to
+  the user through ``bridge vlan`` commands, but general-purpose (anything
+  other than STP, PTP etc) traffic termination is not possible through the
+  switch net devices. The other packets can be still by user space processed
+  through the DSA master interface (similar to ``DSA_TAG_PROTO_NONE``).
+- Mode 3 (best-effort VLAN-aware): a port is in this mode when enslaved to a
+  bridge with ``vlan_filtering=1``, and the devlink property of its parent
+  switch named ``best_effort_vlan_filtering`` is set to ``true``. When
+  configured like this, the range of usable VIDs is reduced (0 to 1023 and 3072
+  to 4094), so is the number of usable VIDs (maximum of 7 non-pvid VLANs per
+  port*), and shared VLAN learning is performed (FDB lookup is done only by
+  DMAC, not also by VID).
+
+To summarize, in each mode, the following types of traffic are supported over
+the switch net devices:
+
++-------------+-----------+--------------+------------+
+|             |   Mode 1  |    Mode 2    |   Mode 3   |
++=============+===========+==============+============+
+|   Regular   |    Yes    |      No      |     Yes    |
+|   traffic   |           | (use master) |            |
++-------------+-----------+--------------+------------+
+| Management  |    Yes    |     Yes      |     Yes    |
+|   traffic   |           |              |            |
+| (BPDU, PTP) |           |              |            |
++-------------+-----------+--------------+------------+
+
+To configure the switch to operate in Mode 3, the following steps can be
+followed::
+
+  ip link add dev br0 type bridge
+  # swp2 operates in Mode 1 now
+  ip link set dev swp2 master br0
+  # swp2 temporarily moves to Mode 2
+  ip link set dev br0 type bridge vlan_filtering 1
+  [   61.204770] sja1105 spi0.1: Reset switch and programmed static config. Reason: VLAN filtering
+  [   61.239944] sja1105 spi0.1: Disabled switch tagging
+  # swp3 now operates in Mode 3
+  devlink dev param set spi/spi0.1 name best_effort_vlan_filtering value true cmode runtime
+  [   64.682927] sja1105 spi0.1: Reset switch and programmed static config. Reason: VLAN filtering
+  [   64.711925] sja1105 spi0.1: Enabled switch tagging
+  # Cannot use VLANs in range 1024-3071 while in Mode 3.
+  bridge vlan add dev swp2 vid 1025 untagged pvid
+  RTNETLINK answers: Operation not permitted
+  bridge vlan add dev swp2 vid 100
+  bridge vlan add dev swp2 vid 101 untagged
+  bridge vlan
+  port    vlan ids
+  swp5     1 PVID Egress Untagged
+
+  swp2     1 PVID Egress Untagged
+           100
+           101 Egress Untagged
+
+  swp3     1 PVID Egress Untagged
+
+  swp4     1 PVID Egress Untagged
+
+  br0      1 PVID Egress Untagged
+  bridge vlan add dev swp2 vid 102
+  bridge vlan add dev swp2 vid 103
+  bridge vlan add dev swp2 vid 104
+  bridge vlan add dev swp2 vid 105
+  bridge vlan add dev swp2 vid 106
+  bridge vlan add dev swp2 vid 107
+  # Cannot use mode than 7 VLANs per port while in Mode 3.
+  [ 3885.216832] sja1105 spi0.1: No more free subvlans
+
+\* "maximum of 7 non-pvid VLANs per port": Decoding VLAN-tagged packets on the
+CPU in mode 3 is possible through VLAN retagging of packets that go from the
+switch to the CPU. In cross-chip topologies, the port that goes to the CPU
+might also go to other switches. In that case, those other switches will see
+only a retagged packet (which only has meaning for the CPU). So if they are
+interested in this VLAN, they need to apply retagging in the reverse direction,
+to recover the original value from it. This consumes extra hardware resources
+for this switch. There is a maximum of 32 entries in the Retagging Table of
+each switch device.
+
+As an example, consider this cross-chip topology::
+
+  +-------------------------------------------------+
+  | Host SoC                                        |
+  |           +-------------------------+           |
+  |           | DSA master for embedded |           |
+  |           |   switch (non-sja1105)  |           |
+  |  +--------+-------------------------+--------+  |
+  |  |   embedded L2 switch                      |  |
+  |  |                                           |  |
+  |  |   +--------------+     +--------------+   |  |
+  |  |   |DSA master for|     |DSA master for|   |  |
+  |  |   |  SJA1105 1   |     |  SJA1105 2   |   |  |
+  +--+---+--------------+-----+--------------+---+--+
+
+  +-----------------------+ +-----------------------+
+  |   SJA1105 switch 1    | |   SJA1105 switch 2    |
+  +-----+-----+-----+-----+ +-----+-----+-----+-----+
+  |sw1p0|sw1p1|sw1p2|sw1p3| |sw2p0|sw2p1|sw2p2|sw2p3|
+  +-----+-----+-----+-----+ +-----+-----+-----+-----+
+
+To reach the CPU, SJA1105 switch 1 (spi/spi2.1) uses the same port as is uses
+to reach SJA1105 switch 2 (spi/spi2.2), which would be port 4 (not drawn).
+Similarly for SJA1105 switch 2.
+
+Also consider the following commands, that add VLAN 100 to every sja1105 user
+port::
+
+  devlink dev param set spi/spi2.1 name best_effort_vlan_filtering value true cmode runtime
+  devlink dev param set spi/spi2.2 name best_effort_vlan_filtering value true cmode runtime
+  ip link add dev br0 type bridge
+  for port in sw1p0 sw1p1 sw1p2 sw1p3 \
+              sw2p0 sw2p1 sw2p2 sw2p3; do
+      ip link set dev $port master br0
+  done
+  ip link set dev br0 type bridge vlan_filtering 1
+  for port in sw1p0 sw1p1 sw1p2 sw1p3 \
+              sw2p0 sw2p1 sw2p2; do
+      bridge vlan add dev $port vid 100
+  done
+  ip link add link br0 name br0.100 type vlan id 100 && ip link set dev br0.100 up
+  ip addr add 192.168.100.3/24 dev br0.100
+  bridge vlan add dev br0 vid 100 self
+
+  bridge vlan
+  port    vlan ids
+  sw1p0    1 PVID Egress Untagged
+           100
+
+  sw1p1    1 PVID Egress Untagged
+           100
+
+  sw1p2    1 PVID Egress Untagged
+           100
+
+  sw1p3    1 PVID Egress Untagged
+           100
+
+  sw2p0    1 PVID Egress Untagged
+           100
+
+  sw2p1    1 PVID Egress Untagged
+           100
+
+  sw2p2    1 PVID Egress Untagged
+           100
+
+  sw2p3    1 PVID Egress Untagged
+
+  br0      1 PVID Egress Untagged
+           100
+
+SJA1105 switch 1 consumes 1 retagging entry for each VLAN on each user port
+towards the CPU. It also consumes 1 retagging entry for each non-pvid VLAN that
+it is also interested in, which is configured on any port of any neighbor
+switch.
+
+In this case, SJA1105 switch 1 consumes a total of 11 retagging entries, as
+follows:
+- 8 retagging entries for VLANs 1 and 100 installed on its user ports
+  (``sw1p0`` - ``sw1p3``)
+- 3 retagging entries for VLAN 100 installed on the user ports of SJA1105
+  switch 2 (``sw2p0`` - ``sw2p2``), because it also has ports that are
+  interested in it. The VLAN 1 is a pvid on SJA1105 switch 2 and does not need
+  reverse retagging.
+
+SJA1105 switch 2 also consumes 11 retagging entries, but organized as follows:
+- 7 retagging entries for the bridge VLANs on its user ports (``sw2p0`` -
+  ``sw2p3``).
+- 4 retagging entries for VLAN 100 installed on the user ports of SJA1105
+  switch 1 (``sw1p0`` - ``sw1p3``).
 
 Switching features
 ==================
-- 
2.17.1

