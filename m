Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4820049D255
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 20:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244372AbiAZTLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 14:11:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244363AbiAZTLR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 14:11:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 733A2C061748
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 11:11:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2DC3EB81FC6
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 19:11:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A524EC340ED;
        Wed, 26 Jan 2022 19:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643224274;
        bh=syYvUT/Fv+RJZyE/GYnJjTFISk1EdHYT3JrWghnwwoM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xy9N3vmgdx6tNAw3UcJfayEJEnZbDLzYJuqMDZmFsDoKRdUdL9zbmy7nwfhDriG0p
         2V1q02DGdEMcQOHh/9m72NGCR+p2Omz5q8v3nJxmNjopSjrcKosuBqOrdDPcw3tm0k
         98rlVSCoAg9CXGxXL31jL+uYShLdYas+Fo4tFNdzFluU+XxPwV0knbTgZDgR9qSIX/
         CDaCarBptDgwcne2w3cROdY6UUoI36qr/IAp8OoIvrNLxmgxd3euIQks+qG3duL/z2
         t0m7RZOjLvOQix/504s39fydGAyYBhrcSmKTYHPfsR4zUGa/fA1LkKPPVdltXdXzX9
         38Xix4wPFEGNg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH net-next 04/15] net: remove linkmode_change_bit()
Date:   Wed, 26 Jan 2022 11:10:58 -0800
Message-Id: <20220126191109.2822706-5-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126191109.2822706-1-kuba@kernel.org>
References: <20220126191109.2822706-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No callers since v5.7, the initial use case seems pretty
esoteric so removing this should not harm the completeness
of the API.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: Andrew Lunn <andrew@lunn.ch>
CC: Heiner Kallweit <hkallweit1@gmail.com>
CC: Russell King <linux@armlinux.org.uk>
---
 include/linux/linkmode.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/include/linux/linkmode.h b/include/linux/linkmode.h
index f8397f300fcd..15e0e0209da4 100644
--- a/include/linux/linkmode.h
+++ b/include/linux/linkmode.h
@@ -66,11 +66,6 @@ static inline void linkmode_mod_bit(int nr, volatile unsigned long *addr,
 		linkmode_clear_bit(nr, addr);
 }
 
-static inline void linkmode_change_bit(int nr, volatile unsigned long *addr)
-{
-	__change_bit(nr, addr);
-}
-
 static inline int linkmode_test_bit(int nr, const volatile unsigned long *addr)
 {
 	return test_bit(nr, addr);
-- 
2.34.1

