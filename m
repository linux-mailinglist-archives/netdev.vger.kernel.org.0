Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE54355EA1
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 00:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242585AbhDFWMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 18:12:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:52796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344115AbhDFWMY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 18:12:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65C08613DE;
        Tue,  6 Apr 2021 22:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617747135;
        bh=jOgLdvDFW2zfR7Otnfjh5CaRO0BlvQ1igdZOgpzUOvA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OhohBSyiZCd+zN0DkvDrwTjycNYyNFDy+q49RXqym+j+0NqRfe21t7lWtXEElt8SZ
         d1hqC3zg2bd00Mv22LrS/gkClRMgohb24MiAInXhDSnP+3MJfb/sMe2dYUQY2NZzQW
         6J/vE4rfjvniKaxtk1jBEtJKg6PaqJ4yr5Nbdd6Gwjf0oLKiyRn0D7p/BZimu8IkFK
         jFFBaA0le6GsJYUduFVWiRjj7nhIR9I7V3SZLFbLsJlyEfsX+AQyKIl8I3VQUMLAR3
         UhEUL4WcNNsaHRkg9kpYwudfMAN7OnGJdHP83V0NEqoZXfhiud0hQdPEecrzJ2tj4S
         9K76pbx7ocbfA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kuba@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v3 18/18] MAINTAINERS: add myself as maintainer of marvell10g driver
Date:   Wed,  7 Apr 2021 00:11:07 +0200
Message-Id: <20210406221107.1004-19-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210406221107.1004-1-kabel@kernel.org>
References: <20210406221107.1004-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add myself as maintainer of the marvell10g ethernet PHY driver, in
addition to Russell King.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 217c7470bfa9..3ea9539821b5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10695,6 +10695,7 @@ F:	include/linux/mv643xx.h
 
 MARVELL MV88X3310 PHY DRIVER
 M:	Russell King <linux@armlinux.org.uk>
+M:	Marek Behun <marek.behun@nic.cz>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/phy/marvell10g.c
-- 
2.26.2

