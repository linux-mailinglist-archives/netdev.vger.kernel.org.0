Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD5EE96320
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 16:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730432AbfHTOxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 10:53:48 -0400
Received: from vps.xff.cz ([195.181.215.36]:60048 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729351AbfHTOxs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 10:53:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1566312825; bh=wIAxljKfYwADgH+42GDkJIwLygOIg7HG/xvcRvcY98U=;
        h=From:To:Cc:Subject:Date:References:From;
        b=JQloAJ9JgxomMDFTbsLxbkyZJgYGUbjBaehlsq8CDjjsR5kp8P2V0WYdgIg7+puj6
         AFMc4kQ/MwZPB+37mMTvujOxThMU3fqh605btYUrm9Kj8JtaQRpcl2rhfqL4tJ35CM
         I13XbUfgxDkjIsR5LBRq5X2HaxW5C+MsAGAiCREI=
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
Subject: [PATCH 2/6] dt-bindings: net: sun8i-a83t-emac: Add phy-io-supply property
Date:   Tue, 20 Aug 2019 16:53:39 +0200
Message-Id: <20190820145343.29108-3-megous@megous.com>
In-Reply-To: <20190820145343.29108-1-megous@megous.com>
References: <20190820145343.29108-1-megous@megous.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ondrej Jirman <megous@megous.com>

Some PHYs require separate power supply for I/O pins in some modes
of operation. Add phy-io-supply property, to allow enabling this
power supply.

Signed-off-by: Ondrej Jirman <megous@megous.com>
---
 .../devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml    | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml b/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
index 304f244e9ab5..782e202aa124 100644
--- a/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
+++ b/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
@@ -47,6 +47,10 @@ properties:
     description:
       PHY regulator
 
+  phy-io-supply:
+    description:
+      PHY I/O pins regulator
+
 required:
   - compatible
   - reg
-- 
2.22.1

