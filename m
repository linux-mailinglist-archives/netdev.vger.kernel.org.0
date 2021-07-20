Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43EB53CF49E
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 08:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242497AbhGTF6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 01:58:25 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55878 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240618AbhGTF6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 01:58:22 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16K6XJZ6103199;
        Tue, 20 Jul 2021 02:39:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=a8LScp1NXIxegG6IFKJTHoiADJvBkppHvx3EpW+8lRs=;
 b=FOo6H/Eohk7CwCQmFO1YpGo5J6hXTb96B/d6D1Lef5UZB5jMm1fAnSQJA9JFMy4Pp6Se
 8cvlVuN82oS0iQRkJlnoX791Me5txRlFliqr/ET28TvUga0xZrJW2FFRUbBXK9TrGaLZ
 gNrjt3rXyzGXzIHLyrKe0J3c9K8vdivnboYMjA9caVD1DuXgAKykYOcDvrgWT9U9x5ro
 2LvNTrhkEM9XAT1NeE2maIpDdatPbh2DKR7WOElpUt0dchIlapKAJr3icTTw3gyPZKR3
 1VGVr0NT0RwfChMWM1VpGiBs32ncz9XEW+XiD/FFX05cGW5O+YLAqYGqje+CR4CHCNkF 3g== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39wpxmufk4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Jul 2021 02:39:00 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16K6cCtN005719;
        Tue, 20 Jul 2021 06:38:57 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 39upu88mhu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Jul 2021 06:38:57 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16K6aVe732965022
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Jul 2021 06:36:31 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E68BA4057;
        Tue, 20 Jul 2021 06:38:54 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4AEBEA4053;
        Tue, 20 Jul 2021 06:38:54 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 20 Jul 2021 06:38:54 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 0/3] s390/qeth: updates 2021-07-20
Date:   Tue, 20 Jul 2021 08:38:46 +0200
Message-Id: <20210720063849.2646776-1-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZWfJkd3bY4USa9RxXxXongWkS9yLKktv
X-Proofpoint-ORIG-GUID: ZWfJkd3bY4USa9RxXxXongWkS9yLKktv
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-20_04:2021-07-19,2021-07-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 impostorscore=0 clxscore=1011 malwarescore=0
 phishscore=0 spamscore=0 adultscore=0 mlxlogscore=535 lowpriorityscore=0
 suspectscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107200037
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave & Jakub,

please apply the following patch series for qeth to netdev's net-next tree.

This removes the deprecated support for OSN-mode devices, and does some
follow-on cleanups.

Thanks,
Julian

Julian Wiedmann (3):
  s390/qeth: remove OSN support
  s390/qeth: clean up QETH_PROT_* naming
  s390/qeth: clean up device_type management

 arch/s390/include/asm/ccwgroup.h  |   2 -
 drivers/s390/cio/ccwgroup.c       |  22 ----
 drivers/s390/net/Kconfig          |   9 --
 drivers/s390/net/qeth_core.h      |  46 --------
 drivers/s390/net/qeth_core_main.c | 154 +++++++-------------------
 drivers/s390/net/qeth_core_mpc.c  |   3 -
 drivers/s390/net/qeth_core_mpc.h  |  23 +---
 drivers/s390/net/qeth_core_sys.c  |   5 -
 drivers/s390/net/qeth_ethtool.c   |   7 --
 drivers/s390/net/qeth_l2_main.c   | 172 +++---------------------------
 drivers/s390/net/qeth_l3_main.c   |   7 +-
 11 files changed, 61 insertions(+), 389 deletions(-)

-- 
2.25.1

