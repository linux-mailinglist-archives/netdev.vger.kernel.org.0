Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 194691DA415
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 23:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbgESVvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 17:51:19 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:62832 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725998AbgESVvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 17:51:19 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04JLkbEc002277;
        Tue, 19 May 2020 14:51:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=QwKlIuDTGUKjgZWXtSzevk0/SstSLqQaANEuo/ns360=;
 b=WLmuMKIV5s0MMIsO5HLkeesJoOPPLF1iQDSMACwtR6kBzvF9+sEe6NtZGts22qbahUMy
 yKpPrWai8LhaZvBPZOUqioC/z+DvBi0QJyIkqKG7RRaD3U1exsCGI28W1lvcA9zTKdAK
 7BaUqPSerZHHdP3RVNnRw3tgMACXNmE9A0i202VeK0v26Hk0MPYkNTVDLZPZzlQn8pC2
 /NVJ32Om9wGvfng/mtFmEVCiNRTMKqTvH+YfGTTOPAHduAJlnx5nYZvklUY4kulWhuUw
 wykLroHeipl4Lsao+RmWQ8GLxp3jt5BjB3D1j4e+2ePW61c7rwS1IraC4xe7TxGxY3RA qg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 312fpp5hfg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 19 May 2020 14:51:17 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 19 May
 2020 14:51:15 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 19 May
 2020 14:51:14 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 19 May 2020 14:51:14 -0700
Received: from lb-tlvb-ybason.il.qlogic.org (unknown [10.5.221.176])
        by maili.marvell.com (Postfix) with ESMTP id 86EE73F7040;
        Tue, 19 May 2020 14:51:12 -0700 (PDT)
From:   Yuval Basson <ybason@marvell.com>
To:     <davem@davemloft.net>
CC:     <mkalderon@marvell.com>, <ybason@marvell.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH net-next,v2 0/2] qed: Add xrc core support for RoCE
Date:   Tue, 19 May 2020 23:51:24 +0300
Message-ID: <20200519205126.26987-1-ybason@marvell.com>
X-Mailer: git-send-email 2.14.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-19_10:2020-05-19,2020-05-19 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for configuring XRC and provides the necessary
APIs for rdma upper layer driver (qedr) to enable the XRC feature.

Yuval Bason (2):
  qed: changes to ILT to support XRC
  qed: Add XRC to RoCE

 drivers/net/ethernet/qlogic/qed/qed_cxt.c  |  60 ++++++++++--
 drivers/net/ethernet/qlogic/qed/qed_cxt.h  |  10 +-
 drivers/net/ethernet/qlogic/qed/qed_dev.c  |   6 +-
 drivers/net/ethernet/qlogic/qed/qed_rdma.c | 147 +++++++++++++++++++++++++----
 drivers/net/ethernet/qlogic/qed/qed_rdma.h |  19 ++++
 drivers/net/ethernet/qlogic/qed/qed_roce.c |  29 ++++++
 include/linux/qed/qed_rdma_if.h            |  19 ++++
 7 files changed, 258 insertions(+), 32 deletions(-)

-- 
1.8.3.1

