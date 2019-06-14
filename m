Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39EAB45BC6
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 13:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727593AbfFNLxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 07:53:48 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:9077 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727217AbfFNLxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 07:53:48 -0400
X-IronPort-AV: E=Sophos;i="5.62,373,1554735600"; 
   d="scan'208";a="18675542"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 14 Jun 2019 20:53:45 +0900
Received: from fabrizio-dev.ree.adwin.renesas.com (unknown [10.226.36.196])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 5EA77400C455;
        Fri, 14 Jun 2019 20:53:42 +0900 (JST)
From:   Fabrizio Castro <fabrizio.castro@bp.renesas.com>
To:     Simon Horman <horms@verge.net.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc:     Fabrizio Castro <fabrizio.castro@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Magnus Damm <magnus.damm@gmail.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>, xu_shunji@hoperun.com
Subject: [PATCH 0/6] More CAN support for RZ/G2 devices
Date:   Fri, 14 Jun 2019 12:53:28 +0100
Message-Id: <1560513214-28031-1-git-send-email-fabrizio.castro@bp.renesas.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear All,

This series adds CAN and CANFD support to the HiHope RZ/G2M, and also
improves SoC support for the RZ/G2E.
Please note that I wasn't able to test CAN-FD mode but only classical
CAN mode with the CANFD IP, my unit unfortunately comes with CAN-FD
mode disabled in HW, but the CANFD IP is working and responding
correctly while in classical mode.

Please note that this work depends on:
https://patchwork.kernel.org/cover/10986911/
https://patchwork.kernel.org/cover/10990113/

Thanks,
Fab

Fabrizio Castro (6):
  dt-bindings: can: rcar_canfd: document r8a774a1 support
  dt-bindings: can: rcar_can: Complete documentation for RZ/G2[EM]
  arm64: dts: renesas: r8a774c0: Add missing assigned-clocks for CAN[01]
  arm64: dts: renesas: r8a774a1: Add missing assigned-clocks for CAN[01]
  arm64: dts: renesas: r8a774a1: Add CANFD support
  arm64: dts: renesas: hihope-rzg2-ex: Enable CAN interfaces

 .../devicetree/bindings/net/can/rcar_can.txt       |  2 +-
 .../devicetree/bindings/net/can/rcar_canfd.txt     |  9 ++++---
 arch/arm64/boot/dts/renesas/hihope-rzg2-ex.dtsi    | 22 ++++++++++++++++
 arch/arm64/boot/dts/renesas/r8a774a1.dtsi          | 29 ++++++++++++++++++++++
 arch/arm64/boot/dts/renesas/r8a774c0.dtsi          |  4 +++
 5 files changed, 61 insertions(+), 5 deletions(-)

-- 
2.7.4

