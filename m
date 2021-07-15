Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBC523CA556
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 20:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238100AbhGOSYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 14:24:32 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:61202 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232539AbhGOSYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 14:24:31 -0400
X-IronPort-AV: E=Sophos;i="5.84,243,1620658800"; 
   d="scan'208";a="87775111"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 16 Jul 2021 03:21:36 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 890D840C5552;
        Fri, 16 Jul 2021 03:21:32 +0900 (JST)
From:   Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh+dt@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH 0/6] Renesas RZ/G2L CANFD support
Date:   Thu, 15 Jul 2021 19:21:17 +0100
Message-Id: <20210715182123.23372-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

This patch series adds CANFD support to Renesas RZ/G2L family.

CANFD block on RZ/G2L SoC is almost identical to one found on
R-Car Gen3 SoC's. On RZ/G2L SoC interrupt sources for each channel
are split into individual sources.

Patches are based on top of [1] (master branch) + patch [2].

Cheers,
Prabhakar

[1] https://git.kernel.org/pub/scm/linux/kernel/git/geert/renesas-drivers.git/log/
[2] https://patchwork.kernel.org/project/linux-renesas-soc/patch/
20210712194422.12405-4-prabhakar.mahadev-lad.rj@bp.renesas.com/

Lad Prabhakar (6):
  dt-bindings: net: can: renesas,rcar-canfd: Document RZ/G2L SoC
  can: rcar_canfd: Add support for RZ/G2L family
  dt-bindings: clk: r9a07g044-cpg: Add entry for P0_DIV2 core clock
  clk: renesas: r9a07g044-cpg: Add entry for fixed clock P0_DIV2
  clk: renesas: r9a07g044-cpg: Add clock and reset entries for CANFD
  arm64: dts: renesas: r9a07g044: Add CANFD node

 .../bindings/net/can/renesas,rcar-canfd.yaml  |  45 ++-
 arch/arm64/boot/dts/renesas/r9a07g044.dtsi    |  37 +++
 drivers/clk/renesas/r9a07g044-cpg.c           |   7 +-
 drivers/net/can/rcar/rcar_canfd.c             | 275 ++++++++++++++++--
 include/dt-bindings/clock/r9a07g044-cpg.h     |   2 +
 5 files changed, 328 insertions(+), 38 deletions(-)


base-commit: b37235d5fdf50e5f1c23f868ab70bbe640081b21
prerequisite-patch-id: 7436c0d801737268ef470fcb50e620428286e085
-- 
2.17.1

