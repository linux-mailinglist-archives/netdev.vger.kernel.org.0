Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E268113102
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 18:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728236AbfLDRpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 12:45:49 -0500
Received: from lelv0142.ext.ti.com ([198.47.23.249]:49952 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728216AbfLDRpr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 12:45:47 -0500
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id xB4HjduI077775;
        Wed, 4 Dec 2019 11:45:39 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1575481539;
        bh=y0bu3gi4LiyPCwtS8SHQGzSTP8+Hg44usGmaPjP+Eg8=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=IkLYDaJW8E6kT7KeQMbXhGTZCYonCP+wcdSTDUnG+8BqYmk34o1cDXmXq1pHLRtdv
         K0zV8tJM8EGIeGywbbgeBULwNCHNgtD6GOUnXBOvI3ElZgAE99V1A81bZrvK7QTExz
         dKGX2TtdlnTCgw4bercNc4wfU8eis1F1frpU3ei8=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xB4Hjd8f113290
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 4 Dec 2019 11:45:39 -0600
Received: from DLEE100.ent.ti.com (157.170.170.30) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Wed, 4 Dec
 2019 11:45:39 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Wed, 4 Dec 2019 11:45:39 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id xB4HjcN4019620;
        Wed, 4 Dec 2019 11:45:39 -0600
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     Randy Dunlap <rdunlap@infradead.org>, <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Tony Lindgren <tony@atomide.com>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH 2/2] arm: omap2plus_defconfig: enable NET_SWITCHDEV
Date:   Wed, 4 Dec 2019 19:45:33 +0200
Message-ID: <20191204174533.32207-3-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191204174533.32207-1-grygorii.strashko@ti.com>
References: <20191204174533.32207-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TI_CPSW_SWITCHDEV definition in Kconfig was changed from "select
NET_SWITCHDEV" to "depends on NET_SWITCHDEV", and therefore it is required
to explicitelly enable NET_SWITCHDEV config option in omap2plus_defconfig.

Fixes: 3727d259ddaf ("arm: omap2plus_defconfig: enable new cpsw switchdev driver")
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 arch/arm/configs/omap2plus_defconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/configs/omap2plus_defconfig b/arch/arm/configs/omap2plus_defconfig
index 89cce8d4bc6b..7bbef86a4e76 100644
--- a/arch/arm/configs/omap2plus_defconfig
+++ b/arch/arm/configs/omap2plus_defconfig
@@ -92,6 +92,7 @@ CONFIG_IP_PNP_BOOTP=y
 CONFIG_IP_PNP_RARP=y
 CONFIG_NETFILTER=y
 CONFIG_PHONET=m
+CONFIG_NET_SWITCHDEV=y
 CONFIG_CAN=m
 CONFIG_CAN_C_CAN=m
 CONFIG_CAN_C_CAN_PLATFORM=m
@@ -182,6 +183,7 @@ CONFIG_SMSC911X=y
 # CONFIG_NET_VENDOR_STMICRO is not set
 CONFIG_TI_DAVINCI_EMAC=y
 CONFIG_TI_CPSW=y
+CONFIG_TI_CPSW_SWITCHDEV=y
 CONFIG_TI_CPTS=y
 # CONFIG_NET_VENDOR_VIA is not set
 # CONFIG_NET_VENDOR_WIZNET is not set
@@ -554,4 +556,3 @@ CONFIG_DEBUG_INFO_DWARF4=y
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_SCHEDSTATS=y
 # CONFIG_DEBUG_BUGVERBOSE is not set
-CONFIG_TI_CPSW_SWITCHDEV=y
-- 
2.17.1

