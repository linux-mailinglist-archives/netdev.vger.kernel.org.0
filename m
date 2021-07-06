Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 937AE3BD039
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232968AbhGFLcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:32:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:35636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235016AbhGFL3d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:29:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B95A61CD6;
        Tue,  6 Jul 2021 11:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570432;
        bh=6rF2GL9WIIQWkZO/BED3ShKt4VEZx8DQg4Uu0Zr1E20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tdpboa9M8ysKmMAKfkG2FLYyn5K6YrtbAMw6/tJ2ykDX9N/wlRHp0uHxZYFS5q/Cq
         +Jz+X+ZeZR//FCv2x+L7FiqZGBw17SYXmD2jY3rJ2khWmOpB+7I1jixEqxYIfxrF7E
         qqSvhmCrJFyxHoi2wI3tsFMZDka9DB2B/bR97OuQYNOY5nTwVQLwZXvJ8uhsGxDH9K
         /JMC+rZw+tg9r1n+/HYXVGMz6Ya5IEdT97UY13mR3Q+eBLVZO/uE6t4LdGsnY26jKp
         o3yuPovD9gvkW8+MPFO5gvXug8A7CbXoOiyyYPlamPwJKNfIKZvh8IL3PaJ0DIwmct
         eTJWloLtHpmHA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 094/160] cw1200: add missing MODULE_DEVICE_TABLE
Date:   Tue,  6 Jul 2021 07:17:20 -0400
Message-Id: <20210706111827.2060499-94-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

[ Upstream commit dd778f89225cd258e8f0fed2b7256124982c8bb5 ]

This patch adds missing MODULE_DEVICE_TABLE definition which generates
correct modalias for automatic loading of this driver when it is built
as an external module.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1620788714-14300-1-git-send-email-zou_wei@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/st/cw1200/cw1200_sdio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/st/cw1200/cw1200_sdio.c b/drivers/net/wireless/st/cw1200/cw1200_sdio.c
index b65ec14136c7..4c30b5772ce0 100644
--- a/drivers/net/wireless/st/cw1200/cw1200_sdio.c
+++ b/drivers/net/wireless/st/cw1200/cw1200_sdio.c
@@ -53,6 +53,7 @@ static const struct sdio_device_id cw1200_sdio_ids[] = {
 	{ SDIO_DEVICE(SDIO_VENDOR_ID_STE, SDIO_DEVICE_ID_STE_CW1200) },
 	{ /* end: all zeroes */			},
 };
+MODULE_DEVICE_TABLE(sdio, cw1200_sdio_ids);
 
 /* hwbus_ops implemetation */
 
-- 
2.30.2

