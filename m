Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B68FA388BC5
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 12:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348676AbhESKnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 06:43:47 -0400
Received: from foss.arm.com ([217.140.110.172]:58948 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348511AbhESKnl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 06:43:41 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0E14711B3;
        Wed, 19 May 2021 03:42:22 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CBE513F719;
        Wed, 19 May 2021 03:42:19 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Maxime Ripard <mripard@kernel.org>, Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Cc:     Rob Herring <robh@kernel.org>, Icenowy Zheng <icenowy@aosc.io>,
        Samuel Holland <samuel@sholland.org>,
        Ondrej Jirman <megous@megous.com>,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        linux-sunxi@lists.linux.dev, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH v6 06/17] dt-bindings: net: sun8i-emac: Add H616 compatible string
Date:   Wed, 19 May 2021 11:41:41 +0100
Message-Id: <20210519104152.21119-7-andre.przywara@arm.com>
X-Mailer: git-send-email 2.14.1
In-Reply-To: <20210519104152.21119-1-andre.przywara@arm.com>
References: <20210519104152.21119-1-andre.przywara@arm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the obvious compatible name to the existing EMAC binding, and pair
it with the existing A64 fallback compatible string, as the devices are
compatible.

On the way use enums to group the compatible devices together.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 .../devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml    | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml b/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
index 7f2578d48e3f..0ccdab103f59 100644
--- a/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
+++ b/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
@@ -19,7 +19,9 @@ properties:
       - const: allwinner,sun8i-v3s-emac
       - const: allwinner,sun50i-a64-emac
       - items:
-          - const: allwinner,sun50i-h6-emac
+          - enum:
+              - allwinner,sun50i-h6-emac
+              - allwinner,sun50i-h616-emac
           - const: allwinner,sun50i-a64-emac
 
   reg:
-- 
2.17.5

