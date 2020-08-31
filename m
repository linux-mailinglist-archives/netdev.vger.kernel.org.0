Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9AA8257F26
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 18:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728879AbgHaQ6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 12:58:49 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:1316 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728730AbgHaQ6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 12:58:22 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07VGVvxR146716
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 12:58:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=uABidDLy6bogIGlWn06ZrEYEiPQvr84B+nhE5A+kvmM=;
 b=CqVC3pV1tDj9FexHx2sRl0k3ZAxm2ElkuHS5BEQCoF6Ntip5riAWq1juK6Gvg9IeagEe
 5CbV3FQt+1sFDe7kh2vvPyT0vvjlDXjOldJaqy/huWpRFZd7TV8tnCogVtyJ8SBWm2Lw
 np7cA7WWO+YDs8UVKwFssmGaNEMFgF5rrbeQL4ua9/lEVsDjMYTweEzGK/iGFyMdLXda
 TS1qOFXd82jv6iUC/86mlQYhNFKp4nSUDb3iAHSSSzuI9F8gjsssc+tVPnUZ7ki2/x3r
 zutCxc+BQJux0Lq/OIMbpFf7DDEXExZd5KU2IxgctByDI5kTf+Xjw+mhjbSrd47ozfmm qA== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33930dkv28-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 12:58:20 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07VGr4Z8002225
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 16:58:20 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma05wdc.us.ibm.com with ESMTP id 337en91heg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 16:58:20 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07VGwJTg40370616
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 16:58:19 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CA90AB2064;
        Mon, 31 Aug 2020 16:58:19 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C8376B2067;
        Mon, 31 Aug 2020 16:58:18 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.160.96.4])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 31 Aug 2020 16:58:18 +0000 (GMT)
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     drt@linux.vnet.ibm.com, sukadev@linux.vnet.ibm.com,
        ljp@linux.vnet.ibm.com, cforno12@linux.ibm.com,
        Thomas Falcon <tlfalcon@linux.ibm.com>
Subject: [PATCH net-next 3/5] ibmvnic: Remove ACL change indication definitions
Date:   Mon, 31 Aug 2020 11:58:11 -0500
Message-Id: <1598893093-14280-4-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1598893093-14280-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1598893093-14280-1-git-send-email-tlfalcon@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-31_07:2020-08-31,2020-08-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 spamscore=0 malwarescore=0 adultscore=0 clxscore=1015 suspectscore=1
 mlxlogscore=998 priorityscore=1501 lowpriorityscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310095
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Access Control Lists can not be dynamically changed,
so an existing device can never be notified of an update
in ACL settings. Remove it.

Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.h | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index 8da9879..e497392 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -576,15 +576,6 @@ struct ibmvnic_get_vpd_rsp {
 	struct ibmvnic_rc rc;
 } __packed __aligned(8);
 
-struct ibmvnic_acl_change_indication {
-	u8 first;
-	u8 cmd;
-	__be16 change_type;
-#define IBMVNIC_MAC_ACL 0
-#define IBMVNIC_VLAN_ACL 1
-	u8 reserved[12];
-} __packed __aligned(8);
-
 struct ibmvnic_acl_query {
 	u8 first;
 	u8 cmd;
@@ -703,7 +694,6 @@ struct ibmvnic_query_map_rsp {
 	struct ibmvnic_get_vpd_size_rsp get_vpd_size_rsp;
 	struct ibmvnic_get_vpd get_vpd;
 	struct ibmvnic_get_vpd_rsp get_vpd_rsp;
-	struct ibmvnic_acl_change_indication acl_change_indication;
 	struct ibmvnic_acl_query acl_query;
 	struct ibmvnic_generic_crq acl_query_rsp;
 	struct ibmvnic_tune tune;
-- 
1.8.3.1

