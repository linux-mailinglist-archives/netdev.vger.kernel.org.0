Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 986FF3575DC
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 22:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356104AbhDGUYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 16:24:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:55786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356100AbhDGUYD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 16:24:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50434611CC;
        Wed,  7 Apr 2021 20:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617827033;
        bh=hO82dqEarv1Q80hwH5YaNAVWHDQhUZEWqAWokHOIyks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NxmePKWwc6BVk6MRslgIKiV59Kn7NQev8OSfgZ/6PPP+EiMKIxkwIpMV1nK24Tjuq
         17M4YFS6zifcB86bedkE296VXfixhubxfbH69iAHkMtb1pOROBulP1aFPIAjoi5sg5
         NAScR3YNsoP5tSEY6mSYe+KTRMjbBCd/jKXbh1tiNWy/vnVLMpCFl+W+EIMyBXiidy
         5Eh8nUsO+K4Ym3J3LRwaSl7mhvxEvR9tdYkF+58fZbloYaX3SmATqKUgJhPcMsEY0X
         vuI+LcVN3R/dDb4ilnutmC5F5CnlSOKJc0cx1EwTCdUOsrSYgMaq2fGtTHQtPPGE3R
         Y38hH78he4g3w==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>, kuba@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v4 12/16] net: phy: marvell10g: fix driver name for mv88e2110
Date:   Wed,  7 Apr 2021 22:22:50 +0200
Message-Id: <20210407202254.29417-13-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210407202254.29417-1-kabel@kernel.org>
References: <20210407202254.29417-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver name "mv88x2110" should be instead "mv88e2110".

Signed-off-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/marvell10g.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index f74dfd993d8b..3c99757f0306 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -988,7 +988,7 @@ static struct phy_driver mv3310_drivers[] = {
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

