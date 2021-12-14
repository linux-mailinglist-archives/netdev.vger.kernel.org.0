Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15A60473C5D
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 06:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbhLNFSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 00:18:04 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34742 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229757AbhLNFSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 00:18:04 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE3OBkw013902;
        Tue, 14 Dec 2021 05:18:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=41+ZRrJqPO4U3M9AXFUHbwQdidRX9FninWhgvxoV9RE=;
 b=O3/PIiIcNlYgxL6aQm7AZIHdUWZ75iiRtfj3phVHZHiE5sPln5ZaUFV9HPfCh3Y3R/CG
 f8JFckXFbe06CpibkSZfkM9+CbHtQ4MchLlZVfJlxsXJdec0gPgAMISre30DT4oIng+1
 Dxp2LFQLfU2A4/Gp6ly0Q7BPrv8gLfbtjL7OmPATb6+r5R4hcx81N8FbLIyVadxu5/N9
 vViv3ycYuYaEILVODlLvjlxlRPNOCIoZrNhCesRQcKrun5NlPz7zX6NdW0iw36HlgXd7
 A5oecRGiNZJJepysB4aSOljqU/WE2DlTLXVG3wt6qtCwGpC8z2d9mprtZk2RtiIaXbOY 4g== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cx9r806c4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Dec 2021 05:18:02 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BE5CBpb003051;
        Tue, 14 Dec 2021 05:18:01 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma02dal.us.ibm.com with ESMTP id 3cvkmahadr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Dec 2021 05:18:01 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BE5I0Pd30081486
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 05:18:00 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ABAEAAE063;
        Tue, 14 Dec 2021 05:18:00 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 44CFEAE067;
        Tue, 14 Dec 2021 05:18:00 +0000 (GMT)
Received: from ltcden12-lp23.aus.stglabs.ibm.com (unknown [9.40.195.166])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 14 Dec 2021 05:18:00 +0000 (GMT)
From:   Dany Madden <drt@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com, ricklind@linux.ibm.com,
        brking@linux.ibm.com, otis@otisroot.com
Subject: [PATCH net 0/2] cleanup return codes
Date:   Tue, 14 Dec 2021 00:17:46 -0500
Message-Id: <20211214051748.511675-1-drt@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Q1sZNaHVPQVpBpV8AVjXTSZHP9X75WER
X-Proofpoint-GUID: Q1sZNaHVPQVpBpV8AVjXTSZHP9X75WER
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-14_01,2021-12-13_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 bulkscore=0 clxscore=1011 mlxlogscore=579 lowpriorityscore=0
 malwarescore=0 spamscore=0 priorityscore=1501 impostorscore=0
 suspectscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112140027
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update return code in the driver and remove unused defines from header
file.

Dany Madden (2):
  ibmvnic: Update driver return codes
  ibmvnic: remove unused defines

 drivers/net/ethernet/ibm/ibmvnic.c | 64 ++++++++++++++++--------------
 drivers/net/ethernet/ibm/ibmvnic.h |  2 -
 2 files changed, 34 insertions(+), 32 deletions(-)

-- 
2.27.0

