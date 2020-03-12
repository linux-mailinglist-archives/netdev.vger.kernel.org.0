Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42C941836F7
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 18:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgCLRLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 13:11:15 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:35588 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725268AbgCLRLO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 13:11:14 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id AA662C108A;
        Thu, 12 Mar 2020 17:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1584033073; bh=JctjT8ZZB3iGiymejL3UkVZ9bMIbCL4Z7Cm4bSq+Rac=;
        h=From:To:Cc:Subject:Date:From;
        b=VbdaxuRE/sDXULz7i8tqvuBSPauwJNtx8llrBmIzXeZV+nNrAvhFQ1ctRZ7bVk6Jy
         6OE7rwePbWh7p0WNM9QMjnzhRVmLpcfHbOZOWGD+GBcLWlpUgLS4+SBpzIXOY5Kfny
         +tREujQg2815XcPBR9iFnTX242mudETHJ/N262xd94o+4T6QPoT5gRrX9vqGor5I+l
         TV/8yl014BY9de+QuO8nu9ODqxXlAddLFrkNDlqX2zidta0EgIVXDVwoDoZQy28dnB
         +FQN1GL81lB7d8oXH3j6UrxZYohVHI1s57cKMVLPrZUqyNGz1Wy+uPRh+Nm6e75Bn3
         YI2+qy1rNrusg==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id A430CA0061;
        Thu, 12 Mar 2020 17:11:07 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/2] net: phy: XLGMII define and usage in PHYLINK
Date:   Thu, 12 Mar 2020 18:10:08 +0100
Message-Id: <cover.1584031294.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds XLGMII defines and usage in PHYLINK.

Patch 1/2, adds the define for it, whilst 2/2 adds the usage of it in
PHYLINK.

---
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---

Jose Abreu (2):
  net: phy: Add XLGMII interface define
  net: phylink: Add XLGMII support

 drivers/net/phy/phylink.c | 27 +++++++++++++++++++++++++++
 include/linux/phy.h       |  3 +++
 2 files changed, 30 insertions(+)

-- 
2.7.4

