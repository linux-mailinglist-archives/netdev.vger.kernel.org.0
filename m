Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00D102F74E3
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 10:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727763AbhAOJHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 04:07:09 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:58858 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727036AbhAOJHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 04:07:07 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10F8xcIu013563;
        Fri, 15 Jan 2021 01:06:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=gAAeTVrxARquCkyO6ilRB8w39L8xFpomVcWcyRa3SLo=;
 b=Ledi0fptdzSNLo1AqU5QJJuB/vQF1Ht3aS1htz2SuIy6rwDGRx/5Ucl373kuKTV1hR+b
 yGu22/+MVTgZx3rvBtOl6Dw+vwHVG5qFdDDba64Li7HAMR+4OhyfuJb84uPIgAl8LBfE
 2wE+5nbSlOe8oWbQTCq7qJdoaCewXNg/Nnl9CEIoUs617TDf2CEkSE+hdciQYdS/hPlB
 EBxNLDOdKZlkL5eZffMqVuV6Oog9Q8lrOMWh9CLFJ/xP/lDmKyoTQ5jHsCNJLIYj5fq5
 XIqS9I9ZdpeoNIPiH4Ldzj89TbX9kVBe1Vk50wbS5mA6xEnFy38lFs58482E4tNU39wr 6Q== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 35ycvq2311-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 01:06:24 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 15 Jan
 2021 01:06:22 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 15 Jan
 2021 01:06:22 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 15 Jan 2021 01:06:22 -0800
Received: from dc5-eodlnx05.marvell.com (dc5-eodlnx05.marvell.com [10.69.113.147])
        by maili.marvell.com (Postfix) with ESMTP id 3EF583F703F;
        Fri, 15 Jan 2021 01:06:22 -0800 (PST)
From:   Bhaskar Upadhaya <bupadhaya@marvell.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <aelior@marvell.com>,
        <irusskikh@marvell.com>
CC:     <bupadhaya@marvell.com>
Subject: [PATCH net-next 0/3] qede: add netpoll and per-queue coalesce support
Date:   Fri, 15 Jan 2021 01:06:07 -0800
Message-ID: <1610701570-29496-1-git-send-email-bupadhaya@marvell.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-15_06:2021-01-15,2021-01-15 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1: Add net poll controller support to transmit kernel printks
         over UDP.
Patch 2: QLogic card support multiple queues and each queue can be
         configured with respective coalescing parameters, this patch
         add per queue rx-usecs, tx-usecs coalescing parameters.
Patch 3: set default per queue rx-usecs, tx-usecs coalescing parameters.

Bhaskar Upadhaya (3):
  qede: add netpoll support for qede driver
  qede: add per queue coalesce support for qede driver
  qede: set default per queue rx/tx usecs coalescing parameters

 drivers/net/ethernet/qlogic/qede/qede.h       |   5 +
 .../net/ethernet/qlogic/qede/qede_ethtool.c   | 126 +++++++++++++++++-
 drivers/net/ethernet/qlogic/qede/qede_fp.c    |  14 ++
 drivers/net/ethernet/qlogic/qede/qede_main.c  |   7 +
 4 files changed, 150 insertions(+), 2 deletions(-)

-- 
2.17.1

