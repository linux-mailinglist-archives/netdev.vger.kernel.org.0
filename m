Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA8242804C6
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 19:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732945AbgJARMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 13:12:01 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:4229 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732866AbgJARLx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 13:11:53 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 091H200O031039;
        Thu, 1 Oct 2020 13:11:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=yYEcyPP/wqQVm7ClXdu9ltR5ZqDVzWOkv6YMVtwzdo8=;
 b=MghEvdl4kTGbQMJ8UE2ReCcp+/egt50d75ZRL9XpBAUIPMWKvPEb44wM0yu5fJy5oMjT
 hjqvjWYFiv6XSuihDmiuEErCT7Yp/oCbzxfZPFzz2/lLeDq+EXCMuZsAKHksnCwdW3mG
 tpJ8J1vws2vZOLg/vPuFrb241Bmv2G1kgfRE1vhfFCQ5H45VfOW00fRWfdZi8i0vrf/X
 bICy++LDzFuDdGWnCNj1knIvwgsWjhU8DnJofsdGFraRle9Ll0PmLtH1jGJdNsuqGheQ
 KZFBuTcS7tyCTwml5ums/9aIopZtOGc1R0RJNa9IWSPU7paapcfyT4cJInj/rLofKciZ Nw== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33wjtbgx9a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Oct 2020 13:11:50 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 091H2EbU019619;
        Thu, 1 Oct 2020 17:11:47 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 33v6mgta9r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Oct 2020 17:11:47 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 091HBi6x12583312
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Oct 2020 17:11:44 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 535D3A405D;
        Thu,  1 Oct 2020 17:11:44 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0D7FBA405B;
        Thu,  1 Oct 2020 17:11:44 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  1 Oct 2020 17:11:43 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH net-next 7/7] s390/ctcm: remove orphaned function declarations
Date:   Thu,  1 Oct 2020 19:11:36 +0200
Message-Id: <20201001171136.46830-8-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201001171136.46830-1-jwi@linux.ibm.com>
References: <20201001171136.46830-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-01_05:2020-10-01,2020-10-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 clxscore=1015 mlxscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0
 priorityscore=1501 mlxlogscore=999 suspectscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010010139
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

drivers/s390/net/ctcm_fsms.h: fsm_action_nop - only declaration left
after commit 04885948b101 ("ctc: removal of the old ctc driver")

drivers/s390/net/ctcm_mpc.h: ctcmpc_open - only declaration left after
commit 293d984f0e36 ("ctcm: infrastructure for replaced ctc driver")

Reviewed-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/ctcm_fsms.h | 1 -
 drivers/s390/net/ctcm_mpc.h  | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/s390/net/ctcm_fsms.h b/drivers/s390/net/ctcm_fsms.h
index 225737295cb4..d98c486724d4 100644
--- a/drivers/s390/net/ctcm_fsms.h
+++ b/drivers/s390/net/ctcm_fsms.h
@@ -159,7 +159,6 @@ extern const char *ctc_ch_state_names[];
 
 void ctcm_ccw_check_rc(struct channel *ch, int rc, char *msg);
 void ctcm_purge_skb_queue(struct sk_buff_head *q);
-void fsm_action_nop(fsm_instance *fi, int event, void *arg);
 
 /*
  * ----- non-static actions for ctcm channel statemachine -----
diff --git a/drivers/s390/net/ctcm_mpc.h b/drivers/s390/net/ctcm_mpc.h
index 441d7b211f0f..da41b26f76d1 100644
--- a/drivers/s390/net/ctcm_mpc.h
+++ b/drivers/s390/net/ctcm_mpc.h
@@ -228,7 +228,6 @@ static inline void ctcmpc_dump32(char *buf, int len)
 		ctcmpc_dumpit(buf, 32);
 }
 
-int ctcmpc_open(struct net_device *);
 void ctcm_ccw_check_rc(struct channel *, int, char *);
 void mpc_group_ready(unsigned long adev);
 void mpc_channel_action(struct channel *ch, int direction, int action);
-- 
2.17.1

