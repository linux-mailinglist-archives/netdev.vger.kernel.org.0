Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 702C32B69B7
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 17:15:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgKQQPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 11:15:35 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:19272 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726532AbgKQQPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 11:15:34 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AHG3rX6031098;
        Tue, 17 Nov 2020 11:15:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=RwPEBTPhS0kMtIu0enl7fJZuAmeJfDeqZE1QEn1Ypsc=;
 b=Ptvoa3+w6var7qIXI4WzRvsJ0UkJhHQM0P2mm1ps07mqMy7c/kk76WiNKiOIQpjIgth8
 6FChsQP1WPndBvSjB+NN6YBz3L7p1q8mHUtb4wx6T7MYtl8/QU+dYpY5ewUhlnbCtlyC
 pRu67tVuPfFiiMkUeaWuHOxupp0198qERIVjxFguCNkUOrsJGrGAdvWuvCS24vduIgSN
 PlCrF9/r40pDiCOoKkcklXMCnFKHeUmS4YvDBx+eFL6q42rqYGOWa2rXmE8NS1VBwpIA
 6xp12RJENbo8kadq9jYBbfmf6I6BwT5+iQfuKaCRlvXxnA744lboPkcX553fOudr6lvk 6g== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34v961t05p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 11:15:31 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AHG8ZVM001832;
        Tue, 17 Nov 2020 16:15:28 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 34t6gh3a48-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 16:15:28 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AHGFP4D65012188
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 16:15:26 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C374EA4067;
        Tue, 17 Nov 2020 16:15:25 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7D33BA4064;
        Tue, 17 Nov 2020 16:15:25 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 Nov 2020 16:15:25 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 0/9] s390/qeth: updates 2020-11-17
Date:   Tue, 17 Nov 2020 17:15:11 +0100
Message-Id: <20201117161520.1089-1-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-17_06:2020-11-17,2020-11-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0 bulkscore=0
 impostorscore=0 mlxscore=0 mlxlogscore=856 clxscore=1015 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170117
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

please apply the following patch series for qeth to netdev's net-next tree.

This brings some cleanups, and a bunch of improvements for our
.get_link_ksettings() code.

Julian Wiedmann (8):
  s390/qeth: don't call INIT_LIST_HEAD() on iob's list entry
  s390/qeth: reduce rtnl locking for switchdev events
  s390/qeth: tolerate error when querying card info
  s390/qeth: improve QUERY CARD INFO processing
  s390/qeth: set static link info during initialization
  s390/qeth: clean up default cases for ethtool link mode
  s390/qeth: use QUERY OAT for initial link info
  s390/qeth: improve selection of ethtool link modes

Kaixu Xia (1):
  s390/qeth: remove useless if/else

 drivers/s390/net/qeth_core.h      |  24 ++-
 drivers/s390/net/qeth_core_main.c | 232 ++++++++++++++++++++++++++--
 drivers/s390/net/qeth_core_mpc.h  |  40 ++++-
 drivers/s390/net/qeth_ethtool.c   | 243 +++++++++++-------------------
 drivers/s390/net/qeth_l2_main.c   |  33 ++--
 drivers/s390/net/qeth_l3_main.c   |   5 +-
 6 files changed, 378 insertions(+), 199 deletions(-)

-- 
2.17.1

