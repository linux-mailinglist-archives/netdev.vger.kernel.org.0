Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0BC01B4602
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 15:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbgDVNNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 09:13:31 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:1870 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725968AbgDVNNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 09:13:31 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03MDC1Vj017701;
        Wed, 22 Apr 2020 06:13:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=YsNUrpaJLNM54Y3+d384BlF0i85vBPNn69/Y8s8NIKs=;
 b=gz6vyRSvMWQ4ywKHPU7jnwgUR84Ik6Ne6tMEObmk8XlU+IsTQxihlLliC0TTkN38hs5r
 pTr/qHc0UyAjadKBm+/i108z3SjLkO62KuIxAOI3c7UZ9lxtk66vDVR82vvBRaJmLxpM
 Msbc4sKP/MXZ6dTvzk3+Ch6KNoN94ZQE2GOhGQNeU6bFkNKT4m9rg0IUTSGCcwa2F+f6
 J40GUrj0pUQYHYDUSovWpTw+dCX8SV+L5a5eGenUfxBONE+a+JvPpyNjj3ataim+CCQH
 l7Ww/XDn8qeUNVAEN+Bu93RrhGhY7q6FvBaEsYZI2P2UbLXn9g4KDui31P6KyQ8XKB7u sA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 30fxwphjfb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 22 Apr 2020 06:13:30 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Apr
 2020 06:13:28 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 22 Apr 2020 06:13:29 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id CAC413F7085;
        Wed, 22 Apr 2020 06:13:25 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 03MDDPJ0007184;
        Wed, 22 Apr 2020 06:13:25 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 03MDDPSV007183;
        Wed, 22 Apr 2020 06:13:25 -0700
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <irusskikh@marvell.com>, <mkalderon@marvell.com>
Subject: [PATCH net-next 0/2] qed*: Add support for pcie advanced error recovery.
Date:   Wed, 22 Apr 2020 06:13:20 -0700
Message-ID: <20200422131322.7147-1-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-22_06:2020-04-22,2020-04-22 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch series adds qed/qede driver changes for PCIe Advanced Error
Recovery (AER) support.
Patch (1) adds qed changes to enable the device to send error messages
to root port when detected.
Patch (2) adds qede support for handling the detected errors (AERs).

Changes from previous version:
-------------------------------
v2: use pci_num_vf() instead of caching the value in edev.

Please consider applying this to "net-next".

Sudarsana Reddy Kalluru (2):
  qed: Enable device error reporting capability.
  qede: Add support for handling the pcie errors.

 drivers/net/ethernet/qlogic/qed/qed_main.c   |  9 ++++
 drivers/net/ethernet/qlogic/qede/qede.h      |  1 +
 drivers/net/ethernet/qlogic/qede/qede_main.c | 68 +++++++++++++++++++++++++++-
 3 files changed, 77 insertions(+), 1 deletion(-)

-- 
1.8.3.1

