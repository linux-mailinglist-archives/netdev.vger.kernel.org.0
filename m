Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0F13817FA
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 12:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbhEOK6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 06:58:19 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3551 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232153AbhEOKz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 06:55:56 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fj2Jn5t8MzsRHl;
        Sat, 15 May 2021 18:51:53 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Sat, 15 May 2021 18:54:28 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yang Shen <shenyang39@huawei.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH 23/34] net: phy: Demote non-compliant kernel-doc headers
Date:   Sat, 15 May 2021 18:53:48 +0800
Message-ID: <1621076039-53986-24-git-send-email-shenyang39@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1621076039-53986-1-git-send-email-shenyang39@huawei.com>
References: <1621076039-53986-1-git-send-email-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/phy/adin.c:3: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 drivers/net/phy/rockchip.c:3: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst

Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Signed-off-by: Yang Shen <shenyang39@huawei.com>
---
 drivers/net/phy/adin.c     | 2 +-
 drivers/net/phy/rockchip.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index 55a0b91..5ce6da6 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0+
-/**
+/*
  *  Driver for Analog Devices Industrial Ethernet PHYs
  *
  * Copyright 2019 Analog Devices Inc.
diff --git a/drivers/net/phy/rockchip.c b/drivers/net/phy/rockchip.c
index 52f1f65..bb13e75 100644
--- a/drivers/net/phy/rockchip.c
+++ b/drivers/net/phy/rockchip.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0+
-/**
+/*
  * drivers/net/phy/rockchip.c
  *
  * Driver for ROCKCHIP Ethernet PHYs
-- 
2.7.4

