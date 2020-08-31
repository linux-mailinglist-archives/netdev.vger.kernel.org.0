Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2D73257F24
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 18:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728874AbgHaQ6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 12:58:42 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46028 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728211AbgHaQ6X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 12:58:23 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07VGjUTj186934
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 12:58:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=UhbNYWKQNFLz72Gfbsik60f05/Na1Obg3q6ckTkMXjw=;
 b=Q7ctWZuUy6+KoDvR2c36SbCyhPmiNtdEPxih4s5PHtV/7Yut1Y2tf7He/Ym+QbUSFjVo
 a3uiqVCI3f7qG2xEG3EGCA5YSyuuZZC1SKQk2JyT6rYlW3o8HfvzI/Rn7P9Zg2DXfBCN
 yffb/JWeYogPCgIipGCQf9OGFTNBQ+T+qJT3VpGfcyaQEX4pEntWFxY0mNbwhVCwZFPi
 nqBKtr/FD1U1qz6QnVEbxssGuuQIPV+3V8k6ZppkKOvRCB0ROgHSLhM/JNrrug6Jj0WR
 yzs//9u1xlgi2M9Um5xsef4a4wKVfHKXdW0E+eft1kcqkIEBriEUJoxhZSHgrkhGrjA8 og== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33950sr8mr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 12:58:23 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07VGrMdv032202
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 16:58:22 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma01dal.us.ibm.com with ESMTP id 337en95vf9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 16:58:22 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07VGwLDf16057174
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 16:58:21 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 82F56B205F;
        Mon, 31 Aug 2020 16:58:21 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E30D1B2065;
        Mon, 31 Aug 2020 16:58:20 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.160.96.4])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 31 Aug 2020 16:58:20 +0000 (GMT)
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     drt@linux.vnet.ibm.com, sukadev@linux.vnet.ibm.com,
        ljp@linux.vnet.ibm.com, cforno12@linux.ibm.com,
        Thomas Falcon <tlfalcon@linux.ibm.com>
Subject: [PATCH net-next 5/5] ibmvnic: Provide documentation for ACL sysfs files
Date:   Mon, 31 Aug 2020 11:58:13 -0500
Message-Id: <1598893093-14280-6-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1598893093-14280-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1598893093-14280-1-git-send-email-tlfalcon@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-31_07:2020-08-31,2020-08-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 suspectscore=1 priorityscore=1501 bulkscore=0 lowpriorityscore=0
 spamscore=0 mlxscore=0 malwarescore=0 mlxlogscore=919 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310095
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide documentation for ibmvnic device Access Control List
files.

Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
---
 Documentation/ABI/testing/sysfs-driver-ibmvnic | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-driver-ibmvnic b/Documentation/ABI/testing/sysfs-driver-ibmvnic
index 7fa2920..8c78312 100644
--- a/Documentation/ABI/testing/sysfs-driver-ibmvnic
+++ b/Documentation/ABI/testing/sysfs-driver-ibmvnic
@@ -12,3 +12,29 @@ Description:	If the ibmvnic device has been configured with redundant
 		returned.
 Users:		Any users of the ibmvnic driver which use redundant hardware
 		configurations.
+
+What:		/sys/devices/vio/<our device>/mac_acls
+Date:		August 2020
+KernelVersion:	5.10
+Contact:	linuxppc-dev@lists.ozlabs.org
+Description:	Read-only file which lists the current entries in the ibmvnic
+		device's MAC address Access Control List. Each entry is
+		separated by a new line.
+Users:		Any users of the ibmvnic driver
+
+What:		/sys/devices/vio/<our device>/vlan_acls
+Date:		August 2020
+KernelVersion:	5.10
+Contact:	linuxppc-dev@lists.ozlabs.org
+Description:	Read-only file which lists the current entries in the ibmvnic
+		device's VLAN ID Access Control List. Each entry is separated
+		by a new line.
+Users:		Any users of the ibmvnic driver
+
+What:		/sys/devices/vio/<our device>/pvid
+Date:		August 2020
+KernelVersion:	5.10
+Contact:	linuxppc-dev@lists.ozlabs.org
+Description:	Read-only file which lists the ibmvnic device's Port VLAN
+		ID and Priority setting. Each entry is separated by a new line.
+Users:		Any users of the ibmvnic driver
-- 
1.8.3.1

