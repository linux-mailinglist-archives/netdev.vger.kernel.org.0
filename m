Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D699461670
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 14:31:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244013AbhK2Nev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 08:34:51 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:27186 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233361AbhK2Ncv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 08:32:51 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AT7ZQv4009078;
        Mon, 29 Nov 2021 05:29:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=bARXr7ssMiW/0HA27ND4Jl6UxNoEhnV5PzaIXe0om7s=;
 b=E2LxXtLbWGOc/7yNsBuN+Ew/7OJhQY9A2zTH1+ZXlG4zPd8jOffDedwBqMh5+1y1v7QX
 AecptVqo4t1oCZTNzL9lnY9Do12gvtYXDaTrpfquGY/rg3Zc87/RgEJF9aBd0U+J3QnN
 BGRvEQJbF8qyTTEABrggDX5HKp1KLgNa3KUyn57DpDCT48HnpuGWTkaU84vGfo6rDXmg
 B8Rvhp6vqhv3in/UUW0Kp3lrN/RAK+lC+YT2D1ZM1oQg2ObTRMs9lyXd8ZJ9JSqfMde3
 o0kWdCgTQciERrU7fW5yS+5CtLKq34MtWTc6a1wdPAsrsfsvxOUABtJVmv5rEPTPw9/w 1Q== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3cmtkph499-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 29 Nov 2021 05:29:31 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 29 Nov
 2021 05:29:29 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 29 Nov 2021 05:29:29 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 3CFB43F70B4;
        Mon, 29 Nov 2021 05:29:29 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 1ATDTElm016084;
        Mon, 29 Nov 2021 05:29:14 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 1ATDSwOc016083;
        Mon, 29 Nov 2021 05:28:58 -0800
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <irusskikh@marvell.com>,
        <dbezrukov@marvell.com>
Subject: [PATCH net 0/7] net: atlantic: 11-2021 fixes
Date:   Mon, 29 Nov 2021 05:28:22 -0800
Message-ID: <20211129132829.16038-1-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: J1ODUwoIgbcVruqaue1b_9UCOI7YCU1V
X-Proofpoint-ORIG-GUID: J1ODUwoIgbcVruqaue1b_9UCOI7YCU1V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-29_08,2021-11-28_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch series contains fixes for atlantic driver to improve support
of latest AQC113 chipset.

Please consider applying it to 'net' tree.

Dmitry Bogdanov (2):
  atlantic: Increase delay for fw transactions
  atlantic: Fix statistics logic for production hardware

Nikita Danilov (2):
  atlatnic: enable Nbase-t speeds with base-t
  atlantic: Add missing DIDs and fix 115c.

Sameer Saurabh (3):
  atlantic: Fix to display FW bundle version instead of FW mac version.
  Remove Half duplex mode speed capabilities.
  atlantic: Remove warn trace message.

 .../ethernet/aquantia/atlantic/aq_common.h    |  27 ++---
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |   2 +
 .../net/ethernet/aquantia/atlantic/aq_nic.c   |  10 +-
 .../ethernet/aquantia/atlantic/aq_pci_func.c  |   7 +-
 .../net/ethernet/aquantia/atlantic/aq_vec.c   |   3 -
 .../aquantia/atlantic/hw_atl/hw_atl_utils.c   |  15 ++-
 .../atlantic/hw_atl/hw_atl_utils_fw2x.c       |   3 -
 .../aquantia/atlantic/hw_atl2/hw_atl2.c       |  22 +++-
 .../aquantia/atlantic/hw_atl2/hw_atl2.h       |   2 +
 .../aquantia/atlantic/hw_atl2/hw_atl2_utils.h |  38 +++++-
 .../atlantic/hw_atl2/hw_atl2_utils_fw.c       | 110 ++++++++++++++----
 11 files changed, 184 insertions(+), 55 deletions(-)

-- 
2.27.0

