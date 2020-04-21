Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44BDC1B2A94
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 17:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729038AbgDUPAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 11:00:30 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:5084 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726691AbgDUPA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 11:00:29 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03LEtdPA022819;
        Tue, 21 Apr 2020 08:00:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=gVGdFuDtXWVvrhYgwk22D1x1+ZiklgcaTckYHRh4214=;
 b=fk1+RaN/1KZtbLv+CGYX21dr/UELUJESRO/mMm+9ZgbPm4iHxd6zKtQKORFopHOPPq3d
 JwVnSdhnxhEmCBCk7bB7SFCfi2yj+nGLY6Xxyo+2D8oofRwq2P2boaNtB/CA44Ojk/ga
 WlM36E4XLg1E0OeLBzfJj3Dr32rezHzfhfksM7k/h5nmPFJctJuxeeOVZg9tjRTlm/ZY
 K66Ta5sR+awAWEGq9s8C/bsc+q17B55PlaQrHa5CBYn9sw2jjisdVx6EQBOftarEeqF9
 /CZ+21lQSk30Hzw+N2J4CNH+yl05NspfD11K52s776vA5NrwQuS8o/xXxEgJM90N81u6 XQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 30fxwpcqua-17
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 21 Apr 2020 08:00:27 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 21 Apr
 2020 07:53:26 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 21 Apr 2020 07:53:26 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 86A903F703F;
        Tue, 21 Apr 2020 07:53:26 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 03LErQgC016323;
        Tue, 21 Apr 2020 07:53:26 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 03LEr7Hw016314;
        Tue, 21 Apr 2020 07:53:07 -0700
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <irusskikh@marvell.com>, <mkalderon@marvell.com>
Subject: [PATCH net-next 0/3] qed*: Add support for pcie advanced error recovery.
Date:   Tue, 21 Apr 2020 07:52:57 -0700
Message-ID: <20200421145300.16278-1-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-21_05:2020-04-20,2020-04-21 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch series add qed/qede driver support for PCIe Advanced Error
Recovery (AER) support.
Patch (1) adds qed changes to enable device to send the error messages to
root port when detected.
Patch (2) adds changes to cache the VF count for a given PF.
Patch (3) adds qede support for handling the detected errors (AERs).

Sudarsana Reddy Kalluru (3):
  qed: Enable device error reporting capability.
  qede: Cache num configured VFs on a PF.
  qede: Add support for handling the pcie errors.

 drivers/net/ethernet/qlogic/qed/qed_main.c   |  9 +++
 drivers/net/ethernet/qlogic/qede/qede.h      |  2 +
 drivers/net/ethernet/qlogic/qede/qede_main.c | 83 +++++++++++++++++++++++++---
 3 files changed, 87 insertions(+), 7 deletions(-)

-- 
1.8.3.1

