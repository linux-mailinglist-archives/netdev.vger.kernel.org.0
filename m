Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24F78383A1F
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 18:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239024AbhEQQiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 12:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242606AbhEQQie (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 12:38:34 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82D24C003663;
        Mon, 17 May 2021 08:41:05 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id 3BE141F423BB
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
        Chen-Yu Tsai <wens213@gmail.com>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v3 net-next 3/4] dt-bindings: net: rockchip-dwmac: add rk3568 compatible string
Date:   Mon, 17 May 2021 12:40:36 -0300
Message-Id: <20210517154037.37946-4-ezequiel@collabora.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210517154037.37946-1-ezequiel@collabora.com>
References: <20210517154037.37946-1-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add compatible string for RK3568 gmac, and constrain it to
be compatible with Synopsys dwmac 4.20a.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 .../bindings/net/rockchip-dwmac.yaml          | 30 +++++++++++--------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml b/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml
index 34a660ad6b30..083623c8d718 100644
--- a/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml
@@ -24,6 +24,7 @@ select:
           - rockchip,rk3366-gmac
           - rockchip,rk3368-gmac
           - rockchip,rk3399-gmac
+          - rockchip,rk3568-gmac
           - rockchip,rv1108-gmac
   required:
     - compatible
@@ -33,18 +34,23 @@ allOf:
 
 properties:
   compatible:
-    items:
-      - enum:
-          - rockchip,px30-gmac
-          - rockchip,rk3128-gmac
-          - rockchip,rk3228-gmac
-          - rockchip,rk3288-gmac
-          - rockchip,rk3308-gmac
-          - rockchip,rk3328-gmac
-          - rockchip,rk3366-gmac
-          - rockchip,rk3368-gmac
-          - rockchip,rk3399-gmac
-          - rockchip,rv1108-gmac
+    oneOf:
+      - items:
+          - enum:
+              - rockchip,px30-gmac
+              - rockchip,rk3128-gmac
+              - rockchip,rk3228-gmac
+              - rockchip,rk3288-gmac
+              - rockchip,rk3308-gmac
+              - rockchip,rk3328-gmac
+              - rockchip,rk3366-gmac
+              - rockchip,rk3368-gmac
+              - rockchip,rk3399-gmac
+              - rockchip,rv1108-gmac
+      - items:
+          - enum:
+              - rockchip,rk3568-gmac
+          - const: snps,dwmac-4.20a
 
   clocks:
     minItems: 5
-- 
2.30.0

