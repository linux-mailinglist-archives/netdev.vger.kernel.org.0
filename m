Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7F53E35F8
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 16:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbhHGO4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 10:56:51 -0400
Received: from mx20.baidu.com ([111.202.115.85]:42174 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229503AbhHGO4t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Aug 2021 10:56:49 -0400
Received: from Bc-Mail-Ex13.internal.baidu.com (unknown [172.31.51.53])
        by Forcepoint Email with ESMTPS id 27C55EFB590501808A9E;
        Sat,  7 Aug 2021 22:56:29 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 Bc-Mail-Ex13.internal.baidu.com (172.31.51.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Sat, 7 Aug 2021 22:56:28 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.62.19) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Sat, 7 Aug 2021 22:56:28 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <arnd@arndb.de>,
        <geert@linux-m68k.org>, <jgg@ziepe.ca>, <schmitzmic@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Cai Huoqing <caihuoqing@baidu.com>
Subject: [PATCH 0/2] net: ethernet: Remove the 8390 network drivers
Date:   Sat, 7 Aug 2021 22:56:19 +0800
Message-ID: <20210807145619.832-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.32.0.windows.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.31.62.19]
X-ClientProxiedBy: BJHW-Mail-Ex14.internal.baidu.com (10.127.64.37) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit <0cf445ceaf43> ("<netdev: Update status of 8390 based drivers>")
indicated the 8390 network drivers as orphan/obsolete in Jan 2011,
updated in the MAINTAINERS file.

now, after being exposed for 10 years to refactoring and
no one has become its maintainer for the past 10 years,
so to remove the 8390 network drivers for good.

additionally, 8390 is a kind of old ethernet chip based on
ISA interface which is hard to find in the market. 

Cai Huoqing (2):
  net: ethernet: Remove the 8390 network drivers
  MAINTAINERS: Remove the 8390 network drivers info

 MAINTAINERS                           |    6 -
 drivers/net/ethernet/8390/8390.c      |  103 --
 drivers/net/ethernet/8390/8390.h      |  236 ----
 drivers/net/ethernet/8390/8390p.c     |  105 --
 drivers/net/ethernet/8390/Kconfig     |  212 ---
 drivers/net/ethernet/8390/Makefile    |   20 -
 drivers/net/ethernet/8390/apne.c      |  619 ---------
 drivers/net/ethernet/8390/ax88796.c   | 1022 ---------------
 drivers/net/ethernet/8390/axnet_cs.c  | 1707 ------------------------
 drivers/net/ethernet/8390/etherh.c    |  856 -------------
 drivers/net/ethernet/8390/hydra.c     |  273 ----
 drivers/net/ethernet/8390/lib8390.c   | 1092 ----------------
 drivers/net/ethernet/8390/mac8390.c   |  848 ------------
 drivers/net/ethernet/8390/mcf8390.c   |  475 -------
 drivers/net/ethernet/8390/ne.c        | 1004 ---------------
 drivers/net/ethernet/8390/ne2k-pci.c  |  747 -----------
 drivers/net/ethernet/8390/pcnet_cs.c  | 1708 -------------------------
 drivers/net/ethernet/8390/smc-ultra.c |  629 ---------
 drivers/net/ethernet/8390/stnic.c     |  303 -----
 drivers/net/ethernet/8390/wd.c        |  574 ---------
 drivers/net/ethernet/8390/xsurf100.c  |  377 ------
 drivers/net/ethernet/8390/zorro8390.c |  452 -------
 drivers/net/ethernet/Kconfig          |    1 -
 drivers/net/ethernet/Makefile         |    1 -
 24 files changed, 13370 deletions(-)
 delete mode 100644 drivers/net/ethernet/8390/8390.c
 delete mode 100644 drivers/net/ethernet/8390/8390.h
 delete mode 100644 drivers/net/ethernet/8390/8390p.c
 delete mode 100644 drivers/net/ethernet/8390/Kconfig
 delete mode 100644 drivers/net/ethernet/8390/Makefile
 delete mode 100644 drivers/net/ethernet/8390/apne.c
 delete mode 100644 drivers/net/ethernet/8390/ax88796.c
 delete mode 100644 drivers/net/ethernet/8390/axnet_cs.c
 delete mode 100644 drivers/net/ethernet/8390/etherh.c
 delete mode 100644 drivers/net/ethernet/8390/hydra.c
 delete mode 100644 drivers/net/ethernet/8390/lib8390.c
 delete mode 100644 drivers/net/ethernet/8390/mac8390.c
 delete mode 100644 drivers/net/ethernet/8390/mcf8390.c
 delete mode 100644 drivers/net/ethernet/8390/ne.c
 delete mode 100644 drivers/net/ethernet/8390/ne2k-pci.c
 delete mode 100644 drivers/net/ethernet/8390/pcnet_cs.c
 delete mode 100644 drivers/net/ethernet/8390/smc-ultra.c
 delete mode 100644 drivers/net/ethernet/8390/stnic.c
 delete mode 100644 drivers/net/ethernet/8390/wd.c
 delete mode 100644 drivers/net/ethernet/8390/xsurf100.c
 delete mode 100644 drivers/net/ethernet/8390/zorro8390.c

-- 
2.25.1

