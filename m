Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71FD6166E3
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 17:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbfEGPgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 11:36:15 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:51549 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726726AbfEGPgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 11:36:15 -0400
Received: from mc-bl-xps13.lan (aaubervilliers-681-1-86-253.w90-88.abo.wanadoo.fr [90.88.28.253])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id 5A9D8100010;
        Tue,  7 May 2019 15:36:11 +0000 (UTC)
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com
Subject: [PATCH net] dt-bindings: net: Fix a typo in the phy-mode list for ethernet bindings
Date:   Tue,  7 May 2019 17:35:55 +0200
Message-Id: <20190507153555.18545-1-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The phy_mode "2000base-x" is actually supposed to be "1000base-x", even
though the commit title of the original patch says otherwise.

Fixes: 55601a880690 ("net: phy: Add 2000base-x, 2500base-x and rxaui modes")
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
 Documentation/devicetree/bindings/net/ethernet.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/ethernet.txt b/Documentation/devicetree/bindings/net/ethernet.txt
index a68621580584..d45b5b56fa39 100644
--- a/Documentation/devicetree/bindings/net/ethernet.txt
+++ b/Documentation/devicetree/bindings/net/ethernet.txt
@@ -36,7 +36,7 @@ Documentation/devicetree/bindings/phy/phy-bindings.txt.
   * "smii"
   * "xgmii"
   * "trgmii"
-  * "2000base-x",
+  * "1000base-x",
   * "2500base-x",
   * "rxaui"
   * "xaui"
-- 
2.20.1

