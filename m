Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF71340D8D
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 19:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232292AbhCRSzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 14:55:40 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:20010 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229469AbhCRSzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 14:55:08 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12IIXVWm013805;
        Thu, 18 Mar 2021 14:55:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=eXbLvG4c/p0GdooaswaCe5+Yz3iiCHMakFOZ8hs7xuE=;
 b=J3qFwdLPgpR7p7uEqmlLmumMqIEeulANM6GS3wBN7cm49+z+Qe5dToHvZ1jn97ArEdSD
 6MiGve8vnv2TTOeasm7ytWaKln4Y8/oWNMVA3Wj0j+go/5lYLNlsCO2ZtmILpgJy7e2R
 dsQlJW3TR543gRGkV7YtMhzDQ2t3Rq6dkg61gopj0xSWAw/T1c8QtjIeMbRPt8oCBq8e
 8/kO99DizDUFqN6WntVeSW3nWlcXrGmlRQRS5q62Jj88hK+JuxUXZVRLM9DLZjjTAagW
 0NMK31netBpZ/5zBI/y/7akk3Rg1J9nfmTOiQtVCqHcOxUJBzeAC/dlC1qxi2Y5NOADT CA== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37bxvm9dke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 14:55:05 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12IIqfqX021735;
        Thu, 18 Mar 2021 18:55:03 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 378n18anhb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 18:55:03 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12IIt0sR28836300
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Mar 2021 18:55:00 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8A2A4A4055;
        Thu, 18 Mar 2021 18:55:00 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 46715A404D;
        Thu, 18 Mar 2021 18:55:00 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 18 Mar 2021 18:55:00 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 0/3] s390/qeth: updates 2021-03-18
Date:   Thu, 18 Mar 2021 19:54:53 +0100
Message-Id: <20210318185456.2153426-1-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-18_12:2021-03-17,2021-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 suspectscore=0 adultscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 mlxlogscore=946 lowpriorityscore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103180131
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave & Jakub,

please apply the following patch series for qeth to netdev's net-next
tree.

This brings two small optimizations (replace a hard-coded GFP_ATOMIC,
pass through the NAPI budget to enable napi_consume_skb()), and removes
some redundant VLAN filter code.

Thanks,
Julian

Julian Wiedmann (3):
  s390/qeth: allocate initial TX Buffer structs with GFP_KERNEL
  s390/qeth: enable napi_consume_skb() for pending TX buffers
  s390/qeth: remove RX VLAN filter stubs in L3 driver

 drivers/s390/net/qeth_core_main.c | 18 ++++++++++--------
 drivers/s390/net/qeth_l3_main.c   | 25 +------------------------
 2 files changed, 11 insertions(+), 32 deletions(-)

-- 
2.25.1

