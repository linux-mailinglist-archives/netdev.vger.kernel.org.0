Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC015638AFC
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 14:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbiKYNSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 08:18:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiKYNSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 08:18:10 -0500
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 010312E6A9;
        Fri, 25 Nov 2022 05:18:08 -0800 (PST)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 4E88A10000B;
        Fri, 25 Nov 2022 13:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1669382287;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=0d1cFLg9vl+Y4ldKUYkiu6bdGuh9DYdx4Y4f8oOvYjY=;
        b=TPQyE/rY1wNqd0FskVoPtDoHcp10guMJ73MlQIwlblQJO3x6dFAkplU5Y8GHhejVMLWq4q
        vGIJpMiyENS/FSYsTLu7caevWi2rU8m3ia8EGeDbofzGGYhJEZM3P0FiCcnkTUfOPSwmr6
        VwLKgNAeIEOm4HC0lMliiE9z8JHSpATviAXdKdryo9LGwfrk2873gaQqc8b1TfHRwoM9Al
        x7o1POcQZ8VAvzuFgWBsTHBWuizXwB4Czzeo+D73Q7Z24kQ47jodFHeSNltBkW/E31Kn+I
        rkTr3ajy6B/oXKLCQHqUrL9RAzy+adCVPmIcvyyUAt+kGsBOgbcd6bzxLsAhLg==
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
Subject: [PATCH net-next 0/3] net: pcs: altera-tse: simplify and clean-up the driver
Date:   Fri, 25 Nov 2022 14:17:58 +0100
Message-Id: <20221125131801.64234-1-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello everyone,

This small series does a bit of code cleanup in the altera TSE pcs
driver, removong unused register definitions, handling 1000BaseX speed
configuration correctly according to the datasheet, and making use of
proper poll_timeout helpers.

No functional change is introduced.

Best regards,

Maxime

Maxime Chevallier (3):
  net: pcs: altera-tse: use read_poll_timeout to wait for reset
  net: pcs: altera-tse: don't set the speed for 1000BaseX
  net: pcs: altera-tse: remove unnecessary register definitions

 drivers/net/pcs/pcs-altera-tse.c | 21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

-- 
2.38.1

