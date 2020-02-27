Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 465C317224E
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 16:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731209AbgB0PaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 10:30:25 -0500
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:33593 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728205AbgB0PaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 10:30:23 -0500
X-Originating-IP: 90.89.41.158
Received: from localhost (lfbn-tou-1-1473-158.w90-89.abo.wanadoo.fr [90.89.41.158])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 9C5491BF209;
        Thu, 27 Feb 2020 15:30:16 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        foss@0leil.net
Subject: [PATCH net-next 0/3] net: phy: mscc: add support for RGMII MAC mode
Date:   Thu, 27 Feb 2020 16:28:56 +0100
Message-Id: <20200227152859.1687119-1-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

This series adds support for the RGMII MAC mode for the VSC8584 PHY
family.

The first patch adds support for configuring the PHY MAC mode based on
phydev->interface.

The second and third patches add new dt bindings for the MSCC driver, to
configure the RGMII Tx and Rx skews from the device tree.

Thanks!
Antoine


Antoine Tenart (3):
  net: phy: mscc: add support for RGMII MAC mode
  dt-bindings: net: phy: mscc: document rgmii skew properties
  net: phy: mscc: implement RGMII skew delay configuration

 .../bindings/net/mscc-phy-vsc8531.txt         |  8 +++
 drivers/net/phy/mscc.c                        | 51 ++++++++++++++-----
 include/dt-bindings/net/mscc-phy-vsc8531.h    | 10 ++++
 3 files changed, 57 insertions(+), 12 deletions(-)

-- 
2.24.1

