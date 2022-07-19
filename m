Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1798957A96F
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 23:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240650AbiGSVvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 17:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240674AbiGSVvY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 17:51:24 -0400
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D7034BD11;
        Tue, 19 Jul 2022 14:51:22 -0700 (PDT)
Received: by mail-io1-f42.google.com with SMTP id n7so12939325ioo.7;
        Tue, 19 Jul 2022 14:51:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AWpPh2MV8ZydJ1kl3+Cx9007CH/br5IiIihhDoXag0c=;
        b=IRbvy48mXAwqIAJ0lXBj65rxcl0IjM5uNTVycWQEvSL9jkEX50rufFYbMjZv+vQhvK
         iXPE6qcQ4jT3Aw5JrnwpRWfOrJjtEohG4zbO9KU7F+DV+btqWYSuwJUeqZDdn3Je3e6p
         UmGLpktTTlogK8wBNmznYZOHTf3pwT+EGGzmgs4ZDVtUl+3xIXtjDQpNfALziivyaw/V
         8brF5T8B/XBiRpMQXuooMJTibj2n2fGKPe707/B1hwjpPlcaigx11RiiSe89FA4TMA6q
         NyYeeFV3RJDmiawf7JWzHOhgWziUhiIGWyt8HwyPzdE7thxHwpOoRBKldP5gMW6nyfAI
         zn7g==
X-Gm-Message-State: AJIora8yVyvzctl5gQIlaIXo7rVE7irFOdDc58bdm/AKq8JeaXLeZ/om
        +7QbnKx1gvVdsuC0tb5FYg==
X-Google-Smtp-Source: AGRyM1tr4VZoFaawfO4qy1VHhBBZHGW3jSSkTnSb10U7jc3AEbSUdqYGiiBEpq9Bx2EclHX3xZwMEw==
X-Received: by 2002:a6b:5d09:0:b0:67b:d670:8813 with SMTP id r9-20020a6b5d09000000b0067bd6708813mr12053359iob.10.1658267481324;
        Tue, 19 Jul 2022 14:51:21 -0700 (PDT)
Received: from xps15.herring.priv ([64.188.179.248])
        by smtp.googlemail.com with ESMTPSA id h10-20020a02c72a000000b00339dfb793aesm7115897jao.86.2022.07.19.14.51.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 14:51:21 -0700 (PDT)
From:   Rob Herring <robh@kernel.org>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] dt-bindings: net: fsl,fec: Add missing types to phy-reset-* properties
Date:   Tue, 19 Jul 2022 15:51:08 -0600
Message-Id: <20220719215109.1876788-1-robh@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The phy-reset-* properties are missing type definitions and are not common
properties. Even though they are deprecated, a type is needed.

Signed-off-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/net/fsl,fec.yaml | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/fsl,fec.yaml b/Documentation/devicetree/bindings/net/fsl,fec.yaml
index daa2f79a294f..1b1853062cd3 100644
--- a/Documentation/devicetree/bindings/net/fsl,fec.yaml
+++ b/Documentation/devicetree/bindings/net/fsl,fec.yaml
@@ -183,6 +183,7 @@ properties:
       Should specify the gpio for phy reset.
 
   phy-reset-duration:
+    $ref: /schemas/types.yaml#/definitions/uint32
     deprecated: true
     description:
       Reset duration in milliseconds.  Should present only if property
@@ -191,12 +192,14 @@ properties:
       and 1 millisecond will be used instead.
 
   phy-reset-active-high:
+    type: boolean
     deprecated: true
     description:
       If present then the reset sequence using the GPIO specified in the
       "phy-reset-gpios" property is reversed (H=reset state, L=operation state).
 
   phy-reset-post-delay:
+    $ref: /schemas/types.yaml#/definitions/uint32
     deprecated: true
     description:
       Post reset delay in milliseconds. If present then a delay of phy-reset-post-delay
-- 
2.34.1

