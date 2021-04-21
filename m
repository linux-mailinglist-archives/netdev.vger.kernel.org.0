Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 781F0366DB9
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 16:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236008AbhDUOJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 10:09:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:43050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238640AbhDUOJX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 10:09:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5670D6144D;
        Wed, 21 Apr 2021 14:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619014129;
        bh=Q39/EqgKLZ9mg03RG0C0LuPcS7ytFA0cNgiwKkeGoSU=;
        h=From:To:Cc:Subject:Date:From;
        b=tl3voTBlfTsejLt57++YhBrw1lsUnxdm1Ch4Xokmkf7vNqFJf5+fJdJwrqGq8fQEi
         zUa8ochDNthHw/lNiIUf7wVpugAf/fMhPfmDSADFx3NWD2exDXOv5P5xnuM1dupcBW
         8ZcKp9BAd6mKbHmtrEOTTQuI3dR7uuoc8np6uAGJojQHvhjaWA1wq4zysIpoqx0ija
         CO5b3QudK4wT2R1Ozk8NL5Woa0USDzwxmisj+H4t96LQSg6WKKdFVF9srHDTCR7dn1
         FKdbRM0UtLFWXJdVPTxgyKv/xYY3G/Ixh8OgbvCaQ9AzFyWJRxM1Sc0fK1F0n1Bsxg
         rnRL2SlTtNKIg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     kuba@kernel.org, =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net-next] net: phy: marvell: don't use empty switch default case
Date:   Wed, 21 Apr 2021 16:08:03 +0200
Message-Id: <20210421140803.17780-1-kabel@kernel.org>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This causes error reported by kernel test robot.

Signed-off-by: Marek Behún <kabel@kernel.org>
Fixes: 41d26bf4aba0 ("net: phy: marvell: refactor HWMON OOP style")
Reported-by: kernel test robot <lkp@intel.com>
---
 drivers/net/phy/marvell.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 1cce86b280af..e2b2b20c0dc5 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -2499,8 +2499,6 @@ static int marvell_hwmon_write(struct device *dev, enum hwmon_sensor_types type,
 		if (ops->set_temp_critical)
 			err = ops->set_temp_critical(phydev, temp);
 		break;
-	default:
-		fallthrough;
 	}
 
 	return err;
-- 
2.26.3

