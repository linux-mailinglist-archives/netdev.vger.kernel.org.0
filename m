Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C1343E4199
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 10:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233972AbhHIIcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 04:32:04 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:2382 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233963AbhHIIcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 04:32:03 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1798V5Jf155938;
        Mon, 9 Aug 2021 04:31:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=poPv+UoKvxI3S2CgzQ5xTqxLYj1q4W4Bf+VrFQU+oK8=;
 b=dTSddl0tP6Tt1TLrU+Do9Ec1GPhSOGsBNZhV3I2EdkHtUvJz/9JAfC5BRYQtFLhm/L26
 +AsiWhkv6xQOp+AIgqMka1ikEuZng9G+atvSMIyRLxXAFBjrkvuh2VcQGmIydV87KlpZ
 D9ODD1nIn8lRA612K202dRCdmCl6PN3h96XV1TGzV3KR9PsI5LmnCoKIjQOmLNggYnb0
 JDANeKe8buymVqhzIUkrtdOtNu0Rqwi+y5NOcTJNCyXUIGipj1apupkHMV0xKv+iz0Up
 kIE4jZp3a4R7l2sL/rOd7FM08IQD25TE36cbPzQyPwMv0LrIbFJyN0vG/i4En1bu76M9 LA== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ab0x180db-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 04:31:32 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1798SU2j017556;
        Mon, 9 Aug 2021 08:31:30 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 3a9ht8u8uv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 08:31:29 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1798VPSW46072310
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Aug 2021 08:31:25 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 855C2A4070;
        Mon,  9 Aug 2021 08:31:25 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BC295A4065;
        Mon,  9 Aug 2021 08:31:24 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  9 Aug 2021 08:31:24 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net-next 0/5] net/iucv: updates 2021-08-09
Date:   Mon,  9 Aug 2021 10:30:45 +0200
Message-Id: <20210809083050.2328336-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Xu8BULGPrbPnFUhwgN3-O65hLBIEpV7R
X-Proofpoint-ORIG-GUID: Xu8BULGPrbPnFUhwgN3-O65hLBIEpV7R
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-09_01:2021-08-06,2021-08-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 priorityscore=1501 mlxscore=0 spamscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 lowpriorityscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108090065
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please apply the following iucv patches to netdev's net-next tree.

Remove the usage of register asm statements and replace deprecated
CPU-hotplug functions with the current version.
Use use consume_skb() instead of kfree_skb() to avoid flooding
dropwatch with false-positives, and 2 patches with cleanups.

Heiko Carstens (1):
  net/iucv: get rid of register asm usage

Julian Wiedmann (3):
  net/af_iucv: support drop monitoring
  net/af_iucv: clean up a try_then_request_module()
  net/af_iucv: remove wrappers around iucv (de-)registration

Sebastian Andrzej Siewior (1):
  net/iucv: Replace deprecated CPU-hotplug functions.

 net/iucv/af_iucv.c | 72 ++++++++++++++++++----------------------------
 net/iucv/iucv.c    | 60 +++++++++++++++++++-------------------
 2 files changed, 59 insertions(+), 73 deletions(-)

-- 
2.25.1

