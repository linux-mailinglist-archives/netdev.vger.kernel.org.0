Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2F5EF528
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 06:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387521AbfKEFwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 00:52:08 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:12170 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387504AbfKEFwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 00:52:08 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA55noBY019326;
        Mon, 4 Nov 2019 21:52:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=MY2juLgBtQDsrhQsqWV4sNEHaFkAlP1jBUA99PoRXIM=;
 b=HLi7XBPruPQN6OOuox/7aNxiEZjkOG1pBMHqr0tQQJzBhhjJ/AcpA7LFoZ1yoBaRb10P
 thJALrDMscf+c8t5Bk9erL2tGOP+N52bYz5COt583K4ypDut8x9tZBNy5e2yuTi8sTEk
 LiZ5RPS+jaJtLT+iPRUkaDlrJ44rNOM84qRV1xvp9quW416P/uFJmYPJKTHPqzqkLGjl
 mZq34hXiZqvZlDO2W/ZuTDwX189XjI5CLGeZ3pw6r8VanNdjXvsSM44pQEHTlTAAzD1I
 1eh9gxM/XeliLH3C0WodlPWd6JjXPLxYR5j9ftSed3MwJVgUHm4eWHKnJDc40Eo+NLiA mA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2w17n91eq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 04 Nov 2019 21:52:05 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Mon, 4 Nov
 2019 21:52:04 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Mon, 4 Nov 2019 21:52:04 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 3B0BC3F7043;
        Mon,  4 Nov 2019 21:52:04 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id xA55q4To030050;
        Mon, 4 Nov 2019 21:52:04 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id xA55q3Cg030049;
        Mon, 4 Nov 2019 21:52:03 -0800
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <manishc@marvell.com>,
        <mrangankar@marvell.com>, <mkalderon@marvell.com>,
        <aelior@marvell.com>
Subject: [PATCH net-next 0/4] bnx2x/cnic: Enable Multi-Cos.
Date:   Mon, 4 Nov 2019 21:51:08 -0800
Message-ID: <20191105055112.30005-1-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-11-05_01:2019-11-04,2019-11-05 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch series enables Multi-cos feature in the driver. This require
the use of new firmware 7.13.15.0.
Patch (1) adds driver changes to use new FW.
Patches (2) - (3) enables multi-cos functionality in bnx2x driver.
Patch (4) adds cnic driver change as required by new FW.

Manish Chopra (1):
  bnx2x: Fix PF-VF communication over multi-cos queues.

Manish Rangankar (1):
  cnic: Set fp_hsi_ver as part of CLIENT_SETUP ramrod

Sudarsana Reddy Kalluru (2):
  bnx2x: Utilize FW 7.13.15.0.
  bnx2x: Enable Multi-Cos feature.

 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |   3 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_fw_defs.h    | 132 ++++++++++-----------
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_hsi.h    |   2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c  |  16 ++-
 drivers/net/ethernet/broadcom/cnic.c               |   2 +
 5 files changed, 82 insertions(+), 73 deletions(-)

-- 
1.8.3.1

