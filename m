Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1B3A11FB62
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 22:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbfLOVIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 16:08:19 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:48739 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726537AbfLOVIR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Dec 2019 16:08:17 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 891c2408;
        Sun, 15 Dec 2019 20:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=qAVJhL6W/v0pOjc+ptVjw2SyL
        vo=; b=BO9lxNkiTBKdxyZipe/J8XcthxTAa/gguruJvnYt8uW/TylBT/MapkgvV
        eUFEfWNI6etZydp88QKJj1HmW7/2afeBmbWWgDso2O8Ggw+VJYtZLe2iwboNqv2b
        VeVdxGC8zrgzWce/0U0hzmE3M9xR7gcA9WHbxIwqP2y9Lp6luRvE/jlAWJMjkPa+
        MoRbAGKYIScwBi/8NDJ9VAQwy0l2P67/qBdsul6BhCsfCcPJfRA8WOS/nvYB3Gy+
        WXHXE4k31aTE7Ov2veUFoNEX+36bXlx3MKOSkjCsunwaJ9MwmrC4xkLBqlb3hUuR
        4zD3LxOah/2CTbURHw0OHeA6r3GQQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 058b4056 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Sun, 15 Dec 2019 20:12:01 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net-next 4/5] wireguard: main: remove unused include <linux/version.h>
Date:   Sun, 15 Dec 2019 22:08:03 +0100
Message-Id: <20191215210804.143919-5-Jason@zx2c4.com>
In-Reply-To: <20191215210804.143919-1-Jason@zx2c4.com>
References: <20191215210804.143919-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

Remove <linux/version.h> from the includes for main.c, which is unused.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
[Jason: reworded commit message]
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireguard/main.c b/drivers/net/wireguard/main.c
index 10c0a40f6a9e..7a7d5f1a80fc 100644
--- a/drivers/net/wireguard/main.c
+++ b/drivers/net/wireguard/main.c
@@ -12,7 +12,6 @@
 
 #include <uapi/linux/wireguard.h>
 
-#include <linux/version.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/genetlink.h>
-- 
2.24.1

