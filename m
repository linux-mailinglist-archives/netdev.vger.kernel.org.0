Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 852FC3492E5
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 14:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbhCYNOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 09:14:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:52748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230339AbhCYNNm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 09:13:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F27D261A1E;
        Thu, 25 Mar 2021 13:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616678022;
        bh=ZFJurUnJK78TF7LRyAyoDsdJum1NzykQEtrffQ3FDZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cl36vQldNpzyg73lqz6qO2hO3dTt0zyQPJRoS8nwPdqAEMZ9yX1PWotP5u6PHrjiZ
         FIMFj8rv2H3NhKZrThcQeQw/p28NshSwevClpw2WyfVuhF+Oyx3lbxy78kAnEnaVqz
         YK7dY6vKyHZJ6T3n4UfydxOvxWN8G3mcX40dl8N69FsKASRU5UvZsiG/Olxya4Js02
         J0vTALZ623GiEj+DDV1yWEx342IQKHp24S2ixzPK0u7cPvSF2xNkyUS22QnjCvOSTI
         Zvolg2ahjJ5SZANHT8wH88zUIcTi2a60N0u45qiLeYdxn5O01p7aeHM9Pjhp2rK9mD
         iol3J0YiDRJIw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>, kuba@kernel.org
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v2 10/12] net: phy: add constants for 2.5G and 5G speed in PCS speed register
Date:   Thu, 25 Mar 2021 14:12:48 +0100
Message-Id: <20210325131250.15901-11-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210325131250.15901-1-kabel@kernel.org>
References: <20210325131250.15901-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add constants for 2.5G and 5G speed in PCS speed register into mdio.h.

Signed-off-by: Marek Behún <kabel@kernel.org>
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

