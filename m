Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 644AA38261D
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 10:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235221AbhEQIBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 04:01:05 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3711 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235505AbhEQIAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 04:00:13 -0400
Received: from dggems703-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FkBK81Dr2z16R9Q;
        Mon, 17 May 2021 15:56:12 +0800 (CST)
Received: from dggema704-chm.china.huawei.com (10.3.20.68) by
 dggems703-chm.china.huawei.com (10.3.19.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 17 May 2021 15:58:56 +0800
Received: from localhost.localdomain (10.67.165.2) by
 dggema704-chm.china.huawei.com (10.3.20.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 17 May 2021 15:58:56 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yang Shen <shenyang39@huawei.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH v2 23/24] net: phy: Demote non-compliant kernel-doc headers
Date:   Mon, 17 May 2021 12:45:34 +0800
Message-ID: <20210517044535.21473-24-shenyang39@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210517044535.21473-1-shenyang39@huawei.com>
References: <20210517044535.21473-1-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.2]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggema704-chm.china.huawei.com (10.3.20.68)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/phy/adin.c:3: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 drivers/net/phy/rockchip.c:3: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst

Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Signed-off-by: Yang Shen <shenyang39@huawei.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/adin.c     | 2 +-
 drivers/net/phy/rockchip.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index 55a0b91816e2..5ce6da62cc8e 100644
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
index 52f1f65320fe..bb13e75183ee 100644
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
2.17.1

