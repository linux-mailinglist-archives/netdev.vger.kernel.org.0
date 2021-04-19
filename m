Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D94F6364BC4
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 22:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242854AbhDSUqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 16:46:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:55042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240473AbhDSUpT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 16:45:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9948A613C5;
        Mon, 19 Apr 2021 20:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618865081;
        bh=fRKMYZvYhGVmJMK3RmuKLhM0C0YEvl0xVllUaPM6n1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dt+QjnConBhgbRHdb6uQOboobm6KbnPSjYkoeNLHMetmYO3KmokZElgwA9TbhJdBL
         /c8NseTM490Qq5Z8B8Sd7p/3E0ulnjKz9xNS/mOwzIvZ8EkZTfJQ2OjJcm+oT3tfKZ
         PGqlqCNmd0WaSyBpyCt6ZkhiSRSmi1Hk46/RT2lkB1Ei0ursp8Jd3QT6WlFJ/bt0jj
         sKV+Ga5zf6+eZRn5hJafBfoBC2Ll9zE1o4d5m2XfC/BuUO3DgWmEGNzLrEteUmQvtB
         TuMOCy5OBOFb7qKydE4uJlPQhuwRcBaB0LWB7KrJM9uikuThb6efzAvwnWHP24zvck
         p+ZBfz0XjUyUQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wan Jiabing <wanjiabing@vivo.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 14/21] cavium/liquidio: Fix duplicate argument
Date:   Mon, 19 Apr 2021 16:44:12 -0400
Message-Id: <20210419204420.6375-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210419204420.6375-1-sashal@kernel.org>
References: <20210419204420.6375-1-sashal@kernel.org>
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

