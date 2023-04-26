Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE326EEDAB
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 07:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239466AbjDZFtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 01:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239433AbjDZFtP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 01:49:15 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9E4135AF;
        Tue, 25 Apr 2023 22:48:50 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33PJ0k0P012965;
        Tue, 25 Apr 2023 22:48:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=Pr0kr9n/DzGBe9MTqSwgVAn7Iur8skCjJRNn9qOW+Uw=;
 b=bzoPWVLKr8UfDXxjYwXvC+0eLApUlgxgdHDTuvUDhGhUlJuml5owLJ+ZlviSWCnatuq8
 mPihVpMymFPHYq63HwgUOMRiNb5p2s59cRFhsVES4SAWqk74gAxdrbJJqvSmROvbVlKi
 IAcRKDv8ZOd+cu7NpQITmpDZOCzfAngrdrFOaVVnSj6K3kxrDDeD3blj1Nv6uqcWz3iE
 SG+iPUGwe5spXUIH+35VmiFZvjehvFYJIhGt7SyXb+/Nm6RoYq/IQhhhX2f4dBe79QxS
 jiJ2p44w0BwBvJp8ruEPyMXHmaiUuWZ9UE3npLqjNXbKD9cy7rftjKxJ71sPR1gbP3ML Jw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3q6c2fcw3k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 25 Apr 2023 22:48:27 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Tue, 25 Apr
 2023 22:48:26 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Tue, 25 Apr 2023 22:48:26 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id A321B3F706D;
        Tue, 25 Apr 2023 22:48:20 -0700 (PDT)
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
Subject: [net-next Patch v10 8/8] docs: octeontx2: Add Documentation for QOS
Date:   Wed, 26 Apr 2023 11:17:31 +0530
Message-ID: <20230426054731.5720-9-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230426054731.5720-1-hkelam@marvell.com>
References: <20230426054731.5720-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: 29_RWryjuCcrM-fPT1syhH-ewNsBXlr4
X-Proofpoint-ORIG-GUID: 29_RWryjuCcrM-fPT1syhH-ewNsBXlr4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-26_02,2023-04-25_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add QOS example configuration along with tc-htb commands

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/marvell/octeontx2.rst            | 45 +++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst b/Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst
index 5ba9015336e2..bfd233cfac35 100644
--- a/Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst
+++ b/Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst
@@ -13,6 +13,7 @@ Contents
 - `Drivers`_
 - `Basic packet flow`_
 - `Devlink health reporters`_
+- `Quality of service`_
 
 Overview
 ========
@@ -287,3 +288,47 @@ For example::
 	 NIX_AF_ERR:
 	        NIX Error Interrupt Reg : 64
 	        Rx on unmapped PF_FUNC
+
+
+Quality of service
+==================
+
+
+Hardware algorithms used in scheduling
+--------------------------------------
+
+octeontx2 silicon and CN10K transmit interface consists of five transmit levels
+starting from SMQ/MDQ, TL4 to TL1. Each packet will traverse MDQ, TL4 to TL1
+levels. Each level contains an array of queues to support scheduling and shaping.
+The hardware uses the below algorithms depending on the priority of scheduler queues.
+once the usercreates tc classes with different priorities, the driver configures
+schedulers allocated to the class with specified priority along with rate-limiting
+configuration.
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
+
+Setup HTB offload
+-----------------
+
+1. Enable HW TC offload on the interface::
+
+        # ethtool -K <interface> hw-tc-offload on
+
+2. Crate htb root::
+
+        # tc qdisc add dev <interface> clsact
+        # tc qdisc replace dev <interface> root handle 1: htb offload
+
+3. Create tc classes with different priorities::
+
+        # tc class add dev <interface> parent 1: classid 1:1 htb rate 10Gbit prio 1
+
+        # tc class add dev <interface> parent 1: classid 1:2 htb rate 10Gbit prio 7
-- 
2.17.1

