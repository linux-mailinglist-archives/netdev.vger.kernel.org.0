Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 446FB9632B
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 16:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbfHTOyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 10:54:21 -0400
Received: from vps.xff.cz ([195.181.215.36]:60028 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729155AbfHTOxr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 10:53:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1566312825; bh=pjJHOWO7nxttAsWYJkOKvdkuaULnN0PZZ0RAx5PpN9o=;
        h=From:To:Cc:Subject:Date:References:From;
        b=qluk3iBQwrjiEBjSIXnZAafxX6k9lhkgFCeddtDvIAl7JMO+Qt0ZDOCav+zNhQtUW
         4i/wOMDdMxpBqkyqrB67GP86/7lpBKTY0FbsdQVpLRS/nayXCeyRz+0IjEubxfNo2q
         JljrlnPu7zifGmGGs1Y4aDWbZA/PkOP+uwRrjCRI=
From:   megous@megous.com
To:     "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     Ondrej Jirman <megous@megous.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com
Subject: [PATCH 1/6] dt-bindings: net: sun8i-a83t-emac: Add phy-supply property
Date:   Tue, 20 Aug 2019 16:53:38 +0200
Message-Id: <20190820145343.29108-2-megous@megous.com>
In-Reply-To: <20190820145343.29108-1-megous@megous.com>
References: <20190820145343.29108-1-megous@megous.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ondrej Jirman <megous@megous.com>

This is already supported by the driver, but is missing from the
bindings.

Signed-off-by: Ondrej Jirman <megous@megous.com>
---
 .../devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml    | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml b/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
index 3fb0714e761e..304f244e9ab5 100644
--- a/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
+++ b/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
@@ -43,6 +43,10 @@ properties:
       Phandle to the device containing the EMAC or GMAC clock
       register
 
+  phy-supply:
+    description:
+      PHY regulator
+
 required:
   - compatible
   - reg
-- 
2.22.1

