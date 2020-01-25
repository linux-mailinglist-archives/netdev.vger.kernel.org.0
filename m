Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5CC149675
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 16:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgAYPxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 10:53:15 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51150 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725843AbgAYPxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 10:53:14 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00PFbjas099225
        for <netdev@vger.kernel.org>; Sat, 25 Jan 2020 10:53:14 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xrjms6xn5-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 25 Jan 2020 10:53:13 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Sat, 25 Jan 2020 15:53:11 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sat, 25 Jan 2020 15:53:09 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00PFr72G62390480
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 Jan 2020 15:53:07 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 683CF4C040;
        Sat, 25 Jan 2020 15:53:07 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 259DA4C04A;
        Sat, 25 Jan 2020 15:53:07 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat, 25 Jan 2020 15:53:07 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 0/5] s390/qeth: updates 2020-01-25
Date:   Sat, 25 Jan 2020 16:52:58 +0100
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
x-cbid: 20012515-0028-0000-0000-000003D450FC
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20012515-0029-0000-0000-00002498919B
Message-Id: <20200125155303.40971-1-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-25_05:2020-01-24,2020-01-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 bulkscore=0 lowpriorityscore=0 mlxlogscore=597 suspectscore=0
 mlxscore=0 adultscore=0 clxscore=1015 impostorscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2001250132
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

please apply the following patch series for qeth to your net-next tree.

This brings a number of cleanups for the init/teardown code paths.

Thanks,
Julian

Julian Wiedmann (5):
  s390/qeth: shift some bridgeport code around
  s390/qeth: consolidate QDIO queue setup
  s390/qeth: consolidate online/offline code
  s390/qeth: make cmd/reply matching more flexible
  s390/qeth: remove HARDSETUP state

 drivers/s390/net/qeth_core.h      |  25 +++--
 drivers/s390/net/qeth_core_main.c | 156 ++++++++++++++++++++++++------
 drivers/s390/net/qeth_core_sys.c  |   2 -
 drivers/s390/net/qeth_l2.h        |   1 -
 drivers/s390/net/qeth_l2_main.c   | 126 ++++++------------------
 drivers/s390/net/qeth_l2_sys.c    |  34 -------
 drivers/s390/net/qeth_l3_main.c   | 109 ++-------------------
 7 files changed, 180 insertions(+), 273 deletions(-)

-- 
2.17.1

