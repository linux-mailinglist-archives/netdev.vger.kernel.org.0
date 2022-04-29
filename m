Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1F9514F64
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 17:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378447AbiD2Pau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 11:30:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378419AbiD2Pad (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 11:30:33 -0400
Received: from mx0a-00128a01.pphosted.com (mx0a-00128a01.pphosted.com [148.163.135.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A62D9D4CAF;
        Fri, 29 Apr 2022 08:27:14 -0700 (PDT)
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23TCsdmU019426;
        Fri, 29 Apr 2022 11:27:05 -0400
Received: from nwd2mta4.analog.com ([137.71.173.58])
        by mx0a-00128a01.pphosted.com (PPS) with ESMTPS id 3fprv535us-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Apr 2022 11:27:04 -0400
Received: from ASHBMBX8.ad.analog.com (ASHBMBX8.ad.analog.com [10.64.17.5])
        by nwd2mta4.analog.com (8.14.7/8.14.7) with ESMTP id 23TFR3D6044433
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 29 Apr 2022 11:27:03 -0400
Received: from ASHBCASHYB4.ad.analog.com (10.64.17.132) by
 ASHBMBX8.ad.analog.com (10.64.17.5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.14; Fri, 29 Apr 2022 11:27:03 -0400
Received: from ASHBMBX8.ad.analog.com (10.64.17.5) by
 ASHBCASHYB4.ad.analog.com (10.64.17.132) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.14; Fri, 29 Apr 2022 11:27:02 -0400
Received: from zeus.spd.analog.com (10.66.68.11) by ashbmbx8.ad.analog.com
 (10.64.17.5) with Microsoft SMTP Server id 15.2.986.14 via Frontend
 Transport; Fri, 29 Apr 2022 11:27:02 -0400
Received: from localhost.localdomain ([10.48.65.12])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 23TFQEcl028122;
        Fri, 29 Apr 2022 11:26:54 -0400
From:   <alexandru.tachici@analog.com>
To:     <andrew@lunn.ch>
CC:     <o.rempel@pengutronix.de>, <alexandru.tachici@analog.com>,
        <davem@davemloft.net>, <devicetree@vger.kernel.org>,
        <hkallweit1@gmail.com>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux@armlinux.org.uk>,
        <netdev@vger.kernel.org>, <robh+dt@kernel.org>
Subject: [PATCH v7 7/7] dt-bindings: net: phy: Add 10-baseT1L 2.4 Vpp
Date:   Fri, 29 Apr 2022 18:34:37 +0300
Message-ID: <20220429153437.80087-8-alexandru.tachici@analog.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220429153437.80087-1-alexandru.tachici@analog.com>
References: <20220429153437.80087-1-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ADIRuleOP-NewSCL: Rule Triggered
X-Proofpoint-GUID: VLMYCEFUkzUMXzd-sUKUPP3IGRrCdezs
X-Proofpoint-ORIG-GUID: VLMYCEFUkzUMXzd-sUKUPP3IGRrCdezs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-29_07,2022-04-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 lowpriorityscore=0 spamscore=0 impostorscore=0 adultscore=0
 mlxlogscore=792 mlxscore=0 bulkscore=0 suspectscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204290083
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandru Tachici <alexandru.tachici@analog.com>

Add a tristate property to advertise desired transmit level.

If the device supports the 2.4 Vpp operating mode for 10BASE-T1L,
as defined in 802.3gc, and the 2.4 Vpp transmit voltage operation
is desired, property should be set to 1. This property is used
to select whether Auto-Negotiation advertises a request to
operate the 10BASE-T1L PHY in increased transmit level mode.

If property is set to 1, the PHY shall advertise a request
to operate the 10BASE-T1L PHY in increased transmit level mode.
If property is set to zero, the PHY shall not advertise
a request to operate the 10BASE-T1L PHY in increased transmit level mode.

Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
---
 Documentation/devicetree/bindings/net/ethernet-phy.yaml | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
index ee42328a109d..ed1415a4381f 100644
--- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
@@ -77,6 +77,15 @@ properties:
     description:
       Maximum PHY supported speed in Mbits / seconds.
 
+  phy-10base-t1l-2.4vpp:
+    description: |
+      tristate, request/disable 2.4 Vpp operating mode. The values are:
+      0: Disable 2.4 Vpp operating mode.
+      1: Request 2.4 Vpp operating mode from link partner.
+      Absence of this property will leave configuration to default values.
+    $ref: "/schemas/types.yaml#/definitions/uint32"
+    enum: [0, 1]
+
   broken-turn-around:
     $ref: /schemas/types.yaml#/definitions/flag
     description:
-- 
2.25.1

