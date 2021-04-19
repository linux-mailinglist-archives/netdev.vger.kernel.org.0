Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1725364C8B
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 22:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242976AbhDSUwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 16:52:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:54916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242072AbhDSUuI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 16:50:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C316613D4;
        Mon, 19 Apr 2021 20:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618865175;
        bh=zAq6j4WNvL9szHvvi6C/GiCYwJFCVoonCOJU8D4FLjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=axP6j/Stra6pzHXjSv0g0Eev/gmn7YSktlVhf/1lePH3zZyN20L0HCcQftQK/z62C
         4I+5o3Ism/jtel9iC9YGCbF+9YMAgpuMCCNbzXIYtSZ+Zx1cBPoJSoWOBxj+3JZ2M6
         rYixF9jgknEwuFyOjE8C0yOOsXNJg9Xf7/gxUC5nu0t/bd64TvMRyFqKfEJc3zsTIf
         ZiMAoZOBSDY1GJuPXuLe/Y/95Dswy7qUVJrRzNwkUK8kUyxFnBw9pCOGvvn8+HgZOE
         bDJFrGgcqv0oKMbDDJI2lhHEYPq2YFTE2V2p+l6COmmio1RyTnamjePYEs0jVORMoh
         sMVjHT3w5PA2w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wan Jiabing <wanjiabing@vivo.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 4/7] cavium/liquidio: Fix duplicate argument
Date:   Mon, 19 Apr 2021 16:46:05 -0400
Message-Id: <20210419204608.7191-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210419204608.7191-1-sashal@kernel.org>
References: <20210419204608.7191-1-sashal@kernel.org>
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

