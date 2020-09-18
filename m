Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E841027088D
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 23:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbgIRVv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 17:51:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50920 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgIRVv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 17:51:28 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kJOHu-0004pb-B5; Fri, 18 Sep 2020 21:51:26 +0000
From:   Colin King <colin.king@canonical.com>
To:     Thomas Graf <tgraf@suug.ch>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] rhashtable: fix indentation of a continue statement
Date:   Fri, 18 Sep 2020 22:51:26 +0100
Message-Id: <20200918215126.49236-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

A continue statement is indented incorrectly, add in the missing
tab.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 lib/test_rhashtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/test_rhashtable.c b/lib/test_rhashtable.c
index c5a6fef7b45d..76c607ee6db5 100644
--- a/lib/test_rhashtable.c
+++ b/lib/test_rhashtable.c
@@ -434,7 +434,7 @@ static int __init test_rhltable(unsigned int entries)
 		} else {
 			if (WARN(err != -ENOENT, "removed non-existent element, error %d not %d",
 				 err, -ENOENT))
-			continue;
+				continue;
 		}
 	}
 
-- 
2.27.0

