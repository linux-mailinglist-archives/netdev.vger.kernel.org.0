Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D28F24D487
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 13:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728582AbgHULzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 07:55:49 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:49032 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727964AbgHULvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 07:51:45 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07LBo8LO020886;
        Fri, 21 Aug 2020 04:51:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=gLSp4GUtc3fKCYG3D8uO6JQlc3j7t56s1BXqW3SqV8c=;
 b=ZAUm2bs6A/C0HzxcidSbHQ5MPf9T0CUvMu8nGmn2nZQycLZaO/HEMGZ85a1fxYpJxpWA
 5YV26Lx0xhV++us5Hzc6f6PDhxFvN55fkIgp3pNhrW10yz8jN+ExJG5tXoPvsDYNohww
 xx7wJjTR9a8blsW9kASByihwrBH0R5EP+XQQGm6pHrH1jkjwpkoNVRlY78G2b9KnIXxI
 bhUxCSFu8E8je6q8+15AXCLVQ4ra2wVLpvf8nXR1wqmz+cIwUJhRxk0XzFFl9UfefJ8L
 caZvFNnI4h0g73Zvmbf8L/2G+jItVD2ReJ+jHFDotfxFMw4cc0bHthFYpRW2B1Mxdlkk DA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3304fj2e3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 21 Aug 2020 04:51:44 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 21 Aug
 2020 04:51:43 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 21 Aug
 2020 04:51:42 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 21 Aug 2020 04:51:43 -0700
Received: from NN-LT0065.marvell.com (NN-LT0065.marvell.com [10.193.54.69])
        by maili.marvell.com (Postfix) with ESMTP id 909703F7043;
        Fri, 21 Aug 2020 04:51:41 -0700 (PDT)
From:   Dmitry Bogdanov <dbogdanov@marvell.com>
To:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>
CC:     Dmitry Bogdanov <dbogdanov@marvell.com>
Subject: [PATCH v2, net 0/3] net: qed disable aRFS in NPAR and 100G
Date:   Fri, 21 Aug 2020 14:51:33 +0300
Message-ID: <cover.1597833340.git.dbogdanov@marvell.com>
X-Mailer: git-send-email 2.28.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-21_06:2020-08-21,2020-08-21 signatures=0
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

