Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3B751F6ACE
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 17:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728554AbgFKPTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 11:19:30 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:42611 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728484AbgFKPT0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 11:19:26 -0400
Received: by mail-il1-f196.google.com with SMTP id j19so1611700ilk.9;
        Thu, 11 Jun 2020 08:19:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Bzom5I0Qsx/lQuO9r3157DQxFx5Ipkb4zVlo1+AHki0=;
        b=NNeDxr0AecAkZ4HRa1nydSUAeXZNp9nkI/lhJMYPBp0FXYGc5aItTdWp67nEiRzSdE
         aLt0OFni0Lb068GbLSiN8CLBfae5JzsQgRmFPtJgY1qFjAKtxb/lClagJbtj12KImuTM
         t80SQt5HPYRmajZE2WKzERzgARVmQo8dSpFtDm7P0pjsqDVbV5JXUGBEsa01cq+lgmRY
         01VOHxfincKZNe9LtFpFZQ8PfzpkWaYA6Lhw83JhyPomofFwizdjSi0f+FNmDW30R6+N
         GINPQIF9VnH8UufPBrumgrbLw9zGqrKbajupnuLRrXQ/vTO/MVTw6RdoZipeRj/LPd+s
         1UkQ==
X-Gm-Message-State: AOAM530YY+W/hzVth3mew2/XvdJ+WhjpKgh5X9NSUN3yleImE5iYPGRS
        ARviH/AT8Uv3Zd5gmVfgJ/Q0SEM=
X-Google-Smtp-Source: ABdhPJzBBFxrtcbhqbQcEvm2dr7A3emRqSD+5s6FURtJq4Jy7T00ZrsFE/lLZJrZDfQS7fz2X4MsgA==
X-Received: by 2002:a05:6e02:e51:: with SMTP id l17mr8951200ilk.39.1591888764995;
        Thu, 11 Jun 2020 08:19:24 -0700 (PDT)
Received: from xps15.herring.priv ([64.188.179.251])
        by smtp.googlemail.com with ESMTPSA id c20sm1587533iot.33.2020.06.11.08.19.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2020 08:19:24 -0700 (PDT)
From:   Rob Herring <robh@kernel.org>
To:     devicetree@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        "David S. Miller" <davem@davemloft.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        linux-rockchip@lists.infradead.org, linux-media@vger.kernel.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: [PATCH] dt-bindings: Fix more incorrect 'reg' property sizes in examples
Date:   Thu, 11 Jun 2020 09:19:23 -0600
Message-Id: <20200611151923.1102796-1-robh@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The examples template is a 'simple-bus' with a size of 1 cell for
had between 2 and 4 cells which really only errors on I2C or SPI type
devices with a single cell.

The easiest fix in most cases is to change the 'reg' property to 1 cell
for address and size.

Cc: "Heiko Stübner" <heiko@sntech.de>
Cc: Ezequiel Garcia <ezequiel@collabora.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Vinod Koul <vkoul@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-rockchip@lists.infradead.org
Cc: linux-media@vger.kernel.org
Cc: linux-mtd@lists.infradead.org
Cc: netdev@vger.kernel.org
Cc: alsa-devel@alsa-project.org
Signed-off-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/bus/baikal,bt1-apb.yaml     | 4 ++--
 Documentation/devicetree/bindings/bus/baikal,bt1-axi.yaml     | 4 ++--
 .../devicetree/bindings/display/rockchip/rockchip-vop.yaml    | 4 ++--
 Documentation/devicetree/bindings/media/rockchip,vdec.yaml    | 2 +-
 Documentation/devicetree/bindings/media/rockchip-vpu.yaml     | 2 +-
 .../devicetree/bindings/mtd/arasan,nand-controller.yaml       | 2 +-
 Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml   | 2 +-
 .../devicetree/bindings/phy/qcom,usb-snps-femto-v2.yaml       | 2 +-
 Documentation/devicetree/bindings/sound/fsl,easrc.yaml        | 2 +-
 9 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/Documentation/devicetree/bindings/bus/baikal,bt1-apb.yaml b/Documentation/devicetree/bindings/bus/baikal,bt1-apb.yaml
index d6a3b71ea835..68b0131a31d0 100644
--- a/Documentation/devicetree/bindings/bus/baikal,bt1-apb.yaml
+++ b/Documentation/devicetree/bindings/bus/baikal,bt1-apb.yaml
@@ -71,8 +71,8 @@ examples:
 
     bus@1f059000 {
       compatible = "baikal,bt1-apb", "simple-bus";
-      reg = <0 0x1f059000 0 0x1000>,
-            <0 0x1d000000 0 0x2040000>;
+      reg = <0x1f059000 0x1000>,
+            <0x1d000000 0x2040000>;
       reg-names = "ehb", "nodev";
       #address-cells = <1>;
       #size-cells = <1>;
diff --git a/Documentation/devicetree/bindings/bus/baikal,bt1-axi.yaml b/Documentation/devicetree/bindings/bus/baikal,bt1-axi.yaml
index 203bc0e5346b..29e1aaea132b 100644
--- a/Documentation/devicetree/bindings/bus/baikal,bt1-axi.yaml
+++ b/Documentation/devicetree/bindings/bus/baikal,bt1-axi.yaml
@@ -85,8 +85,8 @@ examples:
 
     bus@1f05a000 {
       compatible = "baikal,bt1-axi", "simple-bus";
-      reg = <0 0x1f05a000 0 0x1000>,
-            <0 0x1f04d110 0 0x8>;
+      reg = <0x1f05a000 0x1000>,
+            <0x1f04d110 0x8>;
       reg-names = "qos", "ehb";
       #address-cells = <1>;
       #size-cells = <1>;
diff --git a/Documentation/devicetree/bindings/display/rockchip/rockchip-vop.yaml b/Documentation/devicetree/bindings/display/rockchip/rockchip-vop.yaml
index 1695e3e4bcec..ed8148e26e24 100644
--- a/Documentation/devicetree/bindings/display/rockchip/rockchip-vop.yaml
+++ b/Documentation/devicetree/bindings/display/rockchip/rockchip-vop.yaml
@@ -106,8 +106,8 @@ examples:
     #include <dt-bindings/power/rk3288-power.h>
     vopb: vopb@ff930000 {
       compatible = "rockchip,rk3288-vop";
-      reg = <0x0 0xff930000 0x0 0x19c>,
-            <0x0 0xff931000 0x0 0x1000>;
+      reg = <0xff930000 0x19c>,
+            <0xff931000 0x1000>;
       interrupts = <GIC_SPI 15 IRQ_TYPE_LEVEL_HIGH>;
       clocks = <&cru ACLK_VOP0>,
                <&cru DCLK_VOP0>,
diff --git a/Documentation/devicetree/bindings/media/rockchip,vdec.yaml b/Documentation/devicetree/bindings/media/rockchip,vdec.yaml
index 0c68cdad9a31..8d35c327018b 100644
--- a/Documentation/devicetree/bindings/media/rockchip,vdec.yaml
+++ b/Documentation/devicetree/bindings/media/rockchip,vdec.yaml
@@ -61,7 +61,7 @@ examples:
 
     vdec: video-codec@ff660000 {
         compatible = "rockchip,rk3399-vdec";
-        reg = <0x0 0xff660000 0x0 0x400>;
+        reg = <0xff660000 0x400>;
         interrupts = <GIC_SPI 116 IRQ_TYPE_LEVEL_HIGH 0>;
         clocks = <&cru ACLK_VDU>, <&cru HCLK_VDU>,
                  <&cru SCLK_VDU_CA>, <&cru SCLK_VDU_CORE>;
diff --git a/Documentation/devicetree/bindings/media/rockchip-vpu.yaml b/Documentation/devicetree/bindings/media/rockchip-vpu.yaml
index 27df18ad6a81..2b629456d75f 100644
--- a/Documentation/devicetree/bindings/media/rockchip-vpu.yaml
+++ b/Documentation/devicetree/bindings/media/rockchip-vpu.yaml
@@ -66,7 +66,7 @@ examples:
 
         vpu: video-codec@ff9a0000 {
                 compatible = "rockchip,rk3288-vpu";
-                reg = <0x0 0xff9a0000 0x0 0x800>;
+                reg = <0xff9a0000 0x800>;
                 interrupts = <GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>,
                              <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>;
                 interrupt-names = "vepu", "vdpu";
diff --git a/Documentation/devicetree/bindings/mtd/arasan,nand-controller.yaml b/Documentation/devicetree/bindings/mtd/arasan,nand-controller.yaml
index db8f115a13ec..cb9794edff24 100644
--- a/Documentation/devicetree/bindings/mtd/arasan,nand-controller.yaml
+++ b/Documentation/devicetree/bindings/mtd/arasan,nand-controller.yaml
@@ -53,7 +53,7 @@ examples:
   - |
     nfc: nand-controller@ff100000 {
         compatible = "xlnx,zynqmp-nand-controller", "arasan,nfc-v3p10";
-        reg = <0x0 0xff100000 0x0 0x1000>;
+        reg = <0xff100000 0x1000>;
         clock-names = "controller", "bus";
         clocks = <&clk200>, <&clk100>;
         interrupt-parent = <&gic>;
diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml
index af608f2ecfdf..9b7117920d90 100644
--- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml
+++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml
@@ -121,7 +121,7 @@ examples:
 
     cpts@310d0000 {
          compatible = "ti,am65-cpts";
-         reg = <0x0 0x310d0000 0x0 0x400>;
+         reg = <0x310d0000 0x400>;
          reg-names = "cpts";
          clocks = <&main_cpts_mux>;
          clock-names = "cpts";
diff --git a/Documentation/devicetree/bindings/phy/qcom,usb-snps-femto-v2.yaml b/Documentation/devicetree/bindings/phy/qcom,usb-snps-femto-v2.yaml
index 574f890fab1d..4949a2851532 100644
--- a/Documentation/devicetree/bindings/phy/qcom,usb-snps-femto-v2.yaml
+++ b/Documentation/devicetree/bindings/phy/qcom,usb-snps-femto-v2.yaml
@@ -65,7 +65,7 @@ examples:
     #include <dt-bindings/clock/qcom,gcc-sm8150.h>
     phy@88e2000 {
         compatible = "qcom,sm8150-usb-hs-phy";
-        reg = <0 0x088e2000 0 0x400>;
+        reg = <0x088e2000 0x400>;
         #phy-cells = <0>;
 
         clocks = <&rpmhcc RPMH_CXO_CLK>;
diff --git a/Documentation/devicetree/bindings/sound/fsl,easrc.yaml b/Documentation/devicetree/bindings/sound/fsl,easrc.yaml
index 9dd57a974b28..32d547af9ce7 100644
--- a/Documentation/devicetree/bindings/sound/fsl,easrc.yaml
+++ b/Documentation/devicetree/bindings/sound/fsl,easrc.yaml
@@ -80,7 +80,7 @@ examples:
 
     easrc: easrc@300c0000 {
            compatible = "fsl,imx8mn-easrc";
-           reg = <0x0 0x300c0000 0x0 0x10000>;
+           reg = <0x300c0000 0x10000>;
            interrupts = <0x0 122 0x4>;
            clocks = <&clk IMX8MN_CLK_ASRC_ROOT>;
            clock-names = "mem";
-- 
2.25.1

