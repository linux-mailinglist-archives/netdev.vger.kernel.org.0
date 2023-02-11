Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0625C692DC7
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 04:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbjBKDT5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 22:19:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbjBKDTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 22:19:38 -0500
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19BBDBDD8;
        Fri, 10 Feb 2023 19:19:06 -0800 (PST)
Received: from localhost (unknown [86.120.32.152])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: cristicc)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id B15676602112;
        Sat, 11 Feb 2023 03:19:04 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1676085544;
        bh=giBLXfHgd+nXmXgHpm08kBXy7O346waFR5TnsQQNUJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c4QNRDT72f7rGgDkbpsH5cio8u1cyWic15TpkDUfoubuBgE5U6mjkH2uwqQJsEuck
         /zvq5XfWc3sECoa1uHGMUfMgw5BxNfXqKQVL9+J0nimoYf58szUQrILkSxUDqvtW08
         B2ovKjfoji0bZP+v2SsEywo2OiyB+wXv29mrqZVM2DBeRaC/YLhDUkP+F15oQPq5fh
         ch5CR2oIk/P8nfnsHGCF+yyvyg+j/E1hpz/o2U5lJkRK1Mkts/8dfttRgJ1kTqVGxL
         yZeCyn8WW4dI2kWbdLtXmggsRq7SKHm2GLZ0HacPogzx/P3o3jfS4w7S2JwSAe/fGz
         NwN72WtsW7yTw==
From:   Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
To:     Lee Jones <lee@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Conor Dooley <conor@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Sagar Kadam <sagar.kadam@sifive.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, kernel@collabora.com
Subject: [PATCH 11/12] riscv: dts: starfive: jh7100: Add sysmain and gmac DT nodes
Date:   Sat, 11 Feb 2023 05:18:20 +0200
Message-Id: <20230211031821.976408-12-cristian.ciocaltea@collabora.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230211031821.976408-1-cristian.ciocaltea@collabora.com>
References: <20230211031821.976408-1-cristian.ciocaltea@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide the sysmain and gmac DT nodes supporting the DWMAC found on the
StarFive JH7100 SoC.

Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
---
 arch/riscv/boot/dts/starfive/jh7100.dtsi | 38 ++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/arch/riscv/boot/dts/starfive/jh7100.dtsi b/arch/riscv/boot/dts/starfive/jh7100.dtsi
index 88f91bc5753b..0918af7b6eb0 100644
--- a/arch/riscv/boot/dts/starfive/jh7100.dtsi
+++ b/arch/riscv/boot/dts/starfive/jh7100.dtsi
@@ -164,6 +164,44 @@ rstgen: reset-controller@11840000 {
 			#reset-cells = <1>;
 		};
 
+		sysmain: syscon@11850000 {
+			compatible = "starfive,jh7100-sysmain", "syscon";
+			reg = <0x0 0x11850000 0x0 0x10000>;
+		};
+
+		gmac: ethernet@10020000 {
+			compatible = "starfive,jh7100-dwmac", "snps,dwmac";
+			reg = <0x0 0x10020000 0x0 0x10000>;
+			clocks = <&clkgen JH7100_CLK_GMAC_ROOT_DIV>,
+				 <&clkgen JH7100_CLK_GMAC_AHB>,
+				 <&clkgen JH7100_CLK_GMAC_PTP_REF>,
+				 <&clkgen JH7100_CLK_GMAC_GTX>,
+				 <&clkgen JH7100_CLK_GMAC_TX_INV>;
+			clock-names = "stmmaceth", "pclk", "ptp_ref", "gtxc", "tx";
+			resets = <&rstgen JH7100_RSTN_GMAC_AHB>;
+			reset-names = "ahb";
+			interrupts = <6>, <7>;
+			interrupt-names = "macirq", "eth_wake_irq";
+			max-frame-size = <9000>;
+			phy-mode = "rgmii-txid";
+			snps,multicast-filter-bins = <32>;
+			snps,perfect-filter-entries = <128>;
+			starfive,syscon = <&sysmain>;
+			rx-fifo-depth = <32768>;
+			tx-fifo-depth = <16384>;
+			snps,axi-config = <&stmmac_axi_setup>;
+			snps,fixed-burst;
+			snps,force_thresh_dma_mode;
+			snps,no-pbl-x8;
+			status = "disabled";
+
+			stmmac_axi_setup: stmmac-axi-config {
+				snps,wr_osr_lmt = <0xf>;
+				snps,rd_osr_lmt = <0xf>;
+				snps,blen = <256 128 64 32 0 0 0>;
+			};
+		};
+
 		i2c0: i2c@118b0000 {
 			compatible = "snps,designware-i2c";
 			reg = <0x0 0x118b0000 0x0 0x10000>;
-- 
2.39.1

