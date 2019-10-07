Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D460CDF4B
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 12:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727670AbfJGK0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 06:26:34 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:28598 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726010AbfJGK0e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 06:26:34 -0400
Received: from pps.filterd (m0046037.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x97AKnkm026209;
        Mon, 7 Oct 2019 12:25:56 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=STMicroelectronics;
 bh=aRKA0Hvxqsr1NU6FxTX9pHJ5jFSSMvepSuS2dat7KfY=;
 b=C1PaEp39aGplqzUO+AEhqlnEjwrL8KCqz6cf3NU+SbEGoVaZoHpQ0D+7WbUBls+xhTER
 D0rm5F1dZaNV0owRLPZuNFb8HczCS2pOuIZVzujC09CRsdUa3bQX1AyKxYkPM1d9TMrL
 4EIKogGmOhoXsUfnIN2HBitZ80QQTruxzMDeMUPicGVSi3Dyn1gGUyBiElBb+MAKmrLL
 XgrBYvjdXZqrt0ge+FUtwhTUgNNMyOWERPnRpPV+yZNjyNqGBfdeqOYYC3Ju+yL8JOZV
 51j00jaXVwNTHGJhVFlN6Bdddr/F3ZXGvvfLOt8b1S+I8Ihgfkxw56dr7kugyAh1r0R/ FA== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 2vegxvhrn4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Oct 2019 12:25:56 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 90BF810002A;
        Mon,  7 Oct 2019 12:25:55 +0200 (CEST)
Received: from Webmail-eu.st.com (sfhdag3node2.st.com [10.75.127.8])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 817AE2BFE0A;
        Mon,  7 Oct 2019 12:25:55 +0200 (CEST)
Received: from localhost (10.75.127.48) by SFHDAG3NODE2.st.com (10.75.127.8)
 with Microsoft SMTP Server (TLS) id 15.0.1347.2; Mon, 7 Oct 2019 12:25:55
 +0200
From:   Alexandre Torgue <alexandre.torgue@st.com>
To:     Maxime Ripard <mripard@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Alexandru Ardelean <alexaundru.ardelean@analog.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>
CC:     <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH 1/3] dt-bindings: media: Fix id path for sun4i-a10-csi
Date:   Mon, 7 Oct 2019 12:25:50 +0200
Message-ID: <20191007102552.19808-2-alexandre.torgue@st.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191007102552.19808-1-alexandre.torgue@st.com>
References: <20191007102552.19808-1-alexandre.torgue@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.75.127.48]
X-ClientProxiedBy: SFHDAG7NODE2.st.com (10.75.127.20) To SFHDAG3NODE2.st.com
 (10.75.127.8)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-07_02:2019-10-07,2019-10-07 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit fixes id path of allwinner,sun4i-a10-csi.yaml location.

Fixes: c5e8f4ccd775 ("media: dt-bindings: media: Add Allwinner A10 CSI binding")
Signed-off-by: Alexandre Torgue <alexandre.torgue@st.com>

diff --git a/Documentation/devicetree/bindings/media/allwinner,sun4i-a10-csi.yaml b/Documentation/devicetree/bindings/media/allwinner,sun4i-a10-csi.yaml
index 27f38eed389e..5dd1cf490cd9 100644
--- a/Documentation/devicetree/bindings/media/allwinner,sun4i-a10-csi.yaml
+++ b/Documentation/devicetree/bindings/media/allwinner,sun4i-a10-csi.yaml
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
 %YAML 1.2
 ---
-$id: http://devicetree.org/schemas/arm/allwinner,sun4i-a10-csi.yaml#
+$id: http://devicetree.org/schemas/media/allwinner,sun4i-a10-csi.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
 title: Allwinner A10 CMOS Sensor Interface (CSI) Device Tree Bindings
-- 
2.17.1

