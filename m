Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7032443C7B2
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 12:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241444AbhJ0KeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 06:34:01 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:50714 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241409AbhJ0Kd4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 06:33:56 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19R6I9DE032380;
        Wed, 27 Oct 2021 03:31:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=MBADCeqJ0U0+HojSjTf+nzcPW2oHKOkcHPH21yey2LE=;
 b=VOWZPHtKWN3woscdpZ36yPewL6cOFWlA+hJ58agVnH04dxnMdlVtSCHhaqot0OpaMZvq
 uk1hOh0sTNt3+EY4rxrItEya0CB8ZSiNJgEWkRbxhBTwHJ9ie5h65ULcsheUaD8XE2mA
 P6C0uyPdZy81hKCWqurNx0F82f0dikX7nOHIuemdYb1mBG4gzSHRbGyXsDnaaM9puyKB
 UdIWKNHPpQRTdNMSQO1/dagpevaF8a/9EpENMSjR9gZxHAIDDJ3Mcx3wKD/tXjO7ID/P
 Gnss632Y1jbjFqE8LTfq5lx8vBGfjaCuQvxE3F215C95whLJ9quzYUqxXXibEd4vrQYx Vw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3by1ca8xp6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 27 Oct 2021 03:31:28 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 27 Oct
 2021 03:31:26 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 27 Oct 2021 03:31:26 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id B9D273F7070;
        Wed, 27 Oct 2021 03:31:23 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <hkelam@marvell.com>, <gakula@marvell.com>, <sgoutham@marvell.com>,
        <rsaladi2@marvell.com>, Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH 2/2] devlink: add documentation for octeontx2 driver
Date:   Wed, 27 Oct 2021 16:01:15 +0530
Message-ID: <1635330675-25592-3-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1635330675-25592-1-git-send-email-sbhatta@marvell.com>
References: <1635330675-25592-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: KmRcylUvEog9r6JhlLUlCtjWeow3NEFp
X-Proofpoint-ORIG-GUID: KmRcylUvEog9r6JhlLUlCtjWeow3NEFp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-27_03,2021-10-26_01,2020-04-07_01
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
 Documentation/networking/devlink/octeontx2.rst | 47 ++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)
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
index 0000000..988fa21
--- /dev/null
+++ b/Documentation/networking/devlink/octeontx2.rst
@@ -0,0 +1,47 @@
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
+   * - ``serdes_link``
+     - bool
+     - runtime
+     - Use to initialize and de-initialize SerDes configuration. Command is
+       sent to firmware for SerDes configuration. Supported by PF driver
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

