Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 032353492DD
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 14:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbhCYNNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 09:13:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:52484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230232AbhCYNNY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 09:13:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A544619AB;
        Thu, 25 Mar 2021 13:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616678004;
        bh=t5ezC5guRZmmDDgRVgxE3J8YFRmqg79Ix7Z/HJFHFLY=;
        h=From:To:Cc:Subject:Date:From;
        b=EkT41QvW1+hyjM5gf0fp8z54CrSBDpDpMk36uS0XOdCZGJAo6daRwvVH1RppJ5his
         r8XVIsDDKB1RW/todAn716r2XwWyX7S3rIvnOcjAdG+XMY54wqJZKb68BX6nJ6JfgH
         gEd2zzk6rDf6FWCySIY/2n/5pccUhoZJ0ADgXff92xEevfrq6XDAo8sl+GqWSL3ekX
         u1R/QF2+GugACcE61kMyHvMPcCHVEkHWAESDDryOD/dZoUb13PuLhVQM6zIcXr63YX
         kKyAkZGNJ4vaf0kUYxpiwRyMTOyjYNjH81LlPbhOin3EHGdF5Rq21IpbpnNSRxdZ5r
         7rblzaNz+mSkA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>, kuba@kernel.org
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v2 00/12] net: phy: marvell10g updates
Date:   Thu, 25 Mar 2021 14:12:38 +0100
Message-Id: <20210325131250.15901-1-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here are some updates for marvell10g PHY driver.

Changes since v1:
- added various MACTYPEs support also for 88E21XX
- differentiate between specific models with same PHY_ID
- better check for compatible interface
- print exact model

Marek Behún (12):
  net: phy: marvell10g: rename register
  net: phy: marvell10g: fix typo
  net: phy: marvell10g: allow 5gbase-r and usxgmii
  net: phy: marvell10g: indicate 88X33X0 only port control registers
  net: phy: marvell10g: add MACTYPE definitions for 88X33X0/88X33X0P
  net: phy: marvell10g: add MACTYPE definitions for 88E21XX
  net: phy: marvell10g: add code to determine number of ports
  net: phy: marvell10g: support all rate matching modes
  net: phy: marvell10g: support other MACTYPEs
  net: phy: add constants for 2.5G and 5G speed in PCS speed register
  net: phy: marvell10g: print exact model
  net: phy: marvell10g: better check for compatible interface

 drivers/net/phy/marvell10g.c | 262 +++++++++++++++++++++++++++++------
 include/uapi/linux/mdio.h    |   2 +
 2 files changed, 220 insertions(+), 44 deletions(-)

-- 
2.26.2

