Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72B382576C0
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 11:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbgHaJog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 05:44:36 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:32922 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725915AbgHaJod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 05:44:33 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07V9NS6t014221;
        Mon, 31 Aug 2020 02:44:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=gLSp4GUtc3fKCYG3D8uO6JQlc3j7t56s1BXqW3SqV8c=;
 b=TWHReJ7O0RdTaHoaB4xFammL2YvSi45gmdnIufJ049udI/lPFM63kODhj8PTFg4OBnkN
 guMI4aoy26sIy4oylGKxAh0xpDq01QgufHn/RTEzzvieyKzMzNIwu24s5ez5PlOmW7RO
 t7/d4W73CEoMFoMe8bcmqBveL17FOaoU8u1lOkthCJxW8gccMIaL24A1uK6kYTCQuEMp
 FzhlBrpSs5ZDPTLnr78ItIsx3GS+X3Bh6T+TkUhyFSNbGjV9WfbjtlBWp4LvRz+L2Zbs
 +aQXJH0Rrhihg7Qy9QKzhehT4B9z4O7f7BcB/QHErGKOSbVBTA63GQ1poP4zJ7E65VLN 2g== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 337phprc49-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 31 Aug 2020 02:44:30 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 31 Aug
 2020 02:44:28 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 31 Aug
 2020 02:44:28 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 31 Aug 2020 02:44:29 -0700
Received: from NN-LT0065.marvell.com (NN-LT0065.marvell.com [10.193.39.17])
        by maili.marvell.com (Postfix) with ESMTP id 4E1773F703F;
        Mon, 31 Aug 2020 02:44:27 -0700 (PDT)
From:   Dmitry Bogdanov <dbogdanov@marvell.com>
To:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>
CC:     Dmitry Bogdanov <dbogdanov@marvell.com>
Subject: [PATCH v2 net 0/3] net: qed disable aRFS in NPAR and 100G
Date:   Mon, 31 Aug 2020 12:43:26 +0300
Message-ID: <cover.1597833340.git.dbogdanov@marvell.com>
X-Mailer: git-send-email 2.28.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-31_01:2020-08-31,2020-08-31 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset fixes some recent issues found by customers.

v2:
  correct hash in Fixes tag

Dmitry Bogdanov (3):
  net: qed: Disable aRFS for NPAR and 100G
  net: qede: Disable aRFS for NPAR and 100G
  qed: RDMA personality shouldn't fail VF load

 drivers/net/ethernet/qlogic/qed/qed_dev.c      | 11 ++++++++++-
 drivers/net/ethernet/qlogic/qed/qed_l2.c       |  3 +++
 drivers/net/ethernet/qlogic/qed/qed_main.c     |  2 ++
 drivers/net/ethernet/qlogic/qed/qed_sriov.c    |  1 +
 drivers/net/ethernet/qlogic/qede/qede_filter.c |  3 +++
 drivers/net/ethernet/qlogic/qede/qede_main.c   | 11 +++++------
 include/linux/qed/qed_if.h                     |  1 +
 7 files changed, 25 insertions(+), 7 deletions(-)

-- 
2.17.1

