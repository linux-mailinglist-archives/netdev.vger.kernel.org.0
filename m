Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B158E53456D
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 22:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238920AbiEYU6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 16:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbiEYU6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 16:58:44 -0400
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3FAEBA54B;
        Wed, 25 May 2022 13:58:43 -0700 (PDT)
Received: by mail-ot1-f52.google.com with SMTP id l10-20020a9d7a8a000000b0060b151de434so6756010otn.2;
        Wed, 25 May 2022 13:58:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+7R0jOM1X4u7urBmc2283Rmo7eHakiDoT/FWr1Vpcl8=;
        b=IqIGYdzrWDahmOJXfR5Xv0qGOIIyY3y2iE1rpGzSPQueVxMDJC8N0iN4C1ODKw8PCJ
         s2CimiEkiDWtjzeLLvJyt+8iSO+iRXdVAnd6phKoaSjNq677wyPd5EIRkSiS+BzPiJk0
         UNBc7yQiVK9jdeuGzM2QkUHPkLPkDSNb41gj47Mvk03q+ZmAq3kJxUNHWPWzvPaseBab
         CjCDk4wA6uqrGIWdgJro6+NF3oCAeejqVuG4d4Pxdyf0q8++QXe1MuXe1LGyF64KTOru
         7y7gl5a0p2ErLJRvJ8bIQewGsrRgcrZJksZ+s5C+r4AJDPEbYBNapKfh/8dpZOfn/iv9
         uS7w==
X-Gm-Message-State: AOAM5330UT6iAHwwU6D004hOuyYd+v/prjgDNIZVbQnNPfB2zMCp8kDl
        YO2F9iYGGU5icjvEXT8AXw==
X-Google-Smtp-Source: ABdhPJz5l3JFyaeKrZTFkTzK+zkeMuXVUREn2S52CFfzx7dHLtxFxgDEfFTcUKndzWb2gdIez3qIeQ==
X-Received: by 2002:a05:6830:310c:b0:606:66c8:53d4 with SMTP id b12-20020a056830310c00b0060666c853d4mr13372565ots.129.1653512323186;
        Wed, 25 May 2022 13:58:43 -0700 (PDT)
Received: from xps15.. (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.googlemail.com with ESMTPSA id t5-20020a056871054500b000e686d1386asm6398922oal.4.2022.05.25.13.58.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 13:58:42 -0700 (PDT)
From:   Rob Herring <robh@kernel.org>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Marek Vasut <marex@denx.de>
Cc:     Woojung Huh <Woojung.Huh@microchip.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] dt-bindings: net/dsa: Add spi-peripheral-props.yaml references
Date:   Wed, 25 May 2022 15:57:50 -0500
Message-Id: <20220525205752.2484423-1-robh@kernel.org>
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

SPI peripheral device bindings need to reference spi-peripheral-props.yaml
in order to use various SPI controller specific properties. Otherwise,
the unevaluatedProperties check will reject any controller specific
properties.

Signed-off-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml | 1 +
 Documentation/devicetree/bindings/net/dsa/realtek.yaml       | 1 +
 2 files changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
index 184152087b60..6bbd8145b6c1 100644
--- a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
@@ -12,6 +12,7 @@ maintainers:
 
 allOf:
   - $ref: dsa.yaml#
+  - $ref: /schemas/spi/spi-peripheral-props.yaml#
 
 properties:
   # See Documentation/devicetree/bindings/net/dsa/dsa.yaml for a list of additional
diff --git a/Documentation/devicetree/bindings/net/dsa/realtek.yaml b/Documentation/devicetree/bindings/net/dsa/realtek.yaml
index 99ee4b5b9346..4f99aff029dc 100644
--- a/Documentation/devicetree/bindings/net/dsa/realtek.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/realtek.yaml
@@ -108,6 +108,7 @@ if:
     - reg
 
 then:
+  $ref: /schemas/spi/spi-peripheral-props.yaml#
   not:
     required:
       - mdc-gpios
-- 
2.34.1

