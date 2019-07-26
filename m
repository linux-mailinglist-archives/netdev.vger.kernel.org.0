Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5032176E4B
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 17:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727622AbfGZPwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 11:52:39 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:49880 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725970AbfGZPwj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 11:52:39 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x6QFpQAU029031;
        Fri, 26 Jul 2019 08:52:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=RwHDroHqsiV/jOAkOaK0V8crcBxifEvpbLdx2OH2/4w=;
 b=M+dTryn8mU6FwpMDAipCaeGRlIPMtCvlZ9lfBv1u2D3yZGMhS4zvD0Vh3f6lYmQWfQOH
 t4Ujq7Et0IQCMtjg3TajtbrFXu0IJ2krARkMNnyINWHsn95y9xPaZQw2EPXDixZpTnOM
 Y0abJjKgtmlazU8id1l3KTjOGuRnth+nz9q2/nbgs7IZR9RxFIE7DaiTKTq+GAPbYQYf
 MXJ0FnPvKEEzmiaGdKxk7mXDeGStqNNrqFQSaSupAzSAVNDKjDXdk962or4cW9Elk1m8
 kF77iQ1GVITRvIZJ9/gn8T6k4A0Q4vQ64kY2dRFIVaXtrQBd+zzTs8xBcEbkgwhBKs9T bw== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2tx61rqgu0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 26 Jul 2019 08:52:37 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 26 Jul
 2019 08:52:36 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Fri, 26 Jul 2019 08:52:36 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 8B72E3F703F;
        Fri, 26 Jul 2019 08:52:36 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x6QFqaFq025188;
        Fri, 26 Jul 2019 08:52:36 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x6QFqac5025187;
        Fri, 26 Jul 2019 08:52:36 -0700
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <mkalderon@marvell.com>,
        <aelior@marvell.com>
Subject: [PATCH net-next v2 0/2] qed*: Support for NVM config attributes.
Date:   Fri, 26 Jul 2019 08:52:13 -0700
Message-ID: <20190726155215.25151-1-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-07-26_11:2019-07-26,2019-07-26 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch series adds support for managing the NVM config attributes.
Patch (1) adds functionality to update config attributes via MFW.
Patch (2) adds driver interface for updating the config attributes.

Changes from previous versions:
-------------------------------
v2: Removed unused API.

Please consider applying this series to "net-next".

Sudarsana Reddy Kalluru (2):
  qed: Add API for configuring NVM attributes.
  qed: Add driver API for flashing the config attributes.

 drivers/net/ethernet/qlogic/qed/qed_hsi.h  | 17 ++++++++
 drivers/net/ethernet/qlogic/qed/qed_main.c | 65 ++++++++++++++++++++++++++++++
 drivers/net/ethernet/qlogic/qed/qed_mcp.c  | 35 ++++++++++++++++
 drivers/net/ethernet/qlogic/qed/qed_mcp.h  | 20 +++++++++
 include/linux/qed/qed_if.h                 |  1 +
 5 files changed, 138 insertions(+)

-- 
1.8.3.1

