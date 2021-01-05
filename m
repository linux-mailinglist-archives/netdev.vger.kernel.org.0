Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 548F72EAD2F
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 15:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbhAEON6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 09:13:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726352AbhAEON6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 09:13:58 -0500
Received: from mail-out.m-online.net (mail-out.m-online.net [IPv6:2001:a60:0:28:0:1:25:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB5AFC061574
        for <netdev@vger.kernel.org>; Tue,  5 Jan 2021 06:13:17 -0800 (PST)
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4D9Dvr3zzcz1rwDY;
        Tue,  5 Jan 2021 15:12:08 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4D9Dvr3XRPz1sFWt;
        Tue,  5 Jan 2021 15:12:08 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id QsDp1RNpwVZL; Tue,  5 Jan 2021 15:12:06 +0100 (CET)
X-Auth-Info: yLoGFlxC+BBzxtoHHp4cVsoGG9NNP6zqRjz0qom0ZEE=
Received: from tr.lan (ip-89-176-112-137.net.upcbroadband.cz [89.176.112.137])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Tue,  5 Jan 2021 15:12:06 +0100 (CET)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lukas Wunner <lukas@wunner.de>
Subject: [PATCH net-next V3 0/2] net: ks8851: Add KS8851 PHY support
Date:   Tue,  5 Jan 2021 15:11:49 +0100
Message-Id: <20210105141151.122922-1-marex@denx.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The KS8851 has a reduced internal PHY, which is accessible through its
registers at offset 0xe4. The PHY is compatible with KS886x PHY present
in Micrel switches, including the PHY ID Low/High registers swap, which
is present both in the MAC and the switch.

Marek Vasut (2):
  net: phy: micrel: Add KS8851 PHY support
  net: ks8851: Register MDIO bus and the internal PHY

 drivers/net/ethernet/micrel/ks8851.h        |   2 +
 drivers/net/ethernet/micrel/ks8851_common.c | 112 +++++++++++++++++---
 drivers/net/phy/micrel.c                    |   2 +-
 3 files changed, 99 insertions(+), 17 deletions(-)

Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Lukas Wunner <lukas@wunner.de>

-- 
2.29.2

