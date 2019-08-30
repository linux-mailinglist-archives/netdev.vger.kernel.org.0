Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECCB8A3156
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 09:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727525AbfH3HmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 03:42:21 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:21328 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726655AbfH3HmU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 03:42:20 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7U7dltv026578;
        Fri, 30 Aug 2019 00:42:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=end73pYrocBw6MGspIkHUHGnEK28lKThufnWiPDImyg=;
 b=bBbgRz22UomgeGOjJbV3yHF50GLYon79ChR+3HduDXwb99GTOCER6pfpztvHU2btWYz9
 5ob7IH37u1Sd6HKiYwFdk2Yh37PThToFFYYf+GA4iE1SozSaZXPw6vlgBe4cZyiacSJ4
 vV0jwDsaR2s0vbdM2TeXeh54yOQ/wg1pIyfUGmOvsQnqI85qSBSP60wwYU0eoepafMdG
 RvZUuPCjJSarEB1aKbdgf2RrkD5rcg8sqW2druwQITgGAwogNUQsaJINUkqyHJvfHZXd
 d8Y65sKDj3XIFbnPfsuVqgCpHwwE1HsMsV8U6T1di+kVJ6IN2DNDuEN2m6irzUNH+ZMM Gg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2upmepjc1f-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 30 Aug 2019 00:42:19 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 30 Aug
 2019 00:42:17 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Fri, 30 Aug 2019 00:42:17 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 11B2D3F7048;
        Fri, 30 Aug 2019 00:42:17 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x7U7gGtx008876;
        Fri, 30 Aug 2019 00:42:16 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x7U7gGF5008875;
        Fri, 30 Aug 2019 00:42:16 -0700
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <mkalderon@marvell.com>,
        <aelior@marvell.com>
Subject: [PATCH net-next 0/4] qed*: Enhancements.
Date:   Fri, 30 Aug 2019 00:42:02 -0700
Message-ID: <20190830074206.8836-1-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-30_03:2019-08-29,2019-08-30 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch series adds couple of enhancements to qed/qede drivers.
  - Support for dumping the config id attributes via ethtool -w/W.
  - Support for dumping the GRC data of required memory regions using
    ethtool -w/W interfaces.

Patch (1) adds driver APIs for reading the config id attributes.
Patch (2) adds ethtool support for dumping the config id attributes.
Patch (3) adds support for configuring the GRC dump config flags.
Patch (4) adds ethtool support for dumping the grc dump.

Please consider applying it to net-next.

Sudarsana Reddy Kalluru (4):
  qed: Add APIs for reading config id attributes.
  qede: Add support for reading the config id attributes.
  qed: Add APIs for configuring grc dump config flags.
  qede: Add support for dumping the grc data.

 drivers/net/ethernet/qlogic/qed/qed_debug.c     |  82 +++++++++++++++++
 drivers/net/ethernet/qlogic/qed/qed_hsi.h       |  15 ++++
 drivers/net/ethernet/qlogic/qed/qed_main.c      |  48 ++++++++++
 drivers/net/ethernet/qlogic/qed/qed_mcp.c       |  29 ++++++
 drivers/net/ethernet/qlogic/qed/qed_mcp.h       |  15 ++++
 drivers/net/ethernet/qlogic/qede/qede.h         |  15 ++++
 drivers/net/ethernet/qlogic/qede/qede_ethtool.c | 114 ++++++++++++++++++++++++
 include/linux/qed/qed_if.h                      |  20 +++++
 8 files changed, 338 insertions(+)

-- 
1.8.3.1

