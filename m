Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99E1A1954FF
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 11:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgC0KTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 06:19:49 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44010 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726418AbgC0KTs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 06:19:48 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02RA23Wg072118
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 06:19:47 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yxw7h0xst-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 06:19:47 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Fri, 27 Mar 2020 10:19:44 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 27 Mar 2020 10:19:41 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02RAJeYc50266306
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 10:19:40 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 54D0B4C040;
        Fri, 27 Mar 2020 10:19:40 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 69C714C046;
        Fri, 27 Mar 2020 10:19:39 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 27 Mar 2020 10:19:39 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 0/3] s390/qeth: updates 2020-03-27
Date:   Fri, 27 Mar 2020 11:19:31 +0100
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
x-cbid: 20032710-0028-0000-0000-000003ECC1AB
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20032710-0029-0000-0000-000024B23953
Message-Id: <20200327101934.31040-1-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-27_02:2020-03-26,2020-03-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 adultscore=0 mlxlogscore=539
 mlxscore=0 suspectscore=0 bulkscore=0 priorityscore=1501 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003270087
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

please apply the following patch series for qeth to netdev's net-next
tree.

Spring clean edition:
- remove one sysfs attribute that was never put in use,
- make support for OSN and OSX devices optional, and
- probe for removal of the obsolete OSN support.

Thanks,
Julian

Julian Wiedmann (3):
  s390/qeth: remove fake_broadcast attribute
  s390/qeth: make OSN / OSX support configurable
  s390/qeth: phase out OSN support

 drivers/s390/net/Kconfig          | 17 +++++++++++++++
 drivers/s390/net/qeth_core.h      |  1 -
 drivers/s390/net/qeth_core_main.c |  4 ++++
 drivers/s390/net/qeth_core_mpc.h  | 11 ++++++++++
 drivers/s390/net/qeth_l2_main.c   |  5 +++++
 drivers/s390/net/qeth_l3_sys.c    | 35 -------------------------------
 6 files changed, 37 insertions(+), 36 deletions(-)

-- 
2.17.1

