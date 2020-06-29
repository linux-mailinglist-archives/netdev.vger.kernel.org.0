Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF4F20D42A
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 21:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730699AbgF2TFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:05:51 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:49226 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729572AbgF2TFu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:05:50 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05TB5JB6029710;
        Mon, 29 Jun 2020 04:05:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0818; bh=ZAYLZs15H//oqhindrqfDO/DX/wTlX9nwoHUcZqR8do=;
 b=uTh4MhMEMkWfoyuRZEpJf0SarGJSObDFvouFKsyjH/+03agC9DgRA9b9hcS1TRpul8HP
 bZoS4ag87O/KM+2on+8c4HQ5r6XzIc4ALRHYgG+sVfg2WuFaALb7pdVmHKy9t7RUFBK5
 v1m/Q+6h8OOn5vWChcqqIvZitcPbSDlvgw2M4NdGPW4CpBYmdhTR4MrzLSftf29A627j
 CbNx/HituEujiIjz0gH+97Rcwbr4fYhAnHQ/NfueJNrr3jlOfvzNhfuiiRqna9XrTSOz
 lYrQEx/+snhXymvox/TeJShZQXCiUwmfSfbBxYjiKTq/s9nB9+jotTpUQZTDjbQoZ3dQ Ug== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 31y0wrtfxa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 29 Jun 2020 04:05:48 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 29 Jun
 2020 04:05:47 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 29 Jun 2020 04:05:47 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id 8E4993F703F;
        Mon, 29 Jun 2020 04:05:44 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        "Alexander Lobakin" <alobakin@marvell.com>,
        <GR-everest-linux-l2@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 0/6] net: qed/qede: license cleanup
Date:   Mon, 29 Jun 2020 14:05:06 +0300
Message-ID: <20200629110512.1812-1-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-29_11:2020-06-29,2020-06-29 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QLogic QED drivers source code is dual licensed under
GPL-2.0/BSD-3-Clause.

Correct already existing but wrong SPDX tags to match the actual
license.
Remove the license boilerplates and replace them with the correct
SPDX tag.
Update copyright years in all source files.

Alexander Lobakin (6):
  net: qed: correct existing SPDX tags
  net: qed: convert to SPDX License Identifiers
  net: qed: update copyright years
  net: qede: correct existing SPDX tags
  net: qede: convert to SPDX License Identifiers
  net: qede: update copyright years

 drivers/net/ethernet/qlogic/qed/Makefile      |  4 ++-
 drivers/net/ethernet/qlogic/qed/qed.h         | 30 ++----------------
 drivers/net/ethernet/qlogic/qed/qed_cxt.c     | 30 ++----------------
 drivers/net/ethernet/qlogic/qed/qed_cxt.h     | 30 ++----------------
 drivers/net/ethernet/qlogic/qed/qed_dcbx.c    | 30 ++----------------
 drivers/net/ethernet/qlogic/qed/qed_dcbx.h    | 30 ++----------------
 drivers/net/ethernet/qlogic/qed/qed_debug.c   |  3 +-
 drivers/net/ethernet/qlogic/qed/qed_debug.h   |  3 +-
 drivers/net/ethernet/qlogic/qed/qed_dev.c     | 30 ++----------------
 drivers/net/ethernet/qlogic/qed/qed_dev_api.h | 30 ++----------------
 drivers/net/ethernet/qlogic/qed/qed_fcoe.c    | 30 ++----------------
 drivers/net/ethernet/qlogic/qed/qed_fcoe.h    | 30 ++----------------
 drivers/net/ethernet/qlogic/qed/qed_hsi.h     | 30 ++----------------
 drivers/net/ethernet/qlogic/qed/qed_hw.c      | 30 ++----------------
 drivers/net/ethernet/qlogic/qed/qed_hw.h      | 30 ++----------------
 .../ethernet/qlogic/qed/qed_init_fw_funcs.c   | 30 ++----------------
 .../net/ethernet/qlogic/qed/qed_init_ops.c    | 30 ++----------------
 .../net/ethernet/qlogic/qed/qed_init_ops.h    | 30 ++----------------
 drivers/net/ethernet/qlogic/qed/qed_int.c     | 30 ++----------------
 drivers/net/ethernet/qlogic/qed/qed_int.h     | 30 ++----------------
 drivers/net/ethernet/qlogic/qed/qed_iscsi.c   | 30 ++----------------
 drivers/net/ethernet/qlogic/qed/qed_iscsi.h   | 30 ++----------------
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c   | 31 ++-----------------
 drivers/net/ethernet/qlogic/qed/qed_iwarp.h   | 31 ++-----------------
 drivers/net/ethernet/qlogic/qed/qed_l2.c      | 30 ++----------------
 drivers/net/ethernet/qlogic/qed/qed_l2.h      | 31 ++-----------------
 drivers/net/ethernet/qlogic/qed/qed_ll2.c     | 30 ++----------------
 drivers/net/ethernet/qlogic/qed/qed_ll2.h     | 30 ++----------------
 drivers/net/ethernet/qlogic/qed/qed_main.c    | 30 ++----------------
 drivers/net/ethernet/qlogic/qed/qed_mcp.c     | 30 ++----------------
 drivers/net/ethernet/qlogic/qed/qed_mcp.h     | 30 ++----------------
 drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c |  4 ++-
 drivers/net/ethernet/qlogic/qed/qed_ooo.c     | 30 ++----------------
 drivers/net/ethernet/qlogic/qed/qed_ooo.h     | 30 ++----------------
 drivers/net/ethernet/qlogic/qed/qed_ptp.c     | 31 ++-----------------
 drivers/net/ethernet/qlogic/qed/qed_rdma.c    | 31 ++-----------------
 drivers/net/ethernet/qlogic/qed/qed_rdma.h    | 31 ++-----------------
 .../net/ethernet/qlogic/qed/qed_reg_addr.h    | 30 ++----------------
 drivers/net/ethernet/qlogic/qed/qed_roce.c    | 31 ++-----------------
 drivers/net/ethernet/qlogic/qed/qed_roce.h    | 31 ++-----------------
 .../net/ethernet/qlogic/qed/qed_selftest.c    | 30 ++----------------
 .../net/ethernet/qlogic/qed/qed_selftest.h    |  4 ++-
 drivers/net/ethernet/qlogic/qed/qed_sp.h      | 30 ++----------------
 .../net/ethernet/qlogic/qed/qed_sp_commands.c | 30 ++----------------
 drivers/net/ethernet/qlogic/qed/qed_spq.c     | 30 ++----------------
 drivers/net/ethernet/qlogic/qed/qed_sriov.c   | 30 ++----------------
 drivers/net/ethernet/qlogic/qed/qed_sriov.h   | 30 ++----------------
 drivers/net/ethernet/qlogic/qed/qed_vf.c      | 30 ++----------------
 drivers/net/ethernet/qlogic/qed/qed_vf.h      | 29 +----------------
 drivers/net/ethernet/qlogic/qede/Makefile     |  4 ++-
 drivers/net/ethernet/qlogic/qede/qede.h       | 31 ++-----------------
 drivers/net/ethernet/qlogic/qede/qede_dcbnl.c |  7 +++--
 .../net/ethernet/qlogic/qede/qede_ethtool.c   | 31 ++-----------------
 .../net/ethernet/qlogic/qede/qede_filter.c    | 31 ++-----------------
 drivers/net/ethernet/qlogic/qede/qede_fp.c    | 31 ++-----------------
 drivers/net/ethernet/qlogic/qede/qede_main.c  | 31 ++-----------------
 drivers/net/ethernet/qlogic/qede/qede_ptp.c   | 31 ++-----------------
 drivers/net/ethernet/qlogic/qede/qede_ptp.h   | 31 ++-----------------
 drivers/net/ethernet/qlogic/qede/qede_rdma.c  | 31 ++-----------------
 include/linux/qed/common_hsi.h                | 30 ++----------------
 include/linux/qed/eth_common.h                | 30 ++----------------
 include/linux/qed/fcoe_common.h               |  3 +-
 include/linux/qed/iscsi_common.h              | 30 ++----------------
 include/linux/qed/iwarp_common.h              | 30 ++----------------
 include/linux/qed/qed_chain.h                 | 30 ++----------------
 include/linux/qed/qed_eth_if.h                | 30 ++----------------
 include/linux/qed/qed_fcoe_if.h               |  4 ++-
 include/linux/qed/qed_if.h                    | 30 ++----------------
 include/linux/qed/qed_iov_if.h                | 30 ++----------------
 include/linux/qed/qed_iscsi_if.h              | 30 ++----------------
 include/linux/qed/qed_ll2_if.h                | 30 ++----------------
 include/linux/qed/qed_rdma_if.h               | 31 ++-----------------
 include/linux/qed/qede_rdma.h                 | 31 ++-----------------
 include/linux/qed/rdma_common.h               | 30 ++----------------
 include/linux/qed/roce_common.h               | 30 ++----------------
 include/linux/qed/storage_common.h            | 30 ++----------------
 include/linux/qed/tcp_common.h                | 30 ++----------------
 77 files changed, 178 insertions(+), 1915 deletions(-)

-- 
2.25.1

