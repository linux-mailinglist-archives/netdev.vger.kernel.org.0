Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB3043657CC
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 13:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231422AbhDTLox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 07:44:53 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:12066 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230491AbhDTLox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 07:44:53 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13KBb98E017565;
        Tue, 20 Apr 2021 04:44:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=C0ySn2RpAEOeWhM5f/IQDMVVTUcv7WGBP9G8GJkkq2Y=;
 b=K7toRMUEKh/JfDuQOMPO8/3upzAVjgYlgRVNDioNVx3aiU5wtUlxpYNsNd5Zufdl635M
 52IEOilKZwKSvsjp18J9jNFucJAVSSl8zOUTG7GxclrsrGyRNnez9F+AAckGhey/qSGJ
 /0mXw15O7RqcOvpxL318vyfULYf085FzeUy7TYhTJaAlRwYZ6ItjphZG5YKtDvSjo+u3
 eZDgrmPGpeuP997OvMkTqCYALc4u56e5VQCpGrKfc4quyuk5FtzJK4FSTNQQfNA4M9pL
 M5z6vS7vAwgMNEXwTnZPrauk5vDAsDpoI0fOKowzR4u/kAiAcL2Py7yiIjE26CcYESxc hg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3818tvum22-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 20 Apr 2021 04:44:16 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 20 Apr
 2021 04:44:13 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 20 Apr 2021 04:44:13 -0700
Received: from hyd1schalla-dt.caveonetworks.com.com (unknown [10.29.8.39])
        by maili.marvell.com (Postfix) with ESMTP id D3ECE3F7045;
        Tue, 20 Apr 2021 04:44:09 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <pathreya@marvell.com>, "Srujana Challa" <schalla@marvell.com>
Subject: [PATCH net-next 0/3] Add support for CN10K CPT block
Date:   Tue, 20 Apr 2021 17:13:46 +0530
Message-ID: <20210420114349.22640-1-schalla@marvell.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: qbNw0zUgr95QUKNT4Fvnylf5dVYn7Ol8
X-Proofpoint-ORIG-GUID: qbNw0zUgr95QUKNT4Fvnylf5dVYn7Ol8
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-20_02:2021-04-19,2021-04-20 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

OcteonTX3 (CN10K) silicon is a Marvell next-gen silicon. CN10K CPT
introduces new features like reassembly support and some feature
enhancements.
This patchset adds new mailbox messages and some minor changes to
existing mailbox messages to support CN10K CPT.

Srujana Challa (3):
  octeontx2-af: cn10k: Mailbox changes for CN10K CPT
  octeontx2-af: cn10k: Add mailbox to configure reassembly timeout
  octeontx2-af: Add mailbox for CPT stats

 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  61 ++++++
 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   | 191 +++++++++++++++++-
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |  21 ++
 3 files changed, 265 insertions(+), 8 deletions(-)

-- 
2.29.0

