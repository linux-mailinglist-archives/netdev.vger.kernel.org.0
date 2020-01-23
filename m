Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 688D6146029
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 02:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbgAWBBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 20:01:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52871 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbgAWBBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 20:01:42 -0500
Received: from [82.43.126.140] (helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1iuQsI-00089p-FT; Thu, 23 Jan 2020 01:01:34 +0000
From:   Colin King <colin.king@canonical.com>
To:     Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net/rose: fix spelling mistake "to" -> "too"
Date:   Thu, 23 Jan 2020 01:01:33 +0000
Message-Id: <20200123010133.2834467-1-colin.king@canonical.com>
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
 drivers/dma/s3c24xx-dma.c | 2 +-
 net/rose/af_rose.c        | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/s3c24xx-dma.c b/drivers/dma/s3c24xx-dma.c
index 8e14c72d03f0..63f1453ca250 100644
--- a/drivers/dma/s3c24xx-dma.c
+++ b/drivers/dma/s3c24xx-dma.c
@@ -826,7 +826,7 @@ static struct dma_async_tx_descriptor *s3c24xx_dma_prep_memcpy(
 			len, s3cchan->name);
 
 	if ((len & S3C24XX_DCON_TC_MASK) != len) {
-		dev_err(&s3cdma->pdev->dev, "memcpy size %zu to large\n", len);
+		dev_err(&s3cdma->pdev->dev, "memcpy size %zu too large\n", len);
 		return NULL;
 	}
 
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

