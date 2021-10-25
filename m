Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A30D543932E
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 11:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232721AbhJYKAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 06:00:05 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56482 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232734AbhJYJ7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 05:59:36 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19P9PxGu020661;
        Mon, 25 Oct 2021 09:57:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=raKGaq7KbvGpgVfi7/Y+T3jPC8X2N0kxS80GlNBhIYE=;
 b=SgMdP7uheI9DqstsgIHY0/PWDfCG/EsO7INfuSxxnp8/ozyfzZt7F8k11HlPwrPjh/yG
 pqWUCNBumKZFtB6taXpmRo+izWAtrXsLIIj7dTYh+LRFBsxgMAb1AEr/zHVMBTKeg1ra
 PzwsIPUMBrDgZYOjWAkwi6NQ0khtUCKDQXe356Zy5Tkc0ir5GmavUfDsLnnxr/Qus4rZ
 sWxbbtopOuqztivHhliwd0cFIDkjkaZBhPbQF8fflbtAC4rkVQ10rMAxf0fCatRJba7m
 D2yK6xAD0sMH8gNF8dYh9OMVlVxQjg5v91+Ibm1rjcmRdccx7WrhtWLlLBPbzfjVXLE/ 1g== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bwsxs0m44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 09:57:12 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19P9h4GD010060;
        Mon, 25 Oct 2021 09:57:10 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3bva19m9cj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 09:57:10 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19P9v7cd60686672
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Oct 2021 09:57:07 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3743211C06E;
        Mon, 25 Oct 2021 09:57:07 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E5FC211C05C;
        Mon, 25 Oct 2021 09:57:06 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 25 Oct 2021 09:57:06 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 9/9] s390/qeth: update kerneldoc for qeth_add_hw_header()
Date:   Mon, 25 Oct 2021 11:56:58 +0200
Message-Id: <20211025095658.3527635-10-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211025095658.3527635-1-jwi@linux.ibm.com>
References: <20211025095658.3527635-1-jwi@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: c4NNRu9oXs6kHe1QKI7zN6FEFf2GvPrO
X-Proofpoint-GUID: c4NNRu9oXs6kHe1QKI7zN6FEFf2GvPrO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-25_03,2021-10-25_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 mlxscore=0 spamscore=0
 malwarescore=0 clxscore=1015 impostorscore=0 mlxlogscore=999
 priorityscore=1501 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109230001 definitions=main-2110250058
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qeth_add_hw_header() is missing documentation for some of its
parameters, fix that up.

Reported-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 6e410497826a..26c55f67289f 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -3873,12 +3873,14 @@ static unsigned int qeth_count_elements(struct sk_buff *skb,
 
 /**
  * qeth_add_hw_header() - add a HW header to an skb.
+ * @queue: TX queue that the skb will be placed on.
  * @skb: skb that the HW header should be added to.
  * @hdr: double pointer to a qeth_hdr. When returning with >= 0,
  *	 it contains a valid pointer to a qeth_hdr.
  * @hdr_len: length of the HW header.
  * @proto_len: length of protocol headers that need to be in same page as the
  *	       HW header.
+ * @elements: returns the required number of buffer elements for this skb.
  *
  * Returns the pushed length. If the header can't be pushed on
  * (eg. because it would cross a page boundary), it is allocated from
-- 
2.25.1

