Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0EC246B69A
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 10:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233451AbhLGJI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 04:08:57 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:7254 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233444AbhLGJIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 04:08:53 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B77GgwY021919;
        Tue, 7 Dec 2021 09:05:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=w95JY3a0CWtzfwtZh6Iq4UdGzJ9F26M9G2wG6rW1RXw=;
 b=LH0PiMZl0hIeG+oshQ1UyAKdeVtomZhHJzt3yt/mjLV2aT0FSX+oYhV7vsGqwWNp63cs
 ebu4H0yEdGND09G4LToe9dPDATykvCSz9HSGYRYHuJ13XnmMrnbn4P+L5QIs5vNYMJ1V
 7BPVzS9DEJ3OuF+Dndp3Ozf2ciEcFBWu3lXzANJmivb5R0GMz+NsiIA1O2GuJbD+pzO/
 W4PzjU2azROAFPKObiXwIXoKE3lpjCRju2EGrNzrrcpYNLiszAqdf02Vbvz3fHPlUsBr
 LxFc3ZJNl9eYnWPgjvaqh+6R80BUurSFh3RnYEVOAEVZoFBMMZ5R7Y/0B9KrWgqj4bHZ FA== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ct334t3mf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 09:05:13 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B793k61007461;
        Tue, 7 Dec 2021 09:05:12 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 3cqyy9beer-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 09:05:12 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B7958Vx12779802
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Dec 2021 09:05:08 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE5124204F;
        Tue,  7 Dec 2021 09:05:08 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BCD9642049;
        Tue,  7 Dec 2021 09:05:08 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue,  7 Dec 2021 09:05:08 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55271)
        id 6F651E0792; Tue,  7 Dec 2021 10:05:08 +0100 (CET)
From:   Alexandra Winter <wintera@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>
Subject: [PATCH net-next 0/5] s390/net: updates 2021-12-06
Date:   Tue,  7 Dec 2021 10:04:47 +0100
Message-Id: <20211207090452.1155688-1-wintera@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZCMfmYfnS8mq6sEXDlmFqzteq3aA1C4g
X-Proofpoint-ORIG-GUID: ZCMfmYfnS8mq6sEXDlmFqzteq3aA1C4g
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-07_03,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 mlxscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 impostorscore=0 clxscore=1011
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112070054
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please apply the following patches to netdev's net-next tree.

This brings some maintenance improvements and removes some
unnecessary code checks.

Julian Wiedmann (5):
  s390/qeth: simplify qeth_receive_skb()
  s390/qeth: split up L2 netdev_ops
  s390/qeth: don't offer .ndo_bridge_* ops for OSA devices
  s390/qeth: fine-tune .ndo_select_queue()
  s390/qeth: remove check for packing mode in
    qeth_check_outbound_queue()

 drivers/s390/net/qeth_core.h      |  4 +--
 drivers/s390/net/qeth_core_main.c | 54 +++++++++++++++----------------
 drivers/s390/net/qeth_l2_main.c   | 52 ++++++++++++++++++-----------
 drivers/s390/net/qeth_l3_main.c   | 13 +-------
 4 files changed, 62 insertions(+), 61 deletions(-)

-- 
2.32.0

