Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2CBE2804BE
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 19:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732835AbgJARLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 13:11:51 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14276 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732213AbgJARLv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 13:11:51 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 091H4Q7p164137;
        Thu, 1 Oct 2020 13:11:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=7HYd247Ic8iyvRm6N7LXfzAGe5JT4hjDQbL+SDolh7w=;
 b=Rjonb6Gnw0+M1m2u3SOzBTNxmd4gz59//5SprWxZzkfF2VcyZXhkU4+2o8l7PHgd1cA0
 GKW+RtJZyRHaOZ/2PvcCJKtf+cuxjvGCsJB5wW3CtTRUj5NpAqRbovq3dL1xT0e+xj61
 g/bluiHbR2LtAgoeWOD0cc40JxjgvehLpMOx+/t/z4YxyChrMTP1EyFHzNKwklsh26Nx
 +e/rGjTVFM90F8K/WXBJC9PEDaYVXM53zs4rcUxuGBfrYeOCoBStbRQfjQSRdi4xSukP
 b+pwFjtM8bC7guRYSGiq1Pg4fs9KpTdMFABxT/r/HnO9UIEf/+g5l4Kh0GIFK22gsgCD zQ== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33wh4andfb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Oct 2020 13:11:46 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 091H2tpH017937;
        Thu, 1 Oct 2020 17:11:44 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 33sw97wrt6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Oct 2020 17:11:44 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 091HBgQm10617342
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Oct 2020 17:11:42 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 099C0A4051;
        Thu,  1 Oct 2020 17:11:42 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B2FD1A4040;
        Thu,  1 Oct 2020 17:11:41 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  1 Oct 2020 17:11:41 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 0/7] s390/net: updates 2020-10-01
Date:   Thu,  1 Oct 2020 19:11:29 +0200
Message-Id: <20201001171136.46830-1-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-01_06:2020-10-01,2020-10-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 phishscore=0 suspectscore=0 bulkscore=0 clxscore=1015
 mlxscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0 impostorscore=0
 mlxlogscore=562 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010010144
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave & Jakub,

please apply the following patch series to netdev's net-next tree.

Patches 1-3 enable qeth to also support the .set_channels() ethtool
callback for OSA devices. This completes support for the full range
of device types.

The other patches are just the usual mix of cleanups.
(Even one for ctcm!)

Thanks,
Julian

Julian Wiedmann (6):
  s390/qeth: keep track of wanted TX queues
  s390/qeth: de-magic the QIB parm area
  s390/qeth: allow configuration of TX queues for OSA devices
  s390/qeth: constify the disciplines
  s390/qeth: use netdev_name()
  s390/qeth: static checker cleanups

Vasily Gorbik (1):
  s390/ctcm: remove orphaned function declarations

 drivers/s390/net/ctcm_fsms.h      |   1 -
 drivers/s390/net/ctcm_mpc.h       |   1 -
 drivers/s390/net/qeth_core.h      |  54 ++++++++--
 drivers/s390/net/qeth_core_main.c | 163 ++++++++++++++----------------
 drivers/s390/net/qeth_core_sys.c  |   6 +-
 drivers/s390/net/qeth_ethtool.c   |  16 ++-
 drivers/s390/net/qeth_l2_main.c   |  28 ++---
 drivers/s390/net/qeth_l3_main.c   |  85 +++++++++-------
 drivers/s390/net/qeth_l3_sys.c    |   8 +-
 9 files changed, 202 insertions(+), 160 deletions(-)

-- 
2.17.1

