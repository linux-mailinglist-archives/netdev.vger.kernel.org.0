Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A560524B824
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 13:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728997AbgHTLKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 07:10:21 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:5838 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729769AbgHTLJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 07:09:07 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07KB6vmB005005;
        Thu, 20 Aug 2020 04:09:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=gLSp4GUtc3fKCYG3D8uO6JQlc3j7t56s1BXqW3SqV8c=;
 b=cDEAH5ilIufSWgIFywegA5NfT/3BPVSA5AyJCKuSXCWHYIC7rU95i7aUAiK7FKVVx9qE
 OxKo8FstPIJ92o+ASstPn+j+VZgfnl8GK3EEfkcg6YSQMLdWbSf2BJmPjxTK9AqP6vFI
 kf/Nd14LVJwLLsY/Nm467iKBsxorKrYpTkDvZGWIELF6I5TAPOKwZq/5bs6TQRmO+0eY
 jFud/wBKlJ5YIWSFk3IaNIOjpXg43w3Dng5zzVa4dPZOduMcJmWnecLUe1KjHN7etgJj
 Xwb65oZyHg4+e7LB/vQNvGiT5bbHUp42EMjqeOi9ypmp1EhMaioI4qjQgpOEkI92ptP1 Aw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3304hhvsua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 20 Aug 2020 04:09:05 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 20 Aug
 2020 04:09:03 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 20 Aug 2020 04:09:03 -0700
Received: from NN-LT0065.marvell.com (NN-LT0065.marvell.com [10.193.54.69])
        by maili.marvell.com (Postfix) with ESMTP id 61C563F7043;
        Thu, 20 Aug 2020 04:09:02 -0700 (PDT)
From:   Dmitry Bogdanov <dbogdanov@marvell.com>
To:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>
CC:     Dmitry Bogdanov <dbogdanov@marvell.com>
Subject: [PATCH net 0/3] net: qed disable aRFS in NPAR and 100G
Date:   Thu, 20 Aug 2020 14:08:29 +0300
Message-ID: <cover.1597833340.git.dbogdanov@marvell.com>
X-Mailer: git-send-email 2.28.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-20_02:2020-08-19,2020-08-20 signatures=0
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

