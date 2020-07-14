Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7545E21F3EF
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 16:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728847AbgGNOXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 10:23:47 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:26868 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728706AbgGNOXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 10:23:23 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06EDZFoF095150;
        Tue, 14 Jul 2020 10:23:22 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 328s0dbn3u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jul 2020 10:23:21 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06EEHTvE021600;
        Tue, 14 Jul 2020 14:23:18 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3274pgub5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jul 2020 14:23:18 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06EENFst63242558
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 14:23:16 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D7E324C05A;
        Tue, 14 Jul 2020 14:23:15 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 92D6F4C050;
        Tue, 14 Jul 2020 14:23:15 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 Jul 2020 14:23:15 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 10/10] s390/qeth: constify the MPC initialization data
Date:   Tue, 14 Jul 2020 16:23:05 +0200
Message-Id: <20200714142305.29297-11-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200714142305.29297-1-jwi@linux.ibm.com>
References: <20200714142305.29297-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-14_04:2020-07-14,2020-07-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 suspectscore=0 spamscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 clxscore=1015 impostorscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140104
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We're not modifying these data blobs, so mark them as constant.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c |  2 +-
 drivers/s390/net/qeth_core_mpc.c  | 16 ++++++++--------
 drivers/s390/net/qeth_core_mpc.h  | 17 ++++++++---------
 3 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 01a280b5e8d2..8a76022fceda 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -2026,7 +2026,7 @@ static bool qeth_mpc_match_reply(struct qeth_cmd_buffer *iob,
 }
 
 static struct qeth_cmd_buffer *qeth_mpc_alloc_cmd(struct qeth_card *card,
-						  void *data,
+						  const void *data,
 						  unsigned int data_length)
 {
 	struct qeth_cmd_buffer *iob;
diff --git a/drivers/s390/net/qeth_core_mpc.c b/drivers/s390/net/qeth_core_mpc.c
index e3f4866c158e..68c2588b9dcc 100644
--- a/drivers/s390/net/qeth_core_mpc.c
+++ b/drivers/s390/net/qeth_core_mpc.c
@@ -10,7 +10,7 @@
 #include <asm/cio.h>
 #include "qeth_core_mpc.h"
 
-unsigned char IDX_ACTIVATE_READ[] = {
+const unsigned char IDX_ACTIVATE_READ[] = {
 	0x00, 0x00, 0x80, 0x00,  0x00, 0x00, 0x00, 0x00,
 	0x19, 0x01, 0x01, 0x80,  0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,  0x00, 0x00, 0xc8, 0xc1,
@@ -18,7 +18,7 @@ unsigned char IDX_ACTIVATE_READ[] = {
 	0x00, 0x00
 };
 
-unsigned char IDX_ACTIVATE_WRITE[] = {
+const unsigned char IDX_ACTIVATE_WRITE[] = {
 	0x00, 0x00, 0x80, 0x00,  0x00, 0x00, 0x00, 0x00,
 	0x15, 0x01, 0x01, 0x80,  0x00, 0x00, 0x00, 0x00,
 	0xff, 0xff, 0x00, 0x00,  0x00, 0x00, 0xc8, 0xc1,
@@ -26,7 +26,7 @@ unsigned char IDX_ACTIVATE_WRITE[] = {
 	0x00, 0x00
 };
 
-unsigned char CM_ENABLE[] = {
+const unsigned char CM_ENABLE[] = {
 	0x00, 0xe0, 0x00, 0x00,  0x00, 0x00, 0x00, 0x01,
 	0x00, 0x00, 0x00, 0x14,  0x00, 0x00, 0x00, 0x63,
 	0x10, 0x00, 0x00, 0x01,
@@ -45,7 +45,7 @@ unsigned char CM_ENABLE[] = {
 	0xff, 0xff, 0xff
 };
 
-unsigned char CM_SETUP[] = {
+const unsigned char CM_SETUP[] = {
 	0x00, 0xe0, 0x00, 0x00,  0x00, 0x00, 0x00, 0x02,
 	0x00, 0x00, 0x00, 0x14,  0x00, 0x00, 0x00, 0x64,
 	0x10, 0x00, 0x00, 0x01,
@@ -65,7 +65,7 @@ unsigned char CM_SETUP[] = {
 	0x04, 0x06, 0xc8, 0x00
 };
 
-unsigned char ULP_ENABLE[] = {
+const unsigned char ULP_ENABLE[] = {
 	0x00, 0xe0, 0x00, 0x00,  0x00, 0x00, 0x00, 0x03,
 	0x00, 0x00, 0x00, 0x14,  0x00, 0x00, 0x00, 0x6b,
 	0x10, 0x00, 0x00, 0x01,
@@ -85,7 +85,7 @@ unsigned char ULP_ENABLE[] = {
 	0xf1, 0x00, 0x00
 };
 
-unsigned char ULP_SETUP[] = {
+const unsigned char ULP_SETUP[] = {
 	0x00, 0xe0, 0x00, 0x00,  0x00, 0x00, 0x00, 0x04,
 	0x00, 0x00, 0x00, 0x14,  0x00, 0x00, 0x00, 0x6c,
 	0x10, 0x00, 0x00, 0x01,
@@ -107,7 +107,7 @@ unsigned char ULP_SETUP[] = {
 	0x00, 0x00, 0x00, 0x00
 };
 
-unsigned char DM_ACT[] = {
+const unsigned char DM_ACT[] = {
 	0x00, 0xe0, 0x00, 0x00,  0x00, 0x00, 0x00, 0x05,
 	0x00, 0x00, 0x00, 0x14,  0x00, 0x00, 0x00, 0x55,
 	0x10, 0x00, 0x00, 0x01,
@@ -123,7 +123,7 @@ unsigned char DM_ACT[] = {
 	0x05, 0x40, 0x01, 0x01,  0x00
 };
 
-unsigned char IPA_PDU_HEADER[] = {
+const unsigned char IPA_PDU_HEADER[] = {
 	0x00, 0xe0, 0x00, 0x00,  0x77, 0x77, 0x77, 0x77,
 	0x00, 0x00, 0x00, 0x14,  0x00, 0x00, 0x00, 0x00,
 	0x10, 0x00, 0x00, 0x01,  0x00, 0x00, 0x00, 0x00,
diff --git a/drivers/s390/net/qeth_core_mpc.h b/drivers/s390/net/qeth_core_mpc.h
index 9d6f39d8f9ab..b459def0fb26 100644
--- a/drivers/s390/net/qeth_core_mpc.h
+++ b/drivers/s390/net/qeth_core_mpc.h
@@ -13,13 +13,13 @@
 #include <uapi/linux/if_ether.h>
 #include <uapi/linux/in6.h>
 
+extern const unsigned char IPA_PDU_HEADER[];
 #define IPA_PDU_HEADER_SIZE	0x40
 #define QETH_IPA_PDU_LEN_TOTAL(buffer) (buffer + 0x0e)
 #define QETH_IPA_PDU_LEN_PDU1(buffer) (buffer + 0x26)
 #define QETH_IPA_PDU_LEN_PDU2(buffer) (buffer + 0x29)
 #define QETH_IPA_PDU_LEN_PDU3(buffer) (buffer + 0x3a)
 
-extern unsigned char IPA_PDU_HEADER[];
 #define QETH_IPA_CMD_DEST_ADDR(buffer) (buffer + 0x2c)
 
 #define QETH_SEQ_NO_LENGTH	4
@@ -858,7 +858,7 @@ extern const char *qeth_get_ipa_cmd_name(enum qeth_ipa_cmds cmd);
 /* END OF   IP Assist related definitions                                    */
 /*****************************************************************************/
 
-extern unsigned char CM_ENABLE[];
+extern const unsigned char CM_ENABLE[];
 #define CM_ENABLE_SIZE 0x63
 #define QETH_CM_ENABLE_ISSUER_RM_TOKEN(buffer) (buffer + 0x2c)
 #define QETH_CM_ENABLE_FILTER_TOKEN(buffer) (buffer + 0x53)
@@ -868,7 +868,7 @@ extern unsigned char CM_ENABLE[];
 		(PDU_ENCAPSULATION(buffer) + 0x13)
 
 
-extern unsigned char CM_SETUP[];
+extern const unsigned char CM_SETUP[];
 #define CM_SETUP_SIZE 0x64
 #define QETH_CM_SETUP_DEST_ADDR(buffer) (buffer + 0x2c)
 #define QETH_CM_SETUP_CONNECTION_TOKEN(buffer) (buffer + 0x51)
@@ -877,7 +877,7 @@ extern unsigned char CM_SETUP[];
 #define QETH_CM_SETUP_RESP_DEST_ADDR(buffer) \
 		(PDU_ENCAPSULATION(buffer) + 0x1a)
 
-extern unsigned char ULP_ENABLE[];
+extern const unsigned char ULP_ENABLE[];
 #define ULP_ENABLE_SIZE 0x6b
 #define QETH_ULP_ENABLE_LINKNUM(buffer) (buffer + 0x61)
 #define QETH_ULP_ENABLE_DEST_ADDR(buffer) (buffer + 0x2c)
@@ -898,7 +898,7 @@ extern unsigned char ULP_ENABLE[];
 #define QETH_ULP_ENABLE_PROT_TYPE(buffer) (buffer + 0x50)
 #define QETH_IPA_CMD_PROT_TYPE(buffer) (buffer + 0x19)
 
-extern unsigned char ULP_SETUP[];
+extern const unsigned char ULP_SETUP[];
 #define ULP_SETUP_SIZE 0x6c
 #define QETH_ULP_SETUP_DEST_ADDR(buffer) (buffer + 0x2c)
 #define QETH_ULP_SETUP_CONNECTION_TOKEN(buffer) (buffer + 0x51)
@@ -910,7 +910,7 @@ extern unsigned char ULP_SETUP[];
 		(PDU_ENCAPSULATION(buffer) + 0x1a)
 
 
-extern unsigned char DM_ACT[];
+extern const unsigned char DM_ACT[];
 #define DM_ACT_SIZE 0x55
 #define QETH_DM_ACT_DEST_ADDR(buffer) (buffer + 0x2c)
 #define QETH_DM_ACT_CONNECTION_TOKEN(buffer) (buffer + 0x51)
@@ -921,9 +921,8 @@ extern unsigned char DM_ACT[];
 #define QETH_PDU_HEADER_SEQ_NO(buffer) (buffer + 0x1c)
 #define QETH_PDU_HEADER_ACK_SEQ_NO(buffer) (buffer + 0x20)
 
-extern unsigned char IDX_ACTIVATE_READ[];
-extern unsigned char IDX_ACTIVATE_WRITE[];
-
+extern const unsigned char IDX_ACTIVATE_READ[];
+extern const unsigned char IDX_ACTIVATE_WRITE[];
 #define IDX_ACTIVATE_SIZE	0x22
 #define QETH_IDX_ACT_PNO(buffer) (buffer+0x0b)
 #define QETH_IDX_ACT_ISSUER_RM_TOKEN(buffer) (buffer + 0x0c)
-- 
2.17.1

