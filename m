Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C226E792A5
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 19:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728869AbfG2RxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 13:53:20 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:45056 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728428AbfG2RxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 13:53:16 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 45y6jj6CMNz1rYHJ;
        Mon, 29 Jul 2019 19:53:13 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 45y6jj36Fpz1qqkS;
        Mon, 29 Jul 2019 19:53:13 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id HMEoEI9xwb1B; Mon, 29 Jul 2019 19:53:12 +0200 (CEST)
X-Auth-Info: bbCaZbkX8T1qT/Uf5hYV23wSY8ekSAiAZqwM1YDcnEs=
Received: from kurokawa.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Mon, 29 Jul 2019 19:53:12 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        devicetree@vger.kernel.org
Subject: [PATCH V4 1/3] dt-bindings: net: dsa: ksz: document Microchip KSZ87xx family switches
Date:   Mon, 29 Jul 2019 19:49:45 +0200
Message-Id: <20190729174947.10103-2-marex@denx.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190729174947.10103-1-marex@denx.de>
References: <20190729174947.10103-1-marex@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document Microchip KSZ87xx family switches. These include
KSZ8765 - 5 port switch
KSZ8794 - 4 port switch
KSZ8795 - 5 port switch

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: David S. Miller <davem@davemloft.net>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Tristram Ha <Tristram.Ha@microchip.com>
Cc: Vivien Didelot <vivien.didelot@gmail.com>
Cc: Woojung Huh <woojung.huh@microchip.com>
Cc: devicetree@vger.kernel.org
---
V2: No change
V3: No change
V4: No change
---
 Documentation/devicetree/bindings/net/dsa/ksz.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/ksz.txt b/Documentation/devicetree/bindings/net/dsa/ksz.txt
index 4ac21cef370e..5e8429b6f9ca 100644
--- a/Documentation/devicetree/bindings/net/dsa/ksz.txt
+++ b/Documentation/devicetree/bindings/net/dsa/ksz.txt
@@ -5,6 +5,9 @@ Required properties:
 
 - compatible: For external switch chips, compatible string must be exactly one
   of the following:
+  - "microchip,ksz8765"
+  - "microchip,ksz8794"
+  - "microchip,ksz8795"
   - "microchip,ksz9477"
   - "microchip,ksz9897"
   - "microchip,ksz9896"
-- 
2.20.1

