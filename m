Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA8D83EB4FF
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 14:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240159AbhHMMIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 08:08:51 -0400
Received: from mx21.baidu.com ([220.181.3.85]:43878 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239145AbhHMMIr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 08:08:47 -0400
Received: from BC-Mail-EX08.internal.baidu.com (unknown [172.31.51.48])
        by Forcepoint Email with ESMTPS id BE1FA1E5FAD4A599E8A5;
        Fri, 13 Aug 2021 20:08:18 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BC-Mail-EX08.internal.baidu.com (172.31.51.48) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Fri, 13 Aug 2021 20:08:18 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Fri, 13 Aug 2021 20:08:17 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <davem@davemloft.net>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Cai Huoqing <caihuoqing@baidu.com>
Subject: [PATCH 2/2] MAINTAINERS: Remove the ipx network layer info
Date:   Fri, 13 Aug 2021 20:08:03 +0800
Message-ID: <20210813120803.101-3-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210813120803.101-1-caihuoqing@baidu.com>
References: <20210813120803.101-1-caihuoqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BC-Mail-Ex16.internal.baidu.com (172.31.51.56) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit <47595e32869f> ("<MAINTAINERS: Mark some staging directories>")
indicated the ipx network layer as obsolete in Jan 2018,
updated in the MAINTAINERS file.

now, after being exposed for 3 years to refactoring, so to
remove the ipx network layer info from MAINTAINERS.
additionally, there is no module that depends on ipx.h
except a broken staging driver(r8188eu)

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 MAINTAINERS | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index efac6221afe1..169352637fc2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9788,11 +9788,6 @@ M:	David Sterba <dsterba@suse.com>
 S:	Odd Fixes
 F:	drivers/tty/ipwireless/
 
-IPX NETWORK LAYER
-L:	netdev@vger.kernel.org
-S:	Obsolete
-F:	include/uapi/linux/ipx.h
-
 IRQ DOMAINS (IRQ NUMBER MAPPING LIBRARY)
 M:	Marc Zyngier <maz@kernel.org>
 S:	Maintained
-- 
2.25.1

