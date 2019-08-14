Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE7C88CDCB
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 10:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727507AbfHNIMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 04:12:07 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:59856 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727425AbfHNIMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 04:12:05 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7E89rYG018795;
        Wed, 14 Aug 2019 01:12:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=qcmFFk51+p86KuqhfNzPbYYD6FeS5CIgBsK+gtvFbgA=;
 b=kMmG5wZFomnt6dropdDPAviMmk5pitM9sGH1I1TWJQ5qq4Wvk6XJNUN+jMiZjLTQmNSV
 Eys4TiBNvFn1pf8J33OgqKFOvGeHgUDHOfwZAqr5hcl4snMI7SBax91KO+YO1yHcmHIh
 mijw6ItQryb7mLz/29sMXLWq9RrBsxkVAGBDSxyUKDMduVKCGNbyTpkYeQn6ziW1lMed
 5laIXY8ym1xVNqhxqslyjwe5eTHNOnInOcRyeYrvuDm0bV4Mvssll9TKOJTdmFHhn8qB
 2002N8n8AE5l7e9JSSkdJIKmdY4qs7pU5BqnblK70taryoZdm/eD+nhkdg3zmjLWZog7 5w== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2ubfabe7sy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 14 Aug 2019 01:12:02 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 14 Aug
 2019 01:12:00 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Wed, 14 Aug 2019 01:12:00 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id C58693F703F;
        Wed, 14 Aug 2019 01:12:00 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x7E8C0CI018934;
        Wed, 14 Aug 2019 01:12:00 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x7E8C0hs018933;
        Wed, 14 Aug 2019 01:12:00 -0700
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <mkalderon@marvell.com>,
        <aelior@marvell.com>
Subject: [PATCH net-next v4 0/2] qed*: Support for NVM config attributes.
Date:   Wed, 14 Aug 2019 01:11:51 -0700
Message-ID: <20190814081153.18889-1-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-08-14_03:2019-08-13,2019-08-14 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch series adds support for managing the NVM config attributes.
Patch (1) adds functionality to update config attributes via MFW.
Patch (2) adds driver interface for updating the config attributes.

Changes from previous versions:
-------------------------------
v4: Added more details on the functionality and its usage.
v3: Removed unused variable.
v2: Removed unused API.

Please consider applying this series to "net-next".


Sudarsana Reddy Kalluru (2):
  qed: Add API for configuring NVM attributes.
  qed: Add driver API for flashing the config attributes.

 drivers/net/ethernet/qlogic/qed/qed_hsi.h  | 17 ++++++++
 drivers/net/ethernet/qlogic/qed/qed_main.c | 68 ++++++++++++++++++++++++++++++
 drivers/net/ethernet/qlogic/qed/qed_mcp.c  | 32 ++++++++++++++
 drivers/net/ethernet/qlogic/qed/qed_mcp.h  | 20 +++++++++
 include/linux/qed/qed_if.h                 |  1 +
 5 files changed, 138 insertions(+)

-- 
1.8.3.1

