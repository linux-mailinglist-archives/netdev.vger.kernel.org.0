Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3CF7DA90C
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 11:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394037AbfJQJsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 05:48:11 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:42361 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727242AbfJQJsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 05:48:11 -0400
X-Originating-IP: 86.207.98.53
Received: from localhost (aclermont-ferrand-651-1-259-53.w86-207.abo.wanadoo.fr [86.207.98.53])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 8BD7320004;
        Thu, 17 Oct 2019 09:48:06 +0000 (UTC)
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>, Vladimir Zapolskiy <vz@mleia.com>,
        Sylvain Lemieux <slemieux.tyco@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH v2 1/2] dt-bindings: net: lpc-eth: document optional properties
Date:   Thu, 17 Oct 2019 11:47:56 +0200
Message-Id: <20191017094757.26885-1-alexandre.belloni@bootlin.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Ethernet controller is also an mdio controller, to be able to parse
children (phys for example), #address-cells and #size-cells must be
present.

Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
---
 Documentation/devicetree/bindings/net/lpc-eth.txt | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/lpc-eth.txt b/Documentation/devicetree/bindings/net/lpc-eth.txt
index b92e927808b6..cfe0e5991d46 100644
--- a/Documentation/devicetree/bindings/net/lpc-eth.txt
+++ b/Documentation/devicetree/bindings/net/lpc-eth.txt
@@ -10,6 +10,11 @@ Optional properties:
   absent, "rmii" is assumed.
 - use-iram: Use LPC32xx internal SRAM (IRAM) for DMA buffering
 
+Optional subnodes:
+- mdio : specifies the mdio bus, used as a container for phy nodes according to
+  phy.txt in the same directory
+
+
 Example:
 
 	mac: ethernet@31060000 {
-- 
2.21.0

