Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 465B62D1194
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 14:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbgLGNOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 08:14:40 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14424 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725770AbgLGNOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 08:14:39 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B7D3oxj157929;
        Mon, 7 Dec 2020 08:13:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=RaD+/PEnirNLFwXNFDKwBrU8bEXHLBNcAW/9ohh79zQ=;
 b=HThmSWNPVKhTk1sMrLjlvVj2KvpsOf5vnj0nBqIhTuu7Wn43J3CIVo3+c4KpFX/BxJGQ
 G83xbIxCX79Jy3FSK9aA23AfLarS7Nsg8u5DumsNZ8EMOGOXn0kuRLApXwdLPw9jHo+Q
 x//9g3ZXGooiBpaixqZuTD3GrFlcNzSycD0Ub3ARSDSpjlyO/bcxoLGC8TL5vX+4OxBs
 dYDLaVvuswO+XPMfGT58AagZh2OU7Ch9nZ7bhJCjr9H1DBQrFiDrFEGjllqtlN5LylCo
 7C7Iw8v00w3hCxY1DBejFbXLjAr/2dmOzPXdJ1U0tShq+04GyOY4SXxrhRfaJshwdwEG 4w== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 359m1ra2v6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Dec 2020 08:13:55 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B7DBvGr020554;
        Mon, 7 Dec 2020 13:13:53 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 3581u8kq0d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Dec 2020 13:13:53 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B7DCaQP29163882
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Dec 2020 13:12:36 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E7A2211C04A;
        Mon,  7 Dec 2020 13:12:35 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A77BC11C04C;
        Mon,  7 Dec 2020 13:12:35 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Dec 2020 13:12:35 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 0/6] s390/qeth: updates 2020-12-07
Date:   Mon,  7 Dec 2020 14:12:27 +0100
Message-Id: <20201207131233.90383-1-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-07_11:2020-12-04,2020-12-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 bulkscore=0 clxscore=1015 suspectscore=0 mlxlogscore=759 impostorscore=0
 adultscore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012070080
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

please apply the following patch series for qeth to netdev's net-next tree.

Some sysfs cleanups (with the prep work in ccwgroup acked by Heiko), and
a few improvements to the code that deals with async TX completion
notifications for IQD devices.

This also brings the missing patch from the previous net-next submission.

Thanks,
Julian

Julian Wiedmann (6):
  s390/qeth: don't call INIT_LIST_HEAD() on iob's list entry
  s390/ccwgroup: use bus->dev_groups for bus-based sysfs attributes
  s390/qeth: use dev->groups for common sysfs attributes
  s390/qeth: don't replace a fully completed async TX buffer
  s390/qeth: remove QETH_QDIO_BUF_HANDLED_DELAYED state
  s390/qeth: make qeth_qdio_handle_aob() more robust

 drivers/s390/cio/ccwgroup.c       |  12 +---
 drivers/s390/net/qeth_core.h      |  10 +--
 drivers/s390/net/qeth_core_main.c | 111 +++++++++++++++++-------------
 drivers/s390/net/qeth_core_sys.c  |  41 +++++------
 drivers/s390/net/qeth_l2.h        |   2 -
 drivers/s390/net/qeth_l2_main.c   |   4 +-
 drivers/s390/net/qeth_l2_sys.c    |  19 -----
 drivers/s390/net/qeth_l3.h        |   2 -
 drivers/s390/net/qeth_l3_main.c   |   4 +-
 drivers/s390/net/qeth_l3_sys.c    |  21 ------
 10 files changed, 92 insertions(+), 134 deletions(-)

-- 
2.17.1

