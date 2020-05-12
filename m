Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 474341D005B
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 23:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731375AbgELVL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 17:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731320AbgELVLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 17:11:20 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D571C061A0C;
        Tue, 12 May 2020 14:11:20 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id e1so3774122wrt.5;
        Tue, 12 May 2020 14:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/KGQVBeKYkVYbXvdSBspLFigDe6VZAF+Wx8YN9GDcNc=;
        b=LMZNpxE32rk8g0yplUvy4mvxgaadGMPFKXvoJds2A1GV8eft9FrgFGhZRXfQkivZ4l
         7LmM5yOK/Y6PoacpmcdrJCmxmueQlKLUzqEtvpAWg9ASeZEtUi9JPpk+Ni+1+PKYrpxP
         nCa+xG3RCo+xdPw/05n6gX18g70QhUgBDwqt6zNgQlhRbMpf0esPPJai3Tl4PSvzmMWD
         oVbfa+r3D5ysABf0T/td0xVDus7aC2gEujsc6/l/Vihcr9B2C9qwdsKm4Du5ilvPKc3X
         0/+3HTGlA59ZolkeWdQMc//4lDo/phW7a1lvnjQaXrMg5yaL1dvPhQZ61Xb1XuOKo20z
         yLeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/KGQVBeKYkVYbXvdSBspLFigDe6VZAF+Wx8YN9GDcNc=;
        b=ahgsxaoa+ZJsPVmEZh82VBdpndHe778rwtfKFoY0CST21tia2li59RJNLpoShaYGu2
         FEaz3pz+RFu0y6xSA91DpPrfUrlmhkfB0zH+S3tsYfFK9+1UbyInWBOe6jW4QZV8Vn/f
         DoaIrIgZjQ8LKiNYzmdmVqIfRqisCLN+2FaCwK251Yr96FcDL6PcOa7Zxuf1qiBAudGJ
         K4dNkcf06tJb4y7WHn9nKwMkBJcCJazgggtqV06+s/zcabU+bbS5Xk2TwND8vUaoWIjv
         MUGeR7V041+/QFtVv3DTCfqbzD02dgFZ3lsh40pXTxDbFl4nLprkNgRtU4I4Uz1//ToV
         81Sw==
X-Gm-Message-State: AGi0PuaXxtsV9zou5ZwR4ffVu21c1nU2zijBCw0h7qIrl2ODoJmpL4mT
        mlbjE1pegzPbvYH6wtEYQ0E=
X-Google-Smtp-Source: APiQypK7cfT9u0K0wRgKSWfrFo5+g3J3L9kW9wLiJwLr06ncTXRn0nQoT+QRUji8KiEu1VYA8lF92g==
X-Received: by 2002:adf:fac5:: with SMTP id a5mr28720107wrs.210.1589317878732;
        Tue, 12 May 2020 14:11:18 -0700 (PDT)
Received: from localhost.localdomain (p200300F137132E00428D5CFFFEB99DB8.dip0.t-ipconnect.de. [2003:f1:3713:2e00:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id r3sm9724228wmh.48.2020.05.12.14.11.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 14:11:18 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     robh+dt@kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org
Cc:     jianxin.pan@amlogic.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v3 2/8] dt-bindings: net: dwmac-meson: Document the "timing-adjustment" clock
Date:   Tue, 12 May 2020 23:10:57 +0200
Message-Id: <20200512211103.530674-3-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200512211103.530674-1-martin.blumenstingl@googlemail.com>
References: <20200512211103.530674-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PRG_ETHERNET registers can add an RX delay in RGMII mode. This
requires an internal re-timing circuit whose input clock is called
"timing adjustment clock". Document this clock input so the clock can be
enabled as needed.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
Rob, there is a soft dependency for this patch on commit f22531438ff42c
"dt-bindings: net: dwmac: increase 'maxItems' for 'clocks',
'clock-names' properties" which is currently in your dt-next branch.
That commit is needed to make the dt-bindings schema validation pass,
because it increases the maximum number allowed clocks for anything
that extends "snps,dwmac" from three to five (here I need four clocks).


 .../devicetree/bindings/net/amlogic,meson-dwmac.yaml   | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml b/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml
index 66074314e57a..64c20c92c07d 100644
--- a/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml
@@ -40,18 +40,22 @@ allOf:
     then:
       properties:
         clocks:
+          minItems: 3
+          maxItems: 4
           items:
             - description: GMAC main clock
             - description: First parent clock of the internal mux
             - description: Second parent clock of the internal mux
+            - description: The clock which drives the timing adjustment logic
 
         clock-names:
           minItems: 3
-          maxItems: 3
+          maxItems: 4
           items:
             - const: stmmaceth
             - const: clkin0
             - const: clkin1
+            - const: timing-adjustment
 
         amlogic,tx-delay-ns:
           $ref: /schemas/types.yaml#definitions/uint32
@@ -120,7 +124,7 @@ examples:
          reg = <0xc9410000 0x10000>, <0xc8834540 0x8>;
          interrupts = <8>;
          interrupt-names = "macirq";
-         clocks = <&clk_eth>, <&clkc_fclk_div2>, <&clk_mpll2>;
-         clock-names = "stmmaceth", "clkin0", "clkin1";
+         clocks = <&clk_eth>, <&clk_fclk_div2>, <&clk_mpll2>, <&clk_fclk_div2>;
+         clock-names = "stmmaceth", "clkin0", "clkin1", "timing-adjustment";
          phy-mode = "rgmii";
     };
-- 
2.26.2

