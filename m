Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D08E427A103
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 14:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgI0Mj4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 08:39:56 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:34270 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726149AbgI0Mj4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 08:39:56 -0400
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Sep 2020 08:39:56 EDT
X-IronPort-AV: E=Sophos;i="5.77,310,1596466800"; 
   d="scan'208";a="58260505"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 27 Sep 2020 21:34:52 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 297DB40062C5;
        Sun, 27 Sep 2020 21:34:49 +0900 (JST)
From:   Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org
Cc:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        linux-kernel@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Marian-Cristian Rotariu 
        <marian-cristian.rotariu.rb@bp.renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [RESEND PATCH] dt-bindings: net: renesas,ravb: Add support for r8a774e1 SoC
Date:   Sun, 27 Sep 2020 13:34:39 +0100
Message-Id: <20200927123439.29300-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>

Document RZ/G2H (R8A774E1) SoC bindings.

Signed-off-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Rob Herring <robh@kernel.org>
---
Hi David,

This patch is part of series [1] and is Acked the DT maintainers,
while rest of the patches have been picked up by the respective
maintainers, could you please pick this patch.

[1] https://www.spinics.net/lists/dmaengine/msg22887.html

Cheers,
Prabhakar
---
 Documentation/devicetree/bindings/net/renesas,ravb.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/renesas,ravb.txt b/Documentation/devicetree/bindings/net/renesas,ravb.txt
index 032b76f14f4f..9119f1caf391 100644
--- a/Documentation/devicetree/bindings/net/renesas,ravb.txt
+++ b/Documentation/devicetree/bindings/net/renesas,ravb.txt
@@ -21,6 +21,7 @@ Required properties:
       - "renesas,etheravb-r8a774a1" for the R8A774A1 SoC.
       - "renesas,etheravb-r8a774b1" for the R8A774B1 SoC.
       - "renesas,etheravb-r8a774c0" for the R8A774C0 SoC.
+      - "renesas,etheravb-r8a774e1" for the R8A774E1 SoC.
       - "renesas,etheravb-r8a7795" for the R8A7795 SoC.
       - "renesas,etheravb-r8a7796" for the R8A77960 SoC.
       - "renesas,etheravb-r8a77961" for the R8A77961 SoC.
-- 
2.17.1

