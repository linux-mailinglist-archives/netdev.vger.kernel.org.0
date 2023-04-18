Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2C0F6E67C7
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 17:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbjDRPHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 11:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232291AbjDRPHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 11:07:20 -0400
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAED610E6;
        Tue, 18 Apr 2023 08:07:09 -0700 (PDT)
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-6a60460a23dso188456a34.0;
        Tue, 18 Apr 2023 08:07:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681830429; x=1684422429;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VH0juF1Ay9WqDgJkMzXt8/4BdR/G5VxOS4AZ5Dc0VG0=;
        b=S8XTZFP2Sou81ujmCL9gsRosY+uYdXjg59lvHUSDh2rclx4R6dBpcDGz/TnMNN2lOb
         aeHOzxmmWNRfmEkIZnTuYnlSR/37w3vI6oEUegcOTWwZtLSHGFfOdu/rqq4gm0liLmOA
         IZkIRNLO+oETGjtl4rRz+wCNSte5v2HJixDKRcHPVaHrhfbCEA+2J0UjqSwssWhi0Hsp
         Sa1tEiiZcCio8M8FD1/AfSUB1NjxCwZFJYBt4Q7PjdjXor9AUrKtGoVh6TpceNDl+lz2
         au9WbuhA14JfW+e73Sx3LEe7y26XWx/Z5DfRv1lOPaI2gMZZi+y6H9nMY8C7OkvPaPNv
         6kdw==
X-Gm-Message-State: AAQBX9f4FL02M23sgtx1hFHqZOfmgRlWPsaGgUMofN9PG/gZhsoY+0Jr
        UY4FxC/ZOaejCuk7ic3YYsv7ymZNdA==
X-Google-Smtp-Source: AKy350Y+FFNVhEH8J/xbnSRbbO1WGuy7IynVY3++C2eC62dOzu64tMYXqP0pSiyYkAJ3MP+9jkpkqA==
X-Received: by 2002:a9d:6f90:0:b0:6a4:3c9e:d5a9 with SMTP id h16-20020a9d6f90000000b006a43c9ed5a9mr1142369otq.35.1681830429077;
        Tue, 18 Apr 2023 08:07:09 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id i18-20020a056830011200b006a44d90de05sm4010988otp.69.2023.04.18.08.06.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 08:06:52 -0700 (PDT)
Received: (nullmailer pid 1528776 invoked by uid 1000);
        Tue, 18 Apr 2023 15:06:36 -0000
From:   Rob Herring <robh@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] dt-bindings: net: ethernet: Fix JSON pointer references
Date:   Tue, 18 Apr 2023 10:06:27 -0500
Message-Id: <20230418150628.1528480-1-robh@kernel.org>
X-Mailer: git-send-email 2.39.2
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

A JSON pointer reference (the part after the "#") must start with a "/".
Conversely, references to the entire document must not have a trailing "/"
and should be just a "#". The existing jsonschema package allows these,
but coming changes make allowed "$ref" URIs stricter and throw errors on
these references.

Signed-off-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/net/ethernet-controller.yaml | 2 +-
 Documentation/devicetree/bindings/net/ethernet-switch.yaml     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index 00be387984ac..b7ac69dafbe9 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -205,7 +205,7 @@ properties:
               duplex is assumed.
 
           pause:
-            $ref: /schemas/types.yaml#definitions/flag
+            $ref: /schemas/types.yaml#/definitions/flag
             description:
               Indicates that pause should be enabled.
 
diff --git a/Documentation/devicetree/bindings/net/ethernet-switch.yaml b/Documentation/devicetree/bindings/net/ethernet-switch.yaml
index a04f8ef744aa..3a9bac7b1b98 100644
--- a/Documentation/devicetree/bindings/net/ethernet-switch.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-switch.yaml
@@ -51,7 +51,7 @@ additionalProperties: true
 $defs:
   base:
     description: An ethernet switch without any extra port properties
-    $ref: '#/'
+    $ref: '#'
 
     patternProperties:
       "^(ethernet-)?port@[0-9]+$":
-- 
2.39.2

