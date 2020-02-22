Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 376AF168EA8
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 13:04:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727382AbgBVMEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 07:04:11 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:35032 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726763AbgBVMEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Feb 2020 07:04:11 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 01MC48bM045309;
        Sat, 22 Feb 2020 06:04:08 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1582373048;
        bh=FL3PpKb3O6A20m682u3CDfqsn9XRDAOXLQy7bt/wamI=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=j9418AKwfzL2wsGnrAImK3MbtQpFo5ojJQ4PiJ+Xn6rR+fQCTprCoHo6ny226/CZB
         1nRO6BVBCiHqI+trx5jiznIlphkQaomcFvcUsoyW76lhskbdWs40h7WHB7EeZ9oAzx
         DXZxDCV4jA/AeGQt3A/x1DgOlwN1NQNrdeUUtKOc=
Received: from DLEE108.ent.ti.com (dlee108.ent.ti.com [157.170.170.38])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 01MC48Rq000820
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 22 Feb 2020 06:04:08 -0600
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Sat, 22
 Feb 2020 06:04:08 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Sat, 22 Feb 2020 06:04:08 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 01MC47Wf107377;
        Sat, 22 Feb 2020 06:04:07 -0600
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     Kishon Vijay Abraham I <kishon@ti.com>,
        Tero Kristo <t-kristo@ti.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [for-next PATCH 2/5] dt-bindings: phy: ti: gmii-sel: add support for am654x/j721e soc
Date:   Sat, 22 Feb 2020 14:03:55 +0200
Message-ID: <20200222120358.10003-3-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200222120358.10003-1-grygorii.strashko@ti.com>
References: <20200222120358.10003-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TI AM654x/J721E SoCs have the same PHY interface selection mechanism for
CPSWx subsystem as TI SoCs (AM3/4/5/DRA7), but registers and bit-fields
placement is different.

This patch adds corresponding compatible strings to enable support for TI
AM654x/J721E SoCs.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 Documentation/devicetree/bindings/phy/ti-phy-gmii-sel.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/phy/ti-phy-gmii-sel.txt b/Documentation/devicetree/bindings/phy/ti-phy-gmii-sel.txt
index 50ce9ae0f7a5..83b78c1c0644 100644
--- a/Documentation/devicetree/bindings/phy/ti-phy-gmii-sel.txt
+++ b/Documentation/devicetree/bindings/phy/ti-phy-gmii-sel.txt
@@ -40,6 +40,7 @@ Required properties:
 			  "ti,dra7xx-phy-gmii-sel" for dra7xx/am57xx platform
 			  "ti,am43xx-phy-gmii-sel" for am43xx platform
 			  "ti,dm814-phy-gmii-sel" for dm814x platform
+			  "ti,am654-phy-gmii-sel" for AM654x/J721E platform
 - reg			: Address and length of the register set for the device
 - #phy-cells		: must be 2.
 			  cell 1 - CPSW port number (starting from 1)
-- 
2.17.1

