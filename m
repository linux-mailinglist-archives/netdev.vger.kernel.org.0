Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 959A12C66EB
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 14:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730017AbgK0NdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 08:33:23 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:15733 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729169AbgK0NdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 08:33:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1606484001; x=1638020001;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ASAFX9vUKdMsNKvrYRGh3ZN7aWE7w74mp7PyxPax1gk=;
  b=OEY0rfzsTGBkny4OD2yrL2r5Bv1v1d1SPnKvhZE6GESkYQk9y6jB4Txp
   59lpKMh++p5SXUSwtRZqxxdj9bmlUeCzXCFBjjEJPnl1fuX9z9YT71e8l
   gg6oWmz5it78WNPNbljqUNiQlN4KtpfEIYiW1k8Gd2QaZeSQr+Y+b3sZr
   ICYzYImOGDLEZeK6pSaNhWIJssE3RI0ymuCl39NblnJ5xhwIl2q4TEXPS
   AMICX4l6lXOGklqAIvQzEEsqJ1kivugGRAg7OnNHV1dXuIa82khPD77+0
   yRlHWmG6YwGGmR2OFfeWN7ldhb8t9IaD+j1YQLobvrdUp5aevz530406Y
   w==;
IronPort-SDR: Z+5Tz7a0LpaM/qjYBn/MUdY81rwQ9sHczCeFyBFGm8RZWaFzvyJOfwvkUsH7J33nrnAa0+413Z
 WMtDNkclrxORhjC7GeeTh8R/BJ4nbXY+fyYL6XXR+a8lKiZiy1GHzSpCnbOBeGjn/g2DnOYHbF
 j1CrYdEty5HyDEtfZj4yPxxpPw6y59w8aqc8vM0IA9Pl8htlDbDh26A3X9W665cWBoTbZVzvgS
 bFLS6fciLLIfI/x7DfB3PM+fRRK7FO8pPgJOv+OGeazj6bkv+wvuxQt3YBsX0o4uoRlJRmrDDl
 hZU=
X-IronPort-AV: E=Sophos;i="5.78,374,1599548400"; 
   d="scan'208";a="105259706"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Nov 2020 06:33:20 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 27 Nov 2020 06:33:20 -0700
Received: from mchp-dev-shegelun.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Fri, 27 Nov 2020 06:33:18 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microsemi List <microsemi@lists.bootlin.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 0/3] net: Adding the Sparx5 Switch Driver
Date:   Fri, 27 Nov 2020 14:33:04 +0100
Message-ID: <20201127133307.2969817-1-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series provides the Microchip Sparx5 Switch Driver

The Sparx5 Carrier Ethernet and Industrial switch family delivers 64 Ethernet
ports and up to 200 Gbps of switching bandwidth.

It provides a rich set of Ethernet switching features such as hierarchical QoS,
hardware-based OAM  and service activation testing, protection switching,
IEEE 1588, and Synchronous Ethernet.

Using provider bridging (Q-in-Q) and MPLS/MPLS-TP technology, it delivers MEF CE
2.0 Ethernet virtual connections (EVCs) and features advanced TCAM classification
in both ingress and egress.

Per-EVC features include advanced L3-aware classification, a rich set of
statistics, OAM for end-to-end performance monitoring, and dual-rate policing
and shaping.

Time sensitive networking (TSN) is supported through a comprehensive set of
features including frame preemption, cut-through, frame replication and
elimination for reliability, enhanced scheduling: credit-based shaping,
time-aware shaping, cyclic queuing, and forwarding, and per-stream
policing and filtering.

Together with IEEE 1588 and IEEE 802.1AS support, this guarantees low-latency
deterministic networking for Fronthaul, Carrier, and Industrial Ethernet.

The Sparx5 switch family consists of following SKUs:

- VSC7546 Sparx5-64
  up to 64 Gbps of bandwidth with the following primary port configurations:
  - 6 *10G
  - 16 * 2.5G + 2 * 10G
  - 24 * 1G + 4 * 10G

- VSC7549 Sparx5-90
  up to 90 Gbps of bandwidth with the following primary port configurations:
  - 9 * 10G
  - 16 * 2.5G + 4 * 10G
  - 48 * 1G + 4 * 10G

- VSC7552 Sparx5-128
  up to 128 Gbps of bandwidth with the following primary port configurations:
  - 12 * 10G
  - 16 * 2.5G + 8 * 10G
  - 48 * 1G + 8 * 10G

- VSC7556 Sparx5-160
  up to 160 Gbps of bandwidth with the following primary port configurations:
  - 16 * 10G
  - 10 * 10G + 2 * 25G
  - 16 * 2.5G + 10 * 10G
  - 48 * 1G + 10 * 10G

- VSC7558 Sparx5-200
  up to 200 Gbps of bandwidth with the following primary port configurations:
  - 20 * 10G
  - 8 * 25G

In addition, the device supports one 10/100/1000/2500/5000 Mbps SGMII/SerDes
node processor interface (NPI) Ethernet port.

The Sparx5 support is developed on the PCB134 and PCB135 evaluation boards.

- PCB134 main networking features:
  - 12x SFP+ front 10G module slots (connected to Sparx5 through SFI).
  - 8x SFP28 front 25G module slots (connected to Sparx5 through SFI high speed).
  - Optional, one additional 10/100/1000BASE-T (RJ45) Ethernet port
    (on-board VSC8211 PHY connected to Sparx5 through SGMII).

- PCB135 main networking features:
  - 48x1G (10/100/1000M) RJ45 front ports using 12xVSC8514 QuadPHY’s each
    connected to VSC7558 through QSGMII.
  - 4x10G (1G/2.5G/5G/10G) RJ45 front ports using the AQR407 10G QuadPHY each
    port connects to VSC7558 through SFI.
  - 4x SFP28 25G module slots on back connected to VSC7558 through SFI high
    speed.
  - Optional, one additional 1G (10/100/1000M) RJ45 port using an on-board
    VSC8211 PHY, which can be connected to VSC7558 NPI port through SGMII using
    a loopback add-on PCB)

This series provides support for:
  - SFPs and DAC cables via PHYLINK with a number of 5G, 10G and 25G devices
    and media types.
  - Port module configuration for 10M to 25G speeds with SGMII, QSGMII,
    1000BASEX, 2500BASEX and 10GBASER as appropriate for these modes.
  - SerDes configuration via the Sparx5 SerDes driver (see below).
  - Host mode providing register based injection and extraction.
  - Switch mode providing MAC/VLAN table learning and Layer2 switching offloaded
    to the Sparx5 switch.
  - STP state, VLAN support, host/bridge port mode, Forwarding DB, and
    configuration and statistics via ethtool.

More support will be added at a later stage.

The Sparx5 Switch chip register model can be browsed here:
Link: https://microchip-ung.github.io/sparx-5_reginfo/reginfo_sparx-5.html

The series depends on the following series currently on their way
into the kernel:

- Sparx5 SerDes Driver
  Link: https://lore.kernel.org/r/20201123114234.2292766-1-steen.hegelund@microchip.com/

- Serial GPIO Controller
  Link: https://lore.kernel.org/r/20201113145151.68900-1-lars.povlsen@microchip.com/

Steen Hegelund (3):
  dt-bindings: net: sparx5: Add sparx5-switch bindings
  net: sparx5: Add Sparx5 switchdev driver
  arm64: dts: sparx5: Add the Sparx5 switch node

 .../bindings/net/microchip,sparx5-switch.yaml |  633 +++
 arch/arm64/boot/dts/microchip/sparx5.dtsi     |  364 ++
 .../dts/microchip/sparx5_pcb134_board.dtsi    |  424 +-
 .../dts/microchip/sparx5_pcb135_board.dtsi    |  602 ++-
 drivers/net/ethernet/microchip/Kconfig        |    2 +
 drivers/net/ethernet/microchip/Makefile       |    2 +
 drivers/net/ethernet/microchip/sparx5/Kconfig |    8 +
 .../net/ethernet/microchip/sparx5/Makefile    |   11 +
 .../microchip/sparx5/sparx5_calendar.c        |  593 +++
 .../ethernet/microchip/sparx5/sparx5_common.h |  162 +
 .../microchip/sparx5/sparx5_ethtool.c         | 1027 +++++
 .../microchip/sparx5/sparx5_mactable.c        |  510 +++
 .../ethernet/microchip/sparx5/sparx5_main.c   |  851 ++++
 .../ethernet/microchip/sparx5/sparx5_main.h   |  236 +
 .../microchip/sparx5/sparx5_main_regs.h       | 3922 +++++++++++++++++
 .../ethernet/microchip/sparx5/sparx5_netdev.c |  238 +
 .../ethernet/microchip/sparx5/sparx5_packet.c |  279 ++
 .../microchip/sparx5/sparx5_phylink.c         |  179 +
 .../ethernet/microchip/sparx5/sparx5_port.c   | 1125 +++++
 .../ethernet/microchip/sparx5/sparx5_port.h   |   95 +
 .../microchip/sparx5/sparx5_switchdev.c       |  510 +++
 .../ethernet/microchip/sparx5/sparx5_vlan.c   |  219 +
 22 files changed, 11932 insertions(+), 60 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml
 create mode 100644 drivers/net/ethernet/microchip/sparx5/Kconfig
 create mode 100644 drivers/net/ethernet/microchip/sparx5/Makefile
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_calendar.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_common.h
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
2.29.2

