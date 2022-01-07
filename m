Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F22EE487126
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 04:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345798AbiAGDTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 22:19:47 -0500
Received: from mail-oi1-f175.google.com ([209.85.167.175]:34791 "EHLO
        mail-oi1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344897AbiAGDTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 22:19:46 -0500
Received: by mail-oi1-f175.google.com with SMTP id r131so6537209oig.1;
        Thu, 06 Jan 2022 19:19:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N/+02Uu7Xsp1Sp9baEddjo+2GjQCq8pPfkwGXAATyL4=;
        b=h8DgHNc0YRkw52axUfUCpRduO1WL1Addg7w4C6DZnNnLLZbxzq2RQQUBWUdEBnf+BA
         +q5oSqer1RL5JCWqm2OlT1rIWEtGHF3rHpwaLw99KjlkXS8YkVjgQlK1IozK7L89AnKg
         5vROE+hb6LpD5OQYe4Iwcz7+Chw9OO2Yn4S2Ie7xgZytmYklTK9gRdtOhrs5juxyX1A7
         pyQ34QXfZyi51bY4WRlP/HJeUdRtnNdPX+fsLX1JnSoV0DB+uFfFAR45Tay1K4ZOwk+w
         f665aYX9vJYLOocsjqq1FFd61f6VK51pZfgHWb6rfxZc4CtdZ8aMwnPEFCIpJwK9HLJ+
         qBXw==
X-Gm-Message-State: AOAM5324wlUrOb81/3kGdLkXTSChYQOaIKPwmasbSYTv0KDOwB9/7sW2
        7F3OSrhsY7MUUPvCCY3hAg==
X-Google-Smtp-Source: ABdhPJxFwsoov8BM23F84ePRF4MesulXZT7/QFwJgwS4jJCHX9pjJTcfT92RcdErUYh2DLqb705wyg==
X-Received: by 2002:a05:6808:f11:: with SMTP id m17mr4241451oiw.36.1641525585657;
        Thu, 06 Jan 2022 19:19:45 -0800 (PST)
Received: from xps15.herring.priv (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.googlemail.com with ESMTPSA id q13sm555020otf.76.2022.01.06.19.19.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 19:19:45 -0800 (PST)
From:   Rob Herring <robh@kernel.org>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Greentime Hu <greentime.hu@sifive.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Suman Anna <s-anna@ti.com>, - <patches@opensource.cirrus.com>,
        John Crispin <john@phrozen.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Kumar Gogada <bharat.kumar.gogada@xilinx.com>
Cc:     linux-gpio@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: [PATCH] dt-bindings: Drop required 'interrupt-parent'
Date:   Thu,  6 Jan 2022 21:19:04 -0600
Message-Id: <20220107031905.2406176-1-robh@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'interrupt-parent' is never required as it can be in a parent node or a
parent node itself can be an interrupt provider. Where exactly it lives is
outside the scope of a binding schema.

Signed-off-by: Rob Herring <robh@kernel.org>
---
 .../devicetree/bindings/gpio/toshiba,gpio-visconti.yaml  | 1 -
 .../devicetree/bindings/mailbox/ti,omap-mailbox.yaml     | 9 ---------
 Documentation/devicetree/bindings/mfd/cirrus,madera.yaml | 1 -
 .../devicetree/bindings/net/lantiq,etop-xway.yaml        | 1 -
 .../devicetree/bindings/net/lantiq,xrx200-net.yaml       | 1 -
 .../devicetree/bindings/pci/sifive,fu740-pcie.yaml       | 1 -
 .../devicetree/bindings/pci/xilinx-versal-cpm.yaml       | 1 -
 7 files changed, 15 deletions(-)

diff --git a/Documentation/devicetree/bindings/gpio/toshiba,gpio-visconti.yaml b/Documentation/devicetree/bindings/gpio/toshiba,gpio-visconti.yaml
index 9ad470e01953..b085450b527f 100644
--- a/Documentation/devicetree/bindings/gpio/toshiba,gpio-visconti.yaml
+++ b/Documentation/devicetree/bindings/gpio/toshiba,gpio-visconti.yaml
@@ -43,7 +43,6 @@ required:
   - gpio-controller
   - interrupt-controller
   - "#interrupt-cells"
-  - interrupt-parent
 
 additionalProperties: false
 
diff --git a/Documentation/devicetree/bindings/mailbox/ti,omap-mailbox.yaml b/Documentation/devicetree/bindings/mailbox/ti,omap-mailbox.yaml
index e864d798168d..d433e496ec6e 100644
--- a/Documentation/devicetree/bindings/mailbox/ti,omap-mailbox.yaml
+++ b/Documentation/devicetree/bindings/mailbox/ti,omap-mailbox.yaml
@@ -175,15 +175,6 @@ required:
   - ti,mbox-num-fifos
 
 allOf:
-  - if:
-      properties:
-        compatible:
-          enum:
-            - ti,am654-mailbox
-    then:
-      required:
-        - interrupt-parent
-
   - if:
       properties:
         compatible:
diff --git a/Documentation/devicetree/bindings/mfd/cirrus,madera.yaml b/Documentation/devicetree/bindings/mfd/cirrus,madera.yaml
index 499c62c04daa..5dce62a7eff2 100644
--- a/Documentation/devicetree/bindings/mfd/cirrus,madera.yaml
+++ b/Documentation/devicetree/bindings/mfd/cirrus,madera.yaml
@@ -221,7 +221,6 @@ required:
   - '#gpio-cells'
   - interrupt-controller
   - '#interrupt-cells'
-  - interrupt-parent
   - interrupts
   - AVDD-supply
   - DBVDD1-supply
diff --git a/Documentation/devicetree/bindings/net/lantiq,etop-xway.yaml b/Documentation/devicetree/bindings/net/lantiq,etop-xway.yaml
index 437502c5ca96..3ce9f9a16baf 100644
--- a/Documentation/devicetree/bindings/net/lantiq,etop-xway.yaml
+++ b/Documentation/devicetree/bindings/net/lantiq,etop-xway.yaml
@@ -46,7 +46,6 @@ properties:
 required:
   - compatible
   - reg
-  - interrupt-parent
   - interrupts
   - interrupt-names
   - lantiq,tx-burst-length
diff --git a/Documentation/devicetree/bindings/net/lantiq,xrx200-net.yaml b/Documentation/devicetree/bindings/net/lantiq,xrx200-net.yaml
index 7bc074a42369..5bc1a21ca579 100644
--- a/Documentation/devicetree/bindings/net/lantiq,xrx200-net.yaml
+++ b/Documentation/devicetree/bindings/net/lantiq,xrx200-net.yaml
@@ -38,7 +38,6 @@ properties:
 required:
   - compatible
   - reg
-  - interrupt-parent
   - interrupts
   - interrupt-names
   - "#address-cells"
diff --git a/Documentation/devicetree/bindings/pci/sifive,fu740-pcie.yaml b/Documentation/devicetree/bindings/pci/sifive,fu740-pcie.yaml
index 2b9d1d6fc661..72c78f4ec269 100644
--- a/Documentation/devicetree/bindings/pci/sifive,fu740-pcie.yaml
+++ b/Documentation/devicetree/bindings/pci/sifive,fu740-pcie.yaml
@@ -61,7 +61,6 @@ required:
   - num-lanes
   - interrupts
   - interrupt-names
-  - interrupt-parent
   - interrupt-map-mask
   - interrupt-map
   - clock-names
diff --git a/Documentation/devicetree/bindings/pci/xilinx-versal-cpm.yaml b/Documentation/devicetree/bindings/pci/xilinx-versal-cpm.yaml
index a2bbc0eb7220..32f4641085bc 100644
--- a/Documentation/devicetree/bindings/pci/xilinx-versal-cpm.yaml
+++ b/Documentation/devicetree/bindings/pci/xilinx-versal-cpm.yaml
@@ -55,7 +55,6 @@ required:
   - reg-names
   - "#interrupt-cells"
   - interrupts
-  - interrupt-parent
   - interrupt-map
   - interrupt-map-mask
   - bus-range
-- 
2.32.0

