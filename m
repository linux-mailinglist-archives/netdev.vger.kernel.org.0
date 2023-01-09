Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C606966259B
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 13:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237148AbjAIMaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 07:30:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237269AbjAIMaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 07:30:25 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56E11BE94;
        Mon,  9 Jan 2023 04:30:22 -0800 (PST)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 883EB127C;
        Mon,  9 Jan 2023 13:30:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1673267420;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2k0VUgvl/cd0SNCrte7LIJhV9pJzMXyCEPZG6Vz+Pqc=;
        b=P9jezsvsSJyYDRaBaSIN5g7AuKjbzi7Zg0Q/aK5xWSVPa9F7C+HOSBwaF/ASL8HKfmhLTC
        FPLkzAjxlLXM6rdBmrR6uuag4xrqllLtEkc4JW5UKbReMiCj+XtsoCGe1qYDaKG5q5tn+5
        TLOJW/zGFxA/myVG/sgBrRRcr6vM1v7NLV7v5/+0meNOqF5CakTWscGSmpHvCQyTOPKzE6
        qv/ydvzQXgE1qXHV8k5jY7XIbMMnmhvWvm3cvZs0mry1pyrHGVeBYVs0sdmii3eZK+x7s1
        7arCnpFPpcxNH5UUaH0mag+ylgTheByuIHjgZZn9sufIFFL5Lv5mp9PtkX5qPA==
From:   Michael Walle <michael@walle.cc>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Xu Liang <lxu@maxlinear.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH net-next v3 1/4] dt-bindings: vendor-prefixes: add MaxLinear
Date:   Mon,  9 Jan 2023 13:30:10 +0100
Message-Id: <20230109123013.3094144-2-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230109123013.3094144-1-michael@walle.cc>
References: <20230109123013.3094144-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MaxLinear is a manufacturer of integrated circuits.
https://www.maxlinear.com

Signed-off-by: Michael Walle <michael@walle.cc>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 66bf0da6f60e..60ca96163937 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -777,6 +777,8 @@ patternProperties:
     description: MaxBotix Inc.
   "^maxim,.*":
     description: Maxim Integrated Products
+  "^maxlinear,.*":
+    description: MaxLinear Inc.
   "^mbvl,.*":
     description: Mobiveil Inc.
   "^mcube,.*":
-- 
2.30.2

