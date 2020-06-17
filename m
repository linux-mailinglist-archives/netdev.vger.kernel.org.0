Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0561FD443
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 20:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbgFQSUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 14:20:41 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:37730 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbgFQSUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 14:20:38 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 05HIKVbG058170;
        Wed, 17 Jun 2020 13:20:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1592418031;
        bh=Eui6gMDXRbqI+3Gto0iGF+/V7yAE/pLSF5Iag/APeDc=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=xUcCL+V+x8hqpN9oA19mVYO0xxq0P5M7MEHNV3TIcHO5nJh12FYMkzldhQixY+eKG
         W/uUsQiwFZYYRwxN+T3eKp9cbWrmQc8djYc0tIPQIugI2c1P4fM0J1P3M6OfNWbUgu
         k1r71OKS7FcHCiP8IgETgL63g0TDlrEksBcs5D9I=
Received: from DLEE112.ent.ti.com (dlee112.ent.ti.com [157.170.170.23])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 05HIKV30115931
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 17 Jun 2020 13:20:31 -0500
Received: from DLEE114.ent.ti.com (157.170.170.25) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 17
 Jun 2020 13:20:31 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 17 Jun 2020 13:20:31 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 05HIKV3a064256;
        Wed, 17 Jun 2020 13:20:31 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <robh@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v7 1/6] dt-bindings: net: Add tx and rx internal delays
Date:   Wed, 17 Jun 2020 13:20:14 -0500
Message-ID: <20200617182019.6790-2-dmurphy@ti.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200617182019.6790-1-dmurphy@ti.com>
References: <20200617182019.6790-1-dmurphy@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tx-internal-delays and rx-internal-delays are a common setting for RGMII
capable devices.

These properties are used when the phy-mode or phy-controller is set to
rgmii-id, rgmii-rxid or rgmii-txid.  These modes indicate to the
controller that the PHY will add the internal delay for the connection.

Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 .../devicetree/bindings/net/ethernet-phy.yaml         | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
index 9b1f1147ca36..b2887476fe6a 100644
--- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
@@ -162,6 +162,17 @@ properties:
     description:
       Specifies a reference to a node representing a SFP cage.
 
+
+  rx-internal-delay-ps:
+    description: |
+      RGMII Receive PHY Clock Delay defined in pico seconds.  This is used for
+      PHY's that have configurable RX internal delays.
+
+  tx-internal-delay-ps:
+    description: |
+      RGMII Transmit PHY Clock Delay defined in pico seconds.  This is used for
+      PHY's that have configurable TX internal delays.
+
 required:
   - reg
 
-- 
2.26.2

