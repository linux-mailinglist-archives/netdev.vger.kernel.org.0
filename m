Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAABB3DC36A
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 06:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233122AbhGaEwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 00:52:12 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:43356 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbhGaEwL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Jul 2021 00:52:11 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 16V4pmVX105473;
        Fri, 30 Jul 2021 23:51:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1627707108;
        bh=SHuG0KuuJUw46qCngxJHmhdC+ykdC/6gJbXxAPyMbrk=;
        h=From:To:CC:Subject:Date;
        b=O10z1D4P6vlLCF7NNYZNPII0d6rt047R1gr96hWcCOOBbk9ooOPv8b/f6IopT/hdb
         4lNpIVoanblcxCkX0lyWc0YVdeGa+2QRzsnjq3+rmzYCCeX/CZi1Y/ZC2x4ubAgRt1
         OOW6Z3JRuURhdKw7Hnuik1XEYfFoWubAeUIEeE9Y=
Received: from DLEE100.ent.ti.com (dlee100.ent.ti.com [157.170.170.30])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 16V4pmOp102113
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 30 Jul 2021 23:51:48 -0500
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Fri, 30
 Jul 2021 23:51:47 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Fri, 30 Jul 2021 23:51:48 -0500
Received: from gsaswath-HP-ProBook-640-G5.dal.design.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 16V4pf4J009078;
        Fri, 30 Jul 2021 23:51:42 -0500
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
Subject: [PATCH] dt-bindings: net: can: Document power-domains property
Date:   Sat, 31 Jul 2021 10:21:38 +0530
Message-ID: <20210731045138.29912-1-a-govindraju@ti.com>
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
 Documentation/devicetree/bindings/net/can/bosch,m_can.yaml | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
index a7b5807c5543..d633fe1da870 100644
--- a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
+++ b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
@@ -104,6 +104,13 @@ properties:
           maximum: 32
     maxItems: 1
 
+  power-domains:
+    description:
+      Power domain provider node and an args specifier containing
+      the can device id value. Please see,
+      Documentation/devicetree/bindings/soc/ti/sci-pm-domain.yaml
+    maxItems: 1
+
   can-transceiver:
     $ref: can-transceiver.yaml#
 
-- 
2.17.1

