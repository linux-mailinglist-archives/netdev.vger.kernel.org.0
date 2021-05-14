Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8915380901
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 13:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233008AbhENL4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 07:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232901AbhENL4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 07:56:16 -0400
Received: from mail.manjaro.org (mail.manjaro.org [IPv6:2a01:4f8:150:448b::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2A28C061756
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 04:55:05 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.manjaro.org (Postfix) with ESMTP id D958F22111F;
        Fri, 14 May 2021 13:36:55 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at manjaro.org
Received: from mail.manjaro.org ([127.0.0.1])
        by localhost (manjaro.org [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id OjnBuv_pq9NX; Fri, 14 May 2021 13:36:53 +0200 (CEST)
From:   Tobias Schramm <t.schramm@manjaro.org>
To:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Heiko Stuebner <heiko@sntech.de>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        David Wu <david.wu@rock-chips.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tobias Schramm <t.schramm@manjaro.org>
Subject: [PATCH 1/3] dt-bindings: net: rockchip-dwmac: add rk3308 gmac compatible
Date:   Fri, 14 May 2021 13:38:11 +0200
Message-Id: <20210514113813.2093534-2-t.schramm@manjaro.org>
In-Reply-To: <20210514113813.2093534-1-t.schramm@manjaro.org>
References: <20210514113813.2093534-1-t.schramm@manjaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Rockchip RK3308 has a gmac that is not fully compatible with any of the
other Rockchip gmacs.
This patch adds a compatible string for it.

Signed-off-by: Tobias Schramm <t.schramm@manjaro.org>
---
 Documentation/devicetree/bindings/net/rockchip-dwmac.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml b/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml
index 5acddb6171bf..34a660ad6b30 100644
--- a/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml
@@ -19,6 +19,7 @@ select:
           - rockchip,rk3128-gmac
           - rockchip,rk3228-gmac
           - rockchip,rk3288-gmac
+          - rockchip,rk3308-gmac
           - rockchip,rk3328-gmac
           - rockchip,rk3366-gmac
           - rockchip,rk3368-gmac
@@ -38,6 +39,7 @@ properties:
           - rockchip,rk3128-gmac
           - rockchip,rk3228-gmac
           - rockchip,rk3288-gmac
+          - rockchip,rk3308-gmac
           - rockchip,rk3328-gmac
           - rockchip,rk3366-gmac
           - rockchip,rk3368-gmac
-- 
2.31.1

