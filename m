Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 590F23A3D76
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 09:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231322AbhFKHrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 03:47:15 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4074 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229633AbhFKHrO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 03:47:14 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15B7Wv3C162905;
        Fri, 11 Jun 2021 03:45:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=UiQbbk6BFepCtBQlHAmibchj98XViTBXYqFAu0obfAo=;
 b=KJ8P8ZaIt7ib/LiOIilr7+xSBMviGppFEiIUBQMKIAlDjUfhiymmjY4yaKQ0Hc3t7mXO
 XWmzGNeUoTz4DsZ6CW4PiSI+fzAuoRtgMXmJ5jQu7Dk+8hfEDTlo/PFpqvyK+R8ZyDNp
 6NqpcF3yetPmAN/GecEsH7K4+dBCfO4O4DeLjMiruAYUhyIHTJSk0IfqWLroaWX7Q7M0
 xa6z413NK8hdLj2w41pvUjMP4cKGiOeTxDYkMTqN8xm4VRoNFhm8JPcZJ+d3hLb5sh4d
 tTmEA9gZS/A45h3f9X6A0NMhqXr0N+DFNZjkYyXwRd8BmmEETrKuQ2827aH8LltyxMIC Zw== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3942cha9x0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 03:45:16 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15B7fmXE030753;
        Fri, 11 Jun 2021 07:45:13 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3900hhu9j2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 07:45:12 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15B7jAhR21168598
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jun 2021 07:45:10 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E928F11C066;
        Fri, 11 Jun 2021 07:45:09 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A6A0211C05B;
        Fri, 11 Jun 2021 07:45:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 11 Jun 2021 07:45:09 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 2/2] s390/netiuvc: get rid of forward declarations
Date:   Fri, 11 Jun 2021 09:45:02 +0200
Message-Id: <20210611074502.1719233-3-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210611074502.1719233-1-jwi@linux.ibm.com>
References: <20210611074502.1719233-1-jwi@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 5gzxczoJhI_-lQD1MwtYnsfL6KxsgmgV
X-Proofpoint-GUID: 5gzxczoJhI_-lQD1MwtYnsfL6KxsgmgV
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-11_01:2021-06-11,2021-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0 spamscore=0
 bulkscore=0 clxscore=1015 lowpriorityscore=0 suspectscore=0
 impostorscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2106110048
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

Move netiucv_handler to get rid of forward declarations and gcc11
compile warnings:

drivers/s390/net/netiucv.c:518:65: warning: argument 2 of type ‘u8[16]’ {aka ‘unsigned char[16]’} with mismatched bound [-Warray-parameter=]
  518 | static void netiucv_callback_connack(struct iucv_path *path, u8 ipuser[16])
      |                                                              ~~~^~~~~~~~~~
drivers/s390/net/netiucv.c:122:58: note: previously declared as ‘u8 *’ {aka ‘unsigned char *’}
  122 | static void netiucv_callback_connack(struct iucv_path *, u8 *);

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/netiucv.c | 28 ++++++++++------------------
 1 file changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/s390/net/netiucv.c b/drivers/s390/net/netiucv.c
index 260860cf3aa1..5a0c2f07a3a2 100644
--- a/drivers/s390/net/netiucv.c
+++ b/drivers/s390/net/netiucv.c
@@ -118,24 +118,6 @@ static struct device_driver netiucv_driver = {
 	.bus  = &iucv_bus,
 };
 
-static int netiucv_callback_connreq(struct iucv_path *, u8 *, u8 *);
-static void netiucv_callback_connack(struct iucv_path *, u8 *);
-static void netiucv_callback_connrej(struct iucv_path *, u8 *);
-static void netiucv_callback_connsusp(struct iucv_path *, u8 *);
-static void netiucv_callback_connres(struct iucv_path *, u8 *);
-static void netiucv_callback_rx(struct iucv_path *, struct iucv_message *);
-static void netiucv_callback_txdone(struct iucv_path *, struct iucv_message *);
-
-static struct iucv_handler netiucv_handler = {
-	.path_pending	  = netiucv_callback_connreq,
-	.path_complete	  = netiucv_callback_connack,
-	.path_severed	  = netiucv_callback_connrej,
-	.path_quiesced	  = netiucv_callback_connsusp,
-	.path_resumed	  = netiucv_callback_connres,
-	.message_pending  = netiucv_callback_rx,
-	.message_complete = netiucv_callback_txdone
-};
-
 /**
  * Per connection profiling data
  */
@@ -774,6 +756,16 @@ static void conn_action_txdone(fsm_instance *fi, int event, void *arg)
 	}
 }
 
+static struct iucv_handler netiucv_handler = {
+	.path_pending	  = netiucv_callback_connreq,
+	.path_complete	  = netiucv_callback_connack,
+	.path_severed	  = netiucv_callback_connrej,
+	.path_quiesced	  = netiucv_callback_connsusp,
+	.path_resumed	  = netiucv_callback_connres,
+	.message_pending  = netiucv_callback_rx,
+	.message_complete = netiucv_callback_txdone,
+};
+
 static void conn_action_connaccept(fsm_instance *fi, int event, void *arg)
 {
 	struct iucv_event *ev = arg;
-- 
2.25.1

