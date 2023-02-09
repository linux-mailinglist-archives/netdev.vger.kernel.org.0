Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6961D69060F
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 12:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbjBILEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 06:04:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbjBILEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 06:04:40 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B206F83DA;
        Thu,  9 Feb 2023 03:04:37 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 319Ap2Q4012620;
        Thu, 9 Feb 2023 11:04:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=PhQhT58I6wnVQLRnsRuf7Irjwb3Sjfo6a3eQKFCDmEo=;
 b=rdPIrEVnSu9NUr80wv9DrhntwHTOEHy2KPby7n/eSRiUf3qLU4Ut6mSIz+EUl5fBIjR8
 JAV4TcDL8f8Dhw1OmWPaams5vhpHGoF8pqE+MIpmrHDdgkXydXDf5d76rBR/VYW3gU2n
 GI6pdL576pmrzSBRTPd8GmB2jRteocXICkKDzkvADse87hLszRClGidlrQwDnyYrVCdb
 52ACCJqxpICRmyDVjLbI4k0XZdjoXlJQu1SuPTaQO+g/qcBJ1qV5r09UnfHM4cGUe3Qc
 g77dRghR+D7JwP+gVpRsFBoPz+G0vbFeBX8zz+rtN9q9uM1GeGB0ZhdOiCKAK2gAnq3q 5w== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nmyejr97m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 11:04:32 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 318L9Cbi023711;
        Thu, 9 Feb 2023 11:04:30 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3nhf06x35u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 11:04:30 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 319B4Rqo21299528
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Feb 2023 11:04:27 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EACDC2004D;
        Thu,  9 Feb 2023 11:04:26 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC20120040;
        Thu,  9 Feb 2023 11:04:26 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Thu,  9 Feb 2023 11:04:26 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55271)
        id AC120E08E3; Thu,  9 Feb 2023 12:04:26 +0100 (CET)
From:   Alexandra Winter <wintera@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>
Subject: [PATCH net-next v2 0/4] s390/net: updates 2023-02-06
Date:   Thu,  9 Feb 2023 12:04:20 +0100
Message-Id: <20230209110424.1707501-1-wintera@linux.ibm.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XQTM_EVBE6hN363MKvRntLdvjrzY4pOe
X-Proofpoint-ORIG-GUID: XQTM_EVBE6hN363MKvRntLdvjrzY4pOe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-09_08,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 mlxscore=0 clxscore=1015
 phishscore=0 priorityscore=1501 adultscore=0 malwarescore=0 spamscore=0
 mlxlogscore=837 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302090105
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
If you disagree with patch 4, we can leave it out.
We prefer scnprintf, but no strong opinion.

Thanks,
Alexandra

v2:
- add Reviewed-by (1)
- fix typos in Reviewed-by tags (2,3,4)
- further simplify show functions (3)

Alexandra Winter (1):
  s390/ctcm: cleanup indenting

Thorsten Winkler (3):
  s390/qeth: Use constant for IP address buffers
  s390/qeth: Convert sysfs sprintf to sysfs_emit
  s390/qeth: Convert sprintf/snprintf to scnprintf

 drivers/s390/net/ctcm_fsms.c      | 32 ++++++------
 drivers/s390/net/ctcm_main.c      | 16 +++---
 drivers/s390/net/ctcm_mpc.c       | 15 +++---
 drivers/s390/net/qeth_core_main.c | 14 +++---
 drivers/s390/net/qeth_core_sys.c  | 66 ++++++++++++------------
 drivers/s390/net/qeth_ethtool.c   |  6 +--
 drivers/s390/net/qeth_l2_main.c   | 53 ++++++++++----------
 drivers/s390/net/qeth_l2_sys.c    | 28 +++++------
 drivers/s390/net/qeth_l3_main.c   |  7 +--
 drivers/s390/net/qeth_l3_sys.c    | 83 +++++++++++--------------------
 10 files changed, 150 insertions(+), 170 deletions(-)

-- 
2.37.2

