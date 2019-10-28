Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56E4FE75C9
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 17:08:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390802AbfJ1QIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 12:08:10 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55478 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730787AbfJ1QIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 12:08:10 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9SFqUmT011338
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 12:08:08 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vx06x82yw-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 12:08:08 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Mon, 28 Oct 2019 16:08:06 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 28 Oct 2019 16:08:03 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9SG7TWW37290408
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 16:07:29 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E8F6C52065;
        Mon, 28 Oct 2019 16:08:02 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id A7D4352051;
        Mon, 28 Oct 2019 16:08:02 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, Julian Wiedmann <jwi@linux.ibm.com>,
        Jarod Wilson <jarod@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH net-next] Documentation: net-sysfs: describe missing statistics
Date:   Mon, 28 Oct 2019 17:08:00 +0100
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
x-cbid: 19102816-4275-0000-0000-0000037880A9
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102816-4276-0000-0000-0000388BB441
Message-Id: <20191028160800.69707-1-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-28_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910280160
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sync the ABI description with the interface statistics that are currently
available through sysfs.

CC: Jarod Wilson <jarod@redhat.com>
CC: Jonathan Corbet <corbet@lwn.net>
CC: linux-doc@vger.kernel.org
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 .../ABI/testing/sysfs-class-net-statistics       | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-class-net-statistics b/Documentation/ABI/testing/sysfs-class-net-statistics
index 397118de7b5e..55db27815361 100644
--- a/Documentation/ABI/testing/sysfs-class-net-statistics
+++ b/Documentation/ABI/testing/sysfs-class-net-statistics
@@ -51,6 +51,14 @@ Description:
 		packet processing. See the network driver for the exact
 		meaning of this value.
 
+What:		/sys/class/<iface>/statistics/rx_errors
+Date:		April 2005
+KernelVersion:	2.6.12
+Contact:	netdev@vger.kernel.org
+Description:
+		Indicates the number of receive errors on this network device.
+		See the network driver for the exact meaning of this value.
+
 What:		/sys/class/<iface>/statistics/rx_fifo_errors
 Date:		April 2005
 KernelVersion:	2.6.12
@@ -88,6 +96,14 @@ Description:
 		due to lack of capacity in the receive side. See the network
 		driver for the exact meaning of this value.
 
+What:		/sys/class/<iface>/statistics/rx_nohandler
+Date:		February 2016
+KernelVersion:	4.6
+Contact:	netdev@vger.kernel.org
+Description:
+		Indicates the number of received packets that were dropped on
+		an inactive device by the network core.
+
 What:		/sys/class/<iface>/statistics/rx_over_errors
 Date:		April 2005
 KernelVersion:	2.6.12
-- 
2.17.1

