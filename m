Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B670275354
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 10:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbgIWIhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 04:37:15 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33986 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726359AbgIWIhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 04:37:13 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08N8XZtm042752;
        Wed, 23 Sep 2020 04:37:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=Kgzp/QAU8YLFSLQ2LlcsteMHNXfz8DE/rJu3ziEITeQ=;
 b=QON1hMoQ9CYavrNHN1/9hlz0lGLXscOj5rSni7UX4fNzgLqvMKHbW1t99/YUOPfFiXj9
 7ymfQkQID5ik+JvJm0IEasNOT+B4U+Zhm04SOdTWMPy6mTh1vNTdgQUhucg/YRMk6gqa
 gvYISu7/KsGPSZpvhg08/eGi3OyAVhCEYi1WCF4u8bqRUoKhYnqVl8DTCjVaTOX1LLBV
 xEHMg25NTjgtuaDv+dyur5pqF7M08X45wmi+VDdqHlwnc3v5nu5RBvgr0xsAzH3D3bke
 jz0/4cw6vng+yet7mawJRt2iDVALzHX5Ky5LvQubBRlKayCjIWTkqmgt6N4aRkNBwPNX iw== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33r27m1j7s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Sep 2020 04:37:07 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08N8Z0Ja012185;
        Wed, 23 Sep 2020 08:37:06 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 33n98gt2a5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Sep 2020 08:37:06 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08N8b3co27263402
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Sep 2020 08:37:03 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C79C11C052;
        Wed, 23 Sep 2020 08:37:03 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C10CB11C04A;
        Wed, 23 Sep 2020 08:37:02 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Sep 2020 08:37:02 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 0/9] s390/qeth: updates 2020-09-23
Date:   Wed, 23 Sep 2020 10:36:51 +0200
Message-Id: <20200923083700.44624-1-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-23_03:2020-09-23,2020-09-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 malwarescore=0
 mlxscore=0 impostorscore=0 clxscore=1015 lowpriorityscore=0 adultscore=0
 bulkscore=0 mlxlogscore=714 spamscore=0 priorityscore=1501 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009230069
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave & Jakub,

please apply the following patch series for qeth to netdev's net-next tree.

This brings all sorts of cleanups. Highlights are more code sharing in
the init/teardown paths, and more fine-grained rollback on errors during
initialization (instead of a full-blown teardown).

Thanks,
Julian

Julian Wiedmann (9):
  s390/qeth: don't init refcount twice for mcast IPs
  s390/qeth: relax locking for ipato config data
  s390/qeth: clean up string ops in qeth_l3_parse_ipatoe()
  s390/qeth: replace deprecated simple_stroul()
  s390/qeth: tighten ucast IP locking
  s390/qeth: cancel cmds earlier during teardown
  s390/qeth: consolidate online code
  s390/qeth: consolidate teardown code
  s390/qeth: remove forward declarations in L2 code

 drivers/s390/net/qeth_core.h      |  22 +-
 drivers/s390/net/qeth_core_main.c |  71 +++--
 drivers/s390/net/qeth_core_sys.c  |  65 ++---
 drivers/s390/net/qeth_l2.h        |   7 +
 drivers/s390/net/qeth_l2_main.c   | 412 +++++++++++++-----------------
 drivers/s390/net/qeth_l3.h        |   4 +-
 drivers/s390/net/qeth_l3_main.c   |  88 ++-----
 drivers/s390/net/qeth_l3_sys.c    |  64 ++---
 8 files changed, 338 insertions(+), 395 deletions(-)

-- 
2.17.1

