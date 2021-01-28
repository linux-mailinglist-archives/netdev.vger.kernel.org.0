Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D45313074D9
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 12:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbhA1Lb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 06:31:57 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34084 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231201AbhA1Lbw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 06:31:52 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10SB2cch025683;
        Thu, 28 Jan 2021 06:31:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=33YBZazcCQUKwuLWPfoETQqXXhZxCHNMnNTXTSVkPFo=;
 b=R3Olx6yqCSzHGcuN4EkcQvEowANSQqzp7rihPh7hJrmXjjrKQytwve1jxFBWbjkjZ8+D
 oKJq+j9X09QByRVHwt5k5/AlwKTQ/eCIUa0B5o+ZsdX4kw46PQ1xghsEcSCq5CywlGF3
 r+9DZc3DSWGdSO6Q5c0LinpwZseaMx+Y8ujo8Wg6NA217XI5jN6rw4NHxRBnISOnlTCY
 HLBVxXKjXwS/TBdy0Ck0Q2/5pscvRhlPcIQs36Ilkn8FUaW5tqUOMVB5Kzm9R+TEuYN2
 xj0/zujH/tnPp26BB6xi+4G5mjogX7sDqr0KlWQmN+mJMLsjrHkf2ZoYvvcqyrAt2b49 0g== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36bqsyqc0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jan 2021 06:31:09 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10SBMZMt027501;
        Thu, 28 Jan 2021 11:25:59 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 368be8afkv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jan 2021 11:25:58 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10SBPt8547120708
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jan 2021 11:25:56 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D791942041;
        Thu, 28 Jan 2021 11:25:55 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E2534203F;
        Thu, 28 Jan 2021 11:25:55 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 28 Jan 2021 11:25:55 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 0/5] s390/qeth: updates 2021-01-28
Date:   Thu, 28 Jan 2021 12:25:46 +0100
Message-Id: <20210128112551.18780-1-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-28_05:2021-01-27,2021-01-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 phishscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 mlxlogscore=671
 malwarescore=0 suspectscore=0 adultscore=0 lowpriorityscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101280051
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave & Jakub,

please apply the following patch series for qeth to netdev's net-next tree.

Nothing special, mostly fine-tuning and follow-on cleanups for earlier fixes.

Thanks,
Julian

Julian Wiedmann (5):
  s390/qeth: clean up load/remove code for disciplines
  s390/qeth: remove qeth_get_ip_version()
  s390/qeth: pass proto to qeth_l3_get_cast_type()
  s390/qeth: make cast type selection for af_iucv skbs robust
  s390/qeth: don't fake a TX completion interrupt after TX error

 drivers/s390/net/qeth_core.h      | 44 +++++---------
 drivers/s390/net/qeth_core_main.c | 97 +++++++++++++++++--------------
 drivers/s390/net/qeth_core_sys.c  | 10 +---
 drivers/s390/net/qeth_l2_main.c   |  6 +-
 drivers/s390/net/qeth_l3_main.c   | 90 ++++++++++++++++------------
 5 files changed, 125 insertions(+), 122 deletions(-)

-- 
2.17.1

