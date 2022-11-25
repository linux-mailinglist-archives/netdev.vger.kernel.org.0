Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB2D1638B06
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 14:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbiKYNSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 08:18:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiKYNS0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 08:18:26 -0500
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [217.70.178.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B21A532BAF;
        Fri, 25 Nov 2022 05:18:15 -0800 (PST)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id B329110000E;
        Fri, 25 Nov 2022 13:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1669382294;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kr/Cj9zfcDB4yuNR0P+NcVj8Izrqtu5VXnRoj3YeWog=;
        b=MmSIlxSTGhG1vopnsc3kSCU2v2yKidY5zAz+i/WM5SPO/Il7hWSrz6oQ/P+nsX7zZD85tq
        RCakvZ2swc64GvvKN3bXVudaxMj3uDHPtcKzGUhj7kVnYOz/kRN9MKl8Dk5YN18xUJbYhu
        mRmfIUw7Z9ntF0Ou/gAZwnEn4mKLH/f0DkM1eHofTLwInFEXEbE9qDIS3j/FRadAzwuppm
        UjTVMERSURu9oTfjtViGOSTo2pylhg4DcbGO9eAeFkuLGnRngfeqERckGhSlDTvm7rWxHW
        UpuKzWcIsGeZsQp49gmR+Xm6bpe3gP4nKPyH3rhPXxzUSGZDXpsbohClRtLF6Q==
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        devicetree@vger.kernel.org
Subject: [PATCH net-next 3/3] net: pcs: altera-tse: remove unnecessary register definitions
Date:   Fri, 25 Nov 2022 14:18:01 +0100
Message-Id: <20221125131801.64234-4-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221125131801.64234-1-maxime.chevallier@bootlin.com>
References: <20221125131801.64234-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

remove unused register definitions, left from the split with the
altera-tse mac driver.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
 drivers/net/pcs/pcs-altera-tse.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/net/pcs/pcs-altera-tse.c b/drivers/net/pcs/pcs-altera-tse.c
index be65271ff5de..d616749761f4 100644
--- a/drivers/net/pcs/pcs-altera-tse.c
+++ b/drivers/net/pcs/pcs-altera-tse.c
@@ -12,22 +12,13 @@
 
 /* SGMII PCS register addresses
  */
-#define SGMII_PCS_SCRATCH	0x10
-#define SGMII_PCS_REV		0x11
 #define SGMII_PCS_LINK_TIMER_0	0x12
-#define   SGMII_PCS_LINK_TIMER_REG(x)		(0x12 + (x))
 #define SGMII_PCS_LINK_TIMER_1	0x13
 #define SGMII_PCS_IF_MODE	0x14
 #define   PCS_IF_MODE_SGMII_ENA		BIT(0)
 #define   PCS_IF_MODE_USE_SGMII_AN	BIT(1)
-#define   PCS_IF_MODE_SGMI_SPEED_MASK	GENMASK(3, 2)
-#define   PCS_IF_MODE_SGMI_SPEED_10	(0 << 2)
-#define   PCS_IF_MODE_SGMI_SPEED_100	(1 << 2)
-#define   PCS_IF_MODE_SGMI_SPEED_1000	(2 << 2)
 #define   PCS_IF_MODE_SGMI_HALF_DUPLEX	BIT(4)
 #define   PCS_IF_MODE_SGMI_PHY_AN	BIT(5)
-#define SGMII_PCS_DIS_READ_TO	0x15
-#define SGMII_PCS_READ_TO	0x16
 #define SGMII_PCS_SW_RESET_TIMEOUT 100 /* usecs */
 
 struct altera_tse_pcs {
-- 
2.38.1

