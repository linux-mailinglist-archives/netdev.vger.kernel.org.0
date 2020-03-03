Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B59F0177B61
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 17:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730182AbgCCQAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 11:00:52 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:54078 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729543AbgCCQAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 11:00:49 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 023G0kC9091121;
        Tue, 3 Mar 2020 10:00:46 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1583251246;
        bh=oehu8Dp5oKYIE3wzZN60BoP+9zoo0QNkg4JLEASppoM=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=sOIG1o9G2U58Z90c2BjeCbnkGgxAigmJUGefa2FO/qyUrv/YQ7M/LQlCce3SiRrhC
         s9ybkO3NUkC/mVLzJn6OGTDO0gI5PrOUYhO7ZCSDZKisIaL8G+Gtw+3HwSu4lD/T5R
         aAcP+SDwKV4wXjLTB9OaFxtR8T8TFz6IHWVkSNgM=
Received: from DFLE103.ent.ti.com (dfle103.ent.ti.com [10.64.6.24])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 023G0kXn104100;
        Tue, 3 Mar 2020 10:00:46 -0600
Received: from DFLE112.ent.ti.com (10.64.6.33) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 3 Mar
 2020 10:00:45 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 3 Mar 2020 10:00:46 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 023G0jLL126279;
        Tue, 3 Mar 2020 10:00:45 -0600
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     Murali Karicheri <m-karicheri2@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Tero Kristo <t-kristo@ti.com>,
        "David S . Miller" <davem@davemloft.net>
CC:     Sekhar Nori <nsekhar@ti.com>, Rob Herring <robh+dt@kernel.org>,
        netdev <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [for-next PATCH v2 2/5] dt-bindings: phy: ti: gmii-sel: add support for am654x/j721e soc
Date:   Tue, 3 Mar 2020 18:00:26 +0200
Message-ID: <20200303160029.345-3-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200303160029.345-1-grygorii.strashko@ti.com>
References: <20200303160029.345-1-grygorii.strashko@ti.com>
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
Acked-by: Rob Herring <robh@kernel.org>
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

