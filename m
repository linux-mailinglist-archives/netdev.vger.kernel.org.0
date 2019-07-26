Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 287E676F04
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 18:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728820AbfGZQ0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 12:26:30 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:45220 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727554AbfGZQ0a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 12:26:30 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 45wDx01dQsz1rJhX;
        Fri, 26 Jul 2019 18:26:28 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 45wDx00gynz1qqkT;
        Fri, 26 Jul 2019 18:26:28 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id JMbysYmC5yQD; Fri, 26 Jul 2019 18:26:25 +0200 (CEST)
X-Auth-Info: mV9JwZLuzEltqVV4qYjlyg5n7bhnR7y4hSXyYuIFvbI=
Received: from kurokawa.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Fri, 26 Jul 2019 18:26:25 +0200 (CEST)
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
Subject: [PATCH V3 1/3] dt-bindings: net: dsa: ksz: document Microchip KSZ87xx family switches
Date:   Fri, 26 Jul 2019 18:23:06 +0200
Message-Id: <20190726162308.16764-2-marex@denx.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726162308.16764-1-marex@denx.de>
References: <20190726162308.16764-1-marex@denx.de>
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

