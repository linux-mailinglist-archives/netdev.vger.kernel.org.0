Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBF5B3B31B5
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 16:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232341AbhFXOry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 10:47:54 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:61652 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230170AbhFXOrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 10:47:46 -0400
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15OEfcMe027387;
        Thu, 24 Jun 2021 10:45:06 -0400
Received: from nwd2mta4.analog.com ([137.71.173.58])
        by mx0a-00128a01.pphosted.com with ESMTP id 39c2y8eawq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Jun 2021 10:45:06 -0400
Received: from ASHBMBX9.ad.analog.com (ASHBMBX9.ad.analog.com [10.64.17.10])
        by nwd2mta4.analog.com (8.14.7/8.14.7) with ESMTP id 15OEj5CV041074
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 24 Jun 2021 10:45:05 -0400
Received: from ASHBMBX9.ad.analog.com (10.64.17.10) by ASHBMBX9.ad.analog.com
 (10.64.17.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.858.5; Thu, 24 Jun 2021
 10:45:04 -0400
Received: from zeus.spd.analog.com (10.66.68.11) by ashbmbx9.ad.analog.com
 (10.64.17.10) with Microsoft SMTP Server id 15.2.858.5 via Frontend
 Transport; Thu, 24 Jun 2021 10:45:04 -0400
Received: from localhost.localdomain ([10.48.65.12])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 15OEj0IJ003029;
        Thu, 24 Jun 2021 10:45:00 -0400
From:   <alexandru.tachici@analog.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux@armlinux.org.uk>,
        Alexandru Tachici <alexandru.tachici@analog.com>
Subject: [PATCH 0/4] net: phy: adin1100: Add initial support for ADIN1100 industrial PHY
Date:   Thu, 24 Jun 2021 17:53:49 +0300
Message-ID: <20210624145353.6910-1-alexandru.tachici@analog.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-ADIRuleOP-NewSCL: Rule Triggered
X-Proofpoint-ORIG-GUID: _8R1_7ezYWuivUCvBiCTJinBV2GPDJtq
X-Proofpoint-GUID: _8R1_7ezYWuivUCvBiCTJinBV2GPDJtq
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-24_12:2021-06-24,2021-06-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0
 clxscore=1011 priorityscore=1501 suspectscore=0 bulkscore=0
 mlxlogscore=848 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2106240081
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandru Tachici <alexandru.tachici@analog.com>

The ADIN1100 is a low power single port 10BASE-T1L transceiver designed for
industrial Ethernet applications and is compliant with the IEEE 802.3cg
Ethernet standard for long reach 10 Mb/s Single Pair Ethernet.

1. Add basic support for ADIN1100.

Alexandru Ardelean (1):
  net: phy: adin1100: Add initial support for ADIN1100 industrial PHY

1. Allow user to access error and frame counters through ethtool.

2. Allow user to set the master-slave configuration of ADIN1100.

3. Convert MSE to SQI using a predefined table and allow user access
through ethtool.

Alexandru Tachici (3):
  net: phy: adin1100: Add ethtool get_stats support
  net: phy: adin1100: Add ethtool master-slave support
  net: phy: adin1100: Add SQI support

 drivers/net/phy/Kconfig    |   7 +
 drivers/net/phy/Makefile   |   1 +
 drivers/net/phy/adin1100.c | 642 +++++++++++++++++++++++++++++++++++++
 3 files changed, 650 insertions(+)
 create mode 100644 drivers/net/phy/adin1100.c

--
2.25.1
