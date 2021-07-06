Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62BF33BD5EB
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 14:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344519AbhGFM0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 08:26:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:47624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234657AbhGFLgc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:36:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B2FD61DA8;
        Tue,  6 Jul 2021 11:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570956;
        bh=/XRd8tULFtrzaCZ6URnc8c+qKudLE1jX9tJAc3DmZao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S3I9JGsAZtqKXx3OdHc1z5sIiZMYZoPwh8ifMVLE8bBkmRlTNhSQ5AZjBej+CgHsi
         IETq+kRyN/8DbgxfCzvB+u7dPOFmjCc0vltpMAx2lcZfHhps/HOOqHKnwfvsgfCCvM
         XNniMcR5j7ao6leXsiM0EF11HdbwIR2TIOZA6eQa4QKzdIAT5RkP6Fveq5rVIcG4FG
         TLnODBxfzS4f0bM9uk/ddhda3zftpU6UD5mt3XSmUX7JCVF0irG5KYMgTE+rtUkpRz
         1aFLOeyJNlE4v8Z9jEnrD2oqA4cpl9ec8rmoMKvKvtl8IzqiPvHzjXqf/BcP471owv
         mTF6S4UlUiZNw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 23/35] cw1200: add missing MODULE_DEVICE_TABLE
Date:   Tue,  6 Jul 2021 07:28:35 -0400
Message-Id: <20210706112848.2066036-23-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112848.2066036-1-sashal@kernel.org>
References: <20210706112848.2066036-1-sashal@kernel.org>
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
index d3acc85932a5..de92107549ee 100644
--- a/drivers/net/wireless/st/cw1200/cw1200_sdio.c
+++ b/drivers/net/wireless/st/cw1200/cw1200_sdio.c
@@ -62,6 +62,7 @@ static const struct sdio_device_id cw1200_sdio_ids[] = {
 	{ SDIO_DEVICE(SDIO_VENDOR_ID_STE, SDIO_DEVICE_ID_STE_CW1200) },
 	{ /* end: all zeroes */			},
 };
+MODULE_DEVICE_TABLE(sdio, cw1200_sdio_ids);
 
 /* hwbus_ops implemetation */
 
-- 
2.30.2

