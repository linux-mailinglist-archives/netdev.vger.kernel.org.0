Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A30B145601F
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 17:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232958AbhKRQJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 11:09:32 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:5770 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232822AbhKRQJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 11:09:32 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AIFISfl021909;
        Thu, 18 Nov 2021 16:06:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=pp1;
 bh=j7PWeQI/5Sr1Ek7GKE6nV3o4wDTG+8GTCs+OmzkVV8c=;
 b=aDl3rxMjBp7yQfyfBNoS0t2CgmkGYc2M4n1+bFmxqtDDUcNBvd/fzZ7ZUIFWGh77Mne8
 iNpuOLj7FZ+ZFNVx4ZEqG83Uvl+uUoHwx7JIcFaLLb3GyRyxIqGeFiq4cDfEKzJ3nVag
 XsAue91mHcWEPEO/W+AxzrwKPE8+xXGTXCDH8kFSbFEHP+CJYah7ksuHhW2VdCxbTrAr
 O1/DiTle3vr/qDkjr6QIyqVEke1smbSRzXvydhKykrWg7EgVOgQ2sySPjK1f27uPNZju
 yM0PsihfLIKTARpHRudDOrfLjlRAJg2ArHLA3sRDo922xcszXZwdeng4yroTksXscmG7 OA== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cdrwft65v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Nov 2021 16:06:30 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AIG3VYg023625;
        Thu, 18 Nov 2021 16:06:27 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3ca50aqtjq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Nov 2021 16:06:27 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AIG6OMm4981278
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Nov 2021 16:06:24 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 21381AE071;
        Thu, 18 Nov 2021 16:06:24 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D5E52AE067;
        Thu, 18 Nov 2021 16:06:23 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 18 Nov 2021 16:06:23 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 0/6] s390/net: updates 2021-11-18
Date:   Thu, 18 Nov 2021 17:06:01 +0100
Message-Id: <20211118160607.2245947-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: UTh4UPtvUlyXG3bdfkZI2ExAnxwdznQp
X-Proofpoint-ORIG-GUID: UTh4UPtvUlyXG3bdfkZI2ExAnxwdznQp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-18_12,2021-11-17_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 mlxlogscore=999 impostorscore=0 bulkscore=0 clxscore=1015
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 spamscore=0
 adultscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111180089
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please apply the following patches to netdev's net-next tree.

Heiko provided fixes for kernel doc comments and solved some
other compiler warnings.
Julians qeth patch simplifies the rx queue handling in the code.

Heiko Carstens (5):
  net/iucv: fix kernel doc comments
  net/af_iucv: fix kernel doc comments
  s390/ctcm: fix format string
  s390/ctcm: add __printf format attribute to ctcm_dbf_longtext
  s390/lcs: add braces around empty function body

Julian Wiedmann (1):
  s390/qeth: allocate RX queue at probe time

 drivers/s390/net/ctcm_dbug.h      |   1 +
 drivers/s390/net/ctcm_fsms.c      |   2 +-
 drivers/s390/net/lcs.c            |  11 +--
 drivers/s390/net/qeth_core_main.c |  35 ++++-----
 net/iucv/af_iucv.c                |  38 ++++-----
 net/iucv/iucv.c                   | 124 +++++++++++++++---------------
 6 files changed, 106 insertions(+), 105 deletions(-)

-- 
2.25.1

