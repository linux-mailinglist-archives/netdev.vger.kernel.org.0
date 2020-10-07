Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3BE62869B7
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 22:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728624AbgJGU57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 16:57:59 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36736 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728017AbgJGU56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 16:57:58 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 097KUoEg161459;
        Wed, 7 Oct 2020 16:57:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=EfcyN5PvowzSKa1Mu7qMdhHNBki0r19JqlRsZsRveEA=;
 b=ml2h4lqgS5zzyN3vnwn8a+p9v2XgD6xJMUVtUPzUyN1SqIUP3d6EF4gYKWFPUrCwtTk2
 TEK8YTSvjDIZdaiZfNX7SwmmW4B0Xswbr06gOdbYwqaw16kkZdZPA3uUql5zcLr8SIY4
 HuopB7KGjybHsBPfOJC3FSocMH2YDFw95IY/g8W73ZVNJkZGrTVoBDlFvs8lzh9MdDV8
 +XXl8tRIwaN/HPvoEqgN+gAiGM8lr5H4noJTilcFP9Q9S/5rtOxbHZpx+zZ4VT2vdXk6
 KD8s3+FkyUM+mzh5yz6iAmSktSOHDK4iEibu3ldq2o4rV6jwbxxcrZFP2EFOA12id++Y Lw== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 341jehvnny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Oct 2020 16:57:56 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 097Kvs6F019351;
        Wed, 7 Oct 2020 20:57:54 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 33xgx7te1j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Oct 2020 20:57:54 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 097Kvpmw33096176
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Oct 2020 20:57:51 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 699F0AE056;
        Wed,  7 Oct 2020 20:57:51 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2455AAE053;
        Wed,  7 Oct 2020 20:57:51 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  7 Oct 2020 20:57:51 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 0/3] net/smc: updates 2020-10-07
Date:   Wed,  7 Oct 2020 22:57:40 +0200
Message-Id: <20201007205743.83535-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-07_10:2020-10-07,2020-10-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 mlxlogscore=756 impostorscore=0 spamscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 suspectscore=1 adultscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070127
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please apply the following patch series for smc to netdev's net-next tree.

Patch 1 and 2 address warnings from static code checkers, and patch 3 handles
a case when all proposed ISM V2 devices fail to init and no V1 devices are
tried afterwards.

Karsten Graul (3):
  net/smc: consolidate unlocking in same function
  net/smc: cleanup buffer usage in smc_listen_work()
  net/smc: restore smcd_version when all ISM V2 devices failed to init

 net/smc/af_smc.c | 92 +++++++++++++++++++++++++-----------------------
 1 file changed, 48 insertions(+), 44 deletions(-)

-- 
2.17.1

