Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE4D723DC1F
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 18:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729255AbgHFQq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 12:46:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50785 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729278AbgHFQqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 12:46:13 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1k3esI-0004GH-HC; Thu, 06 Aug 2020 12:19:58 +0000
From:   Colin King <colin.king@canonical.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ath6kl: fix spelling mistake "initilisation" -> "initialization"
Date:   Thu,  6 Aug 2020 13:19:58 +0100
Message-Id: <20200806121958.60700-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in an ath6kl_err error message. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/ath/ath6kl/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 811fad6d60c0..39bf19686175 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1752,7 +1752,7 @@ static int __ath6kl_init_hw_start(struct ath6kl *ar)
 
 	ret = ath6kl_init_service_ep(ar);
 	if (ret) {
-		ath6kl_err("Endpoint service initilisation failed: %d\n", ret);
+		ath6kl_err("Endpoint service initialization failed: %d\n", ret);
 		goto err_cleanup_scatter;
 	}
 
-- 
2.27.0

