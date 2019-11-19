Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4743102F09
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 23:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbfKSWUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 17:20:07 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:40710 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727821AbfKSWUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 17:20:02 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id xAJMJtvb114504;
        Tue, 19 Nov 2019 16:19:55 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1574201995;
        bh=xWIoQSrYXNWBqcNp2g+cclEnGktsP5JwTLkmsEQZEpM=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=ybmCXrsCIBh0ftzKhrQuKsgI9FQarIJB4ADUhRwZRL5b1tymR4EHu9/mW9/U6l/Hx
         B9lVC7XS5QjCcBf1T8MFClk6dxxocPcAWMxVG1TkxEtMr7glft77VFIuO3OMpPxZj4
         cXRxiiZWGJRdWDP7YNgLskQ8o3FNhbckRh1tbDnA=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xAJMJtpp093366
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 19 Nov 2019 16:19:55 -0600
Received: from DFLE105.ent.ti.com (10.64.6.26) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 19
 Nov 2019 16:19:54 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 19 Nov 2019 16:19:54 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id xAJMJsXx085064;
        Tue, 19 Nov 2019 16:19:54 -0600
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
Subject: [PATCH v7 net-next 13/13] arm: omap2plus_defconfig: enable new cpsw switchdev driver
Date:   Wed, 20 Nov 2019 00:19:25 +0200
Message-ID: <20191119221925.28426-14-grygorii.strashko@ti.com>
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

Add CONFIG_TI_CPSW_SWITCHDEV option to enable new cpsw switchdev driver

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 arch/arm/configs/omap2plus_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/omap2plus_defconfig b/arch/arm/configs/omap2plus_defconfig
index 40d7f1a4fc45..89cce8d4bc6b 100644
--- a/arch/arm/configs/omap2plus_defconfig
+++ b/arch/arm/configs/omap2plus_defconfig
@@ -554,3 +554,4 @@ CONFIG_DEBUG_INFO_DWARF4=y
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_SCHEDSTATS=y
 # CONFIG_DEBUG_BUGVERBOSE is not set
+CONFIG_TI_CPSW_SWITCHDEV=y
-- 
2.17.1

