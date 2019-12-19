Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ABFD12642C
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 15:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfLSOCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 09:02:43 -0500
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:29174 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726744AbfLSOCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 09:02:42 -0500
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx08-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBJDgbJo030197;
        Thu, 19 Dec 2019 15:02:31 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=STMicroelectronics;
 bh=lmYBkuR7hu/iO85iNxJiScrX1QW68m2Wp1jYoIywx+U=;
 b=GGKi5DLB7NESlB2r6cTCXbIuYTJ0jr85Am2eS6uqGs+aci2NBMZq3aN55KXOanmI5H8q
 QIlnS9qMb18zfmyp3USNnCPnxL/nSIZZjDft96pV9B895xKT4N6zSFoDh513fA7poNPk
 TNx0cn9F8k6s6hNT9gfeR2L72PRSAQB6PWK/ayaTjb1LtHEOv9C32ub6WLh+MMO2goE3
 fnTynm/avWiw6UjfBp5G4vt4WHxaKg+4yVOGKdo/nsjRFd4cSUPcctwV50HtORjEmUIa
 0gArsbFGuPPVzfVdmthjLe5l5Vn8prFMuFiqvW8AI7xibU/ueI7KxnMJa1wX55AQohFE HQ== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx08-00178001.pphosted.com with ESMTP id 2wvnret2vp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Dec 2019 15:02:31 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 6A9AB10002A;
        Thu, 19 Dec 2019 15:02:28 +0100 (CET)
Received: from Webmail-eu.st.com (sfhdag3node3.st.com [10.75.127.9])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 52C332C38BE;
        Thu, 19 Dec 2019 15:02:28 +0100 (CET)
Received: from localhost (10.75.127.47) by SFHDAG3NODE3.st.com (10.75.127.9)
 with Microsoft SMTP Server (TLS) id 15.0.1347.2; Thu, 19 Dec 2019 15:02:28
 +0100
From:   Benjamin Gaignard <benjamin.gaignard@st.com>
To:     <davem@davemloft.net>, <robh@kernel.org>, <mark.rutland@arm.com>,
        <mripard@kernel.org>, <martin.blumenstingl@googlemail.com>,
        <andrew@lunn.ch>, <narmstrong@baylibre.com>,
        <alexandru.ardelean@analog.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@st.com>
Subject: [PATCH] dt-bindings: net: stmmac: add missing properties keyword
Date:   Thu, 19 Dec 2019 15:02:26 +0100
Message-ID: <20191219140226.16820-1-benjamin.gaignard@st.com>
X-Mailer: git-send-email 2.15.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.75.127.47]
X-ClientProxiedBy: SFHDAG8NODE2.st.com (10.75.127.23) To SFHDAG3NODE3.st.com
 (10.75.127.9)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-19_01:2019-12-17,2019-12-19 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing 'properties' keyword to be compliant with syntax requirements

Fixes: 7db3545aef5fa ("dt-bindings: net: stmmac: Convert the binding to a schemas")
Signed-off-by: Benjamin Gaignard <benjamin.gaignard@st.com>
---
 Documentation/devicetree/bindings/net/snps,dwmac.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index 4845e29411e4..e08cd4c4d568 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -347,6 +347,7 @@ allOf:
               - st,spear600-gmac
 
     then:
+      properties:
         snps,tso:
           $ref: /schemas/types.yaml#definitions/flag
           description:
-- 
2.15.0

