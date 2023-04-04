Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8ED66D6E38
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 22:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236212AbjDDUmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 16:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236087AbjDDUm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 16:42:29 -0400
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50058468E;
        Tue,  4 Apr 2023 13:42:24 -0700 (PDT)
Received: by mail-oi1-f177.google.com with SMTP id bl22so11194284oib.11;
        Tue, 04 Apr 2023 13:42:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680640943;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KBi9VXnHWBPCYkffNdPrifIxEbW15RY1Ay74oyEreAU=;
        b=4n/Yrf0aS1kEaO+V9rQd5RoUE35QpjjNcNpuS25cadaE67ei2wUopJjpTbT7UYwhXv
         CsCgx51sz/Lb9X2cGAXwduYx1Rr9dsM7e6Y+s5gx2YGOs8RFQs71GS0oGhqvP1bxtpkG
         Yv9Vrt+Bl/dLerV47KAn/FH8mwyhUGQUKJKpAO0nWbmu48Yz0EwAgDRtqHyhyLURL62h
         BsWwCNm2m33V8dqKk3tzftLCY16/EdDR7QrHq5f7Ghi12Ln1tKLTFT37A96RunFtuPkk
         ZTR44DoFWOlAOkmy6dVuV08zg9ggqs1FOuppCPw8xM2xpzto0oI2Mloa4HW40bOnYk3o
         2SWA==
X-Gm-Message-State: AAQBX9cKjUFFGa5fSObNiCatC3EKyf4O/SCeqZNHHevF051OZcyxlj/t
        uPi6ySMod6lffrZpdP0R+Q==
X-Google-Smtp-Source: AKy350YVkwiiQklPnU32vOUMUIZnlFofSGv1HYMjqHQP+bygjvZC3mj8DJpsAFQ1lLyOzW7RYel+Eg==
X-Received: by 2002:a54:4585:0:b0:387:926e:35d3 with SMTP id z5-20020a544585000000b00387926e35d3mr241273oib.20.1680640943548;
        Tue, 04 Apr 2023 13:42:23 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id d11-20020a9d5e0b000000b006a3170fe3efsm4207936oti.27.2023.04.04.13.42.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 13:42:23 -0700 (PDT)
Received: (nullmailer pid 635963 invoked by uid 1000);
        Tue, 04 Apr 2023 20:42:22 -0000
From:   Rob Herring <robh@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Christian Marangi <ansuelsmth@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH] dt-bindings: net: ethernet-switch: Make "#address-cells/#size-cells" required
Date:   Tue,  4 Apr 2023 15:42:13 -0500
Message-Id: <20230404204213.635773-1-robh@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.7 required=5.0 tests=FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The schema doesn't allow for a single (unaddressed) ethernet port node
nor does a single port switch make much sense. So if there's always
multiple child nodes, "#address-cells" and "#size-cells" should be
required.

Signed-off-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/net/ethernet-switch.yaml   | 4 ++++
 Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml | 4 +++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/ethernet-switch.yaml b/Documentation/devicetree/bindings/net/ethernet-switch.yaml
index a04f8ef744aa..2ceccce6cbd7 100644
--- a/Documentation/devicetree/bindings/net/ethernet-switch.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-switch.yaml
@@ -40,6 +40,10 @@ patternProperties:
         type: object
         description: Ethernet switch ports
 
+    required:
+      - "#address-cells"
+      - "#size-cells"
+
 oneOf:
   - required:
       - ports
diff --git a/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml b/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml
index d7748dd33199..ad1ff9533697 100644
--- a/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml
+++ b/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml
@@ -53,7 +53,9 @@ examples:
             reg = <0x10>;
 
             ports {
-              /* ... */
+                #address-cells = <1>;
+                #size-cells = <0>;
+                /* ... */
             };
         };
     };
-- 
2.39.2

