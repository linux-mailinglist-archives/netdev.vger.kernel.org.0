Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38B12145FC6
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 01:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbgAWASH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 19:18:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52423 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbgAWASG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 19:18:06 -0500
Received: from [82.43.126.140] (helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1iuQCA-0002zx-6K; Thu, 23 Jan 2020 00:18:02 +0000
From:   Colin King <colin.king@canonical.com>
To:     Pontus Fuchs <pontus.fuchs@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ar5523: fix spelling mistake "to" -> "too"
Date:   Thu, 23 Jan 2020 00:18:01 +0000
Message-Id: <20200123001801.2831921-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in a ar5523_err message. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/ath/ar5523/ar5523.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ar5523/ar5523.c b/drivers/net/wireless/ath/ar5523/ar5523.c
index da2d179430ca..f4a04d88bd3f 100644
--- a/drivers/net/wireless/ath/ar5523/ar5523.c
+++ b/drivers/net/wireless/ath/ar5523/ar5523.c
@@ -74,7 +74,7 @@ static void ar5523_read_reply(struct ar5523 *ar, struct ar5523_cmd_hdr *hdr,
 
 	if (cmd->odata) {
 		if (cmd->olen < olen) {
-			ar5523_err(ar, "olen to small %d < %d\n",
+			ar5523_err(ar, "olen too small %d < %d\n",
 				   cmd->olen, olen);
 			cmd->olen = 0;
 			cmd->res = -EOVERFLOW;
-- 
2.24.0

