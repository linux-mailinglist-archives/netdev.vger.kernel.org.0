Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6284364BFF
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 22:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243054AbhDSUsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 16:48:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:54422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240843AbhDSUqM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 16:46:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58E3461104;
        Mon, 19 Apr 2021 20:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618865107;
        bh=fRKMYZvYhGVmJMK3RmuKLhM0C0YEvl0xVllUaPM6n1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MYQFiyMG5JFmrRKiit6Baux195Q0OzFVMgs+3Y5MUFSNBfvXDiNitnd2wyLcuCXH+
         SJJA4zxsmQj/l25C3IASlZOZLfzzxZmh5okBSHhauWhHPjj4IfVQZ+EUsVJGXx1tNy
         U38f5xdFK2Knr7R2CNe7zEVVDci3cLvmdWEOg9haLAMQN6vOMlbGUin4vWXbGrhs7T
         qxZ6Fp9YnjEq5mhZlUH10ayQEd5Z4loXS2PpyniG2V9npPibaiUmVUha3LQ//Clmkb
         8knCtMg0pbAmG9rAl/IWbxy9bSg4W07A602/lZ007ngN7vuZXgE0vRCXqMJJMpy4qe
         l1lHCzjd0iNZQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wan Jiabing <wanjiabing@vivo.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 08/14] cavium/liquidio: Fix duplicate argument
Date:   Mon, 19 Apr 2021 16:44:48 -0400
Message-Id: <20210419204454.6601-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210419204454.6601-1-sashal@kernel.org>
References: <20210419204454.6601-1-sashal@kernel.org>
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

