Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9103D671C0F
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 13:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbjARMaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 07:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbjARM31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 07:29:27 -0500
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1FA537F06;
        Wed, 18 Jan 2023 03:46:56 -0800 (PST)
X-UUID: c54e4186972511ed945fc101203acc17-20230118
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=HWdLzUSugUMSgO/oMH5yCErnAFFDCPCQAIwaGw1DuZM=;
        b=U7ZLHaVVeJzsTH+NNG5D7fFJu8Q8TyfPozLuTVnb0qC5KMoFhWGfrCUTro6OQohZp2/gd8tDfLwLPVBPRNMo7hVg9tacLT8iWmdnZwULsQJncGaBYUPLnaWO0FBcpUz2GnsAqMNHGo0EqZQLSZ0VfxNBAlab4sohR5R4ehnk/+A=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.18,REQID:7f6ecb4d-0ab7-45d2-a4f5-ba928b089559,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:3ca2d6b,CLOUDID:0d8e2df6-ff42-4fb0-b929-626456a83c14,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0
X-CID-BVR: 0,NGT
X-UUID: c54e4186972511ed945fc101203acc17-20230118
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw02.mediatek.com
        (envelope-from <yanchao.yang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1117001849; Wed, 18 Jan 2023 19:46:39 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Wed, 18 Jan 2023 19:46:38 +0800
Received: from mcddlt001.gcn.mediatek.inc (10.19.240.15) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Wed, 18 Jan 2023 19:46:36 +0800
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
Subject: [PATCH net-next v2 12/12] net: wwan: tmi: Add maintainers and documentation
Date:   Wed, 18 Jan 2023 19:38:59 +0800
Message-ID: <20230118113859.175836-13-yanchao.yang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20230118113859.175836-1-yanchao.yang@mediatek.com>
References: <20230118113859.175836-1-yanchao.yang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
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
index 7f0b7181e60a..30aa7d7c783e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13254,6 +13254,17 @@ L:	netdev@vger.kernel.org
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

