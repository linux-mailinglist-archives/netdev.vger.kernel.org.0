Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A686968C4B9
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 18:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbjBFR2k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 12:28:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbjBFR21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 12:28:27 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD53C28203;
        Mon,  6 Feb 2023 09:28:14 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 316Gvii7032623;
        Mon, 6 Feb 2023 17:28:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=NtFT1K9BSIvq8w5U0bXM81O/5Nk9ADBkcGNcB1EdzEE=;
 b=RHzx2+tklupQQQMVPGMowGSbBy925MuBcSzrjjblyAjo5S9g5GJqa7x1gNIY4BZwWrNh
 ENWz/HudOdsXiSXaWXHsZwKkwm4bkUW5vE7jL3+oE6VtNx4f7bk2lFbJQYClzWsGLO/o
 +0lX8j93oWxf4k3OIXZ0PRP79O4xk+D09kK4ncR+OU0xL3XurqK7uzUtainBdCN5kF1h
 xPet+b9u/zMb+/UCC2mq0VnBQ9GWcDZj2qUY8z/gpAa5eS3ORShvzKV7ew4VmZ0ZLtFZ
 P6uaq/E2ZowmHzurkPQBX0EaFZPqhfodKKWmWbxtfEVnOmWyPx6ZLLJK5oBefi2vwYcy Uw== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nk4x5t5w2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Feb 2023 17:28:09 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 316DwUYe026483;
        Mon, 6 Feb 2023 17:28:07 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3nhf06sw1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Feb 2023 17:28:07 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 316HS4jX52560148
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Feb 2023 17:28:04 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 03FC52004E;
        Mon,  6 Feb 2023 17:28:04 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E70D720049;
        Mon,  6 Feb 2023 17:28:03 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Mon,  6 Feb 2023 17:28:03 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55271)
        id 9D040E0397; Mon,  6 Feb 2023 18:28:03 +0100 (CET)
From:   Alexandra Winter <wintera@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>
Subject: [PATCH net-next 0/4] s390/net: updates 2023-02-06
Date:   Mon,  6 Feb 2023 18:27:50 +0100
Message-Id: <20230206172754.980062-1-wintera@linux.ibm.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: rkZ3cKLw1pUSm-GpLIEBuAUTgoFFapO5
X-Proofpoint-GUID: rkZ3cKLw1pUSm-GpLIEBuAUTgoFFapO5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-06_07,2023-02-06_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 mlxlogscore=676
 spamscore=0 bulkscore=0 mlxscore=0 suspectscore=0 phishscore=0
 lowpriorityscore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2302060149
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave & Jakub,

please apply the following patch series for qeth to netdev's net-next
tree.

Just maintenance patches, no functional changes.

Thanks,
Alexandra

Alexandra Winter (1):
  s390/ctcm: cleanup indenting

Thorsten Winkler (3):
  s390/qeth: Use constant for IP address buffers
  s390/qeth: Convert sysfs sprintf to sysfs_emit
  s390/qeth: Convert sprintf/snprintf to scnprintf

 drivers/s390/net/ctcm_fsms.c      | 32 +++++++--------
 drivers/s390/net/ctcm_main.c      | 16 ++++----
 drivers/s390/net/ctcm_mpc.c       | 15 +++----
 drivers/s390/net/qeth_core_main.c | 14 ++++---
 drivers/s390/net/qeth_core_sys.c  | 66 ++++++++++++++++---------------
 drivers/s390/net/qeth_ethtool.c   |  6 +--
 drivers/s390/net/qeth_l2_main.c   | 53 +++++++++++++------------
 drivers/s390/net/qeth_l2_sys.c    | 28 ++++++-------
 drivers/s390/net/qeth_l3_main.c   |  7 ++--
 drivers/s390/net/qeth_l3_sys.c    | 51 +++++++++++-------------
 10 files changed, 146 insertions(+), 142 deletions(-)

-- 
2.37.2

