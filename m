Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 663501D8B91
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 01:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbgERXUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 19:20:53 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:35910 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726481AbgERXUx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 19:20:53 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04INKEDK031137;
        Mon, 18 May 2020 16:20:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=c70JrSlM28Ph05AJdEpRgX4NdeLwUSa2V/BTucVsKR8=;
 b=MyF30c/j+Th8LPmiGsnxi/qFVJoo78/oT76DGcKcgzALQxM1v87bWWJgNiFIxs53cgO/
 eFO0j5gdEN+vhfflOKC42yG85o/ebb9n24ZxG2syBFE1asVZUlzIfmgtPFzqGAI50t+5
 kAhblH0uR4XVdw+2sNtIdBVI4QdxGypRXHtprIw3eiqlr2QcKLWPgq2kGmLardOuvDlz
 pnbaSdQj5FPT4IWcmTMuATIj5WjVzeAk9c2yuRgSzeuhlWNEmw86vLRSUMhUYodGLsbT
 kSlHl3NOVvyMkl4dorE96dF+jIqxp7hDM5Mpp1wRY2eaz9TEsdahWlWOyJ/ZgcV+xTx8 DQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 312dhqhh46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 18 May 2020 16:20:49 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 18 May
 2020 16:20:48 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 18 May
 2020 16:20:47 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 18 May 2020 16:20:47 -0700
Received: from lb-tlvb-ybason.il.qlogic.org (unknown [10.5.221.176])
        by maili.marvell.com (Postfix) with ESMTP id EEC323F703F;
        Mon, 18 May 2020 16:20:46 -0700 (PDT)
From:   Yuval Basson <ybason@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
Subject: [PATCH net-next 0/2] qed: Add xrc core support for RoCE
Date:   Tue, 19 May 2020 01:20:58 +0300
Message-ID: <20200518222100.30306-1-ybason@marvell.com>
X-Mailer: git-send-email 2.14.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-18_06:2020-05-15,2020-05-18 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for configuring XRC and provides the necessary
APIs for rdma upper layer driver (qedr) to enable the XRC feature.

Yuval Bason (2):
  qed: changes to ILT to support XRC.
  qed: Add XRC to RoCE.

 drivers/net/ethernet/qlogic/qed/qed_cxt.c  |  62 +++++++++++--
 drivers/net/ethernet/qlogic/qed/qed_cxt.h  |  10 ++-
 drivers/net/ethernet/qlogic/qed/qed_dev.c  |   6 +-
 drivers/net/ethernet/qlogic/qed/qed_rdma.c | 135 +++++++++++++++++++++++++----
 drivers/net/ethernet/qlogic/qed/qed_rdma.h |  19 ++++
 drivers/net/ethernet/qlogic/qed/qed_roce.c |  29 +++++++
 include/linux/qed/qed_rdma_if.h            |  19 ++++
 7 files changed, 251 insertions(+), 29 deletions(-)

-- 
1.8.3.1

