Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35D9B3C40F6
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 03:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232613AbhGLBlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 21:41:15 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:10467 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbhGLBlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 21:41:14 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GNRCd0xHbzccKh;
        Mon, 12 Jul 2021 09:35:09 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 12 Jul 2021 09:38:24 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 12 Jul 2021 09:38:24 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <chenhao288@hisilicon.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 1/9] devlink: add documentation for hns3 driver
Date:   Mon, 12 Jul 2021 09:34:50 +0800
Message-ID: <1626053698-46849-2-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1626053698-46849-1-git-send-email-huangguangbin2@huawei.com>
References: <1626053698-46849-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hao Chen <chenhao288@hisilicon.com>

Add a file to document devlink support for hns3 driver.

Now support devlink param and devlink info.

Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 Documentation/networking/devlink/hns3.rst  | 51 ++++++++++++++++++++++++++++++
 Documentation/networking/devlink/index.rst |  1 +
 2 files changed, 52 insertions(+)
 create mode 100644 Documentation/networking/devlink/hns3.rst

diff --git a/Documentation/networking/devlink/hns3.rst b/Documentation/networking/devlink/hns3.rst
new file mode 100644
index 000000000000..798158eb96ee
--- /dev/null
+++ b/Documentation/networking/devlink/hns3.rst
@@ -0,0 +1,51 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+====================
+hns3 devlink support
+====================
+
+This document describes the devlink features implemented by the ``hns3``
+device driver.
+
+Parameters
+==========
+
+The ``hns3`` driver implements the following driver-specific
+parameters.
+
+.. list-table:: Driver-specific parameters implemented
+   :widths: 10 10 10 70
+
+   * - Name
+     - Type
+     - Mode
+     - Description
+   * - ``rx_buf_len``
+     - U32
+     - driverinit
+     - Set rx BD buffer size.
+
+       * Now only support setting 2048 and 4096.
+   * - ``tx_buf_size``
+     - U32
+     - driverinit
+     - Set tx spare buf size.
+
+       * The size is setted for tx bounce feature.
+
+The ``hns3`` driver supports reloading via ``DEVLINK_CMD_RELOAD``
+
+Info versions
+=============
+
+The ``hns3`` driver reports the following versions
+
+.. list-table:: devlink info versions implemented
+   :widths: 10 10 80
+
+   * - Name
+     - Type
+     - Description
+   * - ``fw``
+     - running
+     - Used to represent the firmware version.
diff --git a/Documentation/networking/devlink/index.rst b/Documentation/networking/devlink/index.rst
index b3b9e0692088..03f56ed2961f 100644
--- a/Documentation/networking/devlink/index.rst
+++ b/Documentation/networking/devlink/index.rst
@@ -34,6 +34,7 @@ parameters, info versions, and other features it supports.
    :maxdepth: 1
 
    bnxt
+   hns3
    ionic
    ice
    mlx4
-- 
2.8.1

