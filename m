Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 786772C81D6
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 11:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728628AbgK3KKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 05:10:48 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:20598 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728527AbgK3KKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 05:10:47 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AUA1ZVe000943;
        Mon, 30 Nov 2020 05:09:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=lXJv62q+7dDlBbN/Mx4apxcIPWT/wADOvxZ/PZFg+ng=;
 b=A3Ix0Jgg7K+EGZgMtqc4s6v35lRT+a/HoAASDEGV5x22uHfIKFDjkm+9OlLFaomQ4umM
 cZRi5cPBCawTuAWeamDRfDs5bS9eAtdISogxaKQTAeIQ3hTb7A5RL9wftlgMDJo7ocO5
 8iMGSgbj7NsbjdkOBFmKMVuCwSNto3CUTG/kFFLe3lwpV00T3W1lEZ5aLIyBo4+UYNCa
 pbA0/XNOR2gUfqZG272jcNxAyLVIa/AI+H/WDowNQEGtB616g0vkwFbetgm01Sr5+vwr
 R6PigUxUnIqQaguE8xuE+RN8cfTN2s5n/wMW88W/S6LuBtwC6Gnr1QxY6oFEAHO1pMNE 5w== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 354xhvrbm6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Nov 2020 05:09:58 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AUA8QDo026461;
        Mon, 30 Nov 2020 10:09:56 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 353e689wbw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Nov 2020 10:09:56 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AUA9r6D59900300
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Nov 2020 10:09:53 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A139511C04C;
        Mon, 30 Nov 2020 10:09:53 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5224911C04A;
        Mon, 30 Nov 2020 10:09:53 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 30 Nov 2020 10:09:53 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net-next 0/6] s390/ctcm: updates 2020-11-30
Date:   Mon, 30 Nov 2020 11:09:44 +0100
Message-Id: <20201130100950.42051-1-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-30_02:2020-11-30,2020-11-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 mlxlogscore=908 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011300061
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

please apply the following patch series for ctcm to netdev's net-next tree.

Some rare ctcm updates by Sebastian, who cleans up all places where
in_interrupt() was used to determine the correct GFP_* mask for
allocations.
In the first three patches we can get rid of those allocations entirely,
as they just end up being copied into the skb.

Thanks,
Julian

Sebastian Andrzej Siewior (6):
  s390/ctcm: Avoid temporary allocation of struct th_header and
    th_sweep.
  s390/ctcm: Avoid temporary allocation of struct qllc.
  s390/ctcm: Avoid temporary allocation of struct pdu.
  s390/ctcm: Use explicit allocation mask in ctcmpc_unpack_skb().
  s390/ctcm: Use GFP_KERNEL in add_channel().
  s390/ctcm: Use GFP_ATOMIC in ctcmpc_tx().

 drivers/s390/net/ctcm_fsms.c | 15 +++-----
 drivers/s390/net/ctcm_main.c | 68 ++++++++----------------------------
 drivers/s390/net/ctcm_main.h |  5 ---
 drivers/s390/net/ctcm_mpc.c  | 39 ++++-----------------
 4 files changed, 24 insertions(+), 103 deletions(-)

-- 
2.17.1

