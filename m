Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 173AC3DD2CA
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 11:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233019AbhHBJSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 05:18:53 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:55740 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232670AbhHBJSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 05:18:52 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 1729IVVh028556;
        Mon, 2 Aug 2021 04:18:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1627895911;
        bh=4Z+3ysRgexbfccgrBWiUFU3xK2qFdvWRaUojKrBGN50=;
        h=From:To:CC:Subject:Date;
        b=JdKr7Fmp1rWuq1n1sMwaNqINY940i69NpzOkney8ldmSewGM+lf/pJREi0+Pi/STJ
         BlwhV0eOP1rkAohzb5+1Qt3jbP2WANTNifiqljRGEzxf3r4gwv3O8UBleIOyaRI7Pm
         SdPp6NPeWzPVj0KHTQqy2JIdZtl6Ri1OLJ9E/1cE=
Received: from DFLE100.ent.ti.com (dfle100.ent.ti.com [10.64.6.21])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 1729IVWZ099533
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 2 Aug 2021 04:18:31 -0500
Received: from DFLE115.ent.ti.com (10.64.6.36) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Mon, 2 Aug
 2021 04:18:31 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Mon, 2 Aug 2021 04:18:30 -0500
Received: from gsaswath-HP-ProBook-640-G5.dal.design.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 1729IPBW101552;
        Mon, 2 Aug 2021 04:18:25 -0500
From:   Aswath Govindraju <a-govindraju@ti.com>
CC:     Lokesh Vutla <lokeshvutla@ti.com>, Nishanth Menon <nm@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Aswath Govindraju <a-govindraju@ti.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Sriram Dash <sriram.dash@samsung.com>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] dt-bindings: net: can: Document power-domains property
Date:   Mon, 2 Aug 2021 14:48:22 +0530
Message-ID: <20210802091822.16407-1-a-govindraju@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document power-domains property for adding the Power domain provider.

Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
---

Changes since v1:
- removed reference in the description

 Documentation/devicetree/bindings/net/can/bosch,m_can.yaml | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
index a7b5807c5543..fb547e26c676 100644
--- a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
+++ b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
@@ -104,6 +104,12 @@ properties:
           maximum: 32
     maxItems: 1
 
+  power-domains:
+    description:
+      Power domain provider node and an args specifier containing
+      the can device id value.
+    maxItems: 1
+
   can-transceiver:
     $ref: can-transceiver.yaml#
 
-- 
2.17.1

