Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 742193575DF
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 22:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356150AbhDGUZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 16:25:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:55800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356115AbhDGUYE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 16:24:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2BF4611C1;
        Wed,  7 Apr 2021 20:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617827035;
        bh=V+B246HTRginjGUts7jw9n9eZXQkaeCppYFShohkonQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PhVCUKO6QWdEwdTYiWqtMpIM4LvyscL8GDP9fEB9dKj8TPxv2JQSgQQmTSltvPRrD
         uM5ga9Iyd3K7MzEvJr85oLmdQ1HBB6DJ1cXGSdYc/7lwgEVlzdSu6AUEhHSy5ZIgeP
         9f4TUvAFlbZNjv8gAF1ukUkYeKMNKyoWs2U0cKznMa2PhuYvEiO8iaEK8zkBPUibu7
         9y6BPVPopMb4eM3GOuv+hkkaz0cx39ZFRr1U35tJaJ0bsZsWzingytIDKHhGHMN+eB
         +IF7oY18vAhfMmhAxNQqW14yJDt1obBYenHwQFG2Xp3HvHiwmJCuKcsUGwKPgu+l8Y
         gFkgzAXNQSKmQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>, kuba@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v4 13/16] net: phy: add constants for 2.5G and 5G speed in PCS speed register
Date:   Wed,  7 Apr 2021 22:22:51 +0200
Message-Id: <20210407202254.29417-14-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210407202254.29417-1-kabel@kernel.org>
References: <20210407202254.29417-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add constants for 2.5G and 5G speed in PCS speed register into mdio.h.

Signed-off-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 include/uapi/linux/mdio.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/mdio.h b/include/uapi/linux/mdio.h
index 3f302e2523b2..bdf77dffa5a4 100644
--- a/include/uapi/linux/mdio.h
+++ b/include/uapi/linux/mdio.h
@@ -120,6 +120,8 @@
 #define MDIO_PMA_SPEED_100		0x0020	/* 100M capable */
 #define MDIO_PMA_SPEED_10		0x0040	/* 10M capable */
 #define MDIO_PCS_SPEED_10P2B		0x0002	/* 10PASS-TS/2BASE-TL capable */
+#define MDIO_PCS_SPEED_2_5G		0x0040	/* 2.5G capable */
+#define MDIO_PCS_SPEED_5G		0x0080	/* 5G capable */
 
 /* Device present registers. */
 #define MDIO_DEVS_PRESENT(devad)	(1 << (devad))
-- 
2.26.2

