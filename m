Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 705721C2D54
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 17:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728828AbgECPVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 11:21:33 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:29357 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728345AbgECPV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 11:21:29 -0400
X-IronPort-AV: E=Sophos;i="5.73,347,1583161200"; 
   d="scan'208";a="46006153"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 04 May 2020 00:21:27 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 15C184007F56;
        Mon,  4 May 2020 00:21:24 +0900 (JST)
From:   Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S. Miller" <davem@davemloft.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Rob Herring <robh+dt@kernel.org>,
        Simon Horman <horms+renesas@verge.net.au>
Cc:     Lad Prabhakar <prabhakar.csengg@gmail.com>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH v2] dt-bindings: net: renesas,ether: Sort compatible string in increasing number of the SoC
Date:   Sun,  3 May 2020 16:21:19 +0100
Message-Id: <1588519279-13364-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sort the items in the compatible string list in increasing number of SoC.

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 Changes for v2:
 * Included renesas,ether in subject instead of sh_eth.
 * Included Reviewed-by tags.

 Documentation/devicetree/bindings/net/renesas,ether.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/renesas,ether.yaml b/Documentation/devicetree/bindings/net/renesas,ether.yaml
index 2eaa879..005a3ae 100644
--- a/Documentation/devicetree/bindings/net/renesas,ether.yaml
+++ b/Documentation/devicetree/bindings/net/renesas,ether.yaml
@@ -29,8 +29,8 @@ properties:
               - renesas,rcar-gen1-ether  # a generic R-Car Gen1 device
       - items:
           - enum:
-              - renesas,ether-r8a7745    # device is a part of R8A7745 SoC
               - renesas,ether-r8a7743    # device is a part of R8A7743 SoC
+              - renesas,ether-r8a7745    # device is a part of R8A7745 SoC
               - renesas,ether-r8a7790    # device is a part of R8A7790 SoC
               - renesas,ether-r8a7791    # device is a part of R8A7791 SoC
               - renesas,ether-r8a7793    # device is a part of R8A7793 SoC
-- 
2.7.4

