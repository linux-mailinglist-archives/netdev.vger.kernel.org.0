Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0CC326EE66
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 04:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgIRC2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 22:28:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:44298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729226AbgIRCP1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 22:15:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C60FB23976;
        Fri, 18 Sep 2020 02:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395326;
        bh=KuIx02ZLQcHtYc60sO8az7nsmu847tanrJ4N/NEnmhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ps+FMomPM6tJvPklac9miQBbP2cD7KSY9SkfPawo9UWXldyndvusllujaTqASpMWx
         ambUcJAg3yMOd7NR7zx+gMPx+bK7BXFEuFnbqHyeS1lkR9+jurM4WaiILL7B7uXr7d
         tvdrxskq3SgP+E3AUZIxY+abHLUklfHaInqp9T2U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mert Dirik <mertdirik@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 27/90] ar5523: Add USB ID of SMCWUSBT-G2 wireless adapter
Date:   Thu, 17 Sep 2020 22:13:52 -0400
Message-Id: <20200918021455.2067301-27-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918021455.2067301-1-sashal@kernel.org>
References: <20200918021455.2067301-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mert Dirik <mertdirik@gmail.com>

[ Upstream commit 5b362498a79631f283578b64bf6f4d15ed4cc19a ]

Add the required USB ID for running SMCWUSBT-G2 wireless adapter (SMC
"EZ Connect g").

This device uses ar5523 chipset and requires firmware to be loaded. Even
though pid of the device is 4507, this patch adds it as 4506 so that
AR5523_DEVICE_UG macro can set the AR5523_FLAG_PRE_FIRMWARE flag for pid
4507.

Signed-off-by: Mert Dirik <mertdirik@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ar5523/ar5523.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ar5523/ar5523.c b/drivers/net/wireless/ath/ar5523/ar5523.c
index e492c7f0d311a..9f4ee1d125b68 100644
--- a/drivers/net/wireless/ath/ar5523/ar5523.c
+++ b/drivers/net/wireless/ath/ar5523/ar5523.c
@@ -1769,6 +1769,8 @@ static struct usb_device_id ar5523_id_table[] = {
 	AR5523_DEVICE_UX(0x0846, 0x4300),	/* Netgear / WG111U */
 	AR5523_DEVICE_UG(0x0846, 0x4250),	/* Netgear / WG111T */
 	AR5523_DEVICE_UG(0x0846, 0x5f00),	/* Netgear / WPN111 */
+	AR5523_DEVICE_UG(0x083a, 0x4506),	/* SMC / EZ Connect
+						   SMCWUSBT-G2 */
 	AR5523_DEVICE_UG(0x157e, 0x3006),	/* Umedia / AR5523_1 */
 	AR5523_DEVICE_UX(0x157e, 0x3205),	/* Umedia / AR5523_2 */
 	AR5523_DEVICE_UG(0x157e, 0x3006),	/* Umedia / TEW444UBEU */
-- 
2.25.1

