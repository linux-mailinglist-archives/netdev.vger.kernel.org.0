Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BCB959E933
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 19:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbiHWRWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 13:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240032AbiHWRVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 13:21:11 -0400
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C787C529;
        Tue, 23 Aug 2022 07:57:17 -0700 (PDT)
Received: by mail-ot1-f51.google.com with SMTP id l5-20020a05683004a500b0063707ff8244so9929370otd.12;
        Tue, 23 Aug 2022 07:57:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=32fb+kP/GNTtD4yV9TOnD2b7RZ03KBwBx6+ibrPD+y8=;
        b=YoKL8784sOKdLGvnkA2TH2RNCwV3bfT8AD1iJP3C9tqeIA/iSuJSEJhdymVWtgAEmn
         x+yKWkkb/xnGSwa46aYI1x6YjUYo3vauOpH0S0geFzSWm3KqrYpkrC4kAxD3kDEmwTqd
         3gJJ+YL6YSl8g0vONsduCPwFeG0xYRuYMLoiMaiCrslfB2jb+7A4xJEoSbClHiJv52Ia
         glNiJ3vy+9wuCDtGtpvHP1kjgSxDJ5c3pxM6+GBJSKAV9+7zphdD/BaoZspk/Z9/XoUS
         iCkC30zz4WuicUvSWOYqM6Kq5xTx8Hk/L8y4pFTx22B07eyZv+lNP5QDQ6I9HEtSUtWj
         57JA==
X-Gm-Message-State: ACgBeo2hfJgWlyBWGGG40rBKOHIEM00NR/Tb2pV7teIOT/LEU7ub2QSy
        3javVQQcVamBGSYAu794hA==
X-Google-Smtp-Source: AA6agR5gTDVPXYx4XrmwbScdPsvRYbDyHtuAdNcSHU1Fwpadq2Y01zAfG/CkPYSQeOvRnZjzCO7kHw==
X-Received: by 2002:a05:6830:2498:b0:638:9325:3370 with SMTP id u24-20020a056830249800b0063893253370mr9666966ots.228.1661266636988;
        Tue, 23 Aug 2022 07:57:16 -0700 (PDT)
Received: from xps15.. (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.googlemail.com with ESMTPSA id t1-20020a056870600100b0011c65559b04sm3840637oaa.34.2022.08.23.07.57.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 07:57:16 -0700 (PDT)
From:   Rob Herring <robh@kernel.org>
To:     Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Sekhar Nori <nsekhar@ti.com>
Cc:     linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] dt-bindings: net: Add missing (unevaluated|additional)Properties on child nodes
Date:   Tue, 23 Aug 2022 09:56:36 -0500
Message-Id: <20220823145649.3118479-5-robh@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to ensure only documented properties are present, node schemas
must have unevaluatedProperties or additionalProperties set to false
(typically).

Signed-off-by: Rob Herring <robh@kernel.org>
---
 .../devicetree/bindings/net/cortina,gemini-ethernet.yaml      | 1 +
 Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml     | 4 ++++
 .../devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml        | 1 +
 Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml   | 1 +
 4 files changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/cortina,gemini-ethernet.yaml b/Documentation/devicetree/bindings/net/cortina,gemini-ethernet.yaml
index cc01b9b5752a..253b5d1407ee 100644
--- a/Documentation/devicetree/bindings/net/cortina,gemini-ethernet.yaml
+++ b/Documentation/devicetree/bindings/net/cortina,gemini-ethernet.yaml
@@ -37,6 +37,7 @@ properties:
 patternProperties:
   "^ethernet-port@[0-9]+$":
     type: object
+    unevaluatedProperties: false
     description: contains the resources for ethernet port
     allOf:
       - $ref: ethernet-controller.yaml#
diff --git a/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml b/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
index 31bf825c6598..46e330f45768 100644
--- a/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
+++ b/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
@@ -77,6 +77,8 @@ properties:
 
   ethernet-ports:
     type: object
+    additionalProperties: false
+
     properties:
       '#address-cells':
         const: 1
@@ -89,6 +91,7 @@ properties:
         description: CPSW external ports
 
         $ref: ethernet-controller.yaml#
+        unevaluatedProperties: false
 
         properties:
           reg:
@@ -117,6 +120,7 @@ properties:
 
   cpts:
     type: object
+    unevaluatedProperties: false
     description:
       The Common Platform Time Sync (CPTS) module
 
diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
index b8281d8be940..fb61a2ce0ea8 100644
--- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
+++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
@@ -115,6 +115,7 @@ properties:
         description: CPSWxG NUSS external ports
 
         $ref: ethernet-controller.yaml#
+        unevaluatedProperties: false
 
         properties:
           reg:
diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml
index b783ad0d1f53..e9f78cef6b7f 100644
--- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml
+++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml
@@ -95,6 +95,7 @@ properties:
 
   refclk-mux:
     type: object
+    additionalProperties: false
     description: CPTS reference clock multiplexer clock
     properties:
       '#clock-cells':
-- 
2.34.1

