Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEB5239B2CE
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 08:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbhFDGsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 02:48:05 -0400
Received: from m12-11.163.com ([220.181.12.11]:45127 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229917AbhFDGsF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 02:48:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=PKdV4
        v61pNy3EDpnyZvwHBdxh8RRqfiLDQaXIuC1n8U=; b=EbMoxeE5y4lBqaThOBxr3
        MkNQDfBxdhgAjWhmrdKBSjV8TOv9VM1Yynn1Cwp6tT4mA0Osd1NO5JwUKf53p/2w
        j1j/lwxyWd7yIZYfuqqUQpVtg2CLs+LhZHf5m2lERAQL69ed8onYrgm4gjxbhqng
        SRxbAeCV1+dgcdANlcsDmg=
Received: from COOL-20201222LC.ccdomain.com (unknown [218.94.48.178])
        by smtp7 (Coremail) with SMTP id C8CowAB3bo4vzLlgmlN+gA--.1919S2;
        Fri, 04 Jun 2021 14:46:09 +0800 (CST)
From:   dingsenjie@163.com
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dingsenjie <dingsenjie@yulong.com>
Subject: [PATCH] net: fjes: Use DEFINE_RES_MEM() and DEFINE_RES_IRQ() to simplify code
Date:   Fri,  4 Jun 2021 14:45:51 +0800
Message-Id: <20210604064551.140608-1-dingsenjie@163.com>
X-Mailer: git-send-email 2.21.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: C8CowAB3bo4vzLlgmlN+gA--.1919S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7JF4DAF4Utw1DuFW7GF4kWFg_yoW3GFg_Ca
        yIvanrWw1UKryjyr10kr43ZryxtF1q9rn2g347t39Y9wnrZF17Cw1UCrW7XryDWanrAFnr
        ZF17Zr1Yy347XjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU0nZ2DUUUUU==
X-Originating-IP: [218.94.48.178]
X-CM-SenderInfo: 5glqw25hqmxvi6rwjhhfrp/1tbiThGnyFUDJ6amagAAsr
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: dingsenjie <dingsenjie@yulong.com>

Use macro to simplify the code.

Signed-off-by: dingsenjie <dingsenjie@yulong.com>
---
 drivers/net/fjes/fjes_main.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/net/fjes/fjes_main.c b/drivers/net/fjes/fjes_main.c
index 4666226..d098b1f 100644
--- a/drivers/net/fjes/fjes_main.c
+++ b/drivers/net/fjes/fjes_main.c
@@ -90,16 +90,8 @@
 };
 
 static struct resource fjes_resource[] = {
-	{
-		.flags = IORESOURCE_MEM,
-		.start = 0,
-		.end = 0,
-	},
-	{
-		.flags = IORESOURCE_IRQ,
-		.start = 0,
-		.end = 0,
-	},
+	DEFINE_RES_MEM(0, 1),
+	DEFINE_RES_IRQ(0)
 };
 
 static bool is_extended_socket_device(struct acpi_device *device)
-- 
1.9.1

