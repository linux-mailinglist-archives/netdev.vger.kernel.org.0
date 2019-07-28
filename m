Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59C8477D27
	for <lists+netdev@lfdr.de>; Sun, 28 Jul 2019 03:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729085AbfG1B4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 21:56:01 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:17076 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726357AbfG1B4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 21:56:00 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x6S1tvT5000670;
        Sat, 27 Jul 2019 18:55:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=p7TI9uUOvvyAEDKuuQ/JqEEP1hAtZO7UQS18lSNLSrQ=;
 b=RVbZHt8WJJDfCBABRNWaxi14vpIwGyGLjdlyyi94WLbOCxR0par++/ksQx1OJlId/Ejy
 B9ebblA2yHB+HKAdb1qzdV/boUToFCkhIC1mbS5fuv+4WRKkVI6PPbLFhxD3RgEKSRWq
 ZZ9KnKU61fMJHw9onSW544URayC2qkJvWu9tZTqVOmklgATdRwH6wtqM+ZldV6MRTytU
 p1z08eHAHNOt9cqc0SiOTbzR5nQWf4OwIivrq+l6ZEtRmdTmBKGnFngj4QavLospeghk
 xWLoQOSdXcsdhDGjdzVsX9R6rhLxUXKL0p12h12l95hE/qvE6kJQWNqHUsUygG09nLFR 6g== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2u0kyptk28-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 27 Jul 2019 18:55:57 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Sat, 27 Jul
 2019 18:55:57 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Sat, 27 Jul 2019 18:55:57 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id D90AD3F703F;
        Sat, 27 Jul 2019 18:55:56 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x6S1tqvZ027088;
        Sat, 27 Jul 2019 18:55:52 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x6S1tprr027087;
        Sat, 27 Jul 2019 18:55:51 -0700
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <mkalderon@marvell.com>,
        <aelior@marvell.com>
Subject: [PATCH net-next v3 0/2] qed*: Support for NVM config attributes.
Date:   Sat, 27 Jul 2019 18:55:47 -0700
Message-ID: <20190728015549.27051-1-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-07-27_18:2019-07-26,2019-07-27 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch series adds support for managing the NVM config attributes.
Patch (1) adds functionality to update config attributes via MFW.
Patch (2) adds driver interface for updating the config attributes.

Changes from previous versions:
-------------------------------
v3: Removed unused variable.
v2: Removed unused API.

Please consider applying this series to "net-next".

Sudarsana Reddy Kalluru (2):
  qed: Add API for configuring NVM attributes.
  qed: Add driver API for flashing the config attributes.

 drivers/net/ethernet/qlogic/qed/qed_hsi.h  | 17 ++++++++
 drivers/net/ethernet/qlogic/qed/qed_main.c | 65 ++++++++++++++++++++++++++++++
 drivers/net/ethernet/qlogic/qed/qed_mcp.c  | 32 +++++++++++++++
 drivers/net/ethernet/qlogic/qed/qed_mcp.h  | 20 +++++++++
 include/linux/qed/qed_if.h                 |  1 +
 5 files changed, 135 insertions(+)

-- 
1.8.3.1

