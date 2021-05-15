Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEDFF3818E9
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 15:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbhEONH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 09:07:56 -0400
Received: from mail.manjaro.org ([176.9.38.148]:49902 "EHLO mail.manjaro.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229888AbhEONHv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 May 2021 09:07:51 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.manjaro.org (Postfix) with ESMTP id 589B53E63057;
        Sat, 15 May 2021 15:06:37 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at manjaro.org
Received: from mail.manjaro.org ([127.0.0.1])
        by localhost (manjaro.org [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id iA5RIU16WZMZ; Sat, 15 May 2021 15:06:33 +0200 (CEST)
From:   Tobias Schramm <t.schramm@manjaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Johan Jonker <jbx6244@gmail.com>, linux-kernel@vger.kernel.org,
        Tobias Schramm <t.schramm@manjaro.org>
Subject: [PATCH 1/1] dt-bindings: net: dwmac: add compatible for RK3308 gmac
Date:   Sat, 15 May 2021 15:07:23 +0200
Message-Id: <20210515130723.2130624-2-t.schramm@manjaro.org>
In-Reply-To: <20210515130723.2130624-1-t.schramm@manjaro.org>
References: <20210515130723.2130624-1-t.schramm@manjaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A compatible string for the RK3308 gmac was added to rockchip-dwmac.yaml
in a previous patch.
Apparently it needs to be added to snps,dwmac.yaml, too since that file is
included by rockchip-dwmac.yaml.
This commit adds the compatible string for the RK3308 gmac to
snps,dwmac.yaml, too.

Signed-off-by: Tobias Schramm <t.schramm@manjaro.org>
---
 Documentation/devicetree/bindings/net/snps,dwmac.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index 2edd8bea993e..d94f02470b34 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -60,6 +60,7 @@ properties:
         - rockchip,rk3128-gmac
         - rockchip,rk3228-gmac
         - rockchip,rk3288-gmac
+        - rockchip,rk3308-gmac
         - rockchip,rk3328-gmac
         - rockchip,rk3366-gmac
         - rockchip,rk3368-gmac
-- 
2.31.1

