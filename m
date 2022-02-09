Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 674B94AEBE7
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 09:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240771AbiBIIKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 03:10:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240418AbiBIIKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 03:10:30 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59635C0613CA
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 00:10:34 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nHi3Y-0004o0-8r; Wed, 09 Feb 2022 09:10:28 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nHi3X-0098ix-JX; Wed, 09 Feb 2022 09:10:27 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH net-next v2 0/2] provide yaml schema for some of USB ethernet controllers 
Date:   Wed,  9 Feb 2022 09:10:23 +0100
Message-Id: <20220209081025.2178435-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

changes v2:
- drop label related patches
- remove end-product IDs, only chip IDs are needed.

Oleksij Rempel (2):
  dt-bindings: net: add schema for ASIX USB Ethernet controllers
  dt-bindings: net: add schema for Microchip/SMSC LAN95xx USB Ethernet
    controllers

 .../devicetree/bindings/net/asix,ax88178.yaml | 68 ++++++++++++++++
 .../bindings/net/microchip,lan95xx.yaml       | 80 +++++++++++++++++++
 2 files changed, 148 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/asix,ax88178.yaml
 create mode 100644 Documentation/devicetree/bindings/net/microchip,lan95xx.yaml


base-commit: e783362eb54cd99b2cac8b3a9aeac942e6f6ac07
-- 
2.30.2

