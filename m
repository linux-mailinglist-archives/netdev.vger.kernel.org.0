Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E271F16A094
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 09:54:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727908AbgBXIyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 03:54:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:37886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727874AbgBXIyJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Feb 2020 03:54:09 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4262A2173E;
        Mon, 24 Feb 2020 08:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582534449;
        bh=xrrfTjqUA3ZASNnw1o4uS2gmW3iXWsgg3RblIOSWWqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A5iZmhTRmUn/EPy32nqLlSWM5WfQttuKqn4dbBy8VG02OxsrjPuaD+8W4A6q5F9DM
         FZ2FOcmPYjlGCraRdBnSQi97CVacB1XRy4LwwP2A+nkfH9aWiXmQw3g8kSwgc/6IVW
         J6CH/BqFSwYKOHGgISLqxhlzEzGahYBe36/Sk1UU=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Don Fry <pcnet32@frontier.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>, linux-acenic@sunsite.dk,
        Maxime Ripard <mripard@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Mark Einon <mark.einon@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        linux-rockchip@lists.infradead.org,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        David Dillow <dave@thedillows.org>,
        Netanel Belgazal <netanel@amazon.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        linux-arm-kernel@lists.infradead.org,
        Andreas Larsson <andreas@gaisler.com>,
        Andy Gospodarek <andy@greyhouse.net>, netdev@vger.kernel.org,
        Thor Thayer <thor.thayer@linux.intel.com>,
        linux-kernel@vger.kernel.org, Ion Badulescu <ionut@badula.org>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Jes Sorensen <jes@trained-monkey.org>,
        nios2-dev@lists.rocketboards.org, Chen-Yu Tsai <wens@csie.org>
Subject: [PATCH net-next v1 16/18] net/aquantia: Delete module version
Date:   Mon, 24 Feb 2020 10:53:09 +0200
Message-Id: <20200224085311.460338-17-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200224085311.460338-1-leon@kernel.org>
References: <20200224085311.460338-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

There is no need to keep module and driver versions in in-tree
kernel code.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_cfg.h     |  4 ----
 drivers/net/ethernet/aquantia/atlantic/aq_common.h  |  1 -
 drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c |  1 -
 drivers/net/ethernet/aquantia/atlantic/aq_main.c    |  1 -
 drivers/net/ethernet/aquantia/atlantic/ver.h        | 12 ------------
 5 files changed, 19 deletions(-)
 delete mode 100644 drivers/net/ethernet/aquantia/atlantic/ver.h

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_cfg.h b/drivers/net/ethernet/aquantia/atlantic/aq_cfg.h
index f0c41f7408e5..7560f5506e55 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_cfg.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_cfg.h
@@ -9,8 +9,6 @@
 #ifndef AQ_CFG_H
 #define AQ_CFG_H

-#include <generated/utsrelease.h>
-
 #define AQ_CFG_VECS_DEF   8U
 #define AQ_CFG_TCS_DEF    1U

@@ -85,7 +83,5 @@
 #define AQ_CFG_DRV_AUTHOR      "aQuantia"
 #define AQ_CFG_DRV_DESC        "aQuantia Corporation(R) Network Driver"
 #define AQ_CFG_DRV_NAME        "atlantic"
-#define AQ_CFG_DRV_VERSION	UTS_RELEASE \
-				AQ_CFG_DRV_VERSION_SUFFIX

 #endif /* AQ_CFG_H */
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_common.h b/drivers/net/ethernet/aquantia/atlantic/aq_common.h
index 42ea8d8daa46..c8c402b013bb 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_common.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_common.h
@@ -12,7 +12,6 @@
 #include <linux/etherdevice.h>
 #include <linux/pci.h>
 #include <linux/if_vlan.h>
-#include "ver.h"
 #include "aq_cfg.h"
 #include "aq_utils.h"

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
index 7b55633d2cb9..0bdaa0d785b7 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -132,7 +132,6 @@ static void aq_ethtool_get_drvinfo(struct net_device *ndev,
 	regs_count = aq_nic_get_regs_count(aq_nic);

 	strlcat(drvinfo->driver, AQ_CFG_DRV_NAME, sizeof(drvinfo->driver));
-	strlcat(drvinfo->version, AQ_CFG_DRV_VERSION, sizeof(drvinfo->version));

 	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
 		 "%u.%u.%u", firmware_version >> 24,
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
index 538f460a3da7..9fcab646cbd5 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -19,7 +19,6 @@
 #include <linux/udp.h>

 MODULE_LICENSE("GPL v2");
-MODULE_VERSION(AQ_CFG_DRV_VERSION);
 MODULE_AUTHOR(AQ_CFG_DRV_AUTHOR);
 MODULE_DESCRIPTION(AQ_CFG_DRV_DESC);

diff --git a/drivers/net/ethernet/aquantia/atlantic/ver.h b/drivers/net/ethernet/aquantia/atlantic/ver.h
deleted file mode 100644
index 597654b51e01..000000000000
--- a/drivers/net/ethernet/aquantia/atlantic/ver.h
+++ /dev/null
@@ -1,12 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2017 aQuantia Corporation. All rights reserved
- */
-
-#ifndef VER_H
-#define VER_H
-
-#define AQ_CFG_DRV_VERSION_SUFFIX "-kern"
-
-#endif /* VER_H */
--
2.24.1

