Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E79D53D09A
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 17:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404722AbfFKPTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 11:19:10 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:46130 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404658AbfFKPTD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 11:19:03 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 1B5AEC1DC6;
        Tue, 11 Jun 2019 15:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1560266339; bh=/OJYsOKYv50WQaAr6ltez4OEKGVWdpgD2R9RWLXhY0s=;
        h=From:To:Cc:Subject:Date:From;
        b=I03fF/JSqbyzmgh3vBqDqvXqDG+E1lH1rutlIsrm4Kb04ywQ8XaH1CcWTqjbk8sO6
         v8L3WxPbojMVL9NtXNtvov0w+dFwbdDPFN7zKLq0uugMZrJxPrzbtYd9DXWvEtM4KC
         U1wfLTa+W2jR2swWQluLkUf6+gXL5RWsP/IpQS+p7F8OcRXUpodV1ixD9TwjEOSlBq
         Ll+ez9irfLsbIu8IkkEJiwm2QaI6JFvMwv0cIvuVibb2c45V+RMYQ9K9lAky4eSQ8u
         vwN2YrhTMQ3Nb11BDca4VasqRpa2lScq33TBeET0l2q7Tma8LTvL5ugPYC9sRVhPWT
         RYw7R1dSKbSvg==
Received: from de02.synopsys.com (germany.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 2181FA0057;
        Tue, 11 Jun 2019 15:18:58 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id E49E13FDB8;
        Tue, 11 Jun 2019 17:18:57 +0200 (CEST)
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
Subject: [PATCH net-next 0/3] net: stmmac: Convert to phylink
Date:   Tue, 11 Jun 2019 17:18:44 +0200
Message-Id: <cover.1560266175.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ Hope this diff looks better (generated with --minimal) ]

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

Jose Abreu (3):
  net: stmmac: Prepare to convert to phylink
  net: stmmac: Start adding phylink support
  net: stmmac: Convert to phylink and remove phylib logic

 drivers/net/ethernet/stmicro/stmmac/Kconfig   |   3 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |   7 +-
 .../ethernet/stmicro/stmmac/stmmac_ethtool.c  |  81 +---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 391 ++++++++----------
 .../ethernet/stmicro/stmmac/stmmac_platform.c |  21 +-
 5 files changed, 190 insertions(+), 313 deletions(-)

-- 
2.21.0

