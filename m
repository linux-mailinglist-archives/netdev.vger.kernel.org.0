Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7165C41BA63
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 00:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243134AbhI1WbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 18:31:05 -0400
Received: from mail-ot1-f45.google.com ([209.85.210.45]:37683 "EHLO
        mail-ot1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243128AbhI1WbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 18:31:03 -0400
Received: by mail-ot1-f45.google.com with SMTP id r43-20020a05683044ab00b0054716b40005so432161otv.4;
        Tue, 28 Sep 2021 15:29:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vwcHQF6/8HUIm1fObpnSG0aiSaXON6QZUe3Gw0ku0bk=;
        b=UveUJOKNqA/XPlmllq1lNHiwUvg5j3CKTNtK+9TEaklBTBvZaZO0JU9SJ1hOmQjxVt
         N4uo/9YDiVnM3sB2UPTfJRoCrHgECKRSCwO1vuvnd/4UEibwSl1lEG8Y407HC3OoYmYP
         GF7M7SzOJjAyFqW9ZObVWij9Rf0JFvIbu1wDlRiLsdhCPINGfqUNf/RAcj6jB9HzbBB0
         KO8HwR9iKd3MVfpQfh1Di2vEVSiogGakO9cRZ0xaQyIvYaw2p214KfH0v0DUlloVG7eI
         xLGiE9OpN18kULGtBFPrRbq15IrXGnhZ7EqkP59qkb0n0DyOtINSPwNTd/eXAOHdAFX9
         RmNQ==
X-Gm-Message-State: AOAM530caI4grhCMJ4WQ/ZqA4c5GWtRFCfg3Bc4sPDUUJ7o6tlUgVx9N
        SdMGQwzjK7uQ83nL7bUZswB/ryN+rw==
X-Google-Smtp-Source: ABdhPJwIo8LpG9CqlCCSYyWBM2R+bXzVEo57GgT/4sLojNBA5cKROdiFakWw9bMvfnaBeZBHr5CWRA==
X-Received: by 2002:a05:6830:25d1:: with SMTP id d17mr7302750otu.253.1632868162403;
        Tue, 28 Sep 2021 15:29:22 -0700 (PDT)
Received: from xps15.herring.priv (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.googlemail.com with ESMTPSA id g4sm65460ooa.44.2021.09.28.15.29.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 15:29:21 -0700 (PDT)
From:   Rob Herring <robh@kernel.org>
To:     devicetree@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Evgeniy Polyakov <zbr@ioremap.net>,
        Marek Vasut <marex@denx.de>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Daniel Mack <zonque@gmail.com>,
        dri-devel@lists.freedesktop.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] dt-bindings: Drop more redundant 'maxItems'
Date:   Tue, 28 Sep 2021 17:29:20 -0500
Message-Id: <20210928222920.2204761-1-robh@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Another round of removing redundant minItems/maxItems from new schema in
the recent merge window.

If a property has an 'items' list, then a 'minItems' or 'maxItems' with the
same size as the list is redundant and can be dropped. Note that is DT
schema specific behavior and not standard json-schema behavior. The tooling
will fixup the final schema adding any unspecified minItems/maxItems.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Marek Vasut <marex@denx.de>
Cc: Joakim Zhang <qiangqing.zhang@nxp.com>
Cc: Daniel Mack <zonque@gmail.com>
Cc: dri-devel@lists.freedesktop.org
Cc: netdev@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Rob Herring <robh@kernel.org>
---
 .../devicetree/bindings/display/bridge/ti,sn65dsi83.yaml        | 2 --
 Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml        | 1 -
 Documentation/devicetree/bindings/w1/w1-gpio.yaml               | 1 -
 3 files changed, 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/display/bridge/ti,sn65dsi83.yaml b/Documentation/devicetree/bindings/display/bridge/ti,sn65dsi83.yaml
index 07b20383cbca..b446d0f0f1b4 100644
--- a/Documentation/devicetree/bindings/display/bridge/ti,sn65dsi83.yaml
+++ b/Documentation/devicetree/bindings/display/bridge/ti,sn65dsi83.yaml
@@ -50,7 +50,6 @@ properties:
               data-lanes:
                 description: array of physical DSI data lane indexes.
                 minItems: 1
-                maxItems: 4
                 items:
                   - const: 1
                   - const: 2
@@ -71,7 +70,6 @@ properties:
               data-lanes:
                 description: array of physical DSI data lane indexes.
                 minItems: 1
-                maxItems: 4
                 items:
                   - const: 1
                   - const: 2
diff --git a/Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml b/Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml
index 5629b2e4ccf8..ee4afe361fac 100644
--- a/Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml
+++ b/Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml
@@ -34,7 +34,6 @@ properties:
 
   clocks:
     minItems: 3
-    maxItems: 5
     items:
       - description: MAC host clock
       - description: MAC apb clock
diff --git a/Documentation/devicetree/bindings/w1/w1-gpio.yaml b/Documentation/devicetree/bindings/w1/w1-gpio.yaml
index 7ba1c2fd4722..8eef2380161b 100644
--- a/Documentation/devicetree/bindings/w1/w1-gpio.yaml
+++ b/Documentation/devicetree/bindings/w1/w1-gpio.yaml
@@ -15,7 +15,6 @@ properties:
 
   gpios:
     minItems: 1
-    maxItems: 2
     items:
       - description: Data I/O pin
       - description: Enable pin for an external pull-up resistor
-- 
2.30.2

