Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 575581D53C1
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 17:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgEOPKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 11:10:49 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:10282 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726244AbgEOPKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 11:10:44 -0400
X-IronPort-AV: E=Sophos;i="5.73,395,1583161200"; 
   d="scan'208";a="46974927"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 16 May 2020 00:10:42 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id AAAD440065C1;
        Sat, 16 May 2020 00:10:38 +0900 (JST)
From:   Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Jens Axboe <axboe@kernel.dk>, Rob Herring <robh+dt@kernel.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S. Miller" <davem@davemloft.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>
Cc:     linux-ide@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-mmc@vger.kernel.org, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH 16/17] dt-bindings: watchdog: renesas,wdt: Document r8a7742 support
Date:   Fri, 15 May 2020 16:08:56 +0100
Message-Id: <1589555337-5498-17-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RZ/G1H (R8A7742) watchdog implementation is compatible with R-Car Gen2,
therefore add relevant documentation.

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
---
 Documentation/devicetree/bindings/watchdog/renesas,wdt.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/watchdog/renesas,wdt.txt b/Documentation/devicetree/bindings/watchdog/renesas,wdt.txt
index 79b3c62..e42fd30 100644
--- a/Documentation/devicetree/bindings/watchdog/renesas,wdt.txt
+++ b/Documentation/devicetree/bindings/watchdog/renesas,wdt.txt
@@ -5,6 +5,7 @@ Required properties:
 		fallback compatible string when compatible with the generic
 		version.
 	       Examples with soctypes are:
+		 - "renesas,r8a7742-wdt" (RZ/G1H)
 		 - "renesas,r8a7743-wdt" (RZ/G1M)
 		 - "renesas,r8a7744-wdt" (RZ/G1N)
 		 - "renesas,r8a7745-wdt" (RZ/G1E)
-- 
2.7.4

