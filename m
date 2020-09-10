Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F42D264A45
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 18:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbgIJQuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 12:50:07 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57258 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726794AbgIJQtV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 12:49:21 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08AGY6Yu183091;
        Thu, 10 Sep 2020 12:49:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=b2/FRod3jOvmexo+OTH1PWQX3HffJE0FdPl/mLD8xvU=;
 b=dSAFN2Gu0hAC1NRyO5yM575n2pGagX3BV6myRHCnrcd4MeL0g7an5hoR+OgYzgJ/VImH
 6cCkTYt4mdfQc7AF7L80mPg5DeAe+fmk6BPgEUPwiu3e4EVPV2v9kKH1eYq8AkJhifbt
 4QzhlEExNihy+1l4IB85ZSI2tyJn8exljyzqVoFaoSpggKobANMceU4rhxtQgkKJ1naJ
 kG0K9ail3+xINKgQhLDtb0EtJU/KLRsO2i5YxaIRIJWy9rBSXfFNiYGPlHMyf8asnBQY
 4Eni2EKVN6TjGqfCSFinolpEoWRz4mAp1KcydzM31s3Q/LrxggX6TC+vtbNNknIq6IGC Sw== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33fq1paakb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 12:49:04 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08AGlqQk023937;
        Thu, 10 Sep 2020 16:49:02 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 33c2a86990-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 16:49:01 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08AGmx0l29032740
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Sep 2020 16:48:59 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0ACCE4C050;
        Thu, 10 Sep 2020 16:48:59 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C7BAB4C046;
        Thu, 10 Sep 2020 16:48:58 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 10 Sep 2020 16:48:58 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 00/10] net/smc: updates 2020-09-10
Date:   Thu, 10 Sep 2020 18:48:19 +0200
Message-Id: <20200910164829.65426-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-10_05:2020-09-10,2020-09-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 mlxscore=0 suspectscore=1 bulkscore=0 spamscore=0 clxscore=1015
 priorityscore=1501 mlxlogscore=387 lowpriorityscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009100153
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please apply the following patch series for smc to netdev's net-next tree.

This patch series is a mix of various improvements and cleanups.
The patches 1 and 10 improve the handling of large parallel workloads.
Patch 8 corrects a kernel config default for config CCWGROUP on s390.
Patch 9 allows userspace tools to retrieve socket information for more
sockets.

Guvenc Gulce (2):
  s390/net: Add SMC config as one of the defaults of CCWGROUP
  net/smc: Use the retry mechanism for netlink messages

Karsten Graul (1):
  net/smc: use separate work queues for different worker types

Ursula Braun (7):
  net/smc: reduce active tcp_listen workers
  net/smc: introduce better field names
  net/smc: dynamic allocation of CLC proposal buffer
  net/smc: common routine for CLC accept and confirm
  net/smc: improve server ISM device determination
  net/smc: reduce smc_listen_decline() calls
  net/smc: immediate freeing in smc_lgr_cleanup_early()

 drivers/s390/net/Kconfig |   2 +-
 net/smc/af_smc.c         | 216 +++++++++++++++++++---------------
 net/smc/smc.h            |   7 ++
 net/smc/smc_cdc.c        |   4 +-
 net/smc/smc_clc.c        | 243 ++++++++++++++++++---------------------
 net/smc/smc_clc.h        |  93 +++++++--------
 net/smc/smc_close.c      |   7 +-
 net/smc/smc_core.c       |  56 ++++-----
 net/smc/smc_core.h       |  11 +-
 net/smc/smc_diag.c       |  30 +++--
 net/smc/smc_llc.c        |   2 +-
 net/smc/smc_pnet.c       |   5 +-
 net/smc/smc_tx.c         |  10 +-
 13 files changed, 357 insertions(+), 329 deletions(-)

-- 
2.17.1

