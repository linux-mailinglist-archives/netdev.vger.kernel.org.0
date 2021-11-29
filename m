Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F10D461D04
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 18:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245422AbhK2Rxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 12:53:45 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43126 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241332AbhK2Rvo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 12:51:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8224CB812A3
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 17:48:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD7FBC53FC7
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 17:48:23 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="UHcYT15J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1638208103;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/H4R1tnn8zo+8R9cf6QCiH1/4It6PX9nEULBVx9CvBo=;
        b=UHcYT15J64a3XbXGWXXURUtM+V1/6hhIzlWi5ajzJ07HecmI/LbJLg58W0sfNoVA0FEs0H
        q7o2hFcme5Muw8d8I9hL5NB4bZo2l892+BFs+h+h5wRYi/+yNf2AAv1n/6/nfHlHYOfFNs
        8t7TyIrmHur/QJtahPaOmzmOj37M19g=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 6fd4ae6f (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Mon, 29 Nov 2021 17:48:23 +0000 (UTC)
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

