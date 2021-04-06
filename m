Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 753C9355E9E
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 00:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243644AbhDFWMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 18:12:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:52740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344099AbhDFWMS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 18:12:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E69A613D4;
        Tue,  6 Apr 2021 22:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617747130;
        bh=ZFJurUnJK78TF7LRyAyoDsdJum1NzykQEtrffQ3FDZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p8IuDPRewRI0Rn6Nlfri6vYd5/Gifb893zQn6Ekg4w8GNMPYA0elNNPTCpZ7F8D5l
         nCMGn1/lkBbbpKemlvYe8czdSLNATfhV9aA1NHq0aYVhP7R3VXxR8Nz8wX8Oe9F5hA
         LmB9A1Mu3GbumyhuvYsDQCtnaL73hJRbwi7OlrrlThqe0Ep1MM0CmRMRwgEccdT+v2
         Sn+GQ0Y/5f2IqMCf/8W2ISH4O2tpik859upwA1GzYIuyiobNTcTDoQXHHGdc37lhz0
         +hKyPmVfdXBEg4BtEZiO+p5Di+OE1mXJmhARdke4zsEUqqPbRnYxPGupvqAPXSmRGF
         UnXl348PtvD+A==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kuba@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v3 15/18] net: phy: add constants for 2.5G and 5G speed in PCS speed register
Date:   Wed,  7 Apr 2021 00:11:04 +0200
Message-Id: <20210406221107.1004-16-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210406221107.1004-1-kabel@kernel.org>
References: <20210406221107.1004-1-kabel@kernel.org>
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

