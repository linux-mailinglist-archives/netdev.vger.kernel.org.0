Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 579BA726FE
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 06:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725894AbfGXEvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 00:51:50 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:14136 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725829AbfGXEvu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 00:51:50 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x6O4jqaa009510;
        Tue, 23 Jul 2019 21:51:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=vqD9Og6fCPsvfQpcXe2PNfBKHA9zmI0E/cNsjVJE9lU=;
 b=u4TiKkF5AU4hECw1rlktdJe9fGHSlsuXcJgTdQnnpJYmGKGH8Io72KB536nGNPMeBNAJ
 tUyOp7WbtnK6mzUPXnqIckVhbp+1b4bEkCCc4IDG25xUVCVKOaCvQ+PRcwvK/9H4Gp6w
 PIAEXniBdWDt5i7/WfAZ3AuM3KOQeZX4pBo70wH0bKhHVi3eqDLvQA71/fW1t9Wl/hBD
 Y2DfYjesay2pqMiTjnzNgVqUUfmmQtzIkWVe3An6EKkd+Y1nrgNMetxvhpRWxfK91Za3
 yjQeWBeVRAEgtJPHTz8smFBmjm09A5GFkOPYtPQEUo1wt78oys6vyxzx+yTP62uzlW31 xw== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2tx61rajh4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 23 Jul 2019 21:51:49 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Tue, 23 Jul
 2019 21:51:47 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Tue, 23 Jul 2019 21:51:47 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id AF9913F7040;
        Tue, 23 Jul 2019 21:51:47 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x6O4plJF027740;
        Tue, 23 Jul 2019 21:51:47 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x6O4plni027739;
        Tue, 23 Jul 2019 21:51:47 -0700
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <mkalderon@marvell.com>,
        <aelior@marvell.com>
Subject: [PATCH net-next 0/2] qed: Support for NVM config attributes.
Date:   Tue, 23 Jul 2019 21:51:39 -0700
Message-ID: <20190724045141.27703-1-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-07-24_01:2019-07-23,2019-07-24 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch series add support for managing the NVM config attributes.
Patch (1) adds interfaces for read/write config attributes from MFW.
Patch (2) adds driver interface for updating the config attributes.

Sudarsana Reddy Kalluru (2):
  qed: Add APIs for NVM config attributes.
  qed: Add API for flashing the nvm attributes.

 drivers/net/ethernet/qlogic/qed/qed_hsi.h  | 17 ++++++++
 drivers/net/ethernet/qlogic/qed/qed_main.c | 65 ++++++++++++++++++++++++++++++
 drivers/net/ethernet/qlogic/qed/qed_mcp.c  | 64 +++++++++++++++++++++++++++++
 drivers/net/ethernet/qlogic/qed/qed_mcp.h  | 14 +++++++
 include/linux/qed/qed_if.h                 |  1 +
 5 files changed, 161 insertions(+)

-- 
1.8.3.1

