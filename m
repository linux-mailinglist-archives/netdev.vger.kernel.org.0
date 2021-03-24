Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8E51347E32
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 17:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236897AbhCXQvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 12:51:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:43576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236612AbhCXQu5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 12:50:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85A84619F3;
        Wed, 24 Mar 2021 16:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616604657;
        bh=HZilA3Ddut5I+CzKgTwN2jWGUXVZvJ89bfSy/1ffutg=;
        h=From:To:Cc:Subject:Date:From;
        b=MUfwXs27KbWFBqV6CTNGsruGtj2okH9TL+KSympDqPI1JCQWm9LLlXtyTQZzoox+u
         066ymbbOOaNED6g7Ynyb7yYITsLgo6bic1mrG9trg1juYU2XKA5qRkvQiMgjJZofIJ
         DoyRSBXNWLgc4xfmiswxlAx5kingOBYdP3vgtSH+3Wo2seTkimy3q34GNCNjLT/prt
         HcE0TVr0uKzv/fDj/YjZSRyu3FFyorx72/4eVEXXkFN27ubI7uN9IxYOPrhgXGi5xa
         04rksoqY/zb/vn1zvCiqADj+5KsbNl3GY5q66biqEX3yTzjm6f2d5AnMnbPYeuVZbD
         DRuh7YwXYCJvw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>, kuba@kernel.org
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next 0/7] net: phy: marvell10g updates
Date:   Wed, 24 Mar 2021 17:50:16 +0100
Message-Id: <20210324165023.32352-1-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here are some updates for marvell10g PHY driver.

Marek Behún (7):
  net: phy: marvell10g: rename register
  net: phy: marvell10g: fix typo
  net: phy: marvell10g: allow 5gabse-r and usxgmii
  net: phy: marvell10g: add MACTYPE definitions for 88X3310/88X3310P
  net: phy: marvell10g: save MACTYPE instead of rate_matching boolean
  net: phy: marvell10g: support more rate matching modes
  net: phy: marvell10g: support other MACTYPEs

 drivers/net/phy/marvell10g.c | 102 +++++++++++++++++++++++------------
 1 file changed, 67 insertions(+), 35 deletions(-)

-- 
2.26.2

