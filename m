Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E59C18B93D
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 15:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbgCSOUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 10:20:07 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:55929 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727430AbgCSOUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 10:20:06 -0400
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id E70AD200009;
        Thu, 19 Mar 2020 14:20:01 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 0/2] net: phy: mscc: add support for RGMII MAC mode
Date:   Thu, 19 Mar 2020 15:19:56 +0100
Message-Id: <20200319141958.383626-1-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

This series adds support for the RGMII MAC mode for the VSC8584 PHY
family and for RGMII_ID modes (Tx and/or Rx).

I decided to drop the custom delay for now. I made some tests and it
seemed to be working quite well. If we find out we really need to lower
the delay, which I doubt, I'll send support for it.

Thanks!
Antoine

Since v2:
  - Dropped support for custom dt bindings.
  - Add the 2ns delay based on the interface mode.

Since v1:
  - The RGMII skew delays are now set based on the PHY interface mode
    being used (RGMII vs ID vs RXID vs TXID).
  - When RGMII is used, the skew delays are set to their default value,
    meaning we do not rely anymore on the bootloader's configuration.
  - Improved the commit messages.
  - s/phy_interface_mode_is_rgmii/phy_interface_is_rgmii/

Antoine Tenart (2):
  net: phy: mscc: add support for RGMII MAC mode
  net: phy: mscc: RGMII skew delay configuration

 drivers/net/phy/mscc/mscc.h      | 15 ++++++++
 drivers/net/phy/mscc/mscc_main.c | 61 +++++++++++++++++++++++++-------
 2 files changed, 64 insertions(+), 12 deletions(-)

-- 
2.25.1

