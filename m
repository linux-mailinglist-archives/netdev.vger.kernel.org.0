Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA1873A9B0A
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 14:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233040AbhFPMxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 08:53:44 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:16426 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232801AbhFPMxg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 08:53:36 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15GCkVuS009899;
        Wed, 16 Jun 2021 05:51:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=uaPGvCzpX+pLMz3hDsRnKZ8Ye+3r4/4H2VnQlWxIlpg=;
 b=Px5OezwtTtp8mUyG+KYel1r0zvz+j4kG8av2+yO0bfRrp0rKYh/USfui3hTflt3ShMoq
 n+///1Rykhh7ywf0zr1xde1WRg1I+jRFRE8xRGhnQ59nZcJfhUXpeVTh7sMvt7bCtkli
 3E+Ckz9GdAEt4hxpOny5y46/7qK3vOSrH+gP5MsTUF9p7cc1NX1hWwcqXhC/zNqnVNcZ
 FYKLvDeBnWFw9tnXhBjGRgWicHX+aA7bF34jAVMK39pYXo3wiwbv/F7ssQpTDiT6Lb4t
 y+zDtNl79hEgZAfCvGLGK/u+KteL5bDFrVBzP/slI8YMW18bvFfHlsb1FZcajswNy0+P yg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 397auvhkk8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 16 Jun 2021 05:51:29 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 16 Jun
 2021 05:51:28 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 16 Jun 2021 05:51:28 -0700
Received: from machine421.marvell.com (unknown [10.29.37.2])
        by maili.marvell.com (Postfix) with ESMTP id DE6FD3F704B;
        Wed, 16 Jun 2021 05:51:26 -0700 (PDT)
From:   <sgoutham@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH net-next 0/2] Support ethtool ntuple rule count change
Date:   Wed, 16 Jun 2021 18:21:20 +0530
Message-ID: <1623847882-16744-1-git-send-email-sgoutham@marvell.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: JNRWZhY8-PswfCISLoLgwmFd9zStR3j2
X-Proofpoint-GUID: JNRWZhY8-PswfCISLoLgwmFd9zStR3j2
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

