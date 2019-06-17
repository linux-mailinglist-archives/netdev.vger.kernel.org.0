Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6DD4812C
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 13:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbfFQLqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 07:46:01 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:41000 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725763AbfFQLqB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 07:46:01 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5HBhGie030792;
        Mon, 17 Jun 2019 04:45:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=nrVsJjZZ6QyUTErjs36qRTr4AaR6lIcrVHScaOudV2A=;
 b=AJl8fAN6FQNE51NUn4Yg4FpXojfFvhHIz+ed2LS9S/xuwsaCXaTthQIvRmZBt2tdkjsO
 n3Ku0gGOOoX2gVR0q/TCR0enBmXuBq5Y/2oAHAwI9+ZwsCIEF7hJ0Laup0UMM1TsUDo3
 0ZU5+kpeKsiSOVU0E7NjfGZr2x+H7XffGQ/tMI2YYi6pvGEj/Ft6EMWoMsSvqHoc7/yP
 caOwFn0aSaqVAnqbcCNU4ZJLaR9JSQBwDjGNsYtcvL/BJFsJY5oSVlg6dmNCSQVzANrf
 bNVThJZYfpUmtldQBPvGeIURYrchxrghsMkE0KZtaCeLR37zPJzDQA8ha9V42qYc5a/Y Og== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2t506hxdqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 17 Jun 2019 04:45:58 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Mon, 17 Jun
 2019 04:45:56 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Mon, 17 Jun 2019 04:45:56 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 0672F3F703F;
        Mon, 17 Jun 2019 04:45:56 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x5HBjtC4017131;
        Mon, 17 Jun 2019 04:45:55 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x5HBjtbj017130;
        Mon, 17 Jun 2019 04:45:55 -0700
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <mkalderon@marvell.com>,
        <aelior@marvell.com>
Subject: [PATCH net-next 0/4] qed: Devlink support for config attributes management.
Date:   Mon, 17 Jun 2019 04:45:24 -0700
Message-ID: <20190617114528.17086-1-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-17_06:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch series adds support for managing the config attributes using
devlink interfaces.

Please consider applying it to 'net-next' tree.

Sudarsana Reddy Kalluru (4):
  qed: Add APIs for device attributes configuration.
  qed: Perform devlink registration after the hardware init.
  qed: Add new file for devlink implementation.
  qed: Add devlink support for configuration attributes.

 drivers/net/ethernet/qlogic/qed/Makefile      |   3 +-
 drivers/net/ethernet/qlogic/qed/qed.h         |   1 +
 drivers/net/ethernet/qlogic/qed/qed_devlink.c | 281 ++++++++++++++++++++++++++
 drivers/net/ethernet/qlogic/qed/qed_devlink.h |  41 ++++
 drivers/net/ethernet/qlogic/qed/qed_hsi.h     |  31 +++
 drivers/net/ethernet/qlogic/qed/qed_main.c    | 118 +----------
 drivers/net/ethernet/qlogic/qed/qed_mcp.c     |  64 ++++++
 drivers/net/ethernet/qlogic/qed/qed_mcp.h     |  14 ++
 8 files changed, 444 insertions(+), 109 deletions(-)
 create mode 100644 drivers/net/ethernet/qlogic/qed/qed_devlink.c
 create mode 100644 drivers/net/ethernet/qlogic/qed/qed_devlink.h

-- 
1.8.3.1

