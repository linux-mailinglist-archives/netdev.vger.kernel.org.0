Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE377396DA2
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 08:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233023AbhFAG7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 02:59:53 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2812 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232789AbhFAG7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 02:59:52 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FvNCr40L9zWqHQ;
        Tue,  1 Jun 2021 14:53:28 +0800 (CST)
Received: from dggpeml500023.china.huawei.com (7.185.36.114) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 1 Jun 2021 14:58:09 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 1 Jun 2021 14:58:09 +0800
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
To:     <netdev@vger.kernel.org>
CC:     Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Shahed Shaikh <shshaikh@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        <GR-Linux-NIC-Dev@marvell.com>
Subject: [PATCH] qlcnic: Remove the repeated declaration
Date:   Tue, 1 Jun 2021 14:57:58 +0800
Message-ID: <1622530678-12911-1-git-send-email-zhangshaokun@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function 'qlcnic_82xx_hw_write_wx_2M' is declared twice, so remove the
repeated declaration.

Cc: Shahed Shaikh <shshaikh@marvell.com>
Cc: Manish Chopra <manishc@marvell.com>
Cc: GR-Linux-NIC-Dev@marvell.com
Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.h b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.h
index 601d22495a88..95ecc84dddcd 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.h
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.h
@@ -203,7 +203,6 @@ int qlcnic_82xx_set_nic_info(struct qlcnic_adapter *, struct qlcnic_info *);
 int qlcnic_82xx_get_pci_info(struct qlcnic_adapter *, struct qlcnic_pci_info*);
 int qlcnic_82xx_alloc_mbx_args(struct qlcnic_cmd_args *,
 			       struct qlcnic_adapter *, u32);
-int qlcnic_82xx_hw_write_wx_2M(struct qlcnic_adapter *, ulong, u32);
 int qlcnic_82xx_get_board_info(struct qlcnic_adapter *);
 int qlcnic_82xx_config_led(struct qlcnic_adapter *, u32, u32);
 void qlcnic_82xx_get_func_no(struct qlcnic_adapter *);
-- 
2.7.4

