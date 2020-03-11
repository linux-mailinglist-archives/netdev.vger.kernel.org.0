Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 703BB181458
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 10:16:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728488AbgCKJQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 05:16:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48845 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbgCKJQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 05:16:18 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jBxTK-0007E7-1v; Wed, 11 Mar 2020 09:16:14 +0000
From:   Colin King <colin.king@canonical.com>
To:     Alex Elder <elder@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] soc: qcom: ipa: fix spelling mistake "cahces" -> "caches"
Date:   Wed, 11 Mar 2020 09:16:13 +0000
Message-Id: <20200311091613.75613-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in a dev_err message. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ipa/ipa_modem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ipa/ipa_modem.c b/drivers/net/ipa/ipa_modem.c
index 039afc8c608e..55c9329a4b1d 100644
--- a/drivers/net/ipa/ipa_modem.c
+++ b/drivers/net/ipa/ipa_modem.c
@@ -293,7 +293,7 @@ static void ipa_modem_crashed(struct ipa *ipa)
 
 	ret = ipa_table_hash_flush(ipa);
 	if (ret)
-		dev_err(dev, "error %d flushing hash cahces\n", ret);
+		dev_err(dev, "error %d flushing hash caches\n", ret);
 
 	ret = ipa_endpoint_modem_exception_reset_all(ipa);
 	if (ret)
-- 
2.25.1

