Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D547853484A
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 03:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345814AbiEZBmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 21:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345828AbiEZBmD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 21:42:03 -0400
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33406A7E13;
        Wed, 25 May 2022 18:41:59 -0700 (PDT)
Received: by mail-oi1-f171.google.com with SMTP id i66so603326oia.11;
        Wed, 25 May 2022 18:41:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d+Z9RgiK3EIxVlZZsUbr4/gk0SD8+6Vq2nxSeiDB3Go=;
        b=lonZS1Pi4KRL8RzO1Z0tiH9qUojyzK/dL5wtw2dI+r1w4Cx/N8mctkpbzYaOD/H6bA
         wyesyM50Wr738vR+XsMWpb1aoUZ4/V70zOGaCu9YEZocTLH81SOtGINPoTvSS7AOQ48N
         O0RifAjoxpfpc4KdxSKHs8JlMsMifdoAlh2RP7E419G0enlnvkVQXj7Xp+cEH/n1VDPK
         AGBa8u4L7fpkr/J8UfGmSEt3cpbELl9SEMWVk7CafzrCW8uocoebncLqrYVMDg8CUldz
         ioWctwm5+bZhSii5cwwsCWywVmbrptd/zlzjuAi4yiT+fnjwr302z1pVSH1JjC+E1164
         dvwg==
X-Gm-Message-State: AOAM53023vTsYNe3gU1hOC+YV5VHFPEaq1qEVqgpcdI7b5CY0KdSQMia
        e2Vr4agbz1RZdzii4mqSyw==
X-Google-Smtp-Source: ABdhPJxuUpgwjNNVehgCikH94aM0C278Tato0V32TMxGzCsr8Y3hkxPGQkpU0UbT585q/wH8Oxdo3Q==
X-Received: by 2002:a05:6808:210a:b0:326:77be:466f with SMTP id r10-20020a056808210a00b0032677be466fmr5336oiw.184.1653529318875;
        Wed, 25 May 2022 18:41:58 -0700 (PDT)
Received: from xps15.. (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.googlemail.com with ESMTPSA id pi12-20020a0568704c8c00b000e9b8376a7bsm162542oab.23.2022.05.25.18.41.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 18:41:58 -0700 (PDT)
From:   Rob Herring <robh@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kalle Valo <kvalo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Biao Huang <biao.huang@mediatek.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH] dt-bindings: net: Fix unevaluatedProperties warnings in examples
Date:   Wed, 25 May 2022 20:41:48 -0500
Message-Id: <20220526014149.2872762-1-robh@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'unevaluatedProperties' schema checks is not fully working and doesn't
catch some cases where there's a $ref to another schema. A fix is pending,
but results in new warnings in examples. Fix the warnings by removing
spurious properties or adding missing properties to the schema.

Signed-off-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/net/cdns,macb.yaml           | 1 -
 Documentation/devicetree/bindings/net/mediatek,net.yaml        | 3 +++
 Documentation/devicetree/bindings/net/mediatek-dwmac.yaml      | 3 +++
 .../devicetree/bindings/net/wireless/mediatek,mt76.yaml        | 2 +-
 4 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/cdns,macb.yaml b/Documentation/devicetree/bindings/net/cdns,macb.yaml
index 337cec4d85ca..86fc31c2d91b 100644
--- a/Documentation/devicetree/bindings/net/cdns,macb.yaml
+++ b/Documentation/devicetree/bindings/net/cdns,macb.yaml
@@ -191,7 +191,6 @@ examples:
                     clock-names = "pclk", "hclk", "tx_clk", "rx_clk", "tsu_clk";
                     #address-cells = <1>;
                     #size-cells = <0>;
-                    #stream-id-cells = <1>;
                     iommus = <&smmu 0x875>;
                     power-domains = <&zynqmp_firmware PD_ETH_1>;
                     resets = <&zynqmp_reset ZYNQMP_RESET_GEM1>;
diff --git a/Documentation/devicetree/bindings/net/mediatek,net.yaml b/Documentation/devicetree/bindings/net/mediatek,net.yaml
index 699164dd1295..f5564ecddb62 100644
--- a/Documentation/devicetree/bindings/net/mediatek,net.yaml
+++ b/Documentation/devicetree/bindings/net/mediatek,net.yaml
@@ -27,6 +27,9 @@ properties:
   reg:
     maxItems: 1
 
+  clocks: true
+  clock-names: true
+
   interrupts:
     minItems: 3
     maxItems: 4
diff --git a/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml b/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
index 901944683322..61b2fb9e141b 100644
--- a/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
@@ -58,6 +58,9 @@ properties:
       - const: rmii_internal
       - const: mac_cg
 
+  power-domains:
+    maxItems: 1
+
   mediatek,pericfg:
     $ref: /schemas/types.yaml#/definitions/phandle
     description:
diff --git a/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
index 249967d8d750..5a12dc32288a 100644
--- a/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
+++ b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
@@ -51,7 +51,7 @@ properties:
     description:
       Specify the consys reset for mt7986.
 
-  reset-name:
+  reset-names:
     const: consys
 
   mediatek,infracfg:
-- 
2.34.1

