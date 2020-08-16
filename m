Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC0C4245920
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 21:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729022AbgHPTHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 15:07:43 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:25279 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725873AbgHPTHl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Aug 2020 15:07:41 -0400
X-IronPort-AV: E=Sophos;i="5.76,321,1592838000"; 
   d="scan'208";a="54478014"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 17 Aug 2020 04:07:38 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id C1874400618C;
        Mon, 17 Aug 2020 04:07:35 +0900 (JST)
From:   Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-gpio@vger.kernel.org,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Prabhakar <prabhakar.csengg@gmail.com>
Subject: [PATCH 0/3] r8a7742 add CAN support
Date:   Sun, 16 Aug 2020 20:07:29 +0100
Message-Id: <20200816190732.6905-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

This patch series adds CAN pins to r8a7790 PFC driver and
adds CAN[01] nodes to r8a7742 SoC dtsi.

patches applies on top of [1] (the PFC patch is dependant
on top of patch [2])

[1] https://git.kernel.org/pub/scm/linux/kernel/git/geert/
    renesas-devel.git/log/?h=renesas-arm-dt-for-v5.10
[2] https://patchwork.kernel.org/patch/11670815/

Cheers,
Prabhakar

Lad Prabhakar (3):
  pinctrl: sh-pfc: r8a7790: Add CAN pins, groups and functions
  dt-bindings: can: rcar_can: Add r8a7742 support
  ARM: dts: r8a7742: Add CAN support

 .../devicetree/bindings/net/can/rcar_can.txt  |  3 +-
 arch/arm/boot/dts/r8a7742.dtsi                | 34 ++++++++
 drivers/pinctrl/sh-pfc/pfc-r8a7790.c          | 86 ++++++++++++++++++-
 3 files changed, 120 insertions(+), 3 deletions(-)

-- 
2.17.1

