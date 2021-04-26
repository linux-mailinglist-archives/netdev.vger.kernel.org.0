Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB3F836AAB9
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 04:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbhDZCmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 22:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbhDZCmT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 22:42:19 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F10A9C061574;
        Sun, 25 Apr 2021 19:41:38 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id 030D31F41F94
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     netdev@vger.kernel.org, linux-rockchip@lists.infradead.org,
        devicetree@vger.kernel.org
Cc:     Jose Abreu <joabreu@synopsys.com>,
        Heiko Stuebner <heiko@sntech.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Peter Geis <pgwipeout@gmail.com>,
        Kever Yang <kever.yang@rock-chips.com>,
        David Wu <david.wu@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>,
        Johan Jonker <jbx6244@gmail.com>,
        Ezequiel Garcia <ezequiel@collabora.com>, kernel@collabora.com
Subject: [PATCH 2/3] dt-bindings: net: dwmac: Add Rockchip DWMAC support
Date:   Sun, 25 Apr 2021 23:41:17 -0300
Message-Id: <20210426024118.18717-2-ezequiel@collabora.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210426024118.18717-1-ezequiel@collabora.com>
References: <20210426024118.18717-1-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Rockchip DWMAC controllers, which are based on snps,dwmac.
Some of the SoCs require up to eight clocks, so maxItems
for clocks and clock-names need to be increased.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 .../devicetree/bindings/net/snps,dwmac.yaml         | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index 0642b0f59491..2edd8bea993e 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -56,6 +56,15 @@ properties:
         - amlogic,meson8m2-dwmac
         - amlogic,meson-gxbb-dwmac
         - amlogic,meson-axg-dwmac
+        - rockchip,px30-gmac
+        - rockchip,rk3128-gmac
+        - rockchip,rk3228-gmac
+        - rockchip,rk3288-gmac
+        - rockchip,rk3328-gmac
+        - rockchip,rk3366-gmac
+        - rockchip,rk3368-gmac
+        - rockchip,rk3399-gmac
+        - rockchip,rv1108-gmac
         - snps,dwmac
         - snps,dwmac-3.50a
         - snps,dwmac-3.610
@@ -89,7 +98,7 @@ properties:
 
   clocks:
     minItems: 1
-    maxItems: 5
+    maxItems: 8
     additionalItems: true
     items:
       - description: GMAC main clock
@@ -101,7 +110,7 @@ properties:
 
   clock-names:
     minItems: 1
-    maxItems: 5
+    maxItems: 8
     additionalItems: true
     contains:
       enum:
-- 
2.30.0

