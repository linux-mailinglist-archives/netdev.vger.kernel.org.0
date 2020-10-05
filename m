Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 971CA283196
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 10:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbgJEINZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 04:13:25 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:21606 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725887AbgJEINZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 04:13:25 -0400
X-IronPort-AV: E=Sophos;i="5.77,338,1596466800"; 
   d="scan'208";a="58928994"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 05 Oct 2020 17:13:23 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id C01F5400619F;
        Mon,  5 Oct 2020 17:13:20 +0900 (JST)
From:   Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-kernel@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [RESEND PATCH v2 0/2] dt-bindings: can: document R8A774E1
Date:   Mon,  5 Oct 2020 09:13:17 +0100
Message-Id: <20201005081319.29322-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

I am re-sending this patch set as this has been missed previously.
It is exactly same as [1].

DT maintainers have already acked the patches.

[1] https://www.spinics.net/lists/netdev/msg679244.html

Cheers,
Prabhakar

Changes for v2:
* Added R8A774E1 to the list of SoCs that can use CANFD through "clkp2".
* Added R8A774E1 to the list of SoCs that can use the CANFD clock

Lad Prabhakar (2):
  dt-bindings: can: rcar_canfd: Document r8a774e1 support
  dt-bindings: can: rcar_can: Document r8a774e1 support

 Documentation/devicetree/bindings/net/can/rcar_can.txt   | 5 +++--
 Documentation/devicetree/bindings/net/can/rcar_canfd.txt | 5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

-- 
2.17.1

