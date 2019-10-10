Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1FB5D2C63
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 16:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbfJJO0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 10:26:09 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:57697 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725923AbfJJO0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 10:26:08 -0400
X-IronPort-AV: E=Sophos;i="5.67,280,1566831600"; 
   d="scan'208";a="28794119"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 10 Oct 2019 23:26:06 +0900
Received: from fabrizio-dev.ree.adwin.renesas.com (unknown [10.226.36.196])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id BE7E24288736;
        Thu, 10 Oct 2019 23:26:02 +0900 (JST)
From:   Fabrizio Castro <fabrizio.castro@bp.renesas.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc:     Fabrizio Castro <fabrizio.castro@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>
Subject: [PATCH v2 0/3] Add CAN and CAN-FD support to the RZ/G2N SoC
Date:   Thu, 10 Oct 2019 15:25:57 +0100
Message-Id: <1570717560-7431-1-git-send-email-fabrizio.castro@bp.renesas.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear All,

this series adds CAN and CAN FD support to the RZ/G2N SoC specific dtsi.

Thanks,
Fab

v1->v2:
* Fixed patch 2/3 according to Geert's comment

Fabrizio Castro (3):
  dt-bindings: can: rcar_can: Add r8a774b1 support
  dt-bindings: can: rcar_canfd: document r8a774b1 support
  arm64: dts: renesas: r8a774b1: Add CAN and CAN FD support

 .../devicetree/bindings/net/can/rcar_can.txt       |  5 ++-
 .../devicetree/bindings/net/can/rcar_canfd.txt     |  5 ++-
 arch/arm64/boot/dts/renesas/r8a774b1.dtsi          | 48 ++++++++++++++++++++--
 3 files changed, 51 insertions(+), 7 deletions(-)

-- 
2.7.4

