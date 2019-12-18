Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F23F124DC9
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 17:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727549AbfLRQe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 11:34:59 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:10096 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727533AbfLRQe6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 11:34:58 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBIGYU52120999
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 11:34:58 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wykb72s36-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 11:34:57 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Wed, 18 Dec 2019 16:34:55 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 18 Dec 2019 16:34:53 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBIGYpea63832248
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 16:34:51 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB2C3A4053;
        Wed, 18 Dec 2019 16:34:51 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8567DA4057;
        Wed, 18 Dec 2019 16:34:51 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 18 Dec 2019 16:34:51 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 0/9] s390/qeth: features 2019-12-18
Date:   Wed, 18 Dec 2019 17:34:41 +0100
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
x-cbid: 19121816-0020-0000-0000-00000399938A
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19121816-0021-0000-0000-000021F0B762
Message-Id: <20191218163450.36731-1-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-18_05:2019-12-17,2019-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 clxscore=1015 lowpriorityscore=0 bulkscore=0 impostorscore=0
 mlxlogscore=748 adultscore=0 malwarescore=0 phishscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912180136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

please apply the following patch series to your net-next tree.
Nothing major, just the usual mix of small improvements and cleanups.

Thanks,
Julian


Julian Wiedmann (9):
  s390/qeth: only handle IRQs while device is online
  s390/qeth: wake up all waiters from qeth_irq()
  s390/qeth: overhaul L3 IP address dump code
  s390/qeth: clean up L3 sysfs code
  s390/qeth: remove open-coded inet_make_mask()
  s390/qeth: don't raise NETDEV_REBOOT event from L3 offline path
  s390/qeth: stop yielding the ip_lock during IPv4 registration
  s390/qeth: consolidate helpers for capability checking
  s390/qeth: make use of napi_schedule_irqoff()

 drivers/s390/net/qeth_core.h      |  54 ++--------
 drivers/s390/net/qeth_core_main.c | 125 ++++++++++------------
 drivers/s390/net/qeth_core_mpc.h  |  21 ++--
 drivers/s390/net/qeth_l3.h        |   6 +-
 drivers/s390/net/qeth_l3_main.c   | 106 ++++++------------
 drivers/s390/net/qeth_l3_sys.c    | 172 ++++++++++--------------------
 6 files changed, 176 insertions(+), 308 deletions(-)

-- 
2.17.1

