Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF6245A891
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 17:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234748AbhKWQoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 11:44:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:47752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233715AbhKWQnx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 11:43:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 289DC60F90;
        Tue, 23 Nov 2021 16:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637685644;
        bh=1g0Fb2Uk/jOxx7QzT7TJ5TjvwLuxkudnvVugm9DJ5aU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GKbC+NeayyQznFDs30JjAr248TMNCtrwI9prQDFJzEgerx9KH8ooEjAOw9LixrJBM
         NVTp38vxWp3sRpeeZ0IQcfEzCURULRQbkTqNQE53v72LFwyNcj4gCAP1x2HhmniEXB
         5h+S97G3gV4vn2KS5fDpWmsmH0qKYlOyL5XUmEhbTcaMoyrZSpQUc/etHe9DhIkRR+
         bJvrzzQ/C4jVvf1YVtgMXoCbYuIURAOkiqbfgG3fmBH27rJhrV+fJGBukGNlFdLOC7
         dsIJ9YDe8S+r17avzCYlyWLy/aYg2gatdaM5tAYxTF0DAnmiSbmX1W6shkgT/10OqK
         WDiZwfvoIGoXQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Cc:     Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Sean Anderson <sean.anderson@seco.com>, davem@davemloft.net,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v2 6/8] net: phy: marvell10g: Use generic macro for supported interfaces
Date:   Tue, 23 Nov 2021 17:40:25 +0100
Message-Id: <20211123164027.15618-7-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211123164027.15618-1-kabel@kernel.org>
References: <20211123164027.15618-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that phy.h defines macro DECLARE_PHY_INTERFACE_MASK(), use it
instead of DECLARE_BITMAP().

Signed-off-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/marvell10g.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index b6fea119fe13..d289641190db 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -148,7 +148,7 @@ struct mv3310_chip {
 };
 
 struct mv3310_priv {
-	DECLARE_BITMAP(supported_interfaces, PHY_INTERFACE_MODE_MAX);
+	DECLARE_PHY_INTERFACE_MASK(supported_interfaces);
 
 	u32 firmware_ver;
 	bool has_downshift;
-- 
2.32.0

