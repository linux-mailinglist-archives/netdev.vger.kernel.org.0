Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DECA46FF26
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 11:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240144AbhLJK46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 05:56:58 -0500
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:8124 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239436AbhLJK4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 05:56:35 -0500
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BA6co2b026427;
        Fri, 10 Dec 2021 05:52:41 -0500
Received: from nwd2mta3.analog.com ([137.71.173.56])
        by mx0a-00128a01.pphosted.com (PPS) with ESMTPS id 3cv1tbrw1p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Dec 2021 05:52:41 -0500
Received: from ASHBMBX9.ad.analog.com (ASHBMBX9.ad.analog.com [10.64.17.10])
        by nwd2mta3.analog.com (8.14.7/8.14.7) with ESMTP id 1BAAqe03021159
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 10 Dec 2021 05:52:40 -0500
Received: from ASHBMBX9.ad.analog.com (10.64.17.10) by ASHBMBX9.ad.analog.com
 (10.64.17.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.14; Fri, 10 Dec
 2021 05:52:39 -0500
Received: from zeus.spd.analog.com (10.66.68.11) by ashbmbx9.ad.analog.com
 (10.64.17.10) with Microsoft SMTP Server id 15.2.986.14 via Frontend
 Transport; Fri, 10 Dec 2021 05:52:39 -0500
Received: from localhost.localdomain ([10.48.65.12])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 1BAAqLrH008399;
        Fri, 10 Dec 2021 05:52:36 -0500
From:   <alexandru.tachici@analog.com>
To:     <andrew@lunn.ch>
CC:     <o.rempel@pengutronix.de>, <alexandru.tachici@analog.com>,
        <davem@davemloft.net>, <devicetree@vger.kernel.org>,
        <hkallweit1@gmail.com>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux@armlinux.org.uk>,
        <netdev@vger.kernel.org>, <robh+dt@kernel.org>
Subject: [PATCH v4 7/7] dt-bindings: net: phy: Add 10-baseT1L 2.4 Vpp
Date:   Fri, 10 Dec 2021 13:05:09 +0200
Message-ID: <20211210110509.20970-8-alexandru.tachici@analog.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211210110509.20970-1-alexandru.tachici@analog.com>
References: <20211210110509.20970-1-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ADIRuleOP-NewSCL: Rule Triggered
X-Proofpoint-GUID: SNQGpbfIqGxjCdRU8_c-HQEL8pgOr3FJ
X-Proofpoint-ORIG-GUID: SNQGpbfIqGxjCdRU8_c-HQEL8pgOr3FJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-10_03,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 phishscore=0 mlxlogscore=744 clxscore=1015 impostorscore=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 adultscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112100059
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

Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
---
 Documentation/devicetree/bindings/net/ethernet-phy.yaml | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
index 2766fe45bb98..c1615ea63b1f 100644
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

