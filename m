Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16008461572
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 13:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233201AbhK2Mtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 07:49:43 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:50652 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbhK2Mrm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 07:47:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1638189866; x=1669725866;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DdVxmhjETMnI2QDRtd3TVl+AMLSq2tr/39GpckqtkfM=;
  b=pODauCoZj1gPHTPRM5Ugn43yt3UNuJ3aTxmjcrsL8ZVnUrjCCnjqLC2/
   Gi/FqUfSsyeQT9b34QSxl7yuHeYkJWBwNmXDY5beipNFBLKQ831zV1TP/
   AmhHWBI6+cqFJaDXnVTziXgM2wwjYBvRhc4mg59nodOcMk5OHZyvLPK9r
   T0kAFF6PEGncGcC4PyV0AsIb8GnQqH9yVo300swQntpfV3QauujNyOrbs
   wihb7xtsU9YueFHd9fue1z/zBNOIzKBVVc9X2ilV7LZMVEILR4e9ln8LQ
   Ru38hfnt/ggiYrmoe7BK6afWNzAKcXrH/6IMo7WiSSNa/tPxqKdpc/t//
   w==;
IronPort-SDR: Rbl5vP+VMjKJ9x02xDVhI8N5csMXEBbD3Bl8cyT5mIb21rU/0BhintDae3G/VnN0ncgDMl7VyL
 q/vDEbSTA9EJavVM0jxYMiLpQA1Cpf7X38+INqwAhsPgbDMgwAutJzDwjVtdExeij7XZc2kKwS
 bSmNr/AEGX6jcypFZkX8xX/biMfqSLEuphqbWgaTWRTSm4j0Fj2appe2gjKl5P1zoGwY+YPGGO
 cvgm5fZbiOggKXTWVYdTf5LNivZyfZHKevMD4cOTFx1NZTn8y1ksjVO+FPwQ4nfasJsrOrW14h
 MxfOOi78XYAAjO0pM0Huo4QL
X-IronPort-AV: E=Sophos;i="5.87,273,1631602800"; 
   d="scan'208";a="144833734"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Nov 2021 05:42:42 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Mon, 29 Nov 2021 05:42:40 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Mon, 29 Nov 2021 05:42:38 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <p.zabel@pengutronix.de>,
        <linux@armlinux.org.uk>, <andrew@lunn.ch>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v5 6/6] net: lan966x: Update MAINTAINERS to include lan966x driver
Date:   Mon, 29 Nov 2021 13:43:59 +0100
Message-ID: <20211129124359.4069432-7-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211129124359.4069432-1-horatiu.vultur@microchip.com>
References: <20211129124359.4069432-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update MAINTAINERS to include lan966x driver

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 360e9aa0205d..2235014c16c4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12524,6 +12524,13 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/microchip/lan743x_*
 
+MICROCHIP LAN966X ETHERNET DRIVER
+M:	Horatiu Vultur <horatiu.vultur@microchip.com>
+M:	UNGLinuxDriver@microchip.com
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	drivers/net/ethernet/microchip/lan966x/*
+
 MICROCHIP LCDFB DRIVER
 M:	Nicolas Ferre <nicolas.ferre@microchip.com>
 L:	linux-fbdev@vger.kernel.org
-- 
2.33.0

