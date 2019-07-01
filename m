Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A68B12339
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 22:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbfEBUZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 16:25:04 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:47022 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726533AbfEBUYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 16:24:51 -0400
Received: by mail-wr1-f65.google.com with SMTP id r7so5084669wrr.13;
        Thu, 02 May 2019 13:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+L74GzQLiPaFthiz+XDWtlIF86WhHvHwect6nzsIs/I=;
        b=hFERTfqhrKWosSe4boIAbSDjtk7KK0iB/5LK8eQFUHqUhuS+v1QoXIzyyhBSK/1uHc
         vrWEAZGwp17w2dHjUgKlUQsPqiB0zfMUZYFMJOzeciUtZCzpslrKF8ZYz41jkXTV4zfu
         2oDOBthr5uunU+T3ou2Loiax4cgfvk2vdoiUi0uvi9SVqmd1dcwZq4y+qKkxNfsPNQdT
         oEOnenWZDMSy2/4O08y54ovUyHhh9iSs+4lQ3wKrgIx46hKO9WuxWdZ0gPsHKfJCfXz6
         x4+qhmpsBts9h1E3Dq4R6kt+Eqvn6JtRNeW3ecHVeVjXnip+eIw6QJhakHdO0it4cp4F
         T/tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+L74GzQLiPaFthiz+XDWtlIF86WhHvHwect6nzsIs/I=;
        b=tjo5fn4Ea0EoWfovPxOQGbbEb306/NOFKRoB/xESaP6WtQSePLXhue9VjiiO75CGxV
         5RlVWGPx6b4OF7AowHTGTlQibhbnv92Gmrneqbwt/MDFIGlhM4dUKfMWYCXX0NS+eoiv
         htOb/zEh83C5cNB9F8p/tq7yWPggq2aXjIEENekekgssBRjOPAM0eZA8WZWP9BeZLPTy
         cL9NKY1qyPxwS7eho7APnwxDFJM/iAJKanjf5QVG7NJHs87M0TG5q8W54eX95C1jWAnK
         LFd7KwpHsIt4TaE9vYBfkbGZX1lv3u3u1nhJhxgVl59GsTbZbDgS9XFcUdmAzPsLyF86
         K1VQ==
X-Gm-Message-State: APjAAAW+rtxBc/lZ+TlsmF+aiYpuF2c87OpwSl6Dbl2BkJHM4pQj1P4V
        woZIXqjJXHU/vkLmHpuduLs=
X-Google-Smtp-Source: APXvYqwX8l3c9U/1dxN7cA0oWznjpHXuQlUVv3jQ6NWhfue4aZGguy8aucNYAZmDlakpj2hFu2k9yQ==
X-Received: by 2002:adf:c6c3:: with SMTP id c3mr4301074wrh.267.1556828688991;
        Thu, 02 May 2019 13:24:48 -0700 (PDT)
Received: from localhost.localdomain (5-12-225-227.residential.rdsnet.ro. [5.12.225.227])
        by smtp.gmail.com with ESMTPSA id s124sm217655wmf.42.2019.05.02.13.24.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 13:24:48 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v5 net-next 11/12] Documentation: net: dsa: Add details about NXP SJA1105 driver
Date:   Thu,  2 May 2019 23:23:39 +0300
Message-Id: <20190502202340.21054-12-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190502202340.21054-1-olteanv@gmail.com>
References: <20190502202340.21054-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes in v5:
Stripped blank lines at the end of files.

Changes in v4:
Removed the section about traffic, as well as mentions of other
unsupported yet features.

Changes in v3:
Reworked as rst, added a table for traffic support, added chapter for
switching features.

Changes in v2:
More verbiage at the end, regarding RGMII delays and potentially other
hardware-related caveats.

 Documentation/networking/dsa/index.rst   |   1 +
 Documentation/networking/dsa/sja1105.rst | 166 +++++++++++++++++++++++
 2 files changed, 167 insertions(+)
 create mode 100644 Documentation/networking/dsa/sja1105.rst

diff --git a/Documentation/networking/dsa/index.rst b/Documentation/networking/dsa/index.rst
index 5c488d345a1e..0e5b7a9be406 100644
--- a/Documentation/networking/dsa/index.rst
+++ b/Documentation/networking/dsa/index.rst
@@ -8,3 +8,4 @@ Distributed Switch Architecture
    dsa
    bcm_sf2
    lan9303
+   sja1105
diff --git a/Documentation/networking/dsa/sja1105.rst b/Documentation/networking/dsa/sja1105.rst
new file mode 100644
index 000000000000..7c13b40915c0
--- /dev/null
+++ b/Documentation/networking/dsa/sja1105.rst
@@ -0,0 +1,166 @@
+=========================
+NXP SJA1105 switch driver
+=========================
+
+Overview
+========
+
+The NXP SJA1105 is a family of 6 devices:
+
+- SJA1105E: First generation, no TTEthernet
+- SJA1105T: First generation, TTEthernet
+- SJA1105P: Second generation, no TTEthernet, no SGMII
+- SJA1105Q: Second generation, TTEthernet, no SGMII
+- SJA1105R: Second generation, no TTEthernet, SGMII
+- SJA1105S: Second generation, TTEthernet, SGMII
+
+These are SPI-managed automotive switches, with all ports being gigabit
+capable, and supporting MII/RMII/RGMII and optionally SGMII on one port.
+
+Being automotive parts, their configuration interface is geared towards
+set-and-forget use, with minimal dynamic interaction at runtime. They
+require a static configuration to be composed by software and packed
+with CRC and table headers, and sent over SPI.
+
+The static configuration is composed of several configuration tables. Each
+table takes a number of entries. Some configuration tables can be (partially)
+reconfigured at runtime, some not. Some tables are mandatory, some not:
+
+============================= ================== =============================
+Table                          Mandatory          Reconfigurable
+============================= ================== =============================
+Schedule                       no                 no
+Schedule entry points          if Scheduling      no
+VL Lookup                      no                 no
+VL Policing                    if VL Lookup       no
+VL Forwarding                  if VL Lookup       no
+L2 Lookup                      no                 no
+L2 Policing                    yes                no
+VLAN Lookup                    yes                yes
+L2 Forwarding                  yes                partially (fully on P/Q/R/S)
+MAC Config                     yes                partially (fully on P/Q/R/S)
+Schedule Params                if Scheduling      no
+Schedule Entry Points Params   if Scheduling      no
+VL Forwarding Params           if VL Forwarding   no
+L2 Lookup Params               no                 partially (fully on P/Q/R/S)
+L2 Forwarding Params           yes                no
+Clock Sync Params              no                 no
+AVB Params                     no                 no
+General Params                 yes                partially
+Retagging                      no                 yes
+xMII Params                    yes                no
+SGMII                          no                 yes
+============================= ================== =============================
+
+
+Also the configuration is write-only (software cannot read it back from the
+switch except for very few exceptions).
+
+The driver creates a static configuration at probe time, and keeps it at
+all times in memory, as a shadow for the hardware state. When required to
+change a hardware setting, the static configuration is also updated.
+If that changed setting can be transmitted to the switch through the dynamic
+reconfiguration interface, it is; otherwise the switch is reset and
+reprogrammed with the updated static configuration.
+
+Switching features
+==================
+
+The driver supports the configuration of L2 forwarding rules in hardware for
+port bridging. The forwarding, broadcast and flooding domain between ports can
+be restricted through two methods: either at the L2 forwarding level (isolate
+one bridge's ports from another's) or at the VLAN port membership level
+(isolate ports within the same bridge). The final forwarding decision taken by
+the hardware is a logical AND of these two sets of rules.
+
+The hardware tags all traffic internally with a port-based VLAN (pvid), or it
+decodes the VLAN information from the 802.1Q tag. Advanced VLAN classification
+is not possible. Once attributed a VLAN tag, frames are checked against the
+port's membership rules and dropped at ingress if they don't match any VLAN.
+This behavior is available when switch ports are enslaved to a bridge with
+``vlan_filtering 1``.
+
+Normally the hardware is not configurable with respect to VLAN awareness, but
+by changing what TPID the switch searches 802.1Q tags for, the semantics of a
+bridge with ``vlan_filtering 0`` can be kept (accept all traffic, tagged or
+untagged), and therefore this mode is also supported.
+
+Segregating the switch ports in multiple bridges is supported (e.g. 2 + 2), but
+all bridges should have the same level of VLAN awareness (either both have
+``vlan_filtering`` 0, or both 1). Also an inevitable limitation of the fact
+that VLAN awareness is global at the switch level is that once a bridge with
+``vlan_filtering`` enslaves at least one switch port, the other un-bridged
+ports are no longer available for standalone traffic termination.
+
+Device Tree bindings and board design
+=====================================
+
+This section references ``Documentation/devicetree/bindings/net/dsa/sja1105.txt``
+and aims to showcase some potential switch caveats.
+
+RMII PHY role and out-of-band signaling
+---------------------------------------
+
+In the RMII spec, the 50 MHz clock signals are either driven by the MAC or by
+an external oscillator (but not by the PHY).
+But the spec is rather loose and devices go outside it in several ways.
+Some PHYs go against the spec and may provide an output pin where they source
+the 50 MHz clock themselves, in an attempt to be helpful.
+On the other hand, the SJA1105 is only binary configurable - when in the RMII
+MAC role it will also attempt to drive the clock signal. To prevent this from
+happening it must be put in RMII PHY role.
+But doing so has some unintended consequences.
+In the RMII spec, the PHY can transmit extra out-of-band signals via RXD[1:0].
+These are practically some extra code words (/J/ and /K/) sent prior to the
+preamble of each frame. The MAC does not have this out-of-band signaling
+mechanism defined by the RMII spec.
+So when the SJA1105 port is put in PHY role to avoid having 2 drivers on the
+clock signal, inevitably an RMII PHY-to-PHY connection is created. The SJA1105
+emulates a PHY interface fully and generates the /J/ and /K/ symbols prior to
+frame preambles, which the real PHY is not expected to understand. So the PHY
+simply encodes the extra symbols received from the SJA1105-as-PHY onto the
+100Base-Tx wire.
+On the other side of the wire, some link partners might discard these extra
+symbols, while others might choke on them and discard the entire Ethernet
+frames that follow along. This looks like packet loss with some link partners
+but not with others.
+The take-away is that in RMII mode, the SJA1105 must be let to drive the
+reference clock if connected to a PHY.
+
+RGMII fixed-link and internal delays
+------------------------------------
+
+As mentioned in the bindings document, the second generation of devices has
+tunable delay lines as part of the MAC, which can be used to establish the
+correct RGMII timing budget.
+When powered up, these can shift the Rx and Tx clocks with a phase difference
+between 73.8 and 101.7 degrees.
+The catch is that the delay lines need to lock onto a clock signal with a
+stable frequency. This means that there must be at least 2 microseconds of
+silence between the clock at the old vs at the new frequency. Otherwise the
+lock is lost and the delay lines must be reset (powered down and back up).
+In RGMII the clock frequency changes with link speed (125 MHz at 1000 Mbps, 25
+MHz at 100 Mbps and 2.5 MHz at 10 Mbps), and link speed might change during the
+AN process.
+In the situation where the switch port is connected through an RGMII fixed-link
+to a link partner whose link state life cycle is outside the control of Linux
+(such as a different SoC), then the delay lines would remain unlocked (and
+inactive) until there is manual intervention (ifdown/ifup on the switch port).
+The take-away is that in RGMII mode, the switch's internal delays are only
+reliable if the link partner never changes link speeds, or if it does, it does
+so in a way that is coordinated with the switch port (practically, both ends of
+the fixed-link are under control of the same Linux system).
+As to why would a fixed-link interface ever change link speeds: there are
+Ethernet controllers out there which come out of reset in 100 Mbps mode, and
+their driver inevitably needs to change the speed and clock frequency if it's
+required to work at gigabit.
+
+MDIO bus and PHY management
+---------------------------
+
+The SJA1105 does not have an MDIO bus and does not perform in-band AN either.
+Therefore there is no link state notification coming from the switch device.
+A board would need to hook up the PHYs connected to the switch to any other
+MDIO bus available to Linux within the system (e.g. to the DSA master's MDIO
+bus). Link state management then works by the driver manually keeping in sync
+(over SPI commands) the MAC link speed with the settings negotiated by the PHY.
-- 
2.17.1

