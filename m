Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDCAC27A522
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 03:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgI1BNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 21:13:37 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49066 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726460AbgI1BNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 21:13:34 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08S11XFV149418
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 21:13:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=CNd8gO818PG0/fpTgcEXTP2tZ+1DrSi0ERUwk7/dcKk=;
 b=poL8VXTx0U2s86ScZ+nSthelspXXyWbRrF8ryYwXF3pnuLD2XaTIZob706e5k8w5Vp8Y
 QdJ1PJX8Mnct55Jta+kSExnp26pNmg5jId3XhPA5oURNolRg7huikZ9R/s5db9N2rIy/
 /oqRrgkORUFSNNnGBV7h1CtmVfQXT9SNTly4/QYxzJ/Iz7n87KplOD5oG/PKVEOSzt5N
 2btsT6vNFqt1er20WJUdezT925+mDw+MVDjfqjjLoVspsNExzfJDPzRAzAWhlWZ2xs6Q
 Ao36I3d3JBr/6dzeiT6zM+PHpc+NPc1wM7usglEvo/qpVNHKkiS4su0DAgjo/OXqQarG HA== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33u46usys6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 21:13:32 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08S18FgM023144
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 01:13:32 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma05wdc.us.ibm.com with ESMTP id 33sw98pjgg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 01:13:32 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08S1DWCa39322058
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Sep 2020 01:13:32 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 02EF7AC05F;
        Mon, 28 Sep 2020 01:13:32 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B1A1AC05B;
        Mon, 28 Sep 2020 01:13:31 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.151.55])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 28 Sep 2020 01:13:31 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com, drt@linux.ibm.com,
        Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net-next 2/5] ibmvnic: rename ibmvnic_send_req_caps to send_request_cap
Date:   Sun, 27 Sep 2020 20:13:27 -0500
Message-Id: <20200928011330.79774-3-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20200928011330.79774-1-ljp@linux.ibm.com>
References: <20200928011330.79774-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-27_18:2020-09-24,2020-09-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 clxscore=1015 impostorscore=0 priorityscore=1501 bulkscore=0 phishscore=0
 mlxlogscore=999 lowpriorityscore=0 malwarescore=0 suspectscore=1
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009280000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The new name send_request_cap pairs with handle_request_cap_rsp.

Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index b4dc63cad4c5..928ad9e98afa 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -3299,7 +3299,7 @@ static int init_sub_crqs(struct ibmvnic_adapter *adapter)
 	return -1;
 }
 
-static void ibmvnic_send_req_caps(struct ibmvnic_adapter *adapter, int retry)
+static void send_request_cap(struct ibmvnic_adapter *adapter, int retry)
 {
 	struct device *dev = &adapter->vdev->dev;
 	union ibmvnic_crq crq;
@@ -4266,7 +4266,7 @@ static void handle_request_cap_rsp(union ibmvnic_crq *crq,
 				be64_to_cpu(crq->request_capability_rsp.number);
 		}
 
-		ibmvnic_send_req_caps(adapter, 1);
+		send_request_cap(adapter, 1);
 		return;
 	default:
 		dev_err(dev, "Error %d in request cap rsp\n",
@@ -4582,7 +4582,7 @@ static void handle_query_cap_rsp(union ibmvnic_crq *crq,
 out:
 	if (atomic_read(&adapter->running_cap_crqs) == 0) {
 		adapter->wait_capability = false;
-		ibmvnic_send_req_caps(adapter, 0);
+		send_request_cap(adapter, 0);
 	}
 }
 
-- 
2.23.0

