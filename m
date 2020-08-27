Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49F5025409C
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 10:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727946AbgH0IWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 04:22:22 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:24984 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726266AbgH0IWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 04:22:21 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07R843RB179849;
        Thu, 27 Aug 2020 04:22:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=gt9ZhqtUyQzEV6FWnuL7Hv5kDOpxzUAmkLbMVWAJv9c=;
 b=D/w6DhtCoec957OLyepKx38Okjx72/cU1AxEZ1gFp5q1X6fE1MEnXSzt+6aKyZw51rzn
 EwnxsuB2oZJaP45bGnoTUD0AZGMvwOBo4S5icTthhzjlwDwh2mdN3rZRmFTQGOONP501
 i1M5Y0r7lJS4338g1HpMTsG4gpxdSg6Mjqis3KFGhmS6pNKzMrnV9gW6xyEDz+iB3RRr
 VRcNoPx+1L63rcCJQVAEBgkDaQ/Lrb0XQNiEJApf636MveM7im3DUw2xwu2chMOa9U6y
 TzZEiNXEAlAjlj9M3jkzDXwh/hTkz7n0TaRZOb/yKxmyU1giutaV2X9LfTvn9k6tF6zz 6g== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3368aqhv7d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Aug 2020 04:22:20 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07R8CKZq008553;
        Thu, 27 Aug 2020 08:17:10 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 332ujjub6w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Aug 2020 08:17:10 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07R8H7b821954952
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Aug 2020 08:17:08 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D58BE4C050;
        Thu, 27 Aug 2020 08:17:07 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 869D64C044;
        Thu, 27 Aug 2020 08:17:07 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 Aug 2020 08:17:07 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 0/8] s390/qeth: updates 2020-08-27
Date:   Thu, 27 Aug 2020 10:16:57 +0200
Message-Id: <20200827081705.21922-1-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-27_02:2020-08-27,2020-08-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 mlxlogscore=779 spamscore=0 clxscore=1015 adultscore=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 mlxscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008270060
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave & Jakub,

please apply the following patch series for qeth to netdev's net-next tree.

Patch 8 makes some improvements to how we handle HW address events,
avoiding some uncertainty around processing stale events after we
switched off the feature.
Except for that it's all straight-forward cleanups.

Thanks,
Julian

Julian Wiedmann (8):
  s390/qeth: clean up qeth_l3_send_setdelmc()'s declaration
  s390/qeth: use to_delayed_work()
  s390/qeth: make queue lock a proper spinlock
  s390/qeth: don't disable address events during initialization
  s390/qeth: don't let HW override the configured port role
  s390/qeth: copy less data from bridge state events
  s390/qeth: unify structs for bridge port state
  s390/qeth: strictly order bridge address events

 drivers/s390/net/qeth_core.h      | 14 ++---
 drivers/s390/net/qeth_core_main.c | 85 ++++++++-------------------
 drivers/s390/net/qeth_core_mpc.h  | 14 +----
 drivers/s390/net/qeth_l2_main.c   | 96 ++++++++++++++++++++-----------
 drivers/s390/net/qeth_l2_sys.c    |  1 +
 drivers/s390/net/qeth_l3_main.c   |  3 +-
 6 files changed, 100 insertions(+), 113 deletions(-)

-- 
2.17.1

