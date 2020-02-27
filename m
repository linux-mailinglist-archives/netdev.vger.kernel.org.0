Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05EFE172266
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 16:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729601AbgB0PlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 10:41:14 -0500
Received: from relay11.mail.gandi.net ([217.70.178.231]:45367 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729207AbgB0PlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 10:41:14 -0500
Received: from localhost (lfbn-tou-1-1473-158.w90-89.abo.wanadoo.fr [90.89.41.158])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id 2A875100015;
        Thu, 27 Feb 2020 15:41:11 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/2] net: phy: mscc: support LOS active low
Date:   Thu, 27 Feb 2020 16:40:31 +0100
Message-Id: <20200227154033.1688498-1-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

This series adds a device tree property for the VSC8584 PHY family to
describe the LOS pin connected to the PHY as being active low. This new
property is then used in the MSCC PHY driver.

Thanks!
Antoine

Antoine Tenart (2):
  dt-bindings: net: phy: mscc: document LOS active low property
  net: phy: mscc: support LOS being active low

 Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt | 1 +
 drivers/net/phy/mscc.c                                     | 7 +++++++
 2 files changed, 8 insertions(+)

-- 
2.24.1

