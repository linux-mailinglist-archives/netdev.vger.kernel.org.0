Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 002093620AE
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 15:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243720AbhDPNRe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 09:17:34 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:38085 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243487AbhDPNRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 09:17:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1618579027; x=1650115027;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=VQWAf+sSaiPxZM4ON97z8nMb61u8our8U0qMomJbIUg=;
  b=Iy2D6gteFTUEi+dCAa14jCBvjZ05g5NZ3SDpJfXi/oOSGoPaO8ZOJokL
   C18u8PfIN0p+x8zQEZ99BEI/pOk5R7IHxv5OCBq2GVfqweLFevpwdMlfs
   KV6L9mnXeQTGHACXWw5evLLyg7UhC1l3bC1LipTlnB1lYoQjR+0Qs6iOb
   /UGsFxNI7lXK6Cg+ev+6xWBKJgT09olyx5JmmGyIUFkH0YC2PFDEzcZ0O
   WW/Vk3sDPDu3q/sEHzNZGYKu+XzUP+GoReK7U00N5iKFKa5Qaou1c3Ib7
   74tCP7N16O8lpQHP/8mIYCKJGfCs+ArOX1Cdm0GSFSHRam6F0WLgrKfHU
   g==;
IronPort-SDR: FFvNxn2kaBgHSquqrNfy/GyPMw+SbKeKDdBlwsdtJ+1qpTz37nkjpQhp4E6w/VOeb7PXHm8P34
 9vb+YwtztC1tP++Wq8BeViQ9eY6PN8c2dtNO25wg8Va+IPjW4xLRKzjJKw9y1ptxYDJdbzVCzk
 S0GU2GQrAqIJCeLKFzWLGTSVptwXOp0ASUym6Kw8EsBU96aU4B5ID4NlemSCp99Zt0Rzc54x20
 hm01T4sZaUkKGIssm8MZYXPxDR4fNeJv5/Ex06O6h/MTthHPye53w4/ceLdfo1Lm3pebE0E1hX
 LnM=
X-IronPort-AV: E=Sophos;i="5.82,226,1613458800"; 
   d="scan'208";a="117306735"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Apr 2021 06:17:06 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 16 Apr 2021 06:17:06 -0700
Received: from mchp-dev-shegelun.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Fri, 16 Apr 2021 06:17:03 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "Microchip Linux Driver Support" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Mark Einon <mark.einon@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "Simon Horman" <simon.horman@netronome.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH net-next 00/10] Adding the Sparx5 Switch Driver
Date:   Fri, 16 Apr 2021 15:16:47 +0200
Message-ID: <20210416131657.3151464-1-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series provides the Microchip Sparx5 Switch Driver

The Sparx5 Carrier Ethernet and Industrial switch family delivers 64
Ethernet ports and up to 200 Gbps of switching bandwidth.

It provides a rich set of Ethernet switching features such as hierarchical
QoS, hardware-based OAM  and service activation testing, protection
switching, IEEE 1588, and Synchronous Ethernet.

Using provider bridging (Q-in-Q) and MPLS/MPLS-TP technology, it delivers
MEF CE
2.0 Ethernet virtual connections (EVCs) and features advanced TCAM
  classification in both ingress and egress.

Per-EVC features include advanced L3-aware classification, a rich set of
statistics, OAM for end-to-end performance monitoring, and dual-rate
policing and shaping.

Time sensitive networking (TSN) is supported through a comprehensive set of
features including frame preemption, cut-through, frame replication and
elimination for reliability, enhanced scheduling: credit-based shaping,
time-aware shaping, cyclic queuing, and forwarding, and per-stream policing
and filtering.

Together with IEEE 1588 and IEEE 802.1AS support, this guarantees
low-latency deterministic networking for Fronthaul, Carrier, and Industrial
Ethernet.

The Sparx5 switch family consists of following SKUs:

- VSC7546 Sparx5-64 up to 64 Gbps of bandwidth with the following primary
  port configurations:
  - 6 *10G
  - 16 * 2.5G + 2 * 10G
  - 24 * 1G + 4 * 10G

- VSC7549 Sparx5-90 up to 90 Gbps of bandwidth with the following primary
  port configurations:
  - 9 * 10G
  - 16 * 2.5G + 4 * 10G
  - 48 * 1G + 4 * 10G

- VSC7552 Sparx5-128 up to 128 Gbps of bandwidth with the following primary
  port configurations:
  - 12 * 10G
  - 16 * 2.5G + 8 * 10G
  - 48 * 1G + 8 * 10G

- VSC7556 Sparx5-160 up to 160 Gbps of bandwidth with the following primary
  port configurations:
  - 16 * 10G
  - 10 * 10G + 2 * 25G
  - 16 * 2.5G + 10 * 10G
  - 48 * 1G + 10 * 10G

- VSC7558 Sparx5-200 up to 200 Gbps of bandwidth with the following primary
  port configurations:
  - 20 * 10G
  - 8 * 25G

In addition, the device supports one 10/100/1000/2500/5000 Mbps
SGMII/SerDes node processor interface (NPI) Ethernet port.

The Sparx5 support is developed on the PCB134 and PCB135 evaluation boards.

- PCB134 main networking features:
  - 12x SFP+ front 10G module slots (connected to Sparx5 through SFI).
  - 8x SFP28 front 25G module slots (connected to Sparx5 through SFI high
    speed).
  - Optional, one additional 10/100/1000BASE-T (RJ45) Ethernet port
    (on-board VSC8211 PHY connected to Sparx5 through SGMII).

- PCB135 main networking features:
  - 48x1G (10/100/1000M) RJ45 front ports using 12xVSC8514 QuadPHY’s each
    connected to VSC7558 through QSGMII.
  - 4x10G (1G/2.5G/5G/10G) RJ45 front ports using the AQR407 10G QuadPHY
    each port connects to VSC7558 through SFI.
  - 4x SFP28 25G module slots on back connected to VSC7558 through SFI high
    speed.
  - Optional, one additional 1G (10/100/1000M) RJ45 port using an on-board
    VSC8211 PHY, which can be connected to VSC7558 NPI port through SGMII
    using a loopback add-on PCB)

This series provides support for:
  - SFPs and DAC cables via PHYLINK with a number of 5G, 10G and 25G
    devices and media types.
  - Port module configuration for 10M to 25G speeds with SGMII, QSGMII,
    1000BASEX, 2500BASEX and 10GBASER as appropriate for these modes.
  - SerDes configuration via the Sparx5 SerDes driver (see below).
  - Host mode providing register based injection and extraction.
  - Switch mode providing MAC/VLAN table learning and Layer2 switching
    offloaded to the Sparx5 switch.
  - STP state, VLAN support, host/bridge port mode, Forwarding DB, and
    configuration and statistics via ethtool.

More support will be added at a later stage.

The Sparx5 Chip Register Model can be browsed at this location:
https://github.com/microchip-ung/sparx-5_reginfo
and the datasheet is available here:
https://ww1.microchip.com/downloads/en/DeviceDoc/SparX-5_Family_L2L3_Enterprise_10G_Ethernet_Switches_Datasheet_00003822B.pdf

The series depends on the following series currently on their way
into the kernel:

- Sparx5 SerDes Driver
  Link: https://lore.kernel.org/r/20210218161451.3489955-1-steen.hegelund@microchip.com/

- Sparx5 Reset Driver
  Link: https://lore.kernel.org/r/20210416084054.2922327-1-steen.hegelund@microchip.com/

Steen Hegelund (10):
  dt-bindings: net: sparx5: Add sparx5-switch bindings
  net: sparx5: add the basic sparx5 driver
  net: sparx5: add hostmode with phylink support
  net: sparx5: add port module support
  net: sparx5: add mactable support
  net: sparx5: add vlan support
  net: sparx5: add switching support
  net: sparx5: add calendar bandwidth allocation support
  net: sparx5: add ethtool configuration and statistics support
  arm64: dts: sparx5: Add the Sparx5 switch node

 .../bindings/net/microchip,sparx5-switch.yaml |  227 +
 arch/arm64/boot/dts/microchip/sparx5.dtsi     |   94 +-
 .../dts/microchip/sparx5_pcb134_board.dtsi    |  481 +-
 .../dts/microchip/sparx5_pcb135_board.dtsi    |  621 ++-
 drivers/net/ethernet/microchip/Kconfig        |    2 +
 drivers/net/ethernet/microchip/Makefile       |    2 +
 drivers/net/ethernet/microchip/sparx5/Kconfig |    9 +
 .../net/ethernet/microchip/sparx5/Makefile    |   10 +
 .../microchip/sparx5/sparx5_calendar.c        |  596 +++
 .../microchip/sparx5/sparx5_ethtool.c         |  999 ++++
 .../microchip/sparx5/sparx5_mactable.c        |  500 ++
 .../ethernet/microchip/sparx5/sparx5_main.c   |  867 ++++
 .../ethernet/microchip/sparx5/sparx5_main.h   |  363 ++
 .../microchip/sparx5/sparx5_main_regs.h       | 4402 +++++++++++++++++
 .../ethernet/microchip/sparx5/sparx5_netdev.c |  247 +
 .../ethernet/microchip/sparx5/sparx5_packet.c |  292 ++
 .../microchip/sparx5/sparx5_phylink.c         |  195 +
 .../ethernet/microchip/sparx5/sparx5_port.c   | 1129 +++++
 .../ethernet/microchip/sparx5/sparx5_port.h   |   98 +
 .../microchip/sparx5/sparx5_switchdev.c       |  508 ++
 .../ethernet/microchip/sparx5/sparx5_vlan.c   |  224 +
 21 files changed, 11782 insertions(+), 84 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml
 create mode 100644 drivers/net/ethernet/microchip/sparx5/Kconfig
 create mode 100644 drivers/net/ethernet/microchip/sparx5/Makefile
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_calendar.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_main.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_main.h
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_main_regs.h
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_port.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_port.h
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c

-- 
2.31.1

