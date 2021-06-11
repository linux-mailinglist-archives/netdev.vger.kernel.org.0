Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D18393A3D44
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 09:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbhFKHgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 03:36:12 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61524 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231437AbhFKHf6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 03:35:58 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15B7XcQM043065;
        Fri, 11 Jun 2021 03:33:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=CGIkfAPmDwpW5INTS4JNW3+TZVZmdzed1mgGP9qSomg=;
 b=llWf1khIIRzGku7/9jYKs2N+/r0O9qdUDvU3YosX1aDfHGo1ma90aPwmtO5dW1aWeZuB
 XE6NL66oDovcao0/Tcl9Em8sv/rngPge8BYWOsgbkxh2Utp9n8tewKFsvKb/nL2w1xMx
 bHzuXMcZmgGH7JoKmtyzS4AIZxsugtzh7nEbfFeD0t4p4esI4lOZfNqJnlj6OY+aBZNv
 xqguvwTcVRjiBsG3RQWhaubRRJ5Dt5VYBULbj6cL10RIHN3dOrf7WuC5AcWld5x8Lo4Z
 tZdOZgzXF8TshFg98TnhBLGWkBvLa8sadXVLlNDMD+M+LZt/2fg0jByD71zddQ0sfMRi 7A== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39424qj5q3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 03:33:57 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15B7W9BI029157;
        Fri, 11 Jun 2021 07:33:53 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 3900w89try-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 07:33:53 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15B7Wr5Z35455446
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jun 2021 07:32:53 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 164DEA4069;
        Fri, 11 Jun 2021 07:33:48 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D036CA4064;
        Fri, 11 Jun 2021 07:33:47 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 11 Jun 2021 07:33:47 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 0/9] s390/qeth: updates 2021-06-11
Date:   Fri, 11 Jun 2021 09:33:32 +0200
Message-Id: <20210611073341.1634501-1-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: p_T7zd2gt6TuZoCtv-qi9dyMdVwY7Shn
X-Proofpoint-ORIG-GUID: p_T7zd2gt6TuZoCtv-qi9dyMdVwY7Shn
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-11_01:2021-06-11,2021-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 clxscore=1015 lowpriorityscore=0 malwarescore=0 priorityscore=1501
 adultscore=0 bulkscore=0 mlxscore=0 mlxlogscore=626 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106110048
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave & Jakub,

please apply the following patch series for qeth to netdev's net-next tree.

This enables TX NAPI for those devices that didn't use it previously, so
that we can eventually rip out the qdio layer's internal interrupt
machinery.

Other than that it's just the normal mix of minor improvements and
cleanups.

Thanks,
Julian

Alexandra Winter (1):
  s390/qeth: Consider dependency on SWITCHDEV module

Julian Wiedmann (8):
  s390/qeth: count TX completion interrupts
  s390/qeth: also use TX NAPI for non-IQD devices
  s390/qeth: unify the tracking of active cmds on ccw device
  s390/qeth: use ethtool_sprintf()
  s390/qeth: consolidate completion of pending TX buffers
  s390/qeth: remove QAOB's pointer to its TX buffer
  s390/qeth: remove TX buffer's pointer to its queue
  s390/qeth: shrink TX buffer struct

 arch/s390/include/asm/qdio.h      |   4 +-
 drivers/s390/net/qeth_core.h      |  42 ++--
 drivers/s390/net/qeth_core_main.c | 349 ++++++++++++------------------
 drivers/s390/net/qeth_ethtool.c   |   7 +-
 drivers/s390/net/qeth_l2_main.c   |  12 +-
 5 files changed, 181 insertions(+), 233 deletions(-)

-- 
2.25.1

