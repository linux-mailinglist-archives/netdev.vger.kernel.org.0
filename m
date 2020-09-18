Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3970D26FB09
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 12:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbgIRK6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 06:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbgIRK6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 06:58:11 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40177C061788
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 03:58:11 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id p9so7510757ejf.6
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 03:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E4DvFOcJAST3leUERaTt1Mz73uAmZiVqlB+qoaSVZio=;
        b=LIRls3ONOuyE9Q8fYLsrNKdyosxV860Ij+bI+p14fq56D4UiweYDGRdLUvQehGx4YX
         gVdt3F2KuJO0CqP5rGlfYnZ+sVg5ExEp3mIq8zABwzrnMjGMYbfEji+oOxmN9CqSleFp
         7mxW2fd/cXBThPgLywGqxldkVuMe6O1yFkihDuO7unCy6FbKtLVXX8yEobURpzXS0Dd3
         l802ApfcnEYb85RK2NG8rx9eP9QBvqJFq8iePcMjdO2BJ6jDqYTeNbA1enc9Xy/8/PE+
         50jw4CaKMAxFIs8X301Y8LmuK+aoO90855xKLr/doDqCx9j+NtGkXPiIdB5ueS98T1BE
         gxOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E4DvFOcJAST3leUERaTt1Mz73uAmZiVqlB+qoaSVZio=;
        b=QzxFg7x7g8198LYm05j4nwM7gj0J7meGR0iJSI1splRc1j4zVE9p7p6ptDSL6AdoDG
         H8zvMmdfcgM0/91Gv1tOEl4UaeEa8mIJnGxRuOogwnLmuB3cGTxrWWO/WPP06E9T6+8i
         t/mYvyXk/zfE4Swt+UFIMTHRGWUd/LDxBydqMrgxVl/8gSwuAys5wca5byCHrCXT1O0E
         TVLKojuUC7l9QeQYw6SRXjhL4DOJrkZp93yonbog1eC/JzPGqfSRDMjeP6CdGG2nv7Qa
         VUDydFGHV0TsHoyOyWdCdkrjQ2dNL9PBfgD3QcrwAlzWCU7vBfmTEs5DMzj7U69MktrH
         5NRw==
X-Gm-Message-State: AOAM530lTHeHXSs/sSfMnW1pSpOlLsHbN1Xk8ivbAzu7nOU8+EwXaGTH
        rcZe/4LtSKCRp44RPDpHuy8=
X-Google-Smtp-Source: ABdhPJzZsgXhwaFGW31dkgBZveeTNB+f27rSRxRoZIQavM5nwto8/snjTi0kxxYq7yvPsdaBPNEVwA==
X-Received: by 2002:a17:906:4f16:: with SMTP id t22mr34870560eju.40.1600426689963;
        Fri, 18 Sep 2020 03:58:09 -0700 (PDT)
Received: from localhost.localdomain ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id k1sm1995086eji.20.2020.09.18.03.58.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 03:58:09 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com,
        UNGLinuxDriver@microchip.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org
Subject: [PATCH net-next 06/11] net: dsa: seville: reindent defines for MDIO controller
Date:   Fri, 18 Sep 2020 13:57:48 +0300
Message-Id: <20200918105753.3473725-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918105753.3473725-1-olteanv@gmail.com>
References: <20200918105753.3473725-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Reindent these definitions to be in line with the rest of the driver.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/seville_vsc9953.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 0b6ceec85891..224f7326ddb6 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -16,12 +16,12 @@
 #define VSC9953_VCAP_IS2_ENTRY_WIDTH		376
 #define VSC9953_VCAP_PORT_CNT			10
 
-#define		MSCC_MIIM_CMD_OPR_WRITE		BIT(1)
-#define		MSCC_MIIM_CMD_OPR_READ		BIT(2)
-#define		MSCC_MIIM_CMD_WRDATA_SHIFT	4
-#define		MSCC_MIIM_CMD_REGAD_SHIFT	20
-#define		MSCC_MIIM_CMD_PHYAD_SHIFT	25
-#define		MSCC_MIIM_CMD_VLD		BIT(31)
+#define MSCC_MIIM_CMD_OPR_WRITE			BIT(1)
+#define MSCC_MIIM_CMD_OPR_READ			BIT(2)
+#define MSCC_MIIM_CMD_WRDATA_SHIFT		4
+#define MSCC_MIIM_CMD_REGAD_SHIFT		20
+#define MSCC_MIIM_CMD_PHYAD_SHIFT		25
+#define MSCC_MIIM_CMD_VLD			BIT(31)
 
 static const u32 vsc9953_ana_regmap[] = {
 	REG(ANA_ADVLEARN,			0x00b500),
-- 
2.25.1

