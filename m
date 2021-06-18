Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 375813AC113
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 04:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231654AbhFRC4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 22:56:09 -0400
Received: from mail.loongson.cn ([114.242.206.163]:39824 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231651AbhFRC4I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 22:56:08 -0400
Received: from localhost.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Dxv0CzCsxgVnITAA--.632S5;
        Fri, 18 Jun 2021 10:53:47 +0800 (CST)
From:   Qing Zhang <zhangqing@loongson.cn>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Huacai Chen <chenhc@lemote.com>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 4/4] dt-bindings: dwmac: Add bindings for new Loongson SoC and bridge chip
Date:   Fri, 18 Jun 2021 10:53:37 +0800
Message-Id: <20210618025337.5705-4-zhangqing@loongson.cn>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210618025337.5705-1-zhangqing@loongson.cn>
References: <20210618025337.5705-1-zhangqing@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf9Dxv0CzCsxgVnITAA--.632S5
X-Coremail-Antispam: 1UD129KBjvJXoW7WrWktry3Ar1UZrWrJrW3trb_yoW8JF4xpr
        sxCFn3Kr1FyF47Zwn5tF1rCrW7Xr95Jr4xJFs7t3WIqF1kJa1vgw4Fgws8JFW5ur4xZFW2
        vryS9F4YgFy0kw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUPvb7Iv0xC_Cr1lb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI
        8067AKxVWUWwA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF
        64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcV
        CY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280
        aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzV
        Aqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUAVWUtwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S
        6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7Mx
        kIecxEwVAFwVW8JwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s02
        6c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw
        0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvE
        c7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67
        AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuY
        vjxUcYiiDUUUU
X-CM-SenderInfo: x2kd0wptlqwqxorr0wxvrqhubq/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the dwmac bindings for the Loongson-2K SoC and the LS7A
bridge chip.

Signed-off-by: Qing Zhang <zhangqing@loongson.cn>
---
 Documentation/devicetree/bindings/net/snps,dwmac.yaml | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index 2edd8bea993e..9631bbbb6f69 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -56,6 +56,8 @@ properties:
         - amlogic,meson8m2-dwmac
         - amlogic,meson-gxbb-dwmac
         - amlogic,meson-axg-dwmac
+        - loongson,ls2k-dwmac
+        - loongson,ls7a-dwmac
         - rockchip,px30-gmac
         - rockchip,rk3128-gmac
         - rockchip,rk3228-gmac
@@ -310,6 +312,8 @@ allOf:
               - allwinner,sun8i-r40-emac
               - allwinner,sun8i-v3s-emac
               - allwinner,sun50i-a64-emac
+              - loongson,ls2k-dwmac
+              - loongson,ls7a-dwmac
               - snps,dwxgmac
               - snps,dwxgmac-2.10
               - st,spear600-gmac
@@ -353,6 +357,8 @@ allOf:
               - allwinner,sun8i-r40-emac
               - allwinner,sun8i-v3s-emac
               - allwinner,sun50i-a64-emac
+              - loongson,ls2k-dwmac
+              - loongson,ls7a-dwmac
               - snps,dwmac-4.00
               - snps,dwmac-4.10a
               - snps,dwmac-4.20a
-- 
2.31.0

