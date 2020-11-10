Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 979422ACCCD
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 04:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733251AbgKJD5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 22:57:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:59218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387811AbgKJD5B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 22:57:01 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F4EB207BC;
        Tue, 10 Nov 2020 03:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604980621;
        bh=8XF7R//Yl6NH0VxVXke17EfNRQeotPb3MfGtIMyT23U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j6S0Dms0ZvF84s1Ds9SKMFfCGMzO/Fsy1ixlXLGExb/3QRv37C60o26pRNJqRNKxR
         NvkZXHpOPnYVSZx6SQDmozkWQqZlwFRKBIuVHvEy+LrQOEavf5cJ7YkpQRoxWmNqAD
         uk7ojGDVxx6eaoZQEsZHmkuU+Ig17Avo+rgup9ns=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ye Bin <yebin10@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 07/10] cfg80211: regulatory: Fix inconsistent format argument
Date:   Mon,  9 Nov 2020 22:56:48 -0500
Message-Id: <20201110035651.425177-7-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201110035651.425177-1-sashal@kernel.org>
References: <20201110035651.425177-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ye Bin <yebin10@huawei.com>

[ Upstream commit db18d20d1cb0fde16d518fb5ccd38679f174bc04 ]

Fix follow warning:
[net/wireless/reg.c:3619]: (warning) %d in format string (no. 2)
requires 'int' but the argument type is 'unsigned int'.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Ye Bin <yebin10@huawei.com>
Link: https://lore.kernel.org/r/20201009070215.63695-1-yebin10@huawei.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/reg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 474923175b108..dcbf5cd44bb37 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2775,7 +2775,7 @@ static void print_rd_rules(const struct ieee80211_regdomain *rd)
 		power_rule = &reg_rule->power_rule;
 
 		if (reg_rule->flags & NL80211_RRF_AUTO_BW)
-			snprintf(bw, sizeof(bw), "%d KHz, %d KHz AUTO",
+			snprintf(bw, sizeof(bw), "%d KHz, %u KHz AUTO",
 				 freq_range->max_bandwidth_khz,
 				 reg_get_max_bandwidth(rd, reg_rule));
 		else
-- 
2.27.0

