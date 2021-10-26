Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62B7C43B229
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 14:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234359AbhJZMU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 08:20:59 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:12122 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230409AbhJZMU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 08:20:58 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19Q5oMbg012626;
        Tue, 26 Oct 2021 05:18:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=BLVkkPZnWnYH6M5kkSOIKuxI4SIsnFSU2qUzofv1grE=;
 b=XYQGGFO57OVcYbKJg2CQ6Ilj3doW1/UORkrgQr999PuS7T3CSLXl6M/5FJ7R1sPS+ig6
 KMvyu1BcbrOC9sGNlS7+TzxkmXocbUFhQTBUTO8X2wUFmFiJ+pa7D7aZQvtqlx3lQOd1
 /meMcy4Gq1m2//++03oo9yDZHpXbrnv0TXlwT1N/ok79knwhIiWGHbGSaQDWaFI8Qj1B
 YyaMTEVNgSiZq8qUulrxqKgSY1XWiGvpQC7oZFbPEwRZjaYFL2dSm1u+fnb+2f5AI9+W
 Og9OOP0Mhwf6+1AGkuHhcKHL5MiZYPxuK0cLUj2nhVOtkqq/rpMxmV2vqNCuIgjBCC8R Qw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3bx4dx2yf8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 26 Oct 2021 05:18:31 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 26 Oct
 2021 05:18:29 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 26 Oct 2021 05:18:29 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 14F993F7065;
        Tue, 26 Oct 2021 05:18:26 -0700 (PDT)
From:   Rakesh Babu <rsaladi2@marvell.com>
To:     <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Rakesh Babu <rsaladi2@marvell.com>
Subject: [net-next PATCH v2 0/3] RVU Debugfs updates.
Date:   Tue, 26 Oct 2021 17:48:11 +0530
Message-ID: <20211026121814.27036-1-rsaladi2@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: eh2snDw4d3Zp4d281tG5KLuJ07lyTZZU
X-Proofpoint-ORIG-GUID: eh2snDw4d3Zp4d281tG5KLuJ07lyTZZU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-26_02,2021-10-26_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following patch series consists of the changes/modifications that are
newly added/done to rvu_debugfs.c file.

Patch 1: Few minor changes such as spelling mistakes, deleting unwanted
characters, etc.
Patch 2: Add debugfs dump for lmtst map table
Patch 3: Add channel and channel mask in debugfs.

Changes made from v1 to v2
1. In patch 1 removed unnecessary change, updated commit message.
2. In patch 2 updated commit message explaining about what is LMTST map
table.
3. Patch 3 is left unchanged.

Harman Kalra (1):
  octeontx2-af: cn10k: debugfs for dumping LMTST map table

Rakesh Babu (2):
  octeontx2-af: debugfs: Minor changes.
  octeontx2-af: debugfs: Add channel and channel mask.

 .../net/ethernet/marvell/octeontx2/af/npc.h   |   4 +
 .../marvell/octeontx2/af/rvu_debugfs.c        | 120 ++++++++++++++++--
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |   3 +
 .../marvell/octeontx2/af/rvu_npc_fs.c         |   3 +
 4 files changed, 118 insertions(+), 12 deletions(-)

--
2.17.1
