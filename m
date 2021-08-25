Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 763143F6F75
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 08:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238375AbhHYG0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 02:26:10 -0400
Received: from mx21.baidu.com ([220.181.3.85]:33968 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238139AbhHYG0J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 02:26:09 -0400
Received: from BC-Mail-Ex14.internal.baidu.com (unknown [172.31.51.54])
        by Forcepoint Email with ESMTPS id EC63250FE381D50C37E7;
        Wed, 25 Aug 2021 14:25:21 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BC-Mail-Ex14.internal.baidu.com (172.31.51.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Wed, 25 Aug 2021 14:25:21 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Wed, 25 Aug 2021 14:25:20 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <afaerber@suse.de>, <mani@kernel.org>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <linux-actions@lists.infradead.org>, <netdev@vger.kernel.org>,
        Cai Huoqing <caihuoqing@baidu.com>
Subject: [PATCH] net: ethernet: actions: Add helper dependency on COMPILE_TEST
Date:   Wed, 25 Aug 2021 14:25:13 +0800
Message-ID: <20210825062513.2384-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BC-Mail-Ex30.internal.baidu.com (172.31.51.24) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

it's helpful for complie test in other platform(e.g.X86)

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 drivers/net/ethernet/actions/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/actions/Kconfig b/drivers/net/ethernet/actions/Kconfig
index ccad6a3f4d6f..dedad1fffdc3 100644
--- a/drivers/net/ethernet/actions/Kconfig
+++ b/drivers/net/ethernet/actions/Kconfig
@@ -2,8 +2,8 @@
 
 config NET_VENDOR_ACTIONS
 	bool "Actions Semi devices"
-	default y
-	depends on ARCH_ACTIONS
+	depends on ARCH_ACTIONS || COMPILE_TEST
+	default ARCH_ACTIONS
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
 
-- 
2.25.1

