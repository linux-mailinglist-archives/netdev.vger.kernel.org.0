Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3255D3886C5
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 07:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345520AbhESFjq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 01:39:46 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4674 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244825AbhESFhY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 01:37:24 -0400
Received: from dggems705-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FlM1h0ZDqz1BP5h;
        Wed, 19 May 2021 13:31:52 +0800 (CST)
Received: from dggemi760-chm.china.huawei.com (10.1.198.146) by
 dggems705-chm.china.huawei.com (10.3.19.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 13:34:37 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi760-chm.china.huawei.com (10.1.198.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 19 May 2021 13:34:37 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Hui Tang <tanghui20@huawei.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 12/20] net: realtek: remove leading spaces before tabs
Date:   Wed, 19 May 2021 13:30:45 +0800
Message-ID: <1621402253-27200-13-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621402253-27200-1-git-send-email-tanghui20@huawei.com>
References: <1621402253-27200-1-git-send-email-tanghui20@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggemi760-chm.china.huawei.com (10.1.198.146)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a few leading spaces before tabs and remove it by running the
following commard:

	$ find . -name '*.c' | xargs sed -r -i 's/^[ ]+\t/\t/'
	$ find . -name '*.h' | xargs sed -r -i 's/^[ ]+\t/\t/'

Cc: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 drivers/net/ethernet/realtek/8139cp.c  | 6 +++---
 drivers/net/ethernet/realtek/8139too.c | 6 +++---
 drivers/net/ethernet/realtek/atp.c     | 4 ++--
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet/realtek/8139cp.c
index 4e44313..9677e25 100644
--- a/drivers/net/ethernet/realtek/8139cp.c
+++ b/drivers/net/ethernet/realtek/8139cp.c
@@ -6,7 +6,7 @@
 	Copyright (C) 2000, 2001 David S. Miller (davem@redhat.com) [sungem.c]
 	Copyright 2001 Manfred Spraul				    [natsemi.c]
 	Copyright 1999-2001 by Donald Becker.			    [natsemi.c]
-       	Written 1997-2001 by Donald Becker.			    [8139too.c]
+	Written 1997-2001 by Donald Becker.			    [8139too.c]
 	Copyright 1998-2001 by Jes Sorensen, <jes@trained-monkey.org>. [acenic.c]
 
 	This software may be used and distributed according to the terms of
@@ -947,8 +947,8 @@ static struct net_device_stats *cp_get_stats(struct net_device *dev)
 
 	/* The chip only need report frame silently dropped. */
 	spin_lock_irqsave(&cp->lock, flags);
- 	if (netif_running(dev) && netif_device_present(dev))
- 		__cp_get_stats(cp);
+	if (netif_running(dev) && netif_device_present(dev))
+		__cp_get_stats(cp);
 	spin_unlock_irqrestore(&cp->lock, flags);
 
 	return &dev->stats;
diff --git a/drivers/net/ethernet/realtek/8139too.c b/drivers/net/ethernet/realtek/8139too.c
index 1e5a453..f0608f0 100644
--- a/drivers/net/ethernet/realtek/8139too.c
+++ b/drivers/net/ethernet/realtek/8139too.c
@@ -11,7 +11,7 @@
 
 	-----<snip>-----
 
-        	Written 1997-2001 by Donald Becker.
+		Written 1997-2001 by Donald Becker.
 		This software may be used and distributed according to the
 		terms of the GNU General Public License (GPL), incorporated
 		herein by reference.  Drivers based on or derived from this
@@ -548,8 +548,8 @@ static const struct {
 
 	{ "RTL-8100",
 	  HW_REVID(1, 1, 1, 1, 0, 1, 0),
- 	  HasLWake,
- 	},
+	  HasLWake,
+	},
 
 	{ "RTL-8100B/8139D",
 	  HW_REVID(1, 1, 1, 0, 1, 0, 1),
diff --git a/drivers/net/ethernet/realtek/atp.c b/drivers/net/ethernet/realtek/atp.c
index 9e3b35c..b6c849b 100644
--- a/drivers/net/ethernet/realtek/atp.c
+++ b/drivers/net/ethernet/realtek/atp.c
@@ -497,8 +497,8 @@ static void write_packet(long ioaddr, int length, unsigned char *packet, int pad
 {
     if (length & 1)
     {
-    	length++;
-    	pad_len++;
+	length++;
+	pad_len++;
     }
 
     outb(EOC+MAR, ioaddr + PAR_DATA);
-- 
2.8.1

