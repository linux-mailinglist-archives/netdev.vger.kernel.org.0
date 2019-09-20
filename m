Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1567EB8A93
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 07:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392404AbfITFjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 01:39:03 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:3100 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390510AbfITFjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 01:39:03 -0400
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx08-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8K5ZtCj010154;
        Fri, 20 Sep 2019 07:38:43 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=STMicroelectronics;
 bh=x/LNhVtfhccWnby7ce3HapzzopKDh8uTONbGR64CIfI=;
 b=byWPlN9k23fx4bMu8O6OfpGaDaCZxe32slTjjs5JoP2+1Fsx7/qBylP/Hu+D7wIT8qpj
 IY/2BS07hhtI9utLZ5PpioCr3yjVHT0RDYYpvHiGOE1pLdm7dU/sntkQsDuThbkWlLG1
 W3S4aX+D6FPPUgIb006J5cbUK9VSslRk2uzbMkjDL6Mt3G/Is6I9sQOHIFUUyCiSp+Ho
 CeeewL8VfP/OeBjarwg3IPXl3soCiO3GD/YwR2SrfFOSsptrM+u/nhZYS9DQ8D2NLGfG
 uzpOLXDGITZZKNuvoMk6NSDiQVBfDPJaTGQu1mETn1aVAYd7DUIVd4nsW2djmiyu8qkG qw== 
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
        by mx08-00178001.pphosted.com with ESMTP id 2v3va18qd9-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT);
        Fri, 20 Sep 2019 07:38:43 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id 3379B4C;
        Fri, 20 Sep 2019 05:38:40 +0000 (GMT)
Received: from Webmail-eu.st.com (Safex1hubcas21.st.com [10.75.90.44])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id E09AA2209BE;
        Fri, 20 Sep 2019 07:38:39 +0200 (CEST)
Received: from SAFEX1HUBCAS24.st.com (10.75.90.95) by SAFEX1HUBCAS21.st.com
 (10.75.90.44) with Microsoft SMTP Server (TLS) id 14.3.439.0; Fri, 20 Sep
 2019 07:38:39 +0200
Received: from localhost (10.201.22.222) by webmail-ga.st.com (10.75.90.48)
 with Microsoft SMTP Server (TLS) id 14.3.439.0; Fri, 20 Sep 2019 07:38:39
 +0200
From:   Christophe Roullier <christophe.roullier@st.com>
To:     <robh@kernel.org>, <davem@davemloft.net>, <joabreu@synopsys.com>,
        <mark.rutland@arm.com>, <mcoquelin.stm32@gmail.com>,
        <alexandre.torgue@st.com>, <peppe.cavallaro@st.com>
CC:     <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <christophe.roullier@st.com>, <andrew@lunn.ch>
Subject: [PATCH  5/5] ARM: dts: stm32: Enable gating of the MAC TX clock during TX low-power mode on stm32mp157c
Date:   Fri, 20 Sep 2019 07:38:17 +0200
Message-ID: <20190920053817.13754-6-christophe.roullier@st.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190920053817.13754-1-christophe.roullier@st.com>
References: <20190920053817.13754-1-christophe.roullier@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.201.22.222]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-20_01:2019-09-19,2019-09-20 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When there is no activity on ethernet phy link, the ETH_GTX_CLK is cut

Signed-off-by: Christophe Roullier <christophe.roullier@st.com>
---
 arch/arm/boot/dts/stm32mp157c.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/stm32mp157c.dtsi b/arch/arm/boot/dts/stm32mp157c.dtsi
index f51d6222a0e8..d78dfc44a1fb 100644
--- a/arch/arm/boot/dts/stm32mp157c.dtsi
+++ b/arch/arm/boot/dts/stm32mp157c.dtsi
@@ -1293,6 +1293,7 @@
 			st,syscon = <&syscfg 0x4>;
 			snps,mixed-burst;
 			snps,pbl = <2>;
+			snps,en-tx-lpi-clockgating;
 			snps,axi-config = <&stmmac_axi_config_0>;
 			snps,tso;
 			status = "disabled";
-- 
2.17.1

