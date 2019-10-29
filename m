Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02A37E854C
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 11:15:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730863AbfJ2KPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 06:15:35 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:11888 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728462AbfJ2KPO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 06:15:14 -0400
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx08-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9TACYJN029426;
        Tue, 29 Oct 2019 11:14:56 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=STMicroelectronics;
 bh=eYmZ2Srd9H2L7hFvuLXNpr6vrpdQO7tHOqgIIEXDPpo=;
 b=qxH5/T6DNVZMiiAsbCDSyvz/1YE2wStUxsoTMu8TQiIfOIRnMQjNOgMr/tUOUn+wo/k0
 jadkeGsukO0Ow+GdlLr4AGWQDMDWCdsBBMk+L6FGWeOkVEgKk3ZAyW7l8jGMVcym9L/2
 /riPmRaD/u0qp3/ADi1xoKicka6QaDAI4qnhEJTC5j5O4k1wJqVUMYo38EHx1zVrMYaM
 n5RxJp1X4cIUOb1m83RdutKfoct2R63mfZ3QMK+zRiukzJeMMQVjeMOF7wTsQ9s3ir0h
 7no2/8bc8v89tr0z/MqOYBl1O7qAwKpLvxAkNdJzhpod5VTat+cNgqRMAgLE/63Ql0dv tA== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx08-00178001.pphosted.com with ESMTP id 2vvb98f4ay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Oct 2019 11:14:56 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id D6B4310002A;
        Tue, 29 Oct 2019 11:14:54 +0100 (CET)
Received: from Webmail-eu.st.com (Safex1hubcas21.st.com [10.75.90.44])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id C89262B28DA;
        Tue, 29 Oct 2019 11:14:54 +0100 (CET)
Received: from SAFEX1HUBCAS22.st.com (10.75.90.93) by SAFEX1HUBCAS21.st.com
 (10.75.90.44) with Microsoft SMTP Server (TLS) id 14.3.439.0; Tue, 29 Oct
 2019 11:14:54 +0100
Received: from localhost (10.201.22.222) by Webmail-ga.st.com (10.75.90.48)
 with Microsoft SMTP Server (TLS) id 14.3.439.0; Tue, 29 Oct 2019 11:14:54
 +0100
From:   Christophe Roullier <christophe.roullier@st.com>
To:     <robh@kernel.org>, <davem@davemloft.net>, <joabreu@synopsys.com>,
        <mark.rutland@arm.com>, <mcoquelin.stm32@gmail.com>,
        <alexandre.torgue@st.com>, <peppe.cavallaro@st.com>
CC:     <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <christophe.roullier@st.com>, <andrew@lunn.ch>
Subject: [net: ethernet: stmmac: some fixes and optimizations 4/5] ARM: dts: stm32: adjust slew rate for Ethernet
Date:   Tue, 29 Oct 2019 11:14:40 +0100
Message-ID: <20191029101441.17290-5-christophe.roullier@st.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191029101441.17290-1-christophe.roullier@st.com>
References: <20191029101441.17290-1-christophe.roullier@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.201.22.222]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-29_03:2019-10-28,2019-10-29 signatures=0
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
index e4a0d51ec3a8..79566d4fb9fc 100644
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

