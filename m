Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C73A6DD635
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 11:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbjDKJFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 05:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbjDKJFD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 05:05:03 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD38E3AA2;
        Tue, 11 Apr 2023 02:04:57 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33B8g4BS014870;
        Tue, 11 Apr 2023 02:04:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=ettstRGWvS56fnp3bZw7OTRsDyBJuDTMzGdoHrt4m3U=;
 b=idcspAdOrHA36DRIvGepsqn8DgMBnuUj5mfw1QOYq4ncIhKQTokN4/EiS5ESSlI7nepQ
 yIxDZXyJH1DftmvU1OdJ3D0pjDkRfE1G9Xc1MQLZ2BN6QPvQzcRNodDcUr7fxMWrCbgt
 3oH/86JVVY2YrcXT8AijMAsAyVJu8wWcZTZsGKD5EO3OhEjV53baZ/lhn2vCmwjC/kTI
 8Ba/MpCG1vzVvu/sw+6uDSzaE12W5/8c/Q9HziniZ98W2bOmfD/8v900AGOhtoBvUWXu
 v4DMTEO8Y2yp99sBVwcMT4Mk1sNbo9P0jx5f/pPkEYbVB3/nERsbdtlxESF7+ZQfkZ1e eQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3purfs93d0-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 11 Apr 2023 02:04:48 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Tue, 11 Apr
 2023 02:04:43 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Tue, 11 Apr 2023 02:04:43 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 3B8863F706F;
        Tue, 11 Apr 2023 02:04:37 -0700 (PDT)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>,
        <willemdebruijn.kernel@gmail.com>, <andrew@lunn.ch>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>, <naveenm@marvell.com>, <edumazet@google.com>,
        <pabeni@redhat.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <maxtram95@gmail.com>, <corbet@lwn.net>
Subject: [net-next Patch v9 6/6] docs: octeontx2: Add Documentation for QOS
Date:   Tue, 11 Apr 2023 14:33:59 +0530
Message-ID: <20230411090359.5134-7-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230411090359.5134-1-hkelam@marvell.com>
References: <20230411090359.5134-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 7HuvmxVok2XpKYBXR_Qtw6GJFYOqiedx
X-Proofpoint-GUID: 7HuvmxVok2XpKYBXR_Qtw6GJFYOqiedx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-11_05,2023-04-06_03,2023-02-09_01
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add QOS example configuration along with tc-htb commands

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/marvell/octeontx2.rst            | 39 +++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst b/Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst
index 5ba9015336e2..eca4309964c8 100644
--- a/Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst
+++ b/Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst
@@ -13,6 +13,7 @@ Contents
 - `Drivers`_
 - `Basic packet flow`_
 - `Devlink health reporters`_
+- `Quality of service`_
 
 Overview
 ========
@@ -287,3 +288,41 @@ For example::
 	 NIX_AF_ERR:
 	        NIX Error Interrupt Reg : 64
 	        Rx on unmapped PF_FUNC
+
+
+Quality of service
+==================
+
+octeontx2 silicon and CN10K transmit interface consists of five transmit levels starting from SMQ/MDQ, TL4 to TL1.
+The hardware uses the below algorithms depending on the priority of scheduler queues
+
+1. Strict Priority
+
+      -  Once packets are submitted to MDQ, hardware picks all active MDQs having different priority
+         using strict priority.
+
+2. Round Robin
+
+      - Active MDQs having the same priority level are chosen using round robin.
+
+3. Each packet will traverse MDQ, TL4 to TL1 levels. Each level contains an array of queues to support scheduling and
+   shaping.
+
+4. once the user creates tc classes with different priority
+
+   -  Driver configures schedulers allocated to the class with specified priority along with rate-limiting configuration.
+
+5. Enable HW TC offload on the interface::
+
+        # ethtool -K <interface> hw-tc-offload on
+
+6. Crate htb root::
+
+        # tc qdisc add dev <interface> clsact
+        # tc qdisc replace dev <interface> root handle 1: htb offload
+
+7. Create tc classes with different  priorities::
+
+        # tc class add dev <interface> parent 1: classid 1:1 htb rate 10Gbit prio 1
+
+        # tc class add dev <interface> parent 1: classid 1:2 htb rate 10Gbit prio 7
-- 
2.17.1

