Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7975243E1A7
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 15:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbhJ1NKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 09:10:54 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:1936 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230318AbhJ1NKv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 09:10:51 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19SA5V8S021914;
        Thu, 28 Oct 2021 06:08:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=CCgD8LF29Udc/Z2uA672X7IHzFZhy+sMpnJgvXavnSI=;
 b=j3nLlv5edeTYle6dTgivTmrJYz88MUUNLIu4Zhx10Q64c+q/m1knov7jDCBpb3MMR5Aw
 D2g28qjIAZrQc53d80q2mFVGjoKk4pmlfTfMGwV8Ip5ra4FKAD+40932X4RRBVuTg/Tx
 abmPhMbQb/IKUaZ1v1KiYzb0ZMKCOWtfp/xBYbHt9TEcfesZ47SpOibTcwAwlj29Ep5/
 OUI9+B3VcikbjQfAJiCrlag0auDs4KpXz26V+vh19CeLsZmQV79EXNiHt+K7SmrQbPgC
 zQYRac8SACki+cbAa724KBVNzhN8jzMacNJ9+x6zASzowPTK1PHZMsj485zFtekjA/gc 1w== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3byd2fbmfv-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 28 Oct 2021 06:08:21 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 28 Oct
 2021 06:08:20 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 28 Oct 2021 06:08:19 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id BF6733F706B;
        Thu, 28 Oct 2021 06:08:17 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <hkelam@marvell.com>, <gakula@marvell.com>, <sgoutham@marvell.com>,
        <rsaladi2@marvell.com>, Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH] devlink: add documentation for octeontx2 driver
Date:   Thu, 28 Oct 2021 18:38:15 +0530
Message-ID: <1635426495-28458-1-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: UKujdQiH-A7GyDJ8sKipONSB-J9dESRO
X-Proofpoint-GUID: UKujdQiH-A7GyDJ8sKipONSB-J9dESRO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-28_01,2021-10-26_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a file to document devlink support for octeontx2
driver. Driver-specific parameters implemented by
AF, PF and VF drivers are documented.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 Documentation/networking/devlink/index.rst     |  1 +
 Documentation/networking/devlink/octeontx2.rst | 42 ++++++++++++++++++++++++++
 2 files changed, 43 insertions(+)
 create mode 100644 Documentation/networking/devlink/octeontx2.rst

diff --git a/Documentation/networking/devlink/index.rst b/Documentation/networking/devlink/index.rst
index 19ffd56..4431237 100644
--- a/Documentation/networking/devlink/index.rst
+++ b/Documentation/networking/devlink/index.rst
@@ -48,3 +48,4 @@ parameters, info versions, and other features it supports.
    am65-nuss-cpsw-switch
    prestera
    iosm
+   octeontx2
diff --git a/Documentation/networking/devlink/octeontx2.rst b/Documentation/networking/devlink/octeontx2.rst
new file mode 100644
index 0000000..610de99
--- /dev/null
+++ b/Documentation/networking/devlink/octeontx2.rst
@@ -0,0 +1,42 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=========================
+octeontx2 devlink support
+=========================
+
+This document describes the devlink features implemented by the ``octeontx2 AF, PF and VF``
+device drivers.
+
+Parameters
+==========
+
+The ``octeontx2 PF and VF`` drivers implement the following driver-specific parameters.
+
+.. list-table:: Driver-specific parameters implemented
+   :widths: 5 5 5 85
+
+   * - Name
+     - Type
+     - Mode
+     - Description
+   * - ``mcam_count``
+     - u16
+     - runtime
+     - Select number of match CAM entries to be allocated for an interface.
+       The same is used for ntuple filters of the interface. Supported by
+       PF and VF drivers.
+
+The ``octeontx2 AF`` driver implements the following driver-specific parameters.
+
+.. list-table:: Driver-specific parameters implemented
+   :widths: 5 5 5 85
+
+   * - Name
+     - Type
+     - Mode
+     - Description
+   * - ``dwrr_mtu``
+     - u32
+     - runtime
+     - Use to set the quantum which hardware uses for scheduling among transmit queues.
+       Hardware uses weighted DWRR algorithm to schedule among all transmit queues.
-- 
2.7.4

