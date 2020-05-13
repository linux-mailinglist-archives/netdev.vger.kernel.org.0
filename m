Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D774C1D0A03
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 09:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729887AbgEMHmo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 03:42:44 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46286 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729681AbgEMHmo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 03:42:44 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04D7VvL0155586;
        Wed, 13 May 2020 03:42:38 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3101m499h6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 May 2020 03:42:37 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 04D7ekwO027966;
        Wed, 13 May 2020 07:42:35 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3100ubge6m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 May 2020 07:42:35 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04D7gWrb63439226
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 May 2020 07:42:33 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D6BED11C04A;
        Wed, 13 May 2020 07:42:32 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7BFF911C052;
        Wed, 13 May 2020 07:42:32 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 May 2020 07:42:32 +0000 (GMT)
From:   Ursula Braun <ubraun@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, kgraul@linux.ibm.com,
        weiyongjun1@huawei.com, ubraun@linux.ibm.com
Subject: [PATCH net 0/2] s390/net: updates 2020-05-13
Date:   Wed, 13 May 2020 09:42:28 +0200
Message-Id: <20200513074230.967-1-ubraun@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-13_02:2020-05-11,2020-05-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 mlxlogscore=581 priorityscore=1501 phishscore=0 clxscore=1015
 cotscore=-2147483648 impostorscore=0 spamscore=0 adultscore=0 mlxscore=0
 malwarescore=0 suspectscore=1 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005130065
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dave,

please apply the fix from Wei Yongjun to netdev's net tree and
add Karsten Graul as co-maintainer for drivers/s390/net.

Thanks, Ursula

Ursula Braun (1):
  MAINTAINERS: add Karsten Graul as S390 NETWORK DRIVERS maintainer

Wei Yongjun (1):
  s390/ism: fix error return code in ism_probe()

 MAINTAINERS                | 1 +
 drivers/s390/net/ism_drv.c | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

-- 
2.17.1

