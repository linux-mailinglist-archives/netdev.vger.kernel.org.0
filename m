Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84A7349D35F
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 21:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiAZUYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 15:24:32 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35644 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiAZUYa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 15:24:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A81D617CB
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 20:24:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C17C340E3;
        Wed, 26 Jan 2022 20:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643228669;
        bh=1KF5+bWp5dV4HX303NnSUEZxbGsPOAB2uXurM9YCikY=;
        h=From:To:Cc:Subject:Date:From;
        b=N6lfq2Ceo8b0pxuzDkZXCJ44l4UTbPkO6toslPC2obroTJJ52xLd2/SwgZkQfRs9I
         XNdMKmeaqmx4qLR54UzUYQDK2MxYJNr1cly4yjhQCtvEagKULFngmF8kG2s2VMcmTD
         LvdF3xxOVojOFVMn7vaDjhnFKfSv0E0enbR5GLmEzIm5JFf1CqOVONF//nQIjPI32U
         W1v+zN2IpM7FnZ/1kCIgqAmYhRHHLfE87ZTwjT1Xv582zNa7AKATESf142UNpG8BHS
         V1/kqiRqg7tOk9yuDuxh9wGqFv6LNHOjRLT/EpFN94BQeKIgIZ9+B1A35wpVtQngxa
         hd1MUUwSfkCAA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        inux@armlinux.org.uk, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] MAINTAINERS: add more files to eth PHY
Date:   Wed, 26 Jan 2022 12:24:24 -0800
Message-Id: <20220126202424.2982084-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

include/linux/linkmode.h and include/linux/mii.h
do not match anything in MAINTAINERS. Looks like
they should be under Ethernet PHY.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0d7883977e9b..3e22999669c4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7216,8 +7216,10 @@ F:	drivers/net/mdio/of_mdio.c
 F:	drivers/net/pcs/
 F:	drivers/net/phy/
 F:	include/dt-bindings/net/qca-ar803x.h
+F:	include/linux/linkmode.h
 F:	include/linux/*mdio*.h
 F:	include/linux/mdio/*.h
+F:	include/linux/mii.h
 F:	include/linux/of_net.h
 F:	include/linux/phy.h
 F:	include/linux/phy_fixed.h
-- 
2.34.1

