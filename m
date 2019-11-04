Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D02BCEE10C
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 14:26:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729156AbfKDNZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 08:25:55 -0500
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:16672 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727332AbfKDNZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 08:25:55 -0500
Received: from pps.filterd (m0046037.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA4DNkCs019967;
        Mon, 4 Nov 2019 14:25:39 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=STMicroelectronics;
 bh=JfReHPEwmniYq2zeeS3NIy67VOB8iS3FpX0DY0LvKxk=;
 b=pR6yuwmZed5bN3/slSACQCzTGIkRJ2rcf9w7w9E4PECt5rlwrV5dAn1gwdtZGCzUo9iM
 ou4qITqKxLKH8DO/ygs/RxfwzVf0JqYGWwcdeDMTWb+hyXTJm+h5ZjfSGCa5NCLY/Qn7
 NZtENrC/ypM98hnZwKA9rIOVTF14yNV+bk7sPPXCN6iHrVYv4nE4lNOCdzPBlOwYpOeO
 tGNu8DQ1Pro22O02kwNq950Krlqjv+KOPIvmcSBTMC5ches3zoIz5j9e0BLZPJviwyX7
 KECpY3cTyvli4D3a47pLFZBInfGgZSvAl9NkZlTAhn2twLdeLP/wxDYRpRl0bF7eFiLB FA== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 2w10f19jxy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Nov 2019 14:25:39 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id CD01D10002A;
        Mon,  4 Nov 2019 14:25:38 +0100 (CET)
Received: from Webmail-eu.st.com (Safex1hubcas22.st.com [10.75.90.92])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id BFBAF2BFC79;
        Mon,  4 Nov 2019 14:25:38 +0100 (CET)
Received: from SAFEX1HUBCAS21.st.com (10.75.90.45) by Safex1hubcas22.st.com
 (10.75.90.92) with Microsoft SMTP Server (TLS) id 14.3.439.0; Mon, 4 Nov 2019
 14:25:38 +0100
Received: from localhost (10.201.22.222) by Webmail-ga.st.com (10.75.90.48)
 with Microsoft SMTP Server (TLS) id 14.3.439.0; Mon, 4 Nov 2019 14:25:37
 +0100
From:   Christophe Roullier <christophe.roullier@st.com>
To:     <robh@kernel.org>, <davem@davemloft.net>, <joabreu@synopsys.com>,
        <mark.rutland@arm.com>, <mcoquelin.stm32@gmail.com>,
        <alexandre.torgue@st.com>, <peppe.cavallaro@st.com>
CC:     <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <christophe.roullier@st.com>, <andrew@lunn.ch>
Subject: [PATCH net-next 2/4] ARM: dts: stm32: remove syscfg clock on stm32mp157c ethernet
Date:   Mon, 4 Nov 2019 14:25:31 +0100
Message-ID: <20191104132533.5153-3-christophe.roullier@st.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191104132533.5153-1-christophe.roullier@st.com>
References: <20191104132533.5153-1-christophe.roullier@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.201.22.222]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-11-04_08:2019-11-04,2019-11-04 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syscfg is now activated automatically when syscfg registers are used

Signed-off-by: Christophe Roullier <christophe.roullier@st.com>
---
 arch/arm/boot/dts/stm32mp157c.dtsi | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/stm32mp157c.dtsi b/arch/arm/boot/dts/stm32mp157c.dtsi
index 9b11654a0a39..f13c2348d130 100644
--- a/arch/arm/boot/dts/stm32mp157c.dtsi
+++ b/arch/arm/boot/dts/stm32mp157c.dtsi
@@ -1326,13 +1326,11 @@
 			clock-names = "stmmaceth",
 				      "mac-clk-tx",
 				      "mac-clk-rx",
-				      "ethstp",
-				      "syscfg-clk";
+				      "ethstp";
 			clocks = <&rcc ETHMAC>,
 				 <&rcc ETHTX>,
 				 <&rcc ETHRX>,
-				 <&rcc ETHSTP>,
-				 <&rcc SYSCFG>;
+				 <&rcc ETHSTP>;
 			st,syscon = <&syscfg 0x4>;
 			snps,mixed-burst;
 			snps,pbl = <2>;
-- 
2.17.1

