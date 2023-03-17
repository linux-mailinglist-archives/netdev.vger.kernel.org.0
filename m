Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26F276BE4ED
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 10:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbjCQJHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 05:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbjCQJHf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 05:07:35 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F120B4ED0;
        Fri, 17 Mar 2023 02:06:33 -0700 (PDT)
X-UUID: d938815ec49b11edbd2e61cc88cc8f98-20230317
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=FGfHOBVymC0DHuKRYmnC5Uxx4OWvdn5zdJ7U9DYtQ5U=;
        b=ikcEbLkIxAEIvahriLsuh87t+6pHsv62MC2euRW7W9W4qEOlBJ6pq1fuLCxlffXOOWcIw3Nul//yFdEu+x7OqO1j1SkiVGlFbGd9tr17LgJXEBn00x6Yg/FDGWEzfkWUqdjNezUVC38sZdappQlZYPcKaLgfK1dj7yDJyyXGVe8=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.21,REQID:80b96f3b-72fc-4b21-b459-4786f0e423e3,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:83295aa,CLOUDID:8859ac28-564d-42d9-9875-7c868ee415ec,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-UUID: d938815ec49b11edbd2e61cc88cc8f98-20230317
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
        (envelope-from <yanchao.yang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1577523023; Fri, 17 Mar 2023 16:15:16 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Fri, 17 Mar 2023 16:15:14 +0800
Received: from mcddlt001.gcn.mediatek.inc (10.19.240.15) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.25 via Frontend Transport; Fri, 17 Mar 2023 16:15:13 +0800
From:   Yanchao Yang <yanchao.yang@mediatek.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev ML <netdev@vger.kernel.org>,
        kernel ML <linux-kernel@vger.kernel.org>
CC:     Intel experts <linuxwwan@intel.com>,
        Chetan <m.chetan.kumar@intel.com>,
        MTK ML <linux-mediatek@lists.infradead.org>,
        Liang Lu <liang.lu@mediatek.com>,
        Haijun Liu <haijun.liu@mediatek.com>,
        Hua Yang <hua.yang@mediatek.com>,
        Ting Wang <ting.wang@mediatek.com>,
        Felix Chen <felix.chen@mediatek.com>,
        Mingliang Xu <mingliang.xu@mediatek.com>,
        Min Dong <min.dong@mediatek.com>,
        Aiden Wang <aiden.wang@mediatek.com>,
        Guohao Zhang <guohao.zhang@mediatek.com>,
        Chris Feng <chris.feng@mediatek.com>,
        Yanchao Yang <yanchao.yang@mediatek.com>,
        Lambert Wang <lambert.wang@mediatek.com>,
        Mingchuang Qiao <mingchuang.qiao@mediatek.com>,
        Xiayu Zhang <xiayu.zhang@mediatek.com>,
        Haozhe Chang <haozhe.chang@mediatek.com>
Subject: [PATCH net-next v4 10/10] net: wwan: tmi: Add maintainers and documentation
Date:   Fri, 17 Mar 2023 16:09:42 +0800
Message-ID: <20230317080942.183514-11-yanchao.yang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20230317080942.183514-1-yanchao.yang@mediatek.com>
References: <20230317080942.183514-1-yanchao.yang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds maintainers and documentation for MediaTek TMI 5G WWAN modem
device driver.

Signed-off-by: Yanchao Yang <yanchao.yang@mediatek.com>
Signed-off-by: Felix Chen <felix.chen@mediatek.com>
---
 .../networking/device_drivers/wwan/index.rst  |  1 +
 .../networking/device_drivers/wwan/tmi.rst    | 48 +++++++++++++++++++
 MAINTAINERS                                   | 11 +++++
 3 files changed, 60 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/wwan/tmi.rst

diff --git a/Documentation/networking/device_drivers/wwan/index.rst b/Documentation/networking/device_drivers/wwan/index.rst
index 370d8264d5dc..8298629b4d55 100644
--- a/Documentation/networking/device_drivers/wwan/index.rst
+++ b/Documentation/networking/device_drivers/wwan/index.rst
@@ -10,6 +10,7 @@ Contents:
 
    iosm
    t7xx
+   tmi
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/device_drivers/wwan/tmi.rst b/Documentation/networking/device_drivers/wwan/tmi.rst
new file mode 100644
index 000000000000..3655779bf692
--- /dev/null
+++ b/Documentation/networking/device_drivers/wwan/tmi.rst
@@ -0,0 +1,48 @@
+.. SPDX-License-Identifier: BSD-3-Clause-Clear
+
+.. Copyright (c) 2022, MediaTek Inc.
+
+.. _tmi_driver_doc:
+
+====================================================
+TMI driver for MTK PCIe based T-series 5G Modem
+====================================================
+The TMI(T-series Modem Interface) driver is a WWAN PCIe host driver developed
+for data exchange over PCIe interface between Host platform and MediaTek's
+T-series 5G modem. The driver exposes control plane and data plane interfaces
+to applications. The control plane provides device node interfaces for control
+data transactions. The data plane provides network link interfaces for IP data
+transactions.
+
+Control channel userspace ABI
+=============================
+/dev/wwan0at0 character device
+------------------------------
+The driver exposes an AT port by implementing AT WWAN Port.
+The userspace end of the control channel pipe is a /dev/wwan0at0 character
+device. Application shall use this interface to issue AT commands.
+
+/dev/wwan0mbim0 character device
+--------------------------------
+The driver exposes an MBIM interface to the MBIM function by implementing
+MBIM WWAN Port. The userspace end of the control channel pipe is a
+/dev/wwan0mbim0 character device. Applications shall use this interface
+for MBIM protocol communication.
+
+Data channel userspace ABI
+==========================
+wwan0-X network device
+----------------------
+The TMI driver exposes IP link interfaces "wwan0-X" of type "wwan" for IP
+traffic. Iproute network utility is used for creating "wwan0-X" network
+interfaces and for associating it with the MBIM IP session.
+
+The userspace management application is responsible for creating a new IP link
+prior to establishing an MBIM IP session where the SessionId is greater than 0.
+
+For example, creating a new IP link for an MBIM IP session with SessionId 1:
+
+  ip link add dev wwan0-1 parentdev wwan0 type wwan linkid 1
+
+The driver will automatically map the "wwan0-1" network device to MBIM IP
+session 1.
diff --git a/MAINTAINERS b/MAINTAINERS
index edd3d562beee..5224a42be5ff 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13187,6 +13187,17 @@ L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/wwan/t7xx/
 
+MEDIATEK TMI 5G WWAN MODEM DRIVER
+M:	Yanchao Yang <yanchao.yang@mediatek.com>
+M:	Min Dong <min.dong@mediatek.com>
+M:	MediaTek Corporation <linuxwwan@mediatek.com>
+R:	Liang Lu <liang.lu@mediatek.com>
+R:	Haijun Liu <haijun.liu@mediatek.com>
+R:	Lambert Wang <lambert.wang@mediatek.com>
+L:	netdev@vger.kernel.org
+S:	Supported
+F:	drivers/net/wwan/tmi/
+
 MEDIATEK USB3 DRD IP DRIVER
 M:	Chunfeng Yun <chunfeng.yun@mediatek.com>
 L:	linux-usb@vger.kernel.org
-- 
2.32.0

