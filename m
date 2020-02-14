Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 897FC15E898
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 18:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404618AbgBNRBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 12:01:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:47216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392579AbgBNQQZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 11:16:25 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACA1724654;
        Fri, 14 Feb 2020 16:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696984;
        bh=Ryr712IRyEGx3V2UFQBgJGfJ7BJcj/Aea1W03uMesHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PRK5btVD30faSxIQ8DMuONDXMfI3/7qDDPg6IVUFqNPrYULViIO/+ZM+FdKxEMJ0B
         8ca7Sp3voZNKiIU3bZSXLsUnneu/nn80F0vuaqSob1nFMFsccnJ+83mSD01u00dTmM
         026YTBZbsGAUyt75s8rJN2zUhxWaBZzyAmEed63U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.19 220/252] hostap: Adjust indentation in prism2_hostapd_add_sta
Date:   Fri, 14 Feb 2020 11:11:15 -0500
Message-Id: <20200214161147.15842-220-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161147.15842-1-sashal@kernel.org>
References: <20200214161147.15842-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit b61156fba74f659d0bc2de8f2dbf5bad9f4b8faf ]

Clang warns:

../drivers/net/wireless/intersil/hostap/hostap_ap.c:2511:3: warning:
misleading indentation; statement is not part of the previous 'if'
[-Wmisleading-indentation]
        if (sta->tx_supp_rates & WLAN_RATE_5M5)
        ^
../drivers/net/wireless/intersil/hostap/hostap_ap.c:2509:2: note:
previous statement is here
        if (sta->tx_supp_rates & WLAN_RATE_2M)
        ^
1 warning generated.

This warning occurs because there is a space before the tab on this
line. Remove it so that the indentation is consistent with the Linux
kernel coding style and clang no longer warns.

Fixes: ff1d2767d5a4 ("Add HostAP wireless driver.")
Link: https://github.com/ClangBuiltLinux/linux/issues/813
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intersil/hostap/hostap_ap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intersil/hostap/hostap_ap.c b/drivers/net/wireless/intersil/hostap/hostap_ap.c
index 0094b1d2b5770..3ec46f48cfde1 100644
--- a/drivers/net/wireless/intersil/hostap/hostap_ap.c
+++ b/drivers/net/wireless/intersil/hostap/hostap_ap.c
@@ -2508,7 +2508,7 @@ static int prism2_hostapd_add_sta(struct ap_data *ap,
 		sta->supported_rates[0] = 2;
 	if (sta->tx_supp_rates & WLAN_RATE_2M)
 		sta->supported_rates[1] = 4;
- 	if (sta->tx_supp_rates & WLAN_RATE_5M5)
+	if (sta->tx_supp_rates & WLAN_RATE_5M5)
 		sta->supported_rates[2] = 11;
 	if (sta->tx_supp_rates & WLAN_RATE_11M)
 		sta->supported_rates[3] = 22;
-- 
2.20.1

