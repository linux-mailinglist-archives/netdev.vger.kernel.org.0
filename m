Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC2E31B6FFE
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 10:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgDXIro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 04:47:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42709 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbgDXIro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 04:47:44 -0400
Received: from [82.43.126.140] (helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jRtzi-0006wM-2t; Fri, 24 Apr 2020 08:47:34 +0000
From:   Colin King <colin.king@canonical.com>
To:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] rtw88: fix spelling mistake "fimrware" -> "firmware"
Date:   Fri, 24 Apr 2020 09:47:33 +0100
Message-Id: <20200424084733.7716-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are spelling mistakes in two rtw_err error messages. Fix them.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/realtek/rtw88/mac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/mac.c b/drivers/net/wireless/realtek/rtw88/mac.c
index 645207a01525..056b08b9f06c 100644
--- a/drivers/net/wireless/realtek/rtw88/mac.c
+++ b/drivers/net/wireless/realtek/rtw88/mac.c
@@ -829,7 +829,7 @@ download_firmware_legacy(struct rtw_dev *rtwdev, const u8 *data, u32 size)
 		write_firmware_page(rtwdev, page, data, last_page_size);
 
 	if (!check_hw_ready(rtwdev, REG_MCUFW_CTRL, BIT_FWDL_CHK_RPT, 1)) {
-		rtw_err(rtwdev, "failed to check download fimrware report\n");
+		rtw_err(rtwdev, "failed to check download firmware report\n");
 		return -EINVAL;
 	}
 
@@ -856,7 +856,7 @@ static int download_firmware_validate_legacy(struct rtw_dev *rtwdev)
 		msleep(20);
 	}
 
-	rtw_err(rtwdev, "failed to validate fimrware\n");
+	rtw_err(rtwdev, "failed to validate firmware\n");
 	return -EINVAL;
 }
 
-- 
2.25.1

