Return-Path: <netdev+bounces-2339-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BFF3570156E
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 10:56:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA4091C211A1
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 08:55:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05B8F1111;
	Sat, 13 May 2023 08:55:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED62610E1
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 08:55:58 +0000 (UTC)
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B484D12A;
	Sat, 13 May 2023 01:55:57 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34D8bLjW024516;
	Sat, 13 May 2023 01:55:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=Pr0kr9n/DzGBe9MTqSwgVAn7Iur8skCjJRNn9qOW+Uw=;
 b=jOrFsBvxQeoRH3m6xzJRzDgneBACLQFBSPIyZ0AbVbjNtPoltvOr63umvL+uBAefSksK
 8+soHURaO1GEMlgrJnpv7NbKtptZiaDIjyf9HFWahV4k7yYqWtKt5g+Vj4bfVzeCp/ca
 MOhYc/k2kAtYqkAAuUpOtUinuar9HMUQDngF+BzG4aV3Q5tTG751WxhitVe7AdpumCwC
 +ZlSsN+fseeErDeJqfgEGAGZv9VwVqW+nrkicn5Pi0bWmNz199Xmqz+AwHZtPvsarwT8
 xU1joE0h15OQQCHkgyFXdDsnA0xEr8KSCo0XRrtpgBfbI1h5ftH3dmKJcBPYUy6cPN0u CQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3qhs82tgdk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Sat, 13 May 2023 01:55:47 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Sat, 13 May
 2023 01:55:45 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Sat, 13 May 2023 01:55:45 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
	by maili.marvell.com (Postfix) with ESMTP id 9501D5B6F81;
	Sat, 13 May 2023 01:52:44 -0700 (PDT)
From: Hariprasad Kelam <hkelam@marvell.com>
To: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <kuba@kernel.org>, <davem@davemloft.net>,
        <willemdebruijn.kernel@gmail.com>, <andrew@lunn.ch>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>, <gakula@marvell.com>,
        <jerinj@marvell.com>, <sbhatta@marvell.com>, <hkelam@marvell.com>,
        <naveenm@marvell.com>, <edumazet@google.com>, <pabeni@redhat.com>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <maxtram95@gmail.com>, <corbet@lwn.net>, <linux-doc@vger.kernel.org>
Subject: [net-next Patch v10 8/8] docs: octeontx2: Add Documentation for QOS
Date: Sat, 13 May 2023 14:21:43 +0530
Message-ID: <20230513085143.3289-9-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230513085143.3289-1-hkelam@marvell.com>
References: <20230513085143.3289-1-hkelam@marvell.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: Jdu_l_nvF9-zxkij4P59xjPaxMzUhxpX
X-Proofpoint-ORIG-GUID: Jdu_l_nvF9-zxkij4P59xjPaxMzUhxpX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-13_06,2023-05-05_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

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


