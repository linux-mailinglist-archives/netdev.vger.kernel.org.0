Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20C7511C8FD
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 10:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728342AbfLLJSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 04:18:17 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7674 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728198AbfLLJSQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Dec 2019 04:18:16 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 3EADA54B19AC2CC7B697;
        Thu, 12 Dec 2019 17:18:14 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.439.0; Thu, 12 Dec 2019 17:18:07 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     "Jason A . Donenfeld" <Jason@zx2c4.com>,
        "David S . Miller" <davem@davemloft.net>
CC:     YueHaibing <yuehaibing@huawei.com>, <wireguard@lists.zx2c4.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH net-next] net: Remove unused including <linux/version.h>
Date:   Thu, 12 Dec 2019 09:15:27 +0000
Message-ID: <20191212091527.35293-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove including <linux/version.h> that don't need it.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
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



