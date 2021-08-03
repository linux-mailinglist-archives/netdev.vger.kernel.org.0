Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1167D3DE9DD
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 11:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235255AbhHCJmR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 05:42:17 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:47522 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234998AbhHCJmD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 05:42:03 -0400
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1739aVVX016754;
        Tue, 3 Aug 2021 05:39:26 -0400
Received: from nwd2mta3.analog.com ([137.71.173.56])
        by mx0a-00128a01.pphosted.com with ESMTP id 3a6ep8ufyk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Aug 2021 05:39:26 -0400
Received: from ASHBMBX9.ad.analog.com (ASHBMBX9.ad.analog.com [10.64.17.10])
        by nwd2mta3.analog.com (8.14.7/8.14.7) with ESMTP id 1739dPDO022658
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 3 Aug 2021 05:39:25 -0400
Received: from ASHBMBX8.ad.analog.com (10.64.17.5) by ASHBMBX9.ad.analog.com
 (10.64.17.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.858.5; Tue, 3 Aug 2021
 05:39:24 -0400
Received: from zeus.spd.analog.com (10.66.68.11) by ashbmbx8.ad.analog.com
 (10.64.17.5) with Microsoft SMTP Server id 15.2.858.5 via Frontend Transport;
 Tue, 3 Aug 2021 05:39:24 -0400
Received: from localhost.localdomain ([10.48.65.12])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 1739dJlM012491;
        Tue, 3 Aug 2021 05:39:20 -0400
From:   <alexandru.tachici@analog.com>
To:     <o.rempel@pengutronix.de>
CC:     <alexandru.tachici@analog.com>, <andrew@lunn.ch>,
        <davem@davemloft.net>, <devicetree@vger.kernel.org>,
        <hkallweit1@gmail.com>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux@armlinux.org.uk>,
        <netdev@vger.kernel.org>, <robh+dt@kernel.org>
Subject: Re: [PATCH v2 0/7] net: phy: adin1100: Add initial support for ADIN1100 industrial PHY
Date:   Tue, 3 Aug 2021 12:47:15 +0300
Message-ID: <20210803094715.9743-1-alexandru.tachici@analog.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210723173257.66g3epaszn7qwrvd@pengutronix.de>
References: <20210723173257.66g3epaszn7qwrvd@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-ADIRuleOP-NewSCL: Rule Triggered
X-Proofpoint-ORIG-GUID: neMO3aY1U-BMEwP254Cn9ExAY4juW0r1
X-Proofpoint-GUID: neMO3aY1U-BMEwP254Cn9ExAY4juW0r1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-03_02:2021-08-03,2021-08-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 spamscore=0 clxscore=1011 phishscore=0 mlxlogscore=718 adultscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108030065
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Managed to get some answears form the HW team.

From a safety perspective: in Explosive environments
only 1.0 V is allowed.

Tests showed that 1.0 V shows spurs around 200m and
2.4V works for up to 1.3 Km.

