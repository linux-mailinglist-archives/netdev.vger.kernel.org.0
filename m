Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5E8D1888EB
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 16:18:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbgCQPRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 11:17:53 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:17668 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726597AbgCQPRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 11:17:52 -0400
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02HFDMg7001983;
        Tue, 17 Mar 2020 16:17:23 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=STMicroelectronics;
 bh=d5sQRupo2d0Z3lLmpiw6V8YqXfIBD+SRKOfZr/LN05s=;
 b=oQf2yh0sQFHlHWV5ubbyg5zahKDDBEUa9PGb87OoEGFjLxN1ZXm5QJFgMW+A9MyKkd0N
 CLii5E61HD5EijvQHcxyAb52AlLYkUcJD6EziRjWvl62qDXGyEHXVy5Pr6/NII5pWC8V
 uywXu2di0pQXapAtL8pVJZg7yz4M21hSaGXlTBkLTvgKvvXB2rTFnleHXs++P6fZA5WZ
 8hFSWOrw7NrsoZcruKm6sUfQU3nSCElRu5bmCC4is6GqvNKrOIZvhrZjdl4pZgO7Oq95
 etouCinWyQAjWvXnaQy1ASFFDJ/QBaptzKVp5vF24pNZ6ZYWUuhb2FMNnkUouHLauO76 AA== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 2yrqa9s1vm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Mar 2020 16:17:23 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 9A443100039;
        Tue, 17 Mar 2020 16:17:17 +0100 (CET)
Received: from Webmail-eu.st.com (sfhdag5node3.st.com [10.75.127.15])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 880342BC7B0;
        Tue, 17 Mar 2020 16:17:17 +0100 (CET)
Received: from localhost (10.75.127.44) by SFHDAG5NODE3.st.com (10.75.127.15)
 with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 17 Mar 2020 16:17:16
 +0100
From:   Christophe Roullier <christophe.roullier@st.com>
To:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <mripard@kernel.org>,
        <martin.blumenstingl@googlemail.com>,
        <alexandru.ardelean@analog.com>, <narmstrong@baylibre.com>,
        <mcoquelin.stm32@gmail.com>, <alexandre.torgue@st.com>
CC:     <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        <christophe.roullier@st.com>, <linux-kernel@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCHv2 1/2] dt-bindings: net: dwmac: increase 'maxItems' for 'clocks', 'clock-names' properties
Date:   Tue, 17 Mar 2020 16:17:05 +0100
Message-ID: <20200317151706.25810-2-christophe.roullier@st.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200317151706.25810-1-christophe.roullier@st.com>
References: <20200317151706.25810-1-christophe.roullier@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.75.127.44]
X-ClientProxiedBy: SFHDAG2NODE2.st.com (10.75.127.5) To SFHDAG5NODE3.st.com
 (10.75.127.15)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-17_06:2020-03-17,2020-03-17 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change is needed for some soc based on snps,dwmac, which have
more than 3 clocks.

Signed-off-by: Christophe Roullier <christophe.roullier@st.com>
---
 Documentation/devicetree/bindings/net/snps,dwmac.yaml | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index e08cd4c4d568..439115b7663c 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -27,6 +27,7 @@ select:
           - snps,dwmac-3.710
           - snps,dwmac-4.00
           - snps,dwmac-4.10a
+          - snps,dwmac-4.20a
           - snps,dwxgmac
           - snps,dwxgmac-2.10
 
@@ -62,6 +63,7 @@ properties:
         - snps,dwmac-3.710
         - snps,dwmac-4.00
         - snps,dwmac-4.10a
+        - snps,dwmac-4.20a
         - snps,dwxgmac
         - snps,dwxgmac-2.10
 
@@ -87,7 +89,8 @@ properties:
 
   clocks:
     minItems: 1
-    maxItems: 3
+    maxItems: 5
+    additionalItems: true
     items:
       - description: GMAC main clock
       - description: Peripheral registers interface clock
@@ -97,6 +100,8 @@ properties:
           clock will be used and this is fine on some platforms.
 
   clock-names:
+    minItems: 1
+    maxItems: 5
     additionalItems: true
     contains:
       enum:
@@ -342,6 +347,7 @@ allOf:
               - allwinner,sun50i-a64-emac
               - snps,dwmac-4.00
               - snps,dwmac-4.10a
+              - snps,dwmac-4.20a
               - snps,dwxgmac
               - snps,dwxgmac-2.10
               - st,spear600-gmac
-- 
2.17.1

