Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD846633B6C
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 12:32:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232128AbiKVLc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 06:32:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233502AbiKVLcI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 06:32:08 -0500
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB295288E;
        Tue, 22 Nov 2022 03:27:24 -0800 (PST)
X-UUID: e76ffcae5c714fee94eba8a586db9c6b-20221122
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=HLfCmvTA7XX9kHpprIfVaZHlyBrC288B65o6uhfAvVg=;
        b=QcQ9rKFcHLZE9DKEVcitV7RjbzhcUIxC/KEg89SEYZiS9Ij1sRjSml3EPPmziJAriUOSW/DQLDC7aPvshmk8HmQNN63MeL7yBpOx2shuw8UaBFWD7yigda+vas4E20n5JOL8YB/iJKPsndzWk3/VlmjpbfhWzlV4tjdMK3xSvN8=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.12,REQID:a7780134-a06a-406c-a025-c71dc2660dc1,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:95
X-CID-INFO: VERSION:1.1.12,REQID:a7780134-a06a-406c-a025-c71dc2660dc1,IP:0,URL
        :0,TC:0,Content:0,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Spam_GS981B3D,ACTION
        :quarantine,TS:95
X-CID-META: VersionHash:62cd327,CLOUDID:bca3fbf8-3a34-4838-abcf-dfedf9dd068e,B
        ulkID:2211221927200U8INVQ6,BulkQuantity:0,Recheck:0,SF:38|28|17|19|48,TC:n
        il,Content:0,EDM:-3,IP:nil,URL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
X-UUID: e76ffcae5c714fee94eba8a586db9c6b-20221122
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
        (envelope-from <yanchao.yang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 945321861; Tue, 22 Nov 2022 19:27:18 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Tue, 22 Nov 2022 19:27:16 +0800
Received: from mcddlt001.gcn.mediatek.inc (10.19.240.15) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Tue, 22 Nov 2022 19:27:14 +0800
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
CC:     MTK ML <linux-mediatek@lists.infradead.org>,
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
        Haozhe Chang <haozhe.chang@mediatek.com>,
        MediaTek Corporation <linuxwwan@mediatek.com>
Subject: [PATCH net-next v1 13/13] net: wwan: tmi: Add maintainers and documentation
Date:   Tue, 22 Nov 2022 19:27:10 +0800
Message-ID: <20221122112710.161020-1-yanchao.yang@mediatek.com>
X-Mailer: git-send-email 2.18.0
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

From: MediaTek Corporation <linuxwwan@mediatek.com>

Adds maintainers and documentation for MediaTek TMI 5G WWAN modem
device driver.

Signed-off-by: Felix Chen <felix.chen@mediatek.com>
Signed-off-by: MediaTek Corporation <linuxwwan@mediatek.com>
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
index a96c60c787af..eac544b274ac 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13058,6 +13058,17 @@ L:	netdev@vger.kernel.org
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

