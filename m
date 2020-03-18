Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1184189C59
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 13:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbgCRMz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 08:55:27 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44990 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726962AbgCRMzZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 08:55:25 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02ICXEsj045266
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 08:55:24 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yua3uvh85-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 08:55:24 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Wed, 18 Mar 2020 12:55:22 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 18 Mar 2020 12:55:19 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02ICtIq046858472
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Mar 2020 12:55:18 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C0BFA4054;
        Wed, 18 Mar 2020 12:55:18 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 160C0A405B;
        Wed, 18 Mar 2020 12:55:18 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 18 Mar 2020 12:55:18 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Leon Romanovsky <leonro@mellanox.com>
Subject: [PATCH net-next 08/11] s390/qeth: don't report hard-coded driver version
Date:   Wed, 18 Mar 2020 13:54:52 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200318125455.5838-1-jwi@linux.ibm.com>
References: <20200318125455.5838-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20031812-0028-0000-0000-000003E6E677
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20031812-0029-0000-0000-000024AC3E65
Message-Id: <20200318125455.5838-9-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-18_05:2020-03-18,2020-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 phishscore=0 priorityscore=1501 clxscore=1015 impostorscore=0 adultscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003180061
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Versions are meaningless for an in-kernel driver.
Instead use the UTS_RELEASE that is set by ethtool_get_drvinfo().

Cc: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_ethtool.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/s390/net/qeth_ethtool.c b/drivers/s390/net/qeth_ethtool.c
index 5cfa371b7426..31e019085fc3 100644
--- a/drivers/s390/net/qeth_ethtool.c
+++ b/drivers/s390/net/qeth_ethtool.c
@@ -153,7 +153,6 @@ static void qeth_get_drvinfo(struct net_device *dev,
 
 	strlcpy(info->driver, IS_LAYER2(card) ? "qeth_l2" : "qeth_l3",
 		sizeof(info->driver));
-	strlcpy(info->version, "1.0", sizeof(info->version));
 	strlcpy(info->fw_version, card->info.mcl_level,
 		sizeof(info->fw_version));
 	snprintf(info->bus_info, sizeof(info->bus_info), "%s/%s/%s",
-- 
2.17.1

