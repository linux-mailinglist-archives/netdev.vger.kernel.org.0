Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9AF692DC4
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 04:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbjBKDTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 22:19:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbjBKDT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 22:19:28 -0500
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E09A885B2F;
        Fri, 10 Feb 2023 19:19:02 -0800 (PST)
Received: from localhost (unknown [86.120.32.152])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: cristicc)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 80E466602127;
        Sat, 11 Feb 2023 03:19:01 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1676085541;
        bh=XW8rElFUTfgsJr1jtp6+bs1URQt5kqLzyalOrXtwnI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QRSffU9SmuyvwYAm+UPE3h0oUhI+XYMgdzYG7GG38kA0e0174udJj1lzuUqTkTAW5
         jJqKpWZ512dZgilIhNYQiB72no9UdbhJKRDCSU+ckWSBhW0NyvxAjkvC/8C0qyxK8e
         LFdZngHPm/fTyHwN8rONF8yB2RvwxPnTtwxTtIX0QoVsGCCr0dbtGF72hVIEcMJBlg
         83PRBJ822Q2NEowQn1EwN4+L4YRQG/ZPxscIT5XhGFC3xtO28HnnVxnIF++/evL3/Q
         lh9cxBQYChoB2YQUfa+g1a6o/IwTo8CgvVaThXXaQszH7k4cp8oHKUD7aRoofocVQi
         egZmlE6B9+bnw==
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
Subject: [PATCH 10/12] riscv: dts: starfive: jh7100: Add ccache DT node
Date:   Sat, 11 Feb 2023 05:18:19 +0200
Message-Id: <20230211031821.976408-11-cristian.ciocaltea@collabora.com>
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

Provide a DT node for the Sifive Composable Cache controller found on
the StarFive JH7100 SoC.

Note this is also used to support non-coherent DMA.

Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
---
 arch/riscv/boot/dts/starfive/jh7100.dtsi | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/riscv/boot/dts/starfive/jh7100.dtsi b/arch/riscv/boot/dts/starfive/jh7100.dtsi
index 7109e70fdab8..88f91bc5753b 100644
--- a/arch/riscv/boot/dts/starfive/jh7100.dtsi
+++ b/arch/riscv/boot/dts/starfive/jh7100.dtsi
@@ -32,6 +32,7 @@ U74_0: cpu@0 {
 			i-tlb-sets = <1>;
 			i-tlb-size = <32>;
 			mmu-type = "riscv,sv39";
+			next-level-cache = <&ccache>;
 			riscv,isa = "rv64imafdc";
 			tlb-split;
 
@@ -57,6 +58,7 @@ U74_1: cpu@1 {
 			i-tlb-sets = <1>;
 			i-tlb-size = <32>;
 			mmu-type = "riscv,sv39";
+			next-level-cache = <&ccache>;
 			riscv,isa = "rv64imafdc";
 			tlb-split;
 
@@ -116,6 +118,20 @@ soc {
 		ranges;
 		dma-noncoherent;
 
+		ccache: cache-controller@2010000 {
+			compatible = "starfive,jh7100-ccache", "cache";
+			reg = <0x0 0x2010000 0x0 0x1000>,
+			      <0x0 0x8000000 0x0 0x2000000>;
+			reg-names = "control", "sideband";
+			interrupts = <128>, <130>, <131>, <129>;
+			cache-block-size = <64>;
+			cache-level = <2>;
+			cache-sets = <2048>;
+			cache-size = <2097152>;
+			cache-unified;
+			uncached-offset = <0xf 0x80000000>;
+		};
+
 		clint: clint@2000000 {
 			compatible = "starfive,jh7100-clint", "sifive,clint0";
 			reg = <0x0 0x2000000 0x0 0x10000>;
-- 
2.39.1

