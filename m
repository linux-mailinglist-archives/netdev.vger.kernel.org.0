Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B15363E35FF
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 16:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231159AbhHGO7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 10:59:52 -0400
Received: from mx21.baidu.com ([220.181.3.85]:43052 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229869AbhHGO6M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Aug 2021 10:58:12 -0400
Received: from BC-Mail-Ex12.internal.baidu.com (unknown [172.31.51.52])
        by Forcepoint Email with ESMTPS id 779334BCAD628CC7823F;
        Sat,  7 Aug 2021 22:57:42 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BC-Mail-Ex12.internal.baidu.com (172.31.51.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Sat, 7 Aug 2021 22:57:42 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.62.18) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Sat, 7 Aug 2021 22:57:41 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <arnd@arndb.de>,
        <geert@linux-m68k.org>, <jgg@ziepe.ca>, <schmitzmic@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Cai Huoqing <caihuoqing@baidu.com>
Subject: [PATCH 2/2] MAINTAINERS: Remove the 8390 network drivers info
Date:   Sat, 7 Aug 2021 22:57:32 +0800
Message-ID: <20210807145732.211-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.32.0.windows.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.31.62.18]
X-ClientProxiedBy: BJHW-Mail-Ex14.internal.baidu.com (10.127.64.37) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit <0cf445ceaf43> ("<netdev: Update status of 8390 based drivers>")
indicated the 8390 network drivers as orphan/obsolete in Jan 2011,
updated in the MAINTAINERS file.

now, after being exposed for 10 years to refactoring,
and no one has become its maintainer for the past 10 years,
so to remove the 8390 network drivers info from MAINTAINERS.

additionally, 8390 is a kind of old ethernet chip based on
ISA interface which is hard to find in the market. 

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 MAINTAINERS | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c2eb088b996c..6ef4c65f9e8e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -217,11 +217,6 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
 F:	drivers/tty/serial/8250*
 F:	include/linux/serial_8250.h
 
-8390 NETWORK DRIVERS [WD80x3/SMC-ELITE, SMC-ULTRA, NE2000, 3C503, etc.]
-L:	netdev@vger.kernel.org
-S:	Orphan / Obsolete
-F:	drivers/net/ethernet/8390/
-
 9P FILE SYSTEM
 M:	Eric Van Hensbergen <ericvh@gmail.com>
 M:	Latchesar Ionkov <lucho@ionkov.net>
@@ -2440,7 +2435,6 @@ F:	arch/arm/include/asm/hardware/ioc.h
 F:	arch/arm/include/asm/hardware/iomd.h
 F:	arch/arm/include/asm/hardware/memc.h
 F:	arch/arm/mach-rpc/
-F:	drivers/net/ethernet/8390/etherh.c
 F:	drivers/net/ethernet/i825xx/ether1*
 F:	drivers/net/ethernet/seeq/ether3*
 F:	drivers/scsi/arm/
-- 
2.25.1

