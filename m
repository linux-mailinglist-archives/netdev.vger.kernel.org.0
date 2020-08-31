Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0B29257F20
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 18:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728844AbgHaQ6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 12:58:31 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18034 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726791AbgHaQ6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 12:58:21 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07VGVdik006363
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 12:58:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=Va1DDesDMf3g8OsCJV+vtm44WptYCAIBhEsHmuI3Ops=;
 b=bWVRx7EQvc2lwk2bAcjC8nhSPYZbyT4ed0ytgHGHNm5z8RP7Py3CwK9O3QmjHeded4Rr
 HJ6w+nNA3K4ogAPRB3c7MivEGHc5EXu5Voy/iKB5uIiIcAJcSo2xm3a/hiLfhlJ4lVUk
 n2Gt0smIDoUwQ2/L6A3hYA6spS//H9RRyYKuArovc/UFfWXpbYTf6GaOaMA2zy6ZH5BK
 uthbss39ftdeNk2BkNQQYWxmPhF2YOb5mgEdcSR3vxoIz21p7lNkd0H+2XflfhBqaOi4
 Ux9KAQ+GnWv3IpMfCstDk7Cwee1nwIDmkCETg2cnLmhsQcU0y1VNHQQCM8GdlQeSiADD vw== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33943w9v3x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 12:58:20 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07VGqiM2027464
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 16:58:19 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma02wdc.us.ibm.com with ESMTP id 337en99g01-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 16:58:19 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07VGwI5v28639594
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 16:58:18 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A48E5B2068;
        Mon, 31 Aug 2020 16:58:18 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 10678B205F;
        Mon, 31 Aug 2020 16:58:18 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.160.96.4])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 31 Aug 2020 16:58:17 +0000 (GMT)
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     drt@linux.vnet.ibm.com, sukadev@linux.vnet.ibm.com,
        ljp@linux.vnet.ibm.com, cforno12@linux.ibm.com,
        Thomas Falcon <tlfalcon@linux.ibm.com>
Subject: [PATCH net-next 2/5] ibmvnic: Include documentation for ibmvnic sysfs files
Date:   Mon, 31 Aug 2020 11:58:10 -0500
Message-Id: <1598893093-14280-3-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1598893093-14280-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1598893093-14280-1-git-send-email-tlfalcon@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-31_07:2020-08-31,2020-08-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=1
 lowpriorityscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 impostorscore=0
 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008310095
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Include documentation for existing ibmvnic sysfs files,
currently only for "failover," which is used to swap
the active hardware port to a backup port in redundant
backing hardware or failover configurations.

Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
---
 Documentation/ABI/testing/sysfs-driver-ibmvnic | 14 ++++++++++++++
 1 file changed, 14 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-ibmvnic

diff --git a/Documentation/ABI/testing/sysfs-driver-ibmvnic b/Documentation/ABI/testing/sysfs-driver-ibmvnic
new file mode 100644
index 0000000..7fa2920
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-driver-ibmvnic
@@ -0,0 +1,14 @@
+What:		/sys/devices/vio/<our device>/failover
+Date:		June 2017
+KernelVersion:	4.13
+Contact:	linuxppc-dev@lists.ozlabs.org
+Description:	If the ibmvnic device has been configured with redundant
+		physical NIC ports, the user may write "1" to the failover
+		file to trigger a device failover, which will reset the
+		ibmvnic device and swap to a backup physical port. If no
+		redundant physical port has been configured for the device,
+		the device will not reset and -EINVAL is returned. If anything
+		other than "1" is written to the file, -EINVAL will also be
+		returned.
+Users:		Any users of the ibmvnic driver which use redundant hardware
+		configurations.
-- 
1.8.3.1

