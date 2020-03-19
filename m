Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7264818A9CD
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 01:30:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727240AbgCSAaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 20:30:52 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:39393 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726663AbgCSAav (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 20:30:51 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id b38ae73a;
        Thu, 19 Mar 2020 00:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=wW7zTnTeT6VOR5447iN+/22yZ
        Tc=; b=kqJP1DdNH2mVm3C7qyTfPPvMPL4fv9e7oBUXTkX3h71onv6z8Xm3x8QRX
        0DtU6P3HTdlSBjXfKt43DGp8RMahRH9Nb7tvfGqB0Y91bSyKH4oIv+z9G/P5HKa5
        KdcYTGSNX/Hnr+Bq2heiWqwtvcFJ20N5IJblkmSys2JeWEwt0BwVygVfXiM8x+5D
        xtanXYtDyK1obtzCc48ItVPggDZVHCupI/p04NDesvL7orxlXoHZyjUyV2/tNWLd
        cb/4PFOedYp9oL4AxQy/t0Uza/3Swb5jutKvQFJLwyBM+FQ7ju38Bj5wCfLZo1si
        syFJeXuJP/aROKcyMYoYp/VbR2OlQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id a576793c (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Thu, 19 Mar 2020 00:24:25 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 1/5] wireguard: selftests: remove duplicated include <sys/types.h>
Date:   Wed, 18 Mar 2020 18:30:43 -0600
Message-Id: <20200319003047.113501-2-Jason@zx2c4.com>
In-Reply-To: <20200319003047.113501-1-Jason@zx2c4.com>
References: <20200319003047.113501-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

This commit removes a duplicated include.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 tools/testing/selftests/wireguard/qemu/init.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/wireguard/qemu/init.c b/tools/testing/selftests/wireguard/qemu/init.c
index 90bc9813cadc..c9698120ac9d 100644
--- a/tools/testing/selftests/wireguard/qemu/init.c
+++ b/tools/testing/selftests/wireguard/qemu/init.c
@@ -13,7 +13,6 @@
 #include <fcntl.h>
 #include <sys/wait.h>
 #include <sys/mount.h>
-#include <sys/types.h>
 #include <sys/stat.h>
 #include <sys/types.h>
 #include <sys/io.h>
-- 
2.25.1

