Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A93D63817C8
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 12:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbhEOKzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 06:55:36 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2601 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbhEOKzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 06:55:35 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fj2JV1vcTzsR9G;
        Sat, 15 May 2021 18:51:38 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Sat, 15 May 2021 18:54:15 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yang Shen <shenyang39@huawei.com>
Subject: [PATCH 00/34] Rid W=1 warnings in net
Date:   Sat, 15 May 2021 18:53:25 +0800
Message-ID: <1621076039-53986-1-git-send-email-shenyang39@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a set to fully clean drivers/net.

Yang Shen (34):
  net: arc: Demote non-compliant kernel-doc headers
  net: atheros: atl1c: Fix wrong function name in comments
  net: atheros: atl1e: Fix wrong function name in comments
  net: atheros: atl1x: Fix wrong function name in comments
  net: broadcom: bnx2x: Fix wrong function name in comments
  net: brocade: bna: Fix wrong function name in comments
  net: cadence: macb_ptp: Demote non-compliant kernel-doc headers
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
  net: ath: ath5k: Fix wrong function name in comments
  net: ath: Fix wrong function name in comments
  net: ath: wil6210: Fix wrong function name in comments
  net: broadcom: brcmfmac: Demote non-compliant kernel-doc headers
  net: intel: ipw2x00: Fix wrong function name in comments
  net: intel: iwlwifi: Demote non-compliant kernel-doc headers
  net: marvell: libertas_tf: Fix wrong function name in comments
  net: realtek: rtlwifi: Fix wrong function name in comments
  net: rsi: Fix missing function name in comments
  net: ti: wl1251: Fix missing function name in comments
  net: ti: wlcore: Fix missing function name in comments

 drivers/net/ethernet/arc/emac_rockchip.c                | 2 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c         | 6 +++---
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c         | 4 ++--
 drivers/net/ethernet/atheros/atlx/atl1.c                | 2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c        | 2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c          | 4 ++--
 drivers/net/ethernet/brocade/bna/bfa_cee.c              | 2 +-
 drivers/net/ethernet/cadence/macb_ptp.c                 | 2 +-
 drivers/net/ethernet/calxeda/xgmac.c                    | 8 ++++----
 drivers/net/ethernet/chelsio/cxgb3/sge.c                | 4 ++--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c          | 2 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c              | 4 ++--
 drivers/net/ethernet/chelsio/cxgb4vf/sge.c              | 2 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c       | 2 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c        | 8 ++++----
 drivers/net/ethernet/huawei/hinic/hinic_hw_if.c         | 2 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_qp.c         | 2 +-
 drivers/net/ethernet/huawei/hinic/hinic_main.c          | 4 ++--
 drivers/net/ethernet/huawei/hinic/hinic_tx.c            | 2 +-
 drivers/net/ethernet/micrel/ksz884x.c                   | 6 +++---
 drivers/net/ethernet/microchip/encx24j600.c             | 2 +-
 drivers/net/ethernet/neterion/s2io.c                    | 4 ++--
 drivers/net/ethernet/neterion/vxge/vxge-config.c        | 2 +-
 drivers/net/ethernet/neterion/vxge/vxge-main.c          | 4 ++--
 drivers/net/ethernet/netronome/nfp/ccm_mbox.c           | 2 +-
 drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c | 2 +-
 drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nffw.c   | 2 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c   | 2 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_vnic.c   | 2 +-
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c         | 4 ++--
 drivers/net/ethernet/socionext/sni_ave.c                | 2 +-
 drivers/net/ethernet/ti/cpsw_ale.c                      | 2 +-
 drivers/net/ethernet/via/via-velocity.c                 | 6 +++---
 drivers/net/phy/adin.c                                  | 2 +-
 drivers/net/phy/rockchip.c                              | 2 +-
 drivers/net/wireless/ath/ath5k/pcu.c                    | 2 +-
 drivers/net/wireless/ath/hw.c                           | 2 +-
 drivers/net/wireless/ath/wil6210/interrupt.c            | 2 +-
 drivers/net/wireless/ath/wil6210/wmi.c                  | 6 +++---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c  | 2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 2 +-
 drivers/net/wireless/intel/ipw2x00/ipw2100.c            | 8 ++++----
 drivers/net/wireless/intel/iwlwifi/mvm/rfi.c            | 4 ++--
 drivers/net/wireless/marvell/libertas_tf/if_usb.c       | 2 +-
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c    | 4 ++--
 drivers/net/wireless/rsi/rsi_91x_mgmt.c                 | 4 ++--
 drivers/net/wireless/ti/wl1251/cmd.c                    | 8 ++++----
 drivers/net/wireless/ti/wlcore/cmd.c                    | 6 +++---
 48 files changed, 81 insertions(+), 81 deletions(-)

--
2.7.4

