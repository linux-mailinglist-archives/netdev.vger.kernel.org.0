Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65603439F20
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 21:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233909AbhJYTRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 15:17:32 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:47896 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233951AbhJYTR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 15:17:29 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19PFngSI024462;
        Mon, 25 Oct 2021 12:15:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=sT1dbt5fGFGl/R3R0rBdl6d5cXHq7Xaf6xcVEBNnxpY=;
 b=DbkxlhVdFkJHsmFvJMMTCUkgOqZVrs39j3Ogc8PaZCRkge5MnqbLNaO/C2cBCFQHQ2FX
 0YTgZrr3b6U6QnXyFJsW8cio28C8wWPj4xQnrFcg1pVaSBhWONdvSDuNhX6QDjY+m18r
 aO7ICEyzfqaEhiY5vITj7Xu/stcQN66+Y545EwTzhLGXNWVvXm1dRE7AGZIsBfFyxSfT
 g+Ma5KG9TFGtI0e827qiA+mX8LaCtmzRr6P/oqy3gVSj8t16ak4c6r+bpZxicPXjUlWy
 BpjMz3d8URlGNVUe2g+LUw2hdag52OvJKfuvjLFQVq4aTb6XeEa94L6NexypxB3jqtDB VQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3bwyjg8ts2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 12:15:02 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 25 Oct
 2021 12:14:51 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 25 Oct 2021 12:14:51 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id BC65F3F7041;
        Mon, 25 Oct 2021 12:14:48 -0700 (PDT)
From:   Rakesh Babu <rsaladi2@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <sgoutham@marvell.com>,
        <gakula@marvell.com>, <sbhatta@marvell.com>, <hkelam@marvell.com>
CC:     Rakesh Babu <rsaladi2@marvell.com>
Subject: [net-next PATCH 0/3] RVU Debugfs updates.
Date:   Tue, 26 Oct 2021 00:44:39 +0530
Message-ID: <20211025191442.10084-1-rsaladi2@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 9_NOO5ryLvNNXuz6_DSifjsp8SIuYi4F
X-Proofpoint-GUID: 9_NOO5ryLvNNXuz6_DSifjsp8SIuYi4F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-25_06,2021-10-25_02,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following patch series consists of the changes/modifications that are
newly added/done to rvu_debugfs.c file.

Patch 1: Few minor changes such as spelling mistakes, deleting unwanted
characters, etc.
Patch 2: Add debugfs dump for lmtst map table
Patch 3: Add channel and channel mask in debugfs.

Harman Kalra (1):
  octeontx2-af: cn10k: debugfs for dumping lmtst map table

Rakesh Babu (2):
  octeontx2-af: debugfs: Minor changes.
  octeontx2-af: debugfs: Add channel and channel mask.

 .../net/ethernet/marvell/octeontx2/af/npc.h   |   4 +
 .../marvell/octeontx2/af/rvu_debugfs.c        | 122 ++++++++++++++++--
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |   3 +
 .../marvell/octeontx2/af/rvu_npc_fs.c         |   3 +
 4 files changed, 119 insertions(+), 13 deletions(-)

--
2.17.1
