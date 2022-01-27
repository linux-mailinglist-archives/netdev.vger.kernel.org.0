Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65BE049DFCB
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 11:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239701AbiA0KtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 05:49:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239660AbiA0KtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 05:49:18 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80A66C06174A
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 02:49:17 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nD2Kz-0007ki-2w; Thu, 27 Jan 2022 11:49:09 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nD2Kx-003lyo-BB; Thu, 27 Jan 2022 11:49:07 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH net-next v1 0/4] usbnet: add "label" support
Date:   Thu, 27 Jan 2022 11:49:01 +0100
Message-Id: <20220127104905.899341-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add devicetree label property for usbnet devices and related yaml
schema.

Oleksij Rempel (4):
  dt-bindings: net: add schema for ASIX USB Ethernet controllers
  dt-bindings: net: add schema for Microchip/SMSC LAN95xx USB Ethernet
    controllers
  dt-bindings: net: add "label" property for all usbnet Ethernet
    controllers
  usbnet: add support for label from device tree

 .../devicetree/bindings/net/asix,ax88178.yaml | 102 ++++++++++++++++++
 .../bindings/net/microchip,lan95xx.yaml       |  84 +++++++++++++++
 .../devicetree/bindings/net/usbnet.yaml       |  36 +++++++
 drivers/net/usb/usbnet.c                      |  15 +++
 4 files changed, 237 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/asix,ax88178.yaml
 create mode 100644 Documentation/devicetree/bindings/net/microchip,lan95xx.yaml
 create mode 100644 Documentation/devicetree/bindings/net/usbnet.yaml

-- 
2.30.2

