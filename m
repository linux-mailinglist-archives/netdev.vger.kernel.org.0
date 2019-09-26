Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE1CBF0E6
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 13:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbfIZLNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 07:13:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53060 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfIZLNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 07:13:08 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1iDRhq-0003X9-Ad; Thu, 26 Sep 2019 11:13:06 +0000
From:   Colin King <colin.king@canonical.com>
To:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] NFC: st95hf: clean up indentation issue
Date:   Thu, 26 Sep 2019 12:13:06 +0100
Message-Id: <20190926111306.17409-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The return statement is indented incorrectly, add in a missing
tab and remove an extraneous space after the return

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/nfc/st95hf/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/st95hf/core.c b/drivers/nfc/st95hf/core.c
index ce38782ebf80..291efff048af 100644
--- a/drivers/nfc/st95hf/core.c
+++ b/drivers/nfc/st95hf/core.c
@@ -661,7 +661,7 @@ static int st95hf_error_handling(struct st95hf_context *stcontext,
 			result = -ETIMEDOUT;
 		else
 			result = -EIO;
-	return  result;
+		return result;
 	}
 
 	/* Check for CRC err only if CRC is present in the tag response */
-- 
2.20.1

