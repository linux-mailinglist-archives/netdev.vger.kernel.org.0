Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F15E3D1752
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 22:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232440AbhGUTKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 15:10:00 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:19770 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232213AbhGUTJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 15:09:59 -0400
X-IronPort-AV: E=Sophos;i="5.84,258,1620658800"; 
   d="scan'208";a="88350317"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 22 Jul 2021 04:50:33 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 827C3400D0FD;
        Thu, 22 Jul 2021 04:50:30 +0900 (JST)
From:   Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh+dt@kernel.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH v3 0/3] Renesas RZ/G2L CANFD support
Date:   Wed, 21 Jul 2021 20:49:48 +0100
Message-Id: <20210721194951.30983-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

This patch series adds CANFD support to Renesas RZ/G2L family.

CANFD block on RZ/G2L SoC is almost identical to one found on
R-Car Gen3 SoC's. On RZ/G2L SoC interrupt sources for each channel
are split into individual sources.

Cheers,
Prabhakar

Changes for v3:
* Dropped core clock addition patches from this series (its queued
  up already in renesas-clk-for-v5.15)
* Added reset-names in binding doc as suggested by Philipp
* Updated interrupt names in binding doc as suggested by Geert
* Updated the driver to handle the above DT binding changes

Changes for v2:
* Added interrupt-names property and marked it as required for
  RZ/G2L family
* Added descriptions for reset property
* Re-used irq handlers on RZ/G2L SoC
* Added new enum for chip_id
* Dropped R9A07G044_LAST_CORE_CLK
* Dropped patch (clk: renesas: r9a07g044-cpg: Add clock and reset
  entries for CANFD) as its been merged into renesas tree

Lad Prabhakar (3):
  dt-bindings: net: can: renesas,rcar-canfd: Document RZ/G2L SoC
  can: rcar_canfd: Add support for RZ/G2L family
  arm64: dts: renesas: r9a07g044: Add CANFD node

 .../bindings/net/can/renesas,rcar-canfd.yaml  |  69 ++++++-
 arch/arm64/boot/dts/renesas/r9a07g044.dtsi    |  41 +++++
 drivers/net/can/rcar/rcar_canfd.c             | 173 +++++++++++++++---
 3 files changed, 253 insertions(+), 30 deletions(-)

-- 
2.17.1

