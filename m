Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D74EA58519
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 17:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbfF0PCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 11:02:53 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45032 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726497AbfF0PCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 11:02:53 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5RF2FID142618
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 11:02:52 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tcy4rbq36-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 11:02:37 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Thu, 27 Jun 2019 16:01:39 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 27 Jun 2019 16:01:36 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5RF1PuE40763728
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jun 2019 15:01:25 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 294A2A4068;
        Thu, 27 Jun 2019 15:01:35 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D0CB8A405F;
        Thu, 27 Jun 2019 15:01:34 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 Jun 2019 15:01:34 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 00/12] s390/qeth: updates 2019-06-27
Date:   Thu, 27 Jun 2019 17:01:21 +0200
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
x-cbid: 19062715-0008-0000-0000-000002F7B600
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19062715-0009-0000-0000-00002264EFAC
Message-Id: <20190627150133.58746-1-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-27_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=976 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906270175
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

please apply another round of qeth updates for net-next.
This completes the conversion of the control path to use dynamically
allocated cmd buffers, along with some fine-tuning for the route
validation fix that recently went into -net.

Thanks,
Julian

Julian Wiedmann (12):
  s390/qeth: dynamically allocate simple IPA cmds
  s390/qeth: clarify parameter for simple assist cmds
  s390/qeth: dynamically allocate various cmds with sub-types
  s390/qeth: dynamically allocate diag cmds
  s390/qeth: dynamically allocate vnicc cmds
  s390/qeth: dynamically allocate MPC cmds
  s390/qeth: remove static cmd buffer infrastructure
  s390/qeth: streamline SNMP cmd code
  s390/qeth: consolidate pm code
  s390/qeth: consolidate skb RX processing in L3 driver
  s390/qeth: extract helper for route validation
  s390/qeth: move cast type selection into fill_header()

 drivers/s390/net/qeth_core.h      |  94 +++---
 drivers/s390/net/qeth_core_main.c | 517 +++++++++++-------------------
 drivers/s390/net/qeth_core_mpc.h  |  49 ++-
 drivers/s390/net/qeth_l2_main.c   | 201 +++++-------
 drivers/s390/net/qeth_l3_main.c   | 210 +++++-------
 5 files changed, 425 insertions(+), 646 deletions(-)

-- 
2.17.1

