Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 278E5F1388
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 11:12:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731535AbfKFKMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 05:12:46 -0500
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:29136 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728097AbfKFKMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 05:12:46 -0500
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx08-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA6AC8IP022174;
        Wed, 6 Nov 2019 11:12:30 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=STMicroelectronics;
 bh=CODhr+HDgZkmDdBSbE1YP8Qun5G0drMcjRcuyYv9BoA=;
 b=dqpatyoC2T5bmvP/IaOJIRxLSQJWMbEjYv3SR6Ji9+MfTwpPOtBS1xczFLz/hL0NEKaF
 n8RLd+3h1hn17gXR1WAAmkkfjQS1FPEeZhcnFa7xsY9QoKAMOIWs9AmPqyDWxVNMG4mg
 06U8G9YbapA6iZh6uHEBbzKhLScFEj2VP448y0YSHtX/tzewmq85n7cP/KDMJlmkdfaW
 yGQAiHMjtRW22R0fbkp/rTExCUMOeJZr6u/uBmsH+T+dzisP11yR+TzkhiMC8LQX5Tr6
 L1eJeKgHIVyBie2mmX/9zdyeo2KgWUTkJbGjrJLNFGVkXe1KL4yXSpncgqlmpP4chYS0 wQ== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx08-00178001.pphosted.com with ESMTP id 2w0ytcwf37-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Nov 2019 11:12:30 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 8170B10003D;
        Wed,  6 Nov 2019 11:12:26 +0100 (CET)
Received: from Webmail-eu.st.com (Safex1hubcas24.st.com [10.75.90.94])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 69AA72AD343;
        Wed,  6 Nov 2019 11:12:26 +0100 (CET)
Received: from SAFEX1HUBCAS21.st.com (10.75.90.45) by Safex1hubcas24.st.com
 (10.75.90.94) with Microsoft SMTP Server (TLS) id 14.3.439.0; Wed, 6 Nov 2019
 11:12:26 +0100
Received: from localhost (10.201.22.222) by Webmail-ga.st.com (10.75.90.48)
 with Microsoft SMTP Server (TLS) id 14.3.439.0; Wed, 6 Nov 2019 11:12:25
 +0100
From:   Christophe Roullier <christophe.roullier@st.com>
To:     <robh@kernel.org>, <davem@davemloft.net>, <joabreu@synopsys.com>,
        <mark.rutland@arm.com>, <mcoquelin.stm32@gmail.com>,
        <alexandre.torgue@st.com>, <peppe.cavallaro@st.com>
CC:     <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <christophe.roullier@st.com>, <andrew@lunn.ch>
Subject: [PATCH V3 net-next 3/4] ARM: dts: stm32: adjust slew rate for Ethernet
Date:   Wed, 6 Nov 2019 11:12:19 +0100
Message-ID: <20191106101220.12693-4-christophe.roullier@st.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191106101220.12693-1-christophe.roullier@st.com>
References: <20191106101220.12693-1-christophe.roullier@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.201.22.222]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-06_02:2019-11-06,2019-11-06 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ETH_MDIO slew-rate should be set to "0" instead of "2"

Signed-off-by: Christophe Roullier <christophe.roullier@st.com>
---
 arch/arm/boot/dts/stm32mp157-pinctrl.dtsi | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/stm32mp157-pinctrl.dtsi b/arch/arm/boot/dts/stm32mp157-pinctrl.dtsi
index 0a3a7d66737b..9a8f0d4c9ea3 100644
--- a/arch/arm/boot/dts/stm32mp157-pinctrl.dtsi
+++ b/arch/arm/boot/dts/stm32mp157-pinctrl.dtsi
@@ -217,13 +217,18 @@
 						 <STM32_PINMUX('C', 2, AF11)>, /* ETH_RGMII_TXD2 */
 						 <STM32_PINMUX('E', 2, AF11)>, /* ETH_RGMII_TXD3 */
 						 <STM32_PINMUX('B', 11, AF11)>, /* ETH_RGMII_TX_CTL */
-						 <STM32_PINMUX('A', 2, AF11)>, /* ETH_MDIO */
 						 <STM32_PINMUX('C', 1, AF11)>; /* ETH_MDC */
 					bias-disable;
 					drive-push-pull;
-					slew-rate = <3>;
+					slew-rate = <2>;
 				};
 				pins2 {
+					pinmux = <STM32_PINMUX('A', 2, AF11)>; /* ETH_MDIO */
+					bias-disable;
+					drive-push-pull;
+					slew-rate = <0>;
+				};
+				pins3 {
 					pinmux = <STM32_PINMUX('C', 4, AF11)>, /* ETH_RGMII_RXD0 */
 						 <STM32_PINMUX('C', 5, AF11)>, /* ETH_RGMII_RXD1 */
 						 <STM32_PINMUX('B', 0, AF11)>, /* ETH_RGMII_RXD2 */
-- 
2.17.1

