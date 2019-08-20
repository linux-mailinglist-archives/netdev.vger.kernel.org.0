Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3DD962C4
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 16:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730301AbfHTOq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 10:46:59 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60160 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730189AbfHTOq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 10:46:58 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7KEXpHe127264
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 10:46:56 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ugh4mx8dt-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 10:46:56 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Tue, 20 Aug 2019 15:46:54 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 20 Aug 2019 15:46:52 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7KEko6642598542
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 14:46:50 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B0B9011C052;
        Tue, 20 Aug 2019 14:46:50 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 67C3911C04C;
        Tue, 20 Aug 2019 14:46:50 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 20 Aug 2019 14:46:50 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 0/9] s390/net: updates 2019-08-20
Date:   Tue, 20 Aug 2019 16:46:34 +0200
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
x-cbid: 19082014-0008-0000-0000-0000030B14E1
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19082014-0009-0000-0000-00004A293C8B
Message-Id: <20190820144643.64041-1-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-20_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=867 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908200145
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

please apply the following patches to net-next. This series brings a mix
of cleanups and small improvements for various parts of qeth's control
path. Also, a minor cleanup for ctcm and lcs.

Thanks,
Julian


Julian Wiedmann (9):
  s390/qeth: use node_descriptor struct
  s390/qeth: propagate length of processed cmd IO data to callback
  s390/qeth: use correct length field in SNMP cmd callback
  s390/qeth: keep cmd alive after IO completion
  s390/qeth: merge qeth_reply struct into qeth_cmd_buffer
  s390/qeth: get vnicc sub-cmd type from reply data
  s390/qeth: streamline control code for promisc mode
  s390/ctcm: don't use intparm for channel IO
  s390/lcs: don't use intparm for channel IO

 drivers/s390/net/ctcm_fsms.c      |  42 ++---
 drivers/s390/net/ctcm_main.c      |   6 +-
 drivers/s390/net/ctcm_mpc.c       |   6 +-
 drivers/s390/net/lcs.c            |   6 +-
 drivers/s390/net/qeth_core.h      |  36 ++---
 drivers/s390/net/qeth_core_main.c | 261 ++++++++++++++----------------
 drivers/s390/net/qeth_core_mpc.h  |   1 -
 drivers/s390/net/qeth_l2_main.c   |  62 +++----
 drivers/s390/net/qeth_l3_main.c   |  24 +--
 9 files changed, 197 insertions(+), 247 deletions(-)

-- 
2.17.1

