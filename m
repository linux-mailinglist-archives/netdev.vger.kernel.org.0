Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDBA426FB0C
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 12:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbgIRK6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 06:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbgIRK6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 06:58:10 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 057ECC061756
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 03:58:10 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id lo4so7494533ejb.8
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 03:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Mz0nf5lKPBUxgJuP35DRL+TsAjc1AJ4rawiw0Qy5rqs=;
        b=uNPHXwa5Y8zNSbTInqX3pl2dxFZLvpvLq59lWYTJ+6extUA/gqD+yu32d0YWTkrYsa
         QsDababULPd+5pdgau3C5CAQ+C8Cviixe3rKVx5bqgPjYYl+3oPvcn2OHMzgu/cCIHMf
         aPqUe7jNzEy1p7D/KAavBlfKd4z/IFTPQh3f2Q9qi/OsdDivmpmMbbHq3G091wEHO1H0
         J92e0w1YKSqJ+C0fbRFfJcJmgSHtB6TdD0l07DEkMEmfO4r+bbzS3GNtKg6bqcaAuOoD
         AiJZHdqyonC4RmkJlpmN+PnQpSHmOxmc70k2kX0vH3aIv/UL670VviyT3HlpFCPkJcD5
         ablw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Mz0nf5lKPBUxgJuP35DRL+TsAjc1AJ4rawiw0Qy5rqs=;
        b=KPJYYMiXRMFOMt+B/IXpNow8XCgdk5upliwm9wNIkcPTGgV8Y3mia5EZivolaePHUT
         lSmhkR2LUBn2DoBRF9Rd94dAfCrZPI1H7zTHXT/cOtXQGCsNo1f/CUhe2Ql0JhsD/evD
         xO9uub0rWRyvDb0KlSsLI0xnXIEXOQkCxXg/RuPR9KjVwuRgMVBUxN4dhuC/Iqs1qcH0
         2dkOvogQEHp8lZqCk8sr7ehmeX8+lF126KgHyImUulEq3WYSiraAdo4BUKrXvKN05xbB
         TZnMsj1F7D2NiDew+l8f1cNEDryYlcbgE9K1P/8+0t6hSvl/qfmzOr61wNU2BH0A8uNu
         uOMw==
X-Gm-Message-State: AOAM531tEH/zAekSkdLHbz8aG3hH9Z17M6LBkbkUdBg4vTqgO2RmIhlO
        ypbIiQ7iqPNbOaMLjPK1YAg=
X-Google-Smtp-Source: ABdhPJywwhQqPgEWWh36koONOO/qekAGBUnqXfg3+G+lHUpcAhISAUHBdjY1UXNBIyCgifNCH7zYlg==
X-Received: by 2002:a17:906:b285:: with SMTP id q5mr35042891ejz.545.1600426688713;
        Fri, 18 Sep 2020 03:58:08 -0700 (PDT)
Received: from localhost.localdomain ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id k1sm1995086eji.20.2020.09.18.03.58.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 03:58:08 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com,
        UNGLinuxDriver@microchip.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org
Subject: [PATCH net-next 05/11] net: dsa: seville: remove unused defines for the mdio controller
Date:   Fri, 18 Sep 2020 13:57:47 +0300
Message-Id: <20200918105753.3473725-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918105753.3473725-1-olteanv@gmail.com>
References: <20200918105753.3473725-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Some definitions were likely copied from
drivers/net/mdio/mdio-mscc-miim.c.

They are not necessary, remove them.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/seville_vsc9953.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index dfc9a1b2a504..0b6ceec85891 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -16,23 +16,12 @@
 #define VSC9953_VCAP_IS2_ENTRY_WIDTH		376
 #define VSC9953_VCAP_PORT_CNT			10
 
-#define MSCC_MIIM_REG_STATUS			0x0
-#define		MSCC_MIIM_STATUS_STAT_BUSY	BIT(3)
-#define MSCC_MIIM_REG_CMD			0x8
 #define		MSCC_MIIM_CMD_OPR_WRITE		BIT(1)
 #define		MSCC_MIIM_CMD_OPR_READ		BIT(2)
 #define		MSCC_MIIM_CMD_WRDATA_SHIFT	4
 #define		MSCC_MIIM_CMD_REGAD_SHIFT	20
 #define		MSCC_MIIM_CMD_PHYAD_SHIFT	25
 #define		MSCC_MIIM_CMD_VLD		BIT(31)
-#define MSCC_MIIM_REG_DATA			0xC
-#define		MSCC_MIIM_DATA_ERROR		(BIT(16) | BIT(17))
-
-#define MSCC_PHY_REG_PHY_CFG		0x0
-#define		PHY_CFG_PHY_ENA		(BIT(0) | BIT(1) | BIT(2) | BIT(3))
-#define		PHY_CFG_PHY_COMMON_RESET BIT(4)
-#define		PHY_CFG_PHY_RESET	(BIT(5) | BIT(6) | BIT(7) | BIT(8))
-#define MSCC_PHY_REG_PHY_STATUS		0x4
 
 static const u32 vsc9953_ana_regmap[] = {
 	REG(ANA_ADVLEARN,			0x00b500),
-- 
2.25.1

