Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9529F3CF4A6
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 08:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242639AbhGTF7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 01:59:04 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39708 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242554AbhGTF62 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 01:58:28 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16K6XLE9103287;
        Tue, 20 Jul 2021 02:39:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=O/VQ0ww/VrSBje9dK1/CgqVGewCiOLr1uqPBtY4wzlk=;
 b=Pgu0n4ywvGayn/ynEXLAw2OI1QuuxO5oofqKSqRLIS4Mea+IUwDPWX4H/25miIjbFvWv
 4XWxc29UnOOW/ygGLN1tSLT+dEeG+llUAOhu6bU9jDH6M+gqJTzvOl5ik8o12GIO9k3G
 9VawW+IUuLSEEuQXYzIkuQ+CX9orfdtc1xJtZk2g6qLFHg8RmFknE1ZHQFaLslkx3pgR
 gIzSJY9gbF6LtcmcHOWYBtUfgNJ0VLQWFzwsxENPRfHM9xibWIMxjjpTIMB8yz7muh5L
 y8SLKlpPS/giolHHCrHzkuTfSfRmSBLPYxc+zXiMA1+qOXO3fLO3tbnd+Tz+aj8ZIfrP EQ== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39wpxmufkh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Jul 2021 02:39:04 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16K6bbOG005281;
        Tue, 20 Jul 2021 06:38:59 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 39upu88mhv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Jul 2021 06:38:58 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16K6aZQF23396854
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Jul 2021 06:36:35 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A441FA4053;
        Tue, 20 Jul 2021 06:38:55 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 43C92A4051;
        Tue, 20 Jul 2021 06:38:55 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 20 Jul 2021 06:38:55 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>
Subject: [PATCH net-next 2/3] s390/qeth: clean up QETH_PROT_* naming
Date:   Tue, 20 Jul 2021 08:38:48 +0200
Message-Id: <20210720063849.2646776-3-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210720063849.2646776-1-jwi@linux.ibm.com>
References: <20210720063849.2646776-1-jwi@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6fug1bjh194nyAhurzQ4ddyM8TGxTdmy
X-Proofpoint-ORIG-GUID: 6fug1bjh194nyAhurzQ4ddyM8TGxTdmy
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-20_04:2021-07-19,2021-07-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 impostorscore=0 clxscore=1015 malwarescore=0
 phishscore=0 spamscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 suspectscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107200037
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The QETH_PROT_* naming is shared among two unrelated areas - one is
the MPC-level protocol identifiers, the other is the qeth_prot_version
enum.

Rename the MPC definitions to use QETH_MPC_PROT_*.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 2 +-
 drivers/s390/net/qeth_core_mpc.h  | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 19a4bf25bd75..02a12f984ce2 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -2422,7 +2422,7 @@ static int qeth_ulp_enable_cb(struct qeth_card *card, struct qeth_reply *reply,
 
 static u8 qeth_mpc_select_prot_type(struct qeth_card *card)
 {
-	return IS_LAYER2(card) ? QETH_PROT_LAYER2 : QETH_PROT_TCPIP;
+	return IS_LAYER2(card) ? QETH_MPC_PROT_L2 : QETH_MPC_PROT_L3;
 }
 
 static int qeth_ulp_enable(struct qeth_card *card)
diff --git a/drivers/s390/net/qeth_core_mpc.h b/drivers/s390/net/qeth_core_mpc.h
index a0dbe8b77924..6257f00786b3 100644
--- a/drivers/s390/net/qeth_core_mpc.h
+++ b/drivers/s390/net/qeth_core_mpc.h
@@ -905,9 +905,9 @@ extern const unsigned char ULP_ENABLE[];
 		(PDU_ENCAPSULATION(buffer) + 0x17)
 #define QETH_ULP_ENABLE_RESP_LINK_TYPE(buffer) \
 		(PDU_ENCAPSULATION(buffer) + 0x2b)
-/* Layer 2 definitions */
-#define QETH_PROT_LAYER2 0x08
-#define QETH_PROT_TCPIP  0x03
+
+#define QETH_MPC_PROT_L2	0x08
+#define QETH_MPC_PROT_L3	0x03
 #define QETH_ULP_ENABLE_PROT_TYPE(buffer) (buffer + 0x50)
 #define QETH_IPA_CMD_PROT_TYPE(buffer) (buffer + 0x19)
 
-- 
2.25.1

