Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0964EE8B
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 20:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726665AbfFUSOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 14:14:19 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:50862 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbfFUSOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 14:14:18 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id x5LIEBPU044395;
        Fri, 21 Jun 2019 13:14:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1561140851;
        bh=ykGDUhIz4RTT4sMHR+7NG3qQiJjOwv9ygF0iullx9Io=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=eFLgfPdFrCIKTX89JTxxu6ZjYn7UD6gj3vyfGtxscwBkpOmkykjpknw//fANd2TKO
         4X3RUdJo5c0gxfzTXSsQYSg3rd5coHYe1zXmk5m5bivkRTB3ei8hVloyUHOIRgVOnO
         0twNmbLYmiEntLwvnCYTT5iyrpm8sGJ3RNQykbjU=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x5LIEBtM003403
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 21 Jun 2019 13:14:11 -0500
Received: from DFLE111.ent.ti.com (10.64.6.32) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Fri, 21
 Jun 2019 13:14:11 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Fri, 21 Jun 2019 13:14:11 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id x5LIEAQu092995;
        Fri, 21 Jun 2019 13:14:10 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     <netdev@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jiri Pirko <jiri@resnulli.us>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [RFC PATCH v4 net-next 08/11] phy: ti: phy-gmii-sel: dependency from ti cpsw-switchdev driver
Date:   Fri, 21 Jun 2019 21:13:11 +0300
Message-ID: <20190621181314.20778-9-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190621181314.20778-1-grygorii.strashko@ti.com>
References: <20190621181314.20778-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add dependency from TI_CPSW_SWITCHDEV.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/phy/ti/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/ti/Kconfig b/drivers/phy/ti/Kconfig
index c3fa1840f8de..174888609779 100644
--- a/drivers/phy/ti/Kconfig
+++ b/drivers/phy/ti/Kconfig
@@ -90,8 +90,8 @@ config TWL4030_USB
 
 config PHY_TI_GMII_SEL
 	tristate
-	default y if TI_CPSW=y
-	depends on TI_CPSW || COMPILE_TEST
+	default y if TI_CPSW=y || TI_CPSW_SWITCHDEV=y
+	depends on TI_CPSW || TI_CPSW_SWITCHDEV || COMPILE_TEST
 	select GENERIC_PHY
 	select REGMAP
 	default m
-- 
2.17.1

