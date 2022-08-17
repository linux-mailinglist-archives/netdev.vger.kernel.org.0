Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 321B65974A5
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 18:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241113AbiHQQzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 12:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240977AbiHQQzB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 12:55:01 -0400
Received: from baptiste.telenet-ops.be (baptiste.telenet-ops.be [IPv6:2a02:1800:120:4::f00:13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7058D74CDD
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 09:54:59 -0700 (PDT)
Received: from ramsan.of.borg ([84.195.186.194])
        by baptiste.telenet-ops.be with bizsmtp
        id 8gut2800Q4C55Sk01gutjl; Wed, 17 Aug 2022 18:54:57 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1oOMJg-001VWQ-Sq; Wed, 17 Aug 2022 18:54:52 +0200
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1oOMJg-0035oh-Hb; Wed, 17 Aug 2022 18:54:52 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Slark Xiao <slark_xiao@163.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v2] dt-bindings: Fix incorrect "the the" corrections
Date:   Wed, 17 Aug 2022 18:54:51 +0200
Message-Id: <c5743c0a1a24b3a8893797b52fed88b99e56b04b.1660755148.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lots of double occurrences of "the" were replaced by single occurrences,
but some of them should become "to the" instead.

Fixes: 12e5bde18d7f6ca4 ("dt-bindings: Fix typo in comment")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
v2:
  - Drop blank line between Fixes and SoB tags.
---
 Documentation/devicetree/bindings/net/qcom-emac.txt         | 2 +-
 Documentation/devicetree/bindings/thermal/rcar-thermal.yaml | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/qcom-emac.txt b/Documentation/devicetree/bindings/net/qcom-emac.txt
index e6cb2291471c4c11..7ae8aa14863454d2 100644
--- a/Documentation/devicetree/bindings/net/qcom-emac.txt
+++ b/Documentation/devicetree/bindings/net/qcom-emac.txt
@@ -14,7 +14,7 @@ MAC node:
 - mac-address : The 6-byte MAC address. If present, it is the default
 	MAC address.
 - internal-phy : phandle to the internal PHY node
-- phy-handle : phandle the external PHY node
+- phy-handle : phandle to the external PHY node
 
 Internal PHY node:
 - compatible : Should be "qcom,fsm9900-emac-sgmii" or "qcom,qdf2432-emac-sgmii".
diff --git a/Documentation/devicetree/bindings/thermal/rcar-thermal.yaml b/Documentation/devicetree/bindings/thermal/rcar-thermal.yaml
index 00dcbdd361442981..119998d10ff41836 100644
--- a/Documentation/devicetree/bindings/thermal/rcar-thermal.yaml
+++ b/Documentation/devicetree/bindings/thermal/rcar-thermal.yaml
@@ -42,7 +42,7 @@ properties:
     description:
       Address ranges of the thermal registers. If more then one range is given
       the first one must be the common registers followed by each sensor
-      according the datasheet.
+      according to the datasheet.
     minItems: 1
     maxItems: 4
 
-- 
2.25.1

