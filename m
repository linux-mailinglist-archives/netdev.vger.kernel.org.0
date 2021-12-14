Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10404473C5F
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 06:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhLNFSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 00:18:17 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60594 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229794AbhLNFSQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 00:18:16 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE3NXna006083;
        Tue, 14 Dec 2021 05:18:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=smPy9P4mImxY1jWQxmehjAClVm74vnzjR4s2ilEYfIA=;
 b=HlHKdiOY6f0DcgMOQ/DMyZUoT1HQoj1UQyXHNM5LjO6M44zytSB5LbBJNCUL7PCSu0sr
 RXeW9p6o6hWRRArz9Y8owCWEj7GxQQzRLsUib8Jk2yMzox4qx/LI3T0hbrw9xohw5S5Y
 OPeYQgN0LnpdSTVRk68Iq+8wmlzxpHgtXJKespa+d52BvLBxslNLI634u3p9XZPm1fu4
 juxyF2VnVlMrFp2239/v4YsFavPFiWV5nR/6hl27vFzYXUiKV8qt9LCBH47t3tcsCslh
 USdRlvMgMnXK6ZpNICyqbCfFErnmirXcC5e/h2NEn+Hz4ukW7ZWcb1mOI/uahY5lYbsS pg== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cx9r6r0s1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Dec 2021 05:18:15 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BE5IFJq025804;
        Tue, 14 Dec 2021 05:18:15 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma04dal.us.ibm.com with ESMTP id 3cvkma9cvx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Dec 2021 05:18:15 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BE5IEA827066842
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 05:18:14 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0BCB1AE06A;
        Tue, 14 Dec 2021 05:18:14 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A32C1AE068;
        Tue, 14 Dec 2021 05:18:13 +0000 (GMT)
Received: from ltcden12-lp23.aus.stglabs.ibm.com (unknown [9.40.195.166])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 14 Dec 2021 05:18:13 +0000 (GMT)
From:   Dany Madden <drt@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com, ricklind@linux.ibm.com,
        brking@linux.ibm.com, otis@otisroot.com
Subject: [PATCH net 2/2] ibmvnic: remove unused defines
Date:   Tue, 14 Dec 2021 00:17:48 -0500
Message-Id: <20211214051748.511675-3-drt@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211214051748.511675-1-drt@linux.ibm.com>
References: <20211214051748.511675-1-drt@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: uM8S7IOMrmz8FSRe9h9f59Im3WWfa_VH
X-Proofpoint-ORIG-GUID: uM8S7IOMrmz8FSRe9h9f59Im3WWfa_VH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-14_01,2021-12-13_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 suspectscore=0 mlxlogscore=828 malwarescore=0
 mlxscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0 adultscore=0
 impostorscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2112140027
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IBMVNIC_STATS_TIMEOUT and IBMVNIC_INIT_FAILED are not used in the driver.
Remove them.

Suggested-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Signed-off-by: Dany Madden <drt@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index b8e42f67d897..4a8f36e0ab07 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -18,8 +18,6 @@
 #define IBMVNIC_NAME		"ibmvnic"
 #define IBMVNIC_DRIVER_VERSION	"1.0.1"
 #define IBMVNIC_INVALID_MAP	-1
-#define IBMVNIC_STATS_TIMEOUT	1
-#define IBMVNIC_INIT_FAILED	2
 #define IBMVNIC_OPEN_FAILED	3
 
 /* basic structures plus 100 2k buffers */
-- 
2.27.0

