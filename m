Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D76F446204A
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 20:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243197AbhK2TXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 14:23:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379742AbhK2TVv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 14:21:51 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A3C5C09B079;
        Mon, 29 Nov 2021 07:39:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 65B3ACE1302;
        Mon, 29 Nov 2021 15:39:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CFF1C53FCB;
        Mon, 29 Nov 2021 15:39:47 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="ZH4qUUbt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1638200386;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/H4R1tnn8zo+8R9cf6QCiH1/4It6PX9nEULBVx9CvBo=;
        b=ZH4qUUbtMQmbrKIoUIJ6KIsnxQHpzG5SHThHNMMOdF8rqGpSaD1TJp8tucZ9yeHvA1askx
        3d0a/2XZO4VXQ4eBep0CV6brCQqJ4yWYCv/yI5mH2tazzpSsHg1/1cgJJ3HyZcjbisdE81
        MXjPjeaOlEBNrtObMRQlaLkT8mXPHfw=
Received: by mail.zx2c4.com (OpenSMTPD) with ESMTPSA id ee729afc (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 29 Nov 2021 15:39:46 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Li Zhijian <lizhijian@cn.fujitsu.com>, stable@vger.kernel.org,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 05/10] wireguard: selftests: rename DEBUG_PI_LIST to DEBUG_PLIST
Date:   Mon, 29 Nov 2021 10:39:24 -0500
Message-Id: <20211129153929.3457-6-Jason@zx2c4.com>
In-Reply-To: <20211129153929.3457-1-Jason@zx2c4.com>
References: <20211129153929.3457-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Li Zhijian <lizhijian@cn.fujitsu.com>

DEBUG_PI_LIST was renamed to DEBUG_PLIST since 8e18faeac3 ("lib/plist:
rename DEBUG_PI_LIST to DEBUG_PLIST").

Signed-off-by: Li Zhijian <lizhijian@cn.fujitsu.com>
Fixes: 8e18faeac3 ("lib/plist: rename DEBUG_PI_LIST to DEBUG_PLIST")
Cc: stable@vger.kernel.org
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 tools/testing/selftests/wireguard/qemu/debug.config | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/wireguard/qemu/debug.config b/tools/testing/selftests/wireguard/qemu/debug.config
index fe07d97df9fa..2b321b8a96cf 100644
--- a/tools/testing/selftests/wireguard/qemu/debug.config
+++ b/tools/testing/selftests/wireguard/qemu/debug.config
@@ -47,7 +47,7 @@ CONFIG_DEBUG_ATOMIC_SLEEP=y
 CONFIG_TRACE_IRQFLAGS=y
 CONFIG_DEBUG_BUGVERBOSE=y
 CONFIG_DEBUG_LIST=y
-CONFIG_DEBUG_PI_LIST=y
+CONFIG_DEBUG_PLIST=y
 CONFIG_PROVE_RCU=y
 CONFIG_SPARSE_RCU_POINTER=y
 CONFIG_RCU_CPU_STALL_TIMEOUT=21
-- 
2.34.1

