Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F77D192BD
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 21:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfEITUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 15:20:32 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:60226 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726907AbfEITUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 15:20:32 -0400
X-IronPort-AV: E=Sophos;i="5.60,450,1549897200"; 
   d="scan'208";a="15462905"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 10 May 2019 04:20:29 +0900
Received: from fabrizio-dev.ree.adwin.renesas.com (unknown [10.226.36.196])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 4F427415F3F2;
        Fri, 10 May 2019 04:20:26 +0900 (JST)
From:   Fabrizio Castro <fabrizio.castro@bp.renesas.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc:     Fabrizio Castro <fabrizio.castro@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Simon Horman <horms@verge.net.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH repost 0/5] Repost CAN and CANFD dt-bindings
Date:   Thu,  9 May 2019 20:20:17 +0100
Message-Id: <1557429622-31676-1-git-send-email-fabrizio.castro@bp.renesas.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear All,

I am reposting some CAN and CANFD related dt-bindings changes for
Renesas' R-Car and RZ/G devices that have been originally sent
end of last year and beginning of this year.

Thanks,
Fab

Fabrizio Castro (3):
  dt-bindings: can: rcar_can: Fix RZ/G2 CAN clocks
  dt-bindings: can: rcar_can: Add r8a774c0 support
  dt-bindings: can: rcar_canfd: document r8a774c0 support

Marek Vasut (2):
  dt-bindings: can: rcar_canfd: document r8a77965 support
  dt-bindings: can: rcar_canfd: document r8a77990 support

 Documentation/devicetree/bindings/net/can/rcar_can.txt   | 13 ++++---------
 Documentation/devicetree/bindings/net/can/rcar_canfd.txt | 16 ++++++++++------
 2 files changed, 14 insertions(+), 15 deletions(-)

-- 
2.7.4

