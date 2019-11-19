Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46CAF102F14
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 23:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbfKSWT5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 17:19:57 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:34644 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727709AbfKSWTz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 17:19:55 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id xAJMJneG027239;
        Tue, 19 Nov 2019 16:19:49 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1574201989;
        bh=ykGDUhIz4RTT4sMHR+7NG3qQiJjOwv9ygF0iullx9Io=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=WpPqbyAm/IU2+m3vxCOahuYA47y9ALfAlhDcLkJgueoxT6ePlDBzlikeR2Xb5FTsR
         CixiFDugbJwqtUnm9+DuZpuWtZWdkZ+ulrtsEij+UwCUD1Oh1wgYt/w5guNMoVCjWc
         SeG4EBRwyIk9wPDl6qlUSxjj4/Qj7WZFT3Tuo28s=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xAJMJmHB093309
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 19 Nov 2019 16:19:49 -0600
Received: from DLEE113.ent.ti.com (157.170.170.24) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 19
 Nov 2019 16:19:48 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 19 Nov 2019 16:19:48 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id xAJMJlV3007646;
        Tue, 19 Nov 2019 16:19:48 -0600
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
Subject: [PATCH v7 net-next 09/13] phy: ti: phy-gmii-sel: dependency from ti cpsw-switchdev driver
Date:   Wed, 20 Nov 2019 00:19:21 +0200
Message-ID: <20191119221925.28426-10-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191119221925.28426-1-grygorii.strashko@ti.com>
References: <20191119221925.28426-1-grygorii.strashko@ti.com>
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

