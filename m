Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 200AE281628
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 17:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388299AbgJBPJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 11:09:47 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:29490 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388226AbgJBPJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 11:09:43 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 092F4exq050477;
        Fri, 2 Oct 2020 11:09:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=bRP++DUAVWq6B29S8rqoPMSxXCoil1Uq+2LQkm6p2nM=;
 b=Tyl5Z/IIR4GOXhPIKADX4KcCBEyBYMWmpV1IuVHFY16WRmsw40iUSfVBWFlitC+FiC19
 iD7KvfpxPisT3AItF72BS6tZjX7tGasR76ZCUnaIh1ecRWwQyZu4vjRUA48ggLJKlPxf
 IwmP307kOIyOr3dZCD4besF6n4TcO13lhnQNYvSej6I8Dtgoa5ogtEoplczjdrCK+4u6
 n2/0ZvjSG/VgCEV6Wz3DxlQgnVr1Bp7WHvHIiutbb6HymW3VbKN9XiYCMG4sejo6IY9s
 rLsH+lrnH9RXm2rxHn7Pvo0wdJ1e9RLlzC0rs35srHHI6DnmEgCQSzc6zXiMHMDx0DFm rg== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33x677rpv6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 11:09:41 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 092F3IIN010724;
        Fri, 2 Oct 2020 15:09:36 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 33sw97xprd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 15:09:36 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 092F9X7Z33358252
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Oct 2020 15:09:33 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6723DA404D;
        Fri,  2 Oct 2020 15:09:33 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0CED9A4051;
        Fri,  2 Oct 2020 15:09:33 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  2 Oct 2020 15:09:32 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 0/2] net/smc: updates 2020-10-02
Date:   Fri,  2 Oct 2020 17:09:25 +0200
Message-Id: <20201002150927.72261-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-02_10:2020-10-02,2020-10-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=1 bulkscore=0 phishscore=0
 clxscore=1015 spamscore=0 mlxlogscore=459 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010020119
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please apply the following patch series for smc to netdev's net-next tree.

Patch 1 improves the ISM device payload of a CLC porposal message, patch 2
adds to use an array to access the system EID fields.

Karsten Graul (2):
  net/smc: send ISM devices with unique chid in CLC proposal
  net/smc: use an array to check fields in system EID

 net/smc/af_smc.c  | 18 +++++++++++++++++-
 net/smc/smc_ism.c |  2 +-
 2 files changed, 18 insertions(+), 2 deletions(-)

-- 
2.17.1

