Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC7321E288
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 23:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbgGMVg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 17:36:27 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:6771 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726150AbgGMVfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 17:35:52 -0400
X-IronPort-AV: E=Sophos;i="5.75,348,1589209200"; 
   d="scan'208";a="52016003"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 14 Jul 2020 06:35:51 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 532E640F7FC8;
        Tue, 14 Jul 2020 06:35:47 +0900 (JST)
From:   Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Vinod Koul <vkoul@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        dmaengine@vger.kernel.org, devicetree@vger.kernel.org,
        linux-gpio@vger.kernel.org, iommu@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>
Subject: [PATCH 6/9] dt-bindings: gpio: renesas,rcar-gpio: Add r8a774e1 support
Date:   Mon, 13 Jul 2020 22:35:17 +0100
Message-Id: <1594676120-5862-7-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1594676120-5862-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <1594676120-5862-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document Renesas RZ/G2H (R8A774E1) GPIO blocks compatibility within the
relevant dt-bindings.

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
 Documentation/devicetree/bindings/gpio/renesas,rcar-gpio.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/gpio/renesas,rcar-gpio.yaml b/Documentation/devicetree/bindings/gpio/renesas,rcar-gpio.yaml
index 397d9383d15a..a9a9dd0854e7 100644
--- a/Documentation/devicetree/bindings/gpio/renesas,rcar-gpio.yaml
+++ b/Documentation/devicetree/bindings/gpio/renesas,rcar-gpio.yaml
@@ -37,6 +37,7 @@ properties:
              - renesas,gpio-r8a774a1     # RZ/G2M
              - renesas,gpio-r8a774b1     # RZ/G2N
              - renesas,gpio-r8a774c0     # RZ/G2E
+             - renesas,gpio-r8a774e1     # RZ/G2H
              - renesas,gpio-r8a7795      # R-Car H3
              - renesas,gpio-r8a7796      # R-Car M3-W
              - renesas,gpio-r8a77961     # R-Car M3-W+
-- 
2.17.1

