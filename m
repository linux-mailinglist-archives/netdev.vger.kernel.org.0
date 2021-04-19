Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A957364C70
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 22:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240843AbhDSUuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 16:50:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:54660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234434AbhDSUsx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 16:48:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6796C613C9;
        Mon, 19 Apr 2021 20:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618865163;
        bh=zAq6j4WNvL9szHvvi6C/GiCYwJFCVoonCOJU8D4FLjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eRtVGQtoxQdSZwr+xv6+gkmlxxXlL942raJSBmRSSZdko5yDegR+HQvXAQftvXk06
         Zdjn2bf25rSKjz9ajM47bqPN+ndQm/Up7DHLbBTqPmMMJGx08zm6ePWjWHMM+20SzU
         4uOZbQyRDq+jZDgOyAZM5mCkK1LG63Qut459IpBMPffVRN9VLvMpCMuJN5P81Ib6JA
         Ezav4lepS4lTs/I+Utif2O9Qqpep1VneMv2lfZySN+5Z0F85NEUyiq0BMRnP5vSwto
         InI1joynyNcSLxc8SB+0PTbRz1jSii5rfeYlRLam+71e6xen3Lr5xLM4FdJKG9V/fn
         Orn5h8RIT7d3A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wan Jiabing <wanjiabing@vivo.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 5/8] cavium/liquidio: Fix duplicate argument
Date:   Mon, 19 Apr 2021 16:45:51 -0400
Message-Id: <20210419204554.7071-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210419204554.7071-1-sashal@kernel.org>
References: <20210419204554.7071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wan Jiabing <wanjiabing@vivo.com>

[ Upstream commit 416dcc5ce9d2a810477171c62ffa061a98f87367 ]

Fix the following coccicheck warning:

./drivers/net/ethernet/cavium/liquidio/cn66xx_regs.h:413:6-28:
duplicated argument to & or |

The CN6XXX_INTR_M1UPB0_ERR here is duplicate.
Here should be CN6XXX_INTR_M1UNB0_ERR.

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cavium/liquidio/cn66xx_regs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/cn66xx_regs.h b/drivers/net/ethernet/cavium/liquidio/cn66xx_regs.h
index 5e3aff242ad3..3ab84d18ad3a 100644
--- a/drivers/net/ethernet/cavium/liquidio/cn66xx_regs.h
+++ b/drivers/net/ethernet/cavium/liquidio/cn66xx_regs.h
@@ -417,7 +417,7 @@
 	   | CN6XXX_INTR_M0UNWI_ERR             \
 	   | CN6XXX_INTR_M1UPB0_ERR             \
 	   | CN6XXX_INTR_M1UPWI_ERR             \
-	   | CN6XXX_INTR_M1UPB0_ERR             \
+	   | CN6XXX_INTR_M1UNB0_ERR             \
 	   | CN6XXX_INTR_M1UNWI_ERR             \
 	   | CN6XXX_INTR_INSTR_DB_OF_ERR        \
 	   | CN6XXX_INTR_SLIST_DB_OF_ERR        \
-- 
2.30.2

