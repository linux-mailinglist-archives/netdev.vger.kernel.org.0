Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB171C5D7F
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 18:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730710AbgEEQ0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 12:26:31 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47782 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729310AbgEEQ0O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 12:26:14 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 045G7VIs153284;
        Tue, 5 May 2020 12:26:12 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30sp8jyt33-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 May 2020 12:26:10 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 045GJkak003354;
        Tue, 5 May 2020 16:26:04 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 30s0g5qc3d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 May 2020 16:26:04 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 045GOqn760490184
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 May 2020 16:24:52 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AAACE42042;
        Tue,  5 May 2020 16:26:01 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 617A742041;
        Tue,  5 May 2020 16:26:01 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 May 2020 16:26:01 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 00/11] s390/qeth: updates 2020-05-05
Date:   Tue,  5 May 2020 18:25:48 +0200
Message-Id: <20200505162559.14138-1-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-05_09:2020-05-04,2020-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 malwarescore=0 suspectscore=0 priorityscore=1501 spamscore=0 clxscore=1015
 mlxscore=0 lowpriorityscore=0 mlxlogscore=999 impostorscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050124
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

please apply the following patch series for qeth to netdev's net-next
tree.

This primarily adds infrastructure to deal with HW offloads when the
packets get forwarded over the adapter's internal switch.
Aside from that, just some minor tweaking for the TX code and support
for ethtool-driven reset.

Thanks,
Julian

Julian Wiedmann (11):
  s390/qeth: keep track of LP2LP capability for csum offload
  s390/qeth: process local address events
  s390/qeth: add debugfs file for local IP addresses
  s390/qeth: extract helpers for next-hop lookup
  s390/qeth: don't use restricted offloads for local traffic
  s390/qeth: merge TX skb mapping code
  s390/qeth: indicate contiguous TX buffer elements
  s390/qeth: set TX IRQ marker on last buffer in a group
  s390/qeth: return error when starting a reset fails
  s390/qeth: allow reset via ethtool
  s390/qeth: clean up Kconfig help text

 drivers/s390/net/Kconfig          |   9 +-
 drivers/s390/net/qeth_core.h      |  49 +++-
 drivers/s390/net/qeth_core_main.c | 465 +++++++++++++++++++++++++-----
 drivers/s390/net/qeth_core_mpc.h  |  25 ++
 drivers/s390/net/qeth_core_sys.c  |  15 +-
 drivers/s390/net/qeth_ethtool.c   |  16 +
 drivers/s390/net/qeth_l2_main.c   |   2 +
 drivers/s390/net/qeth_l3_main.c   |  19 +-
 8 files changed, 502 insertions(+), 98 deletions(-)

-- 
2.17.1

