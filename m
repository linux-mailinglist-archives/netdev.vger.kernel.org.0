Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3174355E9D
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 00:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344035AbhDFWMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 18:12:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:52734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344063AbhDFWMR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 18:12:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55347613D7;
        Tue,  6 Apr 2021 22:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617747128;
        bh=pQxFrHdhl1DiWoghPTu2qloZY6/sTlZQpu2SanSfzPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N/gTY9rzrlK97EUxC+EoPyrHkZ2iNOd+OCZqivUJRtDgULk6wgIVKvTXZPeRcOMIW
         GFGBqiWPOjaAxiyuE1D3vHWNl2Ay3Yh/RApUfFFMyOt2xrnFfDA8JGix8JscIOjskP
         LcbMXYitjn/+v33VK5whRK6HrQcD4KQaIMfWnOXDZQnL2dsOpZO2TFqDYuxenNxJ4Q
         WreYN95c5okwktEjn+82zZVIvb9eMh25oVcCc5zBsedhFb5kLIZTbRzqbee6PXoizL
         gTq550fLSMo1OWRs5Fmdx8ciWVrEXwvMxWJRi4+FMleugG5sNNpvYWEqIuid9mA2ua
         EzQFqZjjOiGyQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kuba@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v3 14/18] net: phy: marvell10g: fix driver name for mv88e2110
Date:   Wed,  7 Apr 2021 00:11:03 +0200
Message-Id: <20210406221107.1004-15-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210406221107.1004-1-kabel@kernel.org>
References: <20210406221107.1004-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver name "mv88x2110" should be instead "mv88e2110".

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/marvell10g.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 74a91853ef46..51b7a5083bdf 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -974,7 +974,7 @@ static struct phy_driver mv3310_drivers[] = {
 	{
 		.phy_id		= MARVELL_PHY_ID_88E2110,
 		.phy_id_mask	= MARVELL_PHY_ID_MASK,
-		.name		= "mv88x2110",
+		.name		= "mv88e2110",
 		.driver_data	= &mv2110_type,
 		.probe		= mv3310_probe,
 		.suspend	= mv3310_suspend,
-- 
2.26.2

