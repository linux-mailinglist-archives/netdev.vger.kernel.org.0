Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43DD3563C4F
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 00:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbiGAWXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 18:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiGAWXt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 18:23:49 -0400
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A593BFAF;
        Fri,  1 Jul 2022 15:23:48 -0700 (PDT)
Received: by mail-io1-f48.google.com with SMTP id u20so3531563iob.8;
        Fri, 01 Jul 2022 15:23:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wgTXRa0gUVNHwULWBQ6HmK4rStMh8mkQWbVbr/JyhMI=;
        b=6EjuxkPT81t+q1OYYaSF3mXaJdusaH2YQ8QnnncpDLRxNVKAnba21olHnkwqhKtpgH
         v9ljiJ2Zrgxo6kd6XTJCe25NI89gVhZRZkddDRayzguvf4oqWNS0ytGtlNauCM1XVbJq
         isHvWd0QHPWTyDG/ZQRwKLP5orIMH+PR+wTgsCloROEXTreo0obkCkwP56CosQaeilNy
         h665Leuju0hMQSS/q5JztDBraBUNqPqMABl6fu+WIYvMFJ41AXYyqRJ6BOylCeRvxpTg
         Y0B2h0BzculOs89trbGwW2PwW/Joda7p68ftrgVAEAcrNVBP8InDvDTYyL9cSi6kcfVA
         z+Cw==
X-Gm-Message-State: AJIora+FIR4M8dUHIOis4+U6Ib76OrSqmgtPDMqCOd3hMj7euAiGYVpj
        YGEq6nW1J3+ZiC6f3ntNmA==
X-Google-Smtp-Source: AGRyM1ulGVnw6GEJ6uNo8AiP90w7VF/bBbxVRP75OaGfKKmHCUmJ1JkpX14z5ToaHIpMF1cfcdXH/w==
X-Received: by 2002:a6b:c941:0:b0:672:734f:d05f with SMTP id z62-20020a6bc941000000b00672734fd05fmr8199292iof.87.1656714228220;
        Fri, 01 Jul 2022 15:23:48 -0700 (PDT)
Received: from xps15.herring.priv ([64.188.179.248])
        by smtp.googlemail.com with ESMTPSA id t16-20020a92dc10000000b002d94906dacfsm9418189iln.67.2022.07.01.15.23.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 15:23:47 -0700 (PDT)
From:   Rob Herring <robh@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] dt-bindings: net: dsa: mediatek,mt7530: Add missing 'reg' property
Date:   Fri,  1 Jul 2022 16:22:40 -0600
Message-Id: <20220701222240.1706272-1-robh@kernel.org>
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

The 'reg' property is missing from the mediatek,mt7530 schema which
results in the following warning once 'unevaluatedProperties' is fixed:

Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.example.dtb: switch@0: Unevaluated properties are not allowed ('reg' was unexpected)

Fixes: e0dda3119741 ("dt-bindings: net: dsa: convert binding for mediatek switches")
Signed-off-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index a3bf432960d8..17ab6c69ecc7 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -66,6 +66,9 @@ properties:
       - mediatek,mt7531
       - mediatek,mt7621
 
+  reg:
+    maxItems: 1
+
   core-supply:
     description:
       Phandle to the regulator node necessary for the core power.
-- 
2.34.1

