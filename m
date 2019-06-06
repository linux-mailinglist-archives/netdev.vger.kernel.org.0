Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB6B1372C9
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 13:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728354AbfFFL06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 07:26:58 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:60812 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726961AbfFFL06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 07:26:58 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 7E3F8C0B66;
        Thu,  6 Jun 2019 11:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1559820429; bh=LYlsmuhYso763N/RO39um+ScxW0aMyDOSjQIC78SHBQ=;
        h=From:To:Cc:Subject:Date:From;
        b=iFLGbuSjEvG5FT0C04tHTBa3IbPDhVG0rW4E+2tKwEUu9NCL/0C6LP2WvrQT2x4nh
         8VL4aFFxBHLG353m89erGIIUiRcexRD+tPX1HG+XkPGEqJTIgXz5m0NzM672oo3I4P
         +TWiB5UVRpIH5yVWYX+qqPfAWzPl87pFMQ5I7kqA08t/XGt2ePZ6Thea/m9ZpB6La4
         gPu0k1rnHm9+8Az+mwbYkjIoCiNK00p9G+AXTo/0o/JWPTdT9rJpNwrPzM71UA2wDs
         dq4aFn25X+cWftdVq4Ay4DTWLxYV9aykKyVXfKcQWVmfzc9RV16nxXxoZj8umPbLez
         JU1nOqYo9Q5QA==
Received: from de02.synopsys.com (germany.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 54354A005D;
        Thu,  6 Jun 2019 11:26:54 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 1DDD43E9E1;
        Thu,  6 Jun 2019 13:26:54 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [RFC net-next 0/2] net: stmmac: Convert to phylink
Date:   Thu,  6 Jun 2019 13:26:49 +0200
Message-Id: <cover.1559741195.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ Resending with PHYLIB maintainer (Russell) in cc plus some PHY experts ]

For review and testing only.

This converts stmmac to use phylink. Besides the code redution this will
allow to gain more flexibility.

Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>

Jose Abreu (2):
  net: stmmac: Prepare to convert to phylink
  net: stmmac: Convert to phylink

 drivers/net/ethernet/stmicro/stmmac/Kconfig        |   3 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |   4 +-
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |  72 +---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 389 +++++++++------------
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |  21 +-
 5 files changed, 189 insertions(+), 300 deletions(-)

-- 
2.7.4

