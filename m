Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2933A3AC116
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 04:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232041AbhFRC4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 22:56:11 -0400
Received: from mail.loongson.cn ([114.242.206.163]:39818 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231565AbhFRC4J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 22:56:09 -0400
Received: from localhost.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Dxv0CzCsxgVnITAA--.632S3;
        Fri, 18 Jun 2021 10:53:43 +0800 (CST)
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
Subject: [PATCH 2/4] MIPS: Loongson64: Add GMAC support for Loongson-2K1000
Date:   Fri, 18 Jun 2021 10:53:35 +0800
Message-Id: <20210618025337.5705-2-zhangqing@loongson.cn>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210618025337.5705-1-zhangqing@loongson.cn>
References: <20210618025337.5705-1-zhangqing@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf9Dxv0CzCsxgVnITAA--.632S3
X-Coremail-Antispam: 1UD129KBjvJXoW7try7WF4DAry5GF1DAF18Zrb_yoW8AryfpF
        17Aayqkr4rWryIkws8JFWDAF43Aa9YkFna93ZxGr4Ut34vq3Wjvr43tF1fKr13XrW8X34F
        qrWvgry8KF17Jw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUPqb7Iv0xC_Zr1lb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI
        8067AKxVWUGwA2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF
        64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcV
        CY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280
        aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzV
        Aqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUAVWUtwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S
        6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7Mx
        kIecxEwVAFwVW8JwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s02
        6c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw
        0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvE
        c7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14
        v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x
        07j3ManUUUUU=
X-CM-SenderInfo: x2kd0wptlqwqxorr0wxvrqhubq/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The GMAC module is now supported, enable it.

Signed-off-by: Qing Zhang <zhangqing@loongson.cn>
---
 .../boot/dts/loongson/loongson64-2k1000.dtsi  | 46 +++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi b/arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi
index 569e814def83..5747f171de29 100644
--- a/arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi
+++ b/arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi
@@ -114,6 +114,52 @@ pci@1a000000 {
 			ranges = <0x01000000 0x0 0x00000000 0x0 0x18000000  0x0 0x00010000>,
 				 <0x02000000 0x0 0x40000000 0x0 0x40000000  0x0 0x40000000>;
 
+			gmac@3,0 {
+				compatible = "pci0014,7a03.0",
+						   "pci0014,7a03",
+						   "pciclass0c0320",
+						   "pciclass0c03",
+						   "loongson, pci-gmac";
+
+				reg = <0x1800 0x0 0x0 0x0 0x0>;
+				interrupts = <12 IRQ_TYPE_LEVEL_LOW>,
+					     <13 IRQ_TYPE_LEVEL_LOW>;
+				interrupt-names = "macirq", "eth_lpi";
+				interrupt-parent = <&liointc0>;
+				phy-mode = "rgmii";
+				mdio {
+					#address-cells = <1>;
+					#size-cells = <0>;
+					compatible = "snps,dwmac-mdio";
+					phy0: ethernet-phy@0 {
+						reg = <0>;
+					};
+				};
+			};
+
+			gmac@3,1 {
+				compatible = "pci0014,7a03.0",
+						   "pci0014,7a03",
+						   "pciclass0c0320",
+						   "pciclass0c03",
+						   "loongson, pci-gmac";
+
+				reg = <0x1900 0x0 0x0 0x0 0x0>;
+				interrupts = <14 IRQ_TYPE_LEVEL_LOW>,
+					     <15 IRQ_TYPE_LEVEL_LOW>;
+				interrupt-names = "macirq", "eth_lpi";
+				interrupt-parent = <&liointc0>;
+				phy-mode = "rgmii";
+				mdio {
+					#address-cells = <1>;
+					#size-cells = <0>;
+					compatible = "snps,dwmac-mdio";
+					phy1: ethernet-phy@1 {
+						reg = <0>;
+					};
+				};
+			};
+
 			ehci@4,1 {
 				compatible = "pci0014,7a14.0",
 						   "pci0014,7a14",
-- 
2.31.0

