Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31AC835D96D
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 09:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237986AbhDMH46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 03:56:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:42428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237044AbhDMH4q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 03:56:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 958AF613B7;
        Tue, 13 Apr 2021 07:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618300585;
        bh=Db91jAp9otYq+4ZPotJ9/HrzmEzHJg35UdP86+kSBd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VfCQAx1oPubtUs79/vawLaPID7RkmbQVZ+vY4Tm7lFF9xTk6bpRZKLe7j6BKtmNFc
         Ze7Phbrg3BgT6/Ts61LZX7KV88J7OkBm/EZzsGFO31s5jS8rPbGEPF590bbROnaGDf
         jKg3vR8x7us4rZEnNs2udrHD2MWdOcL9oP3mHbrJ08O0xSOuYBf06h8nqMVKgIz3Mz
         QEESQ16+KGqt0hoSvB9gHo2vN8HspyYXnio9sJMVR5/O2x+ngJwOxZV8XtWYvHwG9O
         99Z4oJJGsr1Eh5UcvGme2ctAuTWdZZQVmaL85+e0u+QPxFCPfVw+AJPvzrejmQinHe
         xoEnYom37zTwQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@armlinux.org.uk>, kuba@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next 4/5] net: dsa: mv88e6xxx: simulate Amethyst PHY model number
Date:   Tue, 13 Apr 2021 09:55:37 +0200
Message-Id: <20210413075538.30175-5-kabel@kernel.org>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210413075538.30175-1-kabel@kernel.org>
References: <20210413075538.30175-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Amethyst internal PHYs also report empty model number in MII_PHYSID2.

Fill in switch product number, as is done for Topaz and Peridot.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 860dca41cf4b..9c4f8517c34b 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3165,6 +3165,7 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
 static const u16 family_prod_id_table[] = {
 	[MV88E6XXX_FAMILY_6341] = MV88E6XXX_PORT_SWITCH_ID_PROD_6341,
 	[MV88E6XXX_FAMILY_6390] = MV88E6XXX_PORT_SWITCH_ID_PROD_6390,
+	[MV88E6XXX_FAMILY_6393] = MV88E6XXX_PORT_SWITCH_ID_PROD_6393X,
 };
 
 static int mv88e6xxx_mdio_read(struct mii_bus *bus, int phy, int reg)
-- 
2.26.3

