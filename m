Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55C92146493
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 10:27:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727194AbgAWJ1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 04:27:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36350 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbgAWJ1h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 04:27:37 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1iuYlv-0007Zz-54; Thu, 23 Jan 2020 09:27:31 +0000
From:   Colin King <colin.king@canonical.com>
To:     Ralf Baechle <ralf@linux-mips.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][V2] net/rose: fix spelling mistake "to" -> "too"
Date:   Thu, 23 Jan 2020 09:27:30 +0000
Message-Id: <20200123092730.10909-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in a printk message. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
V2: split the patch, the V1 included another fix.
---
 net/rose/af_rose.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index 46b8ff24020d..1e8eeb044b07 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -1475,7 +1475,7 @@ static int __init rose_proto_init(void)
 	int rc;
 
 	if (rose_ndevs > 0x7FFFFFFF/sizeof(struct net_device *)) {
-		printk(KERN_ERR "ROSE: rose_proto_init - rose_ndevs parameter to large\n");
+		printk(KERN_ERR "ROSE: rose_proto_init - rose_ndevs parameter too large\n");
 		rc = -EINVAL;
 		goto out;
 	}
-- 
2.24.0

