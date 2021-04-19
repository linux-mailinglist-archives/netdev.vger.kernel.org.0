Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5D8B364C25
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 22:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242915AbhDSUs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 16:48:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:54660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242766AbhDSUq5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 16:46:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12727613C0;
        Mon, 19 Apr 2021 20:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618865129;
        bh=fRKMYZvYhGVmJMK3RmuKLhM0C0YEvl0xVllUaPM6n1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k3b0L6C8jWdRJG6TB0C5Uj6n/rLZGEqPoEGz9XDObvgPdlsV0e1dEiXqjzUsQ2Mvh
         EF8psc4RjQ6y2Cdd7kPoBEsmznoyGjpaTmV7FrYo11QRMhqhoE0cq0cGCe4UfaA9Q/
         BcniY6SnneB9IE7iEmBeZlS/nvDchtiin8bHe0eKDzli7/KQaoTkudSr8pW8TKNboT
         Hj+gI6NZcdsn/3gFk/fmgyL5IITBQmjY+/3LLqYgvwi7AwIKg/guC3KwAb0BTTwpDY
         W7leHyYnb4hmgr0wfadQFCma0Nc8zUBs06TLBIdMa+yNNe+z0HF/rQRrVfTCeD9/qF
         TWDJ+7ERJxHEQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wan Jiabing <wanjiabing@vivo.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 08/12] cavium/liquidio: Fix duplicate argument
Date:   Mon, 19 Apr 2021 16:45:13 -0400
Message-Id: <20210419204517.6770-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210419204517.6770-1-sashal@kernel.org>
References: <20210419204517.6770-1-sashal@kernel.org>
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
index b248966837b4..7aad40b2aa73 100644
--- a/drivers/net/ethernet/cavium/liquidio/cn66xx_regs.h
+++ b/drivers/net/ethernet/cavium/liquidio/cn66xx_regs.h
@@ -412,7 +412,7 @@
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

