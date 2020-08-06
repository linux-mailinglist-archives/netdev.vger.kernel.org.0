Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B60B23DC21
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 18:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729350AbgHFQqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 12:46:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50790 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729164AbgHFQq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 12:46:26 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1k3egl-0003Dm-JH; Thu, 06 Aug 2020 12:08:03 +0000
From:   Colin King <colin.king@canonical.com>
To:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] rtw88: fix spelling mistake: "unsupport" -> "unsupported"
Date:   Thu,  6 Aug 2020 13:08:03 +0100
Message-Id: <20200806120803.60113-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are some spelling mistakes in rtw_info messages. Fix these.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/realtek/rtw88/rtw8822b.c | 4 ++--
 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822b.c b/drivers/net/wireless/realtek/rtw88/rtw8822b.c
index 351cd055a295..b7a98dbbb09c 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822b.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822b.c
@@ -1009,12 +1009,12 @@ static int rtw8822b_set_antenna(struct rtw_dev *rtwdev,
 		antenna_tx, antenna_rx);
 
 	if (!rtw8822b_check_rf_path(antenna_tx)) {
-		rtw_info(rtwdev, "unsupport tx path 0x%x\n", antenna_tx);
+		rtw_info(rtwdev, "unsupported tx path 0x%x\n", antenna_tx);
 		return -EINVAL;
 	}
 
 	if (!rtw8822b_check_rf_path(antenna_rx)) {
-		rtw_info(rtwdev, "unsupport rx path 0x%x\n", antenna_rx);
+		rtw_info(rtwdev, "unsupported rx path 0x%x\n", antenna_rx);
 		return -EINVAL;
 	}
 
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
index 426808413baa..ed1c14af082b 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -2014,7 +2014,7 @@ static int rtw8822c_set_antenna(struct rtw_dev *rtwdev,
 	case BB_PATH_AB:
 		break;
 	default:
-		rtw_info(rtwdev, "unsupport tx path 0x%x\n", antenna_tx);
+		rtw_info(rtwdev, "unsupported tx path 0x%x\n", antenna_tx);
 		return -EINVAL;
 	}
 
@@ -2024,7 +2024,7 @@ static int rtw8822c_set_antenna(struct rtw_dev *rtwdev,
 	case BB_PATH_AB:
 		break;
 	default:
-		rtw_info(rtwdev, "unsupport rx path 0x%x\n", antenna_rx);
+		rtw_info(rtwdev, "unsupported rx path 0x%x\n", antenna_rx);
 		return -EINVAL;
 	}
 
-- 
2.27.0

