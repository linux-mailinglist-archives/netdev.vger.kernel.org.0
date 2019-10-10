Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 352AED299B
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 14:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387463AbfJJMhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 08:37:42 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:7227 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726923AbfJJMhl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 08:37:41 -0400
X-IronPort-AV: E=Sophos;i="5.67,280,1566831600"; 
   d="scan'208";a="28789735"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 10 Oct 2019 21:37:39 +0900
Received: from fabrizio-dev.ree.adwin.renesas.com (unknown [10.226.36.196])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 9227B4000901;
        Thu, 10 Oct 2019 21:37:35 +0900 (JST)
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
Subject: [PATCH 0/3] Add CAN and CAN-FD support to RZ/G2N SoC
Date:   Thu, 10 Oct 2019 13:37:26 +0100
Message-Id: <1570711049-5691-1-git-send-email-fabrizio.castro@bp.renesas.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear All,

this series adds CAN and CAN FD support to the RZ/G2N SoC specific dtsi.

Thanks,
Fab

Fabrizio Castro (3):
  dt-bindings: can: rcar_can: Add r8a774b1 support
  dt-bindings: can: rcar_canfd: document r8a774b1 support
  arm64: dts: renesas: r8a774b1: Add CAN and CAN FD support

 .../devicetree/bindings/net/can/rcar_can.txt       |  5 ++-
 .../devicetree/bindings/net/can/rcar_canfd.txt     |  1 +
 arch/arm64/boot/dts/renesas/r8a774b1.dtsi          | 48 ++++++++++++++++++++--
 3 files changed, 49 insertions(+), 5 deletions(-)

-- 
2.7.4

