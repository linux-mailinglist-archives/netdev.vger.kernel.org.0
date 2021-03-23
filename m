Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B33FC3458EE
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 08:42:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbhCWHla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 03:41:30 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14005 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbhCWHk7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 03:40:59 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F4NXg327hzrWxx;
        Tue, 23 Mar 2021 15:38:59 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Tue, 23 Mar 2021 15:40:49 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 0/8] net: hns: add some cleanups
Date:   Tue, 23 Mar 2021 15:41:01 +0800
Message-ID: <1616485269-57044-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series includes some cleanups for the HNS ethernet driver.

Huazhong Tan (6):
  net: hns: remove unused get_autoneg()
  net: hns: remove unused set_autoneg()
  net: hns: remove unused set_rx_ignore_pause_frames()
  net: hns: remove unused config_half_duplex()
  net: hns: remove unused NIC_LB_TEST_RX_PKG_ERR
  net: hns: remove unused HNS_LED_PC_REG

Yonglong Liu (2):
  net: hns: remove unnecessary !! operation in
    hns_mac_config_sds_loopback_acpi()
  net: hns: remove redundant variable initialization

 drivers/net/ethernet/hisilicon/hns/hnae.h          |  6 ------
 drivers/net/ethernet/hisilicon/hns/hns_ae_adapt.c  | 22 +---------------------
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_gmac.c | 18 ------------------
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c  |  2 +-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.h  |  4 ----
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c | 16 ++++++++--------
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c |  2 +-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_rcb.c  |  4 ++--
 .../net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c    | 18 +-----------------
 drivers/net/ethernet/hisilicon/hns/hns_enet.c      |  4 ++--
 drivers/net/ethernet/hisilicon/hns/hns_ethtool.c   |  3 +--
 drivers/net/ethernet/hisilicon/hns_mdio.c          |  4 ++--
 12 files changed, 19 insertions(+), 84 deletions(-)

-- 
2.7.4

