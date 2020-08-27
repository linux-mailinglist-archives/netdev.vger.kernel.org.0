Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E375F25497C
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 17:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgH0Paq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 11:30:46 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:9247 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726120AbgH0Paq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 11:30:46 -0400
X-IronPort-AV: E=Sophos;i="5.76,359,1592838000"; 
   d="scan'208";a="55483987"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 28 Aug 2020 00:30:44 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 3503C400759E;
        Fri, 28 Aug 2020 00:30:42 +0900 (JST)
From:   Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     linux-can@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Prabhakar <prabhakar.csengg@gmail.com>
Subject: [PATCH v2 0/2] dt-bindings: can: document R8A774E1
Date:   Thu, 27 Aug 2020 16:30:39 +0100
Message-Id: <20200827153041.27806-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

Both the patches are part of series [1] (patch 18/20, 19/20),
rest of the patches have been acked/merged so just sending
two patches from the series.

[1] https://lkml.org/lkml/2020/7/15/515

Cheers,
Prabhakar

Changes for v2:
* Added R8A774E1 to the list of SoCs that can use CANFD through "clkp2".
* Added R8A774E1 to the list of SoCs that can use the CANFD clock.

Lad Prabhakar (2):
  dt-bindings: can: rcar_canfd: Document r8a774e1 support
  dt-bindings: can: rcar_can: Document r8a774e1 support

 Documentation/devicetree/bindings/net/can/rcar_can.txt   | 5 +++--
 Documentation/devicetree/bindings/net/can/rcar_canfd.txt | 5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

-- 
2.17.1

