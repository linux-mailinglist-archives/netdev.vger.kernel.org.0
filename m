Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4D4DF5FE6
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 16:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbfKIPRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 10:17:00 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:39694 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727050AbfKIPQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 10:16:59 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id xA9FGqA1067260;
        Sat, 9 Nov 2019 09:16:52 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1573312612;
        bh=xWIoQSrYXNWBqcNp2g+cclEnGktsP5JwTLkmsEQZEpM=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=yNdXtTrztUhBab4VjOsMO7bUdlOX9QDrHAHHLfABSHUU8m2WlO4N/ZODCBi9RSH5C
         LJ/T+we68KA8YwQ5xo5fI9AE2r1r8d9Fph0+/OKhSmykY/04LegD4UoaoJy/7gbF1v
         qeeiBO9HpKs3dPTLDaDWJTv3xivEuFZOohe2A2BA=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id xA9FGqFp108670;
        Sat, 9 Nov 2019 09:16:52 -0600
Received: from DLEE108.ent.ti.com (157.170.170.38) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Sat, 9 Nov
 2019 09:16:35 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Sat, 9 Nov 2019 09:16:51 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id xA9FGosN061723;
        Sat, 9 Nov 2019 09:16:51 -0600
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     Florian Fainelli <f.fainelli@gmail.com>, <netdev@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jiri Pirko <jiri@resnulli.us>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH v6 net-next 13/13] arm: omap2plus_defconfig: enable new cpsw switchdev driver
Date:   Sat, 9 Nov 2019 17:15:25 +0200
Message-ID: <20191109151525.18651-14-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191109151525.18651-1-grygorii.strashko@ti.com>
References: <20191109151525.18651-1-grygorii.strashko@ti.com>
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

