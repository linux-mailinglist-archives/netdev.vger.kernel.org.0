Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 318532A0C88
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 18:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbgJ3RaB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 13:30:01 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:58268 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726573AbgJ3RaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 13:30:01 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 09UHTq1h053569;
        Fri, 30 Oct 2020 12:29:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1604078992;
        bh=4evmccUelkMuwSYfCgnhSOzuZfBZ3e4nuY84WUhnBEs=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=ULP4wcLAKceqx7CelgZAFsZvudJrPnxhZNf2Fwne4N9DhZ+eYEXyhaZcPJJg5R8Rv
         ewlumlrfafE1a81UUS9Cl296mJX9ZlK6ErxPQNX+etdA08jQr0jTJEIL2b/yGZyPxp
         3ZNnHqTfoQOgxE2Ji5Ls/Pb2wE45L/oD2EgOT+PM=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 09UHTqBm056288
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 30 Oct 2020 12:29:52 -0500
Received: from DFLE105.ent.ti.com (10.64.6.26) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 30
 Oct 2020 12:29:52 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 30 Oct 2020 12:29:52 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 09UHTqBL046312;
        Fri, 30 Oct 2020 12:29:52 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <davem@davemloft.net>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <robh@kernel.org>
CC:     <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v3 2/4] dt-bindings: net: Add Rx/Tx output configuration for 10base T1L
Date:   Fri, 30 Oct 2020 12:29:48 -0500
Message-ID: <20201030172950.12767-3-dmurphy@ti.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201030172950.12767-1-dmurphy@ti.com>
References: <20201030172950.12767-1-dmurphy@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Per the 802.3cg spec the 10base T1L can operate at 2 different
differential voltages 1v p2p and 2.4v p2p. The abiility of the PHY to
drive that output is dependent on the PHY's on board power supply.
This common feature is applicable to all 10base T1L PHYs so this binding
property belongs in a top level ethernet document.

Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 Documentation/devicetree/bindings/net/ethernet-phy.yaml | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
index 6dd72faebd89..5cad653e143b 100644
--- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
@@ -174,6 +174,11 @@ properties:
       PHY's that have configurable TX internal delays. If this property is
       present then the PHY applies the TX delay.
 
+  tx-rx-output-high:
+    type: boolean
+    description: |
+      Enable the 2.4v p2p differential output voltage for 10base-T1L PHYs.
+
 required:
   - reg
 
-- 
2.28.0.585.ge1cfff676549

