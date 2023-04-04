Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 140F16D6E34
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 22:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236067AbjDDUmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 16:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbjDDUmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 16:42:10 -0400
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E35DD44A3;
        Tue,  4 Apr 2023 13:42:09 -0700 (PDT)
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-17ebba88c60so36072426fac.3;
        Tue, 04 Apr 2023 13:42:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680640929;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HiD5Cz7lLNBfVW+arHQFNCec/cgbJ4PqJxRsUE2otgU=;
        b=aCBoHaqlOJiKQG1Rrb0QiWFyQBKZGjSxd2n1x5QQdsimtWMCiVG4lihM//wYWwz8t4
         o2aMBLxaDdTp3Kmhdu9dkU6odeweZHB66obsa2NP3sk7H0gEZUQYM78f9hylJu8hFoWa
         iJoOzPSBXDaeGzLYYJGDpcB+ugY2b4Lt5XrtuzY6Vk1BGiPYtvWNd4cXx79ZxKxOj7o6
         b3tGRMV/NxvybWds3SshWNnwultiUSj6Exy9k1dEkvk1fUyu8O4LpblnPV7cIdFIJMMa
         Qg6wAkMEAHcXKaZCn22ce5BvgF6Sbtl9gtuzWN1PIKeU7i7RTDFTNsm0bZiq03F8u3W7
         PCAg==
X-Gm-Message-State: AAQBX9e7LuxWCMqLQQ1a/2gxc9juns25UPrCg2Gst4vr2vjmeRaOPzeQ
        MAzGuRBMiJkO4NkyZxnWmQ==
X-Google-Smtp-Source: AKy350YPM4VV7XInRDiZ8ff49y6l0Un3uu4Vhz7nWAjq9QUnzD5kyzMt5aIKd8u1myFRpipHvig7eA==
X-Received: by 2002:a05:6870:b28a:b0:177:c8b4:5c45 with SMTP id c10-20020a056870b28a00b00177c8b45c45mr2328981oao.2.1680640929084;
        Tue, 04 Apr 2023 13:42:09 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id y5-20020a9d6345000000b006a249e69aebsm4021405otk.81.2023.04.04.13.42.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 13:42:08 -0700 (PDT)
Received: (nullmailer pid 635685 invoked by uid 1000);
        Tue, 04 Apr 2023 20:42:07 -0000
From:   Rob Herring <robh@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] dt-bindings: net: dsa: brcm,sf2: Drop unneeded "#address-cells/#size-cells"
Date:   Tue,  4 Apr 2023 15:41:52 -0500
Message-Id: <20230404204152.635400-1-robh@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.8 required=5.0 tests=FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's no need for "#address-cells/#size-cells" in the brcm,sf2 node as
no immediate child nodes have an address. What was probably intended was
to put them in the 'ports' node, but that's not necessary as that is
covered by ethernet-switch.yaml via dsa.yaml.

Signed-off-by: Rob Herring <robh@kernel.org>
---
 .../devicetree/bindings/net/dsa/brcm,sf2.yaml          | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/brcm,sf2.yaml b/Documentation/devicetree/bindings/net/dsa/brcm,sf2.yaml
index eed16e216fb6..72623cfc8c2d 100644
--- a/Documentation/devicetree/bindings/net/dsa/brcm,sf2.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/brcm,sf2.yaml
@@ -76,12 +76,6 @@ properties:
       supports reporting the number of packets in-flight in a switch queue
     type: boolean
 
-  "#address-cells":
-    const: 1
-
-  "#size-cells":
-    const: 0
-
   ports:
     type: object
 
@@ -99,8 +93,6 @@ properties:
 required:
   - reg
   - interrupts
-  - "#address-cells"
-  - "#size-cells"
 
 allOf:
   - $ref: "dsa.yaml#"
@@ -145,8 +137,6 @@ examples:
   - |
     switch@f0b00000 {
             compatible = "brcm,bcm7445-switch-v4.0";
-            #address-cells = <1>;
-            #size-cells = <0>;
             reg = <0xf0b00000 0x40000>,
                   <0xf0b40000 0x110>,
                   <0xf0b40340 0x30>,
-- 
2.39.2

