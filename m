Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80BE143D04C
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 20:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243391AbhJ0SKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 14:10:51 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:56748 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230495AbhJ0SKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 14:10:50 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19RFH24O032380;
        Wed, 27 Oct 2021 11:08:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=XWITGMFb/jan4h4z6VWEZstJVv3zQOCDbuWtYBDyH9g=;
 b=cX05pS0eS2FtDDmw/nKdVILfUWesdZJuhgtG7P4KnUkCBwdyr47wV0cJXQwsLScM8GHj
 kpU+8Cc8pxLCkcraZPY48NxrXXbVpZWBzuwssn9j2qzLW6eagGH662ZsVaXq3ZgmKEAk
 nwwxmQekl1Bce/LK5FKwnhmuiDehK9qyr+tMr2+ST0FzPG79AS2e7k1GPgH99kGI9+mR
 fUgLqfFaslRo5WwHk56E2ii2uJ2cNc/ht71tXOiui+K6fPVkNSrndWN6xq/LOs6iLyMX
 bm42xn4yhfpzeEw3XxGHfMUHJcFOGM2YoHsJjAfCVF5PywJ5d9qU52/nzAB5r7wjBYS0 Tg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3by1caauqj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 27 Oct 2021 11:08:22 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 27 Oct
 2021 11:08:20 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 27 Oct 2021 11:08:20 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 9A5E43F706D;
        Wed, 27 Oct 2021 11:08:17 -0700 (PDT)
From:   Rakesh Babu Saladi <rsaladi2@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>,
        Rakesh Babu Saladi <rsaladi2@marvell.com>
Subject: [net-next PATCH v3 0/3] RVU Debugfs updates.
Date:   Wed, 27 Oct 2021 23:37:42 +0530
Message-ID: <20211027180745.27947-1-rsaladi2@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: nUfb4Yb76zq05P3w31v6darxyUHP0AtS
X-Proofpoint-ORIG-GUID: nUfb4Yb76zq05P3w31v6darxyUHP0AtS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-27_05,2021-10-26_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1: Few minor changes such as spelling mistakes, deleting unwanted
characters, etc.
Patch 2: Add debugfs dump for lmtst map table
Patch 3: Add channel and channel mask in debugfs.

Changes made from v2 to v3:
1. In patch 1 moved few lines and submitted those changes as a
different patch to net branch
2. Patch 2 is left unchanged.
3. Patch 3 is left unchanged.


Harman Kalra (1):
  octeontx2-af: cn10k: debugfs for dumping LMTST map table

Rakesh Babu (1):
  octeontx2-af: debugfs: Add channel and channel mask.

Rakesh Babu Saladi (1):
  octeontx2-af: debugfs: Minor changes.

 .../net/ethernet/marvell/octeontx2/af/npc.h   |   4 +
 .../marvell/octeontx2/af/rvu_debugfs.c        | 118 ++++++++++++++++--
 .../marvell/octeontx2/af/rvu_npc_fs.c         |   3 +
 3 files changed, 114 insertions(+), 11 deletions(-)

--
2.17.1
