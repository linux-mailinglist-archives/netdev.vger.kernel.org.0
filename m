Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2AAC3984B4
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 10:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232943AbhFBI61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 04:58:27 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:1538 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232932AbhFBI6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 04:58:24 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1528YwuY195564;
        Wed, 2 Jun 2021 04:56:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=UdY9VBzt5D5v6s8lbFMOPIBsV2WH5FKPCD1GGo3F674=;
 b=jC0cwsbTnWXrdV28UbKq8Xg+SOKJ5IUHKuVeShmlT1rJU9Whh/gZdkxKbpuZBC0gSqJ0
 9rLciWP9w6nSJuTVA+XgeLk9tQZkFL5gLbiTOHycFaZoZMhgw3IgIwYHsshxVrohhAX7
 5zltwsJsS5XspsYnUhk0gIYisSZD2ysUv1llAgWuyJKD++x6pPWabDU20N6sbqMq+6py
 IhXq7CWVFGRneNrFog52sIdMebLxfZKuaOkVgSke0HpUVfIvOO1FQY8OPnnC1ll1enO3
 dCD4wAzF9AsizRk3u3C5mGI+zx/2rMiMInliZNRQhigYGL+pQ3eccHTB8Mce7r6xEwCs wA== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38x6bngwe3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Jun 2021 04:56:37 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1528uZWh017482;
        Wed, 2 Jun 2021 08:56:35 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 38ucvh97ds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Jun 2021 08:56:35 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1528uWdW27656570
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 2 Jun 2021 08:56:32 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE035A4060;
        Wed,  2 Jun 2021 08:56:32 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A84EA4054;
        Wed,  2 Jun 2021 08:56:32 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  2 Jun 2021 08:56:32 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH net-next 0/2] net/smc: updates 2021-06-02
Date:   Wed,  2 Jun 2021 10:56:24 +0200
Message-Id: <20210602085626.2877926-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: DCv7hmhcm48DvWvxX2_hooG5DRBhcH12
X-Proofpoint-ORIG-GUID: DCv7hmhcm48DvWvxX2_hooG5DRBhcH12
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-02_05:2021-06-02,2021-06-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 adultscore=0 impostorscore=0 priorityscore=1501 mlxlogscore=702
 clxscore=1015 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106020055
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please apply the following patch series for smc to netdev's net-next tree.

Both patches are cleanups and remove unnecessary code.

Julian Wiedmann (1):
  net/smc: no need to flush smcd_dev's event_wq before destroying it

Karsten Graul (1):
  net/smc: avoid possible duplicate dmb unregistration

 net/smc/smc_core.c | 15 ---------------
 net/smc/smc_ism.c  |  1 -
 2 files changed, 16 deletions(-)

-- 
2.25.1

