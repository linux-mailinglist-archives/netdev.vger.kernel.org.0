Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB2B719336E
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 23:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727606AbgCYWFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 18:05:52 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:44182 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727485AbgCYWFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 18:05:49 -0400
Received: by mail-io1-f67.google.com with SMTP id v3so3947013iot.11;
        Wed, 25 Mar 2020 15:05:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AwF7FEOUbNvNk4mSehe5GSFcN0+uDrOJWlHbrUm2jl4=;
        b=pxv7G0herYnThW09pyD7DYp4RI8JVvu7jYaN33KTOuLgkNv+3/nMj0yJ5veHQCt39N
         oDt7O7mDwcObu8qZy6LIVkkkc98wzRAwclrDNQ0e1bqwWdaYKs6iJMb8tIhBXX+D9BeI
         J2r2cmU5dIxAAU+eq3tlPrW3Y31VbwcF5MDwOUeZc4Th/RyWXQSSYlJYUajbxNOwoNIh
         G4xolGeHUDw9cXUOZ0FQsV1XIhx4zXdwXsHEHKJv+yUPe3PTTkyCVZd7rM/jPw68Pq4X
         9Urp2XjESJfCe7EHqB97Yfo+LysGH/euyVK9k1cGPiHcF9Ze2VZP+ShSkNaE5WOfhIlo
         D4aQ==
X-Gm-Message-State: ANhLgQ3QQ76rZ5PNb2Rue3g92sfGo/nu+Ag6kvksZtiOPKWlZXGBnviL
        +mUCAeUwUoaJI40ikJuL5H2wBig=
X-Google-Smtp-Source: ADFU+vsP1GIXWhv3Nn2746MnQvCz0PBygUKBaoaDtLTv4UJllArEZXEuLW2CGMWNrRni/irdN7azAg==
X-Received: by 2002:a5e:8214:: with SMTP id l20mr5055871iom.54.1585173948584;
        Wed, 25 Mar 2020 15:05:48 -0700 (PDT)
Received: from xps15.herring.priv ([64.188.179.250])
        by smtp.googlemail.com with ESMTPSA id v8sm102390ioh.40.2020.03.25.15.05.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 15:05:48 -0700 (PDT)
From:   Rob Herring <robh@kernel.org>
To:     devicetree@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Brian Masney <masneyb@onstation.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Guillaume La Roque <glaroque@baylibre.com>,
        Hartmut Knaack <knaack.h@gmx.de>,
        Jonathan Cameron <jic23@kernel.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        Stephen Boyd <sboyd@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Zhang Rui <rui.zhang@intel.com>,
        dri-devel@lists.freedesktop.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-media@vger.kernel.org, linux-pm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 2/4] dt-bindings: sram: qcom: Clean-up 'ranges' and child node names
Date:   Wed, 25 Mar 2020 16:05:39 -0600
Message-Id: <20200325220542.19189-3-robh@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200325220542.19189-1-robh@kernel.org>
References: <20200325220542.19189-1-robh@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The regex for child nodes doesn't match the example. This wasn't flagged
with 'additionalProperties: false' missing. The child node schema was also
incorrect with 'ranges' property as it applies to child nodes and should
be moved up to the parent node.

Fixes: 957fd69d396b ("dt-bindings: soc: qcom: add On Chip MEMory (OCMEM) bindings")
Cc: Brian Masney <masneyb@onstation.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: linux-arm-msm@vger.kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
---
 .../devicetree/bindings/sram/qcom,ocmem.yaml         | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/sram/qcom,ocmem.yaml b/Documentation/devicetree/bindings/sram/qcom,ocmem.yaml
index 222990f9923c..469cec133647 100644
--- a/Documentation/devicetree/bindings/sram/qcom,ocmem.yaml
+++ b/Documentation/devicetree/bindings/sram/qcom,ocmem.yaml
@@ -43,6 +43,9 @@ properties:
   '#size-cells':
     const: 1
 
+  ranges:
+    maxItems: 1
+
 required:
   - compatible
   - reg
@@ -51,9 +54,10 @@ required:
   - clock-names
   - '#address-cells'
   - '#size-cells'
+  - ranges
 
 patternProperties:
-  "^.+-sram$":
+  "-sram@[0-9a-f]+$":
     type: object
     description: A region of reserved memory.
 
@@ -61,12 +65,8 @@ patternProperties:
       reg:
         maxItems: 1
 
-      ranges:
-        maxItems: 1
-
     required:
       - reg
-      - ranges
 
 examples:
   - |
@@ -88,9 +88,9 @@ examples:
 
         #address-cells = <1>;
         #size-cells = <1>;
+        ranges = <0 0xfec00000 0x100000>;
 
         gmu-sram@0 {
                 reg = <0x0 0x100000>;
-                ranges = <0 0 0xfec00000 0x100000>;
         };
       };
-- 
2.20.1

