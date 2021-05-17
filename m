Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8226A3825FD
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 10:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235589AbhEQIAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 04:00:20 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:2994 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbhEQIAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 04:00:11 -0400
Received: from dggems703-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FkBKf0S8vzmWkH;
        Mon, 17 May 2021 15:56:38 +0800 (CST)
Received: from dggema704-chm.china.huawei.com (10.3.20.68) by
 dggems703-chm.china.huawei.com (10.3.19.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 17 May 2021 15:58:52 +0800
Received: from localhost.localdomain (10.67.165.2) by
 dggema704-chm.china.huawei.com (10.3.20.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 17 May 2021 15:58:52 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yang Shen <shenyang39@huawei.com>
Subject: [PATCH v2 00/24] Rid W=1 warnings in net
Date:   Mon, 17 May 2021 12:45:11 +0800
Message-ID: <20210517044535.21473-1-shenyang39@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.2]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggema704-chm.china.huawei.com (10.3.20.68)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is 1 of 2 sets to fully clean drivers/net.

Changes since v1:
 - add some warnings missed in v1
 - move the patches about drivers/net/wireless into another series

Yang Shen (24):
  net: arc: Demote non-compliant kernel-doc headers
  net: atheros: atl1c: Fix wrong function name in comments
  net: atheros: atl1e: Fix wrong function name in comments
  net: atheros: atl1x: Fix wrong function name in comments
  net: broadcom: bnx2x: Fix wrong function name in comments
  net: brocade: bna: Fix wrong function name in comments
  net: cadence: Demote non-compliant kernel-doc headers
  net: calxeda: Fix wrong function name in comments
  net: chelsio: cxgb3: Fix wrong function name in comments
  net: chelsio: cxgb4: Fix wrong function name in comments
  net: chelsio: cxgb4vf: Fix wrong function name in comments
  net: huawei: hinic: Fix wrong function name in comments
  net: micrel: Fix wrong function name in comments
  net: microchip: Demote non-compliant kernel-doc headers
  net: neterion: Fix wrong function name in comments
  net: neterion: vxge: Fix wrong function name in comments
  net: netronome: nfp: Fix wrong function name in comments
  net: calxeda: Fix wrong function name in comments
  net: samsung: sxgbe: Fix wrong function name in comments
  net: socionext: Demote non-compliant kernel-doc headers
  net: ti: Fix wrong struct name in comments
  net: via: Fix wrong function name in comments
  net: phy: Demote non-compliant kernel-doc headers
  net: hisilicon: hns: Fix wrong function name in comments

 drivers/net/ethernet/arc/emac_rockchip.c         |  2 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c  |  6 +++---
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c  |  4 ++--
 drivers/net/ethernet/atheros/atlx/atl1.c         |  2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c |  2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c   |  4 ++--
 drivers/net/ethernet/brocade/bna/bfa_cee.c       |  2 +-
 drivers/net/ethernet/cadence/macb_pci.c          |  2 +-
 drivers/net/ethernet/cadence/macb_ptp.c          |  2 +-
 drivers/net/ethernet/calxeda/xgmac.c             |  8 ++++----
 drivers/net/ethernet/chelsio/cxgb3/sge.c         |  4 ++--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c   |  2 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c       |  4 ++--
 drivers/net/ethernet/chelsio/cxgb4vf/sge.c       |  2 +-
 .../net/ethernet/hisilicon/hns/hns_dsaf_mac.c    |  6 +++---
 .../net/ethernet/hisilicon/hns/hns_dsaf_main.c   | 16 ++++++++--------
 .../net/ethernet/hisilicon/hns/hns_dsaf_misc.c   |  4 ++--
 .../net/ethernet/hisilicon/hns/hns_dsaf_ppe.c    |  8 ++++----
 .../net/ethernet/hisilicon/hns/hns_dsaf_rcb.c    |  2 +-
 .../net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c  |  4 ++--
 drivers/net/ethernet/hisilicon/hns/hns_enet.c    |  2 +-
 drivers/net/ethernet/hisilicon/hns/hns_ethtool.c |  6 +++---
 .../net/ethernet/huawei/hinic/hinic_hw_cmdq.c    |  2 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c |  8 ++++----
 drivers/net/ethernet/huawei/hinic/hinic_hw_if.c  |  2 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_qp.c  |  2 +-
 drivers/net/ethernet/huawei/hinic/hinic_main.c   |  4 ++--
 drivers/net/ethernet/huawei/hinic/hinic_tx.c     |  2 +-
 drivers/net/ethernet/micrel/ksz884x.c            |  6 +++---
 drivers/net/ethernet/microchip/encx24j600.c      |  2 +-
 drivers/net/ethernet/neterion/s2io.c             |  4 ++--
 drivers/net/ethernet/neterion/vxge/vxge-config.c |  2 +-
 drivers/net/ethernet/neterion/vxge/vxge-main.c   |  4 ++--
 drivers/net/ethernet/netronome/nfp/ccm_mbox.c    |  2 +-
 .../ethernet/netronome/nfp/flower/tunnel_conf.c  |  2 +-
 .../ethernet/netronome/nfp/nfpcore/nfp_nffw.c    |  2 +-
 .../ethernet/qlogic/qlcnic/qlcnic_83xx_init.c    |  2 +-
 .../ethernet/qlogic/qlcnic/qlcnic_83xx_vnic.c    |  2 +-
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c  |  4 ++--
 drivers/net/ethernet/socionext/sni_ave.c         |  2 +-
 drivers/net/ethernet/ti/cpsw_ale.c               |  2 +-
 drivers/net/ethernet/via/via-velocity.c          |  6 +++---
 drivers/net/phy/adin.c                           |  2 +-
 drivers/net/phy/rockchip.c                       |  2 +-
 44 files changed, 80 insertions(+), 80 deletions(-)

--
2.17.1

