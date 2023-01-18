Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD2C767142B
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 07:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbjARGbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 01:31:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbjARG10 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 01:27:26 -0500
Received: from fd01.gateway.ufhost.com (fd01.gateway.ufhost.com [61.152.239.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC7539296;
        Tue, 17 Jan 2023 22:17:11 -0800 (PST)
Received: from EXMBX166.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX166", Issuer "EXMBX166" (not verified))
        by fd01.gateway.ufhost.com (Postfix) with ESMTP id 7071624E171;
        Wed, 18 Jan 2023 14:17:10 +0800 (CST)
Received: from EXMBX073.cuchost.com (172.16.6.83) by EXMBX166.cuchost.com
 (172.16.6.76) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 18 Jan
 2023 14:17:10 +0800
Received: from wyh-VirtualBox.starfivetech.com (171.223.208.138) by
 EXMBX073.cuchost.com (172.16.6.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.42; Wed, 18 Jan 2023 14:17:09 +0800
From:   Yanhong Wang <yanhong.wang@starfivetech.com>
To:     <linux-riscv@lists.infradead.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>
Subject: [PATCH v4 7/7] riscv: dts: starfive: visionfive-v2: Enable gmac device tree node
Date:   Wed, 18 Jan 2023 14:17:01 +0800
Message-ID: <20230118061701.30047-8-yanhong.wang@starfivetech.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230118061701.30047-1-yanhong.wang@starfivetech.com>
References: <20230118061701.30047-1-yanhong.wang@starfivetech.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS066.cuchost.com (172.16.6.26) To EXMBX073.cuchost.com
 (172.16.6.83)
X-YovoleRuleAgent: yovoleflag
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update gmac device tree node status to okay.

Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
---
 .../dts/starfive/jh7110-starfive-visionfive-v2.dts     | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-v2.dts b/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-v2.dts
index c8946cf3a268..b22363d5f9dc 100644
--- a/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-v2.dts
+++ b/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-v2.dts
@@ -15,6 +15,8 @@
 
 	aliases {
 		serial0 = &uart0;
+		ethernet0 = &gmac0;
+		ethernet1 = &gmac1;
 	};
 
 	chosen {
@@ -114,3 +116,11 @@
 	pinctrl-0 = <&uart0_pins>;
 	status = "okay";
 };
+
+&gmac0 {
+	status = "okay";
+};
+
+&gmac1 {
+	status = "okay";
+};
-- 
2.17.1

