Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E70F3A9B08
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 14:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232854AbhFPMxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 08:53:23 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:7068 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233008AbhFPMxV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 08:53:21 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15GCkP23011169;
        Wed, 16 Jun 2021 05:51:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=uaPGvCzpX+pLMz3hDsRnKZ8Ye+3r4/4H2VnQlWxIlpg=;
 b=Vot14To5Ln3QTE1YfWQQrgmeB4PPQq6wB3kymH+eU6CYZFVlbSRQCs2ZMU30lwyFdTF7
 BD57CZejrAruocAMqTZ+p9sVSDqVorHWCsIBj3XVaDlnwuQYbvIo3lHi9qEHdJPsQL01
 HtLuc7Ggh7hFdOiJ+xZJAJOa1u4Y34Ki/DiyI6oeMZRmwvCnBRAi2JXe1FuSJVG1A5Dc
 uNVN0xovsLq2DTDIy7l1RbWOz6pwR7fFSaGogc5NHunV5AzuXuGPrAN2x3S3fy2SavE3
 EVbB5Vw464ThBq2K04mCyY7Rq1dU5maHeKHxb7aBnbeswxh1gs/Gr3/Hp8sZq5a/hpOY 3w== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 396tagxbm8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 16 Jun 2021 05:51:13 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 16 Jun
 2021 05:51:11 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 16 Jun 2021 05:51:11 -0700
Received: from machine421.marvell.com (unknown [10.29.37.2])
        by maili.marvell.com (Postfix) with ESMTP id D54F43F704B;
        Wed, 16 Jun 2021 05:51:09 -0700 (PDT)
From:   <sgoutham@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH net-next 0/2] Support ethtool ntuple rule count change
Date:   Wed, 16 Jun 2021 18:19:36 +0530
Message-ID: <1623847776-16700-1-git-send-email-sgoutham@marvell.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 2W5cEeS3Q0o2Q2n72QZ6vSQpbzUlPwaK
X-Proofpoint-GUID: 2W5cEeS3Q0o2Q2n72QZ6vSQpbzUlPwaK
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-16_07:2021-06-15,2021-06-16 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

Some NICs share resources like packet filters across
multiple interfaces they support. From HW point of view
it is possible to use all filters for a single interface.
This 2 patch series adds support to modify ntuple rule
count for OcteonTx2 netdev.

Sunil Goutham (2):
  net: ethtool: Support setting ntuple rule count
  octeontx2-pf: Support setting ntuple rule count

 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  1 +
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |  3 +++
 .../ethernet/marvell/octeontx2/nic/otx2_flows.c    | 27 ++++++++++++++++++++--
 include/uapi/linux/ethtool.h                       |  1 +
 net/ethtool/ioctl.c                                |  1 +
 5 files changed, 31 insertions(+), 2 deletions(-)

-- 
2.7.4

