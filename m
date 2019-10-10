Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9F1D32B9
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 22:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbfJJUph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 16:45:37 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:35085 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbfJJUpg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 16:45:36 -0400
X-Originating-IP: 86.202.229.42
Received: from localhost (lfbn-lyo-1-146-42.w86-202.abo.wanadoo.fr [86.202.229.42])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 5062DC0006;
        Thu, 10 Oct 2019 20:45:34 +0000 (UTC)
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Vladimir Zapolskiy <vz@mleia.com>,
        Sylvain Lemieux <slemieux.tyco@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 1/2] dt-bindings: net: lpc-eth: document optional properties
Date:   Thu, 10 Oct 2019 22:45:29 +0200
Message-Id: <20191010204530.15150-1-alexandre.belloni@bootlin.com>
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
 Documentation/devicetree/bindings/net/lpc-eth.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/lpc-eth.txt b/Documentation/devicetree/bindings/net/lpc-eth.txt
index b92e927808b6..53884555db05 100644
--- a/Documentation/devicetree/bindings/net/lpc-eth.txt
+++ b/Documentation/devicetree/bindings/net/lpc-eth.txt
@@ -9,6 +9,8 @@ Optional properties:
 - phy-mode: See ethernet.txt file in the same directory. If the property is
   absent, "rmii" is assumed.
 - use-iram: Use LPC32xx internal SRAM (IRAM) for DMA buffering
+- #address-cells: should be present when child phy is decribed. Must be 1.
+- #size-cells: should be present when child phy is decribed. Must be 0.
 
 Example:
 
-- 
2.21.0

